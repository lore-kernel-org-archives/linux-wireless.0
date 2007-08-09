Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hall.aurel32.net ([88.191.38.19]:55857 "EHLO hall.aurel32.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752918AbXHIXJf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Aug 2007 19:09:35 -0400
Date: Fri, 10 Aug 2007 01:09:34 +0200
From: Aurelien Jarno <aurelien@aurel32.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH][SSB] Read the UART divisor instead of setting it
Message-ID: <20070809230934.GA20434@hall.aurel32.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

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

--- a/drivers/ssb/driver_chipcommon.c
+++ b/drivers/ssb/driver_chipcommon.c
@@ -375,10 +375,8 @@
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
  .''`.  Aurelien Jarno	            | GPG: 1024D/F1BCDB73
 : :' :  Debian developer           | Electrical Engineer
 `. `'   aurel32@debian.org         | aurelien@aurel32.net
   `-    people.debian.org/~aurel32 | www.aurel32.net
