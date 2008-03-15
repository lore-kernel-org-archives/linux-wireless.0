Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.153]:53121 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752696AbYCOUjD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Mar 2008 16:39:03 -0400
Received: by fg-out-1718.google.com with SMTP id l27so857660fgb.17
        for <linux-wireless@vger.kernel.org>; Sat, 15 Mar 2008 13:38:59 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 1/2] rt2x00: Add dev_flags to rx descriptor
Date: Sat, 15 Mar 2008 21:38:07 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200803152137.51308.IvDoorn@gmail.com>
In-Reply-To: <200803152137.51308.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200803152138.07857.IvDoorn@gmail.com> (sfid-20080315_203919_820459_119CB749)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The rxdone_entry_desc structure contains 3 fields
which are always 1 or 0. We can safe 8 bytes by
replacing them with a single dev_flags fields which
contain the flags for those settings.

Additionally we can remove the OFDM flag since it
is no longer used since the introduction of the
SIGNAL_PLCP flag.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2400pci.c   |    7 ++++---
 drivers/net/wireless/rt2x00/rt2500pci.c   |    9 ++++++---
 drivers/net/wireless/rt2x00/rt2500usb.c   |    9 ++++++---
 drivers/net/wireless/rt2x00/rt2x00dev.c   |    8 +++++---
 drivers/net/wireless/rt2x00/rt2x00queue.h |   22 +++++++++++++++-------
 drivers/net/wireless/rt2x00/rt61pci.c     |    9 ++++++---
 drivers/net/wireless/rt2x00/rt73usb.c     |    9 ++++++---
 7 files changed, 48 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index 1f49561..c58b1c0 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -1076,12 +1076,13 @@ static void rt2400pci_fill_rxdone(struct queue_entry *entry,
 	 * of the preamble bit (0x08).
 	 */
 	rxdesc->signal = rt2x00_get_field32(word2, RXD_W2_SIGNAL) & ~0x08;
-	rxdesc->signal_plcp = 1;
 	rxdesc->rssi = rt2x00_get_field32(word2, RXD_W3_RSSI) -
 	    entry->queue->rt2x00dev->rssi_offset;
-	rxdesc->ofdm = 0;
 	rxdesc->size = rt2x00_get_field32(word0, RXD_W0_DATABYTE_COUNT);
-	rxdesc->my_bss = !!rt2x00_get_field32(word0, RXD_W0_MY_BSS);
+
+	rxdesc->dev_flags = RXDONE_SIGNAL_PLCP;
+	if (rt2x00_get_field32(word0, RXD_W0_MY_BSS))
+		rxdesc->dev_flags |= RXDONE_MY_BSS;
 }
 
 /*
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index 0f5139a..9468dde 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -1225,13 +1225,16 @@ static void rt2500pci_fill_rxdone(struct queue_entry *entry,
 	 * the signal is the PLCP value. If it was received with
 	 * a CCK bitrate the signal is the rate in 100kbit/s.
 	 */
-	rxdesc->ofdm = rt2x00_get_field32(word0, RXD_W0_OFDM);
 	rxdesc->signal = rt2x00_get_field32(word2, RXD_W2_SIGNAL);
-	rxdesc->signal_plcp = rxdesc->ofdm;
 	rxdesc->rssi = rt2x00_get_field32(word2, RXD_W2_RSSI) -
 	    entry->queue->rt2x00dev->rssi_offset;
 	rxdesc->size = rt2x00_get_field32(word0, RXD_W0_DATABYTE_COUNT);
-	rxdesc->my_bss = !!rt2x00_get_field32(word0, RXD_W0_MY_BSS);
+
+	rxdesc->dev_flags = 0;
+	if (rt2x00_get_field32(word0, RXD_W0_OFDM))
+		rxdesc->dev_flags |= RXDONE_SIGNAL_PLCP;
+	if (rt2x00_get_field32(word0, RXD_W0_MY_BSS))
+		rxdesc->dev_flags |= RXDONE_MY_BSS;
 }
 
 /*
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index c8216d7..8959a68 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -1139,13 +1139,16 @@ static void rt2500usb_fill_rxdone(struct queue_entry *entry,
 	 * the signal is the PLCP value. If it was received with
 	 * a CCK bitrate the signal is the rate in 100kbit/s.
 	 */
-	rxdesc->ofdm = rt2x00_get_field32(word0, RXD_W0_OFDM);
 	rxdesc->signal = rt2x00_get_field32(word1, RXD_W1_SIGNAL);
-	rxdesc->signal_plcp = rxdesc->ofdm;
 	rxdesc->rssi = rt2x00_get_field32(word1, RXD_W1_RSSI) -
 	    entry->queue->rt2x00dev->rssi_offset;
 	rxdesc->size = rt2x00_get_field32(word0, RXD_W0_DATABYTE_COUNT);
