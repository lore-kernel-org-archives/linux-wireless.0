Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:43661 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753751AbZASX2S (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Jan 2009 18:28:18 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	"Winkler, Tomas" <tomas.winkler@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 10/15] iwlwifi: eliminate power_data_39.
Date: Mon, 19 Jan 2009 15:30:30 -0800
Message-Id: <1232407835-19451-11-git-send-email-reinette.chatre@intel.com> (sfid-20090120_002832_918589_2D21C863)
In-Reply-To: <1232407835-19451-10-git-send-email-reinette.chatre@intel.com>
References: <>
 <1232407835-19451-1-git-send-email-reinette.chatre@intel.com>
 <1232407835-19451-2-git-send-email-reinette.chatre@intel.com>
 <1232407835-19451-3-git-send-email-reinette.chatre@intel.com>
 <1232407835-19451-4-git-send-email-reinette.chatre@intel.com>
 <1232407835-19451-5-git-send-email-reinette.chatre@intel.com>
 <1232407835-19451-6-git-send-email-reinette.chatre@intel.com>
 <1232407835-19451-7-git-send-email-reinette.chatre@intel.com>
 <1232407835-19451-8-git-send-email-reinette.chatre@intel.com>
 <1232407835-19451-9-git-send-email-reinette.chatre@intel.com>
 <1232407835-19451-10-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Winkler, Tomas <tomas.winkler@intel.com>

This patch eliminates 3945 power_data structure and make use of
of iwl_power_data.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Acked-by: Mohamed Abbas <mohamed.abbas@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    1 -
 drivers/net/wireless/iwlwifi/iwl-power.c    |    8 --
 drivers/net/wireless/iwlwifi/iwl-power.h    |   16 ++--
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   94 +++++++++++----------------
 4 files changed, 45 insertions(+), 74 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 75ef8d8..9dc6e3c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1076,7 +1076,6 @@ struct iwl_priv {
 	struct iwl3945_rxon_cmd staging39_rxon;
 	struct iwl3945_rxon_cmd recovery39_rxon;
 
-	struct iwl3945_power_mgr power_data_39;
 	struct iwl3945_notif_statistics statistics_39;
 
 	struct iwl3945_station_entry stations_39[IWL_STATION_COUNT];
diff --git a/drivers/net/wireless/iwlwifi/iwl-power.c b/drivers/net/wireless/iwlwifi/iwl-power.c
index 0276d51..a463459 100644
--- a/drivers/net/wireless/iwlwifi/iwl-power.c
+++ b/drivers/net/wireless/iwlwifi/iwl-power.c
@@ -60,14 +60,6 @@
 #define IWL_POWER_RANGE_1_MAX  (10)
 
 
-#define NOSLP __constant_cpu_to_le16(0), 0, 0
-#define SLP IWL_POWER_DRIVER_ALLOW_SLEEP_MSK, 0, 0
-#define SLP_TOUT(T) __constant_cpu_to_le32((T) * MSEC_TO_USEC)
-#define SLP_VEC(X0, X1, X2, X3, X4) {__constant_cpu_to_le32(X0), \
-				     __constant_cpu_to_le32(X1), \
-				     __constant_cpu_to_le32(X2), \
-				     __constant_cpu_to_le32(X3), \
-				     __constant_cpu_to_le32(X4)}
 
 #define IWL_POWER_ON_BATTERY		IWL_POWER_INDEX_5
 #define IWL_POWER_ON_AC_DISASSOC	IWL_POWER_MODE_CAM
