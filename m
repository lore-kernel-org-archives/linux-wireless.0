Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.181]:4710 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751463AbXKAN15 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Nov 2007 09:27:57 -0400
Received: by py-out-1112.google.com with SMTP id u77so928766pyb
        for <linux-wireless@vger.kernel.org>; Thu, 01 Nov 2007 06:27:56 -0700 (PDT)
Message-ID: <40f31dec0711010627t2e62edb5g225848d3054c4c97@mail.gmail.com> (sfid-20071101_132801_857215_405120BC)
Date: Thu, 1 Nov 2007 15:27:55 +0200
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: [PATCH 6/7] ath5k: Clear up settings of AR5K_RSSI_THR register settings
Cc: "John Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, "Jiri Slaby" <jirislaby@gmail.com>
In-Reply-To: <20071101043933.GG21987@pogo>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20071101043520.GC21987@pogo> <20071101043718.GD21987@pogo>
	 <20071101043815.GE21987@pogo> <20071101043855.GF21987@pogo>
	 <20071101043933.GG21987@pogo>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2007/11/1, Luis R. Rodriguez <mcgrof@gmail.com>:
> Clear up settings of AR5K_RSSI_THR register settings. These are split between
> AR5K_TUNE_BMISS_THRES and AR5K_TUNE_RSSI_THRES.
>
> Changes to ath5k.h, hw.c
> Changes-licensed-under: ISC
>
> Signed-off-by: Luis R. Rodriguez <mcgrof@gmail.com>
> ---
>  drivers/net/wireless/ath5k/ath5k.h |   10 +++++++++-
>  drivers/net/wireless/ath5k/hw.c    |   11 ++++-------
>  2 files changed, 13 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/net/wireless/ath5k/ath5k.h b/drivers/net/wireless/ath5k/ath5k.h
> index 3354b37..c8ab09a 100644
> --- a/drivers/net/wireless/ath5k/ath5k.h
> +++ b/drivers/net/wireless/ath5k/ath5k.h
> @@ -86,8 +86,16 @@
>  #define AR5K_TUNE_RADAR_ALERT                  false
>  #define AR5K_TUNE_MIN_TX_FIFO_THRES            1
>  #define AR5K_TUNE_MAX_TX_FIFO_THRES            ((IEEE80211_MAX_LEN / 64) + 1)
> -#define AR5K_TUNE_RSSI_THRES                   1792
>  #define AR5K_TUNE_REGISTER_TIMEOUT             20000
> +/* Register for RSSI threshold has a mask of 0xff, so 255 seems to
> + * be the max value. */
> +#define AR5K_TUNE_RSSI_THRES                   129
> +/* This must be set when setting the RSSI threshold otherwise it can
> + * prevent a reset. If AR5K_RSSI_THR is read after writing to it
> + * the BMISS_THRES will be seen as 0, seems harware doesn't keep
> + * track of it. Max value depends on harware. For AR5210 this is just 7.
> + * For AR5211+ this seems to be up to 255. */
> +#define AR5K_TUNE_BMISS_THRES                  7
>  #define AR5K_TUNE_REGISTER_DWELL_TIME          20000
>  #define AR5K_TUNE_BEACON_INTERVAL              100
>  #define AR5K_TUNE_AIFS                         2
> diff --git a/drivers/net/wireless/ath5k/hw.c b/drivers/net/wireless/ath5k/hw.c
> index 1b9c4f0..f1ba863 100644
> --- a/drivers/net/wireless/ath5k/hw.c
> +++ b/drivers/net/wireless/ath5k/hw.c
> @@ -849,13 +849,10 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum ieee80211_if_types op_mode,
>         /*PISR/SISR Not available on 5210*/
>         if (ah->ah_version != AR5K_AR5210) {
>                 ath5k_hw_reg_write(ah, 0xffffffff, AR5K_PISR);
> -               /* XXX: AR5K_RSSI_THR has masks and shifts defined for it, so
> -                * direct write using ath5k_hw_reg_write seems wrong. Test with:
> -                * AR5K_REG_WRITE_BITS(ah, AR5K_RSSI_THR,
> -                *   AR5K_RSSI_THR_BMISS, AR5K_TUNE_RSSI_THRES);
> -                * with different variables and check results compared
> -                * to ath5k_hw_reg_write(ah, )  */
> -               ath5k_hw_reg_write(ah, AR5K_TUNE_RSSI_THRES, AR5K_RSSI_THR);
> +               /* If we later allow tuning for this, store into sc structure */
> +               data = AR5K_TUNE_RSSI_THRES |
> +                       AR5K_TUNE_BMISS_THRES << AR5K_RSSI_THR_BMISS_S;
> +               ath5k_hw_reg_write(ah, data, AR5K_RSSI_THR);
>         }
>
>         /*
> --
> 1.5.2.5
>
>

Acked-by: Nick Kossifidis <mickflemm@gmail.com>

-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
