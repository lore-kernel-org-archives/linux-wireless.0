Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:44073 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763163AbXG0J3G (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jul 2007 05:29:06 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 12/17] iwlwifi: endianity cleanup for power table host command
Date: Fri, 27 Jul 2007 17:26:36 +0800
Message-Id: <1185528423816-git-send-email-yi.zhu@intel.com>
In-Reply-To: <11855284212390-git-send-email-yi.zhu@intel.com>
References: <11855284012123-git-send-email-yi.zhu@intel.com>
 <11855284032407-git-send-email-yi.zhu@intel.com>
 <11855284053896-git-send-email-yi.zhu@intel.com>
 <11855284072074-git-send-email-yi.zhu@intel.com>
 <1185528408776-git-send-email-yi.zhu@intel.com>
 <11855284103871-git-send-email-yi.zhu@intel.com>
 <11855284122218-git-send-email-yi.zhu@intel.com>
 <11855284142478-git-send-email-yi.zhu@intel.com>
 <11855284161716-git-send-email-yi.zhu@intel.com>
 <11855284183313-git-send-email-yi.zhu@intel.com>
 <11855284201330-git-send-email-yi.zhu@intel.com>
 <11855284212390-git-send-email-yi.zhu@intel.com>
To: ipwpatch@vger.kernel.org
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch cleans up endianity issues in power table host command.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwl-base.c     |   58 ++++++++++++++++++++---------------
 drivers/net/wireless/iwl-commands.h |   23 +++++++------
 2 files changed, 45 insertions(+), 36 deletions(-)

diff --git a/drivers/net/wireless/iwl-base.c b/drivers/net/wireless/iwl-base.c
index d56360c..111e51b 100644
--- a/drivers/net/wireless/iwl-base.c
+++ b/drivers/net/wireless/iwl-base.c
@@ -2029,26 +2029,33 @@ static void iwl_activate_qos(struct iwl_priv *priv, u8 force)
 #define NOSLP 0, 0, 0
 #define SLP IWL_POWER_DRIVER_ALLOW_SLEEP_MSK, 0, 0
 #endif
