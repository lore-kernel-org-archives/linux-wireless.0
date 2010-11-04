Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:59008 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751465Ab0KDTnh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Nov 2010 15:43:37 -0400
Received: by eye27 with SMTP id 27so1320245eye.19
        for <linux-wireless@vger.kernel.org>; Thu, 04 Nov 2010 12:43:36 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 01/13] rt2x00: Add TXOP_CTRL_CFG register definition
Date: Thu, 4 Nov 2010 20:36:59 +0100
Cc: Helmut Schaa <helmut.schaa@googlemail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201011042037.00178.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Helmut Schaa <helmut.schaa@googlemail.com>

Remove the magic value initialisation of the TXOP_CTRL_CFG register by
defining its fields and using them during intialisation. The field
RESERVED_TRUN_EN is referred to as reserved, however it is set to 1 by
the legacy drivers. Hence, do the same.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800.h    |   23 +++++++++++++++++++++++
 drivers/net/wireless/rt2x00/rt2800lib.c |   18 +++++++++++++++++-
 2 files changed, 40 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
index eb8b6ca..6cfed06 100644
--- a/drivers/net/wireless/rt2x00/rt2800.h
+++ b/drivers/net/wireless/rt2x00/rt2800.h
@@ -960,8 +960,31 @@
 
 /*
  * TXOP_CTRL_CFG:
+ * TIMEOUT_TRUN_EN: Enable/Disable TXOP timeout truncation
+ * AC_TRUN_EN: Enable/Disable truncation for AC change
+ * TXRATEGRP_TRUN_EN: Enable/Disable truncation for TX rate group change
+ * USER_MODE_TRUN_EN: Enable/Disable truncation for user TXOP mode
+ * MIMO_PS_TRUN_EN: Enable/Disable truncation for MIMO PS RTS/CTS
+ * RESERVED_TRUN_EN: Reserved
+ * LSIG_TXOP_EN: Enable/Disable L-SIG TXOP protection
+ * EXT_CCA_EN: Enable/Disable extension channel CCA reference (Defer 40Mhz
+ *	       transmissions if extension CCA is clear).
+ * EXT_CCA_DLY: Extension CCA signal delay time (unit: us)
+ * EXT_CWMIN: CwMin for extension channel backoff
+ *	      0: Disabled
+ *
  */
 #define TXOP_CTRL_CFG			0x1340
+#define TXOP_CTRL_CFG_TIMEOUT_TRUN_EN	FIELD32(0x00000001)
+#define TXOP_CTRL_CFG_AC_TRUN_EN	FIELD32(0x00000002)
+#define TXOP_CTRL_CFG_TXRATEGRP_TRUN_EN	FIELD32(0x00000004)
+#define TXOP_CTRL_CFG_USER_MODE_TRUN_EN	FIELD32(0x00000008)
+#define TXOP_CTRL_CFG_MIMO_PS_TRUN_EN	FIELD32(0x00000010)
+#define TXOP_CTRL_CFG_RESERVED_TRUN_EN	FIELD32(0x00000020)
+#define TXOP_CTRL_CFG_LSIG_TXOP_EN	FIELD32(0x00000040)
+#define TXOP_CTRL_CFG_EXT_CCA_EN	FIELD32(0x00000080)
+#define TXOP_CTRL_CFG_EXT_CCA_DLY	FIELD32(0x0000ff00)
+#define TXOP_CTRL_CFG_EXT_CWMIN		FIELD32(0x000f0000)
 
 /*
  * TX_RTS_CFG:
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 5f00e00..54bf085 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -2097,7 +2097,23 @@ static int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
 		rt2800_register_write(rt2x00dev, WPDMA_GLO_CFG, reg);
 	}
 
-	rt2800_register_write(rt2x00dev, TXOP_CTRL_CFG, 0x0000583f);
+	/*
+	 * The legacy driver also sets TXOP_CTRL_CFG_RESERVED_TRUN_EN to 1
+	 * although it is reserved.
+	 */
+	rt2800_register_read(rt2x00dev, TXOP_CTRL_CFG, &reg);
+	rt2x00_set_field32(&reg, TXOP_CTRL_CFG_TIMEOUT_TRUN_EN, 1);
+	rt2x00_set_field32(&reg, TXOP_CTRL_CFG_AC_TRUN_EN, 1);
+	rt2x00_set_field32(&reg, TXOP_CTRL_CFG_TXRATEGRP_TRUN_EN, 1);
+	rt2x00_set_field32(&reg, TXOP_CTRL_CFG_USER_MODE_TRUN_EN, 1);
+	rt2x00_set_field32(&reg, TXOP_CTRL_CFG_MIMO_PS_TRUN_EN, 1);
+	rt2x00_set_field32(&reg, TXOP_CTRL_CFG_RESERVED_TRUN_EN, 1);
+	rt2x00_set_field32(&reg, TXOP_CTRL_CFG_LSIG_TXOP_EN, 0);
+	rt2x00_set_field32(&reg, TXOP_CTRL_CFG_EXT_CCA_EN, 0);
+	rt2x00_set_field32(&reg, TXOP_CTRL_CFG_EXT_CCA_DLY, 88);
+	rt2x00_set_field32(&reg, TXOP_CTRL_CFG_EXT_CWMIN, 0);
+	rt2800_register_write(rt2x00dev, TXOP_CTRL_CFG, reg);
+
 	rt2800_register_write(rt2x00dev, TXOP_HLDR_ET, 0x00000002);
 
 	rt2800_register_read(rt2x00dev, TX_RTS_CFG, &reg);
-- 
1.7.2.3

