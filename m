Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:41353
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753136AbXHKAGK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Aug 2007 20:06:10 -0400
Message-Id: <20070811000357.090532000@bu3sch.de>
References: <20070811000354.611868000@bu3sch.de>
Date: Sat, 11 Aug 2007 02:03:57 +0200
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de,
	Aurelien Jarno <aurelien@aurel32.net>
Subject: [patch 3/5] ssb: Read the UART divisor instead of setting it
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Aurelien Jarno <aurelien@aurel32.net>

I finally have one more patch for the SSB bus driver. I have ported the
BCM947xx code to the CFE API that is already in the kernel, and I have
seen that when the chip common driver initializes the serial port, it
breaks the CFE console (used as an early console until the serial port
is initialized). This is due to the change of the UART clock in 
ssb_chipco_serial_init().

The patch below reads the current UART divisor value and use it to 
compute baud_base instead of forcing a fixed divisor value. This limits
the maximum speed of the serial port, but don't forget the SSB bus runs 
at around 100MHz. CFE initializes the divisor so that baud_base equals 
1.8432MHz, which is already fast for a serial port.

Signed-off-by: Aurelien Jarno <aurelien@aurel32.net>

Index: ssb-merge/drivers/ssb/driver_chipcommon.c
===================================================================
--- ssb-merge.orig/drivers/ssb/driver_chipcommon.c	2007-08-10 13:30:21.000000000 +0200
+++ ssb-merge/drivers/ssb/driver_chipcommon.c	2007-08-10 13:31:14.000000000 +0200
@@ -375,10 +375,8 @@ int ssb_chipco_serial_init(struct ssb_ch
 		} else if (cc->dev->id.revision >= 3) {
 			/* Internal backplane clock */
 			baud_base = ssb_clockspeed(bus);
-			div = 2; /* Minimum divisor */
-			chipco_write32(cc, SSB_CHIPCO_CLKDIV,
-				       (chipco_read32(cc, SSB_CHIPCO_CLKDIV)
-					& ~SSB_CHIPCO_CLKDIV_UART) | div);
+			div = chipco_read32(cc, SSB_CHIPCO_CLKDIV)
+			      & SSB_CHIPCO_CLKDIV_UART;
 		} else {
 			/* Fixed internal backplane clock */
 			baud_base = 88000000;

-- 

