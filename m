Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:45600 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755996AbYFMO5J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jun 2008 10:57:09 -0400
From: Michael Buesch <mb@bu3sch.de>
To: bcm43xx-dev@lists.berlios.de
Subject: Re: [PATCH] ssb: Fix for incorrect Subsystem and PCI Product IDs on rev 4 SPROMs
Date: Fri, 13 Jun 2008 16:56:31 +0200
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
References: <200806131047.33710.mb@bu3sch.de>
In-Reply-To: <200806131047.33710.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200806131656.32463.mb@bu3sch.de> (sfid-20080613_165713_080910_901FA1D9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 13 June 2008 10:47:33 Michael Buesch wrote:
> From: Larry.Finger@lwfinger.net
> 
> In current ssb-sprom code, the Subsystem and Product ID's are wrong for rev 4
> SPROM's.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Signed-off-by: Michael Buesch <mb@bu3sch.de>
> ---
> 
> John, this is a bugfix for 2.6.26.
> 
> 
> Index: ssb_sprom/ssb_sprom.h
> ===================================================================
> --- ssb_sprom.orig/ssb_sprom.h
> +++ ssb_sprom/ssb_sprom.h

Oh, this changes the ssb userland tool. So I better apply it instead
of sending it to random unrelated people :P

> @@ -33,10 +33,10 @@
>  
>  /* byte offsets */
>  #define SPROM_SUBP		(0x02 * 2)
> -#define SPROM4_SUBP		(0x00 * 2)
> +#define SPROM4_SUBP		(0x02 * 2)
>  #define SPROM_SUBV		(0x03 * 2)
>  #define SPROM_PPID		(0x04 * 2)
> -#define SPROM4_PPID		(0x02 * 2)
> +#define SPROM4_PPID		(0x04 * 2)
>  #define SPROM_BFLHI		(0x1C * 2)
>  #define SPROM_IL0MACADDR	(0x24 * 2)
>  #define SPROM_ET0MACADDR	(0x27 * 2)
> 



-- 
Greetings Michael.
