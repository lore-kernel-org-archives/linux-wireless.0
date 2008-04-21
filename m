Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:22816 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753989AbYDUWmQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Apr 2008 18:42:16 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Mohamed Abbas <mabbas@linux.intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 01/11] iwlwifi: Add power level support
Date: Mon, 21 Apr 2008 15:41:51 -0700
Message-Id: <1208817721-11333-2-git-send-email-reinette.chatre@intel.com> (sfid-20080422_004343_660810_B14B31E4)
In-Reply-To: <1208817721-11333-1-git-send-email-reinette.chatre@intel.com>
References: <1208817721-11333-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohamed Abbas <mabbas@linux.intel.com>

Add power level support

Signed-off-by: Mohamed Abbas <mabbas@linux.intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/Makefile            |    2 +-
 drivers/net/wireless/iwlwifi/iwl-4965-commands.h |    1 +
 drivers/net/wireless/iwlwifi/iwl-4965.c          |   15 +-
 drivers/net/wireless/iwlwifi/iwl-4965.h          |   29 +--
 drivers/net/wireless/iwlwifi/iwl-core.c          |    3 +
 drivers/net/wireless/iwlwifi/iwl-core.h          |    3 +
 drivers/net/wireless/iwlwifi/iwl-power.c         |  423 ++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-power.h         |   76 ++++
 drivers/net/wireless/iwlwifi/iwl4965-base.c      |  217 +----------
 9 files changed, 543 insertions(+), 226 deletions(-)
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-power.c
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-power.h

diff --git a/drivers/net/wireless/iwlwifi/Makefile b/drivers/net/wireless/iwlwifi/Makefile
index ff56805..e83dd68 100644
--- a/drivers/net/wireless/iwlwifi/Makefile
+++ b/drivers/net/wireless/iwlwifi/Makefile
@@ -1,5 +1,5 @@
 obj-$(CONFIG_IWLCORE)	:= iwlcore.o
