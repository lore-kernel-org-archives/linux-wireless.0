Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:32823 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756015Ab1DRRFl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Apr 2011 13:05:41 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 09/10] iwlagn: remove legacy ops
Date: Mon, 18 Apr 2011 09:44:16 -0700
Message-Id: <1303145057-6545-10-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1303145057-6545-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1303145057-6545-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

No longer used by _agn devices, remove it

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.h |   10 ----------
 1 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 0049790..99a91bd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -195,21 +195,11 @@ struct iwl_nic_ops {
 	void (*additional_nic_config)(struct iwl_priv *priv);
 };
 
-struct iwl_legacy_ops {
-	void (*post_associate)(struct iwl_priv *priv);
-	void (*config_ap)(struct iwl_priv *priv);
-	/* station management */
-	int (*update_bcast_stations)(struct iwl_priv *priv);
-	int (*manage_ibss_station)(struct iwl_priv *priv,
-				   struct ieee80211_vif *vif, bool add);
-};
-
 struct iwl_ops {
 	const struct iwl_lib_ops *lib;
 	const struct iwl_hcmd_ops *hcmd;
 	const struct iwl_hcmd_utils_ops *utils;
 	const struct iwl_nic_ops *nic;
-	const struct iwl_legacy_ops *legacy;
 };
 
 struct iwl_mod_params {
-- 
1.7.0.4

