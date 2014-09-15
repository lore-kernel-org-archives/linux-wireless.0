Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f181.google.com ([74.125.82.181]:62892 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753226AbaIOFNn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2014 01:13:43 -0400
Received: by mail-we0-f181.google.com with SMTP id w62so3299624wes.26
        for <linux-wireless@vger.kernel.org>; Sun, 14 Sep 2014 22:13:42 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Arik Nemtsov <arik@wizery.com>,
	Arik Nemtsov <arikx.nemtsov@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 26/28] iwlwifi: mvm: fix PSM disable during TDLS
Date: Mon, 15 Sep 2014 08:12:58 +0300
Message-Id: <1410757980-2138-26-git-send-email-egrumbach@gmail.com> (sfid-20140915_073114_883805_0C435F99)
In-Reply-To: <5416742C.3070804@gmail.com>
References: <5416742C.3070804@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

Simplify the code and check for TDLS stations just before sending the
MAC_POWER_TABLE command. The previous version of the code still allowed
PM in some multi-interface scenarios even with TDLS connected.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/power.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/power.c b/drivers/net/wireless/iwlwifi/mvm/power.c
index ff842ee..5b85b0c 100644
--- a/drivers/net/wireless/iwlwifi/mvm/power.c
+++ b/drivers/net/wireless/iwlwifi/mvm/power.c
@@ -336,7 +336,7 @@ static void iwl_mvm_power_build_cmd(struct iwl_mvm *mvm,
 	cmd->flags |= cpu_to_le16(POWER_FLAGS_POWER_SAVE_ENA_MSK);
 
 	if (!vif->bss_conf.ps || iwl_mvm_vif_low_latency(mvmvif) ||
-	    !mvmvif->pm_enabled)
+	    !mvmvif->pm_enabled || iwl_mvm_tdls_sta_count(mvm, vif))
 		return;
 
 	cmd->flags |= cpu_to_le16(POWER_FLAGS_POWER_MANAGEMENT_ENA_MSK);
@@ -510,8 +510,6 @@ struct iwl_power_vifs {
 	bool bss_active;
 	bool ap_active;
 	bool monitor_active;
-	bool bss_tdls;
-	bool p2p_tdls;
 };
 
 static void iwl_mvm_power_disable_pm_iterator(void *_data, u8* mac,
@@ -566,8 +564,6 @@ static void iwl_mvm_power_get_vifs_iterator(void *_data, u8 *mac,
 		/* only a single MAC of the same type */
 		WARN_ON(power_iterator->p2p_vif);
 		power_iterator->p2p_vif = vif;
-		power_iterator->p2p_tdls =
-			!!iwl_mvm_tdls_sta_count(power_iterator->mvm, vif);
 		if (mvmvif->phy_ctxt)
 			if (mvmvif->phy_ctxt->id < MAX_PHYS)
 				power_iterator->p2p_active = true;
@@ -577,8 +573,6 @@ static void iwl_mvm_power_get_vifs_iterator(void *_data, u8 *mac,
 		/* only a single MAC of the same type */
 		WARN_ON(power_iterator->bss_vif);
 		power_iterator->bss_vif = vif;
-		power_iterator->bss_tdls =
-			!!iwl_mvm_tdls_sta_count(power_iterator->mvm, vif);
 		if (mvmvif->phy_ctxt)
 			if (mvmvif->phy_ctxt->id < MAX_PHYS)
 				power_iterator->bss_active = true;
@@ -621,15 +615,13 @@ static void iwl_mvm_power_set_pm(struct iwl_mvm *mvm,
 		ap_mvmvif = iwl_mvm_vif_from_mac80211(vifs->ap_vif);
 
 	/* enable PM on bss if bss stand alone */
-	if (vifs->bss_active && !vifs->p2p_active && !vifs->ap_active &&
-	    !vifs->bss_tdls) {
+	if (vifs->bss_active && !vifs->p2p_active && !vifs->ap_active) {
 		bss_mvmvif->pm_enabled = true;
 		return;
 	}
 
 	/* enable PM on p2p if p2p stand alone */
-	if (vifs->p2p_active && !vifs->bss_active && !vifs->ap_active &&
-	    !vifs->p2p_tdls) {
+	if (vifs->p2p_active && !vifs->bss_active && !vifs->ap_active) {
 		if (mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_P2P_PM)
 			p2p_mvmvif->pm_enabled = true;
 		return;
-- 
1.9.1

