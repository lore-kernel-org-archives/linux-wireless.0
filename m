Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:26815 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754456Ab1E0QIE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 May 2011 12:08:04 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 10/10] iwlagn: don't advertise interface combinations on device not support dualmode
Date: Fri, 27 May 2011 08:40:33 -0700
Message-Id: <1306510833-32049-11-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110527_180812_135903_150B471C)
In-Reply-To: <1306510833-32049-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1306510833-32049-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

do not advertise the limits on concurrency of virtual interfaces
if no dual-mode supports.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |   29 +++++++++++++++--------------
 1 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 42a71e5..683ceab 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2530,21 +2530,22 @@ static int iwl_mac_setup_register(struct iwl_priv *priv,
 		hw->wiphy->interface_modes |= ctx->interface_modes;
 		hw->wiphy->interface_modes |= ctx->exclusive_interface_modes;
 	}
-
-	BUILD_BUG_ON(NUM_IWL_RXON_CTX != 2);
-
-	if (hw->wiphy->interface_modes & NL80211_IFTYPE_P2P_CLIENT) {
-		hw->wiphy->iface_combinations = iwlagn_iface_combinations_p2p;
-		hw->wiphy->n_iface_combinations =
-			ARRAY_SIZE(iwlagn_iface_combinations_p2p);
-	} else if (hw->wiphy->interface_modes & NL80211_IFTYPE_AP) {
-		hw->wiphy->iface_combinations = iwlagn_iface_combinations_dualmode;
-		hw->wiphy->n_iface_combinations =
-			ARRAY_SIZE(iwlagn_iface_combinations_dualmode);
+	if (capa->flags & IWL_UCODE_TLV_FLAGS_PAN) {
+		BUILD_BUG_ON(NUM_IWL_RXON_CTX != 2);
+
+		if (hw->wiphy->interface_modes & NL80211_IFTYPE_P2P_CLIENT) {
+			hw->wiphy->iface_combinations =
+				iwlagn_iface_combinations_p2p;
+			hw->wiphy->n_iface_combinations =
+				ARRAY_SIZE(iwlagn_iface_combinations_p2p);
+		} else if (hw->wiphy->interface_modes & NL80211_IFTYPE_AP) {
+			hw->wiphy->iface_combinations =
+				iwlagn_iface_combinations_dualmode;
+			hw->wiphy->n_iface_combinations =
+				ARRAY_SIZE(iwlagn_iface_combinations_dualmode);
+		}
+		hw->wiphy->max_remain_on_channel_duration = 1000;
 	}
-
-	hw->wiphy->max_remain_on_channel_duration = 1000;
-
 	hw->wiphy->flags |= WIPHY_FLAG_CUSTOM_REGULATORY |
 			    WIPHY_FLAG_DISABLE_BEACON_HINTS |
 			    WIPHY_FLAG_IBSS_RSN;
-- 
1.7.0.4

