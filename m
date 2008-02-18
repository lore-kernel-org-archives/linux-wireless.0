Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perninha.conectiva.com.br ([200.140.247.100]:38100 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067AbYBRUPM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Feb 2008 15:15:12 -0500
Received: from localhost (perninha.conectiva.com.br [127.0.0.1])
	by perninha.conectiva.com.br (Postfix) with ESMTP id 003633A985
	for <linux-wireless@vger.kernel.org>; Mon, 18 Feb 2008 17:15:09 -0300 (BRT)
Received: from perninha.conectiva.com.br ([127.0.0.1])
	by localhost (perninha.conectiva.com.br [127.0.0.1]) (amavisd-new, port 10025)
	with LMTP id GChxjEUDvtIG for <linux-wireless@vger.kernel.org>;
	Mon, 18 Feb 2008 17:15:09 -0300 (BRT)
Received: from fox.conectiva (fox.conectiva [10.0.2.195])
	by perninha.conectiva.com.br (Postfix) with ESMTP id 786883A981
	for <linux-wireless@vger.kernel.org>; Mon, 18 Feb 2008 17:15:09 -0300 (BRT)
Received: from gotham.conectiva (gotham.conectiva [10.0.2.23])
	by fox.conectiva (Postfix) with ESMTP id 1DB5F2F26E
	for <linux-wireless@vger.kernel.org>; Mon, 18 Feb 2008 17:15:09 -0300 (BRT)
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
To: linux-wireless@vger.kernel.org
Subject: Re: Build problem when using linux/wireless.h header
Date: Mon, 18 Feb 2008 17:15:08 -0300
References: <200802181449.03719.herton@mandriva.com.br>
In-Reply-To: <200802181449.03719.herton@mandriva.com.br>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200802181715.08669.herton@mandriva.com.br> (sfid-20080218_201518_453905_BF6656AD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Em Monday 18 February 2008 14:49:01 Herton Ronaldo Krzesinski escreveu:
> An error when building airpwn (airpwn.sf.net) was reported to me:
> 
> In file included from airpwn.c:36:
> /usr/include/linux/wireless.h:886: error: 'IFNAMSIZ' undeclared here (not in a 
> function)
> airpwn.c: In function 'process_ip_packet':
> airpwn.c:482: warning: ignoring return value of 'write', declared with 
> attribute warn_unused_result
> airpwn.c:483: warning: ignoring return value of 'write', declared with 
> attribute warn_unused_result
> airpwn.c:484: warning: ignoring return value of 'write', declared with 
> attribute warn_unused_result
> make[1]: *** [airpwn.o] Error 1
> 
> This is on a system with sanitized kernel headers installed. airpwn uses 
> <linux/wireless.h>. The problem here is that wireless.h have:
> 
> #ifdef __KERNEL__
> #include <linux/types.h>                /* for "caddr_t" et al          */
> #include <linux/socket.h>               /* for "struct sockaddr" et al  */
> #include <linux/if.h>                   /* for IFNAMSIZ and co... */
> #endif  /* __KERNEL__ */
> 
> This when exported to user space is removed, but they are needed later on, 
> otherwise you get build problems when using this header. One can say that the 
> program including wireless.h should include manually the required headers, 
> but doesn't seem very nice. Also wireless-tools include a copy of wireless.h, 
> seems an unecessary duplication. So what about doing this:
> 
> - Don't export wireless.h from kernel to user space, since wireless-tools 
> already provide it.
> - Patch wireless-tools to include missing headers like this patch:
> 
> diff -p -up wireless_tools.29/wireless.21.h.orig wireless_tools.29/wireless.21.h
> --- wireless_tools.29/wireless.21.h.orig	2008-02-18 13:19:47.000000000 -0300
> +++ wireless_tools.29/wireless.21.h	2008-02-18 13:20:44.000000000 -0300
> @@ -76,6 +76,10 @@
>  #include <linux/types.h>		/* for "caddr_t" et al		*/
>  #include <linux/socket.h>		/* for "struct sockaddr" et al	*/
>  #include <linux/if.h>			/* for IFNAMSIZ and co... */
> +#else
> +#include <sys/types.h>
> +#include <sys/socket.h>
> +#include <net/if.h>
>  #endif	/* __KERNEL__ */
>  
>  /***************************** VERSION *****************************/
> diff -p -up wireless_tools.29/wireless.22.h.orig wireless_tools.29/wireless.22.h
> --- wireless_tools.29/wireless.22.h.orig	2008-02-18 13:19:53.000000000 -0300
> +++ wireless_tools.29/wireless.22.h	2008-02-18 13:21:00.000000000 -0300
> @@ -76,6 +76,10 @@
>  #include <linux/types.h>		/* for "caddr_t" et al		*/
>  #include <linux/socket.h>		/* for "struct sockaddr" et al	*/
>  #include <linux/if.h>			/* for IFNAMSIZ and co... */
> +#else
> +#include <sys/types.h>
> +#include <sys/socket.h>
> +#include <net/if.h>
>  #endif	/* __KERNEL__ */
>  
>  /***************************** VERSION *****************************/

Ok, there will be still an error because of __user with the patch
above (btw the patch is ugly), that can be solved adding:
#ifndef __user
#define __user
#endif

Or just using the linux headers like previously... but then there is
the question:
- Why the includes above were protected by "ifdef __KERNEL__"? (yes I
read the comment, but they make the header unusable)

--
[]'s
Herton
