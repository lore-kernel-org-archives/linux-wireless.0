Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.perches.com ([173.55.12.10]:3508 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753559Ab1AaS6S (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 13:58:18 -0500
Subject: Re: [PATCH 1/1] compat-wireless: Fix ath9k debug log issue.
From: Joe Perches <joe@perches.com>
To: Senthil Balasubramanian <senthilkumar@atheros.com>
Cc: luis.rodriguez@atheros.com, mcgrof@gmail.com,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <1296473865-18529-1-git-send-email-senthilkumar@atheros.com>
References: <1296473865-18529-1-git-send-email-senthilkumar@atheros.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 31 Jan 2011 10:58:16 -0800
Message-ID: <1296500296.4131.175.camel@Joe-Laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-01-31 at 17:07 +0530, Senthil Balasubramanian wrote:
> ath9k debug logs are not shown as we are using recursive vsnprintf
> which are supported in kernel 2.6.36 and above. use vprintk for older
> kernels.

#ifdefs spread around the tree for this sort of
change are not very nice.

Perhaps wireless-compat should not be an impediment to
mainline progress and these sorts of changes should be
minimized.
 
If this is really necessary for backward compatibility,
I think the %pV could just be removed.

If not, because this style would be used in several
places, perhaps another macro could be used to hide the
use of %pV.

Maybe something like:

#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,36))
#define PRINTK_VA_LIST(level, prefix, fmt, __va_list)	\
({							\
 	struct va_format vaf;				\
 							\
 	vaf.fmt = fmt;					\
 	vaf.va = &__va_list;				\
							\
	printk("%s" prefix "%pV", level, &vaf);		\
})
#else
#define PRINTK_VA_LIST(level, prefix, fmt, __va_list)	\
({							\
	printk("%s" prefix, level);			\
	vprintk(fmt, __va_list);			\
})
#endif

> +diff --git a/drivers/net/wireless/ath/main.c b/drivers/net/wireless/ath/main.c
> +index c325202..e3e60d4 100644
> +--- a/drivers/net/wireless/ath/main.c
> ++++ b/drivers/net/wireless/ath/main.c
> +@@ -60,16 +60,23 @@ EXPORT_SYMBOL(ath_rxbuf_alloc);
> + int ath_printk(const char *level, struct ath_common *common,
> + 	       const char *fmt, ...)
> + {
> ++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,36))
> + 	struct va_format vaf;
> ++#endif
> + 	va_list args;
> + 	int rtn;
> + 
> + 	va_start(args, fmt);
> + 
> ++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,36))
> + 	vaf.fmt = fmt;
> + 	vaf.va = &args;
> + 
> + 	rtn = printk("%sath: %pV", level, &vaf);
> ++#else
> ++	printk("%sath: ", level);
> ++	rtn = vprintk(fmt, args);
> ++#endif
> + 
> + 	va_end(args);
> + 

So this would become something like:

int ath_printk(const char *level, struct ath_common *common,
	       const char *fmt, ...)
{
	va_list args;
	int rtn;

	va_start(args, fmt);

	rtn = PRINTK_VA_LIST(level, "ath: ", fmt, args);

	va_end(args);

	return rtn;
}


