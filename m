Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yh0-f54.google.com ([209.85.213.54]:57221 "EHLO
	mail-yh0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030212Ab3BNUZ5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Feb 2013 15:25:57 -0500
Received: by mail-yh0-f54.google.com with SMTP id 29so414070yhr.41
        for <linux-wireless@vger.kernel.org>; Thu, 14 Feb 2013 12:25:56 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1360872580-24334-2-git-send-email-pizza@shaftnet.org>
References: <1360872580-24334-1-git-send-email-pizza@shaftnet.org>
	<1360872580-24334-2-git-send-email-pizza@shaftnet.org>
Date: Thu, 14 Feb 2013 21:25:56 +0100
Message-ID: <CAOZOX0Vva3ObJp6hW85i6m33zYxieTsbER78UVrp23uo=t4B9A@mail.gmail.com> (sfid-20130214_212600_979314_9C4A088E)
Subject: Re: [PATCH] rt2800usb: Add support for eeprom writes.
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Solomon Peachy <pizza@shaftnet.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Solomon Peachy <speachy@sagrad.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> diff --git a/drivers/net/wireless/rt2x00/rt2x00debug.c b/drivers/net/wireless/rt2x00/rt2x00debug.c
> index 3bb8caf..f6776b1 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00debug.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00debug.c
> @@ -86,6 +86,7 @@ struct rt2x00debug_intf {
>         struct dentry *csr_val_entry;
>         struct dentry *eeprom_off_entry;
>         struct dentry *eeprom_val_entry;
> +       struct dentry *eeprom_commit_entry;

This is incorrect, all other debugfs files are read/write, so there is
no point in a extra commit file.

> @@ -650,6 +651,37 @@ static struct dentry *rt2x00debug_create_file_chipset(const char *name,
>         return debugfs_create_blob(name, S_IRUSR, intf->driver_folder, blob);
>  }
>
> +#include "rt2800lib.h"

So here we make the _generic_ rt2x00lib module be specific for rt2800 only.
That is a terrible idea.

> +static ssize_t rt2x00debug_eeprom_commit_write(struct file *file,
> +                                              const char __user *buf,
> +                                              size_t length,
> +                                              loff_t *offset)
> +{
> +       struct rt2x00debug_intf *intf = file->private_data;
> +
> +       rt2800_write_eeprom(intf->rt2x00dev);
> +       return length;
> +}
> +static ssize_t rt2x00debug_eeprom_commit_read(struct file *file,
> +                                             char __user *buf,
> +                                             size_t length,
> +                                             loff_t *offset)
> +{
> +       struct rt2x00debug_intf *intf = file->private_data;
> +
> +       rt2800_read_eeprom(intf->rt2x00dev);
> +       return 0;
> +}

rt2800 specific code doesn't belong in the generic code. You should
make your solution
completely driver independent.

>  /**
> + * rt2x00usb_eeprom_write - Write eeprom to device
> + * @rt2x00dev: Pointer to &struct rt2x00_dev
> + * @eeprom: Pointer to eeprom array to copy the information from
> + * @length: Number of bytes to write to the eeprom
> + *
> + * Simple wrapper around rt2x00usb_vendor_request to write the eeprom
> + * to the device. Note that the eeprom argument _must_ be allocated using
> + * kmalloc for correct handling inside the kernel USB layer.
> + */
> +static inline int rt2x00usb_eeprom_write(struct rt2x00_dev *rt2x00dev,
> +                                        __le16 *eeprom, const u16 length)
> +{
> +       return rt2x00usb_vendor_request(rt2x00dev, USB_EEPROM_WRITE,
> +                                       USB_VENDOR_REQUEST_OUT, 0, 0,
> +                                       eeprom, length,
> +                                       REGISTER_TIMEOUT16(length));
> +}

Have you checked if this is specific to rt2800 or would other Ralink USB devices
be able to work with this as well?

Ivo
