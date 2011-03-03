Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35605 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932219Ab1CCSso (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Mar 2011 13:48:44 -0500
Received: by mail-wy0-f174.google.com with SMTP id 36so1356532wyg.19
        for <linux-wireless@vger.kernel.org>; Thu, 03 Mar 2011 10:48:43 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 09/19] rt2x00: Move TX descriptor field "ifs" into plcp substruct
Date: Thu, 3 Mar 2011 19:43:25 +0100
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201103031938.56423.IvDoorn@gmail.com> <201103031942.36144.IvDoorn@gmail.com> <201103031942.58935.IvDoorn@gmail.com>
In-Reply-To: <201103031942.58935.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201103031943.26328.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Helmut Schaa <helmut.schaa@googlemail.com>

"ifs" is only used by no-HT devices. Move it into the plcp substruct and
fill in the value only for no-HT devices.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2400pci.c   |    2 +-
 drivers/net/wireless/rt2x00/rt2500pci.c   |    2 +-
 drivers/net/wireless/rt2x00/rt2500usb.c   |    2 +-
 drivers/net/wireless/rt2x00/rt2x00queue.c |   20 +++++++++++---------
 drivers/net/wireless/rt2x00/rt2x00queue.h |    2 +-
 drivers/net/wireless/rt2x00/rt61pci.c     |    2 +-
 drivers/net/wireless/rt2x00/rt73usb.c     |    2 +-
 7 files changed, 17 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index 60d7596..9016c00 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -1166,7 +1166,7 @@ static void rt2400pci_write_tx_desc(struct queue_entry *entry,
 			   test_bit(ENTRY_TXD_REQ_TIMESTAMP, &txdesc->flags));
 	rt2x00_set_field32(&word, TXD_W0_RTS,
 			   test_bit(ENTRY_TXD_RTS_FRAME, &txdesc->flags));
