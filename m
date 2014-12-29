Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:47245 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751858AbaL2GY1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Dec 2014 01:24:27 -0500
Received: by mail-wi0-f180.google.com with SMTP id n3so21143523wiv.13
        for <linux-wireless@vger.kernel.org>; Sun, 28 Dec 2014 22:24:26 -0800 (PST)
Received: from muse.ger.corp.intel.com (85-250-108-142.bb.netvision.net.il. [85.250.108.142])
        by mx.google.com with ESMTPSA id gb10sm23488030wjb.21.2014.12.28.22.24.25
        for <linux-wireless@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 28 Dec 2014 22:24:25 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: <linux-wireless@vger.kernel.org>
Subject: [PATCH 06/13] wlcore: enable sleep during AP mode operation
Date: Mon, 29 Dec 2014 08:24:06 +0200
Message-Id: <1419834253-18331-6-git-send-email-eliad@wizery.com> (sfid-20141229_072434_456233_D5408932)
In-Reply-To: <1419834253-18331-1-git-send-email-eliad@wizery.com>
References: <1419834253-18331-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kobi L <kobi.lev100@gmail.com>

Enable ELP authorization in AP mode and enable the use
of the wakeup bit in the ELP register.

Introduce AP role sleep configuration which is disabled
by default. When configured, it allows the AP to sleep
when ELP is authorized for it.

Signed-off-by: Kobi Leibovitch <kobi.lev100@gmail.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/ti/wl12xx/main.c   |  1 +
 drivers/net/wireless/ti/wl18xx/acx.c    | 32 ++++++++++++++++++++++++++++++++
 drivers/net/wireless/ti/wl18xx/acx.h    | 25 +++++++++++++++++++++++--
 drivers/net/wireless/ti/wl18xx/conf.h   | 23 ++++++++++++++++++++++-
 drivers/net/wireless/ti/wl18xx/main.c   |  7 +++++++
 drivers/net/wireless/ti/wlcore/hw_ops.h |  9 +++++++++
 drivers/net/wireless/ti/wlcore/init.c   |  8 ++++++--
 drivers/net/wireless/ti/wlcore/ps.c     |  6 ------
 drivers/net/wireless/ti/wlcore/wlcore.h |  1 +
 9 files changed, 101 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/ti/wl12xx/main.c
