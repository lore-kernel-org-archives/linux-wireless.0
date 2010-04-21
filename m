Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.perches.com ([173.55.12.10]:1652 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754900Ab0DUWuH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Apr 2010 18:50:07 -0400
Subject: Re: [PATCH] Added configurable debug messages to libertastf
From: Joe Perches <joe@perches.com>
To: Steve deRosier <steve@cozybit.com>
Cc: linux-wireless@vger.kernel.org, javier@cozybit.com
In-Reply-To: <1271889581-21352-1-git-send-email-steve@cozybit.com>
References: <1271889581-21352-1-git-send-email-steve@cozybit.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 21 Apr 2010 15:50:05 -0700
Message-ID: <1271890205.1730.588.camel@Joe-Laptop.home>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-04-21 at 15:39 -0700, Steve deRosier wrote:
> Add the same type of configurable debug messages to libertas_tf as
> already exist in the libertas driver.  This has facilitated creation of a interface
> specification and will facilitate future development of this driver.
> 
> Signed-off-by: Steve deRosier <steve@cozybit.com>
[]
> +#define lbtf_pr_info(format, args...) \
> +	printk(KERN_INFO DRV_NAME": " format, ## args)
> +#define lbtf_pr_err(format, args...) \
> +	printk(KERN_ERR DRV_NAME": " format, ## args)
> +#define lbtf_pr_alert(format, args...) \
> +	printk(KERN_ALERT DRV_NAME": " format, ## args)

I think it'd be better to add

#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

and use the more standard pr_<level>s.

> +#ifdef DEBUG
> +static inline void lbtf_deb_hex(unsigned int grp, const char *prompt, u8 *buf, int len)
> +{
> +	int i = 0;
> +
> +	if (len &&
> +	    (lbtf_debug & LBTF_DEB_HEX) &&
> +	    (lbtf_debug & grp))	{
> +		for (i = 1; i <= len; i++) {
> +			if ((i & 0xf) == 1) {
> +				if (i != 1)
> +					printk("\n");
> +				printk(DRV_NAME " %s: ", prompt);
> +			}
> +			printk("%02x ", (u8) *buf);
> +			buf++;
> +		}
> +		printk("\n");
> +	}
> +}

print_hex_dump_bytes


