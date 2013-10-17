Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:48752 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751831Ab3JQHmn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Oct 2013 03:42:43 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 03/21] rt2x00: rt2800pci: move TX descriptor functions to the rt2800mmio module
Date: Thu, 17 Oct 2013 09:42:17 +0200
Message-Id: <1381995755-16471-4-git-send-email-juhosg@openwrt.org> (sfid-20131017_100808_164982_79AA7D27)
In-Reply-To: <1381995755-16471-1-git-send-email-juhosg@openwrt.org>
References: <1381995755-16471-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move the functions into a separate module, in order
to make those usable from other modules. Also move
the TX descriptor related defines from rt2800pci.h
into rt2800mmio.h.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/rt2x00/Kconfig      |    1 +
 drivers/net/wireless/rt2x00/rt2800mmio.c |   68 ++++++++++++++++++++++++++++++
 drivers/net/wireless/rt2x00/rt2800mmio.h |   47 +++++++++++++++++++++
 drivers/net/wireless/rt2x00/rt2800pci.c  |   62 +--------------------------
 drivers/net/wireless/rt2x00/rt2800pci.h  |   37 ----------------
 5 files changed, 117 insertions(+), 98 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/Kconfig b/drivers/net/wireless/rt2x00/Kconfig
index 2232b11..535ad3a 100644
--- a/drivers/net/wireless/rt2x00/Kconfig
+++ b/drivers/net/wireless/rt2x00/Kconfig
@@ -205,6 +205,7 @@ config RT2800_LIB
 
 config RT2800_LIB_MMIO
 	tristate
+	select RT2X00_LIB_MMIO
 
 config RT2X00_LIB_MMIO
 	tristate
diff --git a/drivers/net/wireless/rt2x00/rt2800mmio.c b/drivers/net/wireless/rt2x00/rt2800mmio.c
index a2b9848..d2ebb68 100644
--- a/drivers/net/wireless/rt2x00/rt2800mmio.c
+++ b/drivers/net/wireless/rt2x00/rt2800mmio.c
@@ -30,6 +30,74 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/export.h>
+
+#include "rt2x00.h"
+#include "rt2x00mmio.h"
+#include "rt2800mmio.h"
+
+/*
+ * TX descriptor initialization
+ */
+__le32 *rt2800mmio_get_txwi(struct queue_entry *entry)
+{
+	return (__le32 *) entry->skb->data;
+}
+EXPORT_SYMBOL_GPL(rt2800mmio_get_txwi);
+
+void rt2800mmio_write_tx_desc(struct queue_entry *entry,
+			      struct txentry_desc *txdesc)
+{
+	struct skb_frame_desc *skbdesc = get_skb_frame_desc(entry->skb);
+	struct queue_entry_priv_mmio *entry_priv = entry->priv_data;
+	__le32 *txd = entry_priv->desc;
+	u32 word;
+	const unsigned int txwi_size = entry->queue->winfo_size;
+
+	/*
+	 * The buffers pointed by SD_PTR0/SD_LEN0 and SD_PTR1/SD_LEN1
+	 * must contains a TXWI structure + 802.11 header + padding + 802.11
+	 * data. We choose to have SD_PTR0/SD_LEN0 only contains TXWI and
+	 * SD_PTR1/SD_LEN1 contains 802.11 header + padding + 802.11
+	 * data. It means that LAST_SEC0 is always 0.
+	 */
+
+	/*
+	 * Initialize TX descriptor
+	 */
+	word = 0;
+	rt2x00_set_field32(&word, TXD_W0_SD_PTR0, skbdesc->skb_dma);
+	rt2x00_desc_write(txd, 0, word);
+
+	word = 0;
+	rt2x00_set_field32(&word, TXD_W1_SD_LEN1, entry->skb->len);
+	rt2x00_set_field32(&word, TXD_W1_LAST_SEC1,
+			   !test_bit(ENTRY_TXD_MORE_FRAG, &txdesc->flags));
+	rt2x00_set_field32(&word, TXD_W1_BURST,
+			   test_bit(ENTRY_TXD_BURST, &txdesc->flags));
+	rt2x00_set_field32(&word, TXD_W1_SD_LEN0, txwi_size);
+	rt2x00_set_field32(&word, TXD_W1_LAST_SEC0, 0);
+	rt2x00_set_field32(&word, TXD_W1_DMA_DONE, 0);
+	rt2x00_desc_write(txd, 1, word);
+
+	word = 0;
+	rt2x00_set_field32(&word, TXD_W2_SD_PTR1,
+			   skbdesc->skb_dma + txwi_size);
+	rt2x00_desc_write(txd, 2, word);
+
+	word = 0;
+	rt2x00_set_field32(&word, TXD_W3_WIV,
+			   !test_bit(ENTRY_TXD_ENCRYPT_IV, &txdesc->flags));
+	rt2x00_set_field32(&word, TXD_W3_QSEL, 2);
+	rt2x00_desc_write(txd, 3, word);
+
+	/*
+	 * Register descriptor details in skb frame descriptor.
+	 */
+	skbdesc->desc = txd;
+	skbdesc->desc_len = TXD_DESC_SIZE;
+}
+EXPORT_SYMBOL_GPL(rt2800mmio_write_tx_desc);
 
 #include "rt2x00.h"
 
