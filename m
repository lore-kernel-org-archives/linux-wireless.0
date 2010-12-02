Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:37673 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757797Ab0LBQ5x (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Dec 2010 11:57:53 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 5/5] iwlagn: name change for bt_ch_announce module parameter
Date: Thu,  2 Dec 2010 08:51:24 -0800
Message-Id: <1291308684-3279-6-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1291308684-3279-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1291308684-3279-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Change the module parameter name to bt_ch_inhibition from
bt_ch_announce to better describe the functionality

In order to allow Bluetooth to activate a smart AFH mechanism
and to maximize its available bandwidth the WiFi will request
BT Core to inhibit its activity in channels that interfere
with WiFi activity (and vice versa) if bt_ch_inhibition is enabled

Set module parameter "bt_ch_inhibition=0" will disable the channel
inhibition function

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 9a6f7a0..32ab4a0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2502,7 +2502,7 @@ int iwl_dump_nic_event_log(struct iwl_priv *priv, bool full_log,
 		return pos;
 	}
 
-	/* enable/disable bt channel announcement */
+	/* enable/disable bt channel inhibition */
 	priv->bt_ch_announce = iwlagn_bt_ch_announce;
 
 #ifdef CONFIG_IWLWIFI_DEBUG
@@ -4044,8 +4044,10 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		(iwlagn_ant_coupling > IWL_BT_ANTENNA_COUPLING_THRESHOLD) ?
 		true : false;
 
-	/* enable/disable bt channel announcement */
+	/* enable/disable bt channel inhibition */
 	priv->bt_ch_announce = iwlagn_bt_ch_announce;
+	IWL_DEBUG_INFO(priv, "BT channel inhibition is %s\n",
+		       (priv->bt_ch_announce) ? "On" : "Off");
 
 	if (iwl_alloc_traffic_mem(priv))
 		IWL_ERR(priv, "Not enough memory to generate traffic log\n");
@@ -4588,6 +4590,6 @@ module_param_named(antenna_coupling, iwlagn_ant_coupling, int, S_IRUGO);
 MODULE_PARM_DESC(antenna_coupling,
 		 "specify antenna coupling in dB (defualt: 0 dB)");
 
-module_param_named(bt_ch_announce, iwlagn_bt_ch_announce, bool, S_IRUGO);
-MODULE_PARM_DESC(bt_ch_announce,
-		 "Enable BT channel announcement mode (default: enable)");
+module_param_named(bt_ch_inhibition, iwlagn_bt_ch_announce, bool, S_IRUGO);
+MODULE_PARM_DESC(bt_ch_inhibition,
+		 "Disable BT channel inhibition (default: enable)");
-- 
1.7.0.4

