Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:41899 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753549Ab1CYObi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Mar 2011 10:31:38 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Daniel Halperin <dhalperi@cs.washington.edu>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 06/12] iwlwifi: cleanup and bugfix tx aggregation code
Date: Fri, 25 Mar 2011 07:14:10 -0700
Message-Id: <1301062456-17249-7-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1301062456-17249-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1301062456-17249-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Daniel Halperin <dhalperi@cs.washington.edu>

Since the driver split, there's no need for no_agg_framecnt_info since
all devices have this set to false. Secondly, the compressed block ack
handling code was broken. Fix this.

(1) A shift less than zero simply implies that the buffer wrapped, this
is expected. Remove the incorrect comment.

(2) The (agg->frame_count > (64-sh)) condition can happen if the last
frame is dropped. E.g., if I send 7 frames and the 6th is received but
the 7th is lost, the other side may only shift the window 6, not 7
frames since the last bit is a 0. This is perfectly fine behavior and
doesn't invalidate the feedback.

(3) Store the feedback from a Compressed BA in the first newly received
frame, rather than the start of the window. This way it will get
processed by the rate selection code. Feedback stored in a non-received
frame is likely to get overwritten by the retransmission.
    This is based on the approach taken by minstrel_ht.

Signed-off-by: Daniel Halperin <dhalperi@cs.washington.edu>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c |   82 +++++++++-------------------
 drivers/net/wireless/iwlwifi/iwl-core.h   |    3 -
 2 files changed, 27 insertions(+), 58 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index fb63a03..cb8eacd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -1263,11 +1263,11 @@ static int iwlagn_tx_status_reply_compressed_ba(struct iwl_priv *priv,
 				 struct iwl_compressed_ba_resp *ba_resp)
 
 {
-	int i, sh, ack;
+	int sh;
 	u16 seq_ctl = le16_to_cpu(ba_resp->seq_ctl);
 	u16 scd_flow = le16_to_cpu(ba_resp->scd_flow);
-	int successes = 0;
 	struct ieee80211_tx_info *info;
+	u64 bitmap, sent_bitmap;
 
 	if (unlikely(!agg->wait_for_ba))  {
 		if (unlikely(ba_resp->bitmap))
@@ -1281,70 +1281,42 @@ static int iwlagn_tx_status_reply_compressed_ba(struct iwl_priv *priv,
 
 	/* Calculate shift to align block-ack bits with our Tx window bits */
 	sh = agg->start_idx - SEQ_TO_INDEX(seq_ctl >> 4);
-	if (sh < 0) /* tbw something is wrong with indices */
+	if (sh < 0)
 		sh += 0x100;
 
-	if (agg->frame_count > (64 - sh)) {
-		IWL_DEBUG_TX_REPLY(priv, "more frames than bitmap size");
-		return -1;
-	}
-	if (!priv->cfg->base_params->no_agg_framecnt_info && ba_resp->txed) {
+	/*
+	 * Check for success or failure according to the
+	 * transmitted bitmap and block-ack bitmap
+	 */
+	bitmap = le64_to_cpu(ba_resp->bitmap) >> sh;
+	sent_bitmap = bitmap & agg->bitmap;
+
+	/* Sanity check values reported by uCode */
+	if (ba_resp->txed_2_done > ba_resp->txed) {
+		IWL_DEBUG_TX_REPLY(priv,
+			"bogus sent(%d) and ack(%d) count\n",
+			ba_resp->txed, ba_resp->txed_2_done);
 		/*
-		 * sent and ack information provided by uCode
-		 * use it instead of figure out ourself
+		 * set txed_2_done = txed,
+		 * so it won't impact rate scale
 		 */
-		if (ba_resp->txed_2_done > ba_resp->txed) {
-			IWL_DEBUG_TX_REPLY(priv,
-				"bogus sent(%d) and ack(%d) count\n",
-				ba_resp->txed, ba_resp->txed_2_done);
-			/*
-			 * set txed_2_done = txed,
-			 * so it won't impact rate scale
-			 */
-			ba_resp->txed = ba_resp->txed_2_done;
-		}
-		IWL_DEBUG_HT(priv, "agg frames sent:%d, acked:%d\n",
-				ba_resp->txed, ba_resp->txed_2_done);
-	} else {
-		u64 bitmap, sent_bitmap;
-
-		/* don't use 64-bit values for now */
-		bitmap = le64_to_cpu(ba_resp->bitmap) >> sh;
-
-		/* check for success or failure according to the
-		 * transmitted bitmap and block-ack bitmap */
-		sent_bitmap = bitmap & agg->bitmap;
-
-		/* For each frame attempted in aggregation,
-		 * update driver's record of tx frame's status. */
-		i = 0;
-		while (sent_bitmap) {
-			ack = sent_bitmap & 1ULL;
-			successes += ack;
-			IWL_DEBUG_TX_REPLY(priv, "%s ON i=%d idx=%d raw=%d\n",
-				ack ? "ACK" : "NACK", i,
-				(agg->start_idx + i) & 0xff,
-				agg->start_idx + i);
-			sent_bitmap >>= 1;
-			++i;
-		}
+		ba_resp->txed = ba_resp->txed_2_done;
+	}
+	IWL_DEBUG_HT(priv, "agg frames sent:%d, acked:%d\n",
+			ba_resp->txed, ba_resp->txed_2_done);
 
-		IWL_DEBUG_TX_REPLY(priv, "Bitmap %llx\n",
-				   (unsigned long long)bitmap);
+	/* Find the first ACKed frame to store the TX status */
+	while (sent_bitmap && !(sent_bitmap & 1)) {
+		agg->start_idx = (agg->start_idx + 1) & 0xff;
+		sent_bitmap >>= 1;
 	}
 
 	info = IEEE80211_SKB_CB(priv->txq[scd_flow].txb[agg->start_idx].skb);
 	memset(&info->status, 0, sizeof(info->status));
 	info->flags |= IEEE80211_TX_STAT_ACK;
 	info->flags |= IEEE80211_TX_STAT_AMPDU;
-	if (!priv->cfg->base_params->no_agg_framecnt_info && ba_resp->txed) {
-		info->status.ampdu_ack_len = ba_resp->txed_2_done;
-		info->status.ampdu_len = ba_resp->txed;
-
-	} else {
-		info->status.ampdu_ack_len = successes;
-		info->status.ampdu_len = agg->frame_count;
-	}
+	info->status.ampdu_ack_len = ba_resp->txed_2_done;
+	info->status.ampdu_len = ba_resp->txed;
 	iwlagn_hwrate_to_tx_control(priv, agg->rate_n_flags, info);
 
 	return 0;
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 1f4f6dd..3e680af 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -281,8 +281,6 @@ struct iwl_mod_params {
  * @chain_noise_calib_by_driver: driver has the capability to perform
  *	chain noise calibration operation
  * @shadow_reg_enable: HW shadhow register bit
- * @no_agg_framecnt_info: uCode do not provide aggregation frame count
- *	information
  */
 struct iwl_base_params {
 	int eeprom_size;
@@ -312,7 +310,6 @@ struct iwl_base_params {
 	const bool sensitivity_calib_by_driver;
 	const bool chain_noise_calib_by_driver;
 	const bool shadow_reg_enable;
-	const bool no_agg_framecnt_info;
 };
 /*
  * @advanced_bt_coexist: support advanced bt coexist
-- 
1.7.0.4