index b457069..42264e5 100644
--- a/drivers/net/wireless/ti/wl12xx/main.c
+++ b/drivers/net/wireless/ti/wl12xx/main.c
@@ -1731,6 +1731,7 @@ static struct wlcore_ops wl12xx_ops = {
 	.lnk_low_prio		= wl12xx_lnk_low_prio,
 	.interrupt_notify	= NULL,
 	.rx_ba_filter		= NULL,
+	.ap_sleep		= NULL,
 };
 
 static struct ieee80211_sta_ht_cap wl12xx_ht_cap = {
diff --git a/drivers/net/wireless/ti/wl18xx/acx.c b/drivers/net/wireless/ti/wl18xx/acx.c
index 9d4b9aa..67f2a0e 100644
--- a/drivers/net/wireless/ti/wl18xx/acx.c
+++ b/drivers/net/wireless/ti/wl18xx/acx.c
@@ -24,6 +24,7 @@
 #include "../wlcore/acx.h"
 
 #include "acx.h"
+#include "wl18xx.h"
 
 int wl18xx_acx_host_if_cfg_bitmap(struct wl1271 *wl, u32 host_cfg_bitmap,
 				  u32 sdio_blk_size, u32 extra_mem_blks,
@@ -250,3 +251,34 @@ out:
 	kfree(acx);
 	return ret;
 }
+
+int wl18xx_acx_ap_sleep(struct wl1271 *wl)
+{
+	struct wl18xx_priv *priv = wl->priv;
+	struct acx_ap_sleep_cfg *acx;
+	struct conf_ap_sleep_settings *conf = &priv->conf.ap_sleep;
+	int ret;
+
+	wl1271_debug(DEBUG_ACX, "acx config ap sleep");
+
+	acx = kzalloc(sizeof(*acx), GFP_KERNEL);
+	if (!acx) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	acx->idle_duty_cycle = conf->idle_duty_cycle;
+	acx->connected_duty_cycle = conf->connected_duty_cycle;
+	acx->max_stations_thresh = conf->max_stations_thresh;
+	acx->idle_conn_thresh = conf->idle_conn_thresh;
+
+	ret = wl1271_cmd_configure(wl, ACX_AP_SLEEP_CFG, acx, sizeof(*acx));
+	if (ret < 0) {
+		wl1271_warning("acx config ap-sleep failed: %d", ret);
+		goto out;
+	}
+
+out:
+	kfree(acx);
+	return ret;
+}
diff --git a/drivers/net/wireless/ti/wl18xx/acx.h b/drivers/net/wireless/ti/wl18xx/acx.h
index 1234bdc..4afccd4 100644
--- a/drivers/net/wireless/ti/wl18xx/acx.h
+++ b/drivers/net/wireless/ti/wl18xx/acx.h
@@ -34,8 +34,8 @@ enum {
 	ACX_AUTO_RX_STREAMING		 = 0x0055,
 	ACX_PEER_CAP			 = 0x0056,
 	ACX_INTERRUPT_NOTIFY		 = 0x0057,
-	ACX_RX_BA_FILTER		 = 0x0058
-
+	ACX_RX_BA_FILTER		 = 0x0058,
+	ACX_AP_SLEEP_CFG                 = 0x0059
 };
 
 /* numbers of bits the length field takes (add 1 for the actual number) */
@@ -347,6 +347,26 @@ struct wl18xx_acx_rx_ba_filter {
 	u32 enable;
 };
 
+struct acx_ap_sleep_cfg {
+	struct acx_header header;
+	/* Duty Cycle (20-80% of staying Awake) for IDLE AP
+	 * (0: disable)
+	 */
+	u8 idle_duty_cycle;
+	/* Duty Cycle (20-80% of staying Awake) for Connected AP
+	 * (0: disable)
+	 */
+	u8 connected_duty_cycle;
+	/* Maximum stations that are allowed to be connected to AP
+	 *  (255: no limit)
+	 */
+	u8 max_stations_thresh;
+	/* Timeout till enabling the Sleep Mechanism after data stops
+	 * [unit: 100 msec]
+	 */
+	u8 idle_conn_thresh;
+} __packed;
+
 int wl18xx_acx_host_if_cfg_bitmap(struct wl1271 *wl, u32 host_cfg_bitmap,
 				  u32 sdio_blk_size, u32 extra_mem_blks,
 				  u32 len_field_size);
@@ -359,5 +379,6 @@ int wl18xx_acx_set_peer_cap(struct wl1271 *wl,
 			    u32 rate_set, u8 hlid);
 int wl18xx_acx_interrupt_notify_config(struct wl1271 *wl, bool action);
 int wl18xx_acx_rx_ba_filter(struct wl1271 *wl, bool action);
+int wl18xx_acx_ap_sleep(struct wl1271 *wl);
 
 #endif /* __WL18XX_ACX_H__ */
diff --git a/drivers/net/wireless/ti/wl18xx/conf.h b/drivers/net/wireless/ti/wl18xx/conf.h
index e34302e..71f1ec4 100644
--- a/drivers/net/wireless/ti/wl18xx/conf.h
+++ b/drivers/net/wireless/ti/wl18xx/conf.h
@@ -23,7 +23,7 @@
 #define __WL18XX_CONF_H__
 
 #define WL18XX_CONF_MAGIC	0x10e100ca
-#define WL18XX_CONF_VERSION	(WLCORE_CONF_VERSION | 0x0006)
+#define WL18XX_CONF_VERSION	(WLCORE_CONF_VERSION | 0x0007)
 #define WL18XX_CONF_MASK	0x0000ffff
 #define WL18XX_CONF_SIZE	(WLCORE_CONF_SIZE + \
 				 sizeof(struct wl18xx_priv_conf))
@@ -110,12 +110,33 @@ struct wl18xx_ht_settings {
 	u8 mode;
 } __packed;
 
+struct conf_ap_sleep_settings {
+	/* Duty Cycle (20-80% of staying Awake) for IDLE AP
+	 * (0: disable)
+	 */
+	u8 idle_duty_cycle;
+	/* Duty Cycle (20-80% of staying Awake) for Connected AP
+	 * (0: disable)
+	 */
+	u8 connected_duty_cycle;
+	/* Maximum stations that are allowed to be connected to AP
+	 *  (255: no limit)
+	 */
+	u8 max_stations_thresh;
+	/* Timeout till enabling the Sleep Mechanism after data stops
+	 * [unit: 100 msec]
+	 */
+	u8 idle_conn_thresh;
+} __packed;
+
 struct wl18xx_priv_conf {
 	/* Module params structures */
 	struct wl18xx_ht_settings ht;
 
 	/* this structure is copied wholesale to FW */
 	struct wl18xx_mac_and_phy_params phy;
+
+	struct conf_ap_sleep_settings ap_sleep;
 } __packed;
 
 #endif /* __WL18XX_CONF_H__ */
diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index 7edb8a1..9e648a1 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -568,6 +568,12 @@ static struct wl18xx_priv_conf wl18xx_default_priv_conf = {
 		.high_power_val_2nd		= 0xff,
 		.tx_rf_margin			= 1,
 	},
