Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:41412 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754831Ab1FXTVZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jun 2011 15:21:25 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 2/2] iwlagn: fix change_interface for P2P types
Date: Fri, 24 Jun 2011 11:49:34 -0700
Message-Id: <1308941374-29323-3-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110624_212131_143589_D1D5FE10)
In-Reply-To: <1308941374-29323-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1308941374-29323-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When an interface changes type to a P2P type,
iwlagn will erroneously set vif->type to the
P2P type and not the reduced/split type. Fix
this by keeping "newtype" in another variable
for the assignment to vif->type.

Cc: stable@kernel.org [2.6.38+]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 213c80c..45cc51c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1763,6 +1763,7 @@ int iwl_mac_change_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	struct iwl_rxon_context *ctx = iwl_rxon_ctx_from_vif(vif);
 	struct iwl_rxon_context *bss_ctx = &priv->contexts[IWL_RXON_CTX_BSS];
 	struct iwl_rxon_context *tmp;
+	enum nl80211_iftype newviftype = newtype;
 	u32 interface_modes;
 	int err;
 
@@ -1818,7 +1819,7 @@ int iwl_mac_change_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 
 	/* success */
 	iwl_teardown_interface(priv, vif, true);
-	vif->type = newtype;
+	vif->type = newviftype;
 	vif->p2p = newp2p;
 	err = iwl_setup_interface(priv, ctx);
 	WARN_ON(err);
-- 
1.7.0.4

