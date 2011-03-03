Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:45862 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758702Ab1CCStO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Mar 2011 13:49:14 -0500
Received: by wwb22 with SMTP id 22so1738699wwb.1
        for <linux-wireless@vger.kernel.org>; Thu, 03 Mar 2011 10:49:13 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 07/19] rt2x00: Optimize TX descriptor handling
Date: Thu, 3 Mar 2011 19:42:35 +0100
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201103031938.56423.IvDoorn@gmail.com> <201103031941.04133.IvDoorn@gmail.com> <201103031942.02498.IvDoorn@gmail.com>
In-Reply-To: <201103031942.02498.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201103031942.36144.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Helmut Schaa <helmut.schaa@googlemail.com>

HT and no-HT rt2x00 devices use a partly different TX descriptor.
Optimize the tx desciptor memory layout by putting the PLCP and HT
substructs into a union and introduce a new driver flag to decide which
TX desciptor format is used by the device.

This saves us the expensive PLCP calculation fOr HT devices and the HT
descriptor setup on no-HT devices.

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2400pci.c   |   10 ++++++----
 drivers/net/wireless/rt2x00/rt2500pci.c   |   10 ++++++----
 drivers/net/wireless/rt2x00/rt2500usb.c   |   10 ++++++----
 drivers/net/wireless/rt2x00/rt2800lib.c   |   11 ++++++-----
 drivers/net/wireless/rt2x00/rt2800pci.c   |    1 +
 drivers/net/wireless/rt2x00/rt2800usb.c   |    1 +
 drivers/net/wireless/rt2x00/rt2x00.h      |    1 +
 drivers/net/wireless/rt2x00/rt2x00ht.c    |   20 ++++++++++----------
 drivers/net/wireless/rt2x00/rt2x00queue.c |   23 +++++++++++++----------
 drivers/net/wireless/rt2x00/rt2x00queue.h |   25 ++++++++++++++++---------
 drivers/net/wireless/rt2x00/rt61pci.c     |   10 ++++++----
 drivers/net/wireless/rt2x00/rt73usb.c     |   10 ++++++----
 12 files changed, 78 insertions(+), 54 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index d38acf4..60d7596 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -1131,19 +1131,21 @@ static void rt2400pci_write_tx_desc(struct queue_entry *entry,
 	rt2x00_desc_write(txd, 2, word);
 
 	rt2x00_desc_read(txd, 3, &word);
-	rt2x00_set_field32(&word, TXD_W3_PLCP_SIGNAL, txdesc->signal);
+	rt2x00_set_field32(&word, TXD_W3_PLCP_SIGNAL, txdesc->u.plcp.signal);
 	rt2x00_set_field32(&word, TXD_W3_PLCP_SIGNAL_REGNUM, 5);
 	rt2x00_set_field32(&word, TXD_W3_PLCP_SIGNAL_BUSY, 1);
-	rt2x00_set_field32(&word, TXD_W3_PLCP_SERVICE, txdesc->service);
+	rt2x00_set_field32(&word, TXD_W3_PLCP_SERVICE, txdesc->u.plcp.service);
 	rt2x00_set_field32(&word, TXD_W3_PLCP_SERVICE_REGNUM, 6);
 	rt2x00_set_field32(&word, TXD_W3_PLCP_SERVICE_BUSY, 1);
 	rt2x00_desc_write(txd, 3, word);
 
 	rt2x00_desc_read(txd, 4, &word);
-	rt2x00_set_field32(&word, TXD_W4_PLCP_LENGTH_LOW, txdesc->length_low);
+	rt2x00_set_field32(&word, TXD_W4_PLCP_LENGTH_LOW,
+			   txdesc->u.plcp.length_low);
 	rt2x00_set_field32(&word, TXD_W3_PLCP_LENGTH_LOW_REGNUM, 8);
 	rt2x00_set_field32(&word, TXD_W3_PLCP_LENGTH_LOW_BUSY, 1);
-	rt2x00_set_field32(&word, TXD_W4_PLCP_LENGTH_HIGH, txdesc->length_high);
+	rt2x00_set_field32(&word, TXD_W4_PLCP_LENGTH_HIGH,
+			   txdesc->u.plcp.length_high);
 	rt2x00_set_field32(&word, TXD_W3_PLCP_LENGTH_HIGH_REGNUM, 7);
 	rt2x00_set_field32(&word, TXD_W3_PLCP_LENGTH_HIGH_BUSY, 1);
 	rt2x00_desc_write(txd, 4, word);
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index b00e4d4..53ff64e 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -1287,10 +1287,12 @@ static void rt2500pci_write_tx_desc(struct queue_entry *entry,
 	rt2x00_desc_write(txd, 2, word);
 
 	rt2x00_desc_read(txd, 3, &word);
-	rt2x00_set_field32(&word, TXD_W3_PLCP_SIGNAL, txdesc->signal);
-	rt2x00_set_field32(&word, TXD_W3_PLCP_SERVICE, txdesc->service);
-	rt2x00_set_field32(&word, TXD_W3_PLCP_LENGTH_LOW, txdesc->length_low);
-	rt2x00_set_field32(&word, TXD_W3_PLCP_LENGTH_HIGH, txdesc->length_high);
+	rt2x00_set_field32(&word, TXD_W3_PLCP_SIGNAL, txdesc->u.plcp.signal);
+	rt2x00_set_field32(&word, TXD_W3_PLCP_SERVICE, txdesc->u.plcp.service);
+	rt2x00_set_field32(&word, TXD_W3_PLCP_LENGTH_LOW,
+			   txdesc->u.plcp.length_low);
+	rt2x00_set_field32(&word, TXD_W3_PLCP_LENGTH_HIGH,
+			   txdesc->u.plcp.length_high);
 	rt2x00_desc_write(txd, 3, word);
 
 	rt2x00_desc_read(txd, 10, &word);
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index b71df29..ed5bc9c 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -1114,10 +1114,12 @@ static void rt2500usb_write_tx_desc(struct queue_entry *entry,
 	rt2x00_desc_write(txd, 1, word);
 
 	rt2x00_desc_read(txd, 2, &word);
-	rt2x00_set_field32(&word, TXD_W2_PLCP_SIGNAL, txdesc->signal);
-	rt2x00_set_field32(&word, TXD_W2_PLCP_SERVICE, txdesc->service);
-	rt2x00_set_field32(&word, TXD_W2_PLCP_LENGTH_LOW, txdesc->length_low);
-	rt2x00_set_field32(&word, TXD_W2_PLCP_LENGTH_HIGH, txdesc->length_high);
+	rt2x00_set_field32(&word, TXD_W2_PLCP_SIGNAL, txdesc->u.plcp.signal);
+	rt2x00_set_field32(&word, TXD_W2_PLCP_SERVICE, txdesc->u.plcp.service);
+	rt2x00_set_field32(&word, TXD_W2_PLCP_LENGTH_LOW,
+			   txdesc->u.plcp.length_low);
+	rt2x00_set_field32(&word, TXD_W2_PLCP_LENGTH_HIGH,
+			   txdesc->u.plcp.length_high);
 	rt2x00_desc_write(txd, 2, word);
 
 	if (test_bit(ENTRY_TXD_ENCRYPT, &txdesc->flags)) {
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 66ff8d5..d789d5b 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -472,14 +472,15 @@ void rt2800_write_tx_data(struct queue_entry *entry,
 			   test_bit(ENTRY_TXD_REQ_TIMESTAMP, &txdesc->flags));
 	rt2x00_set_field32(&word, TXWI_W0_AMPDU,
 			   test_bit(ENTRY_TXD_HT_AMPDU, &txdesc->flags));
-	rt2x00_set_field32(&word, TXWI_W0_MPDU_DENSITY, txdesc->mpdu_density);
-	rt2x00_set_field32(&word, TXWI_W0_TX_OP, txdesc->txop);
-	rt2x00_set_field32(&word, TXWI_W0_MCS, txdesc->mcs);
+	rt2x00_set_field32(&word, TXWI_W0_MPDU_DENSITY,
+			   txdesc->u.ht.mpdu_density);
+	rt2x00_set_field32(&word, TXWI_W0_TX_OP, txdesc->u.ht.txop);
+	rt2x00_set_field32(&word, TXWI_W0_MCS, txdesc->u.ht.mcs);
 	rt2x00_set_field32(&word, TXWI_W0_BW,
 			   test_bit(ENTRY_TXD_HT_BW_40, &txdesc->flags));
 	rt2x00_set_field32(&word, TXWI_W0_SHORT_GI,
 			   test_bit(ENTRY_TXD_HT_SHORT_GI, &txdesc->flags));
-	rt2x00_set_field32(&word, TXWI_W0_STBC, txdesc->stbc);
+	rt2x00_set_field32(&word, TXWI_W0_STBC, txdesc->u.ht.stbc);
 	rt2x00_set_field32(&word, TXWI_W0_PHYMODE, txdesc->rate_mode);
 	rt2x00_desc_write(txwi, 0, word);
 
@@ -488,7 +489,7 @@ void rt2800_write_tx_data(struct queue_entry *entry,
 			   test_bit(ENTRY_TXD_ACK, &txdesc->flags));
 	rt2x00_set_field32(&word, TXWI_W1_NSEQ,
 			   test_bit(ENTRY_TXD_GENERATE_SEQ, &txdesc->flags));
-	rt2x00_set_field32(&word, TXWI_W1_BW_WIN_SIZE, txdesc->ba_size);
+	rt2x00_set_field32(&word, TXWI_W1_BW_WIN_SIZE, txdesc->u.ht.ba_size);
 	rt2x00_set_field32(&word, TXWI_W1_WIRELESS_CLI_ID,
 			   test_bit(ENTRY_TXD_ENCRYPT, &txdesc->flags) ?
 			   txdesc->key_idx : 0xff);
diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index 9dbb598..1b5753b 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -979,6 +979,7 @@ static int rt2800pci_probe_hw(struct rt2x00_dev *rt2x00dev)
 	if (!modparam_nohwcrypt)
 		__set_bit(CONFIG_SUPPORT_HW_CRYPTO, &rt2x00dev->flags);
 	__set_bit(DRIVER_SUPPORT_LINK_TUNING, &rt2x00dev->flags);
+	__set_bit(DRIVER_REQUIRE_HT_TX_DESC, &rt2x00dev->flags);
 
 	/*
 	 * Set the rssi offset.
diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 5d91561..f1a9214 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -565,6 +565,7 @@ static int rt2800usb_probe_hw(struct rt2x00_dev *rt2x00dev)
 		__set_bit(CONFIG_SUPPORT_HW_CRYPTO, &rt2x00dev->flags);
 	__set_bit(DRIVER_SUPPORT_LINK_TUNING, &rt2x00dev->flags);
 	__set_bit(DRIVER_SUPPORT_WATCHDOG, &rt2x00dev->flags);
+	__set_bit(DRIVER_REQUIRE_HT_TX_DESC, &rt2x00dev->flags);
 
 	/*
 	 * Set the rssi offset.
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index be4d4cd..e17e348 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -663,6 +663,7 @@ enum rt2x00_flags {
 	DRIVER_REQUIRE_TXSTATUS_FIFO,
 	DRIVER_REQUIRE_TASKLET_CONTEXT,
 	DRIVER_REQUIRE_SW_SEQNO,
+	DRIVER_REQUIRE_HT_TX_DESC,
 
 	/*
 	 * Driver features
diff --git a/drivers/net/wireless/rt2x00/rt2x00ht.c b/drivers/net/wireless/rt2x00/rt2x00ht.c
index 03d9579..78a0e73 100644
--- a/drivers/net/wireless/rt2x00/rt2x00ht.c
+++ b/drivers/net/wireless/rt2x00/rt2x00ht.c
@@ -38,12 +38,12 @@ void rt2x00ht_create_tx_descriptor(struct queue_entry *entry,
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)entry->skb->data;
 
 	if (tx_info->control.sta)
-		txdesc->mpdu_density =
+		txdesc->u.ht.mpdu_density =
 		    tx_info->control.sta->ht_cap.ampdu_density;
 
-	txdesc->ba_size = 7;	/* FIXME: What value is needed? */
+	txdesc->u.ht.ba_size = 7;	/* FIXME: What value is needed? */
 
-	txdesc->stbc =
+	txdesc->u.ht.stbc =
 	    (tx_info->flags & IEEE80211_TX_CTL_STBC) >> IEEE80211_TX_CTL_STBC_SHIFT;
 
 	/*
@@ -51,22 +51,22 @@ void rt2x00ht_create_tx_descriptor(struct queue_entry *entry,
 	 * mcs rate to be used
 	 */
 	if (txrate->flags & IEEE80211_TX_RC_MCS) {
-		txdesc->mcs = txrate->idx;
+		txdesc->u.ht.mcs = txrate->idx;
 
 		/*
 		 * MIMO PS should be set to 1 for STA's using dynamic SM PS
 		 * when using more then one tx stream (>MCS7).
 		 */
-		if (tx_info->control.sta && txdesc->mcs > 7 &&
+		if (tx_info->control.sta && txdesc->u.ht.mcs > 7 &&
 		    ((tx_info->control.sta->ht_cap.cap &
 		      IEEE80211_HT_CAP_SM_PS) >>
 		     IEEE80211_HT_CAP_SM_PS_SHIFT) ==
 		    WLAN_HT_CAP_SM_PS_DYNAMIC)
 			__set_bit(ENTRY_TXD_HT_MIMO_PS, &txdesc->flags);
 	} else {
-		txdesc->mcs = rt2x00_get_rate_mcs(hwrate->mcs);
+		txdesc->u.ht.mcs = rt2x00_get_rate_mcs(hwrate->mcs);
 		if (txrate->flags & IEEE80211_TX_RC_USE_SHORT_PREAMBLE)
-			txdesc->mcs |= 0x08;
+			txdesc->u.ht.mcs |= 0x08;
 	}
 
 	/*
@@ -105,11 +105,11 @@ void rt2x00ht_create_tx_descriptor(struct queue_entry *entry,
 	 * for frames not transmitted with TXOP_HTTXOP
 	 */
 	if (ieee80211_is_mgmt(hdr->frame_control))
-		txdesc->txop = TXOP_BACKOFF;
+		txdesc->u.ht.txop = TXOP_BACKOFF;
 	else if (!(tx_info->flags & IEEE80211_TX_CTL_FIRST_FRAGMENT))
-		txdesc->txop = TXOP_SIFS;
+		txdesc->u.ht.txop = TXOP_SIFS;
 	else
-		txdesc->txop = TXOP_HTTXOP;
+		txdesc->u.ht.txop = TXOP_HTTXOP;
 }
 
 u16 rt2x00ht_center_channel(struct rt2x00_dev *rt2x00dev,
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index eebb564..7816c1c 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -270,12 +270,12 @@ static void rt2x00queue_create_tx_descriptor_plcp(struct queue_entry *entry,
 	 * PLCP setup
 	 * Length calculation depends on OFDM/CCK rate.
 	 */
-	txdesc->signal = hwrate->plcp;
-	txdesc->service = 0x04;
+	txdesc->u.plcp.signal = hwrate->plcp;
+	txdesc->u.plcp.service = 0x04;
 
 	if (hwrate->flags & DEV_RATE_OFDM) {
-		txdesc->length_high = (data_length >> 6) & 0x3f;
-		txdesc->length_low = data_length & 0x3f;
+		txdesc->u.plcp.length_high = (data_length >> 6) & 0x3f;
+		txdesc->u.plcp.length_low = data_length & 0x3f;
 	} else {
 		/*
 		 * Convert length to microseconds.
@@ -290,18 +290,18 @@ static void rt2x00queue_create_tx_descriptor_plcp(struct queue_entry *entry,
 			 * Check if we need to set the Length Extension
 			 */
 			if (hwrate->bitrate == 110 && residual <= 30)
-				txdesc->service |= 0x80;
+				txdesc->u.plcp.service |= 0x80;
 		}
 
-		txdesc->length_high = (duration >> 8) & 0xff;
-		txdesc->length_low = duration & 0xff;
+		txdesc->u.plcp.length_high = (duration >> 8) & 0xff;
+		txdesc->u.plcp.length_low = duration & 0xff;
 
 		/*
 		 * When preamble is enabled we should set the
 		 * preamble bit for the signal.
 		 */
 		if (txrate->flags & IEEE80211_TX_RC_USE_SHORT_PREAMBLE)
-			txdesc->signal |= 0x08;
+			txdesc->u.plcp.signal |= 0x08;
 	}
 }
 
@@ -397,9 +397,12 @@ static void rt2x00queue_create_tx_descriptor(struct queue_entry *entry,
 	 * Apply TX descriptor handling by components
 	 */
 	rt2x00crypto_create_tx_descriptor(entry, txdesc);
-	rt2x00ht_create_tx_descriptor(entry, txdesc, hwrate);
 	rt2x00queue_create_tx_descriptor_seq(entry, txdesc);
-	rt2x00queue_create_tx_descriptor_plcp(entry, txdesc, hwrate);
+
+	if (test_bit(DRIVER_REQUIRE_HT_TX_DESC, &rt2x00dev->flags))
+		rt2x00ht_create_tx_descriptor(entry, txdesc, hwrate);
+	else
+		rt2x00queue_create_tx_descriptor_plcp(entry, txdesc, hwrate);
 }
 
 static int rt2x00queue_write_tx_data(struct queue_entry *entry,
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.h b/drivers/net/wireless/rt2x00/rt2x00queue.h
index fab8e26..3305520 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.h
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.h
@@ -305,20 +305,27 @@ struct txentry_desc {
 	u16 length;
 	u16 header_length;
 
-	u16 length_high;
-	u16 length_low;
-	u16 signal;
-	u16 service;
-
-	u16 mcs;
-	u16 stbc;
-	u16 ba_size;
+	union {
+		struct {
+			u16 length_high;
+			u16 length_low;
+			u16 signal;
+			u16 service;
+		} plcp;
+
+		struct {
+			u16 mcs;
+			u16 stbc;
+			u16 ba_size;
+			u16 mpdu_density;
+			short txop;
+		} ht;
+	} u;
+
 	u16 rate_mode;
-	u16 mpdu_density;
 
 	short retry_limit;
 	short ifs;
-	short txop;
 
 	enum cipher cipher;
 	u16 key_idx;
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 674239e..6b49c28 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -1898,10 +1898,12 @@ static void rt61pci_write_tx_desc(struct queue_entry *entry,
 	rt2x00_desc_write(txd, 1, word);
 
 	rt2x00_desc_read(txd, 2, &word);
-	rt2x00_set_field32(&word, TXD_W2_PLCP_SIGNAL, txdesc->signal);
-	rt2x00_set_field32(&word, TXD_W2_PLCP_SERVICE, txdesc->service);
-	rt2x00_set_field32(&word, TXD_W2_PLCP_LENGTH_LOW, txdesc->length_low);
-	rt2x00_set_field32(&word, TXD_W2_PLCP_LENGTH_HIGH, txdesc->length_high);
+	rt2x00_set_field32(&word, TXD_W2_PLCP_SIGNAL, txdesc->u.plcp.signal);
+	rt2x00_set_field32(&word, TXD_W2_PLCP_SERVICE, txdesc->u.plcp.service);
+	rt2x00_set_field32(&word, TXD_W2_PLCP_LENGTH_LOW,
+			   txdesc->u.plcp.length_low);
+	rt2x00_set_field32(&word, TXD_W2_PLCP_LENGTH_HIGH,
+			   txdesc->u.plcp.length_high);
 	rt2x00_desc_write(txd, 2, word);
 
 	if (test_bit(ENTRY_TXD_ENCRYPT, &txdesc->flags)) {
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 61c964d..80d06d0 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -1499,10 +1499,12 @@ static void rt73usb_write_tx_desc(struct queue_entry *entry,
 	rt2x00_desc_write(txd, 1, word);
 
 	rt2x00_desc_read(txd, 2, &word);
-	rt2x00_set_field32(&word, TXD_W2_PLCP_SIGNAL, txdesc->signal);
-	rt2x00_set_field32(&word, TXD_W2_PLCP_SERVICE, txdesc->service);
-	rt2x00_set_field32(&word, TXD_W2_PLCP_LENGTH_LOW, txdesc->length_low);
-	rt2x00_set_field32(&word, TXD_W2_PLCP_LENGTH_HIGH, txdesc->length_high);
+	rt2x00_set_field32(&word, TXD_W2_PLCP_SIGNAL, txdesc->u.plcp.signal);
+	rt2x00_set_field32(&word, TXD_W2_PLCP_SERVICE, txdesc->u.plcp.service);
+	rt2x00_set_field32(&word, TXD_W2_PLCP_LENGTH_LOW,
+			   txdesc->u.plcp.length_low);
+	rt2x00_set_field32(&word, TXD_W2_PLCP_LENGTH_HIGH,
+			   txdesc->u.plcp.length_high);
 	rt2x00_desc_write(txd, 2, word);
 
 	if (test_bit(ENTRY_TXD_ENCRYPT, &txdesc->flags)) {
-- 
1.7.2.3

