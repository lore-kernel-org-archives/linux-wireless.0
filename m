Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.189]:59572 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753792AbYCIVvc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Mar 2008 17:51:32 -0400
Received: by fk-out-0910.google.com with SMTP id z23so1362518fkz.5
        for <linux-wireless@vger.kernel.org>; Sun, 09 Mar 2008 14:51:31 -0700 (PDT)
To: "John W. Linville" <linville@redhat.com>
Subject: [PATCH 23/24] rt2x00: Fix rt2400pci signal
Date: Sun, 9 Mar 2008 22:49:04 +0100
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	rt2400-devel@lists.sourceforge.net
References: <200803092237.43451.IvDoorn@gmail.com>
In-Reply-To: <200803092237.43451.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200803092249.04284.IvDoorn@gmail.com> (sfid-20080309_215432_457257_994FC99D)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After sampling hundreds of RX frame descriptors,
the results were conclusive:
- The Ralink documentation regarding the SIGNAL and RSSI are wrong.

It turns out that of the 5 BBR registers, we should not use BBR0 and BBR1
for SIGNAL and RSSI respectively, but actually BBR1 and BBR2.
BBR0 does show values, but the exact meaning remains unclear,
but they cannot be translated into a SIGNAL or RSSI field.
BBR3, BBR4 and BBR5 are always 0, so their meaning is unknown.

As it turns out, the reported SIGNAL is the PLCP value, this
in contradiction to what was expected looking at rt2500pci which
only reported the PLCP values for OFDM rates and bitrate values
for CCK rates.

