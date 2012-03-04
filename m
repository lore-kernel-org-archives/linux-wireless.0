Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:11400 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755010Ab2CDUnB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Mar 2012 15:43:01 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 026/101] iwlwifi: move tid_to_ac to PCI-E
Date: Sun,  4 Mar 2012 11:28:40 -0800
Message-Id: <1330889395-533-27-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120304_214558_282371_BA48F086)
In-Reply-To: <1330889395-533-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1330889395-533-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Currently, queue mapping is handled in the
transport. This may change, but until then
the code for it can be close to where it's
used rather than in iwl-shared.h.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-shared.h        |   46 ----------------------
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c |   46 ++++++++++++++++++++++
 2 files changed, 46 insertions(+), 46 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index 2b9d21a..740a058 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -412,52 +412,6 @@ static inline bool iwl_have_debug_level(u32 level)
 	return iwlagn_mod_params.debug_level & level;
 }
 
-/*
- * mac80211 queues, ACs, hardware queues, FIFOs.
- *
- * Cf. http://wireless.kernel.org/en/developers/Documentation/mac80211/queues
- *
- * Mac80211 uses the following numbers, which we get as from it
- * by way of skb_get_queue_mapping(skb):
- *
- *	VO	0
- *	VI	1
- *	BE	2
- *	BK	3
- *
- *
- * Regular (not A-MPDU) frames are put into hardware queues corresponding
- * to the FIFOs, see comments in iwl-prph.h. Aggregated frames get their
- * own queue per aggregation session (RA/TID combination), such queues are
- * set up to map into FIFOs too, for which we need an AC->FIFO mapping. In
- * order to map frames to the right queue, we also need an AC->hw queue
- * mapping. This is implemented here.
- *
- * Due to the way hw queues are set up (by the hw specific modules like
- * iwl-4965.c, iwl-5000.c etc.), the AC->hw queue mapping is the identity
- * mapping.
- */
-
-static const u8 tid_to_ac[] = {
-	IEEE80211_AC_BE,
-	IEEE80211_AC_BK,
-	IEEE80211_AC_BK,
-	IEEE80211_AC_BE,
-	IEEE80211_AC_VI,
-	IEEE80211_AC_VI,
-	IEEE80211_AC_VO,
-	IEEE80211_AC_VO
-};
-
-static inline int get_ac_from_tid(u16 tid)
-{
-	if (likely(tid < ARRAY_SIZE(tid_to_ac)))
-		return tid_to_ac[tid];
-
-	/* no support for TIDs 8-15 yet */
-	return -EINVAL;
-}
-
 enum iwl_rxon_context_id {
 	IWL_RXON_CTX_BSS,
 	IWL_RXON_CTX_PAN,
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
index 0513b90..0164154 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
@@ -41,6 +41,43 @@
 #define IWL_TX_CRC_SIZE 4
 #define IWL_TX_DELIMITER_SIZE 4
 
+/*
+ * mac80211 queues, ACs, hardware queues, FIFOs.
+ *
+ * Cf. http://wireless.kernel.org/en/developers/Documentation/mac80211/queues
+ *
+ * Mac80211 uses the following numbers, which we get as from it
+ * by way of skb_get_queue_mapping(skb):
+ *
+ *	VO	0
+ *	VI	1
+ *	BE	2
+ *	BK	3
+ *
+ *
+ * Regular (not A-MPDU) frames are put into hardware queues corresponding
+ * to the FIFOs, see comments in iwl-prph.h. Aggregated frames get their
+ * own queue per aggregation session (RA/TID combination), such queues are
+ * set up to map into FIFOs too, for which we need an AC->FIFO mapping. In
+ * order to map frames to the right queue, we also need an AC->hw queue
+ * mapping. This is implemented here.
+ *
+ * Due to the way hw queues are set up (by the hw specific code), the AC->hw
+ * queue mapping is the identity mapping.
+ */
+
+static const u8 tid_to_ac[] = {
+	IEEE80211_AC_BE,
+	IEEE80211_AC_BK,
+	IEEE80211_AC_BK,
+	IEEE80211_AC_BE,
+	IEEE80211_AC_VI,
+	IEEE80211_AC_VI,
+	IEEE80211_AC_VO,
+	IEEE80211_AC_VO
+};
+
+
 /**
  * iwl_trans_txq_update_byte_cnt_tbl - Set up entry in Tx byte-count array
  */
@@ -442,6 +479,15 @@ void iwl_trans_tx_queue_set_status(struct iwl_trans *trans,
 			scd_retry ? "BA" : "AC/CMD", txq_id);
 }
 
+static inline int get_ac_from_tid(u16 tid)
+{
+	if (likely(tid < ARRAY_SIZE(tid_to_ac)))
+		return tid_to_ac[tid];
+
+	/* no support for TIDs 8-15 yet */
+	return -EINVAL;
+}
+
 static inline int get_fifo_from_tid(struct iwl_trans_pcie *trans_pcie,
 				    u8 ctx, u16 tid)
 {
-- 
1.7.0.4

