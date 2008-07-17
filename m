Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:58468 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753543AbYGQR4m (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jul 2008 13:56:42 -0400
Subject: Re: [PATCH 2/3] libertas: add sysfs hooks to update boot2 and
	persistent firmware
From: Dan Williams <dcbw@redhat.com>
To: Brian Cavagnolo <brian@cozybit.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	libertas-dev@lists.infradead.org
In-Reply-To: <487f84b8.29578c0a.46a7.5cef@mx.google.com>
References: <487f84b8.29578c0a.46a7.5cef@mx.google.com>
Content-Type: text/plain
Date: Thu, 17 Jul 2008 13:54:45 -0400
Message-Id: <1216317285.23645.18.camel@localhost.localdomain> (sfid-20080717_195646_125523_ED4C2215)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-07-16 at 10:28 -0700, Brian Cavagnolo wrote:
> To use these features, copy the boot2 and firmware images to /lib/firmware and:
> 
> echo <boot2_image_name> > /sys/class/net/ethX/lbs_boot2
> echo <firmware_image_name> > /sys/class/net/ethX/lbs_fw

Perhaps "lbs_flash_boot2" and "lbs_flash_fw" would be better names here?
Otherwise it looks like one of the drivers that you can choose alternate
firmware for (atmel.c for example) and doesn't give any indication that
it'll permanently change what's on the dongle.

Dan

> Signed-off-by: Brian Cavagnolo <brian@cozybit.com>
> ---
>  drivers/net/wireless/libertas/if_usb.c |   71 ++++++++++++++++++++++++++++++++
>  1 files changed, 71 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/libertas/if_usb.c b/drivers/net/wireless/libertas/if_usb.c
> index e83a4c2..c89785c 100644
> --- a/drivers/net/wireless/libertas/if_usb.c
> +++ b/drivers/net/wireless/libertas/if_usb.c
> @@ -51,6 +51,68 @@ static void if_usb_free(struct if_usb_card *cardp);
>  static int if_usb_submit_rx_urb(struct if_usb_card *cardp);
>  static int if_usb_reset_device(struct if_usb_card *cardp);
>  
> +/* sysfs hooks */
> +
> +/**
> + *  Set function to write firmware to device's persistent memory
> + */
> +static ssize_t if_usb_firmware_set(struct device *dev,
> +		struct device_attribute *attr, const char *buf, size_t count)
> +{
> +	struct lbs_private *priv = to_net_dev(dev)->priv;
> +	struct if_usb_card *cardp = priv->card;
> +	char fwname[FIRMWARE_NAME_MAX];
> +	int ret;
> +
> +	if (!(priv->fwcapinfo & FW_CAPINFO_FIRMWARE_UPGRADE))
> +		return -EOPNOTSUPP;
> +
> +	sscanf(buf, "%29s", fwname); /* FIRMWARE_NAME_MAX - 1 = 29 */
> +	ret = if_usb_prog_firmware(cardp, fwname, BOOT_CMD_UPDATE_FW);
> +	if (ret == 0)
> +		return count;
> +
> +	return ret;
> +}
> +
> +/**
> + * lbs_fw attribute to be exported per ethX interface through sysfs
> + * (/sys/class/net/ethX/lbs_fw).  Use this like so to write firmware to the
> + * device's persistent memory:
> + * echo usb8388-5.126.0.p5.bin > /sys/class/net/ethX/lbs_fw
> + */
> +static DEVICE_ATTR(lbs_fw, 0200, NULL, if_usb_firmware_set);
> +
> +/**
> + *  Set function to write firmware to device's persistent memory
> + */
> +static ssize_t if_usb_boot2_set(struct device *dev,
> +		struct device_attribute *attr, const char *buf, size_t count)
> +{
> +	struct lbs_private *priv = to_net_dev(dev)->priv;
> +	struct if_usb_card *cardp = priv->card;
> +	char fwname[FIRMWARE_NAME_MAX];
> +	int ret;
> +
> +	if (!(priv->fwcapinfo & FW_CAPINFO_BOOT2_UPGRADE))
> +		return -EOPNOTSUPP;
> +
> +	sscanf(buf, "%29s", fwname); /* FIRMWARE_NAME_MAX - 1 = 29 */
> +	ret = if_usb_prog_firmware(cardp, fwname, BOOT_CMD_UPDATE_BOOT2);
> +	if (ret == 0)
> +		return count;
> +
> +	return ret;
> +}
> +
> +/**
> + * lbs_boot2 attribute to be exported per ethX interface through sysfs
> + * (/sys/class/net/ethX/lbs_boot2).  Use this like so to write firmware to the
> + * device's persistent memory:
> + * echo usb8388-5.126.0.p5.bin > /sys/class/net/ethX/lbs_boot2
> + */
> +static DEVICE_ATTR(lbs_boot2, 0200, NULL, if_usb_boot2_set);
> +
>  /**
>   *  @brief  call back function to handle the status of the URB
>   *  @param urb 		pointer to urb structure
> @@ -263,6 +325,12 @@ static int if_usb_probe(struct usb_interface *intf,
>  	usb_get_dev(udev);
>  	usb_set_intfdata(intf, cardp);
>  
> +	if (device_create_file(&priv->dev->dev, &dev_attr_lbs_fw))
> +		lbs_pr_err("cannot register lbs_fw attribute\n");
> +
> +	if (device_create_file(&priv->dev->dev, &dev_attr_lbs_boot2))
> +		lbs_pr_err("cannot register lbs_boot2 attribute\n");
> +
>  	return 0;
>  
>  err_start_card:
> @@ -288,6 +356,9 @@ static void if_usb_disconnect(struct usb_interface *intf)
>  
>  	lbs_deb_enter(LBS_DEB_MAIN);
>  
> +	device_remove_file(&priv->dev->dev, &dev_attr_lbs_boot2);
> +	device_remove_file(&priv->dev->dev, &dev_attr_lbs_fw);
> +
>  	cardp->surprise_removed = 1;
>  
>  	if (priv) {

