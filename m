Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:40279 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932117Ab3CDUEa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Mar 2013 15:04:30 -0500
Received: by mail-wg0-f47.google.com with SMTP id dr13so4409297wgb.2
        for <linux-wireless@vger.kernel.org>; Mon, 04 Mar 2013 12:04:29 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1362409848.21028.16.camel@jlt4.sipsolutions.net>
References: <1362204172-28307-1-git-send-email-thomas@cozybit.com>
 <1362204172-28307-4-git-send-email-thomas@cozybit.com> <1362409848.21028.16.camel@jlt4.sipsolutions.net>
From: Thomas Pedersen <thomas@cozybit.com>
Date: Mon, 4 Mar 2013 12:04:09 -0800
Message-ID: <CAG6hwVPGJk4CGcibimaSB5ADjcUmyhzNkF4JW4eveBDZma+SnA@mail.gmail.com> (sfid-20130304_210434_222097_64C33C95)
Subject: Re: [PATCH 4/6] nl80211: user_mpm overrides auto_open_plinks
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 4, 2013 at 7:10 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Fri, 2013-03-01 at 22:02 -0800, Thomas Pedersen wrote:
>> If the user requested a userspace MPM, automatically
>> disable auto_open_plinks to fully disable the kernel MPM.
>>
>> Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
>> ---
>>  include/uapi/linux/nl80211.h |    6 ++++--
>>  net/wireless/nl80211.c       |    3 +++
>>  2 files changed, 7 insertions(+), 2 deletions(-)
>>
>> diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
>> index 8134c6a..79da871 100644
>> --- a/include/uapi/linux/nl80211.h
>> +++ b/include/uapi/linux/nl80211.h
>> @@ -2467,8 +2467,10 @@ enum nl80211_mesh_power_mode {
>>   * @NL80211_MESHCONF_TTL: specifies the value of TTL field set at a source mesh
>>   *   point.
>>   *
>> - * @NL80211_MESHCONF_AUTO_OPEN_PLINKS: whether we should automatically
>> - *   open peer links when we detect compatible mesh peers.
>> + * @NL80211_MESHCONF_AUTO_OPEN_PLINKS: whether we should automatically open
>> + *   peer links when we detect compatible mesh peers. Disabled if
>> + *   @NL80211_MESH_SETUP_USERSPACE_MPM or @NL80211_MESH_SETUP_USERSPACE_AMPE are
>> + *   set.
>>   *
>>   * @NL80211_MESHCONF_HWMP_MAX_PREQ_RETRIES: the number of action frames
>>   *   containing a PREQ that an MP can send to a particular destination (path
>> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
>> index e3f2489..bd73231 100644
>> --- a/net/wireless/nl80211.c
>> +++ b/net/wireless/nl80211.c
>> @@ -7422,6 +7422,9 @@ static int nl80211_join_mesh(struct sk_buff *skb, struct genl_info *info)
>>                       return err;
>>       }
>>
>> +     if (setup.user_mpm)
>> +             cfg.auto_open_plinks = false;
>
> Maybe you should reject the invalid configuration instead?

But then if the user wants "userspace MPM" they have to select that
and disable auto_open_plinks as well. I think if the user wants his
own MPM, the kernel should be smart enough to completely disable its
own.

-- 
Thomas
