Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1976 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753655Ab3GINWg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jul 2013 09:22:36 -0400
Message-ID: <51DC0E91.2020604@broadcom.com> (sfid-20130709_152240_413511_1373E90E)
Date: Tue, 9 Jul 2013 15:22:25 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Jeffrey (Sheng-Hui) Chu" <jeffchu@broadcom.com>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Samuel Ortiz" <sameo@linux.intel.com>
Subject: Re:
References: <90AC93A0CCA054488FFC508D6F62B6F40FED489B@IRVEXCHMB07.corp.ad.broadcom.com>
In-Reply-To: <90AC93A0CCA054488FFC508D6F62B6F40FED489B@IRVEXCHMB07.corp.ad.broadcom.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

+ Samuel

On 07/08/2013 11:52 PM, Jeffrey (Sheng-Hui) Chu wrote:
>  From b4555081b1d27a31c22abede8e0397f1d61fbb04 Mon Sep 17 00:00:00 2001
> From: Jeffrey Chu <jeffchu@broadcom.com>
> Date: Mon, 8 Jul 2013 17:50:21 -0400
> Subject: [PATCH] Add bcm2079x-i2c driver for Bcm2079x NFC Controller.

The subject did not show in my mailbox. Not sure if necessary, but I 
tend to send patches to a maintainer and CC the appropriate list(s). So 
the nfc list as well (linux-nfc@lists.01.org).

Regards,
Arend

> Signed-off-by: Jeffrey Chu <jeffchu@broadcom.com>
> ---
>   drivers/nfc/Kconfig                 |    1 +
>   drivers/nfc/Makefile                |    1 +
>   drivers/nfc/bcm2079x/Kconfig        |   10 +
>   drivers/nfc/bcm2079x/Makefile       |    4 +
>   drivers/nfc/bcm2079x/bcm2079x-i2c.c |  416 +++++++++++++++++++++++++++++++++++
>   drivers/nfc/bcm2079x/bcm2079x.h     |   34 +++
>   6 files changed, 466 insertions(+)
>   create mode 100644 drivers/nfc/bcm2079x/Kconfig
>   create mode 100644 drivers/nfc/bcm2079x/Makefile
>   create mode 100644 drivers/nfc/bcm2079x/bcm2079x-i2c.c
>   create mode 100644 drivers/nfc/bcm2079x/bcm2079x.h
>
> diff --git a/drivers/nfc/Kconfig b/drivers/nfc/Kconfig
> index 74a852e..fa540f4 100644
> --- a/drivers/nfc/Kconfig
> +++ b/drivers/nfc/Kconfig
> @@ -38,5 +38,6 @@ config NFC_MEI_PHY
>
>   source "drivers/nfc/pn544/Kconfig"
>   source "drivers/nfc/microread/Kconfig"
> +source "drivers/nfc/bcm2079x/Kconfig"
>
>   endmenu
> diff --git a/drivers/nfc/Makefile b/drivers/nfc/Makefile
> index aa6bd65..a56adf6 100644
> --- a/drivers/nfc/Makefile
> +++ b/drivers/nfc/Makefile
> @@ -7,5 +7,6 @@ obj-$(CONFIG_NFC_MICROREAD)	+= microread/
>   obj-$(CONFIG_NFC_PN533)		+= pn533.o
>   obj-$(CONFIG_NFC_WILINK)	+= nfcwilink.o
>   obj-$(CONFIG_NFC_MEI_PHY)	+= mei_phy.o
> +obj-$(CONFIG_NFC_PN544)		+= bcm2079x/

I suspect this is a copy-paste error right? Should be 
obj-$(CONFIG_NFC_BCM2079X_I2C).

