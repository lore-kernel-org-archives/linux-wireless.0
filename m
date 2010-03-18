Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:33152 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443Ab0CRK1n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Mar 2010 06:27:43 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH 07/21] wl1271: Add sysfs file to control BT co-ex state
Date: Thu, 18 Mar 2010 12:26:32 +0200
Message-Id: <1268908006-16992-8-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1268908006-16992-1-git-send-email-luciano.coelho@nokia.com>
References: <1268908006-16992-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

Add a sysfs file to control the state of the BT co-ex (enable or disable it.)
By default, the BT co-ex is enabled.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271.h      |    2 +
 drivers/net/wireless/wl12xx/wl1271_acx.c  |    7 ++-
 drivers/net/wireless/wl12xx/wl1271_acx.h  |    2 +-
 drivers/net/wireless/wl12xx/wl1271_init.c |    2 +-
 drivers/net/wireless/wl12xx/wl1271_main.c |   72 +++++++++++++++++++++++++++++
 5 files changed, 81 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271.h b/drivers/net/wireless/wl12xx/wl1271.h
index 7397999..23a0c7e 100644
--- a/drivers/net/wireless/wl12xx/wl1271.h
+++ b/drivers/net/wireless/wl12xx/wl1271.h
@@ -484,6 +484,8 @@ struct wl1271 {
 	/* Current chipset configuration */
 	struct conf_drv_settings conf;
 
+	bool sg_enabled;
+
 	struct list_head list;
 };
 
diff --git a/drivers/net/wireless/wl12xx/wl1271_acx.c b/drivers/net/wireless/wl12xx/wl1271_acx.c
index e7c22d3..7e337ce 100644
--- a/drivers/net/wireless/wl12xx/wl1271_acx.c
+++ b/drivers/net/wireless/wl12xx/wl1271_acx.c
@@ -534,7 +534,7 @@ out:
 }
 
 
-int wl1271_acx_sg_enable(struct wl1271 *wl)
+int wl1271_acx_sg_enable(struct wl1271 *wl, bool enable)
 {
 	struct acx_bt_wlan_coex *pta;
 	int ret;
@@ -547,7 +547,10 @@ int wl1271_acx_sg_enable(struct wl1271 *wl)
 		goto out;
 	}
 
-	pta->enable = wl->conf.sg.state;
+	if (enable)
+		pta->enable = wl->conf.sg.state;
+	else
+		pta->enable = CONF_SG_DISABLE;
 
 	ret = wl1271_cmd_configure(wl, ACX_SG_ENABLE, pta, sizeof(*pta));
 	if (ret < 0) {
diff --git a/drivers/net/wireless/wl12xx/wl1271_acx.h b/drivers/net/wireless/wl12xx/wl1271_acx.h
index dee3c06..8e5870f 100644
--- a/drivers/net/wireless/wl12xx/wl1271_acx.h
+++ b/drivers/net/wireless/wl12xx/wl1271_acx.h
@@ -1005,7 +1005,7 @@ int wl1271_acx_dco_itrim_params(struct wl1271 *wl);
 int wl1271_acx_beacon_filter_opt(struct wl1271 *wl, bool enable_filter);
 int wl1271_acx_beacon_filter_table(struct wl1271 *wl);
 int wl1271_acx_conn_monit_params(struct wl1271 *wl);
-int wl1271_acx_sg_enable(struct wl1271 *wl);
+int wl1271_acx_sg_enable(struct wl1271 *wl, bool enable);
 int wl1271_acx_sg_cfg(struct wl1271 *wl);
 int wl1271_acx_cca_threshold(struct wl1271 *wl);
 int wl1271_acx_bcn_dtim_options(struct wl1271 *wl);
diff --git a/drivers/net/wireless/wl12xx/wl1271_init.c b/drivers/net/wireless/wl12xx/wl1271_init.c
index d68445c..d9335fc 100644
--- a/drivers/net/wireless/wl12xx/wl1271_init.c
+++ b/drivers/net/wireless/wl12xx/wl1271_init.c
@@ -164,7 +164,7 @@ int wl1271_init_pta(struct wl1271 *wl)
 	if (ret < 0)
 		return ret;
 
-	ret = wl1271_acx_sg_enable(wl);
+	ret = wl1271_acx_sg_enable(wl, wl->sg_enabled);
 	if (ret < 0)
 		return ret;
 
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index ad9c491..abf9f22 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -1982,6 +1982,68 @@ static const struct ieee80211_ops wl1271_ops = {
 	CFG80211_TESTMODE_CMD(wl1271_tm_cmd)
 };
 
+static ssize_t wl1271_sysfs_show_bt_coex_state(struct device *dev,
+					       struct device_attribute *attr,
+					       char *buf)
+{
+	struct wl1271 *wl = dev_get_drvdata(dev);
+	ssize_t len;
+
+	/* FIXME: what's the maximum length of buf? page size?*/
+	len = 500;
+
+	mutex_lock(&wl->mutex);
+	len = snprintf(buf, len, "%d\n\n0 - off\n1 - on\n",
+		       wl->sg_enabled);
+	mutex_unlock(&wl->mutex);
+
+	return len;
+
+}
+
+static ssize_t wl1271_sysfs_store_bt_coex_state(struct device *dev,
+						struct device_attribute *attr,
+						const char *buf, size_t count)
+{
+	struct wl1271 *wl = dev_get_drvdata(dev);
+	unsigned long res;
+	int ret;
+
+	ret = strict_strtoul(buf, 10, &res);
+
+	if (ret < 0) {
+		wl1271_warning("incorrect value written to bt_coex_mode");
+		return count;
+	}
+
+	mutex_lock(&wl->mutex);
+
+	res = !!res;
+
+	if (res == wl->sg_enabled)
+		goto out;
+
+	wl->sg_enabled = res;
+
+	if (wl->state == WL1271_STATE_OFF)
+		goto out;
+
+	ret = wl1271_ps_elp_wakeup(wl, false);
+	if (ret < 0)
+		goto out;
+
+	wl1271_acx_sg_enable(wl, wl->sg_enabled);
+	wl1271_ps_elp_sleep(wl);
+
+ out:
+	mutex_unlock(&wl->mutex);
+	return count;
+}
+
+static DEVICE_ATTR(bt_coex_state, S_IRUGO | S_IWUSR,
+		   wl1271_sysfs_show_bt_coex_state,
+		   wl1271_sysfs_store_bt_coex_state);
+
 int wl1271_register_hw(struct wl1271 *wl)
 {
 	int ret;
@@ -2073,6 +2135,7 @@ struct ieee80211_hw *wl1271_alloc_hw(void)
 	wl->band = IEEE80211_BAND_2GHZ;
 	wl->vif = NULL;
 	wl->flags = 0;
+	wl->sg_enabled = true;
 
 	for (i = 0; i < ACX_TX_DESCRIPTORS; i++)
 		wl->tx_frames[i] = NULL;
@@ -2095,9 +2158,18 @@ struct ieee80211_hw *wl1271_alloc_hw(void)
 	}
 	dev_set_drvdata(&wl1271_device.dev, wl);
 
+	/* Create sysfs file to control bt coex state */
+	ret = device_create_file(&wl1271_device.dev, &dev_attr_bt_coex_state);
+	if (ret < 0) {
+		wl1271_error("failed to create sysfs file bt_coex_state");
+		goto err_platform;
+	}
 
 	return hw;
 
+err_platform:
+	platform_device_unregister(&wl1271_device);
+
 err_hw:
 	ieee80211_unregister_hw(wl->hw);
 
-- 
1.6.3.3

