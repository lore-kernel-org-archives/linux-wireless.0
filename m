Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:22946 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756882Ab0KJV5v (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Nov 2010 16:57:51 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 10 Nov 2010 13:57:39 -0800
Date: Wed, 10 Nov 2010 13:57:49 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Arnaud Lacombe <lacombar@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Luis Rodriguez" <Luis.Rodriguez@Atheros.com>
Subject: Re: [PATCH 07/44] compat/2.6.19: rework compat macro to
 kmem_cache_destroy()
Message-ID: <20101110215749.GE4667@tux>
References: <1289355626-25373-1-git-send-email-lacombar@gmail.com>
 <1289355626-25373-8-git-send-email-lacombar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1289355626-25373-8-git-send-email-lacombar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 09, 2010 at 06:19:49PM -0800, Arnaud Lacombe wrote:
> Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
> ---
>  include/linux/compat-2.6.19.h |   11 +----------
>  1 files changed, 1 insertions(+), 10 deletions(-)
> 
> diff --git a/include/linux/compat-2.6.19.h b/include/linux/compat-2.6.19.h
> index bcffc47..ddba97d 100644
> --- a/include/linux/compat-2.6.19.h
> +++ b/include/linux/compat-2.6.19.h
> @@ -8,16 +8,7 @@
>  
>  #include <linux/slab.h>
>  
> -static inline int
> -compat_kmem_cache_destroy(struct kmem_cache *cachep)
> -{
> -#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,19))
> -	return kmem_cache_destroy(cachep);
> -#else
> -	kmem_cache_destroy(cachep);
> -	return 0;
> -#endif
> -}
> +#define kmem_cache_destroy(cachep)	({ kmem_cache_destroy(cachep); 0; })

Is this because it shall not even fail for older kernels?

  Luis
