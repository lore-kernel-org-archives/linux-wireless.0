Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:54091 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751786AbYGRF4T (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jul 2008 01:56:19 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Esti Kummer <stkumer@localhost.localdomain>,
	Esti Kummer <ester.kummer@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 02/13] iwlwifi: corrects power_level in sysfs
Date: Fri, 18 Jul 2008 13:52:58 +0800
Message-Id: <1216360389-5352-3-git-send-email-yi.zhu@intel.com> (sfid-20080718_075625_778146_4F230D89)
In-Reply-To: <1216360389-5352-2-git-send-email-yi.zhu@intel.com>
References: <1216360389-5352-1-git-send-email-yi.zhu@intel.com>
 <1216360389-5352-2-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Esti Kummer <stkumer@localhost.localdomain>

This patch corrects power_level in sysfs.

Signed-off-by: Esti Kummer <ester.kummer@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-power.c    |   27 +++++++-----
 drivers/net/wireless/iwlwifi/iwl-power.h    |   31 +++++++++----
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   63 ++++++++------------------
 3 files changed, 58 insertions(+), 63 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-power.c b/drivers/net/wireless/iwlwifi/iwl-power.c
index e3c71be..028e305 100644
--- a/drivers/net/wireless/iwlwifi/iwl-power.c
+++ b/drivers/net/wireless/iwlwifi/iwl-power.c
@@ -82,7 +82,7 @@
 
 /* default power management (not Tx power) table values */
 /* for tim  0-10 */
