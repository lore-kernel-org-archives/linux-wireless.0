Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:48029 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754053Ab0EYTXQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 May 2010 15:23:16 -0400
Received: by pxi18 with SMTP id 18so2118056pxi.19
        for <linux-wireless@vger.kernel.org>; Tue, 25 May 2010 12:23:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTinMo6L_LuCgcu9izxUVsFbi7kamHD2F_xThwJ2R@mail.gmail.com>
References: <1274770211-22710-1-git-send-email-juuso.oikarinen@nokia.com>
	<1274770211-22710-2-git-send-email-juuso.oikarinen@nokia.com>
	<AANLkTinMo6L_LuCgcu9izxUVsFbi7kamHD2F_xThwJ2R@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 25 May 2010 12:22:56 -0700
Message-ID: <AANLkTikFo-MHuryI_y8Y_WHgzvK5PxQhWoLURf9rs_6s@mail.gmail.com>
Subject: Re: [PATCH] cfg80211: Fix user-space crda query stall
To: Juuso Oikarinen <juuso.oikarinen@nokia.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 25, 2010 at 12:02 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> On Mon, May 24, 2010 at 11:50 PM, Juuso Oikarinen
> <juuso.oikarinen@nokia.com> wrote:
>> The userspace crda utility can fail to respond to kernel requests in (at least)
>> two scenarios: it is not runnable for any reason, or it is invoked with a
>> country code not in its database.
>>
>> When the userspace crda utility fails to respond to kernel requests (i.e. it
>> does not use NL80211_CMD_SET_REG to provide the kernel regulatory information
>> for the requested country) the kernel crda subsystem will stall. It will
>> refuse to process any further regulatory hints. This is easiest demonstrated
>> by using for instance the "iw" tool:
>>
>>   iw reg set EU
>>   iw reg set US
>>
>> "EU" is not a country code present in the database, so user space crda will
>> not respond. Attempting to define US after that will be silently ignored
>> (internally, an -EAGAIN is the result, as the "EU" request is still
>> "being processed".)
>>
>> To fix this issue, this patch implements timeout protection for the userspace
>> crda invocation. If there is no response for five seconds, the crda code will
>> force itself to the world regulatory domain for maximum safety.
>>
>> Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
>
> This is a great idea, I really like it and appreciate you taking the
> time to work on this, however to do this it requires a little more
> work and will point out the notes below. So NACK for now but with some
> fixes I think this would be great.
>
>> ---
>>  net/wireless/reg.c |   44 ++++++++++++++++++++++++++++++++++++++++++++
>>  1 files changed, 44 insertions(+), 0 deletions(-)
>>
>> diff --git a/net/wireless/reg.c b/net/wireless/reg.c
>> index 8f0d97d..6c945f0 100644
>> --- a/net/wireless/reg.c
>> +++ b/net/wireless/reg.c
>> @@ -385,6 +385,40 @@ static inline void reg_regdb_query(const char *alpha2) {}
>>  #endif /* CONFIG_CFG80211_INTERNAL_REGDB */
>>
>>  /*
>> + * This gets invoked if crda in userspace is not responding (it's not getting
>> + * executed or the country code in the hint is not in the database.
>> + */
>> +
>> +static void call_crda_timeout_work(struct work_struct *work)
>> +{
>> +       if (!last_request)
>> +               return;
>> +
>> +       printk(KERN_INFO "cfg80211: crda request timed out, reverting to 00\n");
>> +
>> +       mutex_lock(&cfg80211_mutex);
>> +
>> +       /*
>> +        * As we are not getting data for the current country, force us back
>> +        * to the world regdomain.
>> +        */
>> +       last_request->alpha2[0] = '0';
>> +       last_request->alpha2[1] = '0';
>> +       set_regdom(cfg80211_world_regdom);
>> +       mutex_unlock(&cfg80211_mutex);
>> +}
>
>
> Actually you may want to consider using restore_regulatory_settings()
> instead as that would:
>
>  * set the world regdom
>  * then set the first user specified regulatory domain if they had one picked
>
> This would mean we would go into a loop here though if the user had
> specified 'EU' though so this routine first needs to be fixed to
> annotate a regulatory domain as invalid. Note that a regulatory cannot
> be invalid if CRDA just times out -- CRDA could time out if it was not
> present. So this is a bit tricky and not sure how to resolve it. John
> recently added support for building the regulatory database as part of
> the kernel but at the same time support letting CRDA still update the
> same info if it is present. Then for those setup it could be possible
> 'DE' exists on the core kernel regulatory database but if CRDA is not
> installed then CRDA will time out.
>
> Maybe what we can do is if both the internal kernel regdb *and* CRDA
> times out then mark the user specified request as invalid and restore
> to using the world regdom. This would allow the user to later install
> a CRDA with some newer regdb in userspace, for example. This allows
> for upgrading the db itself from userspace without making kernel
> changes. It allows for countries to be created.

We would also need to handle the case the user is already associated,
what do we do, do we disassociate? Maybe the right fix is to allow
user settings of the regulatory domain only if we are not associated.
Because otherwise we get into issues like what if the user was in 'IT'
but then chooses to be in 'EU' which is invalid, do we invalidate
their current settings / modes of operation / etc.

We already keep track of when we disassociate, but we do not sent an
event back to reg.c when we do, perhaps we need a counter for such
things on reg.c and only allow a user set regulatory domain if the
count is 0. Perhaps Johannes might have other better ideas how to do
this.

  Luis
