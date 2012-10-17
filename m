Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:58411 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755050Ab2JRUKB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Oct 2012 16:10:01 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1TOwPs-00074o-1G
	for linux-wireless@vger.kernel.org; Thu, 18 Oct 2012 22:10:04 +0200
Received: from catv-176-63-153-121.catv.broadband.hu ([176.63.153.121])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 18 Oct 2012 22:10:04 +0200
Received: from aolah76 by catv-176-63-153-121.catv.broadband.hu with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 18 Oct 2012 22:10:04 +0200
To: linux-wireless@vger.kernel.org
From: Ambrus =?utf-8?b?T2zDoWg=?= <aolah76@freemail.hu>
Subject: Re: [PATCH 4/4] =?utf-8?b?YXRoOWtfaHc6?= do not limit initial tx power to 20 dbm
Date: Wed, 17 Oct 2012 22:44:58 +0000 (UTC)
Message-ID: <loom.20121018T003841-742@post.gmane.org> (sfid-20121018_221008_918878_7A015F39)
References: <1311771665-59853-1-git-send-email-nbd@openwrt.org> <1311771665-59853-2-git-send-email-nbd@openwrt.org> <1311771665-59853-3-git-send-email-nbd@openwrt.org> <1311771665-59853-4-git-send-email-nbd@openwrt.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau <nbd@...> writes:

> 
> When testing for tx power, bypass the default limits.
> 
> Signed-off-by: Felix Fietkau <nbd@...>
> ---
>  drivers/net/wireless/ath/ath9k/hw.c |    9 ++++++---
>  1 files changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/hw.c
b/drivers/net/wireless/ath/ath9k/hw.c
> index 8006ce0..a2e5763 100644
> --- a/drivers/net/wireless/ath/ath9k/hw.c
> +++ b/drivers/net/wireless/ath/ath9k/hw.c
> @@ -2432,15 +2432,18 @@ void ath9k_hw_set_txpowerlimit(struct ath_hw *ah, u32
limit, bool test)
>  	struct ath_regulatory *regulatory = ath9k_hw_regulatory(ah);
>  	struct ath9k_channel *chan = ah->curchan;
>  	struct ieee80211_channel *channel = chan->chan;
> +	int reg_pwr = min_t(int, MAX_RATE_POWER, regulatory->power_limit);
> +	int chan_pwr = channel->max_power * 2;
> +
> +	if (test)
> +		reg_pwr = chan_pwr = MAX_RATE_POWER;
> 
>  	regulatory->power_limit = min(limit, (u32) MAX_RATE_POWER);
> 
>  	ah->eep_ops->set_txpower(ah, chan,
>  				 ath9k_regd_get_ctl(regulatory, chan),
>  				 channel->max_antenna_gain * 2,
> -				 channel->max_power * 2,
> -				 min((u32) MAX_RATE_POWER,
> -				 (u32) regulatory->power_limit), test);
> +				 chan_pwr, reg_pwr, test);
>  }
>  EXPORT_SYMBOL(ath9k_hw_set_txpowerlimit);
> 


Dear Mr. Fietkau,

I have tried to apply your patch on
http://www.orbit-lab.org/kernel/compat-wireless-3-stable/v3.3/compat-wireless-3.3-2-n.tar.bz2

I get the following error:

patch -p1 < ath9k_txpower.patch
patching file drivers/net/wireless/ath/ath9k/hw.c
Hunk #1 FAILED at 2432.
patch unexpectedly ends in middle of line
1 out of 1 hunk FAILED -- saving rejects to file
drivers/net/wireless/ath/ath9k/hw.c.rej
patch unexpectedly ends in middle of line

Could you support me with a patch tuned to the above compat-wireless?

Yours sincerelly,

Ambrus Oláh

