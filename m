Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f53.google.com ([209.85.216.53]:38733 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753960Ab1K1UHx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Nov 2011 15:07:53 -0500
MIME-Version: 1.0
In-Reply-To: <201111252059.44293.tlnd@online.de>
References: <1322060687-6512-1-git-send-email-mcgrof@qca.qualcomm.com>
 <1322060687-6512-2-git-send-email-mcgrof@qca.qualcomm.com> <201111252059.44293.tlnd@online.de>
From: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Date: Mon, 28 Nov 2011 15:07:31 -0500
Message-ID: <CAB=NE6VFaiVS-iugG+vA6KKF6hPOAybJFdxV=L+b6Yt-9WcR2g@mail.gmail.com> (sfid-20111128_210757_173380_FB1151EB)
Subject: Re: [RFC 1/2] cfg80211: fix race on init and driver registration
To: Timo Lindhorst <tlnd@online.de>
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org, stable@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 25, 2011 at 2:59 PM, Timo Lindhorst <tlnd@online.de> wrote:
> Am Mittwoch, 23. November 2011, 16:04:46 schrieb Luis R. Rodriguez:
>> There is a theoretical race that if hit will trigger
>> a crash. The race is between when we issue the first
>> regulatory hint, regulatory_hint_core(), gets processed
>> by the workqueue and between when the first device
>> gets registered to the wireless core. This is not easy
>> to reproduce but it was easy to do so through the
>> regulatory simulator I have been working on. This
>> is a port of the fix I implemented there [1].
>>
>> [1]
>> https://github.com/mcgrof/regsim/commit/a246ccf81f059cb662eee288aa13100f63
>> 1e4cc8
>>
>> Cc: stable@vger.kernel.org
>> Cc: Johannes Berg <johannes.berg@intel.com>
>> Signed-off-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
>> ---
>>  net/wireless/reg.c |   28 ++++++++++++++++++++--------
>>  1 files changed, 20 insertions(+), 8 deletions(-)
>>
>> diff --git a/net/wireless/reg.c b/net/wireless/reg.c
>> index 76b35df..df73b96 100644
>> --- a/net/wireless/reg.c
>> +++ b/net/wireless/reg.c
>> @@ -57,8 +57,17 @@
>>  #define REG_DBG_PRINT(args...)
>>  #endif
>>
>> +static struct regulatory_request core_request_world = {
>> +     .initiator = NL80211_REGDOM_SET_BY_CORE,
>> +     .alpha2[0] = '0',
>> +     .alpha2[1] = '0',
>> +     .intersect = false,
>> +     .processed = true,
>> +     .country_ie_env = ENVIRON_ANY,
>> +};
>> +
>>  /* Receipt of information from last regulatory request */
>> -static struct regulatory_request *last_request;
>> +static struct regulatory_request *last_request = &core_request_world;
>>
>>  /* To trigger userspace events */
>>  static struct platform_device *reg_pdev;
>> @@ -165,6 +174,10 @@ static void reset_regdomains(void)
>>
>>       cfg80211_world_regdom = &world_regdom;
>>       cfg80211_regdomain = NULL;
>> +
>> +     if (last_request != &core_request_world)
>> +             kfree(last_request);
>> +     last_request = &core_request_world;
>>  }
> This breaks setting the regdom correctly! reset_regdomains() is called from
> within set_regdom() (i.e. via __set_regdom()), however, the subsequent
> functions called within set_regdom() expect last_request to still hold the
> currently processed request:
>
>        update_all_wiphy_regulatory(last_request->initiator);
>        print_regdomain(cfg80211_regdomain);
>        nl80211_send_reg_change_event(last_request);
>        reg_set_request_processed();
>
> This, for instance, prevents to set the regdom from userspace -- or precisely:
> the regdom is set, but the reg_timeout worker restores the settings after the
> timeout, which is not canceled as intended within reg_set_request_processed(),
> since last_request->initiator is not NL80211_REGDOM_SET_BY_USER anymore as
> last_request was reset to &core_request_world.

Thanks for testing, I really didn't have time. So I'll fix this by
passing a flag to reset_regdomains()s. I see the issue you pointed
out. I'll test this time before sending my new series.

  Luis
