Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.185]:17014 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754505AbXHSSba convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Aug 2007 14:31:30 -0400
Received: by mu-out-0910.google.com with SMTP id i10so1553933mue
        for <linux-wireless@vger.kernel.org>; Sun, 19 Aug 2007 11:31:28 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 20/30] rt2x00: Cleanup TXD flags
Date: Sun, 19 Aug 2007 20:28:36 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200708192018.30624.IvDoorn@gmail.com>
In-Reply-To: <200708192018.30624.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200708192028.36391.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From c46e24be398993af9bb4ad153f5f98dd42f86cd3 Mon Sep 17 00:00:00 2001
From: Ivo van Doorn <IvDoorn@gmail.com>
Date: Sat, 18 Aug 2007 13:19:21 +0200
Subject: [PATCH 20/30] rt2x00: Cleanup TXD flags

Add a new TXD flag to indicate if this frame is part
of the same burst series (CTS/RTS + Fragments).

Also remove the TXD_ACK flag since we can use the control->flags
variable directly. So no point in copying flags.

And lastly fix the check for the NEW_SEQ bit in rt2500usb,
the check for the flag was not converted to a boolean
causing the value always to be set to 0.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2400pci.c  |    2 +-
 drivers/net/wireless/rt2500pci.c  |    2 +-
 drivers/net/wireless/rt2500usb.c  |    4 ++--
 drivers/net/wireless/rt2x00dev.c  |   11 ++++-------
 drivers/net/wireless/rt2x00ring.h |    2 +-
 drivers/net/wireless/rt61pci.c    |    4 +++-
 drivers/net/wireless/rt73usb.c    |    6 +++++-
 7 files changed, 17 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/rt2400pci.c b/drivers/net/wireless/rt2400pci.c
index 1e935fd..e5622d6 100644
--- a/drivers/net/wireless/rt2400pci.c
+++ b/drivers/net/wireless/rt2400pci.c
@@ -1147,7 +1147,7 @@ static void rt2400pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 	rt2x00_set_field32(&word, TXD_W0_MORE_FRAG,
 			   test_bit(ENTRY_TXD_MORE_FRAG, &entry->flags));
 	rt2x00_set_field32(&word, TXD_W0_ACK,
-			   test_bit(ENTRY_TXD_REQ_ACK, &entry->flags));
+			   !(control->flags & IEEE80211_TXCTL_NO_ACK));
 	rt2x00_set_field32(&word, TXD_W0_TIMESTAMP,
 			   test_bit(ENTRY_TXD_REQ_TIMESTAMP, &entry->flags));
 	rt2x00_set_field32(&word, TXD_W0_RTS,
diff --git a/drivers/net/wireless/rt2500pci.c b/drivers/net/wireless/rt2500pci.c
index 28b2c73..bfcedfd 100644
--- a/drivers/net/wireless/rt2500pci.c
+++ b/drivers/net/wireless/rt2500pci.c
@@ -1274,7 +1274,7 @@ static void rt2500pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 	rt2x00_set_field32(&word, TXD_W0_MORE_FRAG,
 			   test_bit(ENTRY_TXD_MORE_FRAG, &entry->flags));
 	rt2x00_set_field32(&word, TXD_W0_ACK,
-			   test_bit(ENTRY_TXD_REQ_ACK, &entry->flags));
+			   !(control->flags & IEEE80211_TXCTL_NO_ACK));
 	rt2x00_set_field32(&word, TXD_W0_TIMESTAMP,
 			   test_bit(ENTRY_TXD_REQ_TIMESTAMP, &entry->flags));
 	rt2x00_set_field32(&word, TXD_W0_OFDM,
diff --git a/drivers/net/wireless/rt2500usb.c b/drivers/net/wireless/rt2500usb.c
index 0c0076c..9670330 100644
--- a/drivers/net/wireless/rt2500usb.c
+++ b/drivers/net/wireless/rt2500usb.c
@@ -1066,13 +1066,13 @@ static void rt2500usb_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 	rt2x00_set_field32(&word, TXD_W0_MORE_FRAG,
 			   test_bit(ENTRY_TXD_MORE_FRAG, &entry->flags));
 	rt2x00_set_field32(&word, TXD_W0_ACK,
-			   test_bit(ENTRY_TXD_REQ_ACK, &entry->flags));
+			   !(control->flags & IEEE80211_TXCTL_NO_ACK));
 	rt2x00_set_field32(&word, TXD_W0_TIMESTAMP,
 			   test_bit(ENTRY_TXD_REQ_TIMESTAMP, &entry->flags));
 	rt2x00_set_field32(&word, TXD_W0_OFDM,
 			   test_bit(ENTRY_TXD_OFDM_RATE, &entry->flags));
 	rt2x00_set_field32(&word, TXD_W0_NEW_SEQ,
-			   control->flags & IEEE80211_TXCTL_FIRST_FRAGMENT);
+			   !!(control->flags & IEEE80211_TXCTL_FIRST_FRAGMENT));
 	rt2x00_set_field32(&word, TXD_W0_IFS, desc->ifs);
 	rt2x00_set_field32(&word, TXD_W0_DATABYTE_COUNT, length);
 	rt2x00_set_field32(&word, TXD_W0_CIPHER, CIPHER_NONE);
