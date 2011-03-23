Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f179.google.com ([209.85.212.179]:33508 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876Ab1CWAwt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Mar 2011 20:52:49 -0400
Received: by pxi2 with SMTP id 2so1498793pxi.10
        for <linux-wireless@vger.kernel.org>; Tue, 22 Mar 2011 17:52:49 -0700 (PDT)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19849.17430.996052.672230@gargle.gargle.HOWL>
Date: Wed, 23 Mar 2011 06:21:34 +0530
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	lrodriguez@atheros.com
Subject: [PATCH 1/3] ath9k: fix beacon timer handling issues
In-Reply-To: <1300827259-42910-1-git-send-email-nbd@openwrt.org>
References: <1300827259-42910-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau wrote:
> diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
> index 8d1d879..8f56158 100644
> --- a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
> +++ b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
> @@ -155,7 +155,7 @@ static void ath9k_htc_beacon_config_ap(struct ath9k_htc_priv *priv,
>  	nexttbtt = intval;
>  
>  	if (priv->op_flags & OP_TSF_RESET) {
> -		intval |= ATH9K_BEACON_RESET_TSF;
> +		ath9k_hw_reset_tsf(priv->ah);
>  		priv->op_flags &= ~OP_TSF_RESET;
>  	} else {
>  		/*
> @@ -168,8 +168,6 @@ static void ath9k_htc_beacon_config_ap(struct ath9k_htc_priv *priv,
>  		} while (nexttbtt < tsftu);
>  	}
>  
> -	intval |= ATH9K_BEACON_ENA;
> -
>  	if (priv->op_flags & OP_ENABLE_BEACON)
>  		imask |= ATH9K_INT_SWBA;
>  
> @@ -178,7 +176,7 @@ static void ath9k_htc_beacon_config_ap(struct ath9k_htc_priv *priv,
>  		bss_conf->beacon_interval, nexttbtt, imask);
>  
>  	WMI_CMD(WMI_DISABLE_INTR_CMDID);
> -	ath9k_hw_beaconinit(priv->ah, nexttbtt, intval);
> +	ath9k_hw_beaconinit(priv->ah, TU_TO_USEC(nexttbtt), TU_TO_USEC(intval));
>  	priv->bmiss_cnt = 0;
>  	htc_imask = cpu_to_be32(imask);
>  	WMI_CMD_BUF(WMI_ENABLE_INTR_CMDID, &htc_imask);
> @@ -207,7 +205,6 @@ static void ath9k_htc_beacon_config_adhoc(struct ath9k_htc_priv *priv,
>  		nexttbtt += intval;
>  	} while (nexttbtt < tsftu);
>  
> -	intval |= ATH9K_BEACON_ENA;
>  	if (priv->op_flags & OP_ENABLE_BEACON)
>  		imask |= ATH9K_INT_SWBA;
>  
> @@ -216,7 +213,7 @@ static void ath9k_htc_beacon_config_adhoc(struct ath9k_htc_priv *priv,
>  		bss_conf->beacon_interval, nexttbtt, imask);
>  
>  	WMI_CMD(WMI_DISABLE_INTR_CMDID);
> -	ath9k_hw_beaconinit(priv->ah, nexttbtt, intval);
> +	ath9k_hw_beaconinit(priv->ah, TU_TO_USEC(nexttbtt), TU_TO_USEC(intval));
>  	priv->bmiss_cnt = 0;
>  	htc_imask = cpu_to_be32(imask);
>  	WMI_CMD_BUF(WMI_ENABLE_INTR_CMDID, &htc_imask);

The HTC bits look okay.

Sujith

