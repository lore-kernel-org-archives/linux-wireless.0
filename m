Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:17575 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752590Ab0FFG4p (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Jun 2010 02:56:45 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Daniel Halperin <dhalperi@cs.washington.edu>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 22/23] iwlwifi: parse block ack responses correctly
Date: Sat,  5 Jun 2010 23:56:37 -0700
Message-Id: <1275807398-18184-23-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1275807398-18184-1-git-send-email-reinette.chatre@intel.com>
References: <1275807398-18184-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Daniel Halperin <dhalperi@cs.washington.edu>

Compressed BlockAck frames store the ACKs/NACKs in a 64-bit bitmap that starts
at the sequence number of the first frame sent in the aggregated batch. Note
that this is a selective ACKnowledgement following selective retransmission;
e.g., if frames 1,4-5 in a batch are ACKed then the next transmission will
include frames 2-3,6-10 (7 frames). In this latter case, the Compressed
BlockAck will not have all meaningful information in the low order bits -- the
semantically meaningful bits of the BA will be 0x1f3 (where the low-order frame
is seq 2).

The driver code originally just looked at the lower (in this case, 7) bits of
the BlockAck. In this case, the lower 7 bits of 0x1f3 => only 5 packets,
maximum, could ever be ACKed. In reality it should be looking at all of the
bits, filtered by those corresponding to packets that were actually sent. This
flaw meant that the number of correctly ACked packets could be significantly
underreported and might result in asynchronous state between TX and RX sides as
well as driver and uCode.

Fix this and also add a shortcut that doesn't require the code to loop through
all 64 bits of the bitmap but rather stops when no higher packets are ACKed.

In my experiments this fix greatly reduces throughput swing, making throughput
stable and high. It is also likely related to some of the stalls observed in
aggregation mode and maybe some of the buffer underruns observed, e.g.,

http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=1968
http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2098
http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2018

Signed-off-by: Daniel Halperin <dhalperi@cs.washington.edu>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index 0d3e13b..10a0acd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -1208,7 +1208,7 @@ static int iwlagn_tx_status_reply_compressed_ba(struct iwl_priv *priv,
 	int i, sh, ack;
 	u16 seq_ctl = le16_to_cpu(ba_resp->seq_ctl);
 	u16 scd_flow = le16_to_cpu(ba_resp->scd_flow);
-	u64 bitmap;
+	u64 bitmap, sent_bitmap;
 	int successes = 0;
 	struct ieee80211_tx_info *info;
 
@@ -1236,16 +1236,19 @@ static int iwlagn_tx_status_reply_compressed_ba(struct iwl_priv *priv,
 
 	/* check for success or failure according to the
 	 * transmitted bitmap and block-ack bitmap */
-	bitmap &= agg->bitmap;
+	sent_bitmap = bitmap & agg->bitmap;
 
 	/* For each frame attempted in aggregation,
 	 * update driver's record of tx frame's status. */
-	for (i = 0; i < agg->frame_count ; i++) {
-		ack = bitmap & (1ULL << i);
-		successes += !!ack;
+	i = 0;
+	while (sent_bitmap) {
+		ack = sent_bitmap & 1ULL;
+		successes += ack;
 		IWL_DEBUG_TX_REPLY(priv, "%s ON i=%d idx=%d raw=%d\n",
 			ack ? "ACK" : "NACK", i, (agg->start_idx + i) & 0xff,
 			agg->start_idx + i);
+		sent_bitmap >>= 1;
+		++i;
 	}
 
 	info = IEEE80211_SKB_CB(priv->txq[scd_flow].txb[agg->start_idx].skb);
-- 
1.7.0.4

