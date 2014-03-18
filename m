Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f48.google.com ([74.125.83.48]:48206 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755888AbaCROpw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Mar 2014 10:45:52 -0400
Received: by mail-ee0-f48.google.com with SMTP id b57so4776272eek.35
        for <linux-wireless@vger.kernel.org>; Tue, 18 Mar 2014 07:45:51 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Avri Altman <avri.altman@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 06/35] iwlwifi: mvm: disable power on P2P client when BSS is added
Date: Tue, 18 Mar 2014 16:45:10 +0200
Message-Id: <1395153939-23897-6-git-send-email-egrumbach@gmail.com> (sfid-20140318_154559_715650_A6BFF055)
In-Reply-To: <53285AF8.7050305@gmail.com>
References: <53285AF8.7050305@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avri Altman <avri.altman@intel.com>

When power update is initiated on BSS STA while P2P client
exists, the power command will be sent only on BSS STA vif
ignoring P2P client.

Since the firmware has symmetric constraints on the power
save enablement we can simplify the code a bit.

The current firmware doesn't know how to enable power
management on P2P client. Even BSS power management must
be disabled when a P2P client is added.

Future firmware will support power save on BSS and P2P client
as long as they are on different channels.
This was buggy since we didn't disable power management on
P2P client interface if BSS added on the same channel.

Signed-off-by: Avri Altman <avri.altman@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/power.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/power.c b/drivers/net/wireless/iwlwifi/mvm/power.c
index def6ec5..6b636ea 100644
--- a/drivers/net/wireless/iwlwifi/mvm/power.c
+++ b/drivers/net/wireless/iwlwifi/mvm/power.c
@@ -511,6 +511,7 @@ int iwl_mvm_power_uapsd_misbehaving_ap_notif(struct iwl_mvm *mvm,
 struct iwl_power_constraint {
 	struct ieee80211_vif *bf_vif;
 	struct ieee80211_vif *bss_vif;
+	struct ieee80211_vif *p2p_vif;
 	u16 bss_phyctx_id;
 	u16 p2p_phyctx_id;
 	bool pm_disabled;
@@ -546,6 +547,10 @@ static void iwl_mvm_power_iterator(void *_data, u8 *mac,
 		if (mvmvif->phy_ctxt)
 			power_iterator->p2p_phyctx_id = mvmvif->phy_ctxt->id;
 
+		/* we should have only one P2P vif */
+		WARN_ON(power_iterator->p2p_vif);
+		power_iterator->p2p_vif = vif;
+
 		IWL_DEBUG_POWER(mvm, "p2p: p2p_id=%d, bss_id=%d\n",
 				power_iterator->p2p_phyctx_id,
 				power_iterator->bss_phyctx_id);
@@ -633,16 +638,18 @@ int iwl_mvm_power_update_mac(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 			return ret;
 	}
 
-	ret = iwl_mvm_power_send_cmd(mvm, vif);
-	if (ret)
-		return ret;
-
-	if (constraint.bss_vif && vif != constraint.bss_vif) {
+	if (constraint.bss_vif) {
 		ret = iwl_mvm_power_send_cmd(mvm, constraint.bss_vif);
 		if (ret)
 			return ret;
 	}
 
+	if (constraint.p2p_vif) {
+		ret = iwl_mvm_power_send_cmd(mvm, constraint.p2p_vif);
+		if (ret)
+			return ret;
+	}
+
 	if (!constraint.bf_vif)
 		return 0;
 
-- 
1.8.3.2

