Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:56990 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757360Ab1DHPuM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Apr 2011 11:50:12 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 04/16] iwlwifi: fix bugs in change_interface
Date: Fri,  8 Apr 2011 08:30:24 -0700
Message-Id: <1302276636-12802-5-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1302276636-12802-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1302276636-12802-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

If change_interface gets invoked during a firmware
restart, it may crash; prevent that from happening
by checking if ctx->vif is assigned.

Additionally, in my initial commit I forgot to set
the vif->p2p variable correctly, so fix that too.

Cc: stable@kernel.org [2.6.38+]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 5e7281c..b5a0654 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1775,6 +1775,15 @@ int iwl_mac_change_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 
 	mutex_lock(&priv->mutex);
 
+	if (!ctx->vif || !iwl_is_ready_rf(priv)) {
+		/*
+		 * Huh? But wait ... this can maybe happen when
+		 * we're in the middle of a firmware restart!
+		 */
+		err = -EBUSY;
+		goto out;
+	}
+
 	interface_modes = ctx->interface_modes | ctx->exclusive_interface_modes;
 
 	if (!(interface_modes & BIT(newtype))) {
@@ -1802,6 +1811,7 @@ int iwl_mac_change_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	/* success */
 	iwl_teardown_interface(priv, vif, true);
 	vif->type = newtype;
+	vif->p2p = newp2p;
 	err = iwl_setup_interface(priv, ctx);
 	WARN_ON(err);
 	/*
-- 
1.7.0.4

