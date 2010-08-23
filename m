Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:24115 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753962Ab0HWOxf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Aug 2010 10:53:35 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 21/26] iwlagn: add bt_ch_announce module parameter
Date: Mon, 23 Aug 2010 07:57:12 -0700
Message-Id: <1282575437-23270-22-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1282575437-23270-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1282575437-23270-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Add bt_ch_announce module parameter to enable/disable BT channel
announcement mode; default is "enable"

Based on the bt channel announcement module parameter to configure the
bt_config host command.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-6000.c |    6 ++++--
 drivers/net/wireless/iwlwifi/iwl-agn.c  |   11 +++++++++++
 drivers/net/wireless/iwlwifi/iwl-dev.h  |    1 +
 3 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index e4873cc..ebf0c7e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -242,9 +242,11 @@ static void iwl6000g2b_send_bt_config(struct iwl_priv *priv)
 	if (!bt_coex_active || priv->iw_mode == NL80211_IFTYPE_ADHOC) {
 		bt_cmd.flags = 0;
 	} else {
-		bt_cmd.flags = IWL6000G2B_BT_FLAG_CHANNEL_INHIBITION |
-				IWL6000G2B_BT_FLAG_COEX_MODE_3W <<
+		bt_cmd.flags = IWL6000G2B_BT_FLAG_COEX_MODE_3W <<
 					IWL6000G2B_BT_FLAG_COEX_MODE_SHIFT;
+		if (priv->bt_ch_announce)
+			bt_cmd.flags |= IWL6000G2B_BT_FLAG_CHANNEL_INHIBITION;
+		IWL_DEBUG_INFO(priv, "BT coex flag: 0X%x\n", bt_cmd.flags);
 	}
 
 	if (priv->bt_full_concurrent)
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 60f9799..e0592f4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -88,6 +88,7 @@ MODULE_LICENSE("GPL");
 MODULE_ALIAS("iwl4965");
 
 static int iwlagn_ant_coupling;
+static bool iwlagn_bt_ch_announce = 1;
 
 /**
  * iwl_commit_rxon - commit staging_rxon to hardware
@@ -2606,6 +2607,9 @@ int iwl_dump_nic_event_log(struct iwl_priv *priv, bool full_log,
 		return pos;
 	}
 
+	/* enable/disable bt channel announcement */
+	priv->bt_ch_announce = iwlagn_bt_ch_announce;
+
 #ifdef CONFIG_IWLWIFI_DEBUG
 	if (!(iwl_get_debug_level(priv) & IWL_DL_FW_ERRORS) && !full_log)
 		size = (size > DEFAULT_DUMP_EVENT_LOG_ENTRIES)
@@ -4147,6 +4151,9 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		(iwlagn_ant_coupling > IWL_BT_ANTENNA_COUPLING_THRESHOLD) ?
 		true : false;
 
+	/* enable/disable bt channel announcement */
+	priv->bt_ch_announce = iwlagn_bt_ch_announce;
+
 	if (iwl_alloc_traffic_mem(priv))
 		IWL_ERR(priv, "Not enough memory to generate traffic log\n");
 
@@ -4684,3 +4691,7 @@ MODULE_PARM_DESC(ucode_alternative,
 module_param_named(antenna_coupling, iwlagn_ant_coupling, int, S_IRUGO);
 MODULE_PARM_DESC(antenna_coupling,
 		 "specify antenna coupling in dB (defualt: 0 dB)");
+
+module_param_named(bt_ch_announce, iwlagn_bt_ch_announce, bool, S_IRUGO);
+MODULE_PARM_DESC(bt_ch_announce,
+		 "Enable BT channel announcement mode (default: enable)");
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 836fe27..1adb68e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1368,6 +1368,7 @@ struct iwl_priv {
 
 	/* bt coex */
 	u8 bt_traffic_load, notif_bt_traffic_load;
+	bool bt_ch_announce;
 	bool bt_sco_active;
 	bool bt_full_concurrent;
 	bool bt_ant_couple_ok;
-- 
1.7.0.4

