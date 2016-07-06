Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:33612 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752055AbcGFKqT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jul 2016 06:46:19 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Matti Gottlieb <matti.gottlieb@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>
Date: Wed,  6 Jul 2016 13:40:12 +0300
Message-Id: <1467801651-1816-17-git-send-email-luca@coelho.fi> (sfid-20160706_125023_530483_1DB2EE1D)
In-Reply-To: <1467801452.25088.20.camel@coelho.fi>
References: <1467801452.25088.20.camel@coelho.fi>
Subject: [PATCH 17/56] iwlwifi: mvm: Do not open aggregations for null data packets
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Matti Gottlieb <matti.gottlieb@intel.com>

Currently we try to open an aggregation for every packet (given that one
is not already open).

This causes redundant overhead (addba/delba) for null data packets.

Do not open an aggregation for null data packets.

Signed-off-by: Matti Gottlieb <matti.gottlieb@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c | 13 +++++++------
 drivers/net/wireless/intel/iwlwifi/mvm/rs.h |  2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c |  2 +-
 3 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rs.c b/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
index 81dd2f6..7aecf46 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
@@ -399,7 +399,7 @@ static int iwl_hwrate_to_plcp_idx(u32 rate_n_flags)
 static void rs_rate_scale_perform(struct iwl_mvm *mvm,
 				  struct ieee80211_sta *sta,
 				  struct iwl_lq_sta *lq_sta,
-				  int tid);
+				  int tid, bool ndp);
 static void rs_fill_lq_cmd(struct iwl_mvm *mvm,
 			   struct ieee80211_sta *sta,
 			   struct iwl_lq_sta *lq_sta,
@@ -1161,7 +1161,7 @@ static u8 rs_get_tid(struct ieee80211_hdr *hdr)
 }
 
 void iwl_mvm_rs_tx_status(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
-			  int tid, struct ieee80211_tx_info *info)
+			  int tid, struct ieee80211_tx_info *info, bool ndp)
 {
 	int legacy_success;
 	int retries;
@@ -1384,7 +1384,7 @@ void iwl_mvm_rs_tx_status(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 done:
 	/* See if there's a better rate or modulation mode to try. */
 	if (sta->supp_rates[info->band])
-		rs_rate_scale_perform(mvm, sta, lq_sta, tid);
+		rs_rate_scale_perform(mvm, sta, lq_sta, tid, ndp);
 }
 
 /*
@@ -1407,7 +1407,8 @@ static void rs_mac80211_tx_status(void *mvm_r,
 	    info->flags & IEEE80211_TX_CTL_NO_ACK)
 		return;
 
-	iwl_mvm_rs_tx_status(mvm, sta, rs_get_tid(hdr), info);
+	iwl_mvm_rs_tx_status(mvm, sta, rs_get_tid(hdr), info,
+			     ieee80211_is_qos_nullfunc(hdr->frame_control));
 }
 
 /*
@@ -2213,7 +2214,7 @@ static bool rs_tpc_perform(struct iwl_mvm *mvm,
 static void rs_rate_scale_perform(struct iwl_mvm *mvm,
 				  struct ieee80211_sta *sta,
 				  struct iwl_lq_sta *lq_sta,
-				  int tid)
+				  int tid, bool ndp)
 {
 	int low = IWL_RATE_INVALID;
 	int high = IWL_RATE_INVALID;
@@ -2512,7 +2513,7 @@ lq_update:
 			    (lq_sta->tx_agg_tid_en & (1 << tid)) &&
 			    (tid != IWL_MAX_TID_COUNT)) {
 				tid_data = &sta_priv->tid_data[tid];
-				if (tid_data->state == IWL_AGG_OFF) {
+				if (tid_data->state == IWL_AGG_OFF && !ndp) {
 					IWL_DEBUG_RATE(mvm,
 						       "try to aggregate tid %d\n",
 						       tid);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rs.h b/drivers/net/wireless/intel/iwlwifi/mvm/rs.h
index 90d046f..d4a7fe2 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rs.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rs.h
@@ -362,7 +362,7 @@ void iwl_mvm_rs_rate_init(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 
 /* Notify RS about Tx status */
 void iwl_mvm_rs_tx_status(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
-			  int tid, struct ieee80211_tx_info *info);
+			  int tid, struct ieee80211_tx_info *info, bool ndp);
 
 /**
  * iwl_rate_control_register - Register the rate control algorithm callbacks
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index 9943013..d91edab 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -1660,7 +1660,7 @@ void iwl_mvm_rx_ba_notif(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb)
 		iwl_mvm_tx_info_from_ba_notif(&ba_info, ba_notif, tid_data);
 
 		IWL_DEBUG_TX_REPLY(mvm, "No reclaim. Update rs directly\n");
-		iwl_mvm_rs_tx_status(mvm, sta, tid, &ba_info);
+		iwl_mvm_rs_tx_status(mvm, sta, tid, &ba_info, false);
 	}
 
 out:
-- 
2.8.1

