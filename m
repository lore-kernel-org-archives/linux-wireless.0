Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:41907 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752375Ab0JAUde (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Oct 2010 16:33:34 -0400
From: Anand Gadiyar <gadiyar@ti.com>
To: linux-omap@vger.kernel.org, linux-wireless@vger.kernel.org
Cc: Anand Gadiyar <gadiyar@ti.com>, Ohad Ben-Cohen <ohad@wizery.com>,
	Tony Lindgren <tony@atomide.com>
Subject: [PATCH] omap: zoom2/3: fix build caused by wl1271 support
Date: Sat,  2 Oct 2010 02:03:26 +0530
Message-Id: <1285965206-17777-1-git-send-email-gadiyar@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Patch "omap: zoom: add mmc3/wl1271 device support" in the
wireless tree still uses .wires in struct omap2_hsmmc_info.
.wires has now been replaced with .caps in patch "omap: mmc:
extended to pass host capabilities from board file" in the
OMAP tree.

This causes linux-next as of 20101001 build to break as
below. Fix this.

  CC      arch/arm/mach-omap2/board-zoom-peripherals.o
arch/arm/mach-omap2/board-zoom-peripherals.c:217: error: unknown field 'wires' specified in initializer
make[1]: *** [arch/arm/mach-omap2/board-zoom-peripherals.o] Error 1
make: *** [arch/arm/mach-omap2] Error 2

Signed-off-by: Anand Gadiyar <gadiyar@ti.com>
Cc: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap2/board-zoom-peripherals.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/arch/arm/mach-omap2/board-zoom-peripherals.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-omap2/board-zoom-peripherals.c
+++ linux-2.6/arch/arm/mach-omap2/board-zoom-peripherals.c
@@ -214,7 +214,7 @@ static struct omap2_hsmmc_info mmc[] __i
 	{
 		.name		= "wl1271",
 		.mmc		= 3,
-		.wires		= 4,
+		.caps		= MMC_CAP_4_BIT_DATA,
 		.gpio_wp	= -EINVAL,
 		.gpio_cd	= -EINVAL,
 		.nonremovable	= true,
