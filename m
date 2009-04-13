Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from baikonur.stro.at ([213.239.196.228]:51281 "EHLO
	baikonur.stro.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304AbZDMUr3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Apr 2009 16:47:29 -0400
Date: Mon, 13 Apr 2009 22:44:30 +0200
From: maximilian attems <max@stro.at>
To: Christian Lamparter <chunkeey@web.de>
Cc: linux-wireless@vger.kernel.org, Bob Copeland <me@bobcopeland.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] ath: add module information
Message-ID: <20090413204430.GH31922@baikonur.stro.at> (sfid-20090413_224732_614869_B046F9C3)
References: <200904132244.24122.chunkeey@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200904132244.24122.chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 13, 2009 at 10:44:23PM +0200, Christian Lamparter wrote:
> diff --git a/drivers/net/wireless/ath/Makefile b/drivers/net/wireless/ath/Makefile
> index a005b91..4bb0132 100644
> --- a/drivers/net/wireless/ath/Makefile
> +++ b/drivers/net/wireless/ath/Makefile
> @@ -3,5 +3,4 @@ obj-$(CONFIG_ATH9K)		+= ath9k/
>  obj-$(CONFIG_AR9170_USB)        += ar9170/
>  
>  obj-$(CONFIG_ATH_COMMON)	+= ath.o
> -ath-objs 		:= regd.o
> -
> +ath-objs 		:= main.o regd.o

why do you put that in a different file and not in ath.c?

> diff --git a/drivers/net/wireless/ath/main.c b/drivers/net/wireless/ath/main.c
> new file mode 100644
> index 0000000..c5eb144
> --- /dev/null
> +++ b/drivers/net/wireless/ath/main.c
> @@ -0,0 +1,33 @@
> +/*
> + * Copyright (c) 2008-2009 Atheros Communications Inc.
> + *
> + * Permission to use, copy, modify, and/or distribute this software for any
> + * purpose with or without fee is hereby granted, provided that the above
> + * copyright notice and this permission notice appear in all copies.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
> + * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
> + * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
> + * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
> + * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
> + * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
> + * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +
> +MODULE_AUTHOR("Atheros Communications");
> +MODULE_DESCRIPTION("Shared library for Atheros wireless LAN cards.");
> +MODULE_LICENSE("Dual BSD/GPL");
> +
> +static int __init ath_init(void)
> +{
> +	return 0;
> +}
> +module_init(ath_init);
> +
> +static void __exit ath_exit(void)
> +{
> +}
> +module_exit(ath_exit);
