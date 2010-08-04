Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:50492 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932431Ab0HDKMY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Aug 2010 06:12:24 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 04 Aug 2010 03:12:24 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19545.15991.794158.128610@gargle.gargle.HOWL>
Date: Wed, 4 Aug 2010 15:48:31 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Rajkumar.Manoharan@Atheros.com>
Subject: [PATCH] ath9k_htc: Fix Bulk endpoint issue
In-Reply-To: <19538.28927.259256.23273@gargle.gargle.HOWL>
References: <19538.28927.259256.23273@gargle.gargle.HOWL>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John,

Can you drop this patch ?
There is an issue which hasn't been fixed yet.
The patch would be resent after more testing.

thanks,
Sujith

Sujith wrote:
> AR9271 devices use four endpoints, of which EP3 and EP4
> are used for register read/write. Currently they are misconfigured
> as Interrupt endpoints. On downloading the firmware to the
> target, the USB descriptors are 'patched' to change the type
> of the endpoints to Bulk. To re-read the descriptors, the target
> has to be reset, triggering a re-enumeration, and the descriptors
> are identified properly.
> 
> A firmware fix is also needed here, to handle an invalid way
> of handling USB_PORT_FEAT_ENABLE, which is cleared as part of
> the reset.
> 
> Also, the target has to be rebooted in the suspend() routine.
> This is needed because, earlier the target was powered down in
> the USB_PORT_FEAT_ENABLE handler routine. Since this is no longer
> the case now, an explicit reboot is required.
> 
> With this fix, the CPU usage during a scan run comes down to
> acceptable levels. The time taken to complete a scan run is also
> reasonably fast, since register reads/writes go over Bulk endpoints.
> 
> Both AR7010 and AR9271 have this issue, but this patch addresses only
> the AR9271 family. Once the FW has been updated for AR7010, the host
> driver can be updated.
> 
> Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
> ---
>  drivers/net/wireless/ath/ath9k/hif_usb.c |  111 +++++++++++++++++++++++------
>  drivers/net/wireless/ath/ath9k/hif_usb.h |    1 +
>  2 files changed, 89 insertions(+), 23 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
> index 61c1bee..6efc46f 100644
> --- a/drivers/net/wireless/ath/ath9k/hif_usb.c
> +++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
> @@ -92,10 +92,19 @@ static int hif_usb_send_regout(struct hif_device_usb *hif_dev,
>  	cmd->skb = skb;
>  	cmd->hif_dev = hif_dev;
>  
> -	usb_fill_int_urb(urb, hif_dev->udev,
> -			 usb_sndintpipe(hif_dev->udev, USB_REG_OUT_PIPE),
> -			 skb->data, skb->len,
> -			 hif_usb_regout_cb, cmd, 1);
> +	if (hif_dev->flags & HIF_USB_AR9271) {
> +		usb_fill_bulk_urb(urb, hif_dev->udev,
> +				  usb_sndbulkpipe(hif_dev->udev,
> +						  USB_REG_OUT_PIPE),
> +				  skb->data, skb->len,
> +				  hif_usb_regout_cb, cmd);
> +	} else {
> +		usb_fill_int_urb(urb, hif_dev->udev,
> +				 usb_sndintpipe(hif_dev->udev,
> +						USB_REG_OUT_PIPE),
> +				 skb->data, skb->len,
> +				 hif_usb_regout_cb, cmd, 1);
> +	}
>  
>  	usb_anchor_urb(urb, &hif_dev->regout_submitted);
>  	ret = usb_submit_urb(urb, GFP_KERNEL);
> @@ -540,10 +549,19 @@ static void ath9k_hif_usb_reg_in_cb(struct urb *urb)
>  			return;
>  		}
>  
> -		usb_fill_int_urb(urb, hif_dev->udev,
> -				 usb_rcvintpipe(hif_dev->udev, USB_REG_IN_PIPE),
> -				 nskb->data, MAX_REG_IN_BUF_SIZE,
> -				 ath9k_hif_usb_reg_in_cb, nskb, 1);
> +		if (hif_dev->flags & HIF_USB_AR9271) {
> +			usb_fill_bulk_urb(urb, hif_dev->udev,
> +					  usb_rcvbulkpipe(hif_dev->udev,
> +							  USB_REG_IN_PIPE),
> +					  nskb->data, MAX_REG_IN_BUF_SIZE,
> +					  ath9k_hif_usb_reg_in_cb, nskb);
> +		} else {
> +			usb_fill_int_urb(urb, hif_dev->udev,
> +					 usb_rcvintpipe(hif_dev->udev,
> +							USB_REG_IN_PIPE),
> +					 nskb->data, MAX_REG_IN_BUF_SIZE,
> +					 ath9k_hif_usb_reg_in_cb, nskb, 1);
> +		}
>  
>  		ret = usb_submit_urb(urb, GFP_ATOMIC);
>  		if (ret) {
> @@ -719,10 +737,17 @@ static int ath9k_hif_usb_alloc_reg_in_urb(struct hif_device_usb *hif_dev)
>  	if (!skb)
>  		goto err;
>  
> -	usb_fill_int_urb(hif_dev->reg_in_urb, hif_dev->udev,
> -			 usb_rcvintpipe(hif_dev->udev, USB_REG_IN_PIPE),
> -			 skb->data, MAX_REG_IN_BUF_SIZE,
> -			 ath9k_hif_usb_reg_in_cb, skb, 1);
> +	if (hif_dev->flags & HIF_USB_AR9271) {
> +		usb_fill_bulk_urb(hif_dev->reg_in_urb, hif_dev->udev,
> +				  usb_rcvbulkpipe(hif_dev->udev, USB_REG_IN_PIPE),
> +				  skb->data, MAX_REG_IN_BUF_SIZE,
> +				  ath9k_hif_usb_reg_in_cb, skb);
> +	} else {
> +		usb_fill_int_urb(hif_dev->reg_in_urb, hif_dev->udev,
> +				 usb_rcvintpipe(hif_dev->udev, USB_REG_IN_PIPE),
> +				 skb->data, MAX_REG_IN_BUF_SIZE,
> +				 ath9k_hif_usb_reg_in_cb, skb, 1);
> +	}
>  
>  	if (usb_submit_urb(hif_dev->reg_in_urb, GFP_KERNEL) != 0)
>  		goto err;
> @@ -822,7 +847,9 @@ static int ath9k_hif_usb_download_fw(struct hif_device_usb *hif_dev)
>  
>  static int ath9k_hif_usb_dev_init(struct hif_device_usb *hif_dev)
>  {
> -	int ret;
> +	struct usb_host_interface *iface_desc;
> +	struct usb_endpoint_descriptor *endpoint;
> +	int i, ret;
>  
>  	/* Request firmware */
>  	ret = request_firmware(&hif_dev->firmware, hif_dev->fw_name,
> @@ -833,14 +860,6 @@ static int ath9k_hif_usb_dev_init(struct hif_device_usb *hif_dev)
>  		goto err_fw_req;
>  	}
>  
> -	/* Alloc URBs */
> -	ret = ath9k_hif_usb_alloc_urbs(hif_dev);
> -	if (ret) {
> -		dev_err(&hif_dev->udev->dev,
> -			"ath9k_htc: Unable to allocate URBs\n");
> -		goto err_urb;
> -	}
> -
>  	/* Download firmware */
>  	ret = ath9k_hif_usb_download_fw(hif_dev);
>  	if (ret) {
> @@ -850,11 +869,46 @@ static int ath9k_hif_usb_dev_init(struct hif_device_usb *hif_dev)
>  		goto err_fw_download;
>  	}
>  
> +	/*
> +	 * If any of the endpoints have been configured as Interrupt,
> +	 * reset the device to trigger re-enumeration.
> +	 *
> +	 * Re-enumeration changes the endpoints from Interrupt to Bulk,
> +	 * since the firmware 'patches' the USB descriptors.
> +	 *
> +	 * For now, do this only for AR9271. AR7010 based devices
> +	 * also need this hack, but until the corresponding FW is fixed,
> +	 * keep using EP3 and EP4 as Interrupt endpoints for AR7010.
> +	 */
> +
> +	if (hif_dev->flags & HIF_USB_AR9271) {
> +		iface_desc = hif_dev->interface->cur_altsetting;
> +
> +		for (i = 0; i < iface_desc->desc.bNumEndpoints; ++i) {
> +			endpoint = &iface_desc->endpoint[i].desc;
> +
> +			if (usb_endpoint_is_int_in(endpoint) ||
> +			    usb_endpoint_is_int_out(endpoint)) {
> +				ret = usb_reset_device(hif_dev->udev);
> +				if (ret)
> +					return ret;
> +			}
> +		}
> +	}
> +
> +	/* Alloc URBs */
> +	ret = ath9k_hif_usb_alloc_urbs(hif_dev);
> +	if (ret) {
> +		dev_err(&hif_dev->udev->dev,
> +			"ath9k_htc: Unable to allocate URBs\n");
> +		goto err_urb;
> +	}
> +
>  	return 0;
>  
> -err_fw_download:
> -	ath9k_hif_usb_dealloc_urbs(hif_dev);
>  err_urb:
> +	ath9k_hif_usb_dealloc_urbs(hif_dev);
> +err_fw_download:
>  	release_firmware(hif_dev->firmware);
>  err_fw_req:
>  	hif_dev->firmware = NULL;
> @@ -909,6 +963,7 @@ static int ath9k_hif_usb_probe(struct usb_interface *interface,
>  		break;
>  	default:
>  		hif_dev->fw_name = FIRMWARE_AR9271;
> +		hif_dev->flags |= HIF_USB_AR9271;
>  		break;
>  	}
>  
> @@ -995,6 +1050,16 @@ static int ath9k_hif_usb_suspend(struct usb_interface *interface,
>  
>  	ath9k_hif_usb_dealloc_urbs(hif_dev);
>  
> +	/*
> +	 * Issue a reboot to the target, since it
> +	 * has be powered down.
> +	 *
> +	 * The 0xffffff command is a special case that
> +	 * is handled in the firmware.
> +	 */
> +	if (hif_dev->flags & HIF_USB_AR9271)
> +		ath9k_hif_usb_reboot(hif_dev->udev);
> +
>  	return 0;
>  }
>  
> diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.h b/drivers/net/wireless/ath/ath9k/hif_usb.h
> index 2daf97b..ced63cb 100644
> --- a/drivers/net/wireless/ath/ath9k/hif_usb.h
> +++ b/drivers/net/wireless/ath/ath9k/hif_usb.h
> @@ -62,6 +62,7 @@ struct tx_buf {
>  };
>  
>  #define HIF_USB_TX_STOP  BIT(0)
> +#define HIF_USB_AR9271   BIT(1)
>  
>  struct hif_usb_tx {
>  	u8 flags;
> -- 
> 1.7.2.1
> 
> 
