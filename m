Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:52032 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751342Ab0CUJkg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Mar 2010 05:40:36 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] ssb: Implement virtual SPROM on disk
Date: Sun, 21 Mar 2010 10:40:30 +0100
Cc: John W Linville <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <4ba564fb.PfAZePu8tStyxs44%Larry.Finger@lwfinger.net>
In-Reply-To: <4ba564fb.PfAZePu8tStyxs44%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201003211040.31118.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 21 March 2010 01:14:51 Larry Finger wrote:
> Some recent BCM43XX devices lack an on-board SPROM. The pertinent data
> from the SPROM could be included in the kernel; however, this presents
> a problem in the generation of a unique, reproducible MAC address. The
> solution has been to create a utility that generates a virtual SPROM
> image with a random MAC address. This image is stored in the firmware
> area, and loaded using the asyncronous firmware load facility.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
> 
> Michael,
> 
> I think this patch eliminates the need for the fallback sprom code; however,
> I have not touched that facility yet.
> 
> Larry
> ---
> 
> Index: wireless-testing/drivers/ssb/pci.c
> ===================================================================
> --- wireless-testing.orig/drivers/ssb/pci.c
> +++ wireless-testing/drivers/ssb/pci.c
> @@ -19,6 +19,7 @@
>  #include <linux/ssb/ssb_regs.h>
>  #include <linux/pci.h>
>  #include <linux/delay.h>
> +#include <linux/firmware.h>
>  
>  #include "ssb_private.h"
>  
> @@ -613,6 +614,39 @@ static int sprom_extract(struct ssb_bus
>  	return 0;
>  }
>  
> +static int ssb_get_vsprom(struct device *dev, u16 *buf, size_t size)
> +{
> +	/* Use the firmware load facility to get the disk image of an SPROM */
> +	const struct firmware *blob;
> +	int err;
> +	int i;
> +
> +	err = request_firmware(&blob, "ssb/vsprom_image", dev);

Well, this has the problem every synchronous firmware fetching mechanism has:
bootup with builtin module.
I think it should be done asynchronously.

> +	if (err) {
> +		printk(KERN_ERR "ssb: The BCM43XX device does not have an "
> +		       "SPROM built in, and the virtual SPROM file is not"
> +		       " available.\n");
> +		printk(KERN_ERR "ssb: Please go to "
> +		       "http://wireless.kernel.org/en/users/Drivers/b43 "
> +		       "and download the utility to create the file.\n");
> +		return err;
> +	}
> +	if (blob->size != size * 2) {
> +		printk(KERN_ERR "ssb: The virtual SPROM file has the wrong"
> +		       " size\n");
> +		return -ENOENT;
> +	}
> +	for (i = 0; i < size; i++)
> +		buf[i] = blob->data[2 * i + 1] << 8 | blob->data[2 * i];
> +	err = sprom_check_crc(buf, size);
> +	if (err) {
> +		printk(KERN_ERR "ssb: Invalid CRC for virtual SPROM\n");
> +		return err;
> +	}
> +
> +	return 0;
> +}
> +
>  static int ssb_pci_sprom_get(struct ssb_bus *bus,
>  			     struct ssb_sprom *sprom)
>  {
> @@ -620,8 +654,18 @@ static int ssb_pci_sprom_get(struct ssb_
>  	int err = -ENOMEM;
>  	u16 *buf;
>  
> -	if (!ssb_is_sprom_available(bus))
> -		return -ENODEV;
> +	if (!ssb_is_sprom_available(bus)) {
> +		buf = kcalloc(SSB_SPROMSIZE_WORDS_R4, sizeof(u16),
> +			      GFP_KERNEL);
> +		if (!buf)
> +			return -ENOMEM;
> +		bus->sprom_size = SSB_SPROMSIZE_WORDS_R4;
> +		if (ssb_get_vsprom(&bus->host_pci->dev, buf, bus->sprom_size)) {
> +			err = -ENODEV;
> +			goto out_free;
> +		}
> +		goto extract;
> +	}
>  
>  	buf = kcalloc(SSB_SPROMSIZE_WORDS_R123, sizeof(u16), GFP_KERNEL);
>  	if (!buf)
> @@ -653,6 +697,7 @@ static int ssb_pci_sprom_get(struct ssb_
>  				   " SPROM CRC (corrupt SPROM)\n");
>  		}
>  	}
> +extract:
>  	err = sprom_extract(bus, sprom, buf, bus->sprom_size);
>  
>  out_free:
> 
> 

-- 
Greetings, Michael.
