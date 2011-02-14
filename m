Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 80-190-117-144.ip-home.de ([80.190.117.144]:34750 "EHLO
	bu3sch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751799Ab1BNXWE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Feb 2011 18:22:04 -0500
Subject: [PATCH] ssb: Make ssb_wait_bit multi-bit safe
From: Michael =?ISO-8859-1?Q?B=FCsch?= <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Cc: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
	b43-dev <b43-dev@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 15 Feb 2011 00:21:50 +0100
Message-ID: <1297725710.5683.17.camel@maggie>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ssb_wait_bit was designed for only one-bit bitmasks.
People start using it for multi-bit bitmasks. Make the "set" case
is safe for this. The "unset" case is already safe.

This does not change behavior of the current code.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

Index: wireless-testing/drivers/ssb/main.c
===================================================================
--- wireless-testing.orig/drivers/ssb/main.c	2010-12-30 15:49:39.235946210 +0100
+++ wireless-testing/drivers/ssb/main.c	2011-02-15 00:17:35.727816704 +0100
@@ -1192,10 +1192,10 @@ void ssb_device_enable(struct ssb_device
 }
 EXPORT_SYMBOL(ssb_device_enable);
 
-/* Wait for a bit in a register to get set or unset.
+/* Wait for bitmask in a register to get set or cleared.
  * timeout is in units of ten-microseconds */
-static int ssb_wait_bit(struct ssb_device *dev, u16 reg, u32 bitmask,
-			int timeout, int set)
+static int ssb_wait_bits(struct ssb_device *dev, u16 reg, u32 bitmask,
+			 int timeout, int set)
 {
 	int i;
 	u32 val;
@@ -1203,7 +1203,7 @@ static int ssb_wait_bit(struct ssb_devic
 	for (i = 0; i < timeout; i++) {
 		val = ssb_read32(dev, reg);
 		if (set) {
-			if (val & bitmask)
+			if ((val & bitmask) == bitmask)
 				return 0;
 		} else {
 			if (!(val & bitmask))
@@ -1227,8 +1227,8 @@ void ssb_device_disable(struct ssb_devic
 
 	reject = ssb_tmslow_reject_bitmask(dev);
 	ssb_write32(dev, SSB_TMSLOW, reject | SSB_TMSLOW_CLOCK);
-	ssb_wait_bit(dev, SSB_TMSLOW, reject, 1000, 1);
-	ssb_wait_bit(dev, SSB_TMSHIGH, SSB_TMSHIGH_BUSY, 1000, 0);
+	ssb_wait_bits(dev, SSB_TMSLOW, reject, 1000, 1);
+	ssb_wait_bits(dev, SSB_TMSHIGH, SSB_TMSHIGH_BUSY, 1000, 0);
 	ssb_write32(dev, SSB_TMSLOW,
 		    SSB_TMSLOW_FGC | SSB_TMSLOW_CLOCK |
 		    reject | SSB_TMSLOW_RESET |

-- 
Greetings Michael.

