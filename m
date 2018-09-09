Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:52697 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726839AbeIJBX7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 9 Sep 2018 21:23:59 -0400
Received: by mail-wm0-f68.google.com with SMTP id y139-v6so19309652wmc.2
        for <linux-wireless@vger.kernel.org>; Sun, 09 Sep 2018 13:33:05 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 08/11] mt76x02: move TXD/RXD/MCU definitions in mt76x02_dma.h
Date: Sun,  9 Sep 2018 22:32:43 +0200
Message-Id: <20180909203246.21608-9-lorenzo.bianconi@redhat.com> (sfid-20180909_223311_469066_EE01BFEE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Introduce mt76x02_dma.h header file to contain mt76x02 dma
related definitions

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/dma.h      | 38 ------------
 .../net/wireless/mediatek/mt76/mt76x02_dma.h  | 60 +++++++++++++++++++
 .../wireless/mediatek/mt76/mt76x02_usb_core.c |  2 +-
 .../wireless/mediatek/mt76/mt76x02_usb_mcu.c  |  2 +-
 .../net/wireless/mediatek/mt76/mt76x02_util.c |  2 +-
 .../net/wireless/mediatek/mt76/mt76x2_dma.c   |  2 +-
 .../net/wireless/mediatek/mt76/mt76x2_mcu.c   |  2 +-
 .../net/wireless/mediatek/mt76/mt76x2_tx.c    |  2 +-
 drivers/net/wireless/mediatek/mt76/mt76x2u.h  |  2 +-
 9 files changed, 67 insertions(+), 45 deletions(-)
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x02_dma.h

diff --git a/drivers/net/wireless/mediatek/mt76/dma.h b/drivers/net/wireless/mediatek/mt76/dma.h
index aa2faf19bf05..357cc356342d 100644
--- a/drivers/net/wireless/mediatek/mt76/dma.h
+++ b/drivers/net/wireless/mediatek/mt76/dma.h
@@ -25,34 +25,6 @@
 #define MT_DMA_CTL_LAST_SEC0		BIT(30)
 #define MT_DMA_CTL_DMA_DONE		BIT(31)
 
-#define MT_TXD_INFO_LEN			GENMASK(15, 0)
-#define MT_TXD_INFO_NEXT_VLD		BIT(16)
-#define MT_TXD_INFO_TX_BURST		BIT(17)
-#define MT_TXD_INFO_80211		BIT(19)
-#define MT_TXD_INFO_TSO			BIT(20)
-#define MT_TXD_INFO_CSO			BIT(21)
-#define MT_TXD_INFO_WIV			BIT(24)
-#define MT_TXD_INFO_QSEL		GENMASK(26, 25)
-#define MT_TXD_INFO_DPORT		GENMASK(29, 27)
-#define MT_TXD_INFO_TYPE		GENMASK(31, 30)
-
-#define MT_RX_FCE_INFO_LEN		GENMASK(13, 0)
-#define MT_RX_FCE_INFO_SELF_GEN		BIT(15)
-#define MT_RX_FCE_INFO_CMD_SEQ		GENMASK(19, 16)
-#define MT_RX_FCE_INFO_EVT_TYPE		GENMASK(23, 20)
-#define MT_RX_FCE_INFO_PCIE_INTR	BIT(24)
-#define MT_RX_FCE_INFO_QSEL		GENMASK(26, 25)
-#define MT_RX_FCE_INFO_D_PORT		GENMASK(29, 27)
-#define MT_RX_FCE_INFO_TYPE		GENMASK(31, 30)
-
-/* MCU request message header  */
-#define MT_MCU_MSG_LEN			GENMASK(15, 0)
-#define MT_MCU_MSG_CMD_SEQ		GENMASK(19, 16)
-#define MT_MCU_MSG_CMD_TYPE		GENMASK(26, 20)
-#define MT_MCU_MSG_PORT			GENMASK(29, 27)
-#define MT_MCU_MSG_TYPE			GENMASK(31, 30)
-#define MT_MCU_MSG_TYPE_CMD		BIT(30)
-
 #define MT_DMA_HDR_LEN			4
 #define MT_RX_INFO_LEN			4
 #define MT_FCE_INFO_LEN			4
@@ -65,16 +37,6 @@ struct mt76_desc {
 	__le32 info;
 } __packed __aligned(4);
 
-enum dma_msg_port {
-	WLAN_PORT,
-	CPU_RX_PORT,
-	CPU_TX_PORT,
-	HOST_PORT,
-	VIRTUAL_CPU_RX_PORT,
-	VIRTUAL_CPU_TX_PORT,
-	DISCARD,
-};
-
 enum mt76_qsel {
 	MT_QSEL_MGMT,
 	MT_QSEL_HCCA,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_dma.h b/drivers/net/wireless/mediatek/mt76/mt76x02_dma.h
new file mode 100644
index 000000000000..32a323ebc6a7
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_dma.h
@@ -0,0 +1,60 @@
+/*
+ * Copyright (C) 2018 Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#ifndef __MT76x02_DMA_H
+#define __MT76x02_DMA_H
+
+#include "dma.h"
+
+#define MT_TXD_INFO_LEN			GENMASK(15, 0)
+#define MT_TXD_INFO_NEXT_VLD		BIT(16)
+#define MT_TXD_INFO_TX_BURST		BIT(17)
+#define MT_TXD_INFO_80211		BIT(19)
+#define MT_TXD_INFO_TSO			BIT(20)
+#define MT_TXD_INFO_CSO			BIT(21)
+#define MT_TXD_INFO_WIV			BIT(24)
+#define MT_TXD_INFO_QSEL		GENMASK(26, 25)
+#define MT_TXD_INFO_DPORT		GENMASK(29, 27)
+#define MT_TXD_INFO_TYPE		GENMASK(31, 30)
+
+#define MT_RX_FCE_INFO_LEN		GENMASK(13, 0)
+#define MT_RX_FCE_INFO_SELF_GEN		BIT(15)
+#define MT_RX_FCE_INFO_CMD_SEQ		GENMASK(19, 16)
+#define MT_RX_FCE_INFO_EVT_TYPE		GENMASK(23, 20)
+#define MT_RX_FCE_INFO_PCIE_INTR	BIT(24)
+#define MT_RX_FCE_INFO_QSEL		GENMASK(26, 25)
+#define MT_RX_FCE_INFO_D_PORT		GENMASK(29, 27)
+#define MT_RX_FCE_INFO_TYPE		GENMASK(31, 30)
+
+/* MCU request message header  */
+#define MT_MCU_MSG_LEN			GENMASK(15, 0)
+#define MT_MCU_MSG_CMD_SEQ		GENMASK(19, 16)
+#define MT_MCU_MSG_CMD_TYPE		GENMASK(26, 20)
+#define MT_MCU_MSG_PORT			GENMASK(29, 27)
+#define MT_MCU_MSG_TYPE			GENMASK(31, 30)
+#define MT_MCU_MSG_TYPE_CMD		BIT(30)
+
+enum dma_msg_port {
+	WLAN_PORT,
+	CPU_RX_PORT,
+	CPU_TX_PORT,
+	HOST_PORT,
+	VIRTUAL_CPU_RX_PORT,
+	VIRTUAL_CPU_TX_PORT,
+	DISCARD,
+};
+
+#endif /* __MT76x02_DMA_H */
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c b/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c
index 9ca9e3d414d3..235b1bc5a367 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c
@@ -15,7 +15,7 @@
  */
 
 #include "mt76.h"
-#include "dma.h"
+#include "mt76x02_dma.h"
 
 int mt76x02u_skb_dma_info(struct sk_buff *skb, int port, u32 flags)
 {
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_usb_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76x02_usb_mcu.c
index cc63efa16634..b39a4d7d71cc 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_usb_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_usb_mcu.c
@@ -17,7 +17,7 @@
 #include <linux/firmware.h>
 
 #include "mt76.h"
-#include "dma.h"
+#include "mt76x02_dma.h"
 #include "mt76x02_mcu.h"
 #include "mt76x02_usb.h"
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
index 33d5cd00e48d..a14d7dba628b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
@@ -16,7 +16,7 @@
  */
 
 #include "mt76.h"
-#include "dma.h"
+#include "mt76x02_dma.h"
 #include "mt76x02_regs.h"
 #include "mt76x02_mac.h"
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_dma.c b/drivers/net/wireless/mediatek/mt76/mt76x2_dma.c
index 44ca660775fd..d3f787644c87 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_dma.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_dma.c
@@ -15,7 +15,7 @@
  */
 
 #include "mt76x2.h"
-#include "dma.h"
+#include "mt76x02_dma.h"
 
 int
 mt76x2_tx_queue_mcu(struct mt76x2_dev *dev, enum mt76_txq_id qid,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76x2_mcu.c
index c90803334ef0..9a174db5a23a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_mcu.c
@@ -21,7 +21,7 @@
 #include "mt76x2.h"
 #include "mt76x2_mcu.h"
 #include "mt76x2_eeprom.h"
-#include "dma.h"
+#include "mt76x02_dma.h"
 
 static struct sk_buff *mt76x2_mcu_msg_alloc(const void *data, int len)
 {
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_tx.c b/drivers/net/wireless/mediatek/mt76/mt76x2_tx.c
index 41d660991839..fcdf1879162e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_tx.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_tx.c
@@ -16,7 +16,7 @@
 
 #include "mt76x2.h"
 #include "mt76x02_util.h"
-#include "dma.h"
+#include "mt76x02_dma.h"
 
 struct beacon_bc_data {
 	struct mt76x2_dev *dev;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2u.h b/drivers/net/wireless/mediatek/mt76/mt76x2u.h
index 5a11217c03ed..83abbafc0c1a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2u.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2u.h
@@ -21,7 +21,7 @@
 
 #include "mt76x2.h"
 #include "mt76x2_mcu.h"
-#include "dma.h"
+#include "mt76x02_dma.h"
 
 #define MT7612U_EEPROM_SIZE		512
 
-- 
2.18.0
