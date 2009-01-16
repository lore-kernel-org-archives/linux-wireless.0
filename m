Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:46507 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937052AbZAPS3d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jan 2009 13:29:33 -0500
From: Christian Lamparter <chunkeey@web.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH] p54spi: fix build dependencies
Date: Fri, 16 Jan 2009 19:29:29 +0100
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>
References: <E1LNgyq-0006iZ-0M@sipsolutions.net> <1232098259.3854.39.camel@johannes>
In-Reply-To: <1232098259.3854.39.camel@johannes>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200901161929.30204.chunkeey@web.de> (sfid-20090116_192953_828755_ADE89C5D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 16 January 2009 10:30:59 Johannes Berg wrote:
> On Fri, 2009-01-16 at 06:15 +0100, Cron Daemon wrote:
> > 
> > +drivers/net/wireless/p54/p54spi.h:28:11: error: unable to open 'mach/board.h'
> > +make[2]: *** [drivers/net/wireless/p54/p54spi.o] Error 1
> > +make[1]: *** [drivers/net/wireless/p54] Error 2
> > +make: *** [_module_drivers/net/wireless] Error 2
> 
> p54spi only depends on SPI_MASTER, but includes arm-specific files.

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
diff --git a/drivers/net/wireless/p54/Kconfig b/drivers/net/wireless/p54/Kconfig
index cfc5f41..131dba3 100644
--- a/drivers/net/wireless/p54/Kconfig
+++ b/drivers/net/wireless/p54/Kconfig
@@ -64,7 +64,8 @@ config P54_PCI
 
 config P54_SPI
 	tristate "Prism54 SPI (stlc45xx) support"
-	depends on P54_COMMON && SPI_MASTER
+	depends on P54_COMMON && SPI_MASTER && ARCH_OMAP && \
+		   (MACH_NOKIA_N800 || MACH_NOKIA_N810)
 	---help---
 	  This driver is for stlc4550 or stlc4560 based wireless chips.
 	  This driver is experimental, untested and will probably only work on
