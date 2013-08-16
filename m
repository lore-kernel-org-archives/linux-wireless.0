Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:39995 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751798Ab3HPIXv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Aug 2013 04:23:51 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 1/2] rt2x00: rt2800lib: introduce rt2800_get_txwi_rxwi_size helper
Date: Fri, 16 Aug 2013 10:23:29 +0200
Message-Id: <1376641410-20798-1-git-send-email-juhosg@openwrt.org> (sfid-20130816_102358_220331_CC8D9FF4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The rt2800pci driver uses the same [RT]XWI size
for all chipsets, however some chips requires
different values.

The size of the [RT]XWI structures is a constant
value for a given chipset and it does not depend
on the underlying interface. Add a helper function
which returns the correct values for the actual
chipset and use the new helper both in the rt2800usb
and in the rt2800pci drivers. This ensures that both
drivers are using the correct values.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |   23 +++++++++++++++++++++++
 drivers/net/wireless/rt2x00/rt2800lib.h |    4 ++++
 drivers/net/wireless/rt2x00/rt2800pci.c |   11 ++++++++---
 drivers/net/wireless/rt2x00/rt2800usb.c |   11 +----------
 4 files changed, 36 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index dedc3d4..313da6a 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -521,6 +521,29 @@ void rt2800_disable_wpdma(struct rt2x00_dev *rt2x00dev)
 }
 EXPORT_SYMBOL_GPL(rt2800_disable_wpdma);
 
+void rt2800_get_txwi_rxwi_size(struct rt2x00_dev *rt2x00dev,
+			       unsigned short *txwi_size,
+			       unsigned short *rxwi_size)
+{
+	switch (rt2x00dev->chip.rt) {
+	case RT3593:
+		*txwi_size = TXWI_DESC_SIZE_4WORDS;
+		*rxwi_size = RXWI_DESC_SIZE_5WORDS;
+		break;
+
+	case RT5592:
+		*txwi_size = TXWI_DESC_SIZE_5WORDS;
+		*rxwi_size = RXWI_DESC_SIZE_6WORDS;
+		break;
+
+	default:
+		*txwi_size = TXWI_DESC_SIZE_4WORDS;
+		*rxwi_size = RXWI_DESC_SIZE_4WORDS;
+		break;
+	}
+}
+EXPORT_SYMBOL_GPL(rt2800_get_txwi_rxwi_size);
+
 static bool rt2800_check_firmware_crc(const u8 *data, const size_t len)
 {
 	u16 fw_crc;
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.h b/drivers/net/wireless/rt2x00/rt2800lib.h
index 6ec7394..a94ba44 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.h
+++ b/drivers/net/wireless/rt2x00/rt2800lib.h
@@ -226,4 +226,8 @@ int rt2800_get_survey(struct ieee80211_hw *hw, int idx,
 		      struct survey_info *survey);
 void rt2800_disable_wpdma(struct rt2x00_dev *rt2x00dev);
 
+void rt2800_get_txwi_rxwi_size(struct rt2x00_dev *rt2x00dev,
+			       unsigned short *txwi_size,
+			       unsigned short *rxwi_size);
+
 #endif /* RT2800LIB_H */
diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index 1f6a4e3..e470fdb 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -1223,12 +1223,17 @@ static const struct rt2x00lib_ops rt2800pci_rt2x00_ops = {
 
 static void rt2800pci_queue_init(struct data_queue *queue)
 {
+	struct rt2x00_dev *rt2x00dev = queue->rt2x00dev;
+	unsigned short txwi_size, rxwi_size;
+
+	rt2800_get_txwi_rxwi_size(rt2x00dev, &txwi_size, &rxwi_size);
+
 	switch (queue->qid) {
 	case QID_RX:
 		queue->limit = 128;
 		queue->data_size = AGGREGATION_SIZE;
 		queue->desc_size = RXD_DESC_SIZE;
-		queue->winfo_size = RXWI_DESC_SIZE_4WORDS;
+		queue->winfo_size = rxwi_size;
 		queue->priv_size = sizeof(struct queue_entry_priv_mmio);
 		break;
 
@@ -1239,7 +1244,7 @@ static void rt2800pci_queue_init(struct data_queue *queue)
 		queue->limit = 64;
 		queue->data_size = AGGREGATION_SIZE;
 		queue->desc_size = TXD_DESC_SIZE;
-		queue->winfo_size = TXWI_DESC_SIZE_4WORDS;
+		queue->winfo_size = txwi_size;
 		queue->priv_size = sizeof(struct queue_entry_priv_mmio);
 		break;
 
@@ -1247,7 +1252,7 @@ static void rt2800pci_queue_init(struct data_queue *queue)
 		queue->limit = 8;
 		queue->data_size = 0; /* No DMA required for beacons */
 		queue->desc_size = TXD_DESC_SIZE;
-		queue->winfo_size = TXWI_DESC_SIZE_4WORDS;
+		queue->winfo_size = txwi_size;
 		queue->priv_size = sizeof(struct queue_entry_priv_mmio);
 		break;
 
diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index fc9efdf..338034e 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -854,16 +854,7 @@ static void rt2800usb_queue_init(struct data_queue *queue)
 	struct rt2x00_dev *rt2x00dev = queue->rt2x00dev;
 	unsigned short txwi_size, rxwi_size;
 
-	if (rt2x00_rt(rt2x00dev, RT3593)) {
-		txwi_size = TXWI_DESC_SIZE_4WORDS;
-		rxwi_size = RXWI_DESC_SIZE_5WORDS;
-	} else if (rt2x00_rt(rt2x00dev, RT5592)) {
-		txwi_size = TXWI_DESC_SIZE_5WORDS;
-		rxwi_size = RXWI_DESC_SIZE_6WORDS;
-	} else {
-		txwi_size = TXWI_DESC_SIZE_4WORDS;
-		rxwi_size = RXWI_DESC_SIZE_4WORDS;
-	}
+	rt2800_get_txwi_rxwi_size(rt2x00dev, &txwi_size, &rxwi_size);
 
 	switch (queue->qid) {
 	case QID_RX:
-- 
1.7.10