diff --git a/drivers/net/wireless/rt2x00/rt2800mmio.h b/drivers/net/wireless/rt2x00/rt2800mmio.h
index 32f9dcd..0266640 100644
--- a/drivers/net/wireless/rt2x00/rt2800mmio.h
+++ b/drivers/net/wireless/rt2x00/rt2800mmio.h
@@ -31,4 +31,51 @@
 #ifndef RT2800MMIO_H
 #define RT2800MMIO_H
 
+/*
+ * DMA descriptor defines.
+ */
+#define TXD_DESC_SIZE			(4 * sizeof(__le32))
+
+/*
+ * TX descriptor format for TX, PRIO and Beacon Ring.
+ */
+
+/*
+ * Word0
+ */
+#define TXD_W0_SD_PTR0			FIELD32(0xffffffff)
+
+/*
+ * Word1
+ */
+#define TXD_W1_SD_LEN1			FIELD32(0x00003fff)
+#define TXD_W1_LAST_SEC1		FIELD32(0x00004000)
+#define TXD_W1_BURST			FIELD32(0x00008000)
+#define TXD_W1_SD_LEN0			FIELD32(0x3fff0000)
+#define TXD_W1_LAST_SEC0		FIELD32(0x40000000)
+#define TXD_W1_DMA_DONE			FIELD32(0x80000000)
+
+/*
+ * Word2
+ */
+#define TXD_W2_SD_PTR1			FIELD32(0xffffffff)
+
+/*
+ * Word3
+ * WIV: Wireless Info Valid. 1: Driver filled WI, 0: DMA needs to copy WI
+ * QSEL: Select on-chip FIFO ID for 2nd-stage output scheduler.
+ *       0:MGMT, 1:HCCA 2:EDCA
+ */
+#define TXD_W3_WIV			FIELD32(0x01000000)
+#define TXD_W3_QSEL			FIELD32(0x06000000)
+#define TXD_W3_TCO			FIELD32(0x20000000)
+#define TXD_W3_UCO			FIELD32(0x40000000)
+#define TXD_W3_ICO			FIELD32(0x80000000)
+
+
+/* TX descriptor initialization */
+__le32 *rt2800mmio_get_txwi(struct queue_entry *entry);
+void rt2800mmio_write_tx_desc(struct queue_entry *entry,
+			      struct txentry_desc *txdesc);
+
 #endif /* RT2800MMIO_H */
diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index ddc6a42..b2e2b09 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -45,6 +45,7 @@
 #include "rt2x00pci.h"
 #include "rt2x00soc.h"
 #include "rt2800lib.h"
+#include "rt2800mmio.h"
 #include "rt2800.h"
 #include "rt2800pci.h"
 