-	rt2x00_set_field32(&word, TXD_W0_IFS, txdesc->ifs);
+	rt2x00_set_field32(&word, TXD_W0_IFS, txdesc->u.plcp.ifs);
 	rt2x00_set_field32(&word, TXD_W0_RETRY_MODE,
 			   test_bit(ENTRY_TXD_RETRY_MODE, &txdesc->flags));
 	rt2x00_desc_write(txd, 0, word);
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index 53ff64e..0fbc18c 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -1317,7 +1317,7 @@ static void rt2500pci_write_tx_desc(struct queue_entry *entry,
 	rt2x00_set_field32(&word, TXD_W0_OFDM,
 			   (txdesc->rate_mode == RATE_MODE_OFDM));
 	rt2x00_set_field32(&word, TXD_W0_CIPHER_OWNER, 1);
-	rt2x00_set_field32(&word, TXD_W0_IFS, txdesc->ifs);
+	rt2x00_set_field32(&word, TXD_W0_IFS, txdesc->u.plcp.ifs);
 	rt2x00_set_field32(&word, TXD_W0_RETRY_MODE,
 			   test_bit(ENTRY_TXD_RETRY_MODE, &txdesc->flags));
 	rt2x00_set_field32(&word, TXD_W0_DATABYTE_COUNT, txdesc->length);
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index ed5bc9c..979fe65 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -1100,7 +1100,7 @@ static void rt2500usb_write_tx_desc(struct queue_entry *entry,
 			   (txdesc->rate_mode == RATE_MODE_OFDM));
 	rt2x00_set_field32(&word, TXD_W0_NEW_SEQ,
 			   test_bit(ENTRY_TXD_FIRST_FRAGMENT, &txdesc->flags));
-	rt2x00_set_field32(&word, TXD_W0_IFS, txdesc->ifs);
+	rt2x00_set_field32(&word, TXD_W0_IFS, txdesc->u.plcp.ifs);
 	rt2x00_set_field32(&word, TXD_W0_DATABYTE_COUNT, txdesc->length);
 	rt2x00_set_field32(&word, TXD_W0_CIPHER, !!txdesc->cipher);
 	rt2x00_set_field32(&word, TXD_W0_KEY_ID, txdesc->key_idx);
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index 7816c1c..6300cf3 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -262,6 +262,16 @@ static void rt2x00queue_create_tx_descriptor_plcp(struct queue_entry *entry,
 	unsigned int duration;
 	unsigned int residual;
 
+	/*
+	 * Determine with what IFS priority this frame should be send.
+	 * Set ifs to IFS_SIFS when the this is not the first fragment,
+	 * or this fragment came after RTS/CTS.
+	 */
+	if (test_bit(ENTRY_TXD_FIRST_FRAGMENT, &txdesc->flags))
+		txdesc->u.plcp.ifs = IFS_BACKOFF;
+	else
+		txdesc->u.plcp.ifs = IFS_SIFS;
+
 	/* Data length + CRC + Crypto overhead (IV/EIV/ICV/MIC) */
 	data_length = entry->skb->len + 4;
 	data_length += rt2x00crypto_tx_overhead(rt2x00dev, entry->skb);
@@ -373,17 +383,9 @@ static void rt2x00queue_create_tx_descriptor(struct queue_entry *entry,
 	    ieee80211_is_probe_resp(hdr->frame_control))
 		__set_bit(ENTRY_TXD_REQ_TIMESTAMP, &txdesc->flags);
 
-	/*
-	 * Determine with what IFS priority this frame should be send.
-	 * Set ifs to IFS_SIFS when the this is not the first fragment,
-	 * or this fragment came after RTS/CTS.
-	 */
 	if ((tx_info->flags & IEEE80211_TX_CTL_FIRST_FRAGMENT) &&
-	    !test_bit(ENTRY_TXD_RTS_FRAME, &txdesc->flags)) {
+	    !test_bit(ENTRY_TXD_RTS_FRAME, &txdesc->flags))
 		__set_bit(ENTRY_TXD_FIRST_FRAGMENT, &txdesc->flags);
-		txdesc->ifs = IFS_BACKOFF;
-	} else
-		txdesc->ifs = IFS_SIFS;
 
 	/*
 	 * Determine rate modulation.
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.h b/drivers/net/wireless/rt2x00/rt2x00queue.h
index 3fa2406..7f8528d 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.h
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.h
@@ -311,6 +311,7 @@ struct txentry_desc {
 			u16 length_low;
 			u16 signal;
 			u16 service;
+			enum ifs ifs;
 		} plcp;
 
 		struct {
@@ -325,7 +326,6 @@ struct txentry_desc {
 	u16 rate_mode;
 
 	short retry_limit;
-	enum ifs ifs;
 
 	enum cipher cipher;
 	u16 key_idx;
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 6b49c28..1eb59ee 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -1948,7 +1948,7 @@ static void rt61pci_write_tx_desc(struct queue_entry *entry,
 			   test_bit(ENTRY_TXD_REQ_TIMESTAMP, &txdesc->flags));
 	rt2x00_set_field32(&word, TXD_W0_OFDM,
 			   (txdesc->rate_mode == RATE_MODE_OFDM));
-	rt2x00_set_field32(&word, TXD_W0_IFS, txdesc->ifs);
+	rt2x00_set_field32(&word, TXD_W0_IFS, txdesc->u.plcp.ifs);
 	rt2x00_set_field32(&word, TXD_W0_RETRY_MODE,
 			   test_bit(ENTRY_TXD_RETRY_MODE, &txdesc->flags));
 	rt2x00_set_field32(&word, TXD_W0_TKIP_MIC,
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 80d06d0..4a4bd4e 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -1474,7 +1474,7 @@ static void rt73usb_write_tx_desc(struct queue_entry *entry,
 			   test_bit(ENTRY_TXD_REQ_TIMESTAMP, &txdesc->flags));
 	rt2x00_set_field32(&word, TXD_W0_OFDM,
 			   (txdesc->rate_mode == RATE_MODE_OFDM));
-	rt2x00_set_field32(&word, TXD_W0_IFS, txdesc->ifs);
+	rt2x00_set_field32(&word, TXD_W0_IFS, txdesc->u.plcp.ifs);
 	rt2x00_set_field32(&word, TXD_W0_RETRY_MODE,
 			   test_bit(ENTRY_TXD_RETRY_MODE, &txdesc->flags));
 	rt2x00_set_field32(&word, TXD_W0_TKIP_MIC,
-- 
1.7.2.3

