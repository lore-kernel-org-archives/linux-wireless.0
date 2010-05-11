Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:1723 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752882Ab0EKVvx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 May 2010 17:51:53 -0400
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Ivo van Doorn <IvDoorn@gmail.com>,
	<linux-wireless@vger.kernel.org>, <users@rt2x00.serialmonkey.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: [PATCH 3/9] rt2x00: Re-order tx descriptor writing code in drivers.
Date: Tue, 11 May 2010 23:51:39 +0200
Message-Id: <1273614705-25118-4-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1273614705-25118-1-git-send-email-gwingerde@gmail.com>
References: <1273614705-25118-1-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Where possible, write the tx descriptor words from start to end, to
follow a logical ordering of words.
Where this is not possible (in rt2400pci, rt2500pci and rt61pci) add
a comment as to why word 0 needs to be written last.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2400pci.c |    5 +++
 drivers/net/wireless/rt2x00/rt2500pci.c |    5 +++
 drivers/net/wireless/rt2x00/rt2500usb.c |   36 +++++++++++-----------
 drivers/net/wireless/rt2x00/rt61pci.c   |    5 +++
 drivers/net/wireless/rt2x00/rt73usb.c   |   52 +++++++++++++++---------------
 5 files changed, 59 insertions(+), 44 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index 4b38451..1eff6ec 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -1039,6 +1039,11 @@ static void rt2400pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 	rt2x00_set_field32(&word, TXD_W3_PLCP_LENGTH_HIGH_BUSY, 1);
 	rt2x00_desc_write(txd, 4, word);
 
+	/*
+	 * Writing TXD word 0 must the last to prevent a race condition with
+	 * the device, whereby the device may take hold of the TXD before we
+	 * finished updating it.
+	 */
 	rt2x00_desc_read(txd, 0, &word);
 	rt2x00_set_field32(&word, TXD_W0_OWNER_NIC, 1);
 	rt2x00_set_field32(&word, TXD_W0_VALID, 1);
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index d876c6d..8d3e95e 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -1193,6 +1193,11 @@ static void rt2500pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 			   test_bit(ENTRY_TXD_RTS_FRAME, &txdesc->flags));
 	rt2x00_desc_write(txd, 10, word);
 
+	/*
+	 * Writing TXD word 0 must the last to prevent a race condition with
+	 * the device, whereby the device may take hold of the TXD before we
+	 * finished updating it.
+	 */
 	rt2x00_desc_read(txd, 0, &word);
 	rt2x00_set_field32(&word, TXD_W0_OWNER_NIC, 1);
 	rt2x00_set_field32(&word, TXD_W0_VALID, 1);
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 30c0544..9a915be 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -1039,6 +1039,24 @@ static void rt2500usb_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 	/*
 	 * Start writing the descriptor words.
 	 */
+	rt2x00_desc_read(txd, 0, &word);
+	rt2x00_set_field32(&word, TXD_W0_RETRY_LIMIT, txdesc->retry_limit);
+	rt2x00_set_field32(&word, TXD_W0_MORE_FRAG,
+			   test_bit(ENTRY_TXD_MORE_FRAG, &txdesc->flags));
+	rt2x00_set_field32(&word, TXD_W0_ACK,
+			   test_bit(ENTRY_TXD_ACK, &txdesc->flags));
+	rt2x00_set_field32(&word, TXD_W0_TIMESTAMP,
+			   test_bit(ENTRY_TXD_REQ_TIMESTAMP, &txdesc->flags));
+	rt2x00_set_field32(&word, TXD_W0_OFDM,
+			   (txdesc->rate_mode == RATE_MODE_OFDM));
+	rt2x00_set_field32(&word, TXD_W0_NEW_SEQ,
+			   test_bit(ENTRY_TXD_FIRST_FRAGMENT, &txdesc->flags));
+	rt2x00_set_field32(&word, TXD_W0_IFS, txdesc->ifs);
+	rt2x00_set_field32(&word, TXD_W0_DATABYTE_COUNT, txdesc->length);
+	rt2x00_set_field32(&word, TXD_W0_CIPHER, !!txdesc->cipher);
+	rt2x00_set_field32(&word, TXD_W0_KEY_ID, txdesc->key_idx);
+	rt2x00_desc_write(txd, 0, word);
+
 	rt2x00_desc_read(txd, 1, &word);
 	rt2x00_set_field32(&word, TXD_W1_IV_OFFSET, txdesc->iv_offset);
 	rt2x00_set_field32(&word, TXD_W1_AIFS, txdesc->aifs);
