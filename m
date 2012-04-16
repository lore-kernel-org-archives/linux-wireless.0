Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:17439 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754824Ab2DPVpg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Apr 2012 17:45:36 -0400
Message-ID: <1334612732.5455.5.camel@dcbw.foobar.com> (sfid-20120416_234539_050070_B2971DD2)
Subject: Re: [RFC 5/4] libertas USB: convert to asynchronous firmware loading
From: Dan Williams <dcbw@redhat.com>
To: Daniel Drake <dsd@laptop.org>
Cc: linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org
Date: Mon, 16 Apr 2012 16:45:32 -0500
In-Reply-To: <20120409202338.B857C9D401E@zog.reactivated.net>
References: <20120409202338.B857C9D401E@zog.reactivated.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-04-09 at 21:23 +0100, Daniel Drake wrote:
> Signed-off-by: Daniel Drake <dsd@laptop.org>
> ---
>  drivers/net/wireless/libertas/if_usb.c |  102 +++++++++++++------------------
>  1 files changed, 43 insertions(+), 59 deletions(-)
> 
> Continuing the patch series from last week:
> 
> [RFC 1/4] libertas: Firmware loading simplifications
> [RFC 2/4] libertas: harden-up exit paths
> [RFC 3/4] libertas: add asynchronous firmware loading capability
> [RFC 4/4] libertas SDIO: convert to asynchronous firmware loading
> 
> This patch moves the USB driver to async firmware loading.

Works on my standlone 8388 dongle.  Same unregistered net_device as for
the 8686 though:

[32173.742533] usb8xxx 2-1:1.0: (unregistered net_device):
00:50:43:28:0b:88, fw 5.110.22p23, cap 0x00000303

Dan