+#define SLP_TIMEOUT(T)  __constant_cpu_to_le32((T) * MSEC_TO_USEC)
+#define SLP_VEC(X0, X1, X2, X3, X4) {__constant_cpu_to_le32(X0), \
+				     __constant_cpu_to_le32(X1), \
+				     __constant_cpu_to_le32(X2), \
+				     __constant_cpu_to_le32(X3), \
+				     __constant_cpu_to_le32(X4)}
+
 
 /* default power management (not Tx power) table values */
 /* for tim  0-10 */
 static struct iwl_power_vec_entry range_0[IWL_POWER_AC] = {
-	{{NOSLP, 0 * MSEC_TO_USEC, 0 * MSEC_TO_USEC, {0, 0, 0, 0, 0}}, 0},
-	{{SLP, 200 * MSEC_TO_USEC, 500 * MSEC_TO_USEC, {1, 2, 3, 4, 4}}, 0},
-	{{SLP, 200 * MSEC_TO_USEC, 300 * MSEC_TO_USEC, {2, 4, 6, 7, 7}}, 0},
-	{{SLP, 50 * MSEC_TO_USEC, 100 * MSEC_TO_USEC, {2, 6, 9, 9, 10}}, 0},
-	{{SLP, 50 * MSEC_TO_USEC, 25 * MSEC_TO_USEC, {2, 7, 9, 9, 10}}, 1},
-	{{SLP, 25 * MSEC_TO_USEC, 25 * MSEC_TO_USEC, {4, 7, 10, 10, 10}}, 1}
+	{{NOSLP, SLP_TIMEOUT(0), SLP_TIMEOUT(0), SLP_VEC(0, 0, 0, 0, 0)}, 0},
+	{{SLP, SLP_TIMEOUT(200), SLP_TIMEOUT(500), SLP_VEC(1, 2, 3, 4, 4)}, 0},
+	{{SLP, SLP_TIMEOUT(200), SLP_TIMEOUT(300), SLP_VEC(2, 4, 6, 7, 7)}, 0},
+	{{SLP, SLP_TIMEOUT(50), SLP_TIMEOUT(100), SLP_VEC(2, 6, 9, 9, 10)}, 0},
+	{{SLP, SLP_TIMEOUT(50), SLP_TIMEOUT(25), SLP_VEC(2, 7, 9, 9, 10)}, 1},
+	{{SLP, SLP_TIMEOUT(25), SLP_TIMEOUT(25), SLP_VEC(4, 7, 10, 10, 10)}, 1}
 };
 
 /* for tim > 10 */
 static struct iwl_power_vec_entry range_1[IWL_POWER_AC] = {
-	{{NOSLP, 0 * MSEC_TO_USEC, 0 * MSEC_TO_USEC, {0, 0, 0, 0, 0}}, 0},
-	{{SLP, 200 * MSEC_TO_USEC, 500 * MSEC_TO_USEC, {1, 2, 3, 4, 0xFF}}, 0},
-	{{SLP, 200 * MSEC_TO_USEC, 300 * MSEC_TO_USEC, {2, 4, 6, 7, 0xFF}}, 0},
-	{{SLP, 50 * MSEC_TO_USEC, 100 * MSEC_TO_USEC, {2, 6, 9, 9, 0xFF}}, 0},
-	{{SLP, 50 * MSEC_TO_USEC, 25 * MSEC_TO_USEC, {2, 7, 9, 9, 0xFF}}, 0},
-	{{SLP, 25 * MSEC_TO_USEC, 25 * MSEC_TO_USEC, {4, 7, 10, 10, 0xFF}}, 0}
+	{{NOSLP, SLP_TIMEOUT(0), SLP_TIMEOUT(0), SLP_VEC(0, 0, 0, 0, 0)}, 0},
+	{{SLP, SLP_TIMEOUT(200), SLP_TIMEOUT(500), SLP_VEC(1, 2, 3, 4, 0xFF)}, 0},
+	{{SLP, SLP_TIMEOUT(200), SLP_TIMEOUT(300), SLP_VEC(2, 4, 6, 7, 0xFF)}, 0},
+	{{SLP, SLP_TIMEOUT(50), SLP_TIMEOUT(100), SLP_VEC(2, 6, 9, 9, 0xFF)}, 0},
+	{{SLP, SLP_TIMEOUT(50), SLP_TIMEOUT(25), SLP_VEC(2, 7, 9, 9, 0xFF)}, 0},
+	{{SLP, SLP_TIMEOUT(25), SLP_TIMEOUT(25), SLP_VEC(4, 7, 10, 10, 0xFF)}, 0}
 };
 
 int iwl_power_init_handle(struct iwl_priv *priv)
@@ -2119,7 +2126,7 @@ static int iwl_update_power_cmd(struct iwl_priv *priv,
 
 		period = priv->assoc_network->tim.tim_period;
 	}
