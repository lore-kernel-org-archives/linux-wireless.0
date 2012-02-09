Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:61626 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754005Ab2BIUyI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Feb 2012 15:54:08 -0500
Received: by bkcjm19 with SMTP id jm19so2188261bkc.19
        for <linux-wireless@vger.kernel.org>; Thu, 09 Feb 2012 12:54:06 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [RFC/RFT] p54usb: Convert to asynchronous firmware loading
Date: Thu, 9 Feb 2012 18:24:59 +0100
Cc: linux-wireless@vger.kernel.org
References: <4f333dab.P7Ufo/3FNn6TtcgX%Larry.Finger@lwfinger.net>
In-Reply-To: <4f333dab.P7Ufo/3FNn6TtcgX%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201202091824.59996.chunkeey@googlemail.com> (sfid-20120209_215412_934582_16C49CD9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hey Larry!

On Thursday, February 09, 2012 04:29:47 AM Larry Finger wrote:
> Drivers that load firmware from their probe routine have problems with the
> latest versions of udev as they get timeouts while waiting for user
> space to start. The problem is fixed by using request_firmware_nowait()
> and delaying the start of mac80211 until the firmware is loaded.
> 
> To prevent the possibility of the driver being unloaded while the firmware
> loading callback is still active, a completion queue entry is used.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
> 
> I will be submitting trial patches for p54pci and p54spi, but I do not have
> the hardware and will not be able to test.
> 
> Larry
That's great. For p54spi we better ask Max <jcmvbkbc@gmail.com> and
maybe Michael <m@bues.ch>.

> ---
> 
>  p54usb.c |  153 ++++++++++++++++++++++++++++++++++++++++++++++-----------------
>  p54usb.h |    3 +
>  2 files changed, 115 insertions(+), 41 deletions(-)
> ---
> 
> Index: wireless-testing-new/drivers/net/wireless/p54/p54usb.c
> ===================================================================
> --- wireless-testing-new.orig/drivers/net/wireless/p54/p54usb.c
> +++ wireless-testing-new/drivers/net/wireless/p54/p54usb.c  
> [...]
> -out:
> +static void p54u_load_firmware_cb(const struct firmware *firmware,
> +				  void *context)
> +{
> +	struct usb_interface *intf = context;
> +	struct ieee80211_hw *dev = usb_get_intfdata(intf);
> +	struct p54u_priv *priv = dev->priv;
> +	struct usb_device *udev = interface_to_usbdev(intf);
> +	struct device *device = &udev->dev;
> +	int i, err;
> +
> +	if (!firmware) {
> +		i = p54_find_type(priv);
> +		if (i < 0)
> +			return;
> +		/* Primary firmware not found - try for legacy variety */
> +		dev_info(&priv->udev->dev, "Loading firmware file %s\n",
> +			 p54u_fwlist[i].fw_legacy);
> +		err = request_firmware_nowait(THIS_MODULE, 1,
> +					      p54u_fwlist[i].fw_legacy,
> +					      device, GFP_KERNEL, intf,
> +					      p54u_load_firmware_cb2);
> +		if (err)
> +			return;
> +	}
> +	complete(&priv->fw_loaded);
> +	priv->fw = firmware;
> +	p54_start_ops(intf);
> +}

are you sure if the "if (err)" is correct? AFAIK request_firmware_nowait
returns 0 when the request is queued so we won't "go through the return"
and the priv->fw will be NULL {which seems kind of odd?}

I think we could do something like:
	err = request_firmware_nowait(THIS_MODULE, 1,
					      p54u_fwlist[i].fw_legacy,
					      device, GFP_KERNEL, intf,
					      p54u_load_firmware_cb2);	

	if (WARN_ON_ONCE(err, "failed to request legacy firmware")) {
		p54u_firmware_load_failed(priv);
	}
	
	return;
}

and 

void p54u_firmware_load_failed(struct p54u_priv *priv)
{
        struct device *parent = priv->udev->dev.parent;
        struct usb_device *udev;

        /*
         * Store a copy of the usb_device pointer locally.
         * This is because device_release_driver initiates
         * p54u_disconnect, which in turn frees our
         * driver context (priv).
         */
        udev = priv->udev;

        complete(&priv->fw_load_wait);

        /* unbind anything failed */
        if (parent)
                device_lock(parent);

        device_release_driver(&udev->dev);
        if (parent)
                device_unlock(parent);

        usb_put_dev(udev);
}

Of course, now we could also modify p54u_load_firmware_cb2 to
call p54u_firmware_load_failed as well.

> +static void p54u_load_firmware_cb2(const struct firmware *firmware,
> +                                  void *context)
> +{
> +       struct usb_interface *intf = context;
> +       struct ieee80211_hw *dev = usb_get_intfdata(intf);
> +       struct p54u_priv *priv = dev->priv;
> +
> +       complete(&priv->fw_loaded);
> +       if (!firmware) {
> +               dev_err(&priv->udev->dev, "Firmware not found\n");

just add:
				p54u_firmware_load_failed(priv);


> +               return;
>         }
> +       priv->fw = firmware;
> +       p54_start_ops(intf);
> +}


> [...]

> +
> +static int p54u_load_firmware(struct ieee80211_hw *dev,
> +			      struct usb_interface *intf)
> +{
> +	struct usb_device *udev = interface_to_usbdev(intf);
> +	struct p54u_priv *priv = dev->priv;
> +	struct device *device = &udev->dev;
> +	int err, i;
> +
> +	BUILD_BUG_ON(ARRAY_SIZE(p54u_fwlist) != __NUM_P54U_HWTYPES);
Yeah, I think I was up all night when I wrote that. The BUILD_BUG_ON is a bit
is completey superfluous.

> +
> +	init_completion(&priv->fw_loaded);
> +	i = p54_find_type(priv);
> +	if (i < 0)
> +		return i;
> +
> +	dev_info(&priv->udev->dev, "Loading firmware file %s\n",
> +	       p54u_fwlist[i].fw);
> +	err = request_firmware_nowait(THIS_MODULE, 1, p54u_fwlist[i].fw,
> +				      device, GFP_KERNEL, intf,
> +				      p54u_load_firmware_cb);
>  	if (err)
> -		release_firmware(priv->fw);
> +		dev_err(&priv->udev->dev, "(p54usb) cannot load firmware %s "
> +					  "(%d)!\n", p54u_fwlist[i].fw, err);
>  
>  	return err;
>  }
> [...]
rest looks good. [Altough, I won't be able to test it in the forthcoming weeks]

Best Regards,
	Chr
