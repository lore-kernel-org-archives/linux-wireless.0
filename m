Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:48763 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752088Ab3JQHmp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Oct 2013 03:42:45 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 05/21] rt2x00: rt2800pci: move RX control handler functions to the rt2800mmio module
Date: Thu, 17 Oct 2013 09:42:19 +0200
Message-Id: <1381995755-16471-6-git-send-email-juhosg@openwrt.org> (sfid-20131017_100806_928629_B201C0F4)
In-Reply-To: <1381995755-16471-1-git-send-email-juhosg@openwrt.org>
References: <1381995755-16471-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move the functions into a separate module, in order
to make those usable from other modules. Also move
the RX descriptor related defines from rt2800pci.h
into rt2800mmio.h

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/rt2x00/Kconfig      |    1 +
 drivers/net/wireless/rt2x00/rt2800mmio.c |   57 +++++++++++++++++++++++++++++-
 drivers/net/wireless/rt2x00/rt2800mmio.h |   51 ++++++++++++++++++++++++++
 drivers/net/wireless/rt2x00/rt2800pci.c  |   55 ----------------------------
 drivers/net/wireless/rt2x00/rt2800pci.h  |   51 --------------------------
 5 files changed, 108 insertions(+), 107 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/Kconfig b/drivers/net/wireless/rt2x00/Kconfig
index 535ad3a..e863249 100644
--- a/drivers/net/wireless/rt2x00/Kconfig
+++ b/drivers/net/wireless/rt2x00/Kconfig
@@ -206,6 +206,7 @@ config RT2800_LIB
 config RT2800_LIB_MMIO
 	tristate
 	select RT2X00_LIB_MMIO
+	select RT2800_LIB
 
 config RT2X00_LIB_MMIO
 	tristate
diff --git a/drivers/net/wireless/rt2x00/rt2800mmio.c b/drivers/net/wireless/rt2x00/rt2800mmio.c
index d2ebb68..32b8e50 100644
--- a/drivers/net/wireless/rt2x00/rt2800mmio.c
+++ b/drivers/net/wireless/rt2x00/rt2800mmio.c
@@ -34,6 +34,7 @@
 
 #include "rt2x00.h"
 #include "rt2x00mmio.h"
+#include "rt2800lib.h"
 #include "rt2800mmio.h"
 
 /*
@@ -99,7 +100,61 @@ void rt2800mmio_write_tx_desc(struct queue_entry *entry,
 }
 EXPORT_SYMBOL_GPL(rt2800mmio_write_tx_desc);
 
-#include "rt2x00.h"
+/*
+ * RX control handlers
+ */
+void rt2800mmio_fill_rxdone(struct queue_entry *entry,
+			    struct rxdone_entry_desc *rxdesc)
+{
+	struct queue_entry_priv_mmio *entry_priv = entry->priv_data;
+	__le32 *rxd = entry_priv->desc;
+	u32 word;
+
+	rt2x00_desc_read(rxd, 3, &word);
+
+	if (rt2x00_get_field32(word, RXD_W3_CRC_ERROR))
+		rxdesc->flags |= RX_FLAG_FAILED_FCS_CRC;
+
+	/*
+	 * Unfortunately we don't know the cipher type used during
+	 * decryption. This prevents us from correct providing
+	 * correct statistics through debugfs.
+	 */
+	rxdesc->cipher_status = rt2x00_get_field32(word, RXD_W3_CIPHER_ERROR);
+
+	if (rt2x00_get_field32(word, RXD_W3_DECRYPTED)) {
+		/*
+		 * Hardware has stripped IV/EIV data from 802.11 frame during
+		 * decryption. Unfortunately the descriptor doesn't contain
+		 * any fields with the EIV/IV data either, so they can't
+		 * be restored by rt2x00lib.
+		 */
+		rxdesc->flags |= RX_FLAG_IV_STRIPPED;
+
+		/*
+		 * The hardware has already checked the Michael Mic and has
+		 * stripped it from the frame. Signal this to mac80211.
+		 */
+		rxdesc->flags |= RX_FLAG_MMIC_STRIPPED;
+
+		if (rxdesc->cipher_status == RX_CRYPTO_SUCCESS)
+			rxdesc->flags |= RX_FLAG_DECRYPTED;
+		else if (rxdesc->cipher_status == RX_CRYPTO_FAIL_MIC)
+			rxdesc->flags |= RX_FLAG_MMIC_ERROR;
+	}
+
+	if (rt2x00_get_field32(word, RXD_W3_MY_BSS))
+		rxdesc->dev_flags |= RXDONE_MY_BSS;
+
+	if (rt2x00_get_field32(word, RXD_W3_L2PAD))
+		rxdesc->dev_flags |= RXDONE_L2PAD;
+
+	/*
+	 * Process the RXWI structure that is at the start of the buffer.
+	 */
+	rt2800_process_rxwi(entry, rxdesc);
+}
+EXPORT_SYMBOL_GPL(rt2800mmio_fill_rxdone);
 
 MODULE_AUTHOR(DRV_PROJECT);
 MODULE_VERSION(DRV_VERSION);