diff --git a/drivers/net/wireless/iwlwifi/iwl-power.h b/drivers/net/wireless/iwlwifi/iwl-power.h
index 476c2aa..859b60b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-power.h
+++ b/drivers/net/wireless/iwlwifi/iwl-power.h
@@ -66,6 +66,14 @@ enum {
 
 /* Power management (not Tx power) structures */
 
+#define NOSLP __constant_cpu_to_le16(0), 0, 0
+#define SLP IWL_POWER_DRIVER_ALLOW_SLEEP_MSK, 0, 0
+#define SLP_TOUT(T) __constant_cpu_to_le32((T) * MSEC_TO_USEC)
+#define SLP_VEC(X0, X1, X2, X3, X4) {__constant_cpu_to_le32(X0), \
+				     __constant_cpu_to_le32(X1), \
+				     __constant_cpu_to_le32(X2), \
+				     __constant_cpu_to_le32(X3), \
+				     __constant_cpu_to_le32(X4)}
 struct iwl_power_vec_entry {
 	struct iwl_powertable_cmd cmd;
 	u8 no_dtim;
@@ -86,14 +94,6 @@ struct iwl_power_mgr {
 	u8 power_disabled; /* flag to disable using power saving level */
 };
 
-struct iwl3945_power_mgr {
-	spinlock_t lock;
-	struct iwl_power_vec_entry pwr_range_0[IWL_POWER_AC];
-	struct iwl_power_vec_entry pwr_range_1[IWL_POWER_AC];
-	u8 active_index;
-	u32 dtim_val;
-};
-
 void iwl_setup_power_deferred_work(struct iwl_priv *priv);
 void iwl_power_cancel_timeout(struct iwl_priv *priv);
 int iwl_power_update_mode(struct iwl_priv *priv, bool force);
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index a986a5d..fc1c5f8 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -1324,55 +1324,41 @@ static void iwl3945_activate_qos(struct iwl_priv *priv, u8 force)
 #define MSEC_TO_USEC 1024
 
 
-#define NOSLP __constant_cpu_to_le16(0), 0, 0
-#define SLP IWL_POWER_DRIVER_ALLOW_SLEEP_MSK, 0, 0
-#define SLP_TIMEOUT(T) __constant_cpu_to_le32((T) * MSEC_TO_USEC)
-#define SLP_VEC(X0, X1, X2, X3, X4) {__constant_cpu_to_le32(X0), \
-				     __constant_cpu_to_le32(X1), \
-				     __constant_cpu_to_le32(X2), \
-				     __constant_cpu_to_le32(X3), \
-				     __constant_cpu_to_le32(X4)}
-
 /* default power management (not Tx power) table values */
 /* for TIM  0-10 */
