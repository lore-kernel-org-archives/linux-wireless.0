Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 30.mail-out.ovh.net ([213.186.62.213]:35489 "HELO
	30.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756797Ab0CCWDt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Mar 2010 17:03:49 -0500
Message-ID: <4B8EDCC2.9070401@free.fr>
Date: Wed, 03 Mar 2010 23:03:46 +0100
From: Benoit PAPILLAULT <benoit.papillault@free.fr>
MIME-Version: 1.0
To: Andrew Blaich <ablaich@gmail.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Bob Copeland <me@bobcopeland.com>
Subject: Re: [PATCH] ath5k: fixing retries in ath5k_hw_setup_4word_tx_desc
References: <6b5e31691003010730ie73ff4cld32e3a9d38def7d0@mail.gmail.com>
In-Reply-To: <6b5e31691003010730ie73ff4cld32e3a9d38def7d0@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Andrew Blaich a écrit :
> This Patch:
>
> The rate control algorithm, default is Minstrel for ath5k, determines
> the number of retries to use for each rate.  However, there exists in
> ath5k_hw_setup_4word_tx_desc (which is called for AR5212 like devices)
> a set number of retries defined by AR5K_TUNE_HWTXTRIES.  The set
> number of tries is added to the tx_tries0 variable setup by the rate
> control algorithm.  This changes the number of retries the rate
> control algorithm considers necessary.  By removing the
> AR5K_TUNE_HWTXTRIES from the retry calculation the rate control
> algorithm is given control over the number of retries.
>
>
> Signed-off-by:: Andrew Blaich <ablaich@gmail.com>
> ---
> diff --git a/drivers/net/wireless/ath/ath5k/desc.c
> b/drivers/net/wireless/ath/ath5k/desc.c
> index dc30a2b..c18d8d4 100644
> --- a/drivers/net/wireless/ath/ath5k/desc.c
> +++ b/drivers/net/wireless/ath/ath5k/desc.c
> @@ -229,7 +229,7 @@ static int ath5k_hw_setup_4word_tx_desc(struct ath5k_hw *ah,
>  		AR5K_REG_SM(antenna_mode, AR5K_4W_TX_DESC_CTL0_ANT_MODE_XMIT);
>  	tx_ctl->tx_control_1 |= AR5K_REG_SM(type,
>  					AR5K_4W_TX_DESC_CTL1_FRAME_TYPE);
> -	tx_ctl->tx_control_2 = AR5K_REG_SM(tx_tries0 + AR5K_TUNE_HWTXTRIES,
> +	tx_ctl->tx_control_2 = AR5K_REG_SM(tx_tries0,
>  					AR5K_4W_TX_DESC_CTL2_XMIT_TRIES0);
>  	tx_ctl->tx_control_3 = tx_rate0 & AR5K_4W_TX_DESC_CTL3_XMIT_RATE0;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>   
Good catch. If I were you, I would remove the #define in ath5.h as well 
since it is no longer use.

Tested & Acked-by: Benoit Papillault <benoit.papillault@free.fr>

Regards,
Benoit

