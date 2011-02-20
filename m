Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:49387 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752403Ab1BTM6M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Feb 2011 07:58:12 -0500
Received: by eye27 with SMTP id 27so2477447eye.19
        for <linux-wireless@vger.kernel.org>; Sun, 20 Feb 2011 04:58:10 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 6/8] rt2x00: Add/Modify protection related register definitions
Date: Sun, 20 Feb 2011 13:56:54 +0100
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
References: <201102201354.53379.IvDoorn@gmail.com> <201102201356.08735.IvDoorn@gmail.com> <201102201356.27555.IvDoorn@gmail.com>
In-Reply-To: <201102201356.27555.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201102201356.55216.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Shiang Tu <shiang_tu@ralinktech.com>

Make the definition of protection related registers more precisely

Signed-off-by: Shiang Tu <shiang_tu@ralinktech.com>
Acked-by: Helmut Schaa <helmut.schaa@googlemail.com>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800.h    |   22 ++++++++++++++--------
 drivers/net/wireless/rt2x00/rt2800lib.c |   12 ++++++------
 2 files changed, 20 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
index 457887c..d3a693b 100644
--- a/drivers/net/wireless/rt2x00/rt2800.h
+++ b/drivers/net/wireless/rt2x00/rt2800.h
@@ -1138,8 +1138,8 @@
  * PROTECT_RATE: Protection control frame rate for CCK TX(RTS/CTS/CFEnd)
  * PROTECT_CTRL: Protection control frame type for CCK TX
  *               0:none, 1:RTS/CTS, 2:CTS-to-self
- * PROTECT_NAV: TXOP protection type for CCK TX
- *              0:none, 1:ShortNAVprotect, 2:LongNAVProtect
+ * PROTECT_NAV_SHORT: TXOP protection type for CCK TX with short NAV
+ * PROTECT_NAV_LONG: TXOP protection type for CCK TX with long NAV
  * TX_OP_ALLOW_CCK: CCK TXOP allowance, 0:disallow
  * TX_OP_ALLOW_OFDM: CCK TXOP allowance, 0:disallow
  * TX_OP_ALLOW_MM20: CCK TXOP allowance, 0:disallow
@@ -1151,7 +1151,8 @@
 #define CCK_PROT_CFG			0x1364
 #define CCK_PROT_CFG_PROTECT_RATE	FIELD32(0x0000ffff)
 #define CCK_PROT_CFG_PROTECT_CTRL	FIELD32(0x00030000)
-#define CCK_PROT_CFG_PROTECT_NAV	FIELD32(0x000c0000)
+#define CCK_PROT_CFG_PROTECT_NAV_SHORT	FIELD32(0x00040000)
+#define CCK_PROT_CFG_PROTECT_NAV_LONG	FIELD32(0x00080000)
 #define CCK_PROT_CFG_TX_OP_ALLOW_CCK	FIELD32(0x00100000)
 #define CCK_PROT_CFG_TX_OP_ALLOW_OFDM	FIELD32(0x00200000)
 #define CCK_PROT_CFG_TX_OP_ALLOW_MM20	FIELD32(0x00400000)
@@ -1166,7 +1167,8 @@
 #define OFDM_PROT_CFG			0x1368
 #define OFDM_PROT_CFG_PROTECT_RATE	FIELD32(0x0000ffff)
 #define OFDM_PROT_CFG_PROTECT_CTRL	FIELD32(0x00030000)
-#define OFDM_PROT_CFG_PROTECT_NAV	FIELD32(0x000c0000)
+#define OFDM_PROT_CFG_PROTECT_NAV_SHORT	FIELD32(0x00040000)
+#define OFDM_PROT_CFG_PROTECT_NAV_LONG	FIELD32(0x00080000)
 #define OFDM_PROT_CFG_TX_OP_ALLOW_CCK	FIELD32(0x00100000)
 #define OFDM_PROT_CFG_TX_OP_ALLOW_OFDM	FIELD32(0x00200000)
 #define OFDM_PROT_CFG_TX_OP_ALLOW_MM20	FIELD32(0x00400000)
@@ -1181,7 +1183,8 @@
 #define MM20_PROT_CFG			0x136c
 #define MM20_PROT_CFG_PROTECT_RATE	FIELD32(0x0000ffff)
 #define MM20_PROT_CFG_PROTECT_CTRL	FIELD32(0x00030000)
