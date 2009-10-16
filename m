Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:62948 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754685AbZJPVZ6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Oct 2009 17:25:58 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 10/10] iwlwifi: rework for static power save
Date: Fri, 16 Oct 2009 14:25:58 -0700
Message-Id: <1255728358-29976-11-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1255728358-29976-1-git-send-email-reinette.chatre@intel.com>
References: <1255728358-29976-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

For static power save, the actual intervals are calculated by driver based on
the default table and DTIM flag, then sent to uCode when the scheme
is changed.

Three tables are defined based on DTIM period.
	1. DTIM 0 - 2
	2. DTIM 3 - 10
	3. DTIM > 11

The actual number of DTIM a station may miss may not exceed the
following:
	. Only 1 DTIM may be skipped at PI=4 when allowed
	. Only 2 DTIMs may be skipped at PI=5 when allowed
	. DTIM may be skipped only 5 sec after last activity
	. DTIM may be skipped only 30 sec after connection establishment

Only allow user to override the power_level when rf is ready to make sure
power level gets changed upon request.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-debugfs.c |    5 ++-
 drivers/net/wireless/iwlwifi/iwl-power.c   |   75 +++++++++++++++++++--------
 drivers/net/wireless/iwlwifi/iwl-power.h   |    2 +
 3 files changed, 59 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index e78cd26..8784911 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -809,9 +809,12 @@ static ssize_t iwl_dbgfs_sleep_level_override_write(struct file *file,
 	if (value != -1 && (value < 0 || value >= IWL_POWER_NUM))
 		return -EINVAL;
 
+	if (!iwl_is_ready_rf(priv))
+		return -EAGAIN;
+
 	priv->power_data.debug_sleep_level_override = value;
 
-	iwl_power_update_mode(priv, false);
+	iwl_power_update_mode(priv, true);
 
 	return count;
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-power.c b/drivers/net/wireless/iwlwifi/iwl-power.c
index 9c6b149..150ff87 100644
--- a/drivers/net/wireless/iwlwifi/iwl-power.c
+++ b/drivers/net/wireless/iwlwifi/iwl-power.c
@@ -66,7 +66,7 @@ MODULE_PARM_DESC(no_sleep_autoadjust,
 
 struct iwl_power_vec_entry {
 	struct iwl_powertable_cmd cmd;
-	u8 no_dtim;
+	u8 no_dtim;	/* number of skip dtim */
 };
 
 #define IWL_DTIM_RANGE_0_MAX	2
@@ -83,8 +83,9 @@ struct iwl_power_vec_entry {
 				     cpu_to_le32(X4)}
 /* default power management (not Tx power) table values */
 /* for DTIM period 0 through IWL_DTIM_RANGE_0_MAX */
+/* DTIM 0 - 2 */
 static const struct iwl_power_vec_entry range_0[IWL_POWER_NUM] = {
-	{{SLP, SLP_TOUT(200), SLP_TOUT(500), SLP_VEC(1, 2, 2, 2, 0xFF)}, 0},
+	{{SLP, SLP_TOUT(200), SLP_TOUT(500), SLP_VEC(1, 1, 2, 2, 0xFF)}, 0},
 	{{SLP, SLP_TOUT(200), SLP_TOUT(300), SLP_VEC(1, 2, 2, 2, 0xFF)}, 0},
 	{{SLP, SLP_TOUT(50), SLP_TOUT(100), SLP_VEC(2, 2, 2, 2, 0xFF)}, 0},
 	{{SLP, SLP_TOUT(50), SLP_TOUT(25), SLP_VEC(2, 2, 4, 4, 0xFF)}, 1},
@@ -93,15 +94,17 @@ static const struct iwl_power_vec_entry range_0[IWL_POWER_NUM] = {
 
 
 /* for DTIM period IWL_DTIM_RANGE_0_MAX + 1 through IWL_DTIM_RANGE_1_MAX */
+/* DTIM 3 - 10 */
 static const struct iwl_power_vec_entry range_1[IWL_POWER_NUM] = {
 	{{SLP, SLP_TOUT(200), SLP_TOUT(500), SLP_VEC(1, 2, 3, 4, 4)}, 0},
 	{{SLP, SLP_TOUT(200), SLP_TOUT(300), SLP_VEC(1, 2, 3, 4, 7)}, 0},
 	{{SLP, SLP_TOUT(50), SLP_TOUT(100), SLP_VEC(2, 4, 6, 7, 9)}, 0},
 	{{SLP, SLP_TOUT(50), SLP_TOUT(25), SLP_VEC(2, 4, 6, 9, 10)}, 1},
-	{{SLP, SLP_TOUT(25), SLP_TOUT(25), SLP_VEC(2, 4, 7, 10, 10)}, 2}
+	{{SLP, SLP_TOUT(25), SLP_TOUT(25), SLP_VEC(2, 4, 6, 10, 10)}, 2}
 };
 
 /* for DTIM period > IWL_DTIM_RANGE_1_MAX */
+/* DTIM 11 - */
 static const struct iwl_power_vec_entry range_2[IWL_POWER_NUM] = {
 	{{SLP, SLP_TOUT(200), SLP_TOUT(500), SLP_VEC(1, 2, 3, 4, 0xFF)}, 0},
 	{{SLP, SLP_TOUT(200), SLP_TOUT(300), SLP_VEC(2, 4, 6, 7, 0xFF)}, 0},
@@ -115,13 +118,15 @@ static void iwl_static_sleep_cmd(struct iwl_priv *priv,
 				 enum iwl_power_level lvl, int period)
 {
 	const struct iwl_power_vec_entry *table;
-	int max_sleep, i;
-	bool skip;
+	int max_sleep[IWL_POWER_VEC_SIZE] = { 0 };
+	int i;
+	u8 skip;
+	u32 slp_itrvl;
 
 	table = range_2;
-	if (period < IWL_DTIM_RANGE_1_MAX)
+	if (period <= IWL_DTIM_RANGE_1_MAX)
 		table = range_1;
-	if (period < IWL_DTIM_RANGE_0_MAX)
+	if (period <= IWL_DTIM_RANGE_0_MAX)
 		table = range_0;
 
 	BUG_ON(lvl < 0 || lvl >= IWL_POWER_NUM);
@@ -129,34 +134,60 @@ static void iwl_static_sleep_cmd(struct iwl_priv *priv,
 	*cmd = table[lvl].cmd;
 
 	if (period == 0) {
-		skip = false;
+		skip = 0;
 		period = 1;
+		for (i = 0; i < IWL_POWER_VEC_SIZE; i++)
+			max_sleep[i] =  1;
+
 	} else {
-		skip = !!table[lvl].no_dtim;
+		skip = table[lvl].no_dtim;
+		for (i = 0; i < IWL_POWER_VEC_SIZE; i++)
+			max_sleep[i] = le32_to_cpu(cmd->sleep_interval[i]);
+		max_sleep[IWL_POWER_VEC_SIZE - 1] = skip + 1;
 	}
 
-	if (skip) {
-		__le32 slp_itrvl = cmd->sleep_interval[IWL_POWER_VEC_SIZE - 1];
-		max_sleep = le32_to_cpu(slp_itrvl);
-		if (max_sleep == 0xFF)
-			max_sleep = period * (skip + 1);
-		else if (max_sleep > period)
-			max_sleep = (le32_to_cpu(slp_itrvl) / period) * period;
+	slp_itrvl = le32_to_cpu(cmd->sleep_interval[IWL_POWER_VEC_SIZE - 1]);
+	/* figure out the listen interval based on dtim period and skip */
+	if (slp_itrvl == 0xFF)
+		cmd->sleep_interval[IWL_POWER_VEC_SIZE - 1] =
+			cpu_to_le32(period * (skip + 1));
+
+	slp_itrvl = le32_to_cpu(cmd->sleep_interval[IWL_POWER_VEC_SIZE - 1]);
+	if (slp_itrvl > period)
+		cmd->sleep_interval[IWL_POWER_VEC_SIZE - 1] =
+			cpu_to_le32((slp_itrvl / period) * period);
+
+	if (skip)
 		cmd->flags |= IWL_POWER_SLEEP_OVER_DTIM_MSK;
-	} else {
-		max_sleep = period;
+	else
 		cmd->flags &= ~IWL_POWER_SLEEP_OVER_DTIM_MSK;
-	}
 
-	for (i = 0; i < IWL_POWER_VEC_SIZE; i++)
-		if (le32_to_cpu(cmd->sleep_interval[i]) > max_sleep)
-			cmd->sleep_interval[i] = cpu_to_le32(max_sleep);
+	slp_itrvl = le32_to_cpu(cmd->sleep_interval[IWL_POWER_VEC_SIZE - 1]);
+	if (slp_itrvl > IWL_CONN_LISTEN_INTERVAL)
+		cmd->sleep_interval[IWL_POWER_VEC_SIZE - 1] =
+			cpu_to_le32(IWL_CONN_LISTEN_INTERVAL);
+
+	/* enforce max sleep interval */
+	for (i = IWL_POWER_VEC_SIZE - 1; i >= 0 ; i--) {
+		if (le32_to_cpu(cmd->sleep_interval[i]) >
+		    (max_sleep[i] * period))
+			cmd->sleep_interval[i] =
+				cpu_to_le32(max_sleep[i] * period);
+		if (i != (IWL_POWER_VEC_SIZE - 1)) {
+			if (le32_to_cpu(cmd->sleep_interval[i]) >
+			    le32_to_cpu(cmd->sleep_interval[i+1]))
+				cmd->sleep_interval[i] =
+					cmd->sleep_interval[i+1];
+		}
+	}
 
 	if (priv->power_data.pci_pm)
 		cmd->flags |= IWL_POWER_PCI_PM_MSK;
 	else
 		cmd->flags &= ~IWL_POWER_PCI_PM_MSK;
 
+	IWL_DEBUG_POWER(priv, "numSkipDtim = %u, dtimPeriod = %d\n",
+			skip, period);
 	IWL_DEBUG_POWER(priv, "Sleep command for index %d\n", lvl + 1);
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-power.h b/drivers/net/wireless/iwlwifi/iwl-power.h
index 310c32e..0755518 100644
--- a/drivers/net/wireless/iwlwifi/iwl-power.h
+++ b/drivers/net/wireless/iwlwifi/iwl-power.h
@@ -30,6 +30,8 @@
 
 #include "iwl-commands.h"
 
+#define IWL_CONN_LISTEN_INTERVAL	10
+
 #define IWL_ABSOLUTE_ZERO		0
 #define IWL_ABSOLUTE_MAX		0xFFFFFFFF
 #define IWL_TT_INCREASE_MARGIN	5
-- 
1.5.6.3

