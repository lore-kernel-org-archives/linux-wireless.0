Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:60857 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757838Ab2FEIjD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jun 2012 04:39:03 -0400
Message-ID: <1338885523.1817.101.camel@aeonflux> (sfid-20120605_103910_267242_A7B3C23E)
Subject: Re: [PATCH] NFC: Driver for SAMSUNG S3FHRN2 NFC Chip.
From: Marcel Holtmann <marcel@holtmann.org>
To: =?UTF-8?Q?=EC=9D=B4=EC=9A=B4=EA=B8=B0?= <woonki84.lee@samsung.com>
Cc: linux-wireless@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	sameo@linux.intel.com, lauro.venancio@openbossa.org,
	aloisio.almeida@openbossa.org, kgene.kim@samsung.com
Date: Tue, 05 Jun 2012 17:38:43 +0900
In-Reply-To: <001201cd42ef$c283d8d0$478b8a70$%lee@samsung.com>
References: <001201cd42ef$c283d8d0$478b8a70$%lee@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> This is a driver for the S3FHRN2 NFC device. the driver is just a
> proxy getting SHDLC/HCI frames from a userspace stack.

<snip>

> +
> +	info->miscdev.minor = MISC_DYNAMIC_MINOR;
> +	info->miscdev.name = S3FHRN2_DRIVER_NAME;
> +	info->miscdev.fops = &s3fhrn2_fops;
> +	info->miscdev.parent = &client->dev;
> +	ret = misc_register(&info->miscdev);
> +	if (ret < 0) {
> +		dev_err(&client->dev, "failed to register Device\n");
> +		goto err_dev_reg;
> +	}

instead of creating a misc character device, I would prefer that this
gets integrated as driver for the NFC subsystem.

We do not want to have shim NFC drivers in the kernel anymore.

Regards

Marcel