diff --git a/drivers/net/wireless/rt2x00/rt2800mmio.h b/drivers/net/wireless/rt2x00/rt2800mmio.h
index 0266640..71e3d22 100644
--- a/drivers/net/wireless/rt2x00/rt2800mmio.h
+++ b/drivers/net/wireless/rt2x00/rt2800mmio.h
@@ -35,6 +35,7 @@
  * DMA descriptor defines.
  */
 #define TXD_DESC_SIZE			(4 * sizeof(__le32))
+#define RXD_DESC_SIZE			(4 * sizeof(__le32))
 
 /*
  * TX descriptor format for TX, PRIO and Beacon Ring.
@@ -72,10 +73,60 @@
 #define TXD_W3_UCO			FIELD32(0x40000000)
 #define TXD_W3_ICO			FIELD32(0x80000000)
 
+/*
+ * RX descriptor format for RX Ring.
+ */
+
+/*
+ * Word0
+ */
+#define RXD_W0_SDP0			FIELD32(0xffffffff)
+
+/*
+ * Word1
+ */
+#define RXD_W1_SDL1			FIELD32(0x00003fff)
+#define RXD_W1_SDL0			FIELD32(0x3fff0000)
+#define RXD_W1_LS0			FIELD32(0x40000000)
+#define RXD_W1_DMA_DONE			FIELD32(0x80000000)
+
+/*
+ * Word2
+ */
+#define RXD_W2_SDP1			FIELD32(0xffffffff)
+
+/*
+ * Word3
+ * AMSDU: RX with 802.3 header, not 802.11 header.
+ * DECRYPTED: This frame is being decrypted.
+ */
+#define RXD_W3_BA			FIELD32(0x00000001)
+#define RXD_W3_DATA			FIELD32(0x00000002)
+#define RXD_W3_NULLDATA			FIELD32(0x00000004)
+#define RXD_W3_FRAG			FIELD32(0x00000008)
+#define RXD_W3_UNICAST_TO_ME		FIELD32(0x00000010)
+#define RXD_W3_MULTICAST		FIELD32(0x00000020)
+#define RXD_W3_BROADCAST		FIELD32(0x00000040)
+#define RXD_W3_MY_BSS			FIELD32(0x00000080)
+#define RXD_W3_CRC_ERROR		FIELD32(0x00000100)
+#define RXD_W3_CIPHER_ERROR		FIELD32(0x00000600)
+#define RXD_W3_AMSDU			FIELD32(0x00000800)
+#define RXD_W3_HTC			FIELD32(0x00001000)
+#define RXD_W3_RSSI			FIELD32(0x00002000)
+#define RXD_W3_L2PAD			FIELD32(0x00004000)
+#define RXD_W3_AMPDU			FIELD32(0x00008000)
+#define RXD_W3_DECRYPTED		FIELD32(0x00010000)
+#define RXD_W3_PLCP_SIGNAL		FIELD32(0x00020000)
+#define RXD_W3_PLCP_RSSI		FIELD32(0x00040000)
 
 /* TX descriptor initialization */
 __le32 *rt2800mmio_get_txwi(struct queue_entry *entry);
 void rt2800mmio_write_tx_desc(struct queue_entry *entry,
 			      struct txentry_desc *txdesc);
 
+/* RX control handlers */
+void rt2800mmio_fill_rxdone(struct queue_entry *entry,
+			    struct rxdone_entry_desc *rxdesc);
+
+
 #endif /* RT2800MMIO_H */
diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index 37ac888..2cbaaac 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -628,61 +628,6 @@ static int rt2800pci_set_device_state(struct rt2x00_dev *rt2x00dev,
 }
 
 /*
- * RX control handlers
- */
-static void rt2800mmio_fill_rxdone(struct queue_entry *entry,
-				   struct rxdone_entry_desc *rxdesc)
-{
-	struct queue_entry_priv_mmio *entry_priv = entry->priv_data;
-	__le32 *rxd = entry_priv->desc;
-	u32 word;
-
-	rt2x00_desc_read(rxd, 3, &word);
-
-	if (rt2x00_get_field32(word, RXD_W3_CRC_ERROR))
-		rxdesc->flags |= RX_FLAG_FAILED_FCS_CRC;
-
-	/*
-	 * Unfortunately we don't know the cipher type used during
-	 * decryption. This prevents us from correct providing
-	 * correct statistics through debugfs.
-	 */
-	rxdesc->cipher_status = rt2x00_get_field32(word, RXD_W3_CIPHER_ERROR);
-
-	if (rt2x00_get_field32(word, RXD_W3_DECRYPTED)) {
-		/*
-		 * Hardware has stripped IV/EIV data from 802.11 frame during
-		 * decryption. Unfortunately the descriptor doesn't contain
-		 * any fields with the EIV/IV data either, so they can't
-		 * be restored by rt2x00lib.
-		 */
-		rxdesc->flags |= RX_FLAG_IV_STRIPPED;
-
-		/*
-		 * The hardware has already checked the Michael Mic and has
-		 * stripped it from the frame. Signal this to mac80211.
-		 */
-		rxdesc->flags |= RX_FLAG_MMIC_STRIPPED;
-
-		if (rxdesc->cipher_status == RX_CRYPTO_SUCCESS)
-			rxdesc->flags |= RX_FLAG_DECRYPTED;
-		else if (rxdesc->cipher_status == RX_CRYPTO_FAIL_MIC)
-			rxdesc->flags |= RX_FLAG_MMIC_ERROR;
-	}
-
-	if (rt2x00_get_field32(word, RXD_W3_MY_BSS))
-		rxdesc->dev_flags |= RXDONE_MY_BSS;
-
-	if (rt2x00_get_field32(word, RXD_W3_L2PAD))
-		rxdesc->dev_flags |= RXDONE_L2PAD;
-
-	/*
-	 * Process the RXWI structure that is at the start of the buffer.
-	 */
-	rt2800_process_rxwi(entry, rxdesc);
-}
-
-/*
  * Interrupt functions.
  */
 static void rt2800pci_wakeup(struct rt2x00_dev *rt2x00dev)
diff --git a/drivers/net/wireless/rt2x00/rt2800pci.h b/drivers/net/wireless/rt2x00/rt2800pci.h
index ecd154e..0e55159 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.h
+++ b/drivers/net/wireless/rt2x00/rt2800pci.h
@@ -50,55 +50,4 @@
 #define FIRMWARE_RT3290			"rt3290.bin"
 #define FIRMWARE_IMAGE_BASE		0x2000
 
-/*
- * DMA descriptor defines.
- */
-#define RXD_DESC_SIZE			(4 * sizeof(__le32))
-
-/*
- * RX descriptor format for RX Ring.
- */
-
-/*
- * Word0
- */
-#define RXD_W0_SDP0			FIELD32(0xffffffff)
-
-/*
- * Word1
- */
-#define RXD_W1_SDL1			FIELD32(0x00003fff)
-#define RXD_W1_SDL0			FIELD32(0x3fff0000)
-#define RXD_W1_LS0			FIELD32(0x40000000)
-#define RXD_W1_DMA_DONE			FIELD32(0x80000000)
-
-/*
- * Word2
- */
-#define RXD_W2_SDP1			FIELD32(0xffffffff)
-
-/*
- * Word3
- * AMSDU: RX with 802.3 header, not 802.11 header.
- * DECRYPTED: This frame is being decrypted.
- */
-#define RXD_W3_BA			FIELD32(0x00000001)
-#define RXD_W3_DATA			FIELD32(0x00000002)
-#define RXD_W3_NULLDATA			FIELD32(0x00000004)
-#define RXD_W3_FRAG			FIELD32(0x00000008)
-#define RXD_W3_UNICAST_TO_ME		FIELD32(0x00000010)
-#define RXD_W3_MULTICAST		FIELD32(0x00000020)
-#define RXD_W3_BROADCAST		FIELD32(0x00000040)
-#define RXD_W3_MY_BSS			FIELD32(0x00000080)
-#define RXD_W3_CRC_ERROR		FIELD32(0x00000100)
-#define RXD_W3_CIPHER_ERROR		FIELD32(0x00000600)
-#define RXD_W3_AMSDU			FIELD32(0x00000800)
-#define RXD_W3_HTC			FIELD32(0x00001000)
-#define RXD_W3_RSSI			FIELD32(0x00002000)
-#define RXD_W3_L2PAD			FIELD32(0x00004000)
-#define RXD_W3_AMPDU			FIELD32(0x00008000)
-#define RXD_W3_DECRYPTED		FIELD32(0x00010000)
-#define RXD_W3_PLCP_SIGNAL		FIELD32(0x00020000)
-#define RXD_W3_PLCP_RSSI		FIELD32(0x00040000)
-
 #endif /* RT2800PCI_H */
-- 
1.7.10
