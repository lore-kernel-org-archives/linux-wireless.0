Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57625 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755691Ab0KJMfd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Nov 2010 07:35:33 -0500
Received: by fxm16 with SMTP id 16so282269fxm.19
        for <linux-wireless@vger.kernel.org>; Wed, 10 Nov 2010 04:35:32 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Rajkumar Manoharan <rmanoharan@atheros.com>
Subject: Re: [PATCH] ath9k_htc: Add new devices into AR7010
Date: Wed, 10 Nov 2010 13:35:14 +0100
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
References: <1289389041-26938-1-git-send-email-rmanoharan@atheros.com>
In-Reply-To: <1289389041-26938-1-git-send-email-rmanoharan@atheros.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201011101335.14311.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 10 November 2010 12:37:21 Rajkumar Manoharan wrote:
> Treat PIDs (0xA704, 0x1200) as AR7010 devices.

just a though, but instead of relying only on the pid and
hope for no collisions. you could put a @driver_info flag
for all AR7010 devices into the usb_device_id table and
remove the per-device "cases". 

Best Regards,
	Chr

> ---
> diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
> index 0e12277..dfb6560 100644
> --- a/drivers/net/wireless/ath/ath9k/hif_usb.c
> +++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
> @@ -811,6 +811,8 @@ static int ath9k_hif_usb_download_fw(struct hif_device_usb *hif_dev)
>  	case 0x7010:
>  	case 0x7015:
>  	case 0x9018:
> +	case 0xA704: <--
> +	case 0x1200: <--
>  		firm_offset = AR7010_FIRMWARE_TEXT;
>  		break;
>  	default:
> @@ -933,6 +935,8 @@ static int ath9k_hif_usb_probe(struct usb_interface *interface,
>  	case 0x7010:
>  	case 0x7015:
>  	case 0x9018:
> +	case 0xA704:
> +	case 0x1200:
>  		if (le16_to_cpu(udev->descriptor.bcdDevice) == 0x0202)
>  			hif_dev->fw_name = FIRMWARE_AR7010_1_1;
>  		else
> diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
> index 3d7b97f..7c8a38d 100644
> --- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
> +++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
> @@ -249,6 +249,8 @@ static int ath9k_init_htc_services(struct ath9k_htc_priv *priv, u16 devid)
>  	case 0x7010:
>  	case 0x7015:
>  	case 0x9018:
> +	case 0xA704:
> +	case 0x1200:
>  		priv->htc->credits = 45;
>  		break;
>  	default:
> diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
> index fa05b71..52ee82d 100644
> --- a/drivers/net/wireless/ath/ath9k/reg.h
> +++ b/drivers/net/wireless/ath/ath9k/reg.h
> @@ -866,7 +866,9 @@
>  #define AR_DEVID_7010(_ah) \
>  	(((_ah)->hw_version.devid == 0x7010) || \
>  	 ((_ah)->hw_version.devid == 0x7015) || \
> -	 ((_ah)->hw_version.devid == 0x9018))
> +	 ((_ah)->hw_version.devid == 0x9018) || \
> +	 ((_ah)->hw_version.devid == 0xA704) || \
> +	 ((_ah)->hw_version.devid == 0x1200))
>  
>  #define AR_RADIO_SREV_MAJOR                   0xf0
>  #define AR_RAD5133_SREV_MAJOR                 0xc0
