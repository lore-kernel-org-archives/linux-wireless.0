Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53387 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754313Ab1BHNiY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Feb 2011 08:38:24 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [RFC/RFT] iwlwifi: module parameters for health check
Date: Tue,  8 Feb 2011 14:38:23 +0100
Message-Id: <1297172303-17487-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently we unconditionally check "health" and reset radio or whole
device when bad state is detected.

However that not always work correctly. Particularly plcp check is
causing very low speed problems on 3945 and low ack check make 5xxx
devices randomly stop working.

Patch module option to allow to disable this checks. Actually it
make checks disabled by default, since IMHO they are causing more
troubles than give help, but that need to be tested.
---
 drivers/net/wireless/iwlwifi/iwl-agn.c  |    7 +++++++
 drivers/net/wireless/iwlwifi/iwl-core.h |    2 ++
 drivers/net/wireless/iwlwifi/iwl-rx.c   |    6 ++++--
 3 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 2d83f9f..65cfe12 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -4795,3 +4795,10 @@ MODULE_PARM_DESC(antenna_coupling,
 module_param_named(bt_ch_inhibition, iwlagn_bt_ch_announce, bool, S_IRUGO);
 MODULE_PARM_DESC(bt_ch_inhibition,
 		 "Disable BT channel inhibition (default: enable)");
+
+module_param_named(plcp_check, iwlagn_mod_params.plcp_check, bool, S_IRUGO);
+MODULE_PARM_DESC(plcp_check, "Check plcp health (default: 0 [disabled])");
+
+module_param_named(ack_check, iwlagn_mod_params.ack_check, bool, S_IRUGO);
+MODULE_PARM_DESC(ack_check, "Check ack health (default: 0 [disabled])");
+
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 9e7a6d1..96f07d4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -261,6 +261,8 @@ struct iwl_mod_params {
 	int amsdu_size_8K;	/* def: 1 = enable 8K amsdu size */
 	int antenna;  		/* def: 0 = both antennas (use diversity) */
 	int restart_fw;		/* def: 1 = restart firmware */
+	bool plcp_check;	/* def: false = disable plcp health check */
+	bool ack_check;		/* def: false = disable ack health check */
 };
 
 /*
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index b9c2591..8a1a483 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -238,14 +238,16 @@ void iwl_recover_from_statistics(struct iwl_priv *priv,
 	    !iwl_is_any_associated(priv))
 		return;
 
-	if (priv->cfg->ops->lib->check_ack_health &&
+	if (priv->cfg->mod_params->ack_check &&
+	    priv->cfg->ops->lib->check_ack_health &&
 	    !priv->cfg->ops->lib->check_ack_health(priv, pkt)) {
 		IWL_ERR(priv, "low ack count detected, restart firmware\n");
 		if (!iwl_force_reset(priv, IWL_FW_RESET, false))
 			return;
 	}
 
-	if (priv->cfg->ops->lib->check_plcp_health &&
+	if (priv->cfg->mod_params->plcp_check &&
+	    priv->cfg->ops->lib->check_plcp_health &&
 	    !priv->cfg->ops->lib->check_plcp_health(priv, pkt, msecs))
 		iwl_force_reset(priv, IWL_RF_RESET, false);
 }
-- 
1.7.1

