Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from slowhand.arndnet.de ([88.198.19.76]:54585 "EHLO mail.unitix.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754329Ab0KKRsv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Nov 2010 12:48:51 -0500
Message-ID: <4CDC2C80.6030807@arndnet.de>
Date: Thu, 11 Nov 2010 18:48:48 +0100
From: Arnd Hannemann <arnd@arndnet.de>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: John W Linville <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] b43legacy: Fix compile on ARM architecture
References: <4cdc2b80.RuMMb1PuVmklU3JJ%Larry.Finger@lwfinger.net>
In-Reply-To: <4cdc2b80.RuMMb1PuVmklU3JJ%Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 11.11.2010 18:44, schrieb Larry Finger:
> From: Arnd Hannemann <arnd@arndnet.de>
> 
> When b43legacy is compiled on the arm platform, the following errors are seen:
> 
>   CC [M]  drivers/net/wireless/b43legacy/xmit.o
> In file included from include/net/dst.h:11,
> from drivers/net/wireless/b43legacy/xmit.c:31:
> include/net/dst_ops.h:28: error: expected ':', ',', ';', '}' or '__attribute__'
>    before '____cacheline_aligned_in_smp'
> include/net/dst_ops.h: In function 'dst_entries_get_fast':
> include/net/dst_ops.h:33: error: 'struct dst_ops' has no member named
>    'pcpuc_entries'
> include/net/dst_ops.h: In function 'dst_entries_get_slow':
> include/net/dst_ops.h:41: error: 'struct dst_ops' has no member named
>    'pcpuc_entries'
> include/net/dst_ops.h: In function 'dst_entries_add':
> include/net/dst_ops.h:49: error: 'struct dst_ops' has no member named
>    'pcpuc_entries'
> include/net/dst_ops.h: In function 'dst_entries_init':
> include/net/dst_ops.h:55: error: 'struct dst_ops' has no member named
>    'pcpuc_entries'
> include/net/dst_ops.h: In function 'dst_entries_destroy':
> include/net/dst_ops.h:60: error: 'struct dst_ops' has no member named
>    'pcpuc_entries'
> make[4]: *** [drivers/net/wireless/b43legacy/xmit.o] Error 1
> make[3]: *** [drivers/net/wireless/b43legacy] Error 2
> make[2]: *** [drivers/net/wireless] Error 2
> make[1]: *** [drivers/net] Error 2
> make: *** [drivers] Error 2
> 
> The cause is a missing include of <linux/cache.h>, which is present for
> i386 and x86_64 architectures, but not for arm.
> 
> Signed-off-by: Arnd Hannemann <arnd@arndnet.de>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Stable <stable@kernel.org>
> ---
> 
> John,
> 
> Once I get the ability to cross-compile ARM architecture, I will check to
> see if the equivalent patch is needed for b43.

b43 compiles fine for me for the same target.

Thanks,
Arnd

> 
> Larry
> ---
> 
> Index: linux-2.6/include/net/dst_ops.h
> ===================================================================
> --- linux-2.6.orig/include/net/dst_ops.h
> +++ linux-2.6/include/net/dst_ops.h
> @@ -2,6 +2,7 @@
>  #define _NET_DST_OPS_H
>  #include <linux/types.h>
>  #include <linux/percpu_counter.h>
> +#include <linux/cache.h>
>  
>  struct dst_entry;
>  struct kmem_cachep;
> 