@@ -1057,24 +1075,6 @@ static void rt2500usb_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 		_rt2x00_desc_write(txd, 3, skbdesc->iv[0]);
 		_rt2x00_desc_write(txd, 4, skbdesc->iv[1]);
 	}
-
-	rt2x00_desc_read(txd, 0, &word);
-	rt2x00_set_field32(&word, TXD_W0_RETRY_LIMIT, txdesc->retry_limit);
-	rt2x00_set_field32(&word, TXD_W0_MORE_FRAG,
-			   test_bit(ENTRY_TXD_MORE_FRAG, &txdesc->flags));
-	rt2x00_set_field32(&word, TXD_W0_ACK,
-			   test_bit(ENTRY_TXD_ACK, &txdesc->flags));
-	rt2x00_set_field32(&word, TXD_W0_TIMESTAMP,
-			   test_bit(ENTRY_TXD_REQ_TIMESTAMP, &txdesc->flags));
-	rt2x00_set_field32(&word, TXD_W0_OFDM,
-			   (txdesc->rate_mode == RATE_MODE_OFDM));
-	rt2x00_set_field32(&word, TXD_W0_NEW_SEQ,
-			   test_bit(ENTRY_TXD_FIRST_FRAGMENT, &txdesc->flags));
-	rt2x00_set_field32(&word, TXD_W0_IFS, txdesc->ifs);
-	rt2x00_set_field32(&word, TXD_W0_DATABYTE_COUNT, txdesc->length);
-	rt2x00_set_field32(&word, TXD_W0_CIPHER, !!txdesc->cipher);
-	rt2x00_set_field32(&word, TXD_W0_KEY_ID, txdesc->key_idx);
-	rt2x00_desc_write(txd, 0, word);
 }
 
 /*
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 99c2981..55aa010 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -1813,6 +1813,11 @@ static void rt61pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 		rt2x00_desc_write(txd, 11, word);
 	}
 
+	/*
+	 * Writing TXD word 0 must the last to prevent a race condition with
+	 * the device, whereby the device may take hold of the TXD before we
+	 * finished updating it.
+	 */
 	rt2x00_desc_read(txd, 0, &word);
 	rt2x00_set_field32(&word, TXD_W0_OWNER_NIC, 1);
 	rt2x00_set_field32(&word, TXD_W0_VALID, 1);
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 81f6db1..fa40d43 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -1446,6 +1446,32 @@ static void rt73usb_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 	/*
 	 * Start writing the descriptor words.
 	 */
