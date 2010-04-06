Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:49190 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756468Ab0DFVDh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Apr 2010 17:03:37 -0400
Subject: Re: [PATCH 2/2] compat-wireless: fix use of device_create
From: Pavel Roskin <proski@gnu.org>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: lrodriguez@atheros.com, linux-wireless@vger.kernel.org,
	mcgrof@infradead.org
In-Reply-To: <1270501410-3956-2-git-send-email-hauke@hauke-m.de>
References: <1270501410-3956-1-git-send-email-hauke@hauke-m.de>
	 <1270501410-3956-2-git-send-email-hauke@hauke-m.de>
Content-Type: text/plain
Date: Tue, 06 Apr 2010 17:03:35 -0400
Message-Id: <1270587815.31184.4.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-04-05 at 23:03 +0200, Hauke Mehrtens wrote: 
> The signature of device_create changed in the last kernel version.
> Backporting it in compat is hard because of the use of var args.

I see it's applied already, but I hope some belated critique could be
useful anyway.

The log mentions "last kernel version", but the patch affects Linux
2.6.26 and older.  Either the log is wrong (more likely), or the
implementation doesn't include something that it was meant to do.

> ++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,27))
> + 		data->dev = device_create(hwsim_class, NULL, 0, hw,
> + 					  "hwsim%d", i);
> ++#elif (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,26))
> ++		data->dev = device_create_drvdata(hwsim_class, NULL, 0, hw,
> ++					  "hwsim%d", i);
> ++#else
> ++		data->dev = device_create(hwsim_class, NULL, 0,
> ++					  "hwsim%d", i);
> ++		dev_set_drvdata(data->dev, hw);
> ++#endif

Linux 2.6.26 should be able to use exactly the same code as the older
kernels.  It has device_create() with the old signature and
dev_set_drvdata().  I'd rather avoid extra complexity.

Also, it should be possible to redefine device_create() for older
kernels using a macro:

#define device_create(cls, parent, devt, drvdata, fmt, ...)            \
({                                                                     \
       struct device *_dev;                                            \
       _dev = (device_create)(cls, parent, devt, fmt, __VA_ARGS__);    \
       dev_set_drvdata(_dev, drvdata);                                 \
       _dev;                                                           \
})

-- 
Regards,
Pavel Roskin
