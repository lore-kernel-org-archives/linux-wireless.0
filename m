Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hall.aurel32.net ([88.191.38.19]:35978 "EHLO hall.aurel32.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935018AbXHLXu7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Aug 2007 19:50:59 -0400
Date: Mon, 13 Aug 2007 01:50:58 +0200
From: Aurelien Jarno <aurelien@aurel32.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH][SSB] Fix a warning in PCI core driver
Message-ID: <20070812235058.GA4966@hall.aurel32.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The patch below fixes a warning spotted a few days ago by Andrew Morton
while releasing 2.6.23-rc2-mm1.

Signed-off-by: Aurelien Jarno <aurelien@aurel32.net>

--- a/drivers/ssb/driver_pcicore.c
+++ b/drivers/ssb/driver_pcicore.c
@@ -278,7 +278,7 @@
 static struct resource ssb_pcicore_mem_resource = {
 	.name	= "SSB PCIcore external memory",
 	.start	= SSB_PCI_DMA,
-	.end	= SSB_PCI_DMA + SSB_PCI_DMA_SZ - 1,
+	.end	= (u32)SSB_PCI_DMA + (u32)SSB_PCI_DMA_SZ - 1,
 	.flags	= IORESOURCE_MEM,
 };
 

-- 
  .''`.  Aurelien Jarno	            | GPG: 1024D/F1BCDB73
 : :' :  Debian developer           | Electrical Engineer
 `. `'   aurel32@debian.org         | aurelien@aurel32.net
   `-    people.debian.org/~aurel32 | www.aurel32.net
