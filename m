Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:40536 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752886AbaJTIrv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2014 04:47:51 -0400
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21572.49230.430784.951715@gargle.gargle.HOWL> (sfid-20141020_104754_614655_88B028DD)
Date: Mon, 20 Oct 2014 13:27:02 +0530
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: [PATCH 01/10] ath9k_hw: make support for PC-OEM cards optional
In-Reply-To: <1413651732-69783-1-git-send-email-nbd@openwrt.org>
References: <1413651732-69783-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau wrote:
> diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
> index 975074f..7a81f5b 100644
> --- a/drivers/net/wireless/ath/ath9k/hw.h
> +++ b/drivers/net/wireless/ath/ath9k/hw.h
> @@ -244,13 +244,20 @@ enum ath9k_hw_caps {
>  	ATH9K_HW_CAP_2GHZ			= BIT(11),
>  	ATH9K_HW_CAP_5GHZ			= BIT(12),
>  	ATH9K_HW_CAP_APM			= BIT(13),
> +#ifdef CONFIG_ATH9K_PCOEM
>  	ATH9K_HW_CAP_RTT			= BIT(14),
>  	ATH9K_HW_CAP_MCI			= BIT(15),
> -	ATH9K_HW_CAP_DFS			= BIT(16),
> -	ATH9K_HW_WOW_DEVICE_CAPABLE		= BIT(17),
> -	ATH9K_HW_CAP_PAPRD			= BIT(18),
> -	ATH9K_HW_CAP_FCC_BAND_SWITCH		= BIT(19),
> -	ATH9K_HW_CAP_BT_ANT_DIV			= BIT(20),
> +	ATH9K_HW_WOW_DEVICE_CAPABLE		= BIT(16),
> +	ATH9K_HW_CAP_BT_ANT_DIV			= BIT(17),
> +#else
> +	ATH9K_HW_CAP_RTT			= 0,
> +	ATH9K_HW_CAP_MCI			= 0,
> +	ATH9K_HW_WOW_DEVICE_CAPABLE		= 0,
> +	ATH9K_HW_CAP_BT_ANT_DIV			= 0,
> +#endif
> +	ATH9K_HW_CAP_DFS			= BIT(18),
> +	ATH9K_HW_CAP_PAPRD			= BIT(19),
> +	ATH9K_HW_CAP_FCC_BAND_SWITCH		= BIT(20),
>  };

Why is this needed ?
