Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f216.google.com ([209.85.219.216]:65354 "EHLO
	mail-ew0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754154Ab0CIMXV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Mar 2010 07:23:21 -0500
Received: by mail-ew0-f216.google.com with SMTP id 8so655952ewy.28
        for <linux-wireless@vger.kernel.org>; Tue, 09 Mar 2010 04:23:20 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20100309075615.30616.36296.stgit@void>
References: <20100309075124.30616.40896.stgit@void>
	 <20100309075615.30616.36296.stgit@void>
Date: Tue, 9 Mar 2010 14:23:20 +0200
Message-ID: <40f31dec1003090423j58a6dea4nbccfba4c23230722@mail.gmail.com>
Subject: Re: [PATCH 12/13] ath5k: IQ calibration for AR5211 is slightly
	different
From: Nick Kossifidis <mickflemm@gmail.com>
To: Bruno Randolf <br1@einfach.org>
Cc: linville@tuxdriver.com, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/3/9 Bruno Randolf <br1@einfach.org>:
> according to the HAL sources the calculation of the Q value is slightly
> different for AR5211 chips.
>
> i couldn't test this since IQ calibration never finishes on older parts. this
> is a different problem...
>
> Signed-off-by: Bruno Randolf <br1@einfach.org>
> ---
>  drivers/net/wireless/ath/ath5k/phy.c |   11 +++++++++--
>  1 files changed, 9 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath5k/phy.c b/drivers/net/wireless/ath/ath5k/phy.c
> index 95cebd6..3a18742 100644
> --- a/drivers/net/wireless/ath/ath5k/phy.c
> +++ b/drivers/net/wireless/ath/ath5k/phy.c
> @@ -1399,7 +1399,11 @@ static int ath5k_hw_rf511x_calibrate(struct ath5k_hw *ah,
>        }
>
>        i_coffd = ((i_pwr >> 1) + (q_pwr >> 1)) >> 7;
> -       q_coffd = q_pwr >> 7;
> +
> +       if (ah->ah_version == AR5K_AR5211)
> +               q_coffd = q_pwr >> 6;
> +       else
> +               q_coffd = q_pwr >> 7;
>
>        /* protect against divide by 0 and loss of sign bits */
>        if (i_coffd == 0 || q_coffd < 2)
> @@ -1408,7 +1412,10 @@ static int ath5k_hw_rf511x_calibrate(struct ath5k_hw *ah,
>        i_coff = (-iq_corr) / i_coffd;
>        i_coff = clamp(i_coff, -32, 31); /* signed 6 bit */
>
> -       q_coff = (i_pwr / q_coffd) - 128;
> +       if (ah->ah_version == AR5K_AR5211)
> +               q_coff = (i_pwr / q_coffd) - 64;
> +       else
> +               q_coff = (i_pwr / q_coffd) - 128;
>        q_coff = clamp(q_coff, -16, 15); /* signed 5 bit */
>
>        ATH5K_DBG_UNLIMIT(ah->ah_sc, ATH5K_DEBUG_CALIBRATE,
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Acked-by: Nick Kossifidis <mickflemm@gmail.com>

-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
