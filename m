Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.platinumzone24.at ([88.198.159.93]:42878 "EHLO
	mail.platinumzone24.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753815Ab1A3TLI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Jan 2011 14:11:08 -0500
Message-ID: <4D45B7BD.8090907@davizone.at>
Date: Sun, 30 Jan 2011 20:10:53 +0100
From: David Gnedt <david.gnedt@davizone.at>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org, Kalle Valo <kvalo@adurom.com>,
	Grazvydas Ignotas <notasas@gmail.com>,
	Denis 'GNUtoo' Carikli <GNUtoo@no-log.org>
Subject: [PATCH 04/18] wl1251: add sysfs interface for bluetooth coexistence
 mode configuration
References: <4D45A5A5.5090909@davizone.at>
In-Reply-To: <4D45A5A5.5090909@davizone.at>
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Port the bt_coex_mode sysfs interface from wl1251 driver version included
in the Maemo Fremantle kernel to allow bt-coexistence mode configuration.
This enables userspace applications to set one of the modes
WL1251_BT_COEX_OFF, WL1251_BT_COEX_ENABLE and WL1251_BT_COEX_MONOAUDIO.
The default mode is WL1251_BT_COEX_OFF.
It should be noted that this driver always enabled bt-coexistence before
and enabled bt-coexistence directly affects the receiving performance,
rendering it unusable in some low-signal situations. Especially monitor
mode is affected very badly with bt-coexistence enabled.

Signed-off-by: David Gnedt <david.gnedt@davizone.at>
---
Sorry for the partly broken patches, I thought I configured my client the
right way. I tried to stop the mails at my mailserver, but it was mostly
already too late.
---
 drivers/net/wireless/wl1251/acx.c    |   43 ++++++++++++-
 drivers/net/wireless/wl1251/acx.h    |    8 ++-
 drivers/net/wireless/wl1251/init.c   |    6 +--
 drivers/net/wireless/wl1251/main.c   |  108 ++++++++++++++++++++++++++++++++++
 drivers/net/wireless/wl1251/wl1251.h |    8 +++
 5 files changed, 161 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/wl1251/acx.c b/drivers/net/wireless/wl1251/acx.c
index 64a0214..960149e 100644
--- a/drivers/net/wireless/wl1251/acx.c
+++ b/drivers/net/wireless/wl1251/acx.c
@@ -583,7 +583,7 @@ out:
 	return ret;
 }
 
-int wl1251_acx_sg_enable(struct wl1251 *wl)
+int wl1251_acx_sg_enable(struct wl1251 *wl, u8 mode)
 {
 	struct acx_bt_wlan_coex *pta;
 	int ret;
@@ -596,7 +596,7 @@ int wl1251_acx_sg_enable(struct wl1251 *wl)
 		goto out;
 	}
 
-	pta->enable = SG_ENABLE;
+	pta->enable = mode;
 
 	ret = wl1251_cmd_configure(wl, ACX_SG_ENABLE, pta, sizeof(*pta));
 	if (ret < 0) {
@@ -609,7 +609,7 @@ out:
 	return ret;
 }
 
-int wl1251_acx_sg_cfg(struct wl1251 *wl)
+int wl1251_acx_sg_cfg(struct wl1251 *wl, u16 wake_up_beacon)
 {
 	struct acx_bt_wlan_coex_param *param;
 	int ret;
@@ -634,7 +634,7 @@ int wl1251_acx_sg_cfg(struct wl1251 *wl)
 	param->wlan_cycle_fast = PTA_CYCLE_TIME_FAST_DEF;
 	param->bt_anti_starvation_period = PTA_ANTI_STARVE_PERIOD_DEF;
 	param->next_bt_lp_packet = PTA_TIMEOUT_NEXT_BT_LP_PACKET_DEF;
-	param->wake_up_beacon = PTA_TIME_BEFORE_BEACON_DEF;
+	param->wake_up_beacon = wake_up_beacon;
 	param->hp_dm_max_guard_time = PTA_HPDM_MAX_TIME_DEF;
 	param->next_wlan_packet = PTA_TIME_OUT_NEXT_WLAN_DEF;
 	param->antenna_type = PTA_ANTENNA_TYPE_DEF;
@@ -663,6 +663,41 @@ out:
 	return ret;
 }
 
