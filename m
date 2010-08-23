Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:27344 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753940Ab0HWOxb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Aug 2010 10:53:31 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 10/26] iwlagn: keep BT settings across restart
Date: Mon, 23 Aug 2010 07:57:01 -0700
Message-Id: <1282575437-23270-11-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1282575437-23270-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1282575437-23270-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The BT SCO needs to be re-applied to the device,
while the traffic load just needs to be correct
in software.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-6000.c |   16 ++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-agn.c  |   20 ++++++++++++++++++++
 2 files changed, 36 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 5141944..22676d9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -241,6 +241,22 @@ static void iwl6000g2b_send_bt_config(struct iwl_priv *priv)
 
 	if (iwl_send_cmd_pdu(priv, REPLY_BT_CONFIG, sizeof(bt_cmd), &bt_cmd))
 		IWL_ERR(priv, "failed to send BT Coex Config\n");
+
+	/*
+	 * When we are doing a restart, need to also reconfigure BT
+	 * SCO to the device. If not doing a restart, bt_sco_active
+	 * will always be false, so there's no need to have an extra
+	 * variable to check for it.
+	 */
+	if (priv->bt_sco_active) {
+		struct iwl6000g2b_bt_sco_cmd sco_cmd = { .flags = 0 };
+
+		if (priv->bt_sco_active)
+			sco_cmd.flags |= IWL6000G2B_BT_SCO_ACTIVE;
+		if (iwl_send_cmd_pdu(priv, REPLY_BT_COEX_SCO,
+				     sizeof(sco_cmd), &sco_cmd))
+			IWL_ERR(priv, "failed to send BT SCO command\n");
+	}
 }
 
 static struct iwl_sensitivity_ranges iwl6000_sensitivity = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index d4d08aa..9442e77 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3074,10 +3074,30 @@ static void iwl_bg_restart(struct work_struct *data)
 		return;
 
 	if (test_and_clear_bit(STATUS_FW_ERROR, &priv->status)) {
+		bool bt_sco;
+		u8 bt_load;
+
 		mutex_lock(&priv->mutex);
 		priv->vif = NULL;
 		priv->is_open = 0;
+
+		/*
+		 * __iwl_down() will clear the BT status variables,
+		 * which is correct, but when we restart we really
+		 * want to keep them so restore them afterwards.
+		 *
+		 * The restart process will later pick them up and
+		 * re-configure the hw when we reconfigure the BT
+		 * command.
+		 */
+		bt_sco = priv->bt_sco_active;
+		bt_load = priv->bt_traffic_load;
+
 		__iwl_down(priv);
+
+		priv->bt_sco_active = bt_sco;
+		priv->bt_traffic_load = bt_load;
+
 		mutex_unlock(&priv->mutex);
 		iwl_cancel_deferred_work(priv);
 		ieee80211_restart_hw(priv->hw);
-- 
1.7.0.4

