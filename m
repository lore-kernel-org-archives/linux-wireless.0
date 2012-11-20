Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:33664 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751649Ab2KTINk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2012 03:13:40 -0500
Message-ID: <50AB3B6C.4000505@phrozen.org> (sfid-20121120_091342_955610_4EFEE5EC)
Date: Tue, 20 Nov 2012 09:12:28 +0100
From: John Crispin <john@phrozen.org>
MIME-Version: 1.0
To: Hauke Mehrtens <hauke@hauke-m.de>
CC: ralf@linux-mips.org, linux-mips@linux-mips.org,
	linux-wireless@vger.kernel.org, florian@openwrt.org,
	zajec5@gmail.com, m@bues.ch
Subject: Re: [PATCH 7/8] ssb: add GPIO driver
References: <1353365877-11131-1-git-send-email-hauke@hauke-m.de> <1353365877-11131-8-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1353365877-11131-8-git-send-email-hauke@hauke-m.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Hauke,


 > +#ifdef CONFIG_SSB_DRIVER_EXTIF

...

> +}
> +
> +#else
> +static int ssb_gpio_extif_init(struct ssb_bus *bus)
> +{
> +	return 0;
> +}
> +#endif

ssb_gpio_extif_init() is also defined as a static inline stub in the 
header files. you should drop this definition from the code file

	John
