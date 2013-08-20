Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:54821 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751763Ab3HTSEv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Aug 2013 14:04:51 -0400
Message-ID: <1377021890.2016.55.camel@joe-AO722> (sfid-20130820_200454_300687_4A7E9C00)
Subject: Re: [PATCH 13/16] wcn36xx: Add wcn36xx.h
From: Joe Perches <joe@perches.com>
To: Eugene Krasnikov <k.eugene.e@gmail.com>
Cc: linux-wireless@vger.kernel.org, wcn36xx@lists.infradead.org
Date: Tue, 20 Aug 2013 11:04:50 -0700
In-Reply-To: <1377020479-16935-14-git-send-email-k.eugene.e@gmail.com>
References: <1377020479-16935-1-git-send-email-k.eugene.e@gmail.com>
	 <1377020479-16935-14-git-send-email-k.eugene.e@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-08-20 at 19:41 +0200, Eugene Krasnikov wrote:
> Adding wcn36xx.h
[]
> +#define DRIVER_PREFIX "wcn36xx: "
[]

I think you should use pr_fmt and/or netdev_<level>

> +#define wcn36xx_error(fmt, arg...) do {			\
> +	pr_err(DRIVER_PREFIX "ERROR " fmt "\n", ##arg);	\
> +	__WARN();					\
> +} while (0)

What value is there in this __WARN?

Please use _err rather than _error

> +#define wcn36xx_warn(fmt, arg...)				\
> +	pr_warn(DRIVER_PREFIX "WARNING " fmt "\n", ##arg)
> +
> +#define wcn36xx_info(fmt, arg...)		\
> +	pr_info(DRIVER_PREFIX fmt "\n", ##arg)
> +
> +#define wcn36xx_dbg(mask, fmt, arg...) do {			\
> +	if (debug_mask & mask)					\
> +		pr_debug(DRIVER_PREFIX fmt "\n", ##arg);	\
> +} while (0)
> +
> +#define wcn36xx_dbg_dump(mask, prefix_str, buf, len) do {	\
> +	if (debug_mask & mask)					\
> +		print_hex_dump(KERN_DEBUG, prefix_str,		\
> +			       DUMP_PREFIX_OFFSET, 32, 1,	\
> +			       buf, len, false);		\
> +} while (0)
> +

Please move the "\n" to the uses instead of the macro.
This would be consistent with all the other ath macros.


