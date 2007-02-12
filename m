Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ogre.sisk.pl ([217.79.144.158]:44559 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965393AbXBLUyv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Feb 2007 15:54:51 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Larry Finger <larry.finger@lwfinger.net>
Subject: Re: [PATCH] bcm43xx: Fix loss of association after resume
Date: Mon, 12 Feb 2007 21:48:57 +0100
Cc: wireless <linux-wireless@vger.kernel.org>,
	bcm43xx-dev@lists.berlios.de, Michael Buesch <mb@bu3sch.de>,
	John Linville <linville@tuxdriver.com>
References: <45cc9ebb.+9O/IXvs/C9RyFnk%Larry.Finger@lwfinger.net> <200702120150.59747.rjw@sisk.pl> <45CFC062.1050301@lwfinger.net>
In-Reply-To: <45CFC062.1050301@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200702122148.58101.rjw@sisk.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday, 12 February 2007 02:18, Larry Finger wrote:
> Rafael J. Wysocki wrote:
> > 
> > It doesn't help in my case.  The behavior is similar to that without the patch,
> > but also with the patch it loses the association entirely.
> 
> Thanks for trying.
> 
> Do you have this patch installed? If you do, please try increasing the 100 to 200.

Hm, but it wouldn't help to get the microcode to respond after the resume ...

I'm still thinking the problem is with the firmware.  Where exactly is it
stored?

> 
> 
> Larry
> ---
> Index: linux-2.6/drivers/net/wireless/bcm43xx/bcm43xx.h
> ===================================================================
> --- linux-2.6.orig/drivers/net/wireless/bcm43xx/bcm43xx.h
> +++ linux-2.6/drivers/net/wireless/bcm43xx/bcm43xx.h
> @@ -21,7 +21,7 @@
>  #define PFX				KBUILD_MODNAME ": "
> 
>  #define BCM43xx_SWITCH_CORE_MAX_RETRIES	50
> -#define BCM43xx_IRQWAIT_MAX_RETRIES	50
> +#define BCM43xx_IRQWAIT_MAX_RETRIES	100
> 
>  #define BCM43xx_IO_SIZE			8192
> 

Greetings,
Rafael
