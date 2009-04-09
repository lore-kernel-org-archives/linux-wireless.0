Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from Viola.Opus1.COM ([192.245.12.8]:2493 "EHLO Viola.Opus1.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756541AbZDIExM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Apr 2009 00:53:12 -0400
Received: from [10.1.1.4] ([204.17.34.178]) by Opus1.COM (PMDF V6.2-X27 #9830)
 with ESMTPSA id <01N7K5BT706Q96CA3H@Opus1.COM> for
 linux-wireless@vger.kernel.org; Wed, 08 Apr 2009 20:59:35 -0700 (MST)
Date: Wed, 08 Apr 2009 20:59:34 -0700
From: gavron@wetwork.net
Subject: Re: Problems with 2.6.30-rc1
In-reply-to: <49DD149B.2060300@lwfinger.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: bcm43xx-dev@lists.berlios.de,
	wireless <linux-wireless@vger.kernel.org>
Message-id: <49DD72A6.7060002@wetwork.net> (sfid-20090409_065315_490202_70FB6828)
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
References: <20090408182021.GA4112@aragorn.home.lxtec.de>
 <200904082050.00327.mb@bu3sch.de> <49DCF537.8000702@lwfinger.net>
 <20090408192634.GB3717@samweis.home.lxtec.de> <49DD149B.2060300@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I had the same problem on my iwlagn notebook.  This patch successfully 
fixed that as well!

Thanks, Larry :)

Ehud

Larry Finger wrote:
> If you are having problems with wireless networking using 2.6.30-rc1 from
> Linus's Linux-2.6 git tree, the fix is the following (Note: This is _NOT_ needed
> for wireless-testing!!!):
>
> ---
> Fix try_then_request_module to use waiting __request_module again.
>
> Signed-off-by: Andreas Schwab <schwab@linux-m68k.org>
> ---
>  include/linux/kmod.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> Index: linux-2.6.30-rc1/include/linux/kmod.h
> ===================================================================
> --- linux-2.6.30-rc1.orig/include/linux/kmod.h	2009-04-08 12:47:54.000000000 +0200
> +++ linux-2.6.30-rc1/include/linux/kmod.h	2009-04-08 17:39:35.000000000 +0200
> @@ -34,7 +34,7 @@ extern int __request_module(bool wait, c
>  #define request_module(mod...) __request_module(true, mod)
>  #define request_module_nowait(mod...) __request_module(false, mod)
>  #define try_then_request_module(x, mod...) \
> -	((x) ?: (__request_module(false, mod), (x)))
> +	((x) ?: (__request_module(true, mod), (x)))
>  #else
>  static inline int request_module(const char *name, ...) { return -ENOSYS; }
>  static inline int request_module_nowait(const char *name, ...) { return -ENOSYS; }
>
>   

-- 
Legal Disclaimer that you are now contractually bound to under all laws with no recourse:
http://attrition.org/security/rants/z/disclaimers.html

