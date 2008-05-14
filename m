Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52859 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756057AbYENX10 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 May 2008 19:27:26 -0400
Message-Id: <200805142326.m4ENQN38027114@imap1.linux-foundation.org> (sfid-20080515_012729_403497_5DB1B4C1)
Subject: [patch 12/12] b43: use the bitrev helpers rather than rolling a private one
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, akpm@linux-foundation.org,
	harvey.harrison@gmail.com, mb@bu3sch.de
From: akpm@linux-foundation.org
Date: Wed, 14 May 2008 16:26:22 -0700
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Harvey Harrison <harvey.harrison@gmail.com>

The 4-bit reversal flip_4bit is replaced with the bitrev helper bitrev8
and a 4-bit shift.  The B43_WARN is moved to the location where a register
is read from for checking there.  The other caller explicitly passes an
array index which is guaranteed to be within range and so a B43_WARN is
not added there.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Acked-by: Michael Buesch <mb@bu3sch.de>
Cc: "John W. Linville" <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/b43/phy.c |   26 +++++---------------------
 1 file changed, 5 insertions(+), 21 deletions(-)

diff -puN drivers/net/wireless/b43/phy.c~b43-use-the-bitrev-helpers-rather-than-rolling-a-private-one drivers/net/wireless/b43/phy.c
--- a/drivers/net/wireless/b43/phy.c~b43-use-the-bitrev-helpers-rather-than-rolling-a-private-one
+++ a/drivers/net/wireless/b43/phy.c
@@ -28,6 +28,7 @@
 #include <linux/delay.h>
 #include <linux/io.h>
 #include <linux/types.h>
+#include <linux/bitrev.h>
 
 #include "b43.h"
 #include "phy.h"
@@ -85,23 +86,6 @@ const u8 b43_radio_channel_codes_bg[] = 
 
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
@@ -2891,13 +2875,13 @@ b43_radio_interference_mitigation_enable
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
@@ -3530,7 +3514,7 @@ u16 b43_radio_init2050(struct b43_wldev 
 	tmp1 >>= 9;
 
 	for (i = 0; i < 16; i++) {
-		radio78 = ((flip_4bit(i) << 1) | 0x20);
+		radio78 = (bitrev8(i) >> 3) | 0x0020;
 		b43_radio_write16(dev, 0x78, radio78);
 		udelay(10);
 		for (j = 0; j < 16; j++) {
_
