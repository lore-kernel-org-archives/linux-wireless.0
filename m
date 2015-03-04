Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f68.google.com ([74.125.82.68]:33195 "EHLO
	mail-wg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933141AbbCDR7s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Mar 2015 12:59:48 -0500
From: Alban Gruin <alban.gruin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-wireless@vger.kernel.org
Cc: johannes.berg@intel.com
Cc: emmanuel.grumbach@intel.com
Subject: [PATCH] iwlwifi: mvm: fix usage of debug specific variables
Date: Wed, 04 Mar 2015 18:59:07 +0100
Message-ID: <871tl4ej9w.fsf@ylate.i-did-not-set--mail-host-address--so-tickle-me> (sfid-20150304_190008_009775_40AFA4E9)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some variables in structs "iwl_mvm" and "iwl_mvm_vif" are used for debug
purpose, and are declared only if CONFIG_IWLWIFI_DEBUGFS is
set. However, some of these variables are used even if
CONFIG_IWLWIFI_DEBUGFS is not set, resulting in a compilation error.
This patch aims to fix this issue by adding a preprocessor condition
where these variables are used.

Signed-off-by: Alban Gruin <alban.gruin@gmail.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c | 4 ++++
 drivers/net/wireless/iwlwifi/mvm/phy-ctxt.c | 3 +++
 2 files changed, 7 insertions(+)
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
index 581b3b8..42bd545 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
@@ -1375,10 +1375,12 @@ static void iwl_mvm_beacon_loss_iterator(void *_data, u8 *mac,
 {
 	struct iwl_missed_beacons_notif *missed_beacons = _data;
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
+#ifdef CONFIG_IWLWIFI_DEBUGFS
 	struct iwl_mvm *mvm = mvmvif->mvm;
 	struct iwl_fw_dbg_trigger_missed_bcon *bcon_trig;
 	struct iwl_fw_dbg_trigger_tlv *trigger;
 	u32 stop_trig_missed_bcon, stop_trig_missed_bcon_since_rx;
+#endif
 	u32 rx_missed_bcon, rx_missed_bcon_since_rx;
 
 	if (mvmvif->id != (u16)le32_to_cpu(missed_beacons->mac_id))
@@ -1395,6 +1397,7 @@ static void iwl_mvm_beacon_loss_iterator(void *_data, u8 *mac,
 	     IWL_MVM_MISSED_BEACONS_THRESHOLD)
 		ieee80211_beacon_loss(vif);
 
+#ifdef CONFIG_IWLWIFI_DEBUGFS
 	if (!iwl_fw_dbg_trigger_enabled(mvm->fw,
 					FW_DBG_TRIGGER_MISSED_BEACONS))
 		return;
@@ -1414,6 +1417,7 @@ static void iwl_mvm_beacon_loss_iterator(void *_data, u8 *mac,
 	if (rx_missed_bcon_since_rx >= stop_trig_missed_bcon_since_rx ||
 	    rx_missed_bcon >= stop_trig_missed_bcon)
 		iwl_mvm_fw_dbg_collect_trig(mvm, trigger, NULL, 0);
+#endif
 }
 
 int iwl_mvm_rx_missed_beacons_notif(struct iwl_mvm *mvm,
diff --git a/drivers/net/wireless/iwlwifi/mvm/phy-ctxt.c b/drivers/net/wireless/iwlwifi/mvm/phy-ctxt.c
index 1bd10ed..850c72c 100644
--- a/drivers/net/wireless/iwlwifi/mvm/phy-ctxt.c
+++ b/drivers/net/wireless/iwlwifi/mvm/phy-ctxt.c
@@ -175,8 +175,11 @@ static void iwl_mvm_phy_ctxt_cmd_data(struct iwl_mvm *mvm,
 	cmd->rxchain_info |= cpu_to_le32(idle_cnt << PHY_RX_CHAIN_CNT_POS);
 	cmd->rxchain_info |= cpu_to_le32(active_cnt <<
 					 PHY_RX_CHAIN_MIMO_CNT_POS);
+
+#ifdef CONFIG_IWLWIFI_DEBUGFS
 	if (unlikely(mvm->dbgfs_rx_phyinfo))
 		cmd->rxchain_info = cpu_to_le32(mvm->dbgfs_rx_phyinfo);
+#endif
 
 	cmd->txchain_info = cpu_to_le32(iwl_mvm_get_valid_tx_ant(mvm));
 }
