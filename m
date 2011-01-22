Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:47754 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754933Ab1AVASY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Jan 2011 19:18:24 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 14/14] iwlwifi: initial P2P support
Date: Fri, 21 Jan 2011 16:06:49 -0800
Message-Id: <1295654809-5790-15-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1295654809-5790-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1295654809-5790-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

If PAN functionality is present, advertise
P2P interface type support and thus support
for P2P. However, the support is currently
somewhat incomplete -- NoA schedule isn't
added to probe responses, and 11b bitrates
may be used still, etc. Therefore, make it
all optional with a Kconfig option.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/Kconfig    |   16 ++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-agn.c  |    4 ++++
 drivers/net/wireless/iwlwifi/iwl-core.c |    5 +++--
 3 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/Kconfig b/drivers/net/wireless/iwlwifi/Kconfig
index 236f900..e1e3b1c 100644
--- a/drivers/net/wireless/iwlwifi/Kconfig
+++ b/drivers/net/wireless/iwlwifi/Kconfig
@@ -116,6 +116,22 @@ config IWL5000
 		Intel 100 Series Wi-Fi Adapters (100BGN and 130BGN)
 		Intel 2000 Series Wi-Fi Adapters
 
+config IWL_P2P
+	bool "iwlwifi experimental P2P support"
+	depends on IWL5000
+	help
+	  This option enables experimental P2P support for some devices
+	  based on microcode support. Since P2P support is still under
+	  development, this option may even enable it for some devices
+	  now that turn out to not support it in the future due to
+	  microcode restrictions.
+
+	  To determine if your microcode supports the experimental P2P
+	  offered by this option, check if the driver advertises AP
+	  support when it is loaded.
+
+	  Say Y only if you want to experiment with P2P.
+
 config IWL3945
 	tristate "Intel PRO/Wireless 3945ABG/BG Network Connection (iwl3945)"
 	depends on IWLWIFI
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 02771ef..eb16647 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -4136,6 +4136,10 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	priv->contexts[IWL_RXON_CTX_PAN].mcast_queue = IWL_IPAN_MCAST_QUEUE;
 	priv->contexts[IWL_RXON_CTX_PAN].interface_modes =
 		BIT(NL80211_IFTYPE_STATION) | BIT(NL80211_IFTYPE_AP);
+#ifdef CONFIG_IWL_P2P
+	priv->contexts[IWL_RXON_CTX_PAN].interface_modes |=
+		BIT(NL80211_IFTYPE_P2P_CLIENT) | BIT(NL80211_IFTYPE_P2P_GO);
+#endif
 	priv->contexts[IWL_RXON_CTX_PAN].ap_devtype = RXON_DEV_TYPE_CP;
 	priv->contexts[IWL_RXON_CTX_PAN].station_devtype = RXON_DEV_TYPE_2STA;
 	priv->contexts[IWL_RXON_CTX_PAN].unused_devtype = RXON_DEV_TYPE_P2P;
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 8e1b801..a46ad60 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1404,9 +1404,10 @@ int iwl_mac_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 	struct iwl_vif_priv *vif_priv = (void *)vif->drv_priv;
 	struct iwl_rxon_context *tmp, *ctx = NULL;
 	int err;
+	enum nl80211_iftype viftype = ieee80211_vif_type_p2p(vif);
 
 	IWL_DEBUG_MAC80211(priv, "enter: type %d, addr %pM\n",
-			   vif->type, vif->addr);
+			   viftype, vif->addr);
 
 	mutex_lock(&priv->mutex);
 
@@ -1430,7 +1431,7 @@ int iwl_mac_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 			continue;
 		}
 
-		if (!(possible_modes & BIT(vif->type)))
+		if (!(possible_modes & BIT(viftype)))
 			continue;
 
 		/* have maybe usable context w/o interface */
-- 
1.7.0.4