-	rxdesc->my_bss = !!rt2x00_get_field32(word0, RXD_W0_MY_BSS);
+
+	rxdesc->dev_flags = 0;
+	if (rt2x00_get_field32(word0, RXD_W0_OFDM))
+		rxdesc->dev_flags |= RXDONE_SIGNAL_PLCP;
+	if (rt2x00_get_field32(word0, RXD_W0_MY_BSS))
+		rxdesc->dev_flags |= RXDONE_MY_BSS;
 
 	/*
 	 * Adjust the skb memory window to the frame boundaries.
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index ff852c8..566f707 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -580,8 +580,10 @@ void rt2x00lib_rxdone(struct queue_entry *entry,
 	for (i = 0; i < sband->n_bitrates; i++) {
 		rate = rt2x00_get_rate(sband->bitrates[i].hw_value);
 
-		if ((rxdesc->signal_plcp && rate->plcp == rxdesc->signal) ||
-		    (!rxdesc->signal_plcp && rate->bitrate == rxdesc->signal)) {
+		if (((rxdesc->dev_flags & RXDONE_SIGNAL_PLCP) &&
+		     (rate->plcp == rxdesc->signal)) ||
+		    (!(rxdesc->dev_flags & RXDONE_SIGNAL_PLCP) &&
+		      (rate->bitrate == rxdesc->signal))) {
 			idx = i;
 			break;
 		}
@@ -592,7 +594,7 @@ void rt2x00lib_rxdone(struct queue_entry *entry,
 	 */
 	hdr = (struct ieee80211_hdr *)entry->skb->data;
 	fc = le16_to_cpu(hdr->frame_control);
-	if (is_beacon(fc) && rxdesc->my_bss)
+	if (is_beacon(fc) && (rxdesc->dev_flags & RXDONE_MY_BSS))
 		rt2x00lib_update_link_stats(&rt2x00dev->link, rxdesc->rssi);
 
 	rt2x00dev->link.qual.rx_success++;
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.h b/drivers/net/wireless/rt2x00/rt2x00queue.h
index c5f46f2..7027c9f 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.h
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.h
@@ -129,27 +129,35 @@ static inline struct skb_frame_desc* get_skb_frame_desc(struct sk_buff *skb)
 }
 
 /**
+ * enum rxdone_entry_desc_flags: Flags for &struct rxdone_entry_desc
+ *
+ * @RXDONE_SIGNAL_PLCP: Does the signal field contain the plcp value,
+ *	or does it contain the bitrate itself.
+ * @RXDONE_MY_BSS: Does this frame originate from device's BSS.
+ */
+enum rxdone_entry_desc_flags {
+	RXDONE_SIGNAL_PLCP = 1 << 0,
+	RXDONE_MY_BSS = 1 << 1,
+};
+
+/**
  * struct rxdone_entry_desc: RX Entry descriptor
  *
  * Summary of information that has been read from the RX frame descriptor.
  *
  * @signal: Signal of the received frame.
- * @signal_plcp: Does the signal field contain the plcp value,
- *	or does it contain the bitrate itself.
  * @rssi: RSSI of the received frame.
- * @ofdm: Was frame send with an OFDM rate.
  * @size: Data size of the received frame.
  * @flags: MAC80211 receive flags (See &enum mac80211_rx_flags).
- * @my_bss: Does this frame originate from device's BSS.
+ * @dev_flags: Ralink receive flags (See &enum rxdone_entry_desc_flags).
+
  */
 struct rxdone_entry_desc {
 	int signal;
-	int signal_plcp;
 	int rssi;
-	int ofdm;
 	int size;
 	int flags;
-	int my_bss;
+	int dev_flags;
 };
 
 /**
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index babb240..6e643c8 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -1649,12 +1649,15 @@ static void rt61pci_fill_rxdone(struct queue_entry *entry,
 	 * the signal is the PLCP value. If it was received with
 	 * a CCK bitrate the signal is the rate in 100kbit/s.
 	 */
-	rxdesc->ofdm = rt2x00_get_field32(word0, RXD_W0_OFDM);
 	rxdesc->signal = rt2x00_get_field32(word1, RXD_W1_SIGNAL);
-	rxdesc->signal_plcp = rxdesc->ofdm;
 	rxdesc->rssi = rt61pci_agc_to_rssi(entry->queue->rt2x00dev, word1);
 	rxdesc->size = rt2x00_get_field32(word0, RXD_W0_DATABYTE_COUNT);
-	rxdesc->my_bss = !!rt2x00_get_field32(word0, RXD_W0_MY_BSS);
+
+	rxdesc->dev_flags = 0;
+	if (rt2x00_get_field32(word0, RXD_W0_OFDM))
+		rxdesc->dev_flags |= RXDONE_SIGNAL_PLCP;
+	if (rt2x00_get_field32(word0, RXD_W0_MY_BSS))
+		rxdesc->dev_flags |= RXDONE_MY_BSS;
 }
 
 /*
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 46b040b..b50f476 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -1409,12 +1409,15 @@ static void rt73usb_fill_rxdone(struct queue_entry *entry,
 	 * the signal is the PLCP value. If it was received with
 	 * a CCK bitrate the signal is the rate in 100kbit/s.
 	 */
-	rxdesc->ofdm = rt2x00_get_field32(word0, RXD_W0_OFDM);
 	rxdesc->signal = rt2x00_get_field32(word1, RXD_W1_SIGNAL);
-	rxdesc->signal_plcp = rxdesc->ofdm;
 	rxdesc->rssi = rt73usb_agc_to_rssi(entry->queue->rt2x00dev, word1);
 	rxdesc->size = rt2x00_get_field32(word0, RXD_W0_DATABYTE_COUNT);
-	rxdesc->my_bss = !!rt2x00_get_field32(word0, RXD_W0_MY_BSS);
+
+	rxdesc->dev_flags = 0;
+	if (rt2x00_get_field32(word0, RXD_W0_OFDM))
+		rxdesc->dev_flags |= RXDONE_SIGNAL_PLCP;
+	if (rt2x00_get_field32(word0, RXD_W0_MY_BSS))
+		rxdesc->dev_flags |= RXDONE_MY_BSS;
 
 	/*
 	 * Adjust the skb memory window to the frame boundaries.
-- 
1.5.4.3

