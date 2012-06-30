Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:37354 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751110Ab2F3WSm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Jun 2012 18:18:42 -0400
Message-ID: <1341094721.10603.4.camel@joe2Laptop> (sfid-20120701_001922_101084_7073E0B9)
Subject: Re: [PATCH V4] bcma: use custom printing functions
From: Joe Perches <joe@perches.com>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Hauke Mehrtens <hauke@hauke-m.de>
Date: Sat, 30 Jun 2012 15:18:41 -0700
In-Reply-To: <1341087486-14159-1-git-send-email-zajec5@gmail.com>
References: <1341087486-14159-1-git-send-email-zajec5@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2012-06-30 at 22:18 +0200, Rafał Miłecki wrote:
> Having bus number printed makes it much easier to anaylze logs on
> systems with more buses. For example Netgear WNDR4500 has 3 AMBA buses
> in total, which makes standard log really messy.
[]
> V4: replace some pr_debug I missed in V3
> 
> Unfortunately, bcma_debug is not complete in case of
> CONFIG_DYNAMIC_DEBUG. It'd be great if someone could help with that...
[]
> diff --git a/drivers/bcma/bcma_private.h b/drivers/bcma/bcma_private.h
[]
> @@ -10,6 +10,26 @@
>  
>  #define BCMA_CORE_SIZE		0x1000
>  
> +/* We use pr_fmt, so call printk directly */
> +#define bcma_err(bus, fmt, ...) \
> +	printk(KERN_ERR KBUILD_MODNAME " bus%d: " fmt, (bus)->num, ##__VA_ARGS__)
> +#define bcma_warn(bus, fmt, ...) \
> +	printk(KERN_WARNING KBUILD_MODNAME " bus%d: " fmt, (bus)->num, ##__VA_ARGS__)
> +#define bcma_info(bus, fmt, ...) \
> +	printk(KERN_INFO KBUILD_MODNAME " bus%d: " fmt, (bus)->num, ##__VA_ARGS__)
> +
> +#if defined(CONFIG_DYNAMIC_DEBUG)
> +/* FIXME: include bus num */
> +#define bcma_debug(bus, fmt, ...) \
> +	pr_debug(fmt, ##__VA_ARGS__)
> +#elif defined(DEBUG)
> +#define bcma_debug(bus, fmt, ...) \
> +	printk(KERN_DEBUG KBUILD_MODNAME " bus%d: " fmt, (bus)->num, ##__VA_ARGS__)
> +#else
> +#define bcma_debug(bus, fmt, ...) \
> +	no_printk(KERN_DEBUG KBUILD_MODNAME " bus%d: " fmt, (bus)->num, ##__VA_ARGS__)
> +#endif

Well, my suggestion would be to use a standardized
"bcma: bus%d: " prefix and change these to:

#define bcma_err(bus, fmt, ...) \
	pr_err("bus%d: " fmt, (bus)->num, ##__VA_ARGS__)
#define bcma_warn(bus, fmt, ...) \
	pr_warn("bus%d: " fmt, (bus)->num, ##__VA_ARGS__)
#define bcma_info(bus, fmt, ...) \
	pr_info("bus%d: " fmt, (bus)->num, ##__VA_ARGS__)
#define bcma_debug(bus, fmt, ...) \
	pr_debug("bus%d: " fmt, (bus)->num, ##__VA_ARGS__)
 

