Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f179.google.com ([209.85.215.179]:64554 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753872Ab3LQUpA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Dec 2013 15:45:00 -0500
Received: by mail-ea0-f179.google.com with SMTP id r15so3156921ead.10
        for <linux-wireless@vger.kernel.org>; Tue, 17 Dec 2013 12:44:59 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Alexander Bondar <alexander.bondar@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 10/36] iwlwifi: mvm: Enable power save on a single P2P client interface
Date: Tue, 17 Dec 2013 22:44:13 +0200
Message-Id: <1387313079-28123-10-git-send-email-egrumbach@gmail.com> (sfid-20131217_214509_064118_4F132DF6)
In-Reply-To: <52B0B72A.5070704@gmail.com>
References: <52B0B72A.5070704@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Alexander Bondar <alexander.bondar@intel.com>

Enable power save on P2P client interface only if it is the
only bound interface.
Avoid using uAPSD if P2P client is associated to GO that uses
opportunistic power save. This is due to current FW limitation.

Signed-off-by: Alexander Bondar <alexander.bondar@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-fw.h       |    3 +++
 drivers/net/wireless/iwlwifi/mvm/mac80211.c |    3 ++-
 drivers/net/wireless/iwlwifi/mvm/power.c    |   22 +++++++++++++++++++---
 3 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-fw.h b/drivers/net/wireless/iwlwifi/iwl-fw.h
index b2a4c1d..959562d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw.h
@@ -92,6 +92,8 @@
  * @IWL_UCODE_TLV_FLAGS_STA_KEY_CMD: new ADD_STA and ADD_STA_KEY command API
  * @IWL_UCODE_TLV_FLAGS_DEVICE_PS_CMD: support device wide power command
  *	containing CAM (Continuous Active Mode) indication.
+ * @IWL_UCODE_TLV_FLAGS_P2P_PS: P2P client power save is supported (only on a
+ *	single bound interface).
  */
 enum iwl_ucode_tlv_flag {
 	IWL_UCODE_TLV_FLAGS_PAN			= BIT(0),
@@ -113,6 +115,7 @@ enum iwl_ucode_tlv_flag {
 	IWL_UCODE_TLV_FLAGS_SCHED_SCAN		= BIT(17),
 	IWL_UCODE_TLV_FLAGS_STA_KEY_CMD		= BIT(19),
 	IWL_UCODE_TLV_FLAGS_DEVICE_PS_CMD	= BIT(20),
+	IWL_UCODE_TLV_FLAGS_P2P_PS		= BIT(21),
 	IWL_UCODE_TLV_FLAGS_UAPSD_SUPPORT	= BIT(24),
 };
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index d36105f..b42ce2c 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -861,7 +861,8 @@ static void iwl_mvm_bss_info_changed_station(struct iwl_mvm *mvm,
 		 */
 		iwl_mvm_remove_time_event(mvm, mvmvif,
 					  &mvmvif->time_event_data);
-	} else if (changes & (BSS_CHANGED_PS | BSS_CHANGED_QOS)) {
+	} else if (changes & (BSS_CHANGED_PS | BSS_CHANGED_P2P_PS |
+			      BSS_CHANGED_QOS)) {
 		ret = iwl_mvm_power_update_mode(mvm, vif);
 		if (ret)
 			IWL_ERR(mvm, "failed to update power mode\n");
diff --git a/drivers/net/wireless/iwlwifi/mvm/power.c b/drivers/net/wireless/iwlwifi/mvm/power.c
index cfed105..0ef4674 100644
--- a/drivers/net/wireless/iwlwifi/mvm/power.c
+++ b/drivers/net/wireless/iwlwifi/mvm/power.c
@@ -284,6 +284,7 @@ static void iwl_mvm_power_build_cmd(struct iwl_mvm *mvm,
 	bool radar_detect = false;
 	struct iwl_mvm_vif *mvmvif __maybe_unused =
 		iwl_mvm_vif_from_mac80211(vif);
+	bool allow_uapsd = true;
 
 	cmd->id_and_color = cpu_to_le32(FW_CMD_ID_AND_COLOR(mvmvif->id,
 							    mvmvif->color));
@@ -354,8 +355,19 @@ static void iwl_mvm_power_build_cmd(struct iwl_mvm *mvm,
 			cpu_to_le32(IWL_MVM_WOWLAN_PS_TX_DATA_TIMEOUT);
 	}
 
-	if (memcmp(mvmvif->uapsd_misbehaving_bssid, vif->bss_conf.bssid,
-		   ETH_ALEN))
+	if (!memcmp(mvmvif->uapsd_misbehaving_bssid, vif->bss_conf.bssid,
+		    ETH_ALEN))
+		allow_uapsd = false;
+	/*
+	 * Avoid using uAPSD if P2P client is associated to GO that uses
+	 * opportunistic power save. This is due to current FW limitation.
+	 */
+	if (vif->p2p &&
+	    vif->bss_conf.p2p_noa_attr.oppps_ctwindow &
+	    IEEE80211_P2P_OPPPS_ENABLE_BIT)
+		allow_uapsd = false;
+
+	if (allow_uapsd)
 		iwl_mvm_power_configure_uapsd(mvm, vif, cmd);
 
 #ifdef CONFIG_IWLWIFI_DEBUGFS
@@ -404,7 +416,11 @@ static int iwl_mvm_power_mac_update_mode(struct iwl_mvm *mvm,
 	bool ba_enable;
 	struct iwl_mac_power_cmd cmd = {};
 
-	if (vif->type != NL80211_IFTYPE_STATION || vif->p2p)
+	if (vif->type != NL80211_IFTYPE_STATION)
+		return 0;
+
+	if (vif->p2p &&
+	    !(mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_P2P_PS))
 		return 0;
 
 	iwl_mvm_power_build_cmd(mvm, vif, &cmd);
-- 
1.7.9.5

