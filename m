Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:50196 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761842Ab0HFSuC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Aug 2010 14:50:02 -0400
Received: by mail-ey0-f174.google.com with SMTP id 25so2902634eya.19
        for <linux-wireless@vger.kernel.org>; Fri, 06 Aug 2010 11:50:01 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 6/7] rt2x00: Update comments regarding TXWI and TX_STA_FIFO
Date: Fri, 6 Aug 2010 20:48:27 +0200
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
References: <201008062045.05288.IvDoorn@gmail.com> <201008062047.21710.IvDoorn@gmail.com> <201008062047.58607.IvDoorn@gmail.com>
In-Reply-To: <201008062047.58607.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201008062048.28764.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Helmut Schaa <helmut.schaa@googlemail.com>

Add some comments about the TXWI fields and the TX_STA_FIFO register.
Especially describe the relationship between the TXWI field PACKETID
and the PID field in the TX_STA_FIFO register.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800.h |   27 ++++++++++++++++++++++++++-
 1 files changed, 26 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
index ed4ebcd..cf1f16b 100644
--- a/drivers/net/wireless/rt2x00/rt2800.h
+++ b/drivers/net/wireless/rt2x00/rt2800.h
@@ -1318,7 +1318,25 @@
 #define TX_STA_CNT2_TX_UNDER_FLOW_COUNT	FIELD32(0xffff0000)
 
 /*
- * TX_STA_FIFO: TX Result for specific PID status fifo register
+ * TX_STA_FIFO: TX Result for specific PID status fifo register.
+ *
+ * This register is implemented as FIFO with 16 entries in the HW. Each
+ * register read fetches the next tx result. If the FIFO is full because
+ * it wasn't read fast enough after the according interrupt (TX_FIFO_STATUS)
+ * triggered, the hw seems to simply drop further tx results.
+ *
+ * VALID: 1: this tx result is valid
+ *        0: no valid tx result -> driver should stop reading
+ * PID_TYPE: The PID latched from the PID field in the TXWI, can be used
+ *           to match a frame with its tx result (even though the PID is
+ *           only 4 bits wide).
+ * TX_SUCCESS: Indicates tx success (1) or failure (0)
+ * TX_AGGRE: Indicates if the frame was part of an aggregate (1) or not (0)
+ * TX_ACK_REQUIRED: Indicates if the frame needed to get ack'ed (1) or not (0)
+ * WCID: The wireless client ID.
+ * MCS: The tx rate used during the last transmission of this frame, be it
+ *      successful or not.
+ * PHYMODE: The phymode used for the transmission.
  */
 #define TX_STA_FIFO			0x1718
 #define TX_STA_FIFO_VALID		FIELD32(0x00000001)
@@ -1945,6 +1963,13 @@ struct mac_iveiv_entry {
 
 /*
  * Word1
+ * ACK: 0: No Ack needed, 1: Ack needed
+ * NSEQ: 0: Don't assign hw sequence number, 1: Assign hw sequence number
+ * BW_WIN_SIZE: BA windows size of the recipient
+ * WIRELESS_CLI_ID: Client ID for WCID table access
+ * MPDU_TOTAL_BYTE_COUNT: Length of 802.11 frame
+ * PACKETID: Will be latched into the TX_STA_FIFO register once the according
+ *           frame was processed. 0: Don't report tx status for this frame.
  */
 #define TXWI_W1_ACK			FIELD32(0x00000001)
 #define TXWI_W1_NSEQ			FIELD32(0x00000002)
-- 
1.7.2

