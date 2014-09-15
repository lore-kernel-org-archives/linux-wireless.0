Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:36782 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbaIOFNT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2014 01:13:19 -0400
Received: by mail-wg0-f42.google.com with SMTP id x12so3250063wgg.25
        for <linux-wireless@vger.kernel.org>; Sun, 14 Sep 2014 22:13:18 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eyal Shapira <eyal@wizery.com>,
	Eyal Shapira <eyalx.shapira@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 09/28] iwlwifi: mvm: rs: don't zero tx stats after idle
Date: Mon, 15 Sep 2014 08:12:41 +0300
Message-Id: <1410757980-2138-9-git-send-email-egrumbach@gmail.com> (sfid-20140915_073116_470424_66B66B17)
In-Reply-To: <5416742C.3070804@gmail.com>
References: <5416742C.3070804@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

Move the tx stats to the persistent area of lq_sta to
avoid them being zeroed out every time rs reinitializes
which happens after tx idle for 5 secs for example.
The automatic zeroing out made them difficult to use.

Signed-off-by: Eyal Shapira <eyalx.shapira@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/rs.c | 10 ++++++----
 drivers/net/wireless/iwlwifi/mvm/rs.h |  7 ++++---
 2 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index 94c5299..f77dfe4 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -672,8 +672,10 @@ static int rs_collect_tx_data(struct iwl_lq_sta *lq_sta,
 		return -EINVAL;
 
 	if (tbl->column != RS_COLUMN_INVALID) {
-		lq_sta->tx_stats[tbl->column][scale_index].total += attempts;
-		lq_sta->tx_stats[tbl->column][scale_index].success += successes;
+		struct lq_sta_pers *pers = &lq_sta->pers;
+
+		pers->tx_stats[tbl->column][scale_index].total += attempts;
+		pers->tx_stats[tbl->column][scale_index].success += successes;
 	}
 
 	/* Select window for current tx bit rate */
@@ -3171,7 +3173,7 @@ static ssize_t rs_sta_dbgfs_drv_tx_stats_read(struct file *file,
 				 "%s,", column_name[col]);
 
 		for (rate = 0; rate < IWL_RATE_COUNT; rate++) {
-			stats = &(lq_sta->tx_stats[col][rate]);
+			stats = &(lq_sta->pers.tx_stats[col][rate]);
 			pos += scnprintf(pos, endpos - pos,
 					 "%llu/%llu,",
 					 stats->success,
@@ -3190,7 +3192,7 @@ static ssize_t rs_sta_dbgfs_drv_tx_stats_write(struct file *file,
 					       size_t count, loff_t *ppos)
 {
 	struct iwl_lq_sta *lq_sta = file->private_data;
-	memset(lq_sta->tx_stats, 0, sizeof(lq_sta->tx_stats));
+	memset(lq_sta->pers.tx_stats, 0, sizeof(lq_sta->pers.tx_stats));
 
 	return count;
 }
diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.h b/drivers/net/wireless/iwlwifi/mvm/rs.h
index 98bb9b7..95c4b96 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.h
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.h
@@ -333,8 +333,6 @@ struct iwl_lq_sta {
 	bool ldpc;              /* LDPC Rx is supported by the STA */
 	enum ieee80211_band band;
 
-	struct rs_rate_stats tx_stats[RS_COLUMN_COUNT][IWL_RATE_COUNT];
-
 	/* The following are bitmaps of rates; IWL_RATE_6M_MASK, etc. */
 	unsigned long active_legacy_rate;
 	unsigned long active_siso_rate;
@@ -362,11 +360,14 @@ struct iwl_lq_sta {
 	int tpc_reduce;
 
 	/* persistent fields - initialized only once - keep last! */
-	struct {
+	struct lq_sta_pers {
 #ifdef CONFIG_MAC80211_DEBUGFS
 		u32 dbg_fixed_rate;
 		u8 dbg_fixed_txp_reduction;
 #endif
+		u8 chains;
+		s8 chain_signal[IEEE80211_MAX_CHAINS];
+		struct rs_rate_stats tx_stats[RS_COLUMN_COUNT][IWL_RATE_COUNT];
 		struct iwl_mvm *drv;
 	} pers;
 };
-- 
1.9.1

