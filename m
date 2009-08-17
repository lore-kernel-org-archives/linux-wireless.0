Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.24]:23125 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757157AbZHQQ42 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2009 12:56:28 -0400
Received: by ey-out-2122.google.com with SMTP id 22so711134eye.37
        for <linux-wireless@vger.kernel.org>; Mon, 17 Aug 2009 09:56:29 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH 2/7] rt2x00: Fix for rt2800usb for SHARED_KEY_TABLE initializations
Date: Mon, 17 Aug 2009 18:53:57 +0200
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	users@rt2x00.serialmonkey.com,
	Benoit PAPILLAULT <benoit.papillault@free.fr>
References: <200908171853.24256.IvDoorn@gmail.com>
In-Reply-To: <200908171853.24256.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200908171853.57397.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixed comments about SHARED_KEY_TABLE_BASE and SHARED_KEY_MODE_BASE.
Fixed initialization loop for SHARED_KEY_MODE_ENTRY.

Based on a patch for rt2800pci from Benoit.

Signed-off-by: Benoit PAPILLAULT <benoit.papillault@free.fr>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800usb.c |    8 ++++----
 drivers/net/wireless/rt2x00/rt2800usb.h |    4 ++--
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 3856f06..c82474e 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -1463,6 +1463,10 @@ static int rt2800usb_init_registers(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * ASIC will keep garbage value after boot, clear encryption keys.
 	 */
+	for (i = 0; i < 4; i++)
+		rt2x00usb_register_write(rt2x00dev,
+					 SHARED_KEY_MODE_ENTRY(i), 0);
+
 	for (i = 0; i < 256; i++) {
 		u32 wcid[2] = { 0xffffffff, 0x00ffffff };
 		rt2x00usb_register_multiwrite(rt2x00dev, MAC_WCID_ENTRY(i),
@@ -1472,10 +1476,6 @@ static int rt2800usb_init_registers(struct rt2x00_dev *rt2x00dev)
 		rt2x00usb_register_write(rt2x00dev, MAC_IVEIV_ENTRY(i), 0);
 	}
 
-	for (i = 0; i < 16; i++)
-		rt2x00usb_register_write(rt2x00dev,
-					 SHARED_KEY_MODE_ENTRY(i), 0);
-
 	/*
 	 * Clear all beacons
 	 * For the Beacon base registers we only need to clear
diff --git a/drivers/net/wireless/rt2x00/rt2800usb.h b/drivers/net/wireless/rt2x00/rt2800usb.h
index 2d9dc37..a79a6d9 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.h
+++ b/drivers/net/wireless/rt2x00/rt2800usb.h
@@ -1300,8 +1300,8 @@
  * PAIRWISE_KEY_TABLE_BASE: 32-byte * 256 entry
  * MAC_IVEIV_TABLE_BASE: 8-byte * 256-entry
  * MAC_WCID_ATTRIBUTE_BASE: 4-byte * 256-entry
- * SHARED_KEY_TABLE_BASE: 32-byte * 16-entry
- * SHARED_KEY_MODE_BASE: 4-byte * 16-entry
+ * SHARED_KEY_TABLE_BASE: 32 bytes * 32-entry
+ * SHARED_KEY_MODE_BASE: 4 bits * 32-entry
  */
 #define MAC_WCID_BASE			0x1800
 #define PAIRWISE_KEY_TABLE_BASE		0x4000
-- 
1.6.4

