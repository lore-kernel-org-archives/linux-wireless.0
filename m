Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:41991 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754792Ab3HWXCL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Aug 2013 19:02:11 -0400
Message-ID: <1377298929.2816.15.camel@joe-AO722> (sfid-20130824_010214_318067_33BF9EED)
Subject: Re: [PATCH v2 13/16] wcn36xx: add wcn36xx.h
From: Joe Perches <joe@perches.com>
To: Eugene Krasnikov <k.eugene.e@gmail.com>
Cc: linux-wireless@vger.kernel.org, wcn36xx@lists.infradead.org
Date: Fri, 23 Aug 2013 16:02:09 -0700
In-Reply-To: <1377248299-21007-14-git-send-email-k.eugene.e@gmail.com>
References: <1377248299-21007-1-git-send-email-k.eugene.e@gmail.com>
	 <1377248299-21007-14-git-send-email-k.eugene.e@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-08-23 at 10:58 +0200, Eugene Krasnikov wrote:
> Adding wcn36xx.h
[]
> +#define wcn36xx_err(fmt, arg...)				\
> +	printk(KERN_ERR pr_fmt("ERROR " fmt), ##arg);
> +
> +#define wcn36xx_warn(fmt, arg...)				\
> +	printk(KERN_WARNING pr_fmt("WARNING " fmt), ##arg)
> +
> +#define wcn36xx_info(fmt, arg...)		\
> +	printk(KERN_INFO pr_fmt(fmt), ##arg)
> +

I these would be better using:

#define wcn36xx_err(fmt, ...)					\
	pr_err("ERROR " fmt, ##__VA_ARGS__)

etc...

> +#define wcn36xx_dbg(mask, fmt, arg...) do {			\
> +	if (debug_mask & mask)					\
> +		printk(KERN_DEBUG pr_fmt(fmt), ##arg);	\
> +} while (0)

And maybe this one using pr_debug so dynamic_debug
can work too.


