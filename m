Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:24060 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752173AbbCATcD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Mar 2015 14:32:03 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Eyal Shapira <eyal@wizery.com>,
	Eyal Shapira <eyalx.shapira@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 07/31] iwlwifi: mvm: rs: avoid ss_force from being reset after tx idle
Date: Sun,  1 Mar 2015 21:31:20 +0200
Message-Id: <1425238304-498-7-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150301_203211_011476_374E8D46)
In-Reply-To: <1425238186.30202.5.camel@egrumbacBox>
References: <1425238186.30202.5.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

ss_force is a debugging option to force a certain single stream
tx mode. It's not useful if it gets reset after tx idle. Fix that.
While at it also make sure any code touching ss_force will only
get compiled if debugfs support is configured.

Signed-off-by: Eyal Shapira <eyalx.shapira@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/rs.c | 21 ++++++++++++---------
 drivers/net/wireless/iwlwifi/mvm/rs.h |  6 +++---
 2 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index 2bed577..43f807f 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -2545,6 +2545,7 @@ static void *rs_alloc_sta(void *mvm_rate, struct ieee80211_sta *sta,
 #ifdef CONFIG_MAC80211_DEBUGFS
 	lq_sta->pers.dbg_fixed_rate = 0;
 	lq_sta->pers.dbg_fixed_txp_reduction = TPC_INVALID;
+	lq_sta->pers.ss_force = RS_SS_FORCE_NONE;
 #endif
 	lq_sta->pers.chains = 0;
 	memset(lq_sta->pers.chain_signal, 0, sizeof(lq_sta->pers.chain_signal));
@@ -3067,19 +3068,21 @@ static void rs_set_lq_ss_params(struct iwl_mvm *mvm,
 	if (!iwl_mvm_bt_coex_is_mimo_allowed(mvm, sta))
 		goto out;
 
+#ifdef CONFIG_MAC80211_DEBUGFS
 	/* Check if forcing the decision is configured.
 	 * Note that SISO is forced by not allowing STBC or BFER
 	 */
-	if (lq_sta->ss_force == RS_SS_FORCE_STBC)
+	if (lq_sta->pers.ss_force == RS_SS_FORCE_STBC)
 		ss_params |= (LQ_SS_STBC_1SS_ALLOWED | LQ_SS_FORCE);
-	else if (lq_sta->ss_force == RS_SS_FORCE_BFER)
+	else if (lq_sta->pers.ss_force == RS_SS_FORCE_BFER)
 		ss_params |= (LQ_SS_BFER_ALLOWED | LQ_SS_FORCE);
 
-	if (lq_sta->ss_force != RS_SS_FORCE_NONE) {
+	if (lq_sta->pers.ss_force != RS_SS_FORCE_NONE) {
 		IWL_DEBUG_RATE(mvm, "Forcing single stream Tx decision %d\n",
-			       lq_sta->ss_force);
+			       lq_sta->pers.ss_force);
 		goto out;
 	}
+#endif
 
 	if (lq_sta->stbc_capable)
 		ss_params |= LQ_SS_STBC_1SS_ALLOWED;
@@ -3542,7 +3545,7 @@ static ssize_t iwl_dbgfs_ss_force_read(struct file *file,
 	};
 
 	pos += scnprintf(buf+pos, bufsz-pos, "%s\n",
-			 ss_force_name[lq_sta->ss_force]);
+			 ss_force_name[lq_sta->pers.ss_force]);
 	return simple_read_from_buffer(user_buf, count, ppos, buf, pos);
 }
 
@@ -3553,12 +3556,12 @@ static ssize_t iwl_dbgfs_ss_force_write(struct iwl_lq_sta *lq_sta, char *buf,
 	int ret = 0;
 
 	if (!strncmp("none", buf, 4)) {
-		lq_sta->ss_force = RS_SS_FORCE_NONE;
+		lq_sta->pers.ss_force = RS_SS_FORCE_NONE;
 	} else if (!strncmp("siso", buf, 4)) {
-		lq_sta->ss_force = RS_SS_FORCE_SISO;
+		lq_sta->pers.ss_force = RS_SS_FORCE_SISO;
 	} else if (!strncmp("stbc", buf, 4)) {
 		if (lq_sta->stbc_capable) {
-			lq_sta->ss_force = RS_SS_FORCE_STBC;
+			lq_sta->pers.ss_force = RS_SS_FORCE_STBC;
 		} else {
 			IWL_ERR(mvm,
 				"can't force STBC. peer doesn't support\n");
@@ -3566,7 +3569,7 @@ static ssize_t iwl_dbgfs_ss_force_write(struct iwl_lq_sta *lq_sta, char *buf,
 		}
 	} else if (!strncmp("bfer", buf, 4)) {
 		if (lq_sta->bfer_capable) {
-			lq_sta->ss_force = RS_SS_FORCE_BFER;
+			lq_sta->pers.ss_force = RS_SS_FORCE_BFER;
 		} else {
 			IWL_ERR(mvm,
 				"can't force BFER. peer doesn't support\n");
diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.h b/drivers/net/wireless/iwlwifi/mvm/rs.h
index 4cb278f..e4aa934 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.h
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.h
@@ -332,14 +332,14 @@ struct iwl_lq_sta {
 	/* tx power reduce for this sta */
 	int tpc_reduce;
 
-	/* force STBC/BFER/SISO for testing */
-	enum rs_ss_force_opt ss_force;
-
 	/* persistent fields - initialized only once - keep last! */
 	struct lq_sta_pers {
 #ifdef CONFIG_MAC80211_DEBUGFS
 		u32 dbg_fixed_rate;
 		u8 dbg_fixed_txp_reduction;
+
+		/* force STBC/BFER/SISO for testing */
+		enum rs_ss_force_opt ss_force;
 #endif
 		u8 chains;
 		s8 chain_signal[IEEE80211_MAX_CHAINS];
-- 
1.9.1

