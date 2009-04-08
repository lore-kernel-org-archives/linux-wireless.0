Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:61547 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755621AbZDHSVO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Apr 2009 14:21:14 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 05/18] iwlwifi: add station management ops
Date: Wed,  8 Apr 2009 11:26:39 -0700
Message-Id: <1239215212-1657-6-git-send-email-reinette.chatre@intel.com> (sfid-20090408_202121_769575_5B0790DD)
In-Reply-To: <1239215212-1657-5-git-send-email-reinette.chatre@intel.com>
References: <1239215212-1657-1-git-send-email-reinette.chatre@intel.com>
 <1239215212-1657-2-git-send-email-reinette.chatre@intel.com>
 <1239215212-1657-3-git-send-email-reinette.chatre@intel.com>
 <1239215212-1657-4-git-send-email-reinette.chatre@intel.com>
 <1239215212-1657-5-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>

This patch adds declarations for station management ops to iwlwifi drivers.

Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c |   10 ++++++++++
 drivers/net/wireless/iwlwifi/iwl-4965.c |    7 +++++++
 drivers/net/wireless/iwlwifi/iwl-5000.c |    8 ++++++++
 drivers/net/wireless/iwlwifi/iwl-6000.c |    1 +
 drivers/net/wireless/iwlwifi/iwl-core.h |   13 +++++++++++++
 drivers/net/wireless/iwlwifi/iwl-dev.h  |    1 +
 6 files changed, 40 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 9a0fb80..fb08295 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -2954,6 +2954,15 @@ static struct iwl_lib_ops iwl3945_lib = {
 	.post_associate = iwl3945_post_associate,
 };
 
+static struct iwl_station_mgmt_ops iwl3945_station_mgmt = {
+	.add_station = iwl3945_add_station,
+#if 0
+	.remove_station = iwl3945_remove_station,
+#endif
+	.find_station = iwl3945_hw_find_station,
+	.clear_station_table = iwl3945_clear_stations_table,
+};
+
 static struct iwl_hcmd_utils_ops iwl3945_hcmd_utils = {
 	.get_hcmd_size = iwl3945_get_hcmd_size,
 	.build_addsta_hcmd = iwl3945_build_addsta_hcmd,
@@ -2963,6 +2972,7 @@ static struct iwl_ops iwl3945_ops = {
 	.lib = &iwl3945_lib,
 	.hcmd = &iwl3945_hcmd,
 	.utils = &iwl3945_hcmd_utils,
+	.smgmt = &iwl3945_station_mgmt,
 };
 
 static struct iwl_cfg iwl3945_bg_cfg = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 053e420..e3d1e30 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -2268,6 +2268,12 @@ static void iwl4965_cancel_deferred_work(struct iwl_priv *priv)
 	cancel_work_sync(&priv->txpower_work);
 }
 
+static struct iwl_station_mgmt_ops iwl4965_station_mgmt = {
+	.add_station_ht = iwl_add_station_flags,
+	.remove_station = iwl_remove_station,
+	.find_station = iwl_find_station,
+	.clear_station_table = iwl_clear_stations_table,
+};
 
 static struct iwl_hcmd_ops iwl4965_hcmd = {
 	.rxon_assoc = iwl4965_send_rxon_assoc,
@@ -2332,6 +2338,7 @@ static struct iwl_ops iwl4965_ops = {
 	.lib = &iwl4965_lib,
 	.hcmd = &iwl4965_hcmd,
 	.utils = &iwl4965_hcmd_utils,
+	.smgmt = &iwl4965_station_mgmt,
 };
 
 struct iwl_cfg iwl4965_agn_cfg = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 410cba2..1344943 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -1472,6 +1472,13 @@ int iwl5000_calc_rssi(struct iwl_priv *priv,
 	return max_rssi - agc - IWL49_RSSI_OFFSET;
 }
 
+struct iwl_station_mgmt_ops iwl5000_station_mgmt = {
+	.add_station_ht = iwl_add_station_flags,
+	.remove_station = iwl_remove_station,
+	.find_station = iwl_find_station,
+	.clear_station_table = iwl_clear_stations_table,
+};
+
 struct iwl_hcmd_ops iwl5000_hcmd = {
 	.rxon_assoc = iwl5000_send_rxon_assoc,
 	.commit_rxon = iwl_commit_rxon,
@@ -1535,6 +1542,7 @@ struct iwl_ops iwl5000_ops = {
 	.lib = &iwl5000_lib,
 	.hcmd = &iwl5000_hcmd,
 	.utils = &iwl5000_hcmd_utils,
+	.smgmt = &iwl5000_station_mgmt,
 };
 
 struct iwl_mod_params iwl50_mod_params = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index edfa5e1..ee271d7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -72,6 +72,7 @@ static struct iwl_ops iwl6000_ops = {
 	.lib = &iwl5000_lib,
 	.hcmd = &iwl5000_hcmd,
 	.utils = &iwl6000_hcmd_utils,
+	.smgmt = &iwl5000_station_mgmt,
 };
 
 struct iwl_cfg iwl6000_2ag_cfg = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index c7e0595..8b7f5bd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -83,10 +83,22 @@ struct iwl_cmd;
 #define IWL_SKU_A       0x2
 #define IWL_SKU_N       0x8
 
+struct iwl_station_mgmt_ops {
+	u8 (*add_station_ht)(struct iwl_priv *priv, const u8 *addr,
+			int is_ap, u8 flags, struct ieee80211_sta_ht_cap *ht_info);
+	u8 (*add_station)(struct iwl_priv *priv, const u8 *addr,
+			int is_ap, u8 flags);
+	int (*remove_station)(struct iwl_priv *priv, const u8 *addr,
+			int is_ap);
+	u8 (*find_station)(struct iwl_priv *priv, const u8 *addr);
+	void (*clear_station_table)(struct iwl_priv *priv);
+};
+
 struct iwl_hcmd_ops {
 	int (*rxon_assoc)(struct iwl_priv *priv);
 	int (*commit_rxon)(struct iwl_priv *priv);
 };
+
 struct iwl_hcmd_utils_ops {
 	u16 (*get_hcmd_size)(u8 cmd_id, u16 len);
 	u16 (*build_addsta_hcmd)(const struct iwl_addsta_cmd *cmd, u8 *data);
@@ -160,6 +172,7 @@ struct iwl_ops {
 	const struct iwl_lib_ops *lib;
 	const struct iwl_hcmd_ops *hcmd;
 	const struct iwl_hcmd_utils_ops *utils;
+	const struct iwl_station_mgmt_ops *smgmt;
 };
 
 struct iwl_mod_params {
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index ec9a138..59930f3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -70,6 +70,7 @@ extern struct iwl_ops iwl5000_ops;
 extern struct iwl_lib_ops iwl5000_lib;
 extern struct iwl_hcmd_ops iwl5000_hcmd;
 extern struct iwl_hcmd_utils_ops iwl5000_hcmd_utils;
+extern struct iwl_station_mgmt_ops iwl5000_station_mgmt;
 
 /* shared functions from iwl-5000.c */
 extern u16 iwl5000_get_hcmd_size(u8 cmd_id, u16 len);
-- 
1.5.6.3

