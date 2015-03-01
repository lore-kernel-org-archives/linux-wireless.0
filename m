Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:24060 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752280AbbCATb5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Mar 2015 14:31:57 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Eyal Shapira <eyal@wizery.com>,
	Eyal Shapira <eyalx.shapira@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 04/31] iwlwifi: mvm: rs: disable MIMO for low latency P2P
Date: Sun,  1 Mar 2015 21:31:17 +0200
Message-Id: <1425238304-498-4-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150301_203200_073564_FBFD6B42)
In-Reply-To: <1425238186.30202.5.camel@egrumbacBox>
References: <1425238186.30202.5.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

Due to issues with Miracast adapters MIMO reception disable
use of MIMO when for low latency P2P traffic.

Signed-off-by: Eyal Shapira <eyalx.shapira@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/rs.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index 37002cf..2bed577 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -160,6 +160,9 @@ static bool rs_mimo_allow(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 			  struct iwl_scale_tbl_info *tbl,
 			  const struct rs_tx_column *next_col)
 {
+	struct iwl_mvm_sta *mvmsta;
+	struct iwl_mvm_vif *mvmvif;
+
 	if (!sta->ht_cap.ht_supported)
 		return false;
 
@@ -172,6 +175,11 @@ static bool rs_mimo_allow(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 	if (!iwl_mvm_bt_coex_is_mimo_allowed(mvm, sta))
 		return false;
 
+	mvmsta = iwl_mvm_sta_from_mac80211(sta);
+	mvmvif = iwl_mvm_vif_from_mac80211(mvmsta->vif);
+	if (iwl_mvm_vif_low_latency(mvmvif) && mvmsta->vif->p2p)
+		return false;
+
 	return true;
 }
 
-- 
1.9.1

