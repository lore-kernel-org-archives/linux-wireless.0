Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.226]:23530 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753543AbYFNSnY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Jun 2008 14:43:24 -0400
Received: by wr-out-0506.google.com with SMTP id 69so2687394wri.5
        for <linux-wireless@vger.kernel.org>; Sat, 14 Jun 2008 11:43:22 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] rt2x00: Use ieee80211 fc handlers
Date: Sat, 14 Jun 2008 20:57:10 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200806142057.10520.IvDoorn@gmail.com> (sfid-20080614_204328_004290_CD99458B)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With the introduction of the ieee80211 fc handlers
we can now remove the rt2x00.h versions to use the
global versions.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00.h      |   27 ---------------------------
 drivers/net/wireless/rt2x00/rt2x00dev.c   |    5 ++---
 drivers/net/wireless/rt2x00/rt2x00queue.c |   14 +++++---------
 3 files changed, 7 insertions(+), 39 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 0da8f97..21fd9b4 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -111,33 +111,6 @@
 #define EIFS			( SIFS + (8 * (IEEE80211_HEADER + ACK_SIZE)) )
 
 /*
- * IEEE802.11 header defines
- */
-static inline int is_rts_frame(u16 fc)
-{
-	return (((fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_CTL) &&
-		((fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_RTS));
-}
-
-static inline int is_cts_frame(u16 fc)
-{
-	return (((fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_CTL) &&
-		((fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_CTS));
-}
-
-static inline int is_probe_resp(u16 fc)
-{
-	return (((fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_MGMT) &&
-		((fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_PROBE_RESP));
-}
-
-static inline int is_beacon(u16 fc)
-{
-	return (((fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_MGMT) &&
-		((fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_BEACON));
-}
-
-/*
  * Chipset identification
  * The chipset on the device is composed of a RT and RF chip.
  * The chipset combination is important for determining device capabilities.
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 9ea6773..f9e7531 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -561,7 +561,6 @@ void rt2x00lib_rxdone(struct queue_entry *entry,
 	unsigned int align;
 	unsigned int i;
 	int idx = -1;
-	u16 fc;
 
 	/*
 	 * The data behind the ieee80211 header must be
@@ -606,8 +605,8 @@ void rt2x00lib_rxdone(struct queue_entry *entry,
 	 * Only update link status if this is a beacon frame carrying our bssid.
 	 */
 	hdr = (struct ieee80211_hdr *)entry->skb->data;
-	fc = le16_to_cpu(hdr->frame_control);
-	if (is_beacon(fc) && (rxdesc->dev_flags & RXDONE_MY_BSS))
+	if (ieee80211_is_beacon(hdr->frame_control) &&
+	    (rxdesc->dev_flags & RXDONE_MY_BSS))
 		rt2x00lib_update_link_stats(&rt2x00dev->link, rxdesc->rssi);
 
 	rt2x00dev->link.qual.rx_success++;
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index 7b52039..15660b5 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -80,7 +80,6 @@ void rt2x00queue_create_tx_descriptor(struct queue_entry *entry,
 	unsigned int data_length;
 	unsigned int duration;
 	unsigned int residual;
-	u16 frame_control;
 
 	memset(txdesc, 0, sizeof(*txdesc));
 
@@ -96,11 +95,6 @@ void rt2x00queue_create_tx_descriptor(struct queue_entry *entry,
 	data_length = entry->skb->len + 4;
 
 	/*
-	 * Read required fields from ieee80211 header.
-	 */
-	frame_control = le16_to_cpu(hdr->frame_control);
-
-	/*
 	 * Check whether this frame is to be acked.
 	 */
 	if (!(tx_info->flags & IEEE80211_TX_CTL_NO_ACK))
@@ -109,9 +103,10 @@ void rt2x00queue_create_tx_descriptor(struct queue_entry *entry,
 	/*
 	 * Check if this is a RTS/CTS frame
 	 */
-	if (is_rts_frame(frame_control) || is_cts_frame(frame_control)) {
+	if (ieee80211_is_rts(hdr->frame_control) ||
+	    ieee80211_is_cts(hdr->frame_control)) {
 		__set_bit(ENTRY_TXD_BURST, &txdesc->flags);
-		if (is_rts_frame(frame_control))
+		if (ieee80211_is_rts(hdr->frame_control))
 			__set_bit(ENTRY_TXD_RTS_FRAME, &txdesc->flags);
 		else
 			__set_bit(ENTRY_TXD_CTS_FRAME, &txdesc->flags);
@@ -139,7 +134,8 @@ void rt2x00queue_create_tx_descriptor(struct queue_entry *entry,
 	 * Beacons and probe responses require the tsf timestamp
 	 * to be inserted into the frame.
 	 */
-	if (txdesc->queue == QID_BEACON || is_probe_resp(frame_control))
+	if (ieee80211_is_beacon(hdr->frame_control) ||
+	    ieee80211_is_probe_resp(hdr->frame_control))
 		__set_bit(ENTRY_TXD_REQ_TIMESTAMP, &txdesc->flags);
 
 	/*
-- 
1.5.5.4

