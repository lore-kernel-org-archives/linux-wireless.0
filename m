Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f50.google.com ([74.125.83.50]:39714 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753906Ab3LQUpD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Dec 2013 15:45:03 -0500
Received: by mail-ee0-f50.google.com with SMTP id c41so3192279eek.9
        for <linux-wireless@vger.kernel.org>; Tue, 17 Dec 2013 12:45:01 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 12/36] iwlwifi: mvm: move iwl_mvm_set_tx_power to PHY area
Date: Tue, 17 Dec 2013 22:44:15 +0200
Message-Id: <1387313079-28123-12-git-send-email-egrumbach@gmail.com> (sfid-20131217_214633_781851_8E87D661)
In-Reply-To: <52B0B72A.5070704@gmail.com>
References: <52B0B72A.5070704@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This is more related to phy contexts than to mac context.
Move this function to there.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c |   28 +++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index b42ce2c..9a27f57 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -516,6 +516,20 @@ static struct iwl_mvm_phy_ctxt *iwl_mvm_get_free_phy_ctxt(struct iwl_mvm *mvm)
 	return NULL;
 }
 
+static int iwl_mvm_set_tx_power(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
+				s8 tx_power)
+{
+	/* FW is in charge of regulatory enforcement */
+	struct iwl_reduce_tx_power_cmd reduce_txpwr_cmd = {
+		.mac_context_id = iwl_mvm_vif_from_mac80211(vif)->id,
+		.pwr_restriction = cpu_to_le16(tx_power),
+	};
+
+	return iwl_mvm_send_cmd_pdu(mvm, REDUCE_TX_POWER_CMD, CMD_SYNC,
+				    sizeof(reduce_txpwr_cmd),
+				    &reduce_txpwr_cmd);
+}
+
 static int iwl_mvm_mac_add_interface(struct ieee80211_hw *hw,
 				     struct ieee80211_vif *vif)
 {
@@ -736,20 +750,6 @@ out_release:
 	mutex_unlock(&mvm->mutex);
 }
 
-static int iwl_mvm_set_tx_power(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
-				s8 tx_power)
-{
-	/* FW is in charge of regulatory enforcement */
-	struct iwl_reduce_tx_power_cmd reduce_txpwr_cmd = {
-		.mac_context_id = iwl_mvm_vif_from_mac80211(vif)->id,
-		.pwr_restriction = cpu_to_le16(tx_power),
-	};
-
-	return iwl_mvm_send_cmd_pdu(mvm, REDUCE_TX_POWER_CMD, CMD_SYNC,
-				    sizeof(reduce_txpwr_cmd),
-				    &reduce_txpwr_cmd);
-}
-
 static int iwl_mvm_mac_config(struct ieee80211_hw *hw, u32 changed)
 {
 	return 0;
-- 
1.7.9.5

