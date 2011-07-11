Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:51755 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870Ab1GKV07 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jul 2011 17:26:59 -0400
Received: by yxi11 with SMTP id 11so1692578yxi.19
        for <linux-wireless@vger.kernel.org>; Mon, 11 Jul 2011 14:26:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1309835484-26653-7-git-send-email-nbd@openwrt.org>
References: <1309835484-26653-1-git-send-email-nbd@openwrt.org>
	<1309835484-26653-2-git-send-email-nbd@openwrt.org>
	<1309835484-26653-3-git-send-email-nbd@openwrt.org>
	<1309835484-26653-4-git-send-email-nbd@openwrt.org>
	<1309835484-26653-5-git-send-email-nbd@openwrt.org>
	<1309835484-26653-6-git-send-email-nbd@openwrt.org>
	<1309835484-26653-7-git-send-email-nbd@openwrt.org>
Date: Tue, 12 Jul 2011 00:26:58 +0300
Message-ID: <CAFtRNNy56JtDcZBUMSa4A4JjW0RsxO5SYzRdFMcGTg9xJF0ynQ@mail.gmail.com> (sfid-20110711_232702_525396_6C78828C)
Subject: Re: [PATCH v2 7/8] ath5k: disable 32KHz sleep clock operation by default
From: Nick Kossifidis <mickflemm@gmail.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	ath5k-devel@lists.ath5k.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/7/5 Felix Fietkau <nbd@openwrt.org>:
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
>  drivers/net/wireless/ath/ath5k/ath5k.h |    2 ++
>  drivers/net/wireless/ath/ath5k/debug.c |    3 +++
>  drivers/net/wireless/ath/ath5k/reset.c |   11 ++++++++---
>  3 files changed, 13 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
> index c4c02d5..6ea4d5d 100644
> --- a/drivers/net/wireless/ath/ath5k/ath5k.h
> +++ b/drivers/net/wireless/ath/ath5k/ath5k.h
> @@ -1066,6 +1066,8 @@ struct ath5k_hw {
>        u8                      ah_retry_long;
>        u8                      ah_retry_short;
>
> +       u32                     ah_use_32khz_clock;
> +
>        u8                      ah_coverage_class;
>        bool                    ah_ack_bitrate_high;
>        u8                      ah_bwmode;
> diff --git a/drivers/net/wireless/ath/ath5k/debug.c b/drivers/net/wireless/ath/ath5k/debug.c
> index 0bf7313..c0cebb7 100644
> --- a/drivers/net/wireless/ath/ath5k/debug.c
> +++ b/drivers/net/wireless/ath/ath5k/debug.c
> @@ -918,6 +918,9 @@ ath5k_debug_init_device(struct ath5k_softc *sc)
>
>        debugfs_create_file("queue", S_IWUSR | S_IRUSR, phydir, sc,
>                            &fops_queue);
> +
> +       debugfs_create_bool("32khz_clock", S_IWUSR | S_IRUSR, phydir,
> +                           &sc->ah->ah_use_32khz_clock);
>  }
>
>  /* functions used in other places */
> diff --git a/drivers/net/wireless/ath/ath5k/reset.c b/drivers/net/wireless/ath/ath5k/reset.c
> index efcc4df..d94db31 100644
> --- a/drivers/net/wireless/ath/ath5k/reset.c
> +++ b/drivers/net/wireless/ath/ath5k/reset.c
> @@ -1287,11 +1287,16 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum nl80211_iftype op_mode,
>        ath5k_hw_dma_init(ah);
>
>
> -       /* Enable 32KHz clock function for AR5212+ chips
> +       /*
> +        * Enable 32KHz clock function for AR5212+ chips
>         * Set clocks to 32KHz operation and use an
>         * external 32KHz crystal when sleeping if one
> -        * exists */
> -       if (ah->ah_version == AR5K_AR5212 &&
> +        * exists.
> +        * Disabled by default because it is also disabled in
> +        * other drivers and it is known to cause stability
> +        * issues on some devices
> +        */
> +       if (ah->ah_use_32khz_clock && ah->ah_version == AR5K_AR5212 &&
>            op_mode != NL80211_IFTYPE_AP)
>                ath5k_hw_set_sleep_clock(ah, true);
>

Acked-by: Nick Kossifidis <mickflemm@gmail.com>



-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
