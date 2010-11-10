Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:22308 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757196Ab0KJVxr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Nov 2010 16:53:47 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 10 Nov 2010 13:53:34 -0800
Date: Wed, 10 Nov 2010 13:53:44 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Arnaud Lacombe <lacombar@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>
Subject: Re: [PATCH 04/44] compat/2.6.18: add compat inline for
 netdev_alloc_skb()
Message-ID: <20101110215344.GD4667@tux>
References: <1289355626-25373-1-git-send-email-lacombar@gmail.com>
 <1289355626-25373-5-git-send-email-lacombar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1289355626-25373-5-git-send-email-lacombar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 09, 2010 at 06:19:46PM -0800, Arnaud Lacombe wrote:
> Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
> ---
>  include/linux/compat-2.6.18.h |   21 +++++++++++++++++++++
>  1 files changed, 21 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/compat-2.6.18.h b/include/linux/compat-2.6.18.h
> index a45cfc7..4a7034a 100644
> --- a/include/linux/compat-2.6.18.h
> +++ b/include/linux/compat-2.6.18.h
> @@ -6,8 +6,29 @@
>  /* Compat work for 2.6.18 */
>  #if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,18))
>  
> +#include <linux/gfp.h>
> +#include <linux/netdevice.h>
> +#include <linux/skbuff.h>
> +
>  #define roundup(x, y)	((((x) + ((y) - 1)) / (y)) * (y))
>  
> +#ifndef NET_SKB_PAD
> +#define NET_SKB_PAD	16

Why are you adding the ifndef for NET_SKB_PAD if you know you already added it
for 2.6.17 on your patch 2/44 ?

  Luis