> diff --git a/drivers/net/wireless/libertas/if_usb.c b/drivers/net/wireless/libertas/if_usb.c
> index 3dde3e0..d5c02a7 100644
> --- a/drivers/net/wireless/libertas/if_usb.c
> +++ b/drivers/net/wireless/libertas/if_usb.c
> @@ -41,6 +41,16 @@ enum {
>  	MODEL_8682 = 0x2
>  };
>  
> +/* table of firmware file names */
> +static const struct lbs_fw_table fw_table[] = {
> +	{ MODEL_8388, "libertas/usb8388_olpc.bin", NULL },
> +	{ MODEL_8388, "libertas/usb8388_v9.bin", NULL },
> +	{ MODEL_8388, "libertas/usb8388_v5.bin", NULL },
> +	{ MODEL_8388, "libertas/usb8388.bin", NULL },
> +	{ MODEL_8388, "usb8388.bin", NULL },
> +	{ MODEL_8682, "libertas/usb8682.bin", NULL }
> +};
> +
>  static struct usb_device_id if_usb_table[] = {
>  	/* Enter the device signature inside */
>  	{ USB_DEVICE(0x1286, 0x2001), .driver_info = MODEL_8388 },
> @@ -52,7 +62,9 @@ MODULE_DEVICE_TABLE(usb, if_usb_table);
>  
>  static void if_usb_receive(struct urb *urb);
>  static void if_usb_receive_fwload(struct urb *urb);
> -static int if_usb_prog_firmware(struct if_usb_card *cardp);
> +static void if_usb_prog_firmware(struct lbs_private *priv, int ret,
> +				 const struct firmware *fw,
> +				 const struct firmware *unused);
>  static int if_usb_host_to_card(struct lbs_private *priv, uint8_t type,
>  			       uint8_t *payload, uint16_t nb);
>  static int usb_tx_block(struct if_usb_card *cardp, uint8_t *payload,
> @@ -187,6 +199,7 @@ static int if_usb_probe(struct usb_interface *intf,
>  	struct usb_endpoint_descriptor *endpoint;
>  	struct lbs_private *priv;
>  	struct if_usb_card *cardp;
> +	int r = -ENOMEM;
>  	int i;
>  
>  	udev = interface_to_usbdev(intf);
> @@ -244,17 +257,10 @@ static int if_usb_probe(struct usb_interface *intf,
>  		goto dealloc;
>  	}
>  
> -	/* Upload firmware */
> -	if (if_usb_prog_firmware(cardp)) {
> -		lbs_deb_usbd(&udev->dev, "FW upload failed\n");
> -		goto err_prog_firmware;
> -	}
> -
>  	if (!(priv = lbs_add_card(cardp, &intf->dev)))
> -		goto err_prog_firmware;
> +		goto err_add_card;
>  
>  	cardp->priv = priv;
> -	cardp->priv->fw_ready = 1;
>  
>  	priv->hw_host_to_card = if_usb_host_to_card;
>  	priv->enter_deep_sleep = NULL;
> @@ -267,34 +273,25 @@ static int if_usb_probe(struct usb_interface *intf,
>  
>  	cardp->boot2_version = udev->descriptor.bcdDevice;
>  
> -	if_usb_submit_rx_urb(cardp);
> -
> -	if (lbs_start_card(priv))
> -		goto err_start_card;
> -
> -	if_usb_setup_firmware(priv);
> -
>  	usb_get_dev(udev);
>  	usb_set_intfdata(intf, cardp);
>  
> -	/*
> -	 * EHS_REMOVE_WAKEUP is not supported on all versions of the firmware.
> -	 */
> -	priv->wol_criteria = EHS_REMOVE_WAKEUP;
> -	if (lbs_host_sleep_cfg(priv, priv->wol_criteria, NULL))
> -		priv->ehs_remove_supported = false;
> +	r = lbs_get_firmware_async(priv, &udev->dev, cardp->model,
> +				   fw_table, if_usb_prog_firmware);
> +	if (r)
> +		goto err_get_fw;
>  
>  	return 0;
>  
> -err_start_card:
> +err_get_fw:
>  	lbs_remove_card(priv);
> -err_prog_firmware:
> +err_add_card:
>  	if_usb_reset_device(cardp);
>  dealloc:
>  	if_usb_free(cardp);
>  
>  error:
> -	return -ENOMEM;
> +	return r;
>  }
>  
>  /**
> @@ -829,49 +826,22 @@ static int check_fwfile_format(const uint8_t *data, uint32_t totlen)
>  	return ret;
>  }
>  
> -/* table of firmware file names */
> -static const struct {
> -	u32 model;
> -	const char *fwname;
> -} fw_table[] = {
> -	{ MODEL_8388, "libertas/usb8388_olpc.bin" },
> -	{ MODEL_8388, "libertas/usb8388_v9.bin" },
> -	{ MODEL_8388, "libertas/usb8388_v5.bin" },
> -	{ MODEL_8388, "libertas/usb8388.bin" },
> -	{ MODEL_8388, "usb8388.bin" },
> -	{ MODEL_8682, "libertas/usb8682.bin" }
> -};
> -
> -static int get_fw(struct if_usb_card *cardp)
> -{
> -	int i;
> -
> -	/* Otherwise search for firmware to use */
> -	for (i = 0; i < ARRAY_SIZE(fw_table); i++) {
> -		if (fw_table[i].model != cardp->model)
> -			continue;
> -		if (request_firmware(&cardp->fw, fw_table[i].fwname,
> -					&cardp->udev->dev) == 0)
> -			return 0;
> -	}
> -
> -	return -ENOENT;
> -}
> -
> -static int if_usb_prog_firmware(struct if_usb_card *cardp)
> +static void if_usb_prog_firmware(struct lbs_private *priv, int ret,
> +				 const struct firmware *fw,
> +				 const struct firmware *unused)
>  {
> +	struct if_usb_card *cardp = priv->card;
>  	int i = 0;
>  	static int reset_count = 10;
> -	int ret = 0;
>  
>  	lbs_deb_enter(LBS_DEB_USB);
>  
> -	ret = get_fw(cardp);
>  	if (ret) {
>  		pr_err("failed to find firmware (%d)\n", ret);
>  		goto done;
>  	}
>  
> +	cardp->fw = fw;
>  	if (check_fwfile_format(cardp->fw->data, cardp->fw->size)) {
>  		ret = -EINVAL;
>  		goto release_fw;
> @@ -954,13 +924,27 @@ restart:
>  		goto release_fw;
>  	}
>  
> +	cardp->priv->fw_ready = 1;
> +	if_usb_submit_rx_urb(cardp);
> +
> +	if (lbs_start_card(priv))
> +		goto release_fw;
> +
> +	if_usb_setup_firmware(priv);
> +
> +	/*
> +	 * EHS_REMOVE_WAKEUP is not supported on all versions of the firmware.
> +	 */
> +	priv->wol_criteria = EHS_REMOVE_WAKEUP;
> +	if (lbs_host_sleep_cfg(priv, priv->wol_criteria, NULL))
> +		priv->ehs_remove_supported = false;
> +
>   release_fw:
>  	release_firmware(cardp->fw);
>  	cardp->fw = NULL;
>  
>   done:
> -	lbs_deb_leave_args(LBS_DEB_USB, "ret %d", ret);
> -	return ret;
> +	lbs_deb_leave(LBS_DEB_USB);
>  }
>  
> 


