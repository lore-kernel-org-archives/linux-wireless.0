Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ik-out-1112.google.com ([66.249.90.176]:41504 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752488AbYGDLiQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Jul 2008 07:38:16 -0400
Received: by ik-out-1112.google.com with SMTP id c28so563300ika.5
        for <linux-wireless@vger.kernel.org>; Fri, 04 Jul 2008 04:38:15 -0700 (PDT)
To: linville@tuxdriver.com
Subject: [PATCH 4/4] rt2x00: Report RX end time for rt2400pci
Date: Fri, 4 Jul 2008 13:41:57 +0200
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	rt2400-devel@lists.sourceforge.net
References: <200807041340.28103.IvDoorn@gmail.com> <200807041340.53147.IvDoorn@gmail.com> <200807041341.31830.IvDoorn@gmail.com>
In-Reply-To: <200807041341.31830.IvDoorn@gmail.com>
MIME-Version: 1.0
Message-Id: <200807041341.57998.IvDoorn@gmail.com> (sfid-20080704_133819_349513_2A0E44DE)
Content-Type: text/plain;
  charset="utf-8"
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rt2400 is the only currently available rt2x00 driver which
supports reporting of the RX end time for frames.
Since mac80211 uses this information for IBSS syncing, it
is important that it is being reported.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index b3dffcf..54e2f1e 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -1091,10 +1091,12 @@ static void rt2400pci_fill_rxdone(struct queue_entry *entry,
 	u32 word0;
 	u32 word2;
 	u32 word3;
+	u32 word4;
 
 	rt2x00_desc_read(entry_priv->desc, 0, &word0);
 	rt2x00_desc_read(entry_priv->desc, 2, &word2);
 	rt2x00_desc_read(entry_priv->desc, 3, &word3);
+	rt2x00_desc_read(entry_priv->desc, 4, &word4);
 
 	if (rt2x00_get_field32(word0, RXD_W0_CRC_ERROR))
 		rxdesc->flags |= RX_FLAG_FAILED_FCS_CRC;
@@ -1106,6 +1108,7 @@ static void rt2400pci_fill_rxdone(struct queue_entry *entry,
 	 * The signal is the PLCP value, and needs to be stripped
 	 * of the preamble bit (0x08).
 	 */
+	rxdesc->timestamp = rt2x00_get_field32(word4, RXD_W4_RX_END_TIME);
 	rxdesc->signal = rt2x00_get_field32(word2, RXD_W2_SIGNAL) & ~0x08;
 	rxdesc->rssi = rt2x00_get_field32(word2, RXD_W3_RSSI) -
 	    entry->queue->rt2x00dev->rssi_offset;
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 8086263..b48c04e 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -664,6 +664,7 @@ void rt2x00lib_rxdone(struct rt2x00_dev *rt2x00dev,
 
 	rt2x00dev->link.qual.rx_success++;
 
+	rx_status->mactime = rxdesc.timestamp;
 	rx_status->rate_idx = idx;
 	rx_status->qual =
 	    rt2x00lib_calculate_link_signal(rt2x00dev, rxdesc.rssi);
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.h b/drivers/net/wireless/rt2x00/rt2x00queue.h
index 5dd9cca..8945945 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.h
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.h
@@ -146,6 +146,7 @@ enum rxdone_entry_desc_flags {
  *
  * Summary of information that has been read from the RX frame descriptor.
  *
+ * @timestamp: RX Timestamp
  * @signal: Signal of the received frame.
  * @rssi: RSSI of the received frame.
  * @size: Data size of the received frame.
@@ -154,6 +155,7 @@ enum rxdone_entry_desc_flags {
 
  */
 struct rxdone_entry_desc {
+	u64 timestamp;
 	int signal;
 	int rssi;
 	int size;
