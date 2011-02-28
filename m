Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58331 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753793Ab1B1Ndq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Feb 2011 08:33:46 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH v3 3/5] iwlwifi: add {ack,plpc}_check module parameters
Date: Mon, 28 Feb 2011 14:33:15 +0100
Message-Id: <1298899997-2372-3-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1298899997-2372-1-git-send-email-sgruszka@redhat.com>
References: <1298899997-2372-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add module ack_check, and plcp_check parameters. Ack_check is disabled
by default since is proved that check ack health can cause troubles.
Plcp_check is enabled by default.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c |    1 +
 drivers/net/wireless/iwlwifi/iwl-agn.c     |    6 ++++++
 drivers/net/wireless/iwlwifi/iwl-core.h    |    2 ++
 drivers/net/wireless/iwlwifi/iwl-rx.c      |    8 ++++++--
 4 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 0d0572c..693a1fa 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -609,6 +609,7 @@ const u8 *iwlagn_eeprom_query_addr(const struct iwl_priv *priv,
 struct iwl_mod_params iwlagn_mod_params = {
 	.amsdu_size_8K = 1,
 	.restart_fw = 1,
+	.plcp_check = true,
 	/* the rest are 0 by default */
 };
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 8cdbd8c..4792418 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -4785,3 +4785,9 @@ MODULE_PARM_DESC(antenna_coupling,
 module_param_named(bt_ch_inhibition, iwlagn_bt_ch_announce, bool, S_IRUGO);
 MODULE_PARM_DESC(bt_ch_inhibition,
 		 "Disable BT channel inhibition (default: enable)");
+
+module_param_named(plcp_check, iwlagn_mod_params.plcp_check, bool, S_IRUGO);
+MODULE_PARM_DESC(plcp_check, "Check plcp health (default: 1 [enabled])");
+
+module_param_named(ack_check, iwlagn_mod_params.ack_check, bool, S_IRUGO);
+MODULE_PARM_DESC(ack_check, "Check ack health (default: 0 [disabled])");
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index ed701f9..fac3a6c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -261,6 +261,8 @@ struct iwl_mod_params {
 	int amsdu_size_8K;	/* def: 1 = enable 8K amsdu size */
 	int antenna;  		/* def: 0 = both antennas (use diversity) */
 	int restart_fw;		/* def: 1 = restart firmware */
+	bool plcp_check;	/* def: true = enable plcp health check */
+	bool ack_check;		/* def: false = disable ack health check */
 };
 
 /*
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index a21f6fe..fd84d53 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -230,18 +230,22 @@ void iwl_rx_spectrum_measure_notif(struct iwl_priv *priv,
 void iwl_recover_from_statistics(struct iwl_priv *priv,
 				struct iwl_rx_packet *pkt)
 {
+	const struct iwl_mod_params *mod_params = priv->cfg->mod_params;
+
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status) ||
 	    !iwl_is_any_associated(priv))
 		return;
 
-	if (priv->cfg->ops->lib->check_ack_health &&
+	if (mod_params->ack_check &&
+	    priv->cfg->ops->lib->check_ack_health &&
 	    !priv->cfg->ops->lib->check_ack_health(priv, pkt)) {
 		IWL_ERR(priv, "low ack count detected, restart firmware\n");
 		if (!iwl_force_reset(priv, IWL_FW_RESET, false))
 			return;
 	}
 
-	if (priv->cfg->ops->lib->check_plcp_health &&
+	if (mod_params->plcp_check &&
+	    priv->cfg->ops->lib->check_plcp_health &&
 	    !priv->cfg->ops->lib->check_plcp_health(priv, pkt))
 		iwl_force_reset(priv, IWL_RF_RESET, false);
 }
-- 
1.7.1

