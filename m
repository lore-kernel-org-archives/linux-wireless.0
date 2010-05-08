Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:1924 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753822Ab0EHVkc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 May 2010 17:40:32 -0400
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Ivo van Doorn <IvDoorn@gmail.com>,
	<linux-wireless@vger.kernel.org>, <users@rt2x00.serialmonkey.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: [PATCH 3/9] rt2x00: Don't check whether hardware crypto is enabled when reading RXD.
Date: Sat,  8 May 2010 23:40:20 +0200
Message-Id: <1273354826-4335-4-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1273354826-4335-1-git-send-email-gwingerde@gmail.com>
References: <1273354826-4335-1-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We should simply follow what the hardware told us it has done.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2500usb.c |    8 +++-----
 drivers/net/wireless/rt2x00/rt2800pci.c |   17 +++++++----------
 drivers/net/wireless/rt2x00/rt2800usb.c |    8 ++------
 drivers/net/wireless/rt2x00/rt61pci.c   |    8 ++------
 drivers/net/wireless/rt2x00/rt73usb.c   |    8 ++------
 5 files changed, 16 insertions(+), 33 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index c6e6e7b..f90b308 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -1213,11 +1213,9 @@ static void rt2500usb_fill_rxdone(struct queue_entry *entry,
 	if (rt2x00_get_field32(word0, RXD_W0_PHYSICAL_ERROR))
 		rxdesc->flags |= RX_FLAG_FAILED_PLCP_CRC;
 
-	if (test_bit(CONFIG_SUPPORT_HW_CRYPTO, &rt2x00dev->flags)) {
-		rxdesc->cipher = rt2x00_get_field32(word0, RXD_W0_CIPHER);
-		if (rt2x00_get_field32(word0, RXD_W0_CIPHER_ERROR))
-			rxdesc->cipher_status = RX_CRYPTO_FAIL_KEY;
-	}
+	rxdesc->cipher = rt2x00_get_field32(word0, RXD_W0_CIPHER);
+	if (rt2x00_get_field32(word0, RXD_W0_CIPHER_ERROR))
+		rxdesc->cipher_status = RX_CRYPTO_FAIL_KEY;
 
 	if (rxdesc->cipher != CIPHER_NONE) {
 		_rt2x00_desc_read(rxd, 2, &rxdesc->iv[0]);
diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index df2c3fb..b9ec081 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -840,16 +840,13 @@ static void rt2800pci_fill_rxdone(struct queue_entry *entry,
 	if (rt2x00_get_field32(rxd3, RXD_W3_CRC_ERROR))
 		rxdesc->flags |= RX_FLAG_FAILED_FCS_CRC;
 
-	if (test_bit(CONFIG_SUPPORT_HW_CRYPTO, &rt2x00dev->flags)) {
-		/*
-		 * Unfortunately we don't know the cipher type used during
-		 * decryption. This prevents us from correct providing
-		 * correct statistics through debugfs.
-		 */
-		rxdesc->cipher = rt2x00_get_field32(rxwi0, RXWI_W0_UDF);
-		rxdesc->cipher_status =
-		    rt2x00_get_field32(rxd3, RXD_W3_CIPHER_ERROR);
-	}
+	/*
+	 * Unfortunately we don't know the cipher type used during
+	 * decryption. This prevents us from correct providing
+	 * correct statistics through debugfs.
+	 */
+	rxdesc->cipher = rt2x00_get_field32(rxwi0, RXWI_W0_UDF);
+	rxdesc->cipher_status = rt2x00_get_field32(rxd3, RXD_W3_CIPHER_ERROR);
 
 	if (rt2x00_get_field32(rxd3, RXD_W3_DECRYPTED)) {
 		/*
diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 94b6812..df7ad98 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -549,7 +549,6 @@ static void rt2800usb_kick_tx_queue(struct rt2x00_dev *rt2x00dev,
 static void rt2800usb_fill_rxdone(struct queue_entry *entry,
 				  struct rxdone_entry_desc *rxdesc)
 {
-	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
 	struct skb_frame_desc *skbdesc = get_skb_frame_desc(entry->skb);
 	__le32 *rxi = (__le32 *)entry->skb->data;
 	__le32 *rxwi;
@@ -595,11 +594,8 @@ static void rt2800usb_fill_rxdone(struct queue_entry *entry,
 	if (rt2x00_get_field32(rxd0, RXD_W0_CRC_ERROR))
 		rxdesc->flags |= RX_FLAG_FAILED_FCS_CRC;
 
-	if (test_bit(CONFIG_SUPPORT_HW_CRYPTO, &rt2x00dev->flags)) {
-		rxdesc->cipher = rt2x00_get_field32(rxwi0, RXWI_W0_UDF);
-		rxdesc->cipher_status =
-		    rt2x00_get_field32(rxd0, RXD_W0_CIPHER_ERROR);
-	}
+	rxdesc->cipher = rt2x00_get_field32(rxwi0, RXWI_W0_UDF);
+	rxdesc->cipher_status = rt2x00_get_field32(rxd0, RXD_W0_CIPHER_ERROR);
 
 	if (rt2x00_get_field32(rxd0, RXD_W0_DECRYPTED)) {
 		/*
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 8099eca..1b0c70d 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -1968,12 +1968,8 @@ static void rt61pci_fill_rxdone(struct queue_entry *entry,
 	if (rt2x00_get_field32(word0, RXD_W0_CRC_ERROR))
 		rxdesc->flags |= RX_FLAG_FAILED_FCS_CRC;
 
-	if (test_bit(CONFIG_SUPPORT_HW_CRYPTO, &rt2x00dev->flags)) {
-		rxdesc->cipher =
-		    rt2x00_get_field32(word0, RXD_W0_CIPHER_ALG);
-		rxdesc->cipher_status =
-		    rt2x00_get_field32(word0, RXD_W0_CIPHER_ERROR);
-	}
+	rxdesc->cipher = rt2x00_get_field32(word0, RXD_W0_CIPHER_ALG);
+	rxdesc->cipher_status = rt2x00_get_field32(word0, RXD_W0_CIPHER_ERROR);
 
 	if (rxdesc->cipher != CIPHER_NONE) {
 		_rt2x00_desc_read(entry_priv->desc, 2, &rxdesc->iv[0]);
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 1399c18..6acba62 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -1644,12 +1644,8 @@ static void rt73usb_fill_rxdone(struct queue_entry *entry,
 	if (rt2x00_get_field32(word0, RXD_W0_CRC_ERROR))
 		rxdesc->flags |= RX_FLAG_FAILED_FCS_CRC;
 
-	if (test_bit(CONFIG_SUPPORT_HW_CRYPTO, &rt2x00dev->flags)) {
-		rxdesc->cipher =
-		    rt2x00_get_field32(word0, RXD_W0_CIPHER_ALG);
-		rxdesc->cipher_status =
-		    rt2x00_get_field32(word0, RXD_W0_CIPHER_ERROR);
-	}
+	rxdesc->cipher = rt2x00_get_field32(word0, RXD_W0_CIPHER_ALG);
+	rxdesc->cipher_status = rt2x00_get_field32(word0, RXD_W0_CIPHER_ERROR);
 
 	if (rxdesc->cipher != CIPHER_NONE) {
 		_rt2x00_desc_read(rxd, 2, &rxdesc->iv[0]);
-- 
1.7.1

