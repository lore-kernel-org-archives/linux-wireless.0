Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:13395 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751611Ab2DRPFo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Apr 2012 11:05:44 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>,
	stable@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 3.4] iwlwifi: do not nulify ctx->vif on reset
Date: Wed, 18 Apr 2012 08:01:15 -0700
Message-Id: <1334761275-26557-1-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120418_170548_774157_53875E38)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Stanislaw Gruszka <sgruszka@redhat.com>

ctx->vif is dereferenced in different part of iwlwifi code, so do not
nullify it.

This should address at least one of the possible reasons of WARNING at
iwlagn_mac_remove_interface, and perhaps some random crashes when
firmware reset is performed.

Cc: stable@vger.kernel.org
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
this patch will be also available from wireless branch on
 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi.git

 drivers/net/wireless/iwlwifi/iwl-agn.c      |    3 ---
 drivers/net/wireless/iwlwifi/iwl-mac80211.c |   10 +++++++++-
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index f1226db..2a9a16f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -863,7 +863,6 @@ static void iwl_bg_run_time_calib_work(struct work_struct *work)
 
 void iwlagn_prepare_restart(struct iwl_priv *priv)
 {
-	struct iwl_rxon_context *ctx;
 	bool bt_full_concurrent;
 	u8 bt_ci_compliance;
 	u8 bt_load;
@@ -872,8 +871,6 @@ void iwlagn_prepare_restart(struct iwl_priv *priv)
 
 	lockdep_assert_held(&priv->mutex);
 
-	for_each_context(priv, ctx)
-		ctx->vif = NULL;
 	priv->is_open = 0;
 
 	/*
diff --git a/drivers/net/wireless/iwlwifi/iwl-mac80211.c b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
index b6805f8..c24a713 100644
--- a/drivers/net/wireless/iwlwifi/iwl-mac80211.c
+++ b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
@@ -1244,6 +1244,7 @@ static int iwlagn_mac_add_interface(struct ieee80211_hw *hw,
 	struct iwl_rxon_context *tmp, *ctx = NULL;
 	int err;
 	enum nl80211_iftype viftype = ieee80211_vif_type_p2p(vif);
+	bool reset = false;
 
 	IWL_DEBUG_MAC80211(priv, "enter: type %d, addr %pM\n",
 			   viftype, vif->addr);
@@ -1265,6 +1266,13 @@ static int iwlagn_mac_add_interface(struct ieee80211_hw *hw,
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
@@ -1291,7 +1299,7 @@ static int iwlagn_mac_add_interface(struct ieee80211_hw *hw,
 	ctx->vif = vif;
 
 	err = iwl_setup_interface(priv, ctx);
-	if (!err)
+	if (!err || reset)
 		goto out;
 
 	ctx->vif = NULL;
-- 
1.7.0.4

