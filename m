Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.230]:22417 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756189AbYEMTzV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 May 2008 15:55:21 -0400
Received: by wr-out-0506.google.com with SMTP id c48so1076407wra.1
        for <linux-wireless@vger.kernel.org>; Tue, 13 May 2008 12:55:20 -0700 (PDT)
Subject: [PATCH] b43: use the bitrev helpers rather than rolling a private
	one
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 13 May 2008 12:55:18 -0700
Message-Id: <1210708518.6191.0.camel@brick> (sfid-20080513_215536_635562_EF40AFC9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The 4-bit reversal flip_4bit is replaced with the bitrev helper
bitrev8 and a 4-bit shift.  The B43_WARN is moved to the location
where a register is read from for checking there.  The other caller
explicitly passes an array index which is guaranteed to be within range
and so a B43_WARN is not added there.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/net/wireless/b43/phy.c |   26 +++++---------------------
 1 files changed, 5 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/b43/phy.c b/drivers/net/wireless/b43/phy.c
index de024dc..3410674 100644
--- a/drivers/net/wireless/b43/phy.c
+++ b/drivers/net/wireless/b43/phy.c
@@ -28,6 +28,7 @@
 #include <linux/delay.h>
 #include <linux/io.h>
 #include <linux/types.h>
+#include <linux/bitrev.h>
 
 #include "b43.h"
 #include "phy.h"
@@ -85,23 +86,6 @@ const u8 b43_radio_channel_codes_bg[] = {
 
 static void b43_phy_initg(struct b43_wldev *dev);
 
-/* Reverse the bits of a 4bit value.
- * Example:  1101 is flipped 1011
- */
-static u16 flip_4bit(u16 value)
-{
-	u16 flipped = 0x0000;
-
-	B43_WARN_ON(value & ~0x000F);
-
-	flipped |= (value & 0x0001) << 3;
-	flipped |= (value & 0x0002) << 1;
-	flipped |= (value & 0x0004) >> 1;
-	flipped |= (value & 0x0008) >> 3;
-
-	return flipped;
-}
-
 static void generate_rfatt_list(struct b43_wldev *dev,
 				struct b43_rfatt_list *list)
 {
@@ -3069,13 +3053,13 @@ b43_radio_interference_mitigation_enable(struct b43_wldev *dev, int mode)
 		}
 		radio_stacksave(0x0078);
 		tmp = (b43_radio_read16(dev, 0x0078) & 0x001E);
-		flipped = flip_4bit(tmp);
+		B43_WARN_ON(tmp > 15);
+		flipped = bitrev8(tmp) >> 4;
 		if (flipped < 10 && flipped >= 8)
 			flipped = 7;
 		else if (flipped >= 10)
 			flipped -= 3;
-		flipped = flip_4bit(flipped);
-		flipped = (flipped << 1) | 0x0020;
+		flipped = (bitrev8(flipped) >> 3) | 0x0020;
 		b43_radio_write16(dev, 0x0078, flipped);
 
 		b43_calc_nrssi_threshold(dev);
@@ -3708,7 +3692,7 @@ u16 b43_radio_init2050(struct b43_wldev *dev)
 	tmp1 >>= 9;
 
 	for (i = 0; i < 16; i++) {
-		radio78 = ((flip_4bit(i) << 1) | 0x20);
+		radio78 = (bitrev8(i) >> 3) | 0x0020;
 		b43_radio_write16(dev, 0x78, radio78);
 		udelay(10);
 		for (j = 0; j < 16; j++) {
-- 
1.5.5.1.482.g0f174