-#define MM20_PROT_CFG_PROTECT_NAV	FIELD32(0x000c0000)
+#define MM20_PROT_CFG_PROTECT_NAV_SHORT	FIELD32(0x00040000)
+#define MM20_PROT_CFG_PROTECT_NAV_LONG	FIELD32(0x00080000)
 #define MM20_PROT_CFG_TX_OP_ALLOW_CCK	FIELD32(0x00100000)
 #define MM20_PROT_CFG_TX_OP_ALLOW_OFDM	FIELD32(0x00200000)
 #define MM20_PROT_CFG_TX_OP_ALLOW_MM20	FIELD32(0x00400000)
@@ -1196,7 +1199,8 @@
 #define MM40_PROT_CFG			0x1370
 #define MM40_PROT_CFG_PROTECT_RATE	FIELD32(0x0000ffff)
 #define MM40_PROT_CFG_PROTECT_CTRL	FIELD32(0x00030000)
-#define MM40_PROT_CFG_PROTECT_NAV	FIELD32(0x000c0000)
+#define MM40_PROT_CFG_PROTECT_NAV_SHORT	FIELD32(0x00040000)
+#define MM40_PROT_CFG_PROTECT_NAV_LONG	FIELD32(0x00080000)
 #define MM40_PROT_CFG_TX_OP_ALLOW_CCK	FIELD32(0x00100000)
 #define MM40_PROT_CFG_TX_OP_ALLOW_OFDM	FIELD32(0x00200000)
 #define MM40_PROT_CFG_TX_OP_ALLOW_MM20	FIELD32(0x00400000)
@@ -1211,7 +1215,8 @@
 #define GF20_PROT_CFG			0x1374
 #define GF20_PROT_CFG_PROTECT_RATE	FIELD32(0x0000ffff)
 #define GF20_PROT_CFG_PROTECT_CTRL	FIELD32(0x00030000)
-#define GF20_PROT_CFG_PROTECT_NAV	FIELD32(0x000c0000)
+#define GF20_PROT_CFG_PROTECT_NAV_SHORT	FIELD32(0x00040000)
+#define GF20_PROT_CFG_PROTECT_NAV_LONG	FIELD32(0x00080000)
 #define GF20_PROT_CFG_TX_OP_ALLOW_CCK	FIELD32(0x00100000)
 #define GF20_PROT_CFG_TX_OP_ALLOW_OFDM	FIELD32(0x00200000)
 #define GF20_PROT_CFG_TX_OP_ALLOW_MM20	FIELD32(0x00400000)
@@ -1226,7 +1231,8 @@
 #define GF40_PROT_CFG			0x1378
 #define GF40_PROT_CFG_PROTECT_RATE	FIELD32(0x0000ffff)
 #define GF40_PROT_CFG_PROTECT_CTRL	FIELD32(0x00030000)
-#define GF40_PROT_CFG_PROTECT_NAV	FIELD32(0x000c0000)
+#define GF40_PROT_CFG_PROTECT_NAV_SHORT	FIELD32(0x00040000)
+#define GF40_PROT_CFG_PROTECT_NAV_LONG	FIELD32(0x00080000)
 #define GF40_PROT_CFG_TX_OP_ALLOW_CCK	FIELD32(0x00100000)
 #define GF40_PROT_CFG_TX_OP_ALLOW_OFDM	FIELD32(0x00200000)
 #define GF40_PROT_CFG_TX_OP_ALLOW_MM20	FIELD32(0x00400000)
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index d23a5d8..5592180 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -2185,7 +2185,7 @@ static int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
 	rt2800_register_read(rt2x00dev, CCK_PROT_CFG, &reg);
 	rt2x00_set_field32(&reg, CCK_PROT_CFG_PROTECT_RATE, 3);
 	rt2x00_set_field32(&reg, CCK_PROT_CFG_PROTECT_CTRL, 0);
-	rt2x00_set_field32(&reg, CCK_PROT_CFG_PROTECT_NAV, 1);
+	rt2x00_set_field32(&reg, CCK_PROT_CFG_PROTECT_NAV_SHORT, 1);
 	rt2x00_set_field32(&reg, CCK_PROT_CFG_TX_OP_ALLOW_CCK, 1);
 	rt2x00_set_field32(&reg, CCK_PROT_CFG_TX_OP_ALLOW_OFDM, 1);
 	rt2x00_set_field32(&reg, CCK_PROT_CFG_TX_OP_ALLOW_MM20, 1);
@@ -2198,7 +2198,7 @@ static int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
 	rt2800_register_read(rt2x00dev, OFDM_PROT_CFG, &reg);
 	rt2x00_set_field32(&reg, OFDM_PROT_CFG_PROTECT_RATE, 3);
 	rt2x00_set_field32(&reg, OFDM_PROT_CFG_PROTECT_CTRL, 0);