-static struct iwl_power_vec_entry range_0[IWL_POWER_AC] = {
+static struct iwl_power_vec_entry range_0[IWL_POWER_MAX] = {
 	{{NOSLP, SLP_TOUT(0), SLP_TOUT(0), SLP_VEC(0, 0, 0, 0, 0)}, 0},
 	{{SLP, SLP_TOUT(200), SLP_TOUT(500), SLP_VEC(1, 2, 2, 2, 0xFF)}, 0},
 	{{SLP, SLP_TOUT(200), SLP_TOUT(300), SLP_VEC(1, 2, 2, 2, 0xFF)}, 0},
@@ -93,7 +93,7 @@ static struct iwl_power_vec_entry range_0[IWL_POWER_AC] = {
 
 
 /* for tim = 3-10 */
-static struct iwl_power_vec_entry range_1[IWL_POWER_AC] = {
+static struct iwl_power_vec_entry range_1[IWL_POWER_MAX] = {
 	{{NOSLP, SLP_TOUT(0), SLP_TOUT(0), SLP_VEC(0, 0, 0, 0, 0)}, 0},
 	{{SLP, SLP_TOUT(200), SLP_TOUT(500), SLP_VEC(1, 2, 3, 4, 4)}, 0},
 	{{SLP, SLP_TOUT(200), SLP_TOUT(300), SLP_VEC(1, 2, 3, 4, 7)}, 0},
@@ -103,7 +103,7 @@ static struct iwl_power_vec_entry range_1[IWL_POWER_AC] = {
 };
 
 /* for tim > 11 */
-static struct iwl_power_vec_entry range_2[IWL_POWER_AC] = {
+static struct iwl_power_vec_entry range_2[IWL_POWER_MAX] = {
 	{{NOSLP, SLP_TOUT(0), SLP_TOUT(0), SLP_VEC(0, 0, 0, 0, 0)}, 0},
 	{{SLP, SLP_TOUT(200), SLP_TOUT(500), SLP_VEC(1, 2, 3, 4, 0xFF)}, 0},
 	{{SLP, SLP_TOUT(200), SLP_TOUT(300), SLP_VEC(2, 4, 6, 7, 0xFF)}, 0},
@@ -124,7 +124,7 @@ static int iwl_set_power(struct iwl_priv *priv, void *cmd)
  */
 static u16 iwl_get_auto_power_mode(struct iwl_priv *priv)
 {
-	u16 mode = priv->power_data.user_power_setting;
+	u16 mode;
 
 	switch (priv->power_data.user_power_setting) {
 	case IWL_POWER_AUTO:
@@ -136,12 +136,16 @@ static u16 iwl_get_auto_power_mode(struct iwl_priv *priv)
 		else
 			mode = IWL_POWER_ON_AC_DISASSOC;
 		break;
+	/* FIXME: remove battery and ac from here */
 	case IWL_POWER_BATTERY:
 		mode = IWL_POWER_INDEX_3;
 		break;
 	case IWL_POWER_AC:
 		mode = IWL_POWER_MODE_CAM;
 		break;
+	default:
+		mode = priv->power_data.user_power_setting;
+		break;
 	}
 	return mode;
 }
@@ -151,7 +155,7 @@ static int iwl_power_init_handle(struct iwl_priv *priv)
 {
 	int ret = 0, i;
 	struct iwl_power_mgr *pow_data;
-	int size = sizeof(struct iwl_power_vec_entry) * IWL_POWER_AC;
+	int size = sizeof(struct iwl_power_vec_entry) * IWL_POWER_MAX;
 	u16 pci_pm;
 
 	IWL_DEBUG_POWER("Initialize power \n");
@@ -173,7 +177,7 @@ static int iwl_power_init_handle(struct iwl_priv *priv)
 
 		IWL_DEBUG_POWER("adjust power command flags\n");
 
-		for (i = 0; i < IWL_POWER_AC; i++) {
+		for (i = 0; i < IWL_POWER_MAX; i++) {
 			cmd = &pow_data->pwr_range_0[i].cmd;
 
 			if (pci_pm & 0x1)
@@ -265,17 +269,18 @@ int iwl_power_update_mode(struct iwl_priv *priv, u8 refresh)
 	* else user level */
 
 	switch (setting->system_power_setting) {
-	case IWL_POWER_AUTO:
+	case IWL_POWER_SYS_AUTO:
 		final_mode = iwl_get_auto_power_mode(priv);
 		break;
-	case IWL_POWER_BATTERY:
+	case IWL_POWER_SYS_BATTERY:
 		final_mode = IWL_POWER_INDEX_3;
 		break;
-	case IWL_POWER_AC:
+	case IWL_POWER_SYS_AC:
 		final_mode = IWL_POWER_MODE_CAM;
 		break;
 	default:
-		final_mode = setting->system_power_setting;
+		final_mode = IWL_POWER_INDEX_3;
+		WARN_ON(1);
 	}
 
 	if (setting->critical_power_setting > final_mode)
@@ -394,7 +399,7 @@ void iwl_power_initialize(struct iwl_priv *priv)
 	iwl_power_init_handle(priv);
 	priv->power_data.user_power_setting = IWL_POWER_AUTO;
 	priv->power_data.power_disabled = 0;
-	priv->power_data.system_power_setting = IWL_POWER_AUTO;
+	priv->power_data.system_power_setting = IWL_POWER_SYS_AUTO;
 	priv->power_data.is_battery_active = 0;
 	priv->power_data.power_disabled = 0;
 	priv->power_data.critical_power_setting = 0;
diff --git a/drivers/net/wireless/iwlwifi/iwl-power.h b/drivers/net/wireless/iwlwifi/iwl-power.h
index 801f614..abcbbf9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-power.h
+++ b/drivers/net/wireless/iwlwifi/iwl-power.h
@@ -33,12 +33,25 @@
 
 struct iwl_priv;
 
-#define IWL_POWER_MODE_CAM	0x00    /* Continuously Aware Mode, always on */
-#define IWL_POWER_INDEX_3	0x03
-#define IWL_POWER_INDEX_5	0x05
-#define IWL_POWER_AC		0x06
-#define IWL_POWER_BATTERY	0x07
-#define IWL_POWER_AUTO		0x08
+enum {
+	IWL_POWER_MODE_CAM, /* Continuously Aware Mode, always on */
+	IWL_POWER_INDEX_1,
+	IWL_POWER_INDEX_2,
+	IWL_POWER_INDEX_3,
+	IWL_POWER_INDEX_4,
+	IWL_POWER_INDEX_5,
+	IWL_POWER_AUTO,
+	IWL_POWER_MAX = IWL_POWER_AUTO,
+	IWL_POWER_AC,
+	IWL_POWER_BATTERY,
+};
+
+enum {
+	IWL_POWER_SYS_AUTO,
+	IWL_POWER_SYS_AC,
+	IWL_POWER_SYS_BATTERY,
+};
+
 #define IWL_POWER_LIMIT		0x08
 #define IWL_POWER_MASK		0x0F
 #define IWL_POWER_ENABLED	0x10
@@ -52,9 +65,9 @@ struct iwl_power_vec_entry {
 
 struct iwl_power_mgr {
 	spinlock_t lock;
-	struct iwl_power_vec_entry pwr_range_0[IWL_POWER_AC];
-	struct iwl_power_vec_entry pwr_range_1[IWL_POWER_AC];
-	struct iwl_power_vec_entry pwr_range_2[IWL_POWER_AC];
+	struct iwl_power_vec_entry pwr_range_0[IWL_POWER_MAX];
+	struct iwl_power_vec_entry pwr_range_1[IWL_POWER_MAX];
+	struct iwl_power_vec_entry pwr_range_2[IWL_POWER_MAX];
 	u32 dtim_period;
 	/* final power level that used to calculate final power command */
 	u8 power_mode;
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 71f5da3..2001b09 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -3800,76 +3800,53 @@ static ssize_t store_power_level(struct device *d,
 				 const char *buf, size_t count)
 {
 	struct iwl_priv *priv = dev_get_drvdata(d);
-	int rc;
+	int ret;
 	int mode;
 
 	mode = simple_strtoul(buf, NULL, 0);
 	mutex_lock(&priv->mutex);
 
 	if (!iwl_is_ready(priv)) {
-		rc = -EAGAIN;
+		ret = -EAGAIN;
 		goto out;
 	}
 
-	rc = iwl_power_set_user_mode(priv, mode);
-	if (rc) {
+	ret = iwl_power_set_user_mode(priv, mode);
+	if (ret) {
 		IWL_DEBUG_MAC80211("failed setting power mode.\n");
 		goto out;
 	}
-	rc = count;
+	ret = count;
 
  out:
 	mutex_unlock(&priv->mutex);
-	return rc;
+	return ret;
 }
 
-#define MAX_WX_STRING 80
-
-/* Values are in microsecond */
-static const s32 timeout_duration[] = {
-	350000,
-	250000,
-	75000,
-	37000,
-	25000,
-};
-static const s32 period_duration[] = {
-	400000,
-	700000,
-	1000000,
-	1000000,
-	1000000
-};
-
 static ssize_t show_power_level(struct device *d,
 				struct device_attribute *attr, char *buf)
 {
 	struct iwl_priv *priv = dev_get_drvdata(d);
+	int mode = priv->power_data.user_power_setting;
+	int system = priv->power_data.system_power_setting;
 	int level = priv->power_data.power_mode;
 	char *p = buf;
 
-	p += sprintf(p, "%d ", level);
-	switch (level) {
-	case IWL_POWER_MODE_CAM:
-	case IWL_POWER_AC:
-		p += sprintf(p, "(AC)");
+	switch (system) {
+	case IWL_POWER_SYS_AUTO:
+		p += sprintf(p, "SYSTEM:auto");
 		break;
-	case IWL_POWER_BATTERY:
-		p += sprintf(p, "(BATTERY)");
+	case IWL_POWER_SYS_AC:
+		p += sprintf(p, "SYSTEM:ac");
+		break;
+	case IWL_POWER_SYS_BATTERY:
+		p += sprintf(p, "SYSTEM:battery");
 		break;
-	default:
-		p += sprintf(p,
-			     "(Timeout %dms, Period %dms)",
-			     timeout_duration[level - 1] / 1000,
-			     period_duration[level - 1] / 1000);
 	}
-/*
-	if (!(priv->power_mode & IWL_POWER_ENABLED))
-		p += sprintf(p, " OFF\n");
-	else
-		p += sprintf(p, " \n");
-*/
-	p += sprintf(p, " \n");
+
+	p += sprintf(p, "\tMODE:%s", (mode < IWL_POWER_AUTO)?"fixed":"auto");
+	p += sprintf(p, "\tINDEX:%d", level);
+	p += sprintf(p, "\n");
 	return (p - buf + 1);
 }
 
-- 
1.5.3.6