diff --git a/drivers/net/wireless/rt2x00dev.c b/drivers/net/wireless/rt2x00dev.c
index 50c604c..36b522b 100644
--- a/drivers/net/wireless/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00dev.c
@@ -439,6 +439,7 @@ void rt2x00lib_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 	 * Check if this is a RTS/CTS frame
 	 */
 	if (is_rts_frame(frame_control) || is_cts_frame(frame_control)) {
+		__set_bit(ENTRY_TXD_BURST, &entry->flags);
 		if (is_rts_frame(frame_control))
 			__set_bit(ENTRY_TXD_RTS_FRAME, &entry->flags);
 		if (control->rts_cts_rate)
@@ -454,8 +455,10 @@ void rt2x00lib_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 	/*
 	 * Check if more fragments are pending
 	 */
-	if (ieee80211_get_morefrag(ieee80211hdr))
+	if (ieee80211_get_morefrag(ieee80211hdr)) {
+		__set_bit(ENTRY_TXD_BURST, &entry->flags);
 		__set_bit(ENTRY_TXD_MORE_FRAG, &entry->flags);
+	}
 
 	/*
 	 * Beacons and probe responses require the tsf timestamp
@@ -466,12 +469,6 @@ void rt2x00lib_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 		__set_bit(ENTRY_TXD_REQ_TIMESTAMP, &entry->flags);
 
 	/*
-	 * Check if ACK is required
-	 */
-	if (!(control->flags & IEEE80211_TXCTL_NO_ACK))
-		__set_bit(ENTRY_TXD_REQ_ACK, &entry->flags);
-
-	/*
 	 * Determine with what IFS priority this frame should be send.
 	 * Set ifs to IFS_SIFS when the this is not the first fragment,
 	 * or this fragment came after RTS/CTS.
diff --git a/drivers/net/wireless/rt2x00ring.h b/drivers/net/wireless/rt2x00ring.h
index 9c94d06..143ad6d 100644
--- a/drivers/net/wireless/rt2x00ring.h
+++ b/drivers/net/wireless/rt2x00ring.h
@@ -76,7 +76,7 @@ struct data_entry {
 #define ENTRY_TXD_OFDM_RATE	4
 #define ENTRY_TXD_MORE_FRAG	5
 #define ENTRY_TXD_REQ_TIMESTAMP	6
-#define ENTRY_TXD_REQ_ACK	7
+#define ENTRY_TXD_BURST		7
 
 	/*
 	 * Ring we belong to.
diff --git a/drivers/net/wireless/rt61pci.c b/drivers/net/wireless/rt61pci.c
index a6fcef7..e179702 100644
--- a/drivers/net/wireless/rt61pci.c
+++ b/drivers/net/wireless/rt61pci.c
@@ -1519,7 +1519,7 @@ static void rt61pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 	rt2x00_set_field32(&word, TXD_W0_MORE_FRAG,
 			   test_bit(ENTRY_TXD_MORE_FRAG, &entry->flags));
 	rt2x00_set_field32(&word, TXD_W0_ACK,
-			   test_bit(ENTRY_TXD_REQ_ACK, &entry->flags));
+			   !(control->flags & IEEE80211_TXCTL_NO_ACK));
 	rt2x00_set_field32(&word, TXD_W0_TIMESTAMP,
 			   test_bit(ENTRY_TXD_REQ_TIMESTAMP, &entry->flags));
 	rt2x00_set_field32(&word, TXD_W0_OFDM,
@@ -1528,6 +1528,8 @@ static void rt61pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 	rt2x00_set_field32(&word, TXD_W0_RETRY_MODE, 0);
 	rt2x00_set_field32(&word, TXD_W0_TKIP_MIC, 0);
 	rt2x00_set_field32(&word, TXD_W0_DATABYTE_COUNT, length);
+	rt2x00_set_field32(&word, TXD_W0_BURST,
+			   test_bit(ENTRY_TXD_BURST, &entry->flags));
 	rt2x00_set_field32(&word, TXD_W0_CIPHER_ALG, CIPHER_NONE);
 	rt2x00_desc_write(txd, 0, word);
 }
diff --git a/drivers/net/wireless/rt73usb.c b/drivers/net/wireless/rt73usb.c
index 98d3acc..1e8b88e 100644
--- a/drivers/net/wireless/rt73usb.c
+++ b/drivers/net/wireless/rt73usb.c
@@ -1250,11 +1250,13 @@ static void rt73usb_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 	rt2x00_desc_write(txd, 5, word);
 
 	rt2x00_desc_read(txd, 0, &word);
+	rt2x00_set_field32(&word, TXD_W0_BURST,
+			   test_bit(ENTRY_TXD_BURST, &entry->flags));
 	rt2x00_set_field32(&word, TXD_W0_VALID, 1);
 	rt2x00_set_field32(&word, TXD_W0_MORE_FRAG,
 			   test_bit(ENTRY_TXD_MORE_FRAG, &entry->flags));
 	rt2x00_set_field32(&word, TXD_W0_ACK,
-			   test_bit(ENTRY_TXD_REQ_ACK, &entry->flags));
+			   !(control->flags & IEEE80211_TXCTL_NO_ACK));
 	rt2x00_set_field32(&word, TXD_W0_TIMESTAMP,
 			   test_bit(ENTRY_TXD_REQ_TIMESTAMP, &entry->flags));
 	rt2x00_set_field32(&word, TXD_W0_OFDM,
@@ -1263,6 +1265,8 @@ static void rt73usb_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 	rt2x00_set_field32(&word, TXD_W0_RETRY_MODE, 0);
 	rt2x00_set_field32(&word, TXD_W0_TKIP_MIC, 0);
 	rt2x00_set_field32(&word, TXD_W0_DATABYTE_COUNT, length);
+	rt2x00_set_field32(&word, TXD_W0_BURST2,
+			   test_bit(ENTRY_TXD_BURST, &entry->flags));
 	rt2x00_set_field32(&word, TXD_W0_CIPHER_ALG, CIPHER_NONE);
 	rt2x00_desc_write(txd, 0, word);
 }
-- 
1.5.3.rc5