-	rt2x00_set_field32(&reg, OFDM_PROT_CFG_PROTECT_NAV, 1);
+	rt2x00_set_field32(&reg, OFDM_PROT_CFG_PROTECT_NAV_SHORT, 1);
 	rt2x00_set_field32(&reg, OFDM_PROT_CFG_TX_OP_ALLOW_CCK, 1);
 	rt2x00_set_field32(&reg, OFDM_PROT_CFG_TX_OP_ALLOW_OFDM, 1);
 	rt2x00_set_field32(&reg, OFDM_PROT_CFG_TX_OP_ALLOW_MM20, 1);
@@ -2211,7 +2211,7 @@ static int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
 	rt2800_register_read(rt2x00dev, MM20_PROT_CFG, &reg);
 	rt2x00_set_field32(&reg, MM20_PROT_CFG_PROTECT_RATE, 0x4004);
 	rt2x00_set_field32(&reg, MM20_PROT_CFG_PROTECT_CTRL, 0);
-	rt2x00_set_field32(&reg, MM20_PROT_CFG_PROTECT_NAV, 1);
+	rt2x00_set_field32(&reg, MM20_PROT_CFG_PROTECT_NAV_SHORT, 1);
 	rt2x00_set_field32(&reg, MM20_PROT_CFG_TX_OP_ALLOW_CCK, 1);
 	rt2x00_set_field32(&reg, MM20_PROT_CFG_TX_OP_ALLOW_OFDM, 1);
 	rt2x00_set_field32(&reg, MM20_PROT_CFG_TX_OP_ALLOW_MM20, 1);
@@ -2224,7 +2224,7 @@ static int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
 	rt2800_register_read(rt2x00dev, MM40_PROT_CFG, &reg);
 	rt2x00_set_field32(&reg, MM40_PROT_CFG_PROTECT_RATE, 0x4084);
 	rt2x00_set_field32(&reg, MM40_PROT_CFG_PROTECT_CTRL, 0);
-	rt2x00_set_field32(&reg, MM40_PROT_CFG_PROTECT_NAV, 1);
+	rt2x00_set_field32(&reg, MM40_PROT_CFG_PROTECT_NAV_SHORT, 1);
 	rt2x00_set_field32(&reg, MM40_PROT_CFG_TX_OP_ALLOW_CCK, 1);
 	rt2x00_set_field32(&reg, MM40_PROT_CFG_TX_OP_ALLOW_OFDM, 1);
 	rt2x00_set_field32(&reg, MM40_PROT_CFG_TX_OP_ALLOW_MM20, 1);
@@ -2237,7 +2237,7 @@ static int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
 	rt2800_register_read(rt2x00dev, GF20_PROT_CFG, &reg);
 	rt2x00_set_field32(&reg, GF20_PROT_CFG_PROTECT_RATE, 0x4004);
 	rt2x00_set_field32(&reg, GF20_PROT_CFG_PROTECT_CTRL, 0);
-	rt2x00_set_field32(&reg, GF20_PROT_CFG_PROTECT_NAV, 1);
+	rt2x00_set_field32(&reg, GF20_PROT_CFG_PROTECT_NAV_SHORT, 1);
 	rt2x00_set_field32(&reg, GF20_PROT_CFG_TX_OP_ALLOW_CCK, 1);
 	rt2x00_set_field32(&reg, GF20_PROT_CFG_TX_OP_ALLOW_OFDM, 1);
 	rt2x00_set_field32(&reg, GF20_PROT_CFG_TX_OP_ALLOW_MM20, 1);
@@ -2250,7 +2250,7 @@ static int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
 	rt2800_register_read(rt2x00dev, GF40_PROT_CFG, &reg);
 	rt2x00_set_field32(&reg, GF40_PROT_CFG_PROTECT_RATE, 0x4084);
 	rt2x00_set_field32(&reg, GF40_PROT_CFG_PROTECT_CTRL, 0);
-	rt2x00_set_field32(&reg, GF40_PROT_CFG_PROTECT_NAV, 1);
+	rt2x00_set_field32(&reg, GF40_PROT_CFG_PROTECT_NAV_SHORT, 1);
 	rt2x00_set_field32(&reg, GF40_PROT_CFG_TX_OP_ALLOW_CCK, 1);
 	rt2x00_set_field32(&reg, GF40_PROT_CFG_TX_OP_ALLOW_OFDM, 1);
 	rt2x00_set_field32(&reg, GF40_PROT_CFG_TX_OP_ALLOW_MM20, 1);
-- 
1.7.2.3

