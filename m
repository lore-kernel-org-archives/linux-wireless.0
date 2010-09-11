Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:14287 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753501Ab0IKQGp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Sep 2010 12:06:45 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 06/10] iwlwifi: avoid sending too many commands
Date: Sat, 11 Sep 2010 09:08:34 -0700
Message-Id: <1284221318-28281-7-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1284221318-28281-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1284221318-28281-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When the PAN context is unused, there's no
need to continually update it in the device.
So track which contexts are active (with the
special case that the WLAN context is always
active ...) and only send their commands to
the device when needed.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c |    9 +++++++++
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    5 +++++
 drivers/net/wireless/iwlwifi/iwl-core.c     |   13 ++++++++++++-
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    7 +++++++
 4 files changed, 33 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c b/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c
index d03ba6a..a63582f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c
@@ -287,6 +287,15 @@ static int iwlagn_set_pan_params(struct iwl_priv *priv)
 	ctx_bss = &priv->contexts[IWL_RXON_CTX_BSS];
 	ctx_pan = &priv->contexts[IWL_RXON_CTX_PAN];
 
+	/*
+	 * If the PAN context is inactive, then we don't need
+	 * to update the PAN parameters, the last thing we'll
+	 * have done before it goes inactive is making the PAN
+	 * parameters be WLAN-only.
+	 */
+	if (!ctx_pan->is_active)
+		return 0;
+
 	memset(&cmd, 0, sizeof(cmd));
 
 	/* only 2 slots are currently allowed */
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index df2edcc..a19671d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -110,6 +110,9 @@ int iwl_commit_rxon(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 	if (!iwl_is_alive(priv))
 		return -EBUSY;
 
+	if (!ctx->is_active)
+		return 0;
+
 	/* always get timestamp with Rx frame */
 	ctx->staging.flags |= RXON_FLG_TSF2HOST_MSK;
 
@@ -4301,6 +4304,8 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	for (i = 0; i < NUM_IWL_RXON_CTX; i++)
 		priv->contexts[i].ctxid = i;
 
+	priv->contexts[IWL_RXON_CTX_BSS].always_active = true;
+	priv->contexts[IWL_RXON_CTX_BSS].is_active = true;
 	priv->contexts[IWL_RXON_CTX_BSS].rxon_cmd = REPLY_RXON;
 	priv->contexts[IWL_RXON_CTX_BSS].rxon_timing_cmd = REPLY_RXON_TIMING;
 	priv->contexts[IWL_RXON_CTX_BSS].rxon_assoc_cmd = REPLY_RXON_ASSOC;
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index a763103..f67cab5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -196,6 +196,9 @@ static void iwl_update_qos(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return;
 
+	if (!ctx->is_active)
+		return;
+
 	ctx->qos_data.def_qos_parm.qos_flags = 0;
 
 	if (ctx->qos_data.qos_active)
@@ -2008,9 +2011,14 @@ int iwl_mac_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 	 */
 	priv->iw_mode = vif->type;
 
+	ctx->is_active = true;
+
 	err = iwl_set_mode(priv, vif);
-	if (err)
+	if (err) {
+		if (!ctx->always_active)
+			ctx->is_active = false;
 		goto out_err;
+	}
 
 	if (priv->cfg->advanced_bt_coexist &&
 	    vif->type == NL80211_IFTYPE_ADHOC) {
@@ -2052,6 +2060,9 @@ void iwl_mac_remove_interface(struct ieee80211_hw *hw,
 	iwl_scan_cancel_timeout(priv, 100);
 	iwl_set_mode(priv, vif);
 
+	if (!ctx->always_active)
+		ctx->is_active = false;
+
 	if (priv->scan_vif == vif) {
 		scan_completed = true;
 		priv->scan_vif = NULL;
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 504ff0f..4e3a692 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1116,6 +1116,13 @@ struct iwl_rxon_context {
 	const u8 *ac_to_queue;
 	u8 mcast_queue;
 
+	/*
+	 * We could use the vif to indicate active, but we
+	 * also need it to be active during disabling when
+	 * we already removed the vif for type setting.
+	 */
+	bool always_active, is_active;
+
 	enum iwl_rxon_context_id ctxid;
 
 	u32 interface_modes, exclusive_interface_modes;
-- 
1.7.0.4

