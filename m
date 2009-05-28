Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:38810 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921AbZE1HSL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 May 2009 03:18:11 -0400
Subject: Re: [RFT 2/2] ar9170: add AVM FRITZ devices
From: Marcel Holtmann <marcel@holtmann.org>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linux-wireless@vger.kernel.org, jal2@gmx.de,
	Peter.Grabienski@Atheros.com, Stephen.Chen@Atheros.com,
	Michael.Fortin@Atheros.com, Johnny.Cheng@Atheros.com,
	Yuan-Gu.Wei@atheros.com, otus-devel@lists.madwifi-project.org
In-Reply-To: <1243475326-28867-3-git-send-email-lrodriguez@atheros.com>
References: <1243475326-28867-1-git-send-email-lrodriguez@atheros.com>
	 <1243475326-28867-3-git-send-email-lrodriguez@atheros.com>
Content-Type: text/plain
Date: Thu, 28 May 2009 09:17:51 +0200
Message-Id: <1243495071.16631.4.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Luis,

> This adds:
> 
> USB 0x057C:0x8401       AVM FRITZ!WLAN USB Stick N
> USB 0x057C:0x8402       AVM FRITZ!WLAN USB Stick N 2.4
> 
> These devices require the 1-stage firmware, if not present we
> don't continue.
> 
> Cc: Peter Grabienski <Peter.Grabienski@Atheros.com>
> Cc: Stephen Chen <Stephen.Chen@Atheros.com>
> Cc: Michael Fortin <Michael.Fortin@Atheros.com>
> Cc: Johnny Cheng <Johnny.Cheng@Atheros.com>
> Cc: Yuan-Gu Wei <Yuan-Gu.Wei@atheros.com>
> Cc: Joerg Albert <jal2@gmx.de>
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> ---
>  drivers/net/wireless/ath/ar9170/usb.c |   28 ++++++++++++++++++++++++++++
>  drivers/net/wireless/ath/ar9170/usb.h |    2 ++
>  2 files changed, 30 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ar9170/usb.c b/drivers/net/wireless/ath/ar9170/usb.c
> index 3c97c09..45b5291 100644
> --- a/drivers/net/wireless/ath/ar9170/usb.c
> +++ b/drivers/net/wireless/ath/ar9170/usb.c
> @@ -82,6 +82,10 @@ static struct usb_device_id ar9170_usb_ids[] = {
>  	{ USB_DEVICE(0x2019, 0x5304) },
>  	/* IO-Data WNGDNUS2 */
>  	{ USB_DEVICE(0x04bb, 0x093f) },
> +	/* AVM FRITZ!WLAN USB Stick N */
> +	{ USB_DEVICE(0x057C, 0x8401) },
> +	/* AVM FRITZ!WLAN USB Stick N 2.4 */
> +	{ USB_DEVICE(0x057C, 0x8402) },
>  
>  	/* terminate */
>  	{}
> @@ -512,6 +516,12 @@ static int ar9170_usb_request_firmware(struct ar9170_usb *aru)
>  		return 0;
>  	}
>  
> +	if (aru->req_one_stage_fw) {
> +		dev_err(&aru->udev->dev, "ar9170.fw firmware file "
> +			"not found and is required for this device\n");
> +		return -EINVAL;
> +	}
> +
>  	dev_err(&aru->udev->dev, "ar9170.fw firmware file "
>  		"not found, trying old firmware...\n");
>  
> @@ -668,6 +678,22 @@ err_out:
>  	return err;
>  }
>  
> +static bool ar9170_requires_one_stage(const struct usb_device_id *id)
> +{
> +	/* AVM FRITZ only */
> +	if (id->idVendor != 0x057C)
> +		return false;
> +
> +	switch (id->idProduct) {
> +		case 0x8401: /* AVM FRITZ!WLAN USB Stick N */
> +		case 0x8402: /* AVM FRITZ!WLAN USB Stick N 2.4 */
> +			return true;
> +		default:
> +			return false;
> +	}
> +	return false;
> +}
> +

can't you make this part of use_device_id table? Syncing up with product
ids in two places is not a good idea.

Regards

Marcel


