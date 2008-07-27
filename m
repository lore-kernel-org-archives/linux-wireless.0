Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:43044 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752460AbYG0PMD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Jul 2008 11:12:03 -0400
Subject: Re: [PATCH 2/3 RESEND] libertas: add sysfs hooks to update boot2
	and persistent firmware
From: Dan Williams <dcbw@redhat.com>
To: Brian Cavagnolo <brian@cozybit.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	libertas-dev@lists.infradead.org
In-Reply-To: <4884d9e3.1997600a.51e2.fffff1b6@mx.google.com>
References: <4884d9e3.1997600a.51e2.fffff1b6@mx.google.com>
Content-Type: text/plain
Date: Sun, 27 Jul 2008 11:09:43 -0400
Message-Id: <1217171383.2700.17.camel@localhost.localdomain> (sfid-20080727_171206_762254_413C1FC4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-07-21 at 11:03 -0700, Brian Cavagnolo wrote:
> To use these features, copy the boot2 and firmware images to /lib/firmware and:
> 
> echo <boot2_image_name> > /sys/class/net/ethX/lbs_flash_boot2
> echo <firmware_image_name> > /sys/class/net/ethX/lbs_flash_fw
> 
> Signed-off-by: Brian Cavagnolo <brian@cozybit.com>

Acked-by: Dan Williams <dcbw@redhat.com>

> ---
>  drivers/net/wireless/libertas/if_usb.c |   65 ++++++++++++++++++++++++++++++++
>  1 files changed, 65 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/libertas/if_usb.c b/drivers/net/wireless/libertas/if_usb.c
> index 764b285..13c6ec2 100644
> --- a/drivers/net/wireless/libertas/if_usb.c
> +++ b/drivers/net/wireless/libertas/if_usb.c
> @@ -51,6 +51,62 @@ static void if_usb_free(struct if_usb_card *cardp);
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
> +	sscanf(buf, "%29s", fwname); /* FIRMWARE_NAME_MAX - 1 = 29 */
> +	ret = if_usb_prog_firmware(cardp, fwname, BOOT_CMD_UPDATE_FW);
> +	if (ret == 0)
> +		return count;
> +
> +	return ret;
> +}
> +
> +/**
> + * lbs_flash_fw attribute to be exported per ethX interface through sysfs
> + * (/sys/class/net/ethX/lbs_flash_fw).  Use this like so to write firmware to
> + * the device's persistent memory:
> + * echo usb8388-5.126.0.p5.bin > /sys/class/net/ethX/lbs_flash_fw
> + */
> +static DEVICE_ATTR(lbs_flash_fw, 0200, NULL, if_usb_firmware_set);
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
> +	sscanf(buf, "%29s", fwname); /* FIRMWARE_NAME_MAX - 1 = 29 */
> +	ret = if_usb_prog_firmware(cardp, fwname, BOOT_CMD_UPDATE_BOOT2);
> +	if (ret == 0)
> +		return count;
> +
> +	return ret;
> +}
> +
> +/**
> + * lbs_flash_boot2 attribute to be exported per ethX interface through sysfs
> + * (/sys/class/net/ethX/lbs_flash_boot2).  Use this like so to write firmware
> + * to the device's persistent memory:
> + * echo usb8388-5.126.0.p5.bin > /sys/class/net/ethX/lbs_flash_boot2
> + */
> +static DEVICE_ATTR(lbs_flash_boot2, 0200, NULL, if_usb_boot2_set);
> +
>  /**
>   *  @brief  call back function to handle the status of the URB
>   *  @param urb 		pointer to urb structure
> @@ -263,6 +319,12 @@ static int if_usb_probe(struct usb_interface *intf,
>  	usb_get_dev(udev);
>  	usb_set_intfdata(intf, cardp);
>  
> +	if (device_create_file(&priv->dev->dev, &dev_attr_lbs_flash_fw))
> +		lbs_pr_err("cannot register lbs_flash_fw attribute\n");
> +
> +	if (device_create_file(&priv->dev->dev, &dev_attr_lbs_flash_boot2))
> +		lbs_pr_err("cannot register lbs_flash_boot2 attribute\n");
> +
>  	return 0;
>  
>  err_start_card:
> @@ -288,6 +350,9 @@ static void if_usb_disconnect(struct usb_interface *intf)
>  
>  	lbs_deb_enter(LBS_DEB_MAIN);
>  
> +	device_remove_file(&priv->dev->dev, &dev_attr_lbs_flash_boot2);
> +	device_remove_file(&priv->dev->dev, &dev_attr_lbs_flash_fw);
> +
>  	cardp->surprise_removed = 1;
>  
>  	if (priv) {

