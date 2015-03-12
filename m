Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:23662 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754563AbbCLNGE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2015 09:06:04 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Arik Nemtsov <arik@wizery.com>,
	Arik Nemtsov <arikx.nemtsov@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 32/49] iwlwifi: mvm: reflect TDLS pm state in mvmvif->pm_enabled
Date: Thu, 12 Mar 2015 15:04:17 +0200
Message-Id: <1426165474-25586-32-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150312_140747_494393_15EC791D)
In-Reply-To: <1426164431.19690.4.camel@egrumbacBox>
References: <1426164431.19690.4.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

When entering D0i3, the MVM mutex cannot be grabbed. This interferes
with the calculation of the number of connected TDLS stations during
the setup of the power cmd.
The goal is to disable power saving for all vifs while any TDLS station
is connected. For this purpose it is enough to keep the pm_enabled
member of all mvmvifs as false. An update of the power state already
occurs when a TDLS station is added/removed, so the values are correctly
updated.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/power.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/power.c b/drivers/net/wireless/iwlwifi/mvm/power.c
index 2620dd0..9c6fce1 100644
--- a/drivers/net/wireless/iwlwifi/mvm/power.c
+++ b/drivers/net/wireless/iwlwifi/mvm/power.c
@@ -357,7 +357,7 @@ static void iwl_mvm_power_build_cmd(struct iwl_mvm *mvm,
 	cmd->flags |= cpu_to_le16(POWER_FLAGS_POWER_SAVE_ENA_MSK);
 
 	if (!vif->bss_conf.ps || iwl_mvm_vif_low_latency(mvmvif) ||
-	    !mvmvif->pm_enabled || iwl_mvm_tdls_sta_count(mvm, vif))
+	    !mvmvif->pm_enabled)
 		return;
 
 	cmd->flags |= cpu_to_le16(POWER_FLAGS_POWER_MANAGEMENT_ENA_MSK);
@@ -638,6 +638,10 @@ static void iwl_mvm_power_set_pm(struct iwl_mvm *mvm,
 	if (vifs->ap_vif)
 		ap_mvmvif = iwl_mvm_vif_from_mac80211(vifs->ap_vif);
 
+	/* don't allow PM if any TDLS stations exist */
+	if (iwl_mvm_tdls_sta_count(mvm, NULL))
+		return;
+
 	/* enable PM on bss if bss stand alone */
 	if (vifs->bss_active && !vifs->p2p_active && !vifs->ap_active) {
 		bss_mvmvif->pm_enabled = true;
-- 
1.9.1

