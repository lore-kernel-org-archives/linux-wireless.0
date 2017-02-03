Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:37832 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753250AbdBCOi0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 3 Feb 2017 09:38:26 -0500
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri,  3 Feb 2017 16:37:48 +0200
Message-Id: <20170203143812.7525-2-luca@coelho.fi> (sfid-20170203_153840_992229_C296F26C)
In-Reply-To: <20170203143812.7525-1-luca@coelho.fi>
References: <20170203143812.7525-1-luca@coelho.fi>
Subject: [PATCH 01/25] iwlwifi: mvm: fix PS-Poll enablement
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

We added the uAPSD enabled ACs and that made the
firmware choose to pull frames with uAPSD trigger
frames instead of PS-Poll.
Fix that.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/power.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/power.c b/drivers/net/wireless/intel/iwlwifi/mvm/power.c
index af6d10c23e5a..3a8e9379da2f 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/power.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/power.c
@@ -174,6 +174,14 @@ static void iwl_mvm_power_configure_uapsd(struct iwl_mvm *mvm,
 	enum ieee80211_ac_numbers ac;
 	bool tid_found = false;
 
+#ifdef CONFIG_IWLWIFI_DEBUGFS
+	/* set advanced pm flag with no uapsd ACs to enable ps-poll */
+	if (mvmvif->dbgfs_pm.use_ps_poll) {
+		cmd->flags |= cpu_to_le16(POWER_FLAGS_ADVANCE_PM_ENA_MSK);
+		return;
+	}
+#endif
+
 	for (ac = IEEE80211_AC_VO; ac <= IEEE80211_AC_BK; ac++) {
 		if (!mvmvif->queue_params[ac].uapsd)
 			continue;
@@ -204,16 +212,6 @@ static void iwl_mvm_power_configure_uapsd(struct iwl_mvm *mvm,
 		}
 	}
 
-	if (!(cmd->flags & cpu_to_le16(POWER_FLAGS_ADVANCE_PM_ENA_MSK))) {
-#ifdef CONFIG_IWLWIFI_DEBUGFS
-		/* set advanced pm flag with no uapsd ACs to enable ps-poll */
-		if (mvmvif->dbgfs_pm.use_ps_poll)
-			cmd->flags |=
-				cpu_to_le16(POWER_FLAGS_ADVANCE_PM_ENA_MSK);
-#endif
-		return;
-	}
-
 	cmd->flags |= cpu_to_le16(POWER_FLAGS_UAPSD_MISBEHAVING_ENA_MSK);
 
 	if (cmd->uapsd_ac_flags == (BIT(IEEE80211_AC_VO) |
-- 
2.11.0
