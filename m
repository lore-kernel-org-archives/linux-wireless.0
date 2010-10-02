Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:41875 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753980Ab0JBJfi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Oct 2010 05:35:38 -0400
Received: by mail-wy0-f174.google.com with SMTP id 28so3658555wyb.19
        for <linux-wireless@vger.kernel.org>; Sat, 02 Oct 2010 02:35:38 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 15/20] rt2x00: Improve TX status entry validation
Date: Sat, 2 Oct 2010 11:32:43 +0200
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
	Helmut Schaa <helmut.schaa@googlemail.com>
References: <201010021126.18748.IvDoorn@gmail.com> <201010021131.56454.IvDoorn@gmail.com> <201010021132.17888.IvDoorn@gmail.com>
In-Reply-To: <201010021132.17888.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201010021132.44146.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ivo van Doorn <IvDoorn@gmail.com>

The TX_STA_FIFO contains some information for identifying
a outgoing frame, however matching by WCID and ACK status is
not sufficient to 100% identify the macthing queue_entry structure
(containing the SKB buffer) which belongs to the status report.

Within TX_STA_FIFO we have a 4-bit field named PACKETID, which is
currently used to encode the queue id. The queue ID is however
limited to values from 0 to 3, which means 2 bits are sufficient
to encode the value. With the remaining 2 bits we can encode a
partial queue_entry index number. The value of PACKETID is not
allowed to become 0, with the queue ID ranging from 0 to 3, at least
one of the bits for the entry identification must be 1.

That leaves us with 3 possible values we can still encode in the
bits. Altough this doesn't allow 100% accurate matching of the
TX_STA_FIFO queue to a queue_entry structure, it at least improves
the accuracy. This allows us to better detect if we have missed the
TX_STA_FIFO report, which in turn reduces the number of watchdog
warnings regarding the TX status timeout.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800.h    |   14 +++++++++++++-
 drivers/net/wireless/rt2x00/rt2800lib.c |    5 +++--
 2 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
index 4930d29..2a9f402 100644
--- a/drivers/net/wireless/rt2x00/rt2800.h
+++ b/drivers/net/wireless/rt2x00/rt2800.h
@@ -1,5 +1,6 @@
 /*
-	Copyright (C) 2004 - 2009 Ivo van Doorn <IvDoorn@gmail.com>
+	Copyright (C) 2004 - 2010 Ivo van Doorn <IvDoorn@gmail.com>
+	Copyright (C) 2010 Willow Garage <http://www.willowgarage.com>
 	Copyright (C) 2009 Alban Browaeys <prahal@yahoo.com>
 	Copyright (C) 2009 Felix Fietkau <nbd@openwrt.org>
 	Copyright (C) 2009 Luis Correia <luis.f.correia@gmail.com>
@@ -1353,6 +1354,9 @@
  * PID_TYPE: The PID latched from the PID field in the TXWI, can be used
  *           to match a frame with its tx result (even though the PID is
  *           only 4 bits wide).
+ * PID_QUEUE: Part of PID_TYPE, this is the queue index number (0-3)
+ * PID_ENTRY: Part of PID_TYPE, this is the queue entry index number (1-3)
+ *            This identification number is calculated by ((idx % 3) + 1).
  * TX_SUCCESS: Indicates tx success (1) or failure (0)
  * TX_AGGRE: Indicates if the frame was part of an aggregate (1) or not (0)
  * TX_ACK_REQUIRED: Indicates if the frame needed to get ack'ed (1) or not (0)
@@ -1364,6 +1368,8 @@
 #define TX_STA_FIFO			0x1718
 #define TX_STA_FIFO_VALID		FIELD32(0x00000001)
 #define TX_STA_FIFO_PID_TYPE		FIELD32(0x0000001e)
+#define TX_STA_FIFO_PID_QUEUE		FIELD32(0x00000006)
+#define TX_STA_FIFO_PID_ENTRY		FIELD32(0x00000018)
 #define TX_STA_FIFO_TX_SUCCESS		FIELD32(0x00000020)
 #define TX_STA_FIFO_TX_AGGRE		FIELD32(0x00000040)
 #define TX_STA_FIFO_TX_ACK_REQUIRED	FIELD32(0x00000080)
@@ -2024,6 +2030,10 @@ struct mac_iveiv_entry {
  *           frame was processed. If multiple frames are aggregated together
  *           (AMPDU==1) the reported tx status will always contain the packet
  *           id of the first frame. 0: Don't report tx status for this frame.
+ * PACKETID_QUEUE: Part of PACKETID, This is the queue index (0-3)
+ * PACKETID_ENTRY: Part of PACKETID, THis is the queue entry index (1-3)
+ *                 This identification number is calculated by ((idx % 3) + 1).
+ *		   The (+1) is required to prevent PACKETID to become 0.
  */
 #define TXWI_W1_ACK			FIELD32(0x00000001)
 #define TXWI_W1_NSEQ			FIELD32(0x00000002)
@@ -2031,6 +2041,8 @@ struct mac_iveiv_entry {
 #define TXWI_W1_WIRELESS_CLI_ID		FIELD32(0x0000ff00)
 #define TXWI_W1_MPDU_TOTAL_BYTE_COUNT	FIELD32(0x0fff0000)
 #define TXWI_W1_PACKETID		FIELD32(0xf0000000)
+#define TXWI_W1_PACKETID_QUEUE		FIELD32(0x30000000)
+#define TXWI_W1_PACKETID_ENTRY		FIELD32(0xc0000000)
 
 /*
  * Word2
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 403e2ed..8e507d0 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -483,7 +483,8 @@ void rt2800_write_tx_data(struct queue_entry *entry,
 			   txdesc->key_idx : 0xff);
 	rt2x00_set_field32(&word, TXWI_W1_MPDU_TOTAL_BYTE_COUNT,
 			   txdesc->length);
-	rt2x00_set_field32(&word, TXWI_W1_PACKETID, txdesc->qid + 1);
+	rt2x00_set_field32(&word, TXWI_W1_PACKETID_QUEUE, txdesc->qid);
+	rt2x00_set_field32(&word, TXWI_W1_PACKETID_ENTRY, (entry->entry_idx % 3) + 1);
 	rt2x00_desc_write(txwi, 1, word);
 
 	/*
@@ -708,7 +709,7 @@ void rt2800_txdone(struct rt2x00_dev *rt2x00dev)
 		 * Skip this entry when it contains an invalid
 		 * queue identication number.
 		 */
-		pid = rt2x00_get_field32(reg, TX_STA_FIFO_PID_TYPE) - 1;
+		pid = rt2x00_get_field32(reg, TX_STA_FIFO_PID_QUEUE);
 		if (pid >= QID_RX)
 			continue;
 
-- 
1.7.2.3