-#endif				/*IWL_MAC80211_DISABLE */
+#endif	/*IWL_MAC80211_DISABLE */
 	skip = range[mode].no_dtim;
 
 	if (period == 0) {
@@ -2131,24 +2138,25 @@ static int iwl_update_power_cmd(struct iwl_priv *priv,
 		max_sleep = period;
 		cmd->flags &= ~IWL_POWER_SLEEP_OVER_DTIM_MSK;
 	} else {
-		max_sleep = (cmd->sleep_interval[IWL_POWER_TABLE_SIZE - 1] /
-			     period) * period;
+		__le32 slp_itrvl = cmd->sleep_interval[IWL_POWER_VEC_SIZE - 1];
+		max_sleep = (le32_to_cpu(slp_itrvl) / period) * period;
 		cmd->flags |= IWL_POWER_SLEEP_OVER_DTIM_MSK;
 	}
 
-	for (i = 0; i < IWL_POWER_TABLE_SIZE; i++) {
-		if (cmd->sleep_interval[i] > max_sleep)
-			cmd->sleep_interval[i] = max_sleep;
+	for (i = 0; i < IWL_POWER_VEC_SIZE; i++) {
+		if (le32_to_cpu(cmd->sleep_interval[i]) > max_sleep)
+			cmd->sleep_interval[i] = cpu_to_le32(max_sleep);
 	}
 
 	IWL_DEBUG_POWER("Flags value = 0x%08X\n", cmd->flags);
-	IWL_DEBUG_POWER("Tx timeout = %u\n", cmd->tx_data_timeout);
-	IWL_DEBUG_POWER("Rx timeout = %u\n", cmd->rx_data_timeout);
-	IWL_DEBUG_POWER
-	    ("Sleep interval vector = { %d , %d , %d , %d , %d }\n",
-	     cmd->sleep_interval[0], cmd->sleep_interval[1],
-	     cmd->sleep_interval[2], cmd->sleep_interval[3],
-	     cmd->sleep_interval[4]);
+	IWL_DEBUG_POWER("Tx timeout = %u\n", le32_to_cpu(cmd->tx_data_timeout));
+	IWL_DEBUG_POWER("Rx timeout = %u\n", le32_to_cpu(cmd->rx_data_timeout));
+	IWL_DEBUG_POWER("Sleep interval vector = { %d , %d , %d , %d , %d }\n",
+			le32_to_cpu(cmd->sleep_interval[0]),
+			le32_to_cpu(cmd->sleep_interval[1]),
+			le32_to_cpu(cmd->sleep_interval[2]),
+			le32_to_cpu(cmd->sleep_interval[3]),
+			le32_to_cpu(cmd->sleep_interval[4]));
 
 	return rc;
 }
diff --git a/drivers/net/wireless/iwl-commands.h b/drivers/net/wireless/iwl-commands.h
index bd4011d..297d24a 100644
--- a/drivers/net/wireless/iwl-commands.h
+++ b/drivers/net/wireless/iwl-commands.h
@@ -648,29 +648,30 @@ struct iwl_add_sta_resp {
  * ucode assume sleep over DTIM is allowed and we don't need to wakeup
  * for every DTIM.
  */
-#define IWL_POWER_TABLE_SIZE 5
+#define IWL_POWER_VEC_SIZE 5
 
-enum {
-	IWL_POWER_DRIVER_ALLOW_SLEEP_MSK = (1<<0),
-	IWL_POWER_SLEEP_OVER_DTIM_MSK = (1<<2),
-	IWL_POWER_PCI_PM_MSK = (1<<3),
-};
+#define IWL_POWER_DRIVER_ALLOW_SLEEP_MSK	__constant_cpu_to_le32(1<<0)
+#define IWL_POWER_SLEEP_OVER_DTIM_MSK		__constant_cpu_to_le32(1<<2)
+#define IWL_POWER_PCI_PM_MSK			__constant_cpu_to_le32(1<<3)
 
-struct iwl_powertable_cmd {
 #if IWL == 3945
+struct iwl_powertable_cmd {
 	__le32 flags;
+	__le32 rx_data_timeout;
+	__le32 tx_data_timeout;
+	__le32 sleep_interval[IWL_POWER_VEC_SIZE];
+} __attribute__((packed));
 #elif IWL == 4965
+struct iwl_powertable_cmd {
 	__le16 flags;
 	u8 keep_alive_seconds;
 	u8 debug_flags;
-#endif
 	__le32 rx_data_timeout;
 	__le32 tx_data_timeout;
-	__le32 sleep_interval[IWL_POWER_TABLE_SIZE];
-#if IWL == 4965
+	__le32 sleep_interval[IWL_POWER_VEC_SIZE];
 	__le32 keep_alive_beacons;
-#endif
 } __attribute__ ((packed));
+#endif
 
 
 struct iwl_rate_scaling_info {
-- 
1.5.2