+int wl1251_acx_sg_configure(struct wl1251 *wl, bool force)
+{
+	int ret;
+
+	if (wl->state == WL1251_STATE_OFF && !force)
+		return 0;
+
+	switch (wl->bt_coex_mode) {
+	case WL1251_BT_COEX_OFF:
+		ret = wl1251_acx_sg_enable(wl, SG_DISABLE);
+		if (ret)
+			break;
+		ret = wl1251_acx_sg_cfg(wl, 0);
+		break;
+	case WL1251_BT_COEX_ENABLE:
+		ret = wl1251_acx_sg_enable(wl, SG_ENABLE);
+		if (ret)
+			break;
+		ret = wl1251_acx_sg_cfg(wl, PTA_TIME_BEFORE_BEACON_DEF);
+		break;
+	case WL1251_BT_COEX_MONOAUDIO:
+		ret = wl1251_acx_sg_enable(wl, SG_ENABLE);
+		if (ret)
+			break;
+		ret = wl1251_acx_sg_cfg(wl, PTA_TIME_BEFORE_BEACON_MONO_AUDIO);
+		break;
+	default:
+		wl1251_error("Invalid BT co-ex mode!");
+		ret = -EOPNOTSUPP;
+		break;
+	}
+
+	return ret;
+}
+
 int wl1251_acx_cca_threshold(struct wl1251 *wl)
 {
 	struct acx_energy_detection *detection;
diff --git a/drivers/net/wireless/wl1251/acx.h b/drivers/net/wireless/wl1251/acx.h
index efcc3aa..04d4073 100644
--- a/drivers/net/wireless/wl1251/acx.h
+++ b/drivers/net/wireless/wl1251/acx.h
@@ -515,7 +515,8 @@ struct acx_bt_wlan_coex {
 #define PTA_ANTI_STARVE_PERIOD_DEF	  (500)
 #define PTA_ANTI_STARVE_NUM_CYCLE_DEF	  (4)
 #define PTA_ALLOW_PA_SD_DEF		  (1)
-#define PTA_TIME_BEFORE_BEACON_DEF	  (6300)
+#define PTA_TIME_BEFORE_BEACON_DEF	  (500)
+#define PTA_TIME_BEFORE_BEACON_MONO_AUDIO (6300)
 #define PTA_HPDM_MAX_TIME_DEF		  (1600)
 #define PTA_TIME_OUT_NEXT_WLAN_DEF	  (2550)
 #define PTA_AUTO_MODE_NO_CTS_DEF	  (0)
@@ -1387,8 +1388,9 @@ int wl1251_acx_rts_threshold(struct wl1251 *wl, u16 rts_threshold);
 int wl1251_acx_beacon_filter_opt(struct wl1251 *wl, bool enable_filter);
 int wl1251_acx_beacon_filter_table(struct wl1251 *wl);
 int wl1251_acx_conn_monit_params(struct wl1251 *wl);
-int wl1251_acx_sg_enable(struct wl1251 *wl);
-int wl1251_acx_sg_cfg(struct wl1251 *wl);
+int wl1251_acx_sg_enable(struct wl1251 *wl, u8 mode);
+int wl1251_acx_sg_cfg(struct wl1251 *wl, u16 wake_up_beacon);
+int wl1251_acx_sg_configure(struct wl1251 *wl, bool force);
 int wl1251_acx_cca_threshold(struct wl1251 *wl);
 int wl1251_acx_bcn_dtim_options(struct wl1251 *wl);
 int wl1251_acx_aid(struct wl1251 *wl, u16 aid);
diff --git a/drivers/net/wireless/wl1251/init.c b/drivers/net/wireless/wl1251/init.c
index 89b43d3..a6ad223 100644
--- a/drivers/net/wireless/wl1251/init.c
+++ b/drivers/net/wireless/wl1251/init.c
@@ -162,11 +162,7 @@ int wl1251_hw_init_pta(struct wl1251 *wl)
 {
 	int ret;
 
-	ret = wl1251_acx_sg_enable(wl);
-	if (ret < 0)
-		return ret;
-
-	ret = wl1251_acx_sg_cfg(wl);
+	ret = wl1251_acx_sg_configure(wl, true);
 	if (ret < 0)
 		return ret;
 
diff --git a/drivers/net/wireless/wl1251/main.c b/drivers/net/wireless/wl1251/main.c
index 2c95b90..86f3136 100644
--- a/drivers/net/wireless/wl1251/main.c
+++ b/drivers/net/wireless/wl1251/main.c
@@ -27,6 +27,7 @@
 #include <linux/crc32.h>
 #include <linux/etherdevice.h>
 #include <linux/vmalloc.h>
+#include <linux/platform_device.h>
 #include <linux/slab.h>
 
 #include "wl1251.h"
@@ -1214,6 +1215,94 @@ static const struct ieee80211_ops wl1251_ops = {
 	.get_survey = wl1251_op_get_survey,
 };
 
+static ssize_t wl1251_sysfs_show_bt_coex_mode(struct device *dev,
+					      struct device_attribute *attr,
+					      char *buf)
+{
+	struct wl1251 *wl = dev_get_drvdata(dev);
+	ssize_t len;
+
+	/* FIXME: what's the maximum length of buf? page size?*/
+	len = 500;
+
+	mutex_lock(&wl->mutex);
+	len = snprintf(buf, len, "%d\n\n%d - off\n%d - on\n%d - monoaudio\n",
+		       wl->bt_coex_mode,
+		       WL1251_BT_COEX_OFF,
+		       WL1251_BT_COEX_ENABLE,
+		       WL1251_BT_COEX_MONOAUDIO);
+	mutex_unlock(&wl->mutex);
+
+	return len;
+
+}
+
+static ssize_t wl1251_sysfs_store_bt_coex_mode(struct device *dev,
+					       struct device_attribute *attr,
+					       const char *buf, size_t count)
+{
+	struct wl1251 *wl = dev_get_drvdata(dev);
+	unsigned long res;
+	int ret;
+
+	ret = strict_strtoul(buf, 10, &res);
+
+	if (ret < 0) {
+		wl1251_warning("incorrect value written to bt_coex_mode");
+		return count;
+	}
+
+	mutex_lock(&wl->mutex);
+
+	if (res == wl->bt_coex_mode)
+		goto out;
+
+	switch (res) {
+	case WL1251_BT_COEX_OFF:
+	case WL1251_BT_COEX_ENABLE:
+	case WL1251_BT_COEX_MONOAUDIO:
+		wl->bt_coex_mode = res;
+		break;
+	default:
+		wl1251_warning("incorrect value written to bt_coex_mode");
+		goto out;
+	}
+
+	if (wl->state == WL1251_STATE_OFF)
+		goto out;
+
+	ret = wl1251_ps_elp_wakeup(wl);
+	if (ret < 0)
+		goto out;
+
+	wl1251_acx_sg_configure(wl, false);
+	wl1251_ps_elp_sleep(wl);
+
+out:
+	mutex_unlock(&wl->mutex);
+	return count;
+}
+
+static DEVICE_ATTR(bt_coex_mode, S_IRUGO | S_IWUSR,
+		   wl1251_sysfs_show_bt_coex_mode,
+		   wl1251_sysfs_store_bt_coex_mode);
+
+static void wl1251_device_release(struct device *dev)
+{
+
+}
+
+static struct platform_device wl1251_device = {
+	/* FIXME: use wl12xx name to not break the user space */
+	.name		= "wl12xx",
+	.id		= -1,
+
+	/* device model insists to have a release function */
+	.dev            = {
+		.release = wl1251_device_release,
+	},
+};
+
 static int wl1251_read_eeprom_byte(struct wl1251 *wl, off_t offset, u8 *data)
 {
 	unsigned long timeout;
@@ -1326,6 +1415,22 @@ int wl1251_init_ieee80211(struct wl1251 *wl)
 	if (ret)
 		goto out;
 
+	/* Register platform device */
+	ret = platform_device_register(&wl1251_device);
+	if (ret) {
+		wl1251_error("couldn't register platform device");
+		goto out;
+	}
+	dev_set_drvdata(&wl1251_device.dev, wl);
+
+
+	/* Create sysfs file to control bt coex state */
+	ret = device_create_file(&wl1251_device.dev, &dev_attr_bt_coex_mode);
+	if (ret < 0) {
+		wl1251_error("failed to create sysfs file bt_coex_mode");
+		goto out;
+	}
+
 	wl1251_debugfs_init(wl);
 	wl1251_notice("initialized");
 
@@ -1378,6 +1483,7 @@ struct ieee80211_hw *wl1251_alloc_hw(void)
 	wl->beacon_int = WL1251_DEFAULT_BEACON_INT;
 	wl->dtim_period = WL1251_DEFAULT_DTIM_PERIOD;
 	wl->vif = NULL;
+	wl->bt_coex_mode = WL1251_BT_COEX_OFF;
 
 	for (i = 0; i < FW_TX_CMPLT_BLOCK_SIZE; i++)
 		wl->tx_frames[i] = NULL;
@@ -1417,6 +1523,8 @@ int wl1251_free_hw(struct wl1251 *wl)
 
 	wl1251_debugfs_exit(wl);
 
+	platform_device_unregister(&wl1251_device);
+
 	kfree(wl->target_mem_map);
 	kfree(wl->data_path);
 	vfree(wl->fw);
diff --git a/drivers/net/wireless/wl1251/wl1251.h b/drivers/net/wireless/wl1251/wl1251.h
index c0ce2c8..2877023 100644
--- a/drivers/net/wireless/wl1251/wl1251.h
+++ b/drivers/net/wireless/wl1251/wl1251.h
@@ -251,6 +251,12 @@ struct wl1251_debugfs {
 	struct dentry *excessive_retries;
 };
 
+enum wl1251_bt_coex_mode {
+	WL1251_BT_COEX_OFF,
+	WL1251_BT_COEX_ENABLE,
+	WL1251_BT_COEX_MONOAUDIO
+};
+
 struct wl1251_if_operations {
 	void (*read)(struct wl1251 *wl, int addr, void *buf, size_t len);
 	void (*write)(struct wl1251 *wl, int addr, void *buf, size_t len);
@@ -380,6 +386,8 @@ struct wl1251 {
 
 	struct ieee80211_vif *vif;
 
+	enum wl1251_bt_coex_mode bt_coex_mode;
+
 	u32 chip_id;
 	char fw_ver[21];
 
-- 
1.7.0.4


