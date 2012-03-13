Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43157 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755233Ab2CMPKl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Mar 2012 11:10:41 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH] iwlwifi: do not nulify ctx->vif on reset
Date: Tue, 13 Mar 2012 16:10:34 +0100
Message-Id: <1331651434-4370-1-git-send-email-sgruszka@redhat.com> (sfid-20120313_161044_513721_26122C7B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ctx->vif is dereferenced in different part of iwlwifi code, so do not
nullify it.

This should address at least one of the possible reasons of WARNING at
iwlagn_mac_remove_interface, and perhaps some random crashes when
firmware reset is performed.

Cc: stable@vger.kernel.org
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    3 ---
 drivers/net/wireless/iwlwifi/iwl-mac80211.c |   10 +++++++++-
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 28422c0..6375e5a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -862,7 +862,6 @@ static void iwl_bg_run_time_calib_work(struct work_struct *work)
 
 void iwlagn_prepare_restart(struct iwl_priv *priv)
 {
-	struct iwl_rxon_context *ctx;
 	bool bt_full_concurrent;
 	u8 bt_ci_compliance;
 	u8 bt_load;
@@ -871,8 +870,6 @@ void iwlagn_prepare_restart(struct iwl_priv *priv)
 
 	lockdep_assert_held(&priv->mutex);
 
-	for_each_context(priv, ctx)
-		ctx->vif = NULL;
 	priv->is_open = 0;
 
 	/*
diff --git a/drivers/net/wireless/iwlwifi/iwl-mac80211.c b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
index 9212ee3..4e8786d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-mac80211.c
+++ b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
@@ -1241,6 +1241,7 @@ static int iwlagn_mac_add_interface(struct ieee80211_hw *hw,
 	struct iwl_rxon_context *tmp, *ctx = NULL;
 	int err;
 	enum nl80211_iftype viftype = ieee80211_vif_type_p2p(vif);
+	bool reset = false;
 
 	IWL_DEBUG_MAC80211(priv, "enter: type %d, addr %pM\n",
 			   viftype, vif->addr);
@@ -1262,6 +1263,13 @@ static int iwlagn_mac_add_interface(struct ieee80211_hw *hw,
 			tmp->interface_modes | tmp->exclusive_interface_modes;
 
 		if (tmp->vif) {
+			/* On reset we need to add the same interface again */
+			if (tmp->vif == vif) {
+				reset = true;
+				ctx = tmp;
+				break;
+			}
+
 			/* check if this busy context is exclusive */
 			if (tmp->exclusive_interface_modes &
 						BIT(tmp->vif->type)) {
@@ -1288,7 +1296,7 @@ static int iwlagn_mac_add_interface(struct ieee80211_hw *hw,
 	ctx->vif = vif;
 
 	err = iwl_setup_interface(priv, ctx);
-	if (!err)
+	if (!err || reset)
 		goto out;
 
 	ctx->vif = NULL;
-- 
1.7.1

