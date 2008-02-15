Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from tranquility.mcc.ac.uk ([130.88.200.145]:57840 "EHLO
	tranquility.mcc.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754794AbYBOUFP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Feb 2008 15:05:15 -0500
Message-ID: <47B5F0DC.8000904@gentoo.org> (sfid-20080215_200521_189223_3D4A94F7)
Date: Fri, 15 Feb 2008 20:06:52 +0000
From: Daniel Drake <dsd@gentoo.org>
MIME-Version: 1.0
To: Javier Cardona <javier@cozybit.com>
CC: linux-wireless@vger.kernel.org, Ulrich Kunitz <kune@deine-taler.de>
Subject: Re: [PATCH v2] zd1211rw: debugfs access to internal device registers
References: <47b0c7db.16be600a.5533.50ad@mx.google.com>
In-Reply-To: <47b0c7db.16be600a.5533.50ad@mx.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Javier Cardona wrote:
> Expose the internal CR registers via debugfs, useful for driver development.
> For example, to change the tx power for 54 Mbps frames (CR53):

Thanks for the patch! Looks useful.
Comments inline.
In future please explicitly CC driver maintainers on patch submissions.

> diff --git a/drivers/net/wireless/zd1211rw/zd_chip.h b/drivers/net/wireless/zd1211rw/zd_chip.h
> index e44b9d6..5cffbd6 100644
> --- a/drivers/net/wireless/zd1211rw/zd_chip.h
> +++ b/drivers/net/wireless/zd1211rw/zd_chip.h
> @@ -504,7 +504,7 @@ enum {
>  #define CR_ZD1211_RETRY_MAX		CTL_REG(0x067C)
>  
>  #define CR_REG1				CTL_REG(0x0680)
> -/* Setting the bit UNLOCK_PHY_REGS disallows the write access to physical
> +/* Setting the bit UNLOCK_PHY_REGS disallows access to physical
>   * registers, so one could argue it is a LOCK bit. But calling it
>   * LOCK_PHY_REGS makes it confusing.
>   */
> @@ -750,6 +750,9 @@ struct zd_chip {
>  		patch_cck_gain:1, patch_cr157:1, patch_6m_band_edge:1,
>  		new_phy_layout:1, al2230s_bit:1,
>  		supports_tx_led:1;
> +	struct dentry *debugfs_dir;
> +	struct dentry *debugfs_files[4];
> +	u32 debugfs_cr;
>  };

Should we wrap this in an #ifdef to avoid bloating the structure for 
non-debug builds?

> diff --git a/drivers/net/wireless/zd1211rw/zd_debugfs.c b/drivers/net/wireless/zd1211rw/zd_debugfs.c
> new file mode 100644
> index 0000000..b3ff4cb
> --- /dev/null
> +++ b/drivers/net/wireless/zd1211rw/zd_debugfs.c
> @@ -0,0 +1,187 @@
> +/* ZD1211 USB-WLAN driver for Linux
> + *
> + * Copyright (C) 2005-2007 Ulrich Kunitz <kune@deine-taler.de>
> + * Copyright (C) 2006-2007 Daniel Drake <dsd@gentoo.org>
> + * Copyright (C) 2006-2007 Michael Wu <flamingice@sourmilk.net>
> + * Copyright (c) 2007 Luis R. Rodriguez <mcgrof@winlab.rutgers.edu>

I guess none of those copyrights apply to this file.

> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
> + */
> +
> +/*
> + * Added CR register access via debugfs
> + * Copyright (c) 2008 Javier Cardona <javier@cozybit.com>
> + */
> +
> +#include <linux/module.h>
> +#include <linux/dcache.h>
> +#include <linux/debugfs.h>
> +#include <linux/delay.h>
> +#include <linux/mm.h>
> +#include <linux/string.h>
> +#include <net/iw_handler.h>
> +#include <net/mac80211.h>
> +
> +#include "zd_chip.h"
> +
> +static int open_file_generic(struct inode *inode, struct file *file)
> +{
> +	file->private_data = inode->i_private;
> +	return 0;
> +}
> +
> +static const size_t len = PAGE_SIZE;

Why not use PAGE_SIZE everywhere?

> +static ssize_t zd_rdcr_read(struct file *file, char __user *userbuf,
> +				  size_t count, loff_t *ppos)
> +{
> +	struct zd_chip *chip = file->private_data;
> +	zd_addr_t regaddr;
> +	u16 val;
> +	ssize_t pos = 0;
> +	int ret;
> +	unsigned long addr = get_zeroed_page(GFP_KERNEL);
> +	char *buf = (char *)addr;
> +
> +	regaddr = 0xffff & CTL_REG(chip->debugfs_cr << 2);
> +	val = 0;

This is making the incorrect assumption that numbered control registers 
are in numerical order. Check the addresses for CR1 through CR10...

> +	mutex_lock(&chip->mutex);
> +	zd_chip_lock_phy_regs(chip);
> +	ret = zd_ioread16_locked(chip, &val, regaddr);
> +	zd_chip_unlock_phy_regs(chip);
> +	mutex_unlock(&chip->mutex);
> +
> +	if (!ret)
> +		pos += snprintf(buf+pos, len-pos, "CR%d [0x%x] = 0x%02x\n",
> +				chip->debugfs_cr, regaddr, val);
> +	else {
> +		pos += snprintf(buf+pos, len-pos, "read error CR%d: %d\n",
> +				chip->debugfs_cr, ret);
> +		pos += snprintf(buf+pos, len-pos, "is interface up?\n");
> +	}
> +
> +	ret = simple_read_from_buffer(userbuf, count, ppos, buf, pos);
> +	free_page(addr);
> +	return ret;
> +}
> +
> +static ssize_t zd_rdcr_write(struct file *file,
> +				    const char __user *userbuf,
> +				    size_t count, loff_t *ppos)
> +{
> +	struct zd_chip *chip = file->private_data;
> +	ssize_t res, buf_size;
> +	unsigned long addr = get_zeroed_page(GFP_KERNEL);
> +	char *buf = (char *)addr;
> +
> +	buf_size = min(count, len - 1);
> +	if (copy_from_user(buf, userbuf, buf_size)) {
> +		res = -EFAULT;
> +		goto out_unlock;
> +	}
> +	chip->debugfs_cr = simple_strtoul((char *)buf, NULL, 10);
> +	res = count;
> +out_unlock:
> +	free_page(addr);
> +	return res;
> +}
> +
> +static ssize_t zd_wrcr_write(struct file *file,
> +				    const char __user *userbuf,
> +				    size_t count, loff_t *ppos)
> +{
> +
> +	struct zd_chip *chip = file->private_data;
> +	ssize_t res, buf_size;
> +	u32 val;
> +	u16 regaddr;
> +	unsigned long addr = get_zeroed_page(GFP_KERNEL);
> +	char *buf = (char *)addr;
> +
> +	buf_size = min(count, len - 1);
> +	if (copy_from_user(buf, userbuf, buf_size)) {
> +		res = -EFAULT;
> +		goto out_unlock;
> +	}
> +	res = sscanf(buf, "%d %x", &chip->debugfs_cr, &val);
> +	if (res != 2) {
> +		res = -EFAULT;
> +		goto out_unlock;
> +	}
> +
> +	regaddr = 0xffff & CTL_REG(chip->debugfs_cr << 2);
> +
> +	mutex_lock(&chip->mutex);
> +	zd_chip_lock_phy_regs(chip);
> +	zd_iowrite16_locked(chip, val, regaddr);
> +	zd_chip_unlock_phy_regs(chip);
> +	mutex_unlock(&chip->mutex);
> +
> +	res = count;
> +out_unlock:
> +	free_page(addr);
> +	return res;
> +}
> +
> +#define FOPS(fread, fwrite) { \
> +	.owner = THIS_MODULE, \
> +	.open = open_file_generic, \
> +	.read = (fread), \
> +	.write = (fwrite), \
> +}
> +
> +struct zd_debugfs_files {
> +	char *name;
> +	int perm;
> +	struct file_operations fops;
> +};
> +
> +/* check the size of chip->debugfs_files array before adding to this */
> +static struct zd_debugfs_files debugfs_files[] = {
> +	{ "rdcr", 0644, FOPS(zd_rdcr_read, zd_rdcr_write), },
> +	{ "wrcr", 0600, FOPS(NULL, zd_wrcr_write), },
> +};
> +
> +void zd_debugfs_init(struct zd_chip *chip, struct wiphy *wiphy)
> +{
> +	int i;
> +	struct zd_debugfs_files *files;
> +
> +	chip->debugfs_dir = debugfs_create_dir("registers" , wiphy->debugfsdir);
> +	if (!chip->debugfs_dir)
> +		goto exit;
> +
> +	for (i = 0; i < ARRAY_SIZE(debugfs_files); i++) {
> +		files = &debugfs_files[i];
> +		chip->debugfs_files[i] = debugfs_create_file(files->name,
> +				files->perm, chip->debugfs_dir, chip,
> +				&files->fops);
> +	}
> +exit:
> +	return;
> +}
> +EXPORT_SYMBOL(zd_debugfs_init);

Probably should be _GPL?

> +void zd_debugfs_remove(struct zd_chip *chip)
> +{
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(debugfs_files); i++)
> +		debugfs_remove(chip->debugfs_files[i]);
> +
> +	debugfs_remove(chip->debugfs_dir);
> +}
> +EXPORT_SYMBOL(zd_debugfs_remove);

