Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:49597 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834AbaL2GYZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Dec 2014 01:24:25 -0500
Received: by mail-wi0-f179.google.com with SMTP id ex7so21189002wid.6
        for <linux-wireless@vger.kernel.org>; Sun, 28 Dec 2014 22:24:23 -0800 (PST)
Received: from muse.ger.corp.intel.com (85-250-108-142.bb.netvision.net.il. [85.250.108.142])
        by mx.google.com with ESMTPSA id gb10sm23488030wjb.21.2014.12.28.22.24.21
        for <linux-wireless@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 28 Dec 2014 22:24:22 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: <linux-wireless@vger.kernel.org>
Subject: [PATCH 04/13] wlcore: add ability to reduce FW interrupts during suspend
Date: Mon, 29 Dec 2014 08:24:04 +0200
Message-Id: <1419834253-18331-4-git-send-email-eliad@wizery.com> (sfid-20141229_072429_874667_D7E80DED)
In-Reply-To: <1419834253-18331-1-git-send-email-eliad@wizery.com>
References: <1419834253-18331-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ram Amrani <ramrani@ti.com>

Add the ability to mask FW interrupts on RX BA activity, PSM
entry/exit and fast-link notifications. This is used when the host
is suspended in order to decrease redundant wake ups.

Signed-off-by: Ram Amrani <ramrani@ti.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/ti/wl12xx/main.c   |  3 ++
 drivers/net/wireless/ti/wl18xx/acx.c    | 56 +++++++++++++++++++++++++++
 drivers/net/wireless/ti/wl18xx/acx.h    | 25 +++++++++++-
 drivers/net/wireless/ti/wl18xx/main.c   |  3 ++
 drivers/net/wireless/ti/wlcore/conf.h   |  7 +++-
 drivers/net/wireless/ti/wlcore/hw_ops.h | 16 ++++++++
 drivers/net/wireless/ti/wlcore/main.c   | 68 ++++++++++++++++++++++-----------
 drivers/net/wireless/ti/wlcore/wlcore.h |  2 +
 8 files changed, 155 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/ti/wl12xx/main.c
