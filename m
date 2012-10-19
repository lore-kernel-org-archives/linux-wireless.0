Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:61075 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752177Ab2JSFVM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Oct 2012 01:21:12 -0400
Received: by mail-oa0-f46.google.com with SMTP id h16so84178oag.19
        for <linux-wireless@vger.kernel.org>; Thu, 18 Oct 2012 22:21:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <loom.20121018T003841-742@post.gmane.org>
References: <1311771665-59853-1-git-send-email-nbd@openwrt.org>
	<1311771665-59853-2-git-send-email-nbd@openwrt.org>
	<1311771665-59853-3-git-send-email-nbd@openwrt.org>
	<1311771665-59853-4-git-send-email-nbd@openwrt.org>
	<loom.20121018T003841-742@post.gmane.org>
Date: Fri, 19 Oct 2012 10:51:10 +0530
Message-ID: <CAD2nsn2T-GhRwJAAEgpyQTSJLNV1m-ZYC+A3L78GfEpt=ATw_g@mail.gmail.com> (sfid-20121019_072116_061794_05034CB7)
Subject: Re: [PATCH 4/4] ath9k_hw: do not limit initial tx power to 20 dbm
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: =?ISO-8859-1?Q?Ambrus_Ol=E1h?= <aolah76@freemail.hu>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 18, 2012 at 4:14 AM, Ambrus Oláh <aolah76@freemail.hu> wrote:
> Felix Fietkau <nbd@...> writes:
>
>>
>> When testing for tx power, bypass the default limits.
>>
>> Signed-off-by: Felix Fietkau <nbd@...>
>> ---
>>  drivers/net/wireless/ath/ath9k/hw.c |    9 ++++++---
>>  1 files changed, 6 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath9k/hw.c
> b/drivers/net/wireless/ath/ath9k/hw.c
>> index 8006ce0..a2e5763 100644
>> --- a/drivers/net/wireless/ath/ath9k/hw.c
>> +++ b/drivers/net/wireless/ath/ath9k/hw.c
>> @@ -2432,15 +2432,18 @@ void ath9k_hw_set_txpowerlimit(struct ath_hw *ah, u32
> limit, bool test)
>>       struct ath_regulatory *regulatory = ath9k_hw_regulatory(ah);
>>       struct ath9k_channel *chan = ah->curchan;
>>       struct ieee80211_channel *channel = chan->chan;
>> +     int reg_pwr = min_t(int, MAX_RATE_POWER, regulatory->power_limit);
>> +     int chan_pwr = channel->max_power * 2;
>> +
>> +     if (test)
>> +             reg_pwr = chan_pwr = MAX_RATE_POWER;
>>
>>       regulatory->power_limit = min(limit, (u32) MAX_RATE_POWER);
>>
>>       ah->eep_ops->set_txpower(ah, chan,
>>                                ath9k_regd_get_ctl(regulatory, chan),
>>                                channel->max_antenna_gain * 2,
>> -                              channel->max_power * 2,
>> -                              min((u32) MAX_RATE_POWER,
>> -                              (u32) regulatory->power_limit), test);
>> +                              chan_pwr, reg_pwr, test);
>>  }
>>  EXPORT_SYMBOL(ath9k_hw_set_txpowerlimit);
>>
>
>
> Dear Mr. Fietkau,
>
> I have tried to apply your patch on
> http://www.orbit-lab.org/kernel/compat-wireless-3-stable/v3.3/compat-wireless-3.3-2-n.tar.bz2
>
> I get the following error:
>
> patch -p1 < ath9k_txpower.patch
> patching file drivers/net/wireless/ath/ath9k/hw.c
> Hunk #1 FAILED at 2432.
> patch unexpectedly ends in middle of line
> 1 out of 1 hunk FAILED -- saving rejects to file
> drivers/net/wireless/ath/ath9k/hw.c.rej
> patch unexpectedly ends in middle of line
>
> Could you support me with a patch tuned to the above compat-wireless?

try applying over the latest
http://linuxwireless.org/download/compat-wireless-2.6/compat-wireless-2012-10-03.tar.bz2

ideally these patches are based on wireless-testing tree and you goto apply
into it, and do kerenel/module compilation.

http://wireless.kernel.org/en/developers/Documentation/git-guide#Cloning_latest_wireless-testing


>
> Yours sincerelly,
>
> Ambrus Oláh
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
thanks,
shafi
