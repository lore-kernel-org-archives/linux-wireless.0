Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.190]:3327 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572AbXJ0LZf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Oct 2007 07:25:35 -0400
Received: by nf-out-0910.google.com with SMTP id g13so973056nfb
        for <linux-wireless@vger.kernel.org>; Sat, 27 Oct 2007 04:25:34 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 20/21] rt2x00: Correctly set ACK bit in tx descriptors
Date: Sat, 27 Oct 2007 13:43:49 +0200
Cc: rt2400-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
References: <200710271334.34192.IvDoorn@gmail.com>
In-Reply-To: <200710271334.34192.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200710271343.50116.IvDoorn@gmail.com> (sfid-20071027_122538_061945_C942D585)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mattias Nissler <mattias.nissler@gmx.de>

Add a flag to struct txdata_entry_desc that specifies whether an ack for the
frame is to be expected. Use this flag to set the ACK bit in the tx descriptor.
Previously, the ACK bit could be set incorrectly on CTS-to-self frames, so they
caused retries and were reported to be failed in the txdone handlers.

Signed-off-by: Mattias Nissler <mattias.nissler@gmx.de>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2400pci.c  |    2 +-
 drivers/net/wireless/rt2x00/rt2500pci.c  |    2 +-
 drivers/net/wireless/rt2x00/rt2500usb.c  |    2 +-
 drivers/net/wireless/rt2x00/rt2x00dev.c  |   11 ++++++++++-
 drivers/net/wireless/rt2x00/rt2x00ring.h |    1 +
 drivers/net/wireless/rt2x00/rt61pci.c    |    2 +-
 drivers/net/wireless/rt2x00/rt73usb.c    |    2 +-
 7 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index 8889f6d..d48b6ca 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -1072,7 +1072,7 @@ static void rt2400pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 	rt2x00_set_field32(&word, TXD_W0_MORE_FRAG,
 			   test_bit(ENTRY_TXD_MORE_FRAG, &desc->flags));
 	rt2x00_set_field32(&word, TXD_W0_ACK,
-			   !(control->flags & IEEE80211_TXCTL_NO_ACK));
+			   test_bit(ENTRY_TXD_ACK, &desc->flags));
 	rt2x00_set_field32(&word, TXD_W0_TIMESTAMP,
 			   test_bit(ENTRY_TXD_REQ_TIMESTAMP, &desc->flags));
 	rt2x00_set_field32(&word, TXD_W0_RTS,
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index 0aedc46..c5a5c43 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -1203,7 +1203,7 @@ static void rt2500pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 	rt2x00_set_field32(&word, TXD_W0_MORE_FRAG,
 			   test_bit(ENTRY_TXD_MORE_FRAG, &desc->flags));
 	rt2x00_set_field32(&word, TXD_W0_ACK,
-			   !(control->flags & IEEE80211_TXCTL_NO_ACK));
+			   test_bit(ENTRY_TXD_ACK, &desc->flags));
 	rt2x00_set_field32(&word, TXD_W0_TIMESTAMP,
 			   test_bit(ENTRY_TXD_REQ_TIMESTAMP, &desc->flags));
 	rt2x00_set_field32(&word, TXD_W0_OFDM,
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index fdc6da5..43f1e0f 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -1058,7 +1058,7 @@ static void rt2500usb_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 	rt2x00_set_field32(&word, TXD_W0_MORE_FRAG,
 			   test_bit(ENTRY_TXD_MORE_FRAG, &desc->flags));
 	rt2x00_set_field32(&word, TXD_W0_ACK,
-			   !(control->flags & IEEE80211_TXCTL_NO_ACK));
+			   test_bit(ENTRY_TXD_ACK, &desc->flags));
 	rt2x00_set_field32(&word, TXD_W0_TIMESTAMP,
 			   test_bit(ENTRY_TXD_REQ_TIMESTAMP, &desc->flags));
 	rt2x00_set_field32(&word, TXD_W0_OFDM,
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 304830b..3ab1fb9 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -629,12 +629,21 @@ void rt2x00lib_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 	tx_rate = control->tx_rate;
 
 	/*
+	 * Check whether this frame is to be acked
+	 */
+	if (!(control->flags & IEEE80211_TXCTL_NO_ACK))
+		__set_bit(ENTRY_TXD_ACK, &desc.flags);
+
+	/*
 	 * Check if this is a RTS/CTS frame
 	 */
 	if (is_rts_frame(frame_control) || is_cts_frame(frame_control)) {
 		__set_bit(ENTRY_TXD_BURST, &desc.flags);
-		if (is_rts_frame(frame_control))
+		if (is_rts_frame(frame_control)) {
 			__set_bit(ENTRY_TXD_RTS_FRAME, &desc.flags);
+			__set_bit(ENTRY_TXD_ACK, &desc.flags);
+		} else
+			__clear_bit(ENTRY_TXD_ACK, &desc.flags);
 		if (control->rts_cts_rate)
 			tx_rate = control->rts_cts_rate;
 	}
diff --git a/drivers/net/wireless/rt2x00/rt2x00ring.h b/drivers/net/wireless/rt2x00/rt2x00ring.h
index ee6c423..5b871ad 100644
--- a/drivers/net/wireless/rt2x00/rt2x00ring.h
+++ b/drivers/net/wireless/rt2x00/rt2x00ring.h
@@ -52,6 +52,7 @@ struct txdata_entry_desc {
 #define ENTRY_TXD_MORE_FRAG	4
 #define ENTRY_TXD_REQ_TIMESTAMP	5
 #define ENTRY_TXD_BURST		6
+#define ENTRY_TXD_ACK		7
 
 /*
  * Queue ID. ID's 0-4 are data TX rings
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 37fe772..105dc86 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -1578,7 +1578,7 @@ static void rt61pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 	rt2x00_set_field32(&word, TXD_W0_MORE_FRAG,
 			   test_bit(ENTRY_TXD_MORE_FRAG, &desc->flags));
 	rt2x00_set_field32(&word, TXD_W0_ACK,
-			   !(control->flags & IEEE80211_TXCTL_NO_ACK));
+			   test_bit(ENTRY_TXD_ACK, &desc->flags));
 	rt2x00_set_field32(&word, TXD_W0_TIMESTAMP,
 			   test_bit(ENTRY_TXD_REQ_TIMESTAMP, &desc->flags));
 	rt2x00_set_field32(&word, TXD_W0_OFDM,
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index d1375b8..532e75d 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -1275,7 +1275,7 @@ static void rt73usb_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 	rt2x00_set_field32(&word, TXD_W0_MORE_FRAG,
 			   test_bit(ENTRY_TXD_MORE_FRAG, &desc->flags));
 	rt2x00_set_field32(&word, TXD_W0_ACK,
-			   !(control->flags & IEEE80211_TXCTL_NO_ACK));
+			   test_bit(ENTRY_TXD_ACK, &desc->flags));
 	rt2x00_set_field32(&word, TXD_W0_TIMESTAMP,
 			   test_bit(ENTRY_TXD_REQ_TIMESTAMP, &desc->flags));
 	rt2x00_set_field32(&word, TXD_W0_OFDM,
-- 
1.5.3.4