@@ -627,67 +628,6 @@ static int rt2800pci_set_device_state(struct rt2x00_dev *rt2x00dev,
 }
 
 /*
- * TX descriptor initialization
- */
-static __le32 *rt2800mmio_get_txwi(struct queue_entry *entry)
-{
-	return (__le32 *) entry->skb->data;
-}
-
-static void rt2800mmio_write_tx_desc(struct queue_entry *entry,
-				     struct txentry_desc *txdesc)
-{
-	struct skb_frame_desc *skbdesc = get_skb_frame_desc(entry->skb);
-	struct queue_entry_priv_mmio *entry_priv = entry->priv_data;
-	__le32 *txd = entry_priv->desc;
-	u32 word;
-	const unsigned int txwi_size = entry->queue->winfo_size;
-
-	/*
-	 * The buffers pointed by SD_PTR0/SD_LEN0 and SD_PTR1/SD_LEN1
-	 * must contains a TXWI structure + 802.11 header + padding + 802.11
-	 * data. We choose to have SD_PTR0/SD_LEN0 only contains TXWI and
-	 * SD_PTR1/SD_LEN1 contains 802.11 header + padding + 802.11
-	 * data. It means that LAST_SEC0 is always 0.
-	 */
-
-	/*
-	 * Initialize TX descriptor
-	 */
-	word = 0;
-	rt2x00_set_field32(&word, TXD_W0_SD_PTR0, skbdesc->skb_dma);
-	rt2x00_desc_write(txd, 0, word);
-
-	word = 0;
-	rt2x00_set_field32(&word, TXD_W1_SD_LEN1, entry->skb->len);
-	rt2x00_set_field32(&word, TXD_W1_LAST_SEC1,
-			   !test_bit(ENTRY_TXD_MORE_FRAG, &txdesc->flags));
-	rt2x00_set_field32(&word, TXD_W1_BURST,
-			   test_bit(ENTRY_TXD_BURST, &txdesc->flags));
-	rt2x00_set_field32(&word, TXD_W1_SD_LEN0, txwi_size);
-	rt2x00_set_field32(&word, TXD_W1_LAST_SEC0, 0);
-	rt2x00_set_field32(&word, TXD_W1_DMA_DONE, 0);
-	rt2x00_desc_write(txd, 1, word);
-
-	word = 0;
-	rt2x00_set_field32(&word, TXD_W2_SD_PTR1,
-			   skbdesc->skb_dma + txwi_size);
-	rt2x00_desc_write(txd, 2, word);
-
-	word = 0;
-	rt2x00_set_field32(&word, TXD_W3_WIV,
-			   !test_bit(ENTRY_TXD_ENCRYPT_IV, &txdesc->flags));
-	rt2x00_set_field32(&word, TXD_W3_QSEL, 2);
-	rt2x00_desc_write(txd, 3, word);
-
-	/*
-	 * Register descriptor details in skb frame descriptor.
-	 */
-	skbdesc->desc = txd;
-	skbdesc->desc_len = TXD_DESC_SIZE;
-}
-
-/*
  * RX control handlers
  */
 static void rt2800pci_fill_rxdone(struct queue_entry *entry,
diff --git a/drivers/net/wireless/rt2x00/rt2800pci.h b/drivers/net/wireless/rt2x00/rt2800pci.h
index ab22a08..ecd154e 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.h
+++ b/drivers/net/wireless/rt2x00/rt2800pci.h
@@ -53,46 +53,9 @@
 /*
  * DMA descriptor defines.
  */
-#define TXD_DESC_SIZE			(4 * sizeof(__le32))
 #define RXD_DESC_SIZE			(4 * sizeof(__le32))
 
 /*
- * TX descriptor format for TX, PRIO and Beacon Ring.
- */
-
-/*
- * Word0
- */
-#define TXD_W0_SD_PTR0			FIELD32(0xffffffff)
-
-/*
- * Word1
- */
-#define TXD_W1_SD_LEN1			FIELD32(0x00003fff)
-#define TXD_W1_LAST_SEC1		FIELD32(0x00004000)
-#define TXD_W1_BURST			FIELD32(0x00008000)
-#define TXD_W1_SD_LEN0			FIELD32(0x3fff0000)
-#define TXD_W1_LAST_SEC0		FIELD32(0x40000000)
-#define TXD_W1_DMA_DONE			FIELD32(0x80000000)
-
-/*
- * Word2
- */
-#define TXD_W2_SD_PTR1			FIELD32(0xffffffff)
-
-/*
- * Word3
- * WIV: Wireless Info Valid. 1: Driver filled WI, 0: DMA needs to copy WI
- * QSEL: Select on-chip FIFO ID for 2nd-stage output scheduler.
- *       0:MGMT, 1:HCCA 2:EDCA
- */
-#define TXD_W3_WIV			FIELD32(0x01000000)
-#define TXD_W3_QSEL			FIELD32(0x06000000)
-#define TXD_W3_TCO			FIELD32(0x20000000)
-#define TXD_W3_UCO			FIELD32(0x40000000)
-#define TXD_W3_ICO			FIELD32(0x80000000)
-
-/*
  * RX descriptor format for RX Ring.
  */
 
-- 
1.7.10
