Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:36262 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507AbYLAUap (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Dec 2008 15:30:45 -0500
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFC v3 4/4] mac80211: move dynamic_ps_timeout to hw.conf
References: <1227901784-5325-1-git-send-email-kalle.valo@nokia.com>
	<1227901784-5325-5-git-send-email-kalle.valo@nokia.com>
	<43e72e890812011111h53553a18x2d17c9cf267331dd@mail.gmail.com>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Mon, 01 Dec 2008 22:30:37 +0200
In-Reply-To: <43e72e890812011111h53553a18x2d17c9cf267331dd@mail.gmail.com> (ext Luis R. Rodriguez's message of "Mon\, 1 Dec 2008 11\:11\:48 -0800")
Message-ID: <87hc5nbpua.fsf@nokia.com> (sfid-20081201_213049_564735_9CB91ECB)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez <mcgrof@gmail.com> writes:

> On Fri, Nov 28, 2008 at 11:49 AM, Kalle Valo <kalle.valo@nokia.com> wrote:
>
>> diff --git a/net/mac80211/wext.c b/net/mac80211/wext.c
>> index b3ee0dc..95455d0 100644
>> --- a/net/mac80211/wext.c
>> +++ b/net/mac80211/wext.c
>> @@ -962,7 +962,7 @@ static int ieee80211_ioctl_siwpower(struct net_device *dev,
>>
>>        if (wrq->disabled) {
>>                ps = false;
>> -               local->dynamic_ps_timeout = 0;
>> +               local->hw.conf.dynamic_ps_timeout = 0;
>>                goto set;
>>        }
>>
>> @@ -977,7 +977,7 @@ static int ieee80211_ioctl_siwpower(struct net_device *dev,
>>        }
>>
>>        if (wrq->flags & IW_POWER_TIMEOUT)
>> -               local->dynamic_ps_timeout = wrq->value / 1000;
>> +               local->hw.conf.dynamic_ps_timeout = wrq->value / 1000;
>>
>>        if (ps == local->powersave)
>>                return ret;
>> @@ -986,9 +986,9 @@ set:
>>        local->powersave = ps;
>>
>>        if (ifsta->flags & IEEE80211_STA_ASSOCIATED) {
>> -               if (local->dynamic_ps_timeout > 0)
>> +               if (conf->dynamic_ps_timeout > 0)
>>                        mod_timer(&local->dynamic_ps_timer, jiffies +
>> -                                 msecs_to_jiffies(local->dynamic_ps_timeout));
>> +                                 msecs_to_jiffies(conf->dynamic_ps_timeout));
>>                else {
>>                        if (local->powersave)
>>                                conf->flags |= IEEE80211_CONF_PS;
>
> Would it be too much trouble to add this via cfg80211/nl80211 instead
> or at least add both? The more we can push in that direction the
> better.

I definitely would like to see nl80211 support for power save. For
example, I think currently there's no way for the user space to know
dtim period of the bss. (If I'm wrong here, please let me know). We
definitely should fix that in nl80211 to make it easier for the user
space decide on correct power save settings.

Let's start to work on nl80211 after client power save features in
mac80211 are in better shape. At that time we also have a better
understanding of what's needed for the user space interface. Now
things are a bit sketchy still.

-- 
Kalle Valo