+	.ap_sleep = {               /* disabled by default */
+		.idle_duty_cycle        = 0,
+		.connected_duty_cycle   = 0,
+		.max_stations_thresh    = 0,
+		.idle_conn_thresh       = 0,
+	},
 };
 
 static const struct wlcore_partition_set wl18xx_ptable[PART_TABLE_LEN] = {
@@ -1696,6 +1702,7 @@ static struct wlcore_ops wl18xx_ops = {
 	.smart_config_set_group_key = wl18xx_cmd_smart_config_set_group_key,
 	.interrupt_notify = wl18xx_acx_interrupt_notify_config,
 	.rx_ba_filter	= wl18xx_acx_rx_ba_filter,
+	.ap_sleep	= wl18xx_acx_ap_sleep,
 };
 
 /* HT cap appropriate for wide channels in 2Ghz */
diff --git a/drivers/net/wireless/ti/wlcore/hw_ops.h b/drivers/net/wireless/ti/wlcore/hw_ops.h
index c2545ce..449050b 100644
--- a/drivers/net/wireless/ti/wlcore/hw_ops.h
+++ b/drivers/net/wireless/ti/wlcore/hw_ops.h
@@ -234,6 +234,15 @@ wlcore_hw_rx_ba_filter(struct wl1271 *wl, bool action)
 }
 
 static inline int
+wlcore_hw_ap_sleep(struct wl1271 *wl)
+{
+	if (wl->ops->ap_sleep)
+		return wl->ops->ap_sleep(wl);
+
+	return 0;
+}
+
+static inline int
 wlcore_hw_set_peer_cap(struct wl1271 *wl,
 		       struct ieee80211_sta_ht_cap *ht_cap,
 		       bool allow_ht_operation,
diff --git a/drivers/net/wireless/ti/wlcore/init.c b/drivers/net/wireless/ti/wlcore/init.c
index 199e941..5ca1fb1 100644
--- a/drivers/net/wireless/ti/wlcore/init.c
+++ b/drivers/net/wireless/ti/wlcore/init.c
@@ -392,6 +392,11 @@ static int wl1271_ap_hw_init(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 	if (ret < 0)
 		return ret;
 
+	/* configure AP sleep, if enabled */
+	ret = wlcore_hw_ap_sleep(wl);
+	if (ret < 0)
+		return ret;
+
 	return 0;
 }
 
@@ -567,8 +572,7 @@ int wl1271_init_vif_specific(struct wl1271 *wl, struct ieee80211_vif *vif)
 	/* consider all existing roles before configuring psm. */
 
 	if (wl->ap_count == 0 && is_ap) { /* first AP */
-		/* Configure for power always on */
-		ret = wl1271_acx_sleep_auth(wl, WL1271_PSM_CAM);
+		ret = wl1271_acx_sleep_auth(wl, WL1271_PSM_ELP);
 		if (ret < 0)
 			return ret;
 
diff --git a/drivers/net/wireless/ti/wlcore/ps.c b/drivers/net/wireless/ti/wlcore/ps.c
index b52516e..f3ed543 100644
--- a/drivers/net/wireless/ti/wlcore/ps.c
+++ b/drivers/net/wireless/ti/wlcore/ps.c
@@ -56,9 +56,6 @@ void wl1271_elp_work(struct work_struct *work)
 		goto out;
 
 	wl12xx_for_each_wlvif(wl, wlvif) {
-		if (wlvif->bss_type == BSS_TYPE_AP_BSS)
-			goto out;
-
 		if (!test_bit(WLVIF_FLAG_IN_PS, &wlvif->flags) &&
 		    test_bit(WLVIF_FLAG_IN_USE, &wlvif->flags))
 			goto out;
@@ -95,9 +92,6 @@ void wl1271_ps_elp_sleep(struct wl1271 *wl)
 		return;
 
 	wl12xx_for_each_wlvif(wl, wlvif) {
-		if (wlvif->bss_type == BSS_TYPE_AP_BSS)
-			return;
-
 		if (!test_bit(WLVIF_FLAG_IN_PS, &wlvif->flags) &&
 		    test_bit(WLVIF_FLAG_IN_USE, &wlvif->flags))
 			return;
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
index 7860a4e..c8fe2ae 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -118,6 +118,7 @@ struct wlcore_ops {
 			     struct wl1271_link *lnk);
 	int (*interrupt_notify)(struct wl1271 *wl, bool action);
 	int (*rx_ba_filter)(struct wl1271 *wl, bool action);
+	int (*ap_sleep)(struct wl1271 *wl);
 	int (*smart_config_start)(struct wl1271 *wl, u32 group_bitmap);
 	int (*smart_config_stop)(struct wl1271 *wl);
 	int (*smart_config_set_group_key)(struct wl1271 *wl, u16 group_id,
-- 
1.8.5.2.229.g4448466.dirty