This means we should let the driver raise the flag about the contents
of the SIGNAL field so rt2x00lib can always do the right thing based
on what the driver reports.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2400pci.c   |    6 +++++-
 drivers/net/wireless/rt2x00/rt2400pci.h   |    6 +++---
 drivers/net/wireless/rt2x00/rt2500pci.c   |    9 ++++++++-
 drivers/net/wireless/rt2x00/rt2500usb.c   |    6 +++++-
 drivers/net/wireless/rt2x00/rt2x00dev.c   |   16 +++++++++-------
 drivers/net/wireless/rt2x00/rt2x00queue.h |    3 +++
 drivers/net/wireless/rt2x00/rt61pci.c     |    6 +++++-
 drivers/net/wireless/rt2x00/rt73usb.c     |    6 +++++-
 8 files changed, 43 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index a92626b..4cd2842 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -1058,9 +1058,11 @@ static void rt2400pci_fill_rxdone(struct queue_entry *entry,
 	struct queue_entry_priv_pci_rx *priv_rx = entry->priv_data;
 	u32 word0;
 	u32 word2;
+	u32 word3;
 
 	rt2x00_desc_read(priv_rx->desc, 0, &word0);
 	rt2x00_desc_read(priv_rx->desc, 2, &word2);
+	rt2x00_desc_read(priv_rx->desc, 3, &word3);
 
 	rxdesc->flags = 0;
 	if (rt2x00_get_field32(word0, RXD_W0_CRC_ERROR))
@@ -1070,9 +1072,11 @@ static void rt2400pci_fill_rxdone(struct queue_entry *entry,
 
 	/*
 	 * Obtain the status about this packet.
+	 * The signal is the PLCP value.
 	 */
 	rxdesc->signal = rt2x00_get_field32(word2, RXD_W2_SIGNAL);
-	rxdesc->rssi = rt2x00_get_field32(word2, RXD_W2_RSSI) -
+	rxdesc->signal_plcp = 1;
+	rxdesc->rssi = rt2x00_get_field32(word2, RXD_W3_RSSI) -
 	    entry->queue->rt2x00dev->rssi_offset;
 	rxdesc->ofdm = 0;
 	rxdesc->size = rt2x00_get_field32(word0, RXD_W0_DATABYTE_COUNT);
diff --git a/drivers/net/wireless/rt2x00/rt2400pci.h b/drivers/net/wireless/rt2x00/rt2400pci.h
index da178d4..a5210f9 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.h
+++ b/drivers/net/wireless/rt2x00/rt2400pci.h
@@ -899,13 +899,13 @@
  * Word2
  */
 #define RXD_W2_BUFFER_LENGTH		FIELD32(0x0000ffff)
-#define RXD_W2_SIGNAL			FIELD32(0x00ff0000)
-#define RXD_W2_RSSI			FIELD32(0xff000000)
+#define RXD_W2_BBR0			FIELD32(0x00ff0000)
+#define RXD_W2_SIGNAL			FIELD32(0xff000000)
 
 /*
  * Word3
  */
-#define RXD_W3_BBR2			FIELD32(0x000000ff)
+#define RXD_W3_RSSI			FIELD32(0x000000ff)
 #define RXD_W3_BBR3			FIELD32(0x0000ff00)
 #define RXD_W3_BBR4			FIELD32(0x00ff0000)
 #define RXD_W3_BBR5			FIELD32(0xff000000)
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index 4ae09b4..0f5139a 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -1219,10 +1219,17 @@ static void rt2500pci_fill_rxdone(struct queue_entry *entry,
 	if (rt2x00_get_field32(word0, RXD_W0_PHYSICAL_ERROR))
 		rxdesc->flags |= RX_FLAG_FAILED_PLCP_CRC;
 
+	/*
+	 * Obtain the status about this packet.
+	 * When frame was received with an OFDM bitrate,
+	 * the signal is the PLCP value. If it was received with
+	 * a CCK bitrate the signal is the rate in 100kbit/s.
+	 */
+	rxdesc->ofdm = rt2x00_get_field32(word0, RXD_W0_OFDM);
 	rxdesc->signal = rt2x00_get_field32(word2, RXD_W2_SIGNAL);
+	rxdesc->signal_plcp = rxdesc->ofdm;
 	rxdesc->rssi = rt2x00_get_field32(word2, RXD_W2_RSSI) -
 	    entry->queue->rt2x00dev->rssi_offset;
-	rxdesc->ofdm = rt2x00_get_field32(word0, RXD_W0_OFDM);
 	rxdesc->size = rt2x00_get_field32(word0, RXD_W0_DATABYTE_COUNT);
 	rxdesc->my_bss = !!rt2x00_get_field32(word0, RXD_W0_MY_BSS);
 }
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 8dfebfd..c8216d7 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -1135,11 +1135,15 @@ static void rt2500usb_fill_rxdone(struct queue_entry *entry,
 
 	/*
 	 * Obtain the status about this packet.
+	 * When frame was received with an OFDM bitrate,
+	 * the signal is the PLCP value. If it was received with
+	 * a CCK bitrate the signal is the rate in 100kbit/s.
 	 */
+	rxdesc->ofdm = rt2x00_get_field32(word0, RXD_W0_OFDM);
 	rxdesc->signal = rt2x00_get_field32(word1, RXD_W1_SIGNAL);
+	rxdesc->signal_plcp = rxdesc->ofdm;
 	rxdesc->rssi = rt2x00_get_field32(word1, RXD_W1_RSSI) -
 	    entry->queue->rt2x00dev->rssi_offset;
-	rxdesc->ofdm = rt2x00_get_field32(word0, RXD_W0_OFDM);
 	rxdesc->size = rt2x00_get_field32(word0, RXD_W0_DATABYTE_COUNT);
 	rxdesc->my_bss = !!rt2x00_get_field32(word0, RXD_W0_MY_BSS);
 
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 18abf65..76e5dac 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -574,19 +574,21 @@ void rt2x00lib_rxdone(struct queue_entry *entry,
 	u16 fc;
 
 	/*
+	 * If the signal is the plcp value,
+	 * we need to strip the preamble bit (0x08).
+	 */
+	if (rxdesc->signal_plcp)
+		rxdesc->signal &= ~0x08;
+
+	/*
 	 * Update RX statistics.
 	 */
 	sband = &rt2x00dev->bands[rt2x00dev->curr_band];
 	for (i = 0; i < sband->n_bitrates; i++) {
 		rate = rt2x00_get_rate(sband->bitrates[i].hw_value);
 
-		/*
-		 * When frame was received with an OFDM bitrate,
-		 * the signal is the PLCP value. If it was received with
-		 * a CCK bitrate the signal is the rate in 100kbit/s.
-		 */
-		if ((rxdesc->ofdm && rate->plcp == rxdesc->signal) ||
-		    (!rxdesc->ofdm && rate->bitrate == rxdesc->signal)) {
+		if ((rxdesc->signal_plcp && rate->plcp == rxdesc->signal) ||
+		    (!rxdesc->signal_plcp && rate->bitrate == rxdesc->signal)) {
 			idx = i;
 			break;
 		}
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.h b/drivers/net/wireless/rt2x00/rt2x00queue.h
index fbabf38..c5f46f2 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.h
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.h
@@ -134,6 +134,8 @@ static inline struct skb_frame_desc* get_skb_frame_desc(struct sk_buff *skb)
  * Summary of information that has been read from the RX frame descriptor.
  *
  * @signal: Signal of the received frame.
+ * @signal_plcp: Does the signal field contain the plcp value,
+ *	or does it contain the bitrate itself.
  * @rssi: RSSI of the received frame.
  * @ofdm: Was frame send with an OFDM rate.
  * @size: Data size of the received frame.
@@ -142,6 +144,7 @@ static inline struct skb_frame_desc* get_skb_frame_desc(struct sk_buff *skb)
  */
 struct rxdone_entry_desc {
 	int signal;
+	int signal_plcp;
 	int rssi;
 	int ofdm;
 	int size;
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index d11d3e5..babb240 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -1645,10 +1645,14 @@ static void rt61pci_fill_rxdone(struct queue_entry *entry,
 
 	/*
 	 * Obtain the status about this packet.
+	 * When frame was received with an OFDM bitrate,
+	 * the signal is the PLCP value. If it was received with
+	 * a CCK bitrate the signal is the rate in 100kbit/s.
 	 */
+	rxdesc->ofdm = rt2x00_get_field32(word0, RXD_W0_OFDM);
 	rxdesc->signal = rt2x00_get_field32(word1, RXD_W1_SIGNAL);
+	rxdesc->signal_plcp = rxdesc->ofdm;
 	rxdesc->rssi = rt61pci_agc_to_rssi(entry->queue->rt2x00dev, word1);
-	rxdesc->ofdm = rt2x00_get_field32(word0, RXD_W0_OFDM);
 	rxdesc->size = rt2x00_get_field32(word0, RXD_W0_DATABYTE_COUNT);
 	rxdesc->my_bss = !!rt2x00_get_field32(word0, RXD_W0_MY_BSS);
 }
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 03a72ce..46b040b 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -1405,10 +1405,14 @@ static void rt73usb_fill_rxdone(struct queue_entry *entry,
 
 	/*
 	 * Obtain the status about this packet.
+	 * When frame was received with an OFDM bitrate,
+	 * the signal is the PLCP value. If it was received with
+	 * a CCK bitrate the signal is the rate in 100kbit/s.
 	 */
+	rxdesc->ofdm = rt2x00_get_field32(word0, RXD_W0_OFDM);
 	rxdesc->signal = rt2x00_get_field32(word1, RXD_W1_SIGNAL);
+	rxdesc->signal_plcp = rxdesc->ofdm;
 	rxdesc->rssi = rt73usb_agc_to_rssi(entry->queue->rt2x00dev, word1);
-	rxdesc->ofdm = rt2x00_get_field32(word0, RXD_W0_OFDM);
 	rxdesc->size = rt2x00_get_field32(word0, RXD_W0_DATABYTE_COUNT);
 	rxdesc->my_bss = !!rt2x00_get_field32(word0, RXD_W0_MY_BSS);
 
-- 
1.5.4.3

