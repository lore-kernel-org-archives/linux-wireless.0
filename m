Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:62737 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756776Ab2FGAkN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 20:40:13 -0400
From: =?utf-8?B?7J207Jq06riw?= <woonki84.lee@samsung.com>
To: 'Marcel Holtmann' <marcel@holtmann.org>
Cc: linux-wireless@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	sameo@linux.intel.com, lauro.venancio@openbossa.org,
	aloisio.almeida@openbossa.org, kgene.kim@samsung.com
References: <001201cd42ef$c283d8d0$478b8a70$%lee@samsung.com>
 <1338885523.1817.101.camel@aeonflux>
In-reply-to: <1338885523.1817.101.camel@aeonflux>
Subject: RE: [PATCH] NFC: Driver for SAMSUNG S3FHRN2 NFC Chip.
Date: Thu, 07 Jun 2012 09:40:11 +0900
Message-id: <000601cd4446$18d0a9a0$4a71fce0$%lee@samsung.com> (sfid-20120607_024024_290380_32C00DF0)
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

> 
> > This is a driver for the S3FHRN2 NFC device. the driver is just a
> > proxy getting SHDLC/HCI frames from a userspace stack.
> 
> <snip>
> 
> > +
> > +	info->miscdev.minor = MISC_DYNAMIC_MINOR;
> > +	info->miscdev.name = S3FHRN2_DRIVER_NAME;
> > +	info->miscdev.fops = &s3fhrn2_fops;
> > +	info->miscdev.parent = &client->dev;
> > +	ret = misc_register(&info->miscdev);
> > +	if (ret < 0) {
> > +		dev_err(&client->dev, "failed to register Device\n");
> > +		goto err_dev_reg;
> > +	}
> 
> instead of creating a misc character device, I would prefer that this
> gets integrated as driver for the NFC subsystem.
> 
> We do not want to have shim NFC drivers in the kernel anymore.
> 

Ok, I think you are right.
I will submit again after I change misc character device to nfc device
of NFC subsystem.
Thank you for your review.

Regards

Woonki.

