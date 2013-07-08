Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:56622 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751809Ab3GHWEz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jul 2013 18:04:55 -0400
Message-ID: <1373321094.9458.9.camel@joe-AO722> (sfid-20130709_000459_206255_AEE09697)
Subject: Re:
From: Joe Perches <joe@perches.com>
To: "Jeffrey (Sheng-Hui) Chu" <jeffchu@broadcom.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Mon, 08 Jul 2013 15:04:54 -0700
In-Reply-To: <90AC93A0CCA054488FFC508D6F62B6F40FED489B@IRVEXCHMB07.corp.ad.broadcom.com>
References: <90AC93A0CCA054488FFC508D6F62B6F40FED489B@IRVEXCHMB07.corp.ad.broadcom.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-07-08 at 21:52 +0000, Jeffrey (Sheng-Hui) Chu wrote:
[]
> diff --git a/drivers/nfc/bcm2079x/bcm2079x-i2c.c b/drivers/nfc/bcm2079x/bcm2079x-i2c.c
[]
> +/* do not change below */
> +#define MAX_BUFFER_SIZE		780
[]
> +static ssize_t bcm2079x_dev_read(struct file *filp, char __user *buf,
> +					size_t count, loff_t *offset)
> +{
> +	struct bcm2079x_dev *bcm2079x_dev = filp->private_data;
> +	unsigned char tmp[MAX_BUFFER_SIZE];

780 bytes on stack isn't a great idea.

> +static ssize_t bcm2079x_dev_write(struct file *filp, const char __user *buf,
> +					size_t count, loff_t *offset)
> +{
> +	struct bcm2079x_dev *bcm2079x_dev = filp->private_data;
> +	char tmp[MAX_BUFFER_SIZE];

etc.

> +	int ret;
> +
> +	if (count > MAX_BUFFER_SIZE) {
> +		dev_err(&bcm2079x_dev->client->dev, "out of memory\n");

Out of memory isn't really true.
The packet size is just too big for your
little buffer.

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

Looks to me like this should be dev_dbg not dev_info