index 0bccf12..b457069 100644
--- a/drivers/net/wireless/ti/wl12xx/main.c
+++ b/drivers/net/wireless/ti/wl12xx/main.c
@@ -250,6 +250,7 @@ static struct wlcore_conf wl12xx_conf = {
 		.keep_alive_interval         = 55000,
 		.max_listen_interval         = 20,
 		.sta_sleep_auth              = WL1271_PSM_ILLEGAL,
+		.suspend_rx_ba_activity      = 0,
 	},
 	.itrim = {
 		.enable = false,
@@ -1728,6 +1729,8 @@ static struct wlcore_ops wl12xx_ops = {
 	.convert_hwaddr		= wl12xx_convert_hwaddr,
 	.lnk_high_prio		= wl12xx_lnk_high_prio,
 	.lnk_low_prio		= wl12xx_lnk_low_prio,
+	.interrupt_notify	= NULL,
+	.rx_ba_filter		= NULL,
 };
 
 static struct ieee80211_sta_ht_cap wl12xx_ht_cap = {
diff --git a/drivers/net/wireless/ti/wl18xx/acx.c b/drivers/net/wireless/ti/wl18xx/acx.c
index a169bb5..9d4b9aa 100644
--- a/drivers/net/wireless/ti/wl18xx/acx.c
+++ b/drivers/net/wireless/ti/wl18xx/acx.c
@@ -194,3 +194,59 @@ out:
 	kfree(acx);
 	return ret;
 }
+
+/*
+ * When the host is suspended, we don't want to get any fast-link/PSM
+ * notifications
+ */
+int wl18xx_acx_interrupt_notify_config(struct wl1271 *wl,
+				       bool action)
+{
+	struct wl18xx_acx_interrupt_notify *acx;
+	int ret = 0;
+
+	acx = kzalloc(sizeof(*acx), GFP_KERNEL);
+	if (!acx) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	acx->enable = action;
+	ret = wl1271_cmd_configure(wl, ACX_INTERRUPT_NOTIFY, acx, sizeof(*acx));
+	if (ret < 0) {
+		wl1271_warning("acx interrupt notify setting failed: %d", ret);
+		goto out;
+	}
+
+out:
+	kfree(acx);
+	return ret;
+}
+
+/*
+ * When the host is suspended, we can configure the FW to disable RX BA
+ * notifications.
+ */
+int wl18xx_acx_rx_ba_filter(struct wl1271 *wl, bool action)
+{
+	struct wl18xx_acx_rx_ba_filter *acx;
+	int ret = 0;
+
+	acx = kzalloc(sizeof(*acx), GFP_KERNEL);
+	if (!acx) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	acx->enable = (u32)action;
+	ret = wl1271_cmd_configure(wl, ACX_RX_BA_FILTER, acx, sizeof(*acx));
+	if (ret < 0) {
+		wl1271_warning("acx rx ba activity filter setting failed: %d",
+			       ret);
+		goto out;
+	}
+
+out:
+	kfree(acx);
+	return ret;
+}
diff --git a/drivers/net/wireless/ti/wl18xx/acx.h b/drivers/net/wireless/ti/wl18xx/acx.h
index 0e636de..1234bdc 100644
--- a/drivers/net/wireless/ti/wl18xx/acx.h
+++ b/drivers/net/wireless/ti/wl18xx/acx.h
@@ -32,7 +32,10 @@ enum {
 	ACX_SIM_CONFIG			 = 0x0053,
 	ACX_CLEAR_STATISTICS		 = 0x0054,
 	ACX_AUTO_RX_STREAMING		 = 0x0055,
-	ACX_PEER_CAP			 = 0x0056
+	ACX_PEER_CAP			 = 0x0056,
+	ACX_INTERRUPT_NOTIFY		 = 0x0057,
+	ACX_RX_BA_FILTER		 = 0x0058
+
 };
 
 /* numbers of bits the length field takes (add 1 for the actual number) */
@@ -326,6 +329,24 @@ struct wlcore_acx_peer_cap {
 	u8 padding;
 } __packed;
 
+/*
+ * ACX_INTERRUPT_NOTIFY
+ * enable/disable fast-link/PSM notification from FW
+ */
+struct wl18xx_acx_interrupt_notify {
+	struct acx_header header;
+	u32 enable;
+};
+
+/*
+ * ACX_RX_BA_FILTER
+ * enable/disable RX BA filtering in FW
+ */
+struct wl18xx_acx_rx_ba_filter {
+	struct acx_header header;
+	u32 enable;
+};
+
 int wl18xx_acx_host_if_cfg_bitmap(struct wl1271 *wl, u32 host_cfg_bitmap,
 				  u32 sdio_blk_size, u32 extra_mem_blks,
 				  u32 len_field_size);
@@ -336,5 +357,7 @@ int wl18xx_acx_set_peer_cap(struct wl1271 *wl,
 			    struct ieee80211_sta_ht_cap *ht_cap,
 			    bool allow_ht_operation,
 			    u32 rate_set, u8 hlid);
+int wl18xx_acx_interrupt_notify_config(struct wl1271 *wl, bool action);
+int wl18xx_acx_rx_ba_filter(struct wl1271 *wl, bool action);
 
 #endif /* __WL18XX_ACX_H__ */
diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index 6946d18..7edb8a1 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -378,6 +378,7 @@ static struct wlcore_conf wl18xx_conf = {
 		.keep_alive_interval         = 55000,
 		.max_listen_interval         = 20,
 		.sta_sleep_auth              = WL1271_PSM_ILLEGAL,
+		.suspend_rx_ba_activity      = 0,
 	},
 	.itrim = {
 		.enable = false,
@@ -1693,6 +1694,8 @@ static struct wlcore_ops wl18xx_ops = {
 	.smart_config_start = wl18xx_cmd_smart_config_start,
 	.smart_config_stop  = wl18xx_cmd_smart_config_stop,
 	.smart_config_set_group_key = wl18xx_cmd_smart_config_set_group_key,
+	.interrupt_notify = wl18xx_acx_interrupt_notify_config,
+	.rx_ba_filter	= wl18xx_acx_rx_ba_filter,
 };
 
 /* HT cap appropriate for wide channels in 2Ghz */
diff --git a/drivers/net/wireless/ti/wlcore/conf.h b/drivers/net/wireless/ti/wlcore/conf.h
index 40995c4..166add0 100644
--- a/drivers/net/wireless/ti/wlcore/conf.h
+++ b/drivers/net/wireless/ti/wlcore/conf.h
@@ -997,6 +997,11 @@ struct conf_conn_settings {
 	 * whether we can go to ELP.
 	 */
 	u8 sta_sleep_auth;
+
+	/*
+	 * Default RX BA Activity filter configuration
+	 */
+	u8 suspend_rx_ba_activity;
 } __packed;
 
 enum {
@@ -1347,7 +1352,7 @@ struct conf_recovery_settings {
  * version, the two LSB are the lower driver's private conf
  * version.
  */
-#define WLCORE_CONF_VERSION	(0x0005 << 16)
+#define WLCORE_CONF_VERSION	(0x0006 << 16)
 #define WLCORE_CONF_MASK	0xffff0000
 #define WLCORE_CONF_SIZE	(sizeof(struct wlcore_conf_header) +	\
 				 sizeof(struct wlcore_conf))
diff --git a/drivers/net/wireless/ti/wlcore/hw_ops.h b/drivers/net/wireless/ti/wlcore/hw_ops.h
index 29ce55f..c2545ce 100644
--- a/drivers/net/wireless/ti/wlcore/hw_ops.h
+++ b/drivers/net/wireless/ti/wlcore/hw_ops.h
@@ -218,6 +218,22 @@ wlcore_hw_sta_rc_update(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 }
 
 static inline int
+wlcore_hw_interrupt_notify(struct wl1271 *wl, bool action)
+{
+	if (wl->ops->interrupt_notify)
+		return wl->ops->interrupt_notify(wl, action);
+	return 0;
+}
+
+static inline int
+wlcore_hw_rx_ba_filter(struct wl1271 *wl, bool action)
+{
+	if (wl->ops->rx_ba_filter)
+		return wl->ops->rx_ba_filter(wl, action);
+	return 0;
+}
+
+static inline int
 wlcore_hw_set_peer_cap(struct wl1271 *wl,
 		       struct ieee80211_sta_ht_cap *ht_cap,
 		       bool allow_ht_operation,
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index f6e37d5..aaa836b 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -1685,19 +1685,15 @@ static int wl1271_configure_suspend_sta(struct wl1271 *wl,
 	if (!test_bit(WLVIF_FLAG_STA_ASSOCIATED, &wlvif->flags))
 		goto out;
 
-	ret = wl1271_ps_elp_wakeup(wl);
-	if (ret < 0)
-		goto out;
-
 	ret = wl1271_configure_wowlan(wl, wow);
 	if (ret < 0)
-		goto out_sleep;
+		goto out;
 
 	if ((wl->conf.conn.suspend_wake_up_event ==
 	     wl->conf.conn.wake_up_event) &&
 	    (wl->conf.conn.suspend_listen_interval ==
 	     wl->conf.conn.listen_interval))
-		goto out_sleep;
+		goto out;
 
 	ret = wl1271_acx_wake_up_conditions(wl, wlvif,
 				    wl->conf.conn.suspend_wake_up_event,
@@ -1705,9 +1701,6 @@ static int wl1271_configure_suspend_sta(struct wl1271 *wl,
 
 	if (ret < 0)
 		wl1271_error("suspend: set wake up conditions failed: %d", ret);
-
-out_sleep:
-	wl1271_ps_elp_sleep(wl);
 out:
 	return ret;
 
@@ -1721,13 +1714,8 @@ static int wl1271_configure_suspend_ap(struct wl1271 *wl,
 	if (!test_bit(WLVIF_FLAG_AP_STARTED, &wlvif->flags))
 		goto out;
 
-	ret = wl1271_ps_elp_wakeup(wl);
-	if (ret < 0)
-		goto out;
-
 	ret = wl1271_acx_beacon_filter_opt(wl, wlvif, true);
 
-	wl1271_ps_elp_sleep(wl);
 out:
 	return ret;
 
@@ -1756,10 +1744,6 @@ static void wl1271_configure_resume(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 	if (is_sta && !test_bit(WLVIF_FLAG_STA_ASSOCIATED, &wlvif->flags))
 		return;
 
-	ret = wl1271_ps_elp_wakeup(wl);
-	if (ret < 0)
-		return;
-
 	if (is_sta) {
 		wl1271_configure_wowlan(wl, NULL);
 
@@ -1767,7 +1751,7 @@ static void wl1271_configure_resume(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 		     wl->conf.conn.wake_up_event) &&
 		    (wl->conf.conn.suspend_listen_interval ==
 		     wl->conf.conn.listen_interval))
-			goto out_sleep;
+			return;
 
 		ret = wl1271_acx_wake_up_conditions(wl, wlvif,
 				    wl->conf.conn.wake_up_event,
@@ -1780,9 +1764,6 @@ static void wl1271_configure_resume(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 	} else if (is_ap) {
 		ret = wl1271_acx_beacon_filter_opt(wl, wlvif, false);
 	}
-
-out_sleep:
-	wl1271_ps_elp_sleep(wl);
 }
 
 static int wl1271_op_suspend(struct ieee80211_hw *hw,
@@ -1804,6 +1785,11 @@ static int wl1271_op_suspend(struct ieee80211_hw *hw,
 	wl1271_tx_flush(wl);
 
 	mutex_lock(&wl->mutex);
+
+	ret = wl1271_ps_elp_wakeup(wl);
+	if (ret < 0)
+		return ret;
+
 	wl->wow_enabled = true;
 	wl12xx_for_each_wlvif(wl, wlvif) {
 		ret = wl1271_configure_suspend(wl, wlvif, wow);
@@ -1813,7 +1799,27 @@ static int wl1271_op_suspend(struct ieee80211_hw *hw,
 			return ret;
 		}
 	}
+
+	/* disable fast link flow control notifications from FW */
+	ret = wlcore_hw_interrupt_notify(wl, false);
+	if (ret < 0)
+		goto out_sleep;
+
+	/* if filtering is enabled, configure the FW to drop all RX BA frames */
+	ret = wlcore_hw_rx_ba_filter(wl,
+				     !!wl->conf.conn.suspend_rx_ba_activity);
+	if (ret < 0)
+		goto out_sleep;
+
+out_sleep:
+	wl1271_ps_elp_sleep(wl);
 	mutex_unlock(&wl->mutex);
+
+	if (ret < 0) {
+		wl1271_warning("couldn't prepare device to suspend");
+		return ret;
+	}
+
 	/* flush any remaining work */
 	wl1271_debug(DEBUG_MAC80211, "flushing remaining works");
 
@@ -1887,13 +1893,29 @@ static int wl1271_op_resume(struct ieee80211_hw *hw)
 	if (pending_recovery) {
 		wl1271_warning("queuing forgotten recovery on resume");
 		ieee80211_queue_work(wl->hw, &wl->recovery_work);
-		goto out;
+		goto out_sleep;
 	}
 
+	ret = wl1271_ps_elp_wakeup(wl);
+	if (ret < 0)
+		goto out;
+
 	wl12xx_for_each_wlvif(wl, wlvif) {
 		wl1271_configure_resume(wl, wlvif);
 	}
 
+	ret = wlcore_hw_interrupt_notify(wl, true);
+	if (ret < 0)
+		goto out_sleep;
+
+	/* if filtering is enabled, configure the FW to drop all RX BA frames */
+	ret = wlcore_hw_rx_ba_filter(wl, false);
+	if (ret < 0)
+		goto out_sleep;
+
+out_sleep:
+	wl1271_ps_elp_sleep(wl);
+
 out:
 	wl->wow_enabled = false;
 
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
index 2440ebe..7860a4e 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -116,6 +116,8 @@ struct wlcore_ops {
 			      struct wl1271_link *lnk);
 	bool (*lnk_low_prio)(struct wl1271 *wl, u8 hlid,
 			     struct wl1271_link *lnk);
+	int (*interrupt_notify)(struct wl1271 *wl, bool action);
+	int (*rx_ba_filter)(struct wl1271 *wl, bool action);
 	int (*smart_config_start)(struct wl1271 *wl, u32 group_bitmap);
 	int (*smart_config_stop)(struct wl1271 *wl);
 	int (*smart_config_set_group_key)(struct wl1271 *wl, u16 group_id,
-- 
1.8.5.2.229.g4448466.dirty