+	rt2x00_desc_read(txd, 0, &word);
+	rt2x00_set_field32(&word, TXD_W0_BURST,
+			   test_bit(ENTRY_TXD_BURST, &txdesc->flags));
+	rt2x00_set_field32(&word, TXD_W0_VALID, 1);
+	rt2x00_set_field32(&word, TXD_W0_MORE_FRAG,
+			   test_bit(ENTRY_TXD_MORE_FRAG, &txdesc->flags));
+	rt2x00_set_field32(&word, TXD_W0_ACK,
+			   test_bit(ENTRY_TXD_ACK, &txdesc->flags));
+	rt2x00_set_field32(&word, TXD_W0_TIMESTAMP,
+			   test_bit(ENTRY_TXD_REQ_TIMESTAMP, &txdesc->flags));
+	rt2x00_set_field32(&word, TXD_W0_OFDM,
+			   (txdesc->rate_mode == RATE_MODE_OFDM));
+	rt2x00_set_field32(&word, TXD_W0_IFS, txdesc->ifs);
+	rt2x00_set_field32(&word, TXD_W0_RETRY_MODE,
+			   test_bit(ENTRY_TXD_RETRY_MODE, &txdesc->flags));
+	rt2x00_set_field32(&word, TXD_W0_TKIP_MIC,
+			   test_bit(ENTRY_TXD_ENCRYPT_MMIC, &txdesc->flags));
+	rt2x00_set_field32(&word, TXD_W0_KEY_TABLE,
+			   test_bit(ENTRY_TXD_ENCRYPT_PAIRWISE, &txdesc->flags));
+	rt2x00_set_field32(&word, TXD_W0_KEY_INDEX, txdesc->key_idx);
+	rt2x00_set_field32(&word, TXD_W0_DATABYTE_COUNT, txdesc->length);
+	rt2x00_set_field32(&word, TXD_W0_BURST2,
+			   test_bit(ENTRY_TXD_BURST, &txdesc->flags));
+	rt2x00_set_field32(&word, TXD_W0_CIPHER_ALG, txdesc->cipher);
+	rt2x00_desc_write(txd, 0, word);
+
 	rt2x00_desc_read(txd, 1, &word);
 	rt2x00_set_field32(&word, TXD_W1_HOST_Q_ID, txdesc->queue);
 	rt2x00_set_field32(&word, TXD_W1_AIFSN, txdesc->aifs);
@@ -1473,32 +1499,6 @@ static void rt73usb_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 			   TXPOWER_TO_DEV(rt2x00dev->tx_power));
 	rt2x00_set_field32(&word, TXD_W5_WAITING_DMA_DONE_INT, 1);
 	rt2x00_desc_write(txd, 5, word);
-
-	rt2x00_desc_read(txd, 0, &word);
-	rt2x00_set_field32(&word, TXD_W0_BURST,
-			   test_bit(ENTRY_TXD_BURST, &txdesc->flags));
-	rt2x00_set_field32(&word, TXD_W0_VALID, 1);
-	rt2x00_set_field32(&word, TXD_W0_MORE_FRAG,
-			   test_bit(ENTRY_TXD_MORE_FRAG, &txdesc->flags));
-	rt2x00_set_field32(&word, TXD_W0_ACK,
-			   test_bit(ENTRY_TXD_ACK, &txdesc->flags));
-	rt2x00_set_field32(&word, TXD_W0_TIMESTAMP,
-			   test_bit(ENTRY_TXD_REQ_TIMESTAMP, &txdesc->flags));
-	rt2x00_set_field32(&word, TXD_W0_OFDM,
-			   (txdesc->rate_mode == RATE_MODE_OFDM));
-	rt2x00_set_field32(&word, TXD_W0_IFS, txdesc->ifs);
-	rt2x00_set_field32(&word, TXD_W0_RETRY_MODE,
-			   test_bit(ENTRY_TXD_RETRY_MODE, &txdesc->flags));
-	rt2x00_set_field32(&word, TXD_W0_TKIP_MIC,
-			   test_bit(ENTRY_TXD_ENCRYPT_MMIC, &txdesc->flags));
-	rt2x00_set_field32(&word, TXD_W0_KEY_TABLE,
-			   test_bit(ENTRY_TXD_ENCRYPT_PAIRWISE, &txdesc->flags));
-	rt2x00_set_field32(&word, TXD_W0_KEY_INDEX, txdesc->key_idx);
-	rt2x00_set_field32(&word, TXD_W0_DATABYTE_COUNT, txdesc->length);
-	rt2x00_set_field32(&word, TXD_W0_BURST2,
-			   test_bit(ENTRY_TXD_BURST, &txdesc->flags));
-	rt2x00_set_field32(&word, TXD_W0_CIPHER_ALG, txdesc->cipher);
-	rt2x00_desc_write(txd, 0, word);
 }
 
 /*
-- 
1.7.1