-iwlcore-objs 		:= iwl-core.o iwl-eeprom.o iwl-hcmd.o
+iwlcore-objs 		:= iwl-core.o iwl-eeprom.o iwl-hcmd.o iwl-power.o
 iwlcore-$(CONFIG_IWLWIFI_DEBUGFS) += iwl-debugfs.o
 iwlcore-$(CONFIG_IWLWIFI_LEDS) += iwl-led.o
 iwlcore-$(CONFIG_IWLWIFI_RFKILL) += iwl-rfkill.o
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-commands.h b/drivers/net/wireless/iwlwifi/iwl-4965-commands.h
index c03c04f..b2fa58d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-commands.h
@@ -1853,6 +1853,7 @@ struct iwl4965_spectrum_notification {
 #define IWL_POWER_DRIVER_ALLOW_SLEEP_MSK	__constant_cpu_to_le16(1 << 0)
 #define IWL_POWER_SLEEP_OVER_DTIM_MSK		__constant_cpu_to_le16(1 << 2)
 #define IWL_POWER_PCI_PM_MSK			__constant_cpu_to_le16(1 << 3)
+#define IWL_POWER_FAST_PD			__constant_cpu_to_le16(1 << 4)
 
 struct iwl4965_powertable_cmd {
 	__le16 flags;
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 2b9471f..d051aac 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -702,8 +702,6 @@ int iwl4965_hw_nic_init(struct iwl_priv *priv)
 	u32 val;
 	u8 val_link;
 
-	iwl4965_power_init_handle(priv);
-
 	/* nic_init */
 	spin_lock_irqsave(&priv->lock, flags);
 
@@ -1433,6 +1431,17 @@ int iwl4965_hw_txq_free_tfd(struct iwl_priv *priv, struct iwl4965_tx_queue *txq)
 	return 0;
 }
 
+/* set card power command */
+static int iwl4965_set_power(struct iwl_priv *priv,
+		      void *cmd)
+{
+	int ret = 0;
+
+	ret = iwl_send_cmd_pdu_async(priv, POWER_TABLE_CMD,
+				    sizeof(struct iwl4965_powertable_cmd),
+				    cmd, NULL);
+	return ret;
+}
 int iwl4965_hw_reg_set_txpower(struct iwl_priv *priv, s8 power)
 {
 	IWL_ERROR("TODO: Implement iwl4965_hw_reg_set_txpower!\n");
@@ -4336,6 +4345,8 @@ static struct iwl_lib_ops iwl4965_lib = {
 		.release_semaphore = iwlcore_eeprom_release_semaphore,
 	},
 	.radio_kill_sw = iwl4965_radio_kill_sw,
+	.set_power = iwl4965_set_power,
+	.update_chain_flags = iwl4965_update_chain_flags,
 };
 
 static struct iwl_ops iwl4965_ops = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.h b/drivers/net/wireless/iwlwifi/iwl-4965.h
index b8c86c7..478f03f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.h
@@ -44,6 +44,7 @@
 #include "iwl-prph.h"
 #include "iwl-debug.h"
 #include "iwl-led.h"
+#include "iwl-power.h"
 
 /* configuration for the iwl4965 */
 extern struct iwl_cfg iwl4965_agn_cfg;
@@ -257,31 +258,6 @@ enum iwl_pwr_src {
 	IWL_PWR_SRC_VAUX,
 };
 
-struct iwl4965_power_vec_entry {
-	struct iwl4965_powertable_cmd cmd;
-	u8 no_dtim;
-};
-#define IWL_POWER_RANGE_0  (0)
-#define IWL_POWER_RANGE_1  (1)
-
-#define IWL_POWER_MODE_CAM	0x00	/* Continuously Aware Mode, always on */
-#define IWL_POWER_INDEX_3	0x03
-#define IWL_POWER_INDEX_5	0x05
-#define IWL_POWER_AC		0x06
-#define IWL_POWER_BATTERY	0x07
-#define IWL_POWER_LIMIT		0x07
-#define IWL_POWER_MASK		0x0F
-#define IWL_POWER_ENABLED	0x10
-#define IWL_POWER_LEVEL(x)	((x) & IWL_POWER_MASK)
-
-struct iwl4965_power_mgr {
-	spinlock_t lock;
-	struct iwl4965_power_vec_entry pwr_range_0[IWL_POWER_AC];
-	struct iwl4965_power_vec_entry pwr_range_1[IWL_POWER_AC];
-	u8 active_index;
-	u32 dtim_val;
-};
-
 #define IEEE80211_DATA_LEN              2304
 #define IEEE80211_4ADDR_LEN             30
 #define IEEE80211_HLEN                  (IEEE80211_4ADDR_LEN)
@@ -674,6 +650,7 @@ extern unsigned int iwl4965_fill_beacon_frame(struct iwl_priv *priv,
 extern int iwl4965_rx_queue_update_write_ptr(struct iwl_priv *priv,
 					 struct iwl4965_rx_queue *q);
 extern __le16 *ieee80211_get_qos_ctrl(struct ieee80211_hdr *hdr);
+extern void iwl4965_update_chain_flags(struct iwl_priv *priv);
 int iwl4965_set_pwr_src(struct iwl_priv *priv, enum iwl_pwr_src src);
 
 int iwl4965_init_geos(struct iwl_priv *priv);
@@ -1101,7 +1078,7 @@ struct iwl_priv {
 		u64 bytes;
 	} tx_stats[3], rx_stats[3];
 
-	struct iwl4965_power_mgr power_data;
+	struct iwl_power_mgr power_data;
 
 	struct iwl4965_notif_statistics statistics;
 	unsigned long last_statistics_time;
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 2dfd982..c336b19 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -37,6 +37,7 @@ struct iwl_priv; /* FIXME: remove */
 #include "iwl-4965.h" /* FIXME: remove */
 #include "iwl-core.h"
 #include "iwl-rfkill.h"
+#include "iwl-power.h"
 
 
 MODULE_DESCRIPTION("iwl core");
@@ -263,8 +264,10 @@ int iwlcore_low_level_notify(struct iwl_priv *priv,
 		if (ret)
 			IWL_ERROR("Unable to initialize RFKILL system. "
 				  "Ignoring error: %d\n", ret);
+		iwl_power_initialize(priv);
 		break;
 	case IWLCORE_START_EVT:
+		iwl_power_update_mode(priv, 1);
 		break;
 	case IWLCORE_STOP_EVT:
 		break;
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 51f61fb..3d113dc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -118,6 +118,9 @@ struct iwl_lib_ops {
 	struct {
 		int (*set_pwr_src)(struct iwl_priv *priv, enum iwl_pwr_src src);
 	} apm_ops;
+	/* power */
+	int (*set_power)(struct iwl_priv *priv, void *cmd);
+	void (*update_chain_flags)(struct iwl_priv *priv);
 	/* eeprom operations (as defined in iwl-eeprom.h) */
 	struct iwl_eeprom_ops eeprom_ops;
 };
diff --git a/drivers/net/wireless/iwlwifi/iwl-power.c b/drivers/net/wireless/iwlwifi/iwl-power.c
new file mode 100644
index 0000000..a242628
--- /dev/null
+++ b/drivers/net/wireless/iwlwifi/iwl-power.c
@@ -0,0 +1,423 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2007 - 2008 Intel Corporation. All rights reserved.
+ *
+ * Portions of this file are derived from the ipw3945 project, as well
+ * as portions of the ieee80211 subsystem header files.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
+ *
+ * The full GNU General Public License is included in this distribution in the
+ * file called LICENSE.
+ *
+ * Contact Information:
+ * James P. Ketrenos <ipw2100-admin@linux.intel.com>
+ * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
+ *****************************************************************************/
+
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/version.h>
+#include <linux/init.h>
+
+#include <net/mac80211.h>
+
+#include "iwl-eeprom.h"
+#include "iwl-4965.h"
+#include "iwl-core.h"
+#include "iwl-4965-commands.h"
+#include "iwl-debug.h"
+#include "iwl-power.h"
+#include "iwl-helpers.h"
+
+/*
+ * Setting power level allow the card to go to sleep when not busy
+ * there are three factor that decide the power level to go to, they
+ * are list here with its priority
+ *  1- critical_power_setting this will be set according to card temperature.
+ *  2- system_power_setting this will be set by system PM manager.
+ *  3- user_power_setting this will be set by user either by writing to sys or
+ *  	mac80211
+ *
+ * if system_power_setting and user_power_setting is set to auto
+ * the power level will be decided according to association status and battery
+ * status.
+ *
+ */
+
+#define MSEC_TO_USEC 1024
+#define IWL_POWER_RANGE_0_MAX  (2)
+#define IWL_POWER_RANGE_1_MAX  (10)
+
+
+#define NOSLP __constant_cpu_to_le16(0), 0, 0
+#define SLP IWL_POWER_DRIVER_ALLOW_SLEEP_MSK, 0, 0
+#define SLP_TOUT(T) __constant_cpu_to_le32((T) * MSEC_TO_USEC)
+#define SLP_VEC(X0, X1, X2, X3, X4) {__constant_cpu_to_le32(X0), \
+				     __constant_cpu_to_le32(X1), \
+				     __constant_cpu_to_le32(X2), \
+				     __constant_cpu_to_le32(X3), \
+				     __constant_cpu_to_le32(X4)}
+
+#define IWL_POWER_ON_BATTERY		IWL_POWER_INDEX_5
+#define IWL_POWER_ON_AC_DISASSOC	IWL_POWER_MODE_CAM
+#define IWL_POWER_ON_AC_ASSOC		IWL_POWER_MODE_CAM
+
+
+#define IWL_CT_KILL_TEMPERATURE		110
+#define IWL_MIN_POWER_TEMPERATURE	100
+#define IWL_REDUCED_POWER_TEMPERATURE	95
+
+/* default power management (not Tx power) table values */
+/* for tim  0-10 */
+static struct iwl_power_vec_entry range_0[IWL_POWER_AC] = {
+	{{NOSLP, SLP_TOUT(0), SLP_TOUT(0), SLP_VEC(0, 0, 0, 0, 0)}, 0},
+	{{SLP, SLP_TOUT(200), SLP_TOUT(500), SLP_VEC(1, 2, 2, 2, 0xFF)}, 0},
+	{{SLP, SLP_TOUT(200), SLP_TOUT(300), SLP_VEC(1, 2, 2, 2, 0xFF)}, 0},
+	{{SLP, SLP_TOUT(50), SLP_TOUT(100), SLP_VEC(2, 2, 2, 2, 0xFF)}, 0},
+	{{SLP, SLP_TOUT(50), SLP_TOUT(25), SLP_VEC(2, 2, 4, 4, 0xFF)}, 1},
+	{{SLP, SLP_TOUT(25), SLP_TOUT(25), SLP_VEC(2, 2, 4, 6, 0xFF)}, 2}
+};
+
+
+/* for tim = 3-10 */
+static struct iwl_power_vec_entry range_1[IWL_POWER_AC] = {
+	{{NOSLP, SLP_TOUT(0), SLP_TOUT(0), SLP_VEC(0, 0, 0, 0, 0)}, 0},
+	{{SLP, SLP_TOUT(200), SLP_TOUT(500), SLP_VEC(1, 2, 3, 4, 4)}, 0},
+	{{SLP, SLP_TOUT(200), SLP_TOUT(300), SLP_VEC(1, 2, 3, 4, 7)}, 0},
+	{{SLP, SLP_TOUT(50), SLP_TOUT(100), SLP_VEC(2, 4, 6, 7, 9)}, 0},
+	{{SLP, SLP_TOUT(50), SLP_TOUT(25), SLP_VEC(2, 4, 6, 9, 10)}, 1},
+	{{SLP, SLP_TOUT(25), SLP_TOUT(25), SLP_VEC(2, 4, 7, 10, 10)}, 2}
+};
+
+/* for tim > 11 */
+static struct iwl_power_vec_entry range_2[IWL_POWER_AC] = {
+	{{NOSLP, SLP_TOUT(0), SLP_TOUT(0), SLP_VEC(0, 0, 0, 0, 0)}, 0},
+	{{SLP, SLP_TOUT(200), SLP_TOUT(500), SLP_VEC(1, 2, 3, 4, 0xFF)}, 0},
+	{{SLP, SLP_TOUT(200), SLP_TOUT(300), SLP_VEC(2, 4, 6, 7, 0xFF)}, 0},
+	{{SLP, SLP_TOUT(50), SLP_TOUT(100), SLP_VEC(2, 7, 9, 9, 0xFF)}, 0},
+	{{SLP, SLP_TOUT(50), SLP_TOUT(25), SLP_VEC(2, 7, 9, 9, 0xFF)}, 0},
+	{{SLP, SLP_TOUT(25), SLP_TOUT(25), SLP_VEC(4, 7, 10, 10, 0xFF)}, 0}
+};
+
+/* decide the right power level according to association status
+ * and battery status
+ */
+static u16 iwl_get_auto_power_mode(struct iwl_priv *priv)
+{
+	u16 mode = priv->power_data.user_power_setting;
+
+	switch (priv->power_data.user_power_setting) {
+	case IWL_POWER_AUTO:
+		/* if running on battery */
+		if (priv->power_data.is_battery_active)
+			mode = IWL_POWER_ON_BATTERY;
+		else if (iwl_is_associated(priv))
+			mode = IWL_POWER_ON_AC_ASSOC;
+		else
+			mode = IWL_POWER_ON_AC_DISASSOC;
+		break;
+	case IWL_POWER_BATTERY:
+		mode = IWL_POWER_INDEX_3;
+		break;
+	case IWL_POWER_AC:
+		mode = IWL_POWER_MODE_CAM;
+		break;
+	}
+	return mode;
+}
+
+/* initialize to default */
+static int iwl_power_init_handle(struct iwl_priv *priv)
+{
+	int ret = 0, i;
+	struct iwl_power_mgr *pow_data;
+	int size = sizeof(struct iwl_power_vec_entry) * IWL_POWER_AC;
+	u16 pci_pm;
+
+	IWL_DEBUG_POWER("Initialize power \n");
+
+	pow_data = &(priv->power_data);
+
+	memset(pow_data, 0, sizeof(*pow_data));
+
+	memcpy(&pow_data->pwr_range_0[0], &range_0[0], size);
+	memcpy(&pow_data->pwr_range_1[0], &range_1[0], size);
+	memcpy(&pow_data->pwr_range_2[0], &range_2[0], size);
+
+	ret = pci_read_config_word(priv->pci_dev,
+				  PCI_LINK_CTRL, &pci_pm);
+	if (ret != 0)
+		return 0;
+	else {
+		struct iwl4965_powertable_cmd *cmd;
+
+		IWL_DEBUG_POWER("adjust power command flags\n");
+
+		for (i = 0; i < IWL_POWER_AC; i++) {
+			cmd = &pow_data->pwr_range_0[i].cmd;
+
+			if (pci_pm & 0x1)
+				cmd->flags &= ~IWL_POWER_PCI_PM_MSK;
+			else
+				cmd->flags |= IWL_POWER_PCI_PM_MSK;
+		}
+	}
+	return ret;
+}
+
+/* adjust power command according to dtim period and power level*/
+static int iwl_update_power_command(struct iwl_priv *priv,
+				    struct iwl4965_powertable_cmd *cmd,
+				    u16 mode)
+{
+	int ret = 0, i;
+	u8 skip;
+	u32 max_sleep = 0;
+	struct iwl_power_vec_entry *range;
+	u8 period = 0;
+	struct iwl_power_mgr *pow_data;
+
+	if (mode > IWL_POWER_INDEX_5) {
+		IWL_DEBUG_POWER("Error invalid power mode \n");
+		return -1;
+	}
+	pow_data = &(priv->power_data);
+
+	if (pow_data->dtim_period <= IWL_POWER_RANGE_0_MAX)
+		range = &pow_data->pwr_range_0[0];
+	else if (pow_data->dtim_period <= IWL_POWER_RANGE_1_MAX)
+		range = &pow_data->pwr_range_1[0];
+	else
+		range = &pow_data->pwr_range_2[0];
+
+	period = pow_data->dtim_period;
+	memcpy(cmd, &range[mode].cmd, sizeof(struct iwl4965_powertable_cmd));
+
+	if (period == 0) {
+		period = 1;
+		skip = 0;
+	} else
+		skip = range[mode].no_dtim;
+
+	if (skip == 0) {
+		max_sleep = period;
+		cmd->flags &= ~IWL_POWER_SLEEP_OVER_DTIM_MSK;
+	} else {
+		__le32 slp_itrvl = cmd->sleep_interval[IWL_POWER_VEC_SIZE - 1];
+		max_sleep = le32_to_cpu(slp_itrvl);
+		if (max_sleep == 0xFF)
+			max_sleep = period * (skip + 1);
+		else if (max_sleep >  period)
+			max_sleep = (le32_to_cpu(slp_itrvl) / period) * period;
+		cmd->flags |= IWL_POWER_SLEEP_OVER_DTIM_MSK;
+	}
+
+	for (i = 0; i < IWL_POWER_VEC_SIZE; i++) {
+		if (le32_to_cpu(cmd->sleep_interval[i]) > max_sleep)
+			cmd->sleep_interval[i] = cpu_to_le32(max_sleep);
+	}
+
+	IWL_DEBUG_POWER("Flags value = 0x%08X\n", cmd->flags);
+	IWL_DEBUG_POWER("Tx timeout = %u\n", le32_to_cpu(cmd->tx_data_timeout));
+	IWL_DEBUG_POWER("Rx timeout = %u\n", le32_to_cpu(cmd->rx_data_timeout));
+	IWL_DEBUG_POWER("Sleep interval vector = { %d , %d , %d , %d , %d }\n",
+			le32_to_cpu(cmd->sleep_interval[0]),
+			le32_to_cpu(cmd->sleep_interval[1]),
+			le32_to_cpu(cmd->sleep_interval[2]),
+			le32_to_cpu(cmd->sleep_interval[3]),
+			le32_to_cpu(cmd->sleep_interval[4]));
+
+	return ret;
+}
+
+
+/*
+ * calucaute the final power mode index
+ */
+int iwl_power_update_mode(struct iwl_priv *priv, u8 refresh)
+{
+	struct iwl_power_mgr *setting = &(priv->power_data);
+	int ret = 0;
+	u16 uninitialized_var(final_mode);
+
+       /* If on battery, set to 3,
+	* if plugged into AC power, set to CAM ("continuously aware mode"),
+	* else user level */
+
+	switch (setting->system_power_setting) {
+	case IWL_POWER_AUTO:
+		final_mode = iwl_get_auto_power_mode(priv);
+		break;
+	case IWL_POWER_BATTERY:
+		final_mode = IWL_POWER_INDEX_3;
+		break;
+	case IWL_POWER_AC:
+		final_mode = IWL_POWER_MODE_CAM;
+		break;
+	default:
+		final_mode = setting->system_power_setting;
+	}
+
+	if (setting->critical_power_setting > final_mode)
+		final_mode = setting->critical_power_setting;
+
+	/* driver only support CAM for non STA network */
+	if (priv->iw_mode != IEEE80211_IF_TYPE_STA)
+		final_mode = IWL_POWER_MODE_CAM;
+
+	if (!iwl_is_rfkill(priv) && !setting->power_disabled &&
+	    ((setting->power_mode != final_mode) || refresh)) {
+		struct iwl4965_powertable_cmd cmd;
+
+		if (final_mode != IWL_POWER_MODE_CAM)
+			set_bit(STATUS_POWER_PMI, &priv->status);
+
+		iwl_update_power_command(priv, &cmd, final_mode);
+		cmd.keep_alive_beacons = 0;
+
+		if (final_mode == IWL_POWER_INDEX_5)
+			cmd.flags |= IWL_POWER_FAST_PD;
+
+		if (priv->cfg->ops->lib->set_power)
+			ret = priv->cfg->ops->lib->set_power(priv, &cmd);
+
+		if (final_mode == IWL_POWER_MODE_CAM)
+			clear_bit(STATUS_POWER_PMI, &priv->status);
+		else
+			set_bit(STATUS_POWER_PMI, &priv->status);
+
+		if (priv->cfg->ops->lib->update_chain_flags)
+			priv->cfg->ops->lib->update_chain_flags(priv);
+
+		if (!ret)
+			setting->power_mode = final_mode;
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL(iwl_power_update_mode);
+
+/* Allow other iwl code to disable/enable power management active
+ * this will be usefull for rate scale to disable PM during heavy
+ * Tx/Rx activities
+ */
+int iwl_power_disable_management(struct iwl_priv *priv)
+{
+	u16 prev_mode;
+	int ret = 0;
+
+	if (priv->power_data.power_disabled)
+		return -EBUSY;
+
+	prev_mode = priv->power_data.user_power_setting;
+	priv->power_data.user_power_setting = IWL_POWER_MODE_CAM;
+	ret = iwl_power_update_mode(priv, 0);
+	priv->power_data.power_disabled = 1;
+	priv->power_data.user_power_setting = prev_mode;
+
+	return ret;
+}
+EXPORT_SYMBOL(iwl_power_disable_management);
+
+/* Allow other iwl code to disable/enable power management active
+ * this will be usefull for rate scale to disable PM during hight
+ * valume activities
+ */
+int iwl_power_enable_management(struct iwl_priv *priv)
+{
+	int ret = 0;
+
+	priv->power_data.power_disabled = 0;
+	ret = iwl_power_update_mode(priv, 0);
+	return ret;
+}
+EXPORT_SYMBOL(iwl_power_enable_management);
+
+/* set user_power_setting */
+int iwl_power_set_user_mode(struct iwl_priv *priv, u16 mode)
+{
+	int ret = 0;
+
+	if (mode > IWL_POWER_LIMIT)
+		return -EINVAL;
+
+	priv->power_data.user_power_setting = mode;
+
+	ret = iwl_power_update_mode(priv, 0);
+
+	return ret;
+}
+EXPORT_SYMBOL(iwl_power_set_user_mode);
+
+
+/* set system_power_setting. This should be set by over all
+ * PM application.
+ */
+int iwl_power_set_system_mode(struct iwl_priv *priv, u16 mode)
+{
+	int ret = 0;
+
+	if (mode > IWL_POWER_LIMIT)
+		return -EINVAL;
+
+	priv->power_data.system_power_setting = mode;
+
+	ret = iwl_power_update_mode(priv, 0);
+
+	return ret;
+}
+EXPORT_SYMBOL(iwl_power_set_system_mode);
+
+/* initilize to default */
+void iwl_power_initialize(struct iwl_priv *priv)
+{
+
+	iwl_power_init_handle(priv);
+	priv->power_data.user_power_setting = IWL_POWER_AUTO;
+	priv->power_data.power_disabled = 0;
+	priv->power_data.system_power_setting = IWL_POWER_AUTO;
+	priv->power_data.is_battery_active = 0;
+	priv->power_data.power_disabled = 0;
+	priv->power_data.critical_power_setting = 0;
+}
+EXPORT_SYMBOL(iwl_power_initialize);
+
+/* set critical_power_setting according to temperature value */
+int iwl_power_temperature_change(struct iwl_priv *priv)
+{
+	int ret = 0;
+	u16 new_critical = priv->power_data.critical_power_setting;
+	s32 temperature = KELVIN_TO_CELSIUS(priv->last_temperature);
+
+	if (temperature > IWL_CT_KILL_TEMPERATURE)
+		return 0;
+	else if (temperature > IWL_MIN_POWER_TEMPERATURE)
+		new_critical = IWL_POWER_INDEX_5;
+	else if (temperature > IWL_REDUCED_POWER_TEMPERATURE)
+		new_critical = IWL_POWER_INDEX_3;
+	else
+		new_critical = IWL_POWER_MODE_CAM;
+
+	if (new_critical != priv->power_data.critical_power_setting)
+		priv->power_data.critical_power_setting = new_critical;
+
+	if (priv->power_data.critical_power_setting >
+				priv->power_data.power_mode)
+		ret = iwl_power_update_mode(priv, 0);
+
+	return ret;
+}
+EXPORT_SYMBOL(iwl_power_temperature_change);
diff --git a/drivers/net/wireless/iwlwifi/iwl-power.h b/drivers/net/wireless/iwlwifi/iwl-power.h
new file mode 100644
index 0000000..aad2784
--- /dev/null
+++ b/drivers/net/wireless/iwlwifi/iwl-power.h
@@ -0,0 +1,76 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2007 - 2008 Intel Corporation. All rights reserved.
+ *
+ * Portions of this file are derived from the ipw3945 project, as well
+ * as portions of the ieee80211 subsystem header files.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
+ *
+ * The full GNU General Public License is included in this distribution in the
+ * file called LICENSE.
+ *
+ * Contact Information:
+ * James P. Ketrenos <ipw2100-admin@linux.intel.com>
+ * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
+ *****************************************************************************/
+#ifndef __iwl_power_setting_h__
+#define __iwl_power_setting_h__
+
+#include <net/mac80211.h>
+#include "iwl-4965-commands.h"
+
+struct iwl_priv;
+
+#define IWL_POWER_MODE_CAM	0x00    /* Continuously Aware Mode, always on */
+#define IWL_POWER_INDEX_3	0x03
+#define IWL_POWER_INDEX_5	0x05
+#define IWL_POWER_AC		0x06
+#define IWL_POWER_BATTERY	0x07
+#define IWL_POWER_AUTO		0x08
+#define IWL_POWER_LIMIT		0x08
+#define IWL_POWER_MASK		0x0F
+#define IWL_POWER_ENABLED	0x10
+
+/* Power management (not Tx power) structures */
+
+struct iwl_power_vec_entry {
+	struct iwl4965_powertable_cmd cmd;
+	u8 no_dtim;
+};
+
+struct iwl_power_mgr {
+	spinlock_t lock;
+	struct iwl_power_vec_entry pwr_range_0[IWL_POWER_AC];
+	struct iwl_power_vec_entry pwr_range_1[IWL_POWER_AC];
+	struct iwl_power_vec_entry pwr_range_2[IWL_POWER_AC];
+	u32 dtim_period;
+	/* final power level that used to calculate final power command */
+	u8 power_mode;
+	u8 user_power_setting; /* set by user through mac80211 or sysfs */
+	u8 system_power_setting; /* set by kernel syatem tools */
+	u8 critical_power_setting; /* set if driver over heated */
+	u8 is_battery_active; /* DC/AC power */
+	u8 power_disabled; /* flag to disable using power saving level */
+};
+
+int iwl_power_update_mode(struct iwl_priv *priv, u8 refresh);
+int iwl_power_disable_management(struct iwl_priv *priv);
+int iwl_power_enable_management(struct iwl_priv *priv);
+int iwl_power_set_user_mode(struct iwl_priv *priv, u16 mode);
+int iwl_power_set_system_mode(struct iwl_priv *priv, u16 mode);
+void iwl_power_initialize(struct iwl_priv *priv);
+int iwl_power_temperature_change(struct iwl_priv *priv);
+
+#endif  /* __iwl_power_setting_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 7f1a743..6fb9979 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -879,6 +879,13 @@ static int iwl4965_commit_rxon(struct iwl_priv *priv)
 	return 0;
 }
 
+void iwl4965_update_chain_flags(struct iwl_priv *priv)
+{
+
+	iwl4965_set_rxon_chain(priv);
+	iwl4965_commit_rxon(priv);
+}
+
 static int iwl4965_send_bt_config(struct iwl_priv *priv)
 {
 	struct iwl4965_bt_cmd bt_cmd = {
@@ -1366,184 +1373,6 @@ static void iwl4965_activate_qos(struct iwl_priv *priv, u8 force)
 	}
 }
 
-/*
- * Power management (not Tx power!) functions
- */
-#define MSEC_TO_USEC 1024
-
-#define NOSLP __constant_cpu_to_le16(0), 0, 0
-#define SLP IWL_POWER_DRIVER_ALLOW_SLEEP_MSK, 0, 0
-#define SLP_TIMEOUT(T) __constant_cpu_to_le32((T) * MSEC_TO_USEC)
-#define SLP_VEC(X0, X1, X2, X3, X4) {__constant_cpu_to_le32(X0), \
-				     __constant_cpu_to_le32(X1), \
-				     __constant_cpu_to_le32(X2), \
-				     __constant_cpu_to_le32(X3), \
-				     __constant_cpu_to_le32(X4)}
-
-
-/* default power management (not Tx power) table values */
-/* for tim  0-10 */
-static struct iwl4965_power_vec_entry range_0[IWL_POWER_AC] = {
-	{{NOSLP, SLP_TIMEOUT(0), SLP_TIMEOUT(0), SLP_VEC(0, 0, 0, 0, 0)}, 0},
-	{{SLP, SLP_TIMEOUT(200), SLP_TIMEOUT(500), SLP_VEC(1, 2, 3, 4, 4)}, 0},
-	{{SLP, SLP_TIMEOUT(200), SLP_TIMEOUT(300), SLP_VEC(2, 4, 6, 7, 7)}, 0},
-	{{SLP, SLP_TIMEOUT(50), SLP_TIMEOUT(100), SLP_VEC(2, 6, 9, 9, 10)}, 0},
-	{{SLP, SLP_TIMEOUT(50), SLP_TIMEOUT(25), SLP_VEC(2, 7, 9, 9, 10)}, 1},
-	{{SLP, SLP_TIMEOUT(25), SLP_TIMEOUT(25), SLP_VEC(4, 7, 10, 10, 10)}, 1}
-};
-
-/* for tim > 10 */
-static struct iwl4965_power_vec_entry range_1[IWL_POWER_AC] = {
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
-};
-
-int iwl4965_power_init_handle(struct iwl_priv *priv)
-{
-	int rc = 0, i;
-	struct iwl4965_power_mgr *pow_data;
-	int size = sizeof(struct iwl4965_power_vec_entry) * IWL_POWER_AC;
-	u16 pci_pm;
-
-	IWL_DEBUG_POWER("Initialize power \n");
-
-	pow_data = &(priv->power_data);
-
-	memset(pow_data, 0, sizeof(*pow_data));
-
-	pow_data->active_index = IWL_POWER_RANGE_0;
-	pow_data->dtim_val = 0xffff;
-
-	memcpy(&pow_data->pwr_range_0[0], &range_0[0], size);
-	memcpy(&pow_data->pwr_range_1[0], &range_1[0], size);
-
-	rc = pci_read_config_word(priv->pci_dev, PCI_LINK_CTRL, &pci_pm);
-	if (rc != 0)
-		return 0;
-	else {
-		struct iwl4965_powertable_cmd *cmd;
-
-		IWL_DEBUG_POWER("adjust power command flags\n");
-
-		for (i = 0; i < IWL_POWER_AC; i++) {
-			cmd = &pow_data->pwr_range_0[i].cmd;
-
-			if (pci_pm & 0x1)
-				cmd->flags &= ~IWL_POWER_PCI_PM_MSK;
-			else
-				cmd->flags |= IWL_POWER_PCI_PM_MSK;
-		}
-	}
-	return rc;
-}
-
-static int iwl4965_update_power_cmd(struct iwl_priv *priv,
-				struct iwl4965_powertable_cmd *cmd, u32 mode)
-{
-	int rc = 0, i;
-	u8 skip;
-	u32 max_sleep = 0;
-	struct iwl4965_power_vec_entry *range;
-	u8 period = 0;
-	struct iwl4965_power_mgr *pow_data;
-
-	if (mode > IWL_POWER_INDEX_5) {
-		IWL_DEBUG_POWER("Error invalid power mode \n");
-		return -1;
-	}
-	pow_data = &(priv->power_data);
-
-	if (pow_data->active_index == IWL_POWER_RANGE_0)
-		range = &pow_data->pwr_range_0[0];
-	else
-		range = &pow_data->pwr_range_1[1];
-
-	memcpy(cmd, &range[mode].cmd, sizeof(struct iwl4965_powertable_cmd));
-
-#ifdef IWL_MAC80211_DISABLE
-	if (priv->assoc_network != NULL) {
-		unsigned long flags;
-
-		period = priv->assoc_network->tim.tim_period;
-	}
-#endif	/*IWL_MAC80211_DISABLE */
-	skip = range[mode].no_dtim;
-
-	if (period == 0) {
-		period = 1;
-		skip = 0;
-	}
-
-	if (skip == 0) {
-		max_sleep = period;
-		cmd->flags &= ~IWL_POWER_SLEEP_OVER_DTIM_MSK;
-	} else {
-		__le32 slp_itrvl = cmd->sleep_interval[IWL_POWER_VEC_SIZE - 1];
-		max_sleep = (le32_to_cpu(slp_itrvl) / period) * period;
-		cmd->flags |= IWL_POWER_SLEEP_OVER_DTIM_MSK;
-	}
-
-	for (i = 0; i < IWL_POWER_VEC_SIZE; i++) {
-		if (le32_to_cpu(cmd->sleep_interval[i]) > max_sleep)
-			cmd->sleep_interval[i] = cpu_to_le32(max_sleep);
-	}
-
-	IWL_DEBUG_POWER("Flags value = 0x%08X\n", cmd->flags);
-	IWL_DEBUG_POWER("Tx timeout = %u\n", le32_to_cpu(cmd->tx_data_timeout));
-	IWL_DEBUG_POWER("Rx timeout = %u\n", le32_to_cpu(cmd->rx_data_timeout));
-	IWL_DEBUG_POWER("Sleep interval vector = { %d , %d , %d , %d , %d }\n",
-			le32_to_cpu(cmd->sleep_interval[0]),
-			le32_to_cpu(cmd->sleep_interval[1]),
-			le32_to_cpu(cmd->sleep_interval[2]),
-			le32_to_cpu(cmd->sleep_interval[3]),
-			le32_to_cpu(cmd->sleep_interval[4]));
-
-	return rc;
-}
-
-static int iwl4965_send_power_mode(struct iwl_priv *priv, u32 mode)
-{
-	u32 uninitialized_var(final_mode);
-	int rc;
-	struct iwl4965_powertable_cmd cmd;
-
-	/* If on battery, set to 3,
-	 * if plugged into AC power, set to CAM ("continuously aware mode"),
-	 * else user level */
-	switch (mode) {
-	case IWL_POWER_BATTERY:
-		final_mode = IWL_POWER_INDEX_3;
-		break;
-	case IWL_POWER_AC:
-		final_mode = IWL_POWER_MODE_CAM;
-		break;
-	default:
-		final_mode = mode;
-		break;
-	}
-
-	cmd.keep_alive_beacons = 0;
-
-	iwl4965_update_power_cmd(priv, &cmd, final_mode);
-
-	rc = iwl_send_cmd_pdu(priv, POWER_TABLE_CMD, sizeof(cmd), &cmd);
-
-	if (final_mode == IWL_POWER_MODE_CAM)
-		clear_bit(STATUS_POWER_PMI, &priv->status);
-	else
-		set_bit(STATUS_POWER_PMI, &priv->status);
-
-	return rc;
-}
-
 int iwl4965_is_network_packet(struct iwl_priv *priv, struct ieee80211_hdr *header)
 {
 	/* Filter incoming packets to determine if they are targeted toward
@@ -5315,8 +5144,6 @@ static void iwl4965_alive_start(struct iwl_priv *priv)
 	priv->active_rate = priv->rates_mask;
 	priv->active_rate_basic = priv->rates_mask & IWL_BASIC_RATES_MASK;
 
-	iwl4965_send_power_mode(priv, IWL_POWER_LEVEL(priv->power_mode));
-
 	if (iwl_is_associated(priv)) {
 		struct iwl4965_rxon_cmd *active_rxon =
 				(struct iwl4965_rxon_cmd *)(&priv->active_rxon);
@@ -5849,6 +5676,8 @@ static void iwl4965_bg_request_scan(struct work_struct *data)
 				direct_mask,
 				(void *)&scan->data[le16_to_cpu(scan->tx_cmd.len)]);
 
+	scan->filter_flags |= (RXON_FILTER_ACCEPT_GRP_MSK |
+			       RXON_FILTER_BCON_AWARE_MSK);
 	cmd.len += le16_to_cpu(scan->tx_cmd.len) +
 	    scan->channel_count * sizeof(struct iwl4965_scan_channel);
 	cmd.data = scan;
@@ -6011,6 +5840,7 @@ static void iwl4965_post_associate(struct iwl_priv *priv)
 
 	iwl4965_activate_qos(priv, 0);
 
+	iwl_power_update_mode(priv, 0);
 	/* we have just associated, don't start scan too early */
 	priv->next_scan_jiffies = jiffies + IWL_DELAY_NEXT_SCAN;
 }
@@ -7002,6 +6832,8 @@ static void iwl4965_mac_reset_tsf(struct ieee80211_hw *hw)
 		iwl4965_commit_rxon(priv);
 	}
 
+	iwl_power_update_mode(priv, 0);
+
 	/* Per mac80211.h: This is only used in IBSS mode... */
 	if (priv->iw_mode != IEEE80211_IF_TYPE_IBSS) {
 
@@ -7335,20 +7167,11 @@ static ssize_t store_power_level(struct device *d,
 		goto out;
 	}
 
-	if ((mode < 1) || (mode > IWL_POWER_LIMIT) || (mode == IWL_POWER_AC))
-		mode = IWL_POWER_AC;
-	else
-		mode |= IWL_POWER_ENABLED;
-
-	if (mode != priv->power_mode) {
-		rc = iwl4965_send_power_mode(priv, IWL_POWER_LEVEL(mode));
-		if (rc) {
-			IWL_DEBUG_MAC80211("failed setting power mode.\n");
-			goto out;
-		}
-		priv->power_mode = mode;
+	rc = iwl_power_set_user_mode(priv, mode);
+	if (rc) {
+		IWL_DEBUG_MAC80211("failed setting power mode.\n");
+		goto out;
 	}
-
 	rc = count;
 
  out:
@@ -7378,7 +7201,7 @@ static ssize_t show_power_level(struct device *d,
 				struct device_attribute *attr, char *buf)
 {
 	struct iwl_priv *priv = dev_get_drvdata(d);
-	int level = IWL_POWER_LEVEL(priv->power_mode);
+	int level = priv->power_data.power_mode;
 	char *p = buf;
 
 	p += sprintf(p, "%d ", level);
@@ -7396,14 +7219,14 @@ static ssize_t show_power_level(struct device *d,
 			     timeout_duration[level - 1] / 1000,
 			     period_duration[level - 1] / 1000);
 	}
-
+/*
 	if (!(priv->power_mode & IWL_POWER_ENABLED))
 		p += sprintf(p, " OFF\n");
 	else
 		p += sprintf(p, " \n");
-
+*/
+	p += sprintf(p, " \n");
 	return (p - buf + 1);
-
 }
 
 static DEVICE_ATTR(power_level, S_IWUSR | S_IRUSR, show_power_level,
-- 
1.5.3.4

