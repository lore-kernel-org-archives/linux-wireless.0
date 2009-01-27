Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:17884 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751526AbZA0WZJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jan 2009 17:25:09 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	"Winkler, Tomas" <tomas.winkler@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 7/7] iwlwifi: unify iwlagn and 3945 power save management
Date: Tue, 27 Jan 2009 14:27:58 -0800
Message-Id: <1233095278-5850-8-git-send-email-reinette.chatre@intel.com> (sfid-20090127_232519_492386_712CFEB2)
In-Reply-To: <1233095278-5850-7-git-send-email-reinette.chatre@intel.com>
References: <>
 <1233095278-5850-1-git-send-email-reinette.chatre@intel.com>
 <1233095278-5850-2-git-send-email-reinette.chatre@intel.com>
 <1233095278-5850-3-git-send-email-reinette.chatre@intel.com>
 <1233095278-5850-4-git-send-email-reinette.chatre@intel.com>
 <1233095278-5850-5-git-send-email-reinette.chatre@intel.com>
 <1233095278-5850-6-git-send-email-reinette.chatre@intel.com>
 <1233095278-5850-7-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Winkler, Tomas <tomas.winkler@intel.com>

This patch unifies 3945 and iwlagn power save management
This patch also better separates system state from user setting.
System state shall be removed later as this shall be shifted to user space

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Acked-by: Mohamed Abbas <mohamed.abbas@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c     |    6 +-
 drivers/net/wireless/iwlwifi/iwl-core.c     |    4 +-
 drivers/net/wireless/iwlwifi/iwl-power.c    |   17 +--
 drivers/net/wireless/iwlwifi/iwl-power.h    |   14 +--
 drivers/net/wireless/iwlwifi/iwl3945-base.c |  261 +++++----------------------
 5 files changed, 60 insertions(+), 242 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 8ff5798..cb6db45 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -1063,7 +1063,7 @@ static int iwl3945_apm_init(struct iwl_priv *priv)
 {
 	int ret = 0;
 
-	iwl3945_power_init_handle(priv);
+	iwl_power_initialize(priv);
 
 	iwl_set_bit(priv, CSR_GIO_CHICKEN_BITS,
 			  CSR_GIO_CHICKEN_BITS_REG_BIT_DIS_L0S_EXIT_TIMER);
@@ -2372,7 +2372,9 @@ static u16 iwl3945_get_hcmd_size(u8 cmd_id, u16 len)
 {
 	switch (cmd_id) {
 	case REPLY_RXON:
-		return (u16) sizeof(struct iwl3945_rxon_cmd);
+		return sizeof(struct iwl3945_rxon_cmd);
+	case POWER_TABLE_CMD:
+		return sizeof(struct iwl3945_powertable_cmd);
 	default:
 		return len;
 	}
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 5f92cfb..e18c3f3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1355,8 +1355,8 @@ int iwl_init_drv(struct iwl_priv *priv)
 	priv->qos_data.qos_cap.val = 0;
 
 	priv->rates_mask = IWL_RATES_MASK;
-	/* If power management is turned on, default to AC mode */
-	priv->power_mode = IWL_POWER_AC;
+	/* If power management is turned on, default to CAM mode */
+	priv->power_mode = IWL_POWER_MODE_CAM;
 	priv->tx_power_user_lmt = IWL_TX_POWER_TARGET_POWER_MAX;
 
 	ret = iwl_init_channel_map(priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-power.c b/drivers/net/wireless/iwlwifi/iwl-power.c
index abe0d29..4c5a775 100644
--- a/drivers/net/wireless/iwlwifi/iwl-power.c
+++ b/drivers/net/wireless/iwlwifi/iwl-power.c
@@ -102,6 +102,7 @@ static struct iwl_power_vec_entry range_2[IWL_POWER_MAX] = {
 	{{SLP, SLP_TOUT(25), SLP_TOUT(25), SLP_VEC(4, 7, 10, 10, 0xFF)}, 0}
 };
 
+
 /* set card power command */
 static int iwl_set_power(struct iwl_priv *priv, void *cmd)
 {
@@ -126,13 +127,6 @@ static u16 iwl_get_auto_power_mode(struct iwl_priv *priv)
 		else
 			mode = IWL_POWER_ON_AC_DISASSOC;
 		break;
-	/* FIXME: remove battery and ac from here */
-	case IWL_POWER_BATTERY:
-		mode = IWL_POWER_INDEX_3;
-		break;
-	case IWL_POWER_AC:
-		mode = IWL_POWER_MODE_CAM;
-		break;
 	default:
 		mode = priv->power_data.user_power_setting;
 		break;
@@ -357,7 +351,7 @@ EXPORT_SYMBOL(iwl_power_enable_management);
 /* set user_power_setting */
 int iwl_power_set_user_mode(struct iwl_priv *priv, u16 mode)
 {
-	if (mode > IWL_POWER_LIMIT)
+	if (mode > IWL_POWER_MAX)
 		return -EINVAL;
 
 	priv->power_data.user_power_setting = mode;
@@ -371,11 +365,10 @@ EXPORT_SYMBOL(iwl_power_set_user_mode);
  */
 int iwl_power_set_system_mode(struct iwl_priv *priv, u16 mode)
 {
-	if (mode > IWL_POWER_LIMIT)
+	if (mode < IWL_POWER_SYS_MAX)
+		priv->power_data.system_power_setting = mode;
+	else
 		return -EINVAL;
-
-	priv->power_data.system_power_setting = mode;
-
 	return iwl_power_update_mode(priv, 0);
 }
 EXPORT_SYMBOL(iwl_power_set_system_mode);
diff --git a/drivers/net/wireless/iwlwifi/iwl-power.h b/drivers/net/wireless/iwlwifi/iwl-power.h
index 859b60b..879eafd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-power.h
+++ b/drivers/net/wireless/iwlwifi/iwl-power.h
@@ -42,27 +42,15 @@ enum {
 	IWL_POWER_INDEX_5,
 	IWL_POWER_AUTO,
 	IWL_POWER_MAX = IWL_POWER_AUTO,
-	IWL39_POWER_AC = IWL_POWER_AUTO, /* 0x06 */
-	IWL_POWER_AC,
-	IWL39_POWER_BATTERY = IWL_POWER_AC, /* 0x07 */
-	IWL39_POWER_LIMIT = IWL_POWER_AC,
-	IWL_POWER_BATTERY,
 };
 
 enum {
 	IWL_POWER_SYS_AUTO,
 	IWL_POWER_SYS_AC,
 	IWL_POWER_SYS_BATTERY,
+	IWL_POWER_SYS_MAX,
 };
 
-#define IWL_POWER_LIMIT		0x08
-#define IWL_POWER_MASK		0x0F
-#define IWL_POWER_ENABLED	0x10
-
-#define IWL_POWER_RANGE_0  (0)
-#define IWL_POWER_RANGE_1  (1)
-
-#define IWL_POWER_LEVEL(x)	((x) & IWL_POWER_MASK)
 
 /* Power management (not Tx power) structures */
 
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index ac33717..800e46c 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -656,162 +656,6 @@ static void iwl3945_activate_qos(struct iwl_priv *priv, u8 force)
 	}
 }
 
-/*
- * Power management (not Tx power!) functions
- */
-#define MSEC_TO_USEC 1024
-
-
-/* default power management (not Tx power) table values */
-/* for TIM  0-10 */
-static struct iwl_power_vec_entry range_0[IWL_POWER_MAX] = {
-	{{NOSLP, SLP_TOUT(0), SLP_TOUT(0), SLP_VEC(0, 0, 0, 0, 0)}, 0},
-	{{SLP, SLP_TOUT(200), SLP_TOUT(500), SLP_VEC(1, 2, 3, 4, 4)}, 0},
-	{{SLP, SLP_TOUT(200), SLP_TOUT(300), SLP_VEC(2, 4, 6, 7, 7)}, 0},
-	{{SLP, SLP_TOUT(50), SLP_TOUT(100), SLP_VEC(2, 6, 9, 9, 10)}, 0},
-	{{SLP, SLP_TOUT(50), SLP_TOUT(25), SLP_VEC(2, 7, 9, 9, 10)}, 1},
-	{{SLP, SLP_TOUT(25), SLP_TOUT(25), SLP_VEC(4, 7, 10, 10, 10)}, 1}
-};
-
-/* for TIM > 10 */
-static struct iwl_power_vec_entry range_1[IWL_POWER_MAX] = {
-	{{NOSLP, SLP_TOUT(0), SLP_TOUT(0), SLP_VEC(0, 0, 0, 0, 0)}, 0},
-	{{SLP, SLP_TOUT(200), SLP_TOUT(500), SLP_VEC(1, 2, 3, 4, 0xFF)}, 0},
-	{{SLP, SLP_TOUT(200), SLP_TOUT(300), SLP_VEC(2, 4, 6, 7, 0xFF)}, 0},
-	{{SLP, SLP_TOUT(50), SLP_TOUT(100), SLP_VEC(2, 6, 9, 9, 0xFF)}, 0},
-	{{SLP, SLP_TOUT(50), SLP_TOUT(25), SLP_VEC(2, 7, 9, 9, 0xFF)}, 0},
-	{{SLP, SLP_TOUT(25), SLP_TOUT(25), SLP_VEC(4, 7, 10, 10, 0xFF)}, 0}
-};
-
-int iwl3945_power_init_handle(struct iwl_priv *priv)
-{
-	int rc = 0, i;
-	struct iwl_power_mgr *pow_data;
-	int size = sizeof(struct iwl_power_vec_entry) * IWL_POWER_MAX;
-	u16 pci_pm;
-
-	IWL_DEBUG_POWER(priv, "Initialize power \n");
-
-	pow_data = &priv->power_data;
-
-	memset(pow_data, 0, sizeof(*pow_data));
-
-	pow_data->dtim_period = 1;
-
-	memcpy(&pow_data->pwr_range_0[0], &range_0[0], size);
-	memcpy(&pow_data->pwr_range_1[0], &range_1[0], size);
-
-	rc = pci_read_config_word(priv->pci_dev, PCI_LINK_CTRL, &pci_pm);
-	if (rc != 0)
-		return 0;
-	else {
-		struct iwl_powertable_cmd *cmd;
-
-		IWL_DEBUG_POWER(priv, "adjust power command flags\n");
-
-		for (i = 0; i < IWL_POWER_MAX; i++) {
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
-static int iwl3945_update_power_cmd(struct iwl_priv *priv,
-				struct iwl_powertable_cmd *cmd, u32 mode)
-{
-	struct iwl_power_mgr *pow_data;
-	struct iwl_power_vec_entry *range;
-	u32 max_sleep = 0;
-	int i;
-	u8 period = 0;
-	bool skip;
-
-	if (mode > IWL_POWER_INDEX_5) {
-		IWL_DEBUG_POWER(priv, "Error invalid power mode \n");
-		return -EINVAL;
-	}
-	pow_data = &priv->power_data;
-
-	if (pow_data->dtim_period < 10)
-		range = &pow_data->pwr_range_0[0];
-	else
-		range = &pow_data->pwr_range_1[1];
-
-	memcpy(cmd, &range[mode].cmd, sizeof(struct iwl3945_powertable_cmd));
-
-
-	if (period == 0) {
-		period = 1;
-		skip = false;
-	} else {
-		skip = !!range[mode].no_dtim;
-	}
-
-	if (skip) {
-		__le32 slp_itrvl = cmd->sleep_interval[IWL_POWER_VEC_SIZE - 1];
-		max_sleep = (le32_to_cpu(slp_itrvl) / period) * period;
-		cmd->flags |= IWL_POWER_SLEEP_OVER_DTIM_MSK;
-	} else {
-		max_sleep = period;
-		cmd->flags &= ~IWL_POWER_SLEEP_OVER_DTIM_MSK;
-	}
-
-	for (i = 0; i < IWL_POWER_VEC_SIZE; i++)
-		if (le32_to_cpu(cmd->sleep_interval[i]) > max_sleep)
-			cmd->sleep_interval[i] = cpu_to_le32(max_sleep);
-
-	IWL_DEBUG_POWER(priv, "Flags value = 0x%08X\n", cmd->flags);
-	IWL_DEBUG_POWER(priv, "Tx timeout = %u\n", le32_to_cpu(cmd->tx_data_timeout));
-	IWL_DEBUG_POWER(priv, "Rx timeout = %u\n", le32_to_cpu(cmd->rx_data_timeout));
-	IWL_DEBUG_POWER(priv, "Sleep interval vector = { %d , %d , %d , %d , %d }\n",
-			le32_to_cpu(cmd->sleep_interval[0]),
-			le32_to_cpu(cmd->sleep_interval[1]),
-			le32_to_cpu(cmd->sleep_interval[2]),
-			le32_to_cpu(cmd->sleep_interval[3]),
-			le32_to_cpu(cmd->sleep_interval[4]));
-
-	return 0;
-}
-
-static int iwl3945_send_power_mode(struct iwl_priv *priv, u32 mode)
-{
-	u32 uninitialized_var(final_mode);
-	int rc;
-	struct iwl_powertable_cmd cmd;
-
-	/* If on battery, set to 3,
-	 * if plugged into AC power, set to CAM ("continuously aware mode"),
-	 * else user level */
-	switch (mode) {
-	case IWL39_POWER_BATTERY:
-		final_mode = IWL_POWER_INDEX_3;
-		break;
-	case IWL39_POWER_AC:
-		final_mode = IWL_POWER_MODE_CAM;
-		break;
-	default:
-		final_mode = mode;
-		break;
-	}
-
-	iwl3945_update_power_cmd(priv, &cmd, final_mode);
-
-	/* FIXME use get_hcmd_size 3945 command is 4 bytes shorter */
-	rc = iwl_send_cmd_pdu(priv, POWER_TABLE_CMD,
-			      sizeof(struct iwl3945_powertable_cmd), &cmd);
-
-	if (final_mode == IWL_POWER_MODE_CAM)
-		clear_bit(STATUS_POWER_PMI, &priv->status);
-	else
-		set_bit(STATUS_POWER_PMI, &priv->status);
-
-	return rc;
-}
 
 #define MAX_UCODE_BEACON_INTERVAL	1024
 #define INTEL_CONN_LISTEN_INTERVAL	__constant_cpu_to_le16(0xA)
@@ -3467,7 +3311,7 @@ static void iwl3945_alive_start(struct iwl_priv *priv)
 	priv->active_rate = priv->rates_mask;
 	priv->active_rate_basic = priv->rates_mask & IWL_BASIC_RATES_MASK;
 
-	iwl3945_send_power_mode(priv, IWL_POWER_LEVEL(priv->power_mode));
+	iwl_power_update_mode(priv, false);
 
 	if (iwl_is_associated(priv)) {
 		struct iwl3945_rxon_cmd *active_rxon =
@@ -5136,44 +4980,70 @@ static ssize_t show_retry_rate(struct device *d,
 static DEVICE_ATTR(retry_rate, S_IWUSR | S_IRUSR, show_retry_rate,
 		   store_retry_rate);
 
+
 static ssize_t store_power_level(struct device *d,
 				 struct device_attribute *attr,
 				 const char *buf, size_t count)
 {
 	struct iwl_priv *priv = dev_get_drvdata(d);
-	int rc;
-	int mode;
+	int ret;
+	unsigned long mode;
+
 
-	mode = simple_strtoul(buf, NULL, 0);
 	mutex_lock(&priv->mutex);
 
 	if (!iwl_is_ready(priv)) {
-		rc = -EAGAIN;
+		ret = -EAGAIN;
 		goto out;
 	}
 
-	if ((mode < 1) || (mode > IWL39_POWER_LIMIT) ||
-	    (mode == IWL39_POWER_AC))
-		mode = IWL39_POWER_AC;
-	else
-		mode |= IWL_POWER_ENABLED;
+	ret = strict_strtoul(buf, 10, &mode);
+	if (ret)
+		goto out;
 
-	if (mode != priv->power_mode) {
-		rc = iwl3945_send_power_mode(priv, IWL_POWER_LEVEL(mode));
-		if (rc) {
-			IWL_DEBUG_MAC80211(priv, "failed setting power mode\n");
-			goto out;
-		}
-		priv->power_mode = mode;
+	ret = iwl_power_set_user_mode(priv, mode);
+	if (ret) {
+		IWL_DEBUG_MAC80211(priv, "failed setting power mode.\n");
+		goto out;
 	}
-
-	rc = count;
+	ret = count;
 
  out:
 	mutex_unlock(&priv->mutex);
-	return rc;
+	return ret;
 }
 
+static ssize_t show_power_level(struct device *d,
+				struct device_attribute *attr, char *buf)
+{
+	struct iwl_priv *priv = dev_get_drvdata(d);
+	int mode = priv->power_data.user_power_setting;
+	int system = priv->power_data.system_power_setting;
+	int level = priv->power_data.power_mode;
+	char *p = buf;
+
+	switch (system) {
+	case IWL_POWER_SYS_AUTO:
+		p += sprintf(p, "SYSTEM:auto");
+		break;
+	case IWL_POWER_SYS_AC:
+		p += sprintf(p, "SYSTEM:ac");
+		break;
+	case IWL_POWER_SYS_BATTERY:
+		p += sprintf(p, "SYSTEM:battery");
+		break;
+	}
+
+	p += sprintf(p, "\tMODE:%s", (mode < IWL_POWER_AUTO) ?
+			"fixed" : "auto");
+	p += sprintf(p, "\tINDEX:%d", level);
+	p += sprintf(p, "\n");
+	return p - buf + 1;
+}
+
+static DEVICE_ATTR(power_level, S_IWUSR | S_IRUSR,
+		   show_power_level, store_power_level);
+
 #define MAX_WX_STRING 80
 
 /* Values are in microsecond */
@@ -5192,41 +5062,6 @@ static const s32 period_duration[] = {
 	1000000
 };
 
-static ssize_t show_power_level(struct device *d,
-				struct device_attribute *attr, char *buf)
-{
-	struct iwl_priv *priv = dev_get_drvdata(d);
-	int level = IWL_POWER_LEVEL(priv->power_mode);
-	char *p = buf;
-
-	p += sprintf(p, "%d ", level);
-	switch (level) {
-	case IWL_POWER_MODE_CAM:
-	case IWL39_POWER_AC:
-		p += sprintf(p, "(AC)");
-		break;
-	case IWL39_POWER_BATTERY:
-		p += sprintf(p, "(BATTERY)");
-		break;
-	default:
-		p += sprintf(p,
-			     "(Timeout %dms, Period %dms)",
-			     timeout_duration[level - 1] / 1000,
-			     period_duration[level - 1] / 1000);
-	}
-
-	if (!(priv->power_mode & IWL_POWER_ENABLED))
-		p += sprintf(p, " OFF\n");
-	else
-		p += sprintf(p, " \n");
-
-	return p - buf + 1;
-
-}
-
-static DEVICE_ATTR(power_level, S_IWUSR | S_IRUSR, show_power_level,
-		   store_power_level);
-
 static ssize_t show_channels(struct device *d,
 			     struct device_attribute *attr, char *buf)
 {
@@ -5469,8 +5304,8 @@ static int iwl3945_init_drv(struct iwl_priv *priv)
 	priv->qos_data.qos_cap.val = 0;
 
 	priv->rates_mask = IWL_RATES_MASK;
-	/* If power management is turned on, default to AC mode */
-	priv->power_mode = IWL39_POWER_AC;
+	/* If power management is turned on, default to CAM mode */
+	priv->power_mode = IWL_POWER_MODE_CAM;
 	priv->tx_power_user_lmt = IWL_DEFAULT_TX_POWER;
 
 	if (eeprom->version < EEPROM_3945_EEPROM_VERSION) {
-- 
1.5.4.3

