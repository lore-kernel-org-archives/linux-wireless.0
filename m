Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:51545 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752334AbeGAONE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 1 Jul 2018 10:13:04 -0400
Received: by mail-wm0-f67.google.com with SMTP id w137-v6so6474868wmw.1
        for <linux-wireless@vger.kernel.org>; Sun, 01 Jul 2018 07:13:04 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org, sgruszka@redhat.com
Subject: [PATCH 01/19] mt76: move MT_TXD_INFO, MT_MCU_MSG and MT_RX_FCE_INFO defs in dma.h
Date: Sun,  1 Jul 2018 16:12:13 +0200
Message-Id: <20180701141231.25323-2-lorenzo.bianconi@redhat.com> (sfid-20180701_161314_871906_89A72E72)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since MT_TXD_INFO, MT_MCU_MSG and MT_RX_FCE_INFO definitions are in
common between mt76x2u, mt76x2 and mt76x0u move them in dma.h in order
to reuse usb code supporting mt76x2u and mt76x0u based devices

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/dma.h      | 38 +++++++++++++++++++
 .../net/wireless/mediatek/mt76/mt76x2_dma.h   | 38 -------------------
 2 files changed, 38 insertions(+), 38 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/dma.h b/drivers/net/wireless/mediatek/mt76/dma.h
index 1dad39697929..14cfb2dbca25 100644
--- a/drivers/net/wireless/mediatek/mt76/dma.h
+++ b/drivers/net/wireless/mediatek/mt76/dma.h
@@ -25,6 +25,34 @@
 #define MT_DMA_CTL_LAST_SEC0		BIT(30)
 #define MT_DMA_CTL_DMA_DONE		BIT(31)
 
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
 struct mt76_desc {
 	__le32 buf0;
 	__le32 ctrl;
@@ -32,6 +60,16 @@ struct mt76_desc {
 	__le32 info;
 } __packed __aligned(4);
 
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
 int mt76_dma_attach(struct mt76_dev *dev);
 void mt76_dma_cleanup(struct mt76_dev *dev);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_dma.h b/drivers/net/wireless/mediatek/mt76/mt76x2_dma.h
index e9d426bbf91a..da294558c268 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_dma.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_dma.h
@@ -19,34 +19,6 @@
 
 #include "dma.h"
 
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
 enum mt76x2_qsel {
 	MT_QSEL_MGMT,
 	MT_QSEL_HCCA,
@@ -54,14 +26,4 @@ enum mt76x2_qsel {
 	MT_QSEL_EDCA_2,
 };
 
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
 #endif
-- 
2.18.0