same

> diff --git a/drivers/net/wireless/zd1211rw/zd_debugfs.h b/drivers/net/wireless/zd1211rw/zd_debugfs.h
> new file mode 100644
> index 0000000..2cacf9f
> --- /dev/null
> +++ b/drivers/net/wireless/zd1211rw/zd_debugfs.h
> @@ -0,0 +1,7 @@

GPL header here please (if this is worth having its own header file?)

> +#ifndef _ZD_DEBUGFS_H_
> +#define _ZD_DEBUGFS_H_
> +
> +void zd_debugfs_init(struct zd_chip *chip, struct wiphy *wiphy);
> +void zd_debugfs_remove(struct zd_chip *chip);
> +
> +#endif
> diff --git a/drivers/net/wireless/zd1211rw/zd_usb.c b/drivers/net/wireless/zd1211rw/zd_usb.c
> index e34675c..00a24e7 100644
> --- a/drivers/net/wireless/zd1211rw/zd_usb.c
> +++ b/drivers/net/wireless/zd1211rw/zd_usb.c
> @@ -33,6 +33,7 @@
>  #include "zd_def.h"
>  #include "zd_mac.h"
>  #include "zd_usb.h"
> +#include "zd_debugfs.h"
>  
>  static struct usb_device_id usb_ids[] = {
>  	/* ZD1211 */
> @@ -1167,6 +1168,7 @@ static int probe(struct usb_interface *intf, const struct usb_device_id *id)
>  			 "couldn't register device. Error number %d\n", r);
>  		goto error;
>  	}
> +	zd_debugfs_init(&zd_hw_mac(hw)->chip, hw->wiphy);
>  
>  	dev_dbg_f(&intf->dev, "successful\n");
>  	dev_info(&intf->dev, "%s\n", wiphy_name(hw->wiphy));
> @@ -1196,6 +1198,7 @@ static void disconnect(struct usb_interface *intf)
>  
>  	dev_dbg_f(zd_usb_dev(usb), "\n");
>  
> +	zd_debugfs_remove(&mac->chip);
>  	ieee80211_unregister_hw(hw);
>  
>  	/* Just in case something has gone wrong! */

This will cause a compile failure for the non-debug builds, right? I 
expected to see some stub functions somewhere.

Also I feel that such calls should be outside the USB layer, perhaps in 
the MAC or chip initialization instead?

Thanks,
Daniel
