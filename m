Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:61538 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752396Ab0FFG4q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Jun 2010 02:56:46 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Daniel Halperin <dhalperi@cs.washington.edu>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 23/23] iwlwifi: fix wrapping when handling aggregated batches
Date: Sat,  5 Jun 2010 23:56:38 -0700
Message-Id: <1275807398-18184-24-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1275807398-18184-1-git-send-email-reinette.chatre@intel.com>
References: <1275807398-18184-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Daniel Halperin <dhalperi@cs.washington.edu>

Fairly complex code in iwlagn_tx_status_reply_tx handle the status reports for
aggregated packet batches sent by the NIC. This code aims to handle the case
where the NIC retransmits failed packets from a previous batch; the status
information for these packets can sometimes be inserted in the middle of a
batch and are actually not in order by sequence number! (I verified this can
happen with printk's in the function.)

The code in question adaptively identifies the "first" frame of the batch,
taking into account that it may not be the one corresponding to the first agg
status report, and also handles the case when the set of sent packets wraps the
256-character entry buffer. It generates the agg->bitmap field of sent packets
which is later compared to the BlockAck response from the receiver to see which
frames of those sent in this batch were ACKed. A small logic error (wrapping by
0xff==255 instead of 0x100==256) was causing the agg->bitmap to be set
incorrectly.

Fix this wrapping code, and add extensive comments to clarify what is going on.

Signed-off-by: Daniel Halperin <dhalperi@cs.washington.edu>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c |   51 ++++++++++++++++++++++++---
 1 files changed, 45 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index d339881..3577c1e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -93,6 +93,12 @@ static int iwlagn_tx_status_reply_tx(struct iwl_priv *priv,
 	} else {
 		/* Two or more frames were attempted; expect block-ack */
 		u64 bitmap = 0;
+
+		/*
+		 * Start is the lowest frame sent. It may not be the first
+		 * frame in the batch; we figure this out dynamically during
+		 * the following loop.
+		 */
 		int start = agg->start_idx;
 
 		/* Construct bit-map of pending frames within Tx window */
@@ -131,25 +137,58 @@ static int iwlagn_tx_status_reply_tx(struct iwl_priv *priv,
 			IWL_DEBUG_TX_REPLY(priv, "AGG Frame i=%d idx %d seq=%d\n",
 					   i, idx, SEQ_TO_SN(sc));
 
+			/*
+			 * sh -> how many frames ahead of the starting frame is
+			 * the current one?
+			 *
+			 * Note that all frames sent in the batch must be in a
+			 * 64-frame window, so this number should be in [0,63].
+			 * If outside of this window, then we've found a new
+			 * "first" frame in the batch and need to change start.
+			 */
 			sh = idx - start;
-			if (sh > 64) {
-				sh = (start - idx) + 0xff;
+
+			/*
+			 * If >= 64, out of window. start must be at the front
+			 * of the circular buffer, idx must be near the end of
+			 * the buffer, and idx is the new "first" frame. Shift
+			 * the indices around.
+			 */
+			if (sh >= 64) {
+				/* Shift bitmap by start - idx, wrapped */
+				sh = 0x100 - idx + start;
 				bitmap = bitmap << sh;
+				/* Now idx is the new start so sh = 0 */
 				sh = 0;
 				start = idx;
-			} else if (sh < -64)
-				sh  = 0xff - (start - idx);
-			else if (sh < 0) {
+			/*
+			 * If <= -64 then wraps the 256-pkt circular buffer
+			 * (e.g., start = 255 and idx = 0, sh should be 1)
+			 */
+			} else if (sh <= -64) {
+				sh  = 0x100 - start + idx;
+			/*
+			 * If < 0 but > -64, out of window. idx is before start
+			 * but not wrapped. Shift the indices around.
+			 */
+			} else if (sh < 0) {
+				/* Shift by how far start is ahead of idx */
 				sh = start - idx;
-				start = idx;
 				bitmap = bitmap << sh;
+				/* Now idx is the new start so sh = 0 */
+				start = idx;
 				sh = 0;
 			}
+			/* Sequence number start + sh was sent in this batch */
 			bitmap |= 1ULL << sh;
 			IWL_DEBUG_TX_REPLY(priv, "start=%d bitmap=0x%llx\n",
 					   start, (unsigned long long)bitmap);
 		}
 
+		/*
+		 * Store the bitmap and possibly the new start, if we wrapped
+		 * the buffer above
+		 */
 		agg->bitmap = bitmap;
 		agg->start_idx = start;
 		IWL_DEBUG_TX_REPLY(priv, "Frames %d start_idx=%d bitmap=0x%llx\n",
-- 
1.7.0.4

