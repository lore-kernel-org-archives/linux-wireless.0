Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f170.google.com ([74.125.82.170]:64383 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754419AbaEORFa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 May 2014 13:05:30 -0400
Received: by mail-we0-f170.google.com with SMTP id u57so1403513wes.1
        for <linux-wireless@vger.kernel.org>; Thu, 15 May 2014 10:05:28 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luciano.coelho@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 22/24] iwlwifi: mvm: combine p2p and station mac context functions
Date: Thu, 15 May 2014 20:04:39 +0300
Message-Id: <1400173481-9047-22-git-send-email-egrumbach@gmail.com> (sfid-20140515_192147_616690_8CDECB8B)
In-Reply-To: <5374F373.6040902@gmail.com>
References: <5374F373.6040902@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

Instead of having two nearly identical functions to send the mac
context commands, use a single way that can handle both the p2p and
!p2p cases.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c | 90 ++++++++++-------------------
 1 file changed, 32 insertions(+), 58 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
index d5f50af..2c51e40 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
@@ -693,14 +693,37 @@ static int iwl_mvm_mac_ctxt_send_cmd(struct iwl_mvm *mvm,
 	return ret;
 }
 
-/*
- * Fill the specific data for mac context of type station or p2p client
- */
-static void iwl_mvm_mac_ctxt_cmd_fill_sta(struct iwl_mvm *mvm,
-					  struct ieee80211_vif *vif,
-					  struct iwl_mac_data_sta *ctxt_sta,
-					  bool force_assoc_off)
+static int iwl_mvm_mac_ctxt_cmd_sta(struct iwl_mvm *mvm,
+				    struct ieee80211_vif *vif,
+				    u32 action, bool force_assoc_off)
 {
+	struct iwl_mac_ctx_cmd cmd = {};
+	struct iwl_mac_data_sta *ctxt_sta;
+
+	WARN_ON(vif->type != NL80211_IFTYPE_STATION);
+
+	/* Fill the common data for all mac context types */
+	iwl_mvm_mac_ctxt_cmd_common(mvm, vif, &cmd, action);
+
+	if (vif->p2p) {
+		struct ieee80211_p2p_noa_attr *noa =
+			&vif->bss_conf.p2p_noa_attr;
+
+		cmd.p2p_sta.ctwin = cpu_to_le32(noa->oppps_ctwindow &
+					IEEE80211_P2P_OPPPS_CTWINDOW_MASK);
+		ctxt_sta = &cmd.p2p_sta.sta;
+	} else {
+		/* Allow beacons to pass through as long as we are not
+		 * associated, or we do not have dtim period information.
+		 */
+		if (!vif->bss_conf.assoc || !vif->bss_conf.dtim_period)
+			cmd.filter_flags |= cpu_to_le32(MAC_FILTER_IN_BEACON);
+		else
+			cmd.filter_flags &= ~cpu_to_le32(MAC_FILTER_IN_BEACON);
+
+		ctxt_sta = &cmd.sta;
+	}
+
 	/* We need the dtim_period to set the MAC as associated */
 	if (vif->bss_conf.assoc && vif->bss_conf.dtim_period &&
 	    !force_assoc_off) {
@@ -752,51 +775,6 @@ static void iwl_mvm_mac_ctxt_cmd_fill_sta(struct iwl_mvm *mvm,
 
 	ctxt_sta->listen_interval = cpu_to_le32(mvm->hw->conf.listen_interval);
 	ctxt_sta->assoc_id = cpu_to_le32(vif->bss_conf.aid);
-}
-
-static int iwl_mvm_mac_ctxt_cmd_station(struct iwl_mvm *mvm,
-					struct ieee80211_vif *vif,
-					u32 action)
-{
-	struct iwl_mac_ctx_cmd cmd = {};
-
-	WARN_ON(vif->type != NL80211_IFTYPE_STATION || vif->p2p);
-
-	/* Fill the common data for all mac context types */
-	iwl_mvm_mac_ctxt_cmd_common(mvm, vif, &cmd, action);
-
-	/* Allow beacons to pass through as long as we are not associated,or we
-	 * do not have dtim period information */
-	if (!vif->bss_conf.assoc || !vif->bss_conf.dtim_period)
-		cmd.filter_flags |= cpu_to_le32(MAC_FILTER_IN_BEACON);
-	else
-		cmd.filter_flags &= ~cpu_to_le32(MAC_FILTER_IN_BEACON);
-
-	/* Fill the data specific for station mode */
-	iwl_mvm_mac_ctxt_cmd_fill_sta(mvm, vif, &cmd.sta,
-				      action == FW_CTXT_ACTION_ADD);
-
-	return iwl_mvm_mac_ctxt_send_cmd(mvm, &cmd);
-}
-
-static int iwl_mvm_mac_ctxt_cmd_p2p_client(struct iwl_mvm *mvm,
-					   struct ieee80211_vif *vif,
-					   u32 action)
-{
-	struct iwl_mac_ctx_cmd cmd = {};
-	struct ieee80211_p2p_noa_attr *noa = &vif->bss_conf.p2p_noa_attr;
-
-	WARN_ON(vif->type != NL80211_IFTYPE_STATION || !vif->p2p);
-
-	/* Fill the common data for all mac context types */
-	iwl_mvm_mac_ctxt_cmd_common(mvm, vif, &cmd, action);
-
-	/* Fill the data specific for station mode */
-	iwl_mvm_mac_ctxt_cmd_fill_sta(mvm, vif, &cmd.p2p_sta.sta,
-				      action == FW_CTXT_ACTION_ADD);
-
-	cmd.p2p_sta.ctwin = cpu_to_le32(noa->oppps_ctwindow &
-					IEEE80211_P2P_OPPPS_CTWINDOW_MASK);
 
 	return iwl_mvm_mac_ctxt_send_cmd(mvm, &cmd);
 }
@@ -1138,12 +1116,8 @@ static int iwl_mvm_mac_ctx_send(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 {
 	switch (vif->type) {
 	case NL80211_IFTYPE_STATION:
-		if (!vif->p2p)
-			return iwl_mvm_mac_ctxt_cmd_station(mvm, vif,
-							    action);
-		else
-			return iwl_mvm_mac_ctxt_cmd_p2p_client(mvm, vif,
-							       action);
+		return iwl_mvm_mac_ctxt_cmd_sta(mvm, vif, action,
+						action == FW_CTXT_ACTION_ADD);
 		break;
 	case NL80211_IFTYPE_AP:
 		if (!vif->p2p)
-- 
1.8.3.2