-static struct iwl_power_vec_entry range_0[IWL39_POWER_AC] = {
-	{{NOSLP, SLP_TIMEOUT(0), SLP_TIMEOUT(0), SLP_VEC(0, 0, 0, 0, 0)}, 0},
-	{{SLP, SLP_TIMEOUT(200), SLP_TIMEOUT(500), SLP_VEC(1, 2, 3, 4, 4)}, 0},
-	{{SLP, SLP_TIMEOUT(200), SLP_TIMEOUT(300), SLP_VEC(2, 4, 6, 7, 7)}, 0},
-	{{SLP, SLP_TIMEOUT(50), SLP_TIMEOUT(100), SLP_VEC(2, 6, 9, 9, 10)}, 0},
-	{{SLP, SLP_TIMEOUT(50), SLP_TIMEOUT(25), SLP_VEC(2, 7, 9, 9, 10)}, 1},
-	{{SLP, SLP_TIMEOUT(25), SLP_TIMEOUT(25), SLP_VEC(4, 7, 10, 10, 10)}, 1}
+static struct iwl_power_vec_entry range_0[IWL_POWER_MAX] = {
+	{{NOSLP, SLP_TOUT(0), SLP_TOUT(0), SLP_VEC(0, 0, 0, 0, 0)}, 0},
+	{{SLP, SLP_TOUT(200), SLP_TOUT(500), SLP_VEC(1, 2, 3, 4, 4)}, 0},
+	{{SLP, SLP_TOUT(200), SLP_TOUT(300), SLP_VEC(2, 4, 6, 7, 7)}, 0},
+	{{SLP, SLP_TOUT(50), SLP_TOUT(100), SLP_VEC(2, 6, 9, 9, 10)}, 0},
+	{{SLP, SLP_TOUT(50), SLP_TOUT(25), SLP_VEC(2, 7, 9, 9, 10)}, 1},
+	{{SLP, SLP_TOUT(25), SLP_TOUT(25), SLP_VEC(4, 7, 10, 10, 10)}, 1}
 };
 
 /* for TIM > 10 */
-static struct iwl_power_vec_entry range_1[IWL39_POWER_AC] = {
-	{{NOSLP, SLP_TIMEOUT(0), SLP_TIMEOUT(0), SLP_VEC(0, 0, 0, 0, 0)}, 0},
-	{{SLP, SLP_TIMEOUT(200), SLP_TIMEOUT(500),
-		 SLP_VEC(1, 2, 3, 4, 0xFF)}, 0},
-	{{SLP, SLP_TIMEOUT(200), SLP_TIMEOUT(300),
-		 SLP_VEC(2, 4, 6, 7, 0xFF)}, 0},
-	{{SLP, SLP_TIMEOUT(50), SLP_TIMEOUT(100),
-		 SLP_VEC(2, 6, 9, 9, 0xFF)}, 0},
-	{{SLP, SLP_TIMEOUT(50), SLP_TIMEOUT(25), SLP_VEC(2, 7, 9, 9, 0xFF)}, 0},
-	{{SLP, SLP_TIMEOUT(25), SLP_TIMEOUT(25),
-		 SLP_VEC(4, 7, 10, 10, 0xFF)}, 0}
+static struct iwl_power_vec_entry range_1[IWL_POWER_MAX] = {
+	{{NOSLP, SLP_TOUT(0), SLP_TOUT(0), SLP_VEC(0, 0, 0, 0, 0)}, 0},
+	{{SLP, SLP_TOUT(200), SLP_TOUT(500), SLP_VEC(1, 2, 3, 4, 0xFF)}, 0},
+	{{SLP, SLP_TOUT(200), SLP_TOUT(300), SLP_VEC(2, 4, 6, 7, 0xFF)}, 0},
+	{{SLP, SLP_TOUT(50), SLP_TOUT(100), SLP_VEC(2, 6, 9, 9, 0xFF)}, 0},
+	{{SLP, SLP_TOUT(50), SLP_TOUT(25), SLP_VEC(2, 7, 9, 9, 0xFF)}, 0},
+	{{SLP, SLP_TOUT(25), SLP_TOUT(25), SLP_VEC(4, 7, 10, 10, 0xFF)}, 0}
 };
 
 int iwl3945_power_init_handle(struct iwl_priv *priv)
 {
 	int rc = 0, i;
-	struct iwl3945_power_mgr *pow_data;
-	int size = sizeof(struct iwl_power_vec_entry) * IWL39_POWER_AC;
+	struct iwl_power_mgr *pow_data;
+	int size = sizeof(struct iwl_power_vec_entry) * IWL_POWER_MAX;
 	u16 pci_pm;
 
 	IWL_DEBUG_POWER("Initialize power \n");
 
-	pow_data = &(priv->power_data_39);
+	pow_data = &priv->power_data;
 
 	memset(pow_data, 0, sizeof(*pow_data));
 
-	pow_data->active_index = IWL_POWER_RANGE_0;
-	pow_data->dtim_val = 0xffff;
+	pow_data->dtim_period = 1;
 
 	memcpy(&pow_data->pwr_range_0[0], &range_0[0], size);
 	memcpy(&pow_data->pwr_range_1[0], &range_1[0], size);
@@ -1385,7 +1371,7 @@ int iwl3945_power_init_handle(struct iwl_priv *priv)
 
 		IWL_DEBUG_POWER("adjust power command flags\n");
 
-		for (i = 0; i < IWL39_POWER_AC; i++) {
+		for (i = 0; i < IWL_POWER_MAX; i++) {
 			cmd = &pow_data->pwr_range_0[i].cmd;
 
 			if (pci_pm & 0x1)
@@ -1400,53 +1386,46 @@ int iwl3945_power_init_handle(struct iwl_priv *priv)
 static int iwl3945_update_power_cmd(struct iwl_priv *priv,
 				struct iwl_powertable_cmd *cmd, u32 mode)
 {
-	int rc = 0, i;
-	u8 skip;
-	u32 max_sleep = 0;
+	struct iwl_power_mgr *pow_data;
 	struct iwl_power_vec_entry *range;
+	u32 max_sleep = 0;
+	int i;
 	u8 period = 0;
-	struct iwl3945_power_mgr *pow_data;
+	bool skip;
 
 	if (mode > IWL_POWER_INDEX_5) {
 		IWL_DEBUG_POWER("Error invalid power mode \n");
-		return -1;
+		return -EINVAL;
 	}
-	pow_data = &(priv->power_data_39);
+	pow_data = &priv->power_data;
 
-	if (pow_data->active_index == IWL_POWER_RANGE_0)
+	if (pow_data->dtim_period < 10)
 		range = &pow_data->pwr_range_0[0];
 	else
 		range = &pow_data->pwr_range_1[1];
 
 	memcpy(cmd, &range[mode].cmd, sizeof(struct iwl3945_powertable_cmd));
 
-#ifdef IWL_MAC80211_DISABLE
-	if (priv->assoc_network != NULL) {
-		unsigned long flags;
-
-		period = priv->assoc_network->tim.tim_period;
-	}
-#endif	/*IWL_MAC80211_DISABLE */
-	skip = range[mode].no_dtim;
 
 	if (period == 0) {
 		period = 1;
-		skip = 0;
+		skip = false;
+	} else {
+		skip = !!range[mode].no_dtim;
 	}
 
-	if (skip == 0) {
-		max_sleep = period;
-		cmd->flags &= ~IWL_POWER_SLEEP_OVER_DTIM_MSK;
-	} else {
+	if (skip) {
 		__le32 slp_itrvl = cmd->sleep_interval[IWL_POWER_VEC_SIZE - 1];
 		max_sleep = (le32_to_cpu(slp_itrvl) / period) * period;
 		cmd->flags |= IWL_POWER_SLEEP_OVER_DTIM_MSK;
+	} else {
+		max_sleep = period;
+		cmd->flags &= ~IWL_POWER_SLEEP_OVER_DTIM_MSK;
 	}
 
-	for (i = 0; i < IWL_POWER_VEC_SIZE; i++) {
+	for (i = 0; i < IWL_POWER_VEC_SIZE; i++)
 		if (le32_to_cpu(cmd->sleep_interval[i]) > max_sleep)
 			cmd->sleep_interval[i] = cpu_to_le32(max_sleep);
-	}
 
 	IWL_DEBUG_POWER("Flags value = 0x%08X\n", cmd->flags);
 	IWL_DEBUG_POWER("Tx timeout = %u\n", le32_to_cpu(cmd->tx_data_timeout));
@@ -1458,7 +1437,7 @@ static int iwl3945_update_power_cmd(struct iwl_priv *priv,
 			le32_to_cpu(cmd->sleep_interval[3]),
 			le32_to_cpu(cmd->sleep_interval[4]));
 
-	return rc;
+	return 0;
 }
 
 static int iwl3945_send_power_mode(struct iwl_priv *priv, u32 mode)
@@ -6080,6 +6059,7 @@ static void iwl3945_bss_info_changed(struct ieee80211_hw *hw,
 			priv->beacon_int = bss_conf->beacon_int;
 			priv->timestamp = bss_conf->timestamp;
 			priv->assoc_capability = bss_conf->assoc_capability;
+			priv->power_data.dtim_period = bss_conf->dtim_period;
 			priv->next_scan_jiffies = jiffies +
 					IWL_DELAY_NEXT_SCAN_AFTER_ASSOC;
 			mutex_lock(&priv->mutex);
@@ -6941,7 +6921,7 @@ static int iwl3945_init_drv(struct iwl_priv *priv)
 	priv->ibss_beacon = NULL;
 
 	spin_lock_init(&priv->lock);
-	spin_lock_init(&priv->power_data_39.lock);
+	spin_lock_init(&priv->power_data.lock);
 	spin_lock_init(&priv->sta_lock);
 	spin_lock_init(&priv->hcmd_lock);
 
-- 
1.5.4.3

