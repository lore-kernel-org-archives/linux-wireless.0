Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:55761 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756821Ab1GDJ6z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Jul 2011 05:58:55 -0400
Received: by yxi11 with SMTP id 11so1534706yxi.19
        for <linux-wireless@vger.kernel.org>; Mon, 04 Jul 2011 02:58:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1309758467-1712-7-git-send-email-nbd@openwrt.org>
References: <1309758467-1712-1-git-send-email-nbd@openwrt.org>
	<1309758467-1712-2-git-send-email-nbd@openwrt.org>
	<1309758467-1712-3-git-send-email-nbd@openwrt.org>
	<1309758467-1712-4-git-send-email-nbd@openwrt.org>
	<1309758467-1712-5-git-send-email-nbd@openwrt.org>
	<1309758467-1712-6-git-send-email-nbd@openwrt.org>
	<1309758467-1712-7-git-send-email-nbd@openwrt.org>
Date: Mon, 4 Jul 2011 12:58:55 +0300
Message-ID: <CAFtRNNyPJOtjW8vDnjveqmMD3snt_iaDV45p3QZEOKrSyED3yg@mail.gmail.com> (sfid-20110704_115859_184846_F8DB91AB)
Subject: Re: [PATCH 7/8] ath5k: disable 32KHz sleep clock operation
From: Nick Kossifidis <mickflemm@gmail.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	ath5k-devel@lists.ath5k.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/7/4 Felix Fietkau <nbd@openwrt.org>:
> While 32 KHz sleep clock might provide some power saving benefits,
> it is also a major source of stability issues, on OpenWrt it produced
> some reproducible data bus errors on register accesses on several
> different MIPS platforms.
>
> All the Atheros drivers that I can find do not enable this feature,
> so it makes sense to leave it disabled in ath5k as well.
>
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> ---
>  drivers/net/wireless/ath/ath5k/reset.c |    9 ---------
>  1 files changed, 0 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath5k/reset.c b/drivers/net/wireless/ath/ath5k/reset.c
> index 55276ce..192c0cb 100644
> --- a/drivers/net/wireless/ath/ath5k/reset.c
> +++ b/drivers/net/wireless/ath/ath5k/reset.c
> @@ -1285,15 +1285,6 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum nl80211_iftype op_mode,
>         */
>        ath5k_hw_dma_init(ah);
>
> -
> -       /* Enable 32KHz clock function for AR5212+ chips
> -        * Set clocks to 32KHz operation and use an
> -        * external 32KHz crystal when sleeping if one
> -        * exists */
> -       if (ah->ah_version == AR5K_AR5212 &&
> -           op_mode != NL80211_IFTYPE_AP)
> -               ath5k_hw_set_sleep_clock(ah, true);
> -
>        /*
>         * Disable beacons and reset the TSF
>         */
> --
> 1.7.3.2
>

a) LegacyHAL and Sam's HAL both enable it
b) Not many cards have a 32KHz crystal anyway (disabled on EEPROM)
c) Please don't just remove code, if you want to disable it you can
always comment it out
d) Why not make it a module parameter instead ?



-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