>
>   ccflags-$(CONFIG_NFC_DEBUG) := -DDEBUG
> diff --git a/drivers/nfc/bcm2079x/Kconfig b/drivers/nfc/bcm2079x/Kconfig
> new file mode 100644
> index 0000000..889e181
> --- /dev/null
> +++ b/drivers/nfc/bcm2079x/Kconfig
> @@ -0,0 +1,10 @@
> +config NFC_BCM2079X_I2C
> +	tristate "NFC BCM2079x i2c support"
> +	depends on I2C
> +	default n
> +	---help---
> +	  Broadcom BCM2079x i2c driver.
> +	  This is a driver that allows transporting NCI/HCI command and response
> +	  to/from Broadcom bcm2079x NFC Controller.  Select this if your
> +	  platform is using i2c bus to controll this chip.
> +
> diff --git a/drivers/nfc/bcm2079x/Makefile b/drivers/nfc/bcm2079x/Makefile
> new file mode 100644
> index 0000000..be64d35
> --- /dev/null
> +++ b/drivers/nfc/bcm2079x/Makefile
> @@ -0,0 +1,4 @@
> +#
> +# Makefile for bcm2079x NFC driver
> +#
> +obj-$(CONFIG_NFC_BCM2079X_I2C) += bcm2079x-i2c.o
> diff --git a/drivers/nfc/bcm2079x/bcm2079x-i2c.c b/drivers/nfc/bcm2079x/bcm2079x-i2c.c
> new file mode 100644
> index 0000000..988a65e
> --- /dev/null
> +++ b/drivers/nfc/bcm2079x/bcm2079x-i2c.c
> @@ -0,0 +1,416 @@
> +/*
> + * Copyright (C) 2013 Broadcom Corporation.
> + *
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
> + * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> + *
> + */
> +
> +#include <linux/module.h>
> +#include <linux/fs.h>
> +#include <linux/slab.h>
> +#include <linux/i2c.h>
> +#include <linux/irq.h>
> +#include <linux/interrupt.h>
> +#include <linux/gpio.h>
> +#include <linux/miscdevice.h>
> +#include <linux/spinlock.h>
> +#include <linux/poll.h>
> +
> +#include "bcm2079x.h"
> +
> +/* do not change below */
> +#define MAX_BUFFER_SIZE		780
> +
> +/* Read data */
> +#define PACKET_HEADER_SIZE_NCI	(4)
> +#define PACKET_HEADER_SIZE_HCI	(3)
> +#define PACKET_TYPE_NCI		(16)
> +#define PACKET_TYPE_HCIEV	(4)
> +#define MAX_PACKET_SIZE		(PACKET_HEADER_SIZE_NCI + 255)
> +
> +struct bcm2079x_dev {
> +	wait_queue_head_t read_wq;
> +	struct mutex read_mutex;
> +	struct i2c_client *client;
> +	struct miscdevice bcm2079x_device;
> +	unsigned int wake_gpio;
> +	unsigned int en_gpio;
> +	unsigned int irq_gpio;
> +	bool irq_enabled;
> +	spinlock_t irq_enabled_lock;
> +	unsigned int count_irq;
> +};
> +
> +static void bcm2079x_init_stat(struct bcm2079x_dev *bcm2079x_dev)
> +{
> +	bcm2079x_dev->count_irq = 0;
> +}
> +
> +static void bcm2079x_disable_irq(struct bcm2079x_dev *bcm2079x_dev)
> +{
> +	unsigned long flags;
> +	spin_lock_irqsave(&bcm2079x_dev->irq_enabled_lock, flags);
> +	if (bcm2079x_dev->irq_enabled) {
> +		disable_irq_nosync(bcm2079x_dev->client->irq);
> +		bcm2079x_dev->irq_enabled = false;
> +	}
> +	spin_unlock_irqrestore(&bcm2079x_dev->irq_enabled_lock, flags);
> +}
> +
> +static void bcm2079x_enable_irq(struct bcm2079x_dev *bcm2079x_dev)
> +{
> +	unsigned long flags;
> +	spin_lock_irqsave(&bcm2079x_dev->irq_enabled_lock, flags);
> +	if (!bcm2079x_dev->irq_enabled) {
> +		bcm2079x_dev->irq_enabled = true;
> +		enable_irq(bcm2079x_dev->client->irq);
> +	}
> +	spin_unlock_irqrestore(&bcm2079x_dev->irq_enabled_lock, flags);
> +}
> +
> +static void set_client_addr(struct bcm2079x_dev *bcm2079x_dev, int addr)
> +{
> +	struct i2c_client *client = bcm2079x_dev->client;
> +	dev_info(&client->dev,
> +		"Set client device address from 0x%04X flag = "
> +		"%02x, to  0x%04X\n",
> +		client->addr, client->flags, addr);
> +		client->addr = addr;
> +		if (addr < 0x80)
> +			client->flags &= ~I2C_CLIENT_TEN;
> +		else
> +			client->flags |= I2C_CLIENT_TEN;
> +}
> +
> +static irqreturn_t bcm2079x_dev_irq_handler(int irq, void *dev_id)
> +{
> +	struct bcm2079x_dev *bcm2079x_dev = dev_id;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&bcm2079x_dev->irq_enabled_lock, flags);
> +	bcm2079x_dev->count_irq++;
> +	spin_unlock_irqrestore(&bcm2079x_dev->irq_enabled_lock, flags);
> +	wake_up(&bcm2079x_dev->read_wq);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static unsigned int bcm2079x_dev_poll(struct file *filp, poll_table *wait)
> +{
> +	struct bcm2079x_dev *bcm2079x_dev = filp->private_data;
> +	unsigned int mask = 0;
> +	unsigned long flags;
> +
> +	poll_wait(filp, &bcm2079x_dev->read_wq, wait);
> +
> +	spin_lock_irqsave(&bcm2079x_dev->irq_enabled_lock, flags);
> +	if (bcm2079x_dev->count_irq > 0) {
> +		bcm2079x_dev->count_irq--;
> +		mask |= POLLIN | POLLRDNORM;
> +	}
> +	spin_unlock_irqrestore(&bcm2079x_dev->irq_enabled_lock, flags);
> +
> +	return mask;
> +}
> +
> +static ssize_t bcm2079x_dev_read(struct file *filp, char __user *buf,
> +					size_t count, loff_t *offset)
> +{
> +	struct bcm2079x_dev *bcm2079x_dev = filp->private_data;
> +	unsigned char tmp[MAX_BUFFER_SIZE];
> +	int total, len, ret;
> +
> +	total = 0;
> +	len = 0;
> +
> +	if (count > MAX_BUFFER_SIZE)
> +		count = MAX_BUFFER_SIZE;
> +
> +	mutex_lock(&bcm2079x_dev->read_mutex);
> +
> +	/* Read the first 4 bytes to include the length of the NCI or
> +		HCI packet.*/
> +	ret = i2c_master_recv(bcm2079x_dev->client, tmp, 4);
> +	if (ret == 4) {
> +		total = ret;
> +		/* First byte is the packet type*/
> +		switch (tmp[0]) {
> +		case PACKET_TYPE_NCI:
> +			len = tmp[PACKET_HEADER_SIZE_NCI-1];
> +			break;
> +
> +		case PACKET_TYPE_HCIEV:
> +			len = tmp[PACKET_HEADER_SIZE_HCI-1];
> +			if (len == 0)
> +				total--;
> +			else
> +				len--;
> +			break;
> +
> +		default:
> +			len = 0;/*Unknown packet byte */
> +			break;
> +		} /* switch*/
> +
> +		/* make sure full packet fits in the buffer*/
> +		if (len > 0 && (len + total) <= count) {
> +			/** read the remainder of the packet.
> +			**/
> +			ret = i2c_master_recv(bcm2079x_dev->client, tmp+total,
> +				len);
> +			if (ret == len)
> +				total += len;
> +		} /* if */
> +	} /* if */
> +
> +	mutex_unlock(&bcm2079x_dev->read_mutex);
> +
> +	if (total > count || copy_to_user(buf, tmp, total)) {
> +		dev_err(&bcm2079x_dev->client->dev,
> +			"failed to copy to user space, total = %d\n", total);
> +		total = -EFAULT;
> +	}
> +
> +	return total;
> +}
> +
> +static ssize_t bcm2079x_dev_write(struct file *filp, const char __user *buf,
> +					size_t count, loff_t *offset)
> +{
> +	struct bcm2079x_dev *bcm2079x_dev = filp->private_data;
> +	char tmp[MAX_BUFFER_SIZE];
> +	int ret;
> +
> +	if (count > MAX_BUFFER_SIZE) {
> +		dev_err(&bcm2079x_dev->client->dev, "out of memory\n");
> +		return -ENOMEM;
> +	}
> +
> +	if (copy_from_user(tmp, buf, count)) {
> +		dev_err(&bcm2079x_dev->client->dev,
> +			"failed to copy from user space\n");
> +		return -EFAULT;
> +	}
> +
> +	mutex_lock(&bcm2079x_dev->read_mutex);
> +	/* Write data */
> +
> +	ret = i2c_master_send(bcm2079x_dev->client, tmp, count);
> +	if (ret != count) {
> +		dev_err(&bcm2079x_dev->client->dev,
> +			"failed to write %d\n", ret);
> +		ret = -EIO;
> +	}
> +	mutex_unlock(&bcm2079x_dev->read_mutex);
> +
> +	return ret;
> +}
> +
> +static int bcm2079x_dev_open(struct inode *inode, struct file *filp)
> +{
> +	int ret = 0;
> +
> +	struct bcm2079x_dev *bcm2079x_dev = container_of(filp->private_data,
> +							struct bcm2079x_dev,
> +							bcm2079x_device);
> +	filp->private_data = bcm2079x_dev;
> +	bcm2079x_init_stat(bcm2079x_dev);
> +	bcm2079x_enable_irq(bcm2079x_dev);
> +	dev_info(&bcm2079x_dev->client->dev,
> +		 "%d,%d\n", imajor(inode), iminor(inode));
> +
> +	return ret;
> +}
> +
> +static long bcm2079x_dev_unlocked_ioctl(struct file *filp,
> +					 unsigned int cmd, unsigned long arg)
> +{
> +	struct bcm2079x_dev *bcm2079x_dev = filp->private_data;
> +
> +	switch (cmd) {
> +	case BCMNFC_POWER_CTL:
> +		gpio_set_value(bcm2079x_dev->en_gpio, arg);
> +		break;
> +	case BCMNFC_WAKE_CTL:
> +		gpio_set_value(bcm2079x_dev->wake_gpio, arg);
> +		break;
> +	case BCMNFC_SET_ADDR:
> +		set_client_addr(bcm2079x_dev, arg);
> +		break;
> +	default:
> +		dev_err(&bcm2079x_dev->client->dev,
> +			"%s, unknown cmd (%x, %lx)\n", __func__, cmd, arg);
> +		return -ENOSYS;
> +	}
> +
> +	return 0;
> +}
> +
> +static const struct file_operations bcm2079x_dev_fops = {
> +	.owner = THIS_MODULE,
> +	.llseek = no_llseek,
> +	.poll = bcm2079x_dev_poll,
> +	.read = bcm2079x_dev_read,
> +	.write = bcm2079x_dev_write,
> +	.open = bcm2079x_dev_open,
> +	.unlocked_ioctl = bcm2079x_dev_unlocked_ioctl
> +};
> +
> +static int bcm2079x_probe(struct i2c_client *client,
> +				const struct i2c_device_id *id)
> +{
> +	int ret;
> +	struct bcm2079x_platform_data *platform_data;
> +	struct bcm2079x_dev *bcm2079x_dev;
> +
> +	platform_data = client->dev.platform_data;
> +
> +	dev_info(&client->dev, "%s, probing bcm2079x driver flags = %x\n",
> +		__func__, client->flags);
> +	if (platform_data == NULL) {
> +		dev_err(&client->dev, "nfc probe fail\n");
> +		return -ENODEV;
> +	}
> +
> +	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C)) {
> +		dev_err(&client->dev, "need I2C_FUNC_I2C\n");
> +		return -ENODEV;
> +	}
> +
> +	ret = gpio_request_one(platform_data->irq_gpio, GPIOF_IN, "nfc_irq");
> +	if (ret)
> +		return -ENODEV;
> +	ret = gpio_request_one(platform_data->en_gpio, GPIOF_OUT_INIT_LOW,
> +		"nfc_en");
> +	if (ret)
> +		goto err_en;
> +	ret = gpio_request_one(platform_data->wake_gpio, GPIOF_OUT_INIT_LOW,
> +		"nfc_wake");
> +	if (ret)
> +		goto err_wake;
> +
> +	gpio_set_value(platform_data->en_gpio, 0);
> +	gpio_set_value(platform_data->wake_gpio, 0);
> +
> +	bcm2079x_dev = kzalloc(sizeof(*bcm2079x_dev), GFP_KERNEL);
> +	if (bcm2079x_dev == NULL) {
> +		dev_err(&client->dev,
> +			"failed to allocate memory for module data\n");
> +		ret = -ENOMEM;
> +		goto err_exit;
> +	}
> +
> +	bcm2079x_dev->wake_gpio = platform_data->wake_gpio;
> +	bcm2079x_dev->irq_gpio = platform_data->irq_gpio;
> +	bcm2079x_dev->en_gpio = platform_data->en_gpio;
> +	bcm2079x_dev->client = client;
> +
> +	/* init mutex and queues */
> +	init_waitqueue_head(&bcm2079x_dev->read_wq);
> +	mutex_init(&bcm2079x_dev->read_mutex);
> +	spin_lock_init(&bcm2079x_dev->irq_enabled_lock);
> +
> +	bcm2079x_dev->bcm2079x_device.minor = MISC_DYNAMIC_MINOR;
> +	bcm2079x_dev->bcm2079x_device.name = "bcm2079x-i2c";
> +	bcm2079x_dev->bcm2079x_device.fops = &bcm2079x_dev_fops;
> +
> +	ret = misc_register(&bcm2079x_dev->bcm2079x_device);
> +	if (ret) {
> +		dev_err(&client->dev, "misc_register failed\n");
> +		goto err_misc_register;
> +	}
> +
> +	/* request irq.  the irq is set whenever the chip has data available
> +	 * for reading.  it is cleared when all data has been read.
> +	 */
> +	dev_info(&client->dev, "requesting IRQ %d\n", client->irq);
> +	bcm2079x_dev->irq_enabled = true;
> +	ret = request_irq(client->irq, bcm2079x_dev_irq_handler,
> +			IRQF_TRIGGER_RISING, client->name, bcm2079x_dev);
> +	if (ret) {
> +		dev_err(&client->dev, "request_irq failed\n");
> +		goto err_request_irq_failed;
> +	}
> +	bcm2079x_disable_irq(bcm2079x_dev);
> +	i2c_set_clientdata(client, bcm2079x_dev);
> +	dev_info(&client->dev,
> +		 "%s, probing bcm2079x driver exited successfully\n",
> +		 __func__);
> +	return 0;
> +
> +err_request_irq_failed:
> +	misc_deregister(&bcm2079x_dev->bcm2079x_device);
> +err_misc_register:
> +	mutex_destroy(&bcm2079x_dev->read_mutex);
> +	kfree(bcm2079x_dev);
> +err_exit:
> +	gpio_free(platform_data->wake_gpio);
> +err_wake:
> +	gpio_free(platform_data->en_gpio);
> +err_en:
> +	gpio_free(platform_data->irq_gpio);
> +	return ret;
> +}
> +
> +static int bcm2079x_remove(struct i2c_client *client)
> +{
> +	struct bcm2079x_dev *bcm2079x_dev;
> +
> +	bcm2079x_dev = i2c_get_clientdata(client);
> +	free_irq(client->irq, bcm2079x_dev);
> +	misc_deregister(&bcm2079x_dev->bcm2079x_device);
> +	mutex_destroy(&bcm2079x_dev->read_mutex);
> +	gpio_free(bcm2079x_dev->irq_gpio);
> +	gpio_free(bcm2079x_dev->en_gpio);
> +	gpio_free(bcm2079x_dev->wake_gpio);
> +	kfree(bcm2079x_dev);
> +
> +	return 0;
> +}
> +
> +static const struct i2c_device_id bcm2079x_id[] = {
> +	{"bcm2079x-i2c", 0},
> +	{}
> +};
> +
> +static struct i2c_driver bcm2079x_driver = {
> +	.id_table = bcm2079x_id,
> +	.probe = bcm2079x_probe,
> +	.remove = bcm2079x_remove,
> +	.driver = {
> +		.owner = THIS_MODULE,
> +		.name = "bcm2079x-i2c",
> +	},
> +};
> +
> +/*
> + * module load/unload record keeping
> + */
> +
> +static int __init bcm2079x_dev_init(void)
> +{
> +	return i2c_add_driver(&bcm2079x_driver);
> +}
> +module_init(bcm2079x_dev_init);
> +
> +static void __exit bcm2079x_dev_exit(void)
> +{
> +	i2c_del_driver(&bcm2079x_driver);
> +}
> +module_exit(bcm2079x_dev_exit);
> +
> +MODULE_AUTHOR("Broadcom");
> +MODULE_DESCRIPTION("NFC bcm2079x driver");
> +MODULE_LICENSE("GPL");
> diff --git a/drivers/nfc/bcm2079x/bcm2079x.h b/drivers/nfc/bcm2079x/bcm2079x.h
> new file mode 100644
> index 0000000..b8b243f
> --- /dev/null
> +++ b/drivers/nfc/bcm2079x/bcm2079x.h
> @@ -0,0 +1,34 @@
> +/*
> + * Copyright (C) 2013 Broadcom Corporation.
> + *
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
> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
> + */
> +
> +#ifndef _BCM2079X_H
> +#define _BCM2079X_H
> +
> +#define BCMNFC_MAGIC	0xFA
> +
> +#define BCMNFC_POWER_CTL	_IO(BCMNFC_MAGIC, 0x01)
> +#define BCMNFC_WAKE_CTL	_IO(BCMNFC_MAGIC, 0x05)
> +#define BCMNFC_SET_ADDR	_IO(BCMNFC_MAGIC, 0x07)
> +
> +struct bcm2079x_platform_data {
> +	unsigned int irq_gpio;
> +	unsigned int en_gpio;
> +	unsigned int wake_gpio;
> +};
> +
> +#endif
>


