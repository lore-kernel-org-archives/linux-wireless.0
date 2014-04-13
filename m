Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:34675 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755670AbaDMTVS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Apr 2014 15:21:18 -0400
Received: by mail-wi0-f173.google.com with SMTP id z2so3135230wiv.6
        for <linux-wireless@vger.kernel.org>; Sun, 13 Apr 2014 12:21:17 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Avri Altman <avri.altman@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 46/47] iwlwifi: mvm: Re-factor enabling uAPSD logic
Date: Sun, 13 Apr 2014 22:20:01 +0300
Message-Id: <1397416802-32403-46-git-send-email-egrumbach@gmail.com> (sfid-20140413_213514_920382_0E17293B)
In-Reply-To: <534AE330.2020805@gmail.com>
References: <534AE330.2020805@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avri Altman <avri.altman@intel.com>

The driver can enable uAPSD and specify some of its related parameters.
This patch organizes this logic in a separate function.

Signed-off-by: Avri Altman <avri.altman@intel.com>
Reviewed-by: Alexander Bondar <alexander.bondar@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/power.c | 43 +++++++++++++++++++-------------
 1 file changed, 25 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/power.c b/drivers/net/wireless/iwlwifi/mvm/power.c
index 2e6f477..78309f7 100644
--- a/drivers/net/wireless/iwlwifi/mvm/power.c
+++ b/drivers/net/wireless/iwlwifi/mvm/power.c
@@ -268,6 +268,30 @@ static void iwl_mvm_power_configure_uapsd(struct iwl_mvm *mvm,
 		IWL_MVM_PS_HEAVY_RX_THLD_PERCENT;
 }
 
+static bool iwl_mvm_power_allow_uapsd(struct iwl_mvm *mvm,
+				       struct ieee80211_vif *vif)
+{
+	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
+
+	if (!memcmp(mvmvif->uapsd_misbehaving_bssid, vif->bss_conf.bssid,
+		    ETH_ALEN))
+		return false;
+
+	if (vif->p2p &&
+	    !(mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_P2P_PS_UAPSD))
+		return false;
+	/*
+	 * Avoid using uAPSD if P2P client is associated to GO that uses
+	 * opportunistic power save. This is due to current FW limitation.
+	 */
+	if (vif->p2p &&
+	    (vif->bss_conf.p2p_noa_attr.oppps_ctwindow &
+	    IEEE80211_P2P_OPPPS_ENABLE_BIT))
+		return false;
+
+	return true;
+}
+
 static void iwl_mvm_power_build_cmd(struct iwl_mvm *mvm,
 				    struct ieee80211_vif *vif,
 				    struct iwl_mac_power_cmd *cmd)
@@ -280,7 +304,6 @@ static void iwl_mvm_power_build_cmd(struct iwl_mvm *mvm,
 	bool radar_detect = false;
 	struct iwl_mvm_vif *mvmvif __maybe_unused =
 		iwl_mvm_vif_from_mac80211(vif);
-	bool allow_uapsd = true;
 
 	cmd->id_and_color = cpu_to_le32(FW_CMD_ID_AND_COLOR(mvmvif->id,
 							    mvmvif->color));
@@ -346,23 +369,7 @@ static void iwl_mvm_power_build_cmd(struct iwl_mvm *mvm,
 			cpu_to_le32(IWL_MVM_WOWLAN_PS_TX_DATA_TIMEOUT);
 	}
 
-	if (!memcmp(mvmvif->uapsd_misbehaving_bssid, vif->bss_conf.bssid,
-		    ETH_ALEN))
-		allow_uapsd = false;
-
-	if (vif->p2p &&
-	    !(mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_P2P_PS_UAPSD))
-		allow_uapsd = false;
-	/*
-	 * Avoid using uAPSD if P2P client is associated to GO that uses
-	 * opportunistic power save. This is due to current FW limitation.
-	 */
-	if (vif->p2p &&
-	    vif->bss_conf.p2p_noa_attr.oppps_ctwindow &
-	    IEEE80211_P2P_OPPPS_ENABLE_BIT)
-		allow_uapsd = false;
-
-	if (allow_uapsd)
+	if (iwl_mvm_power_allow_uapsd(mvm, vif))
 		iwl_mvm_power_configure_uapsd(mvm, vif, cmd);
 
 #ifdef CONFIG_IWLWIFI_DEBUGFS
-- 
1.8.3.2

