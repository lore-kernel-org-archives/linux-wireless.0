Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:55222
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764909AbXHWW1F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Aug 2007 18:27:05 -0400
Message-Id: <20070823222156.169085000@bu3sch.de>
References: <20070823222153.073035000@bu3sch.de>
Date: Fri, 24 Aug 2007 00:21:58 +0200
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
Subject: [patch 5/7] b43: Fix hwcrypto keyidx for new firmware.
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes crypto-RX on new firmware.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

Index: wireless-dev-new/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-dev-new.orig/drivers/net/wireless/b43/main.c	2007-08-23 23:36:22.000000000 +0200
+++ wireless-dev-new/drivers/net/wireless/b43/main.c	2007-08-23 23:40:23.000000000 +0200
@@ -730,13 +730,18 @@ static void key_write(struct b43_wldev *
 static void keymac_write(struct b43_wldev *dev, u8 index, const u8 * addr)
 {
 	u32 addrtmp[2];
+	u8 per_sta_keys_start = 8;
 
-	B43_WARN_ON(index < 4 + 4);
-	/* We have two default TX keys and two default RX keys.
-	 * Physical mac 0 is mapped to physical key 8.
+	if (b43_new_kidx_api(dev))
+		per_sta_keys_start = 4;
+
+	B43_WARN_ON(index < per_sta_keys_start);
+	/* We have two default TX keys and possibly two default RX keys.
+	 * Physical mac 0 is mapped to physical key 4 or 8, depending
+	 * on the firmware version.
 	 * So we must adjust the index here.
 	 */
-	index -= 8;
+	index -= per_sta_keys_start;
 
 	addrtmp[0] = addr[0];
 	addrtmp[0] |= ((u32) (addr[1]) << 8);
@@ -774,16 +779,20 @@ static void do_key_write(struct b43_wlde
 			 const u8 * key, size_t key_len, const u8 * mac_addr)
 {
 	u8 buf[B43_SEC_KEYSIZE];
+	u8 per_sta_keys_start = 8;
+
+	if (b43_new_kidx_api(dev))
+		per_sta_keys_start = 4;
 
 	B43_WARN_ON(index >= dev->max_nr_keys);
 	B43_WARN_ON(key_len > B43_SEC_KEYSIZE);
 
 	memset(buf, 0, sizeof(buf));
-	if (index >= 8)
+	if (index >= per_sta_keys_start)
 		keymac_write(dev, index, buf);	/* First zero out mac. */
 	memcpy(buf, key, key_len);
 	key_write(dev, index, algorithm, buf);
-	if (index >= 8)
+	if (index >= per_sta_keys_start)
 		keymac_write(dev, index, mac_addr);
 
 	dev->key[index].algorithm = algorithm;

-- 

