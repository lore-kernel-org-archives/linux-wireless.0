Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog119.obsmtp.com ([74.125.149.246]:58970 "EHLO
	na3sys009aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757993Ab2HHMCM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Aug 2012 08:02:12 -0400
Received: by obbtb18 with SMTP id tb18so1302597obb.35
        for <linux-wireless@vger.kernel.org>; Wed, 08 Aug 2012 05:02:10 -0700 (PDT)
From: Victor Goldenshtein <victorg@ti.com>
To: <hostap@lists.shmoo.com>
Cc: <linux-wireless@vger.kernel.org>, <kgiori@qca.qualcomm.com>,
	<mcgrof@frijolero.org>, <zefir.kurtisi@neratec.com>,
	<adrian.chadd@gmail.com>, <j@w1.fi>, <johannes@sipsolutions.net>,
	<coelho@ti.com>, <assaf@ti.com>, <yoni.divinsky@ti.com>,
	<igalc@ti.com>, <adrian@freebsd.org>, <nbd@nbd.name>,
	<simon.wunderlich@s2003.tu-chemnitz.de>
Subject: [PATCH v3 1/7] hostapd: implement dfs drv ops functions
Date: Wed,  8 Aug 2012 14:55:32 +0300
Message-Id: <1344426938-1883-2-git-send-email-victorg@ti.com> (sfid-20120808_140220_059779_20569860)
In-Reply-To: <1344426938-1883-1-git-send-email-victorg@ti.com>
References: <1344426938-1883-1-git-send-email-victorg@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add nl80211 driver operation functions:
hostapd_enable_tx – to enable tx on DFS channel after
channel availability check.
hostapd_channel_switch – to handle channel switch request.
hostapd_start_radar_detection – to enable radar detection
on DFS channel.

Signed-hostap: Victor Goldenshtein <victorg@ti.com>
---
 src/ap/ap_config.h   |    3 ++
 src/ap/ap_drv_ops.c  |   95 ++++++++++++++++++++++++++++++++++++++++++++++++++
 src/ap/ap_drv_ops.h  |    5 +++
 src/ap/hostapd.h     |    6 +++
 src/drivers/driver.h |   48 +++++++++++++++++++++++++
 5 files changed, 157 insertions(+), 0 deletions(-)

diff --git a/src/ap/ap_config.h b/src/ap/ap_config.h
index bfb2d8a..c21a7a8 100644
--- a/src/ap/ap_config.h
+++ b/src/ap/ap_config.h
@@ -454,6 +454,9 @@ struct hostapd_config {
 
 	int ieee80211d;
 
+	/* DFS */
+	int channel_switch_count;
+
 	struct hostapd_tx_queue_params tx_queue[NUM_TX_QUEUES];
 
 	/*
diff --git a/src/ap/ap_drv_ops.c b/src/ap/ap_drv_ops.c
index 64c9c20..d1d9e8b 100644
--- a/src/ap/ap_drv_ops.c
+++ b/src/ap/ap_drv_ops.c
@@ -621,3 +621,98 @@ int hostapd_drv_send_action(struct hostapd_data *hapd, unsigned int freq,
 					 hapd->own_addr, hapd->own_addr, data,
 					 len, 0);
 }
+
+int hostapd_enable_tx(struct hostapd_data *hapd, int freq, int flags)
+{
+	struct os_time now;
+
+	if (!hapd->driver || !hapd->driver->enable_tx)
+		return 0;
+
+	if ((flags & HOSTAPD_CHAN_RADAR) &&
+	    !(hapd->iface->dfs_state & DFS_ENABLED)) {
+		wpa_printf(MSG_ERROR, "Can't enable tx, "
+			   "DFS functionality is not enabled");
+		return -1;
+	}
+
+	os_get_time(&now);
+
+	if ((flags & HOSTAPD_CHAN_RADAR) &&
+	    now.sec - hapd->iface->dfs_start_cac_ts < DFS_MIN_CAC_TIME_SEC) {
+		wpa_printf(MSG_ERROR, "Can't enable tx, "
+			   "DFS min CAC time hasn't passed");
+		return -1;
+	}
+
+	hapd->iface->dfs_start_cac_ts = 0;
+
+	return hapd->driver->enable_tx(hapd->drv_priv, freq);
+}
+
+
+int hostapd_channel_switch(struct hostapd_data *hapd, int freq, int flags,
+			   u8 tx_block, u8 post_switch_block_tx)
+{
+	struct hostapd_channel_switch params;
+
+	if (!hapd->driver || !hapd->driver->hapd_channel_switch)
+		return 0;
+
+	if ((flags & HOSTAPD_CHAN_RADAR) &&
+	    !(hapd->iface->dfs_state & DFS_ENABLED)) {
+		wpa_printf(MSG_ERROR, "Can't switch to radar channel, "
+			   "DFS functionality is not enabled");
+		return -1;
+	}
+
+	if (hapd->iface->conf->secondary_channel) {
+		wpa_printf(MSG_ERROR, "Channel switch is not supported "
+			   "with HT40");
+		return -1;
+	}
+
+	params.freq = freq;
+	params.tx_block = tx_block;
+	params.post_switch_block_tx = post_switch_block_tx;
+	params.ch_switch_count = hapd->iface->conf->channel_switch_count;
+
+	return hapd->driver->hapd_channel_switch(hapd->drv_priv, &params);
+}
+
+int hostapd_start_radar_detection(struct hostapd_data *hapd, int freq,
+				  int flags)
+{
+	int ret;
+	struct os_time now;
+
+	if (!hapd->driver || !hapd->driver->start_radar_detection)
+		return 0;
+
+	if (!(flags & HOSTAPD_CHAN_RADAR)) {
+		wpa_printf(MSG_ERROR, "Can't start radar detection, the channel"
+			   " %d is not DFS channel", (int)hapd->iconf->channel);
+		return -1;
+	}
+
+	if (!(hapd->iface->dfs_state & DFS_ENABLED)) {
+		wpa_printf(MSG_ERROR, "Can't start radar detection, "
+			   "DFS functionality is not enabled");
+		return -1;
+	}
+
+	if (hapd->iface->conf->secondary_channel) {
+		wpa_printf(MSG_ERROR, "Can't start radar detection, "
+			   "DFS functionality on HT40 is not supported");
+		return -1;
+	}
+
+	ret = hapd->driver->start_radar_detection(hapd->drv_priv, freq);
+	if (!ret) {
+		os_get_time(&now);
+		hapd->iface->dfs_start_cac_ts = now.sec;
+	} else
+		hapd->iface->dfs_start_cac_ts = 0;
+
+	return ret;
+}
diff --git a/src/ap/ap_drv_ops.h b/src/ap/ap_drv_ops.h
index 9c53b99..f36bec1 100644
--- a/src/ap/ap_drv_ops.h
+++ b/src/ap/ap_drv_ops.h
@@ -97,6 +97,11 @@ int hostapd_sta_assoc(struct hostapd_data *hapd, const u8 *addr,
 		      int reassoc, u16 status, const u8 *ie, size_t len);
 int hostapd_add_tspec(struct hostapd_data *hapd, const u8 *addr,
 		      u8 *tspec_ie, size_t tspec_ielen);
+int hostapd_enable_tx(struct hostapd_data *hapd, int freq, int flags);
+int hostapd_channel_switch(struct hostapd_data *hapd, int freq, int flags,
+			   u8 tx_block, u8 post_switch_block_tx);
+int hostapd_start_radar_detection(struct hostapd_data *hapd, int freq,
+				  int flags);
 
 
 #include "drivers/driver.h"
diff --git a/src/ap/hostapd.h b/src/ap/hostapd.h
index f7ed311..cdd7556 100644
--- a/src/ap/hostapd.h
+++ b/src/ap/hostapd.h
@@ -240,6 +240,12 @@ struct hostapd_iface {
 	int olbc_ht;
 
 	u16 ht_op_mode;
+
+	/* dfs states */
+	u8 dfs_state;
+	/* dfs start channel availability check time stamp */
+	os_time_t dfs_start_cac_ts;
+
 	void (*scan_cb)(struct hostapd_iface *iface);
 
 	int (*ctrl_iface_init)(struct hostapd_data *hapd);
diff --git a/src/drivers/driver.h b/src/drivers/driver.h
index 82b72cd..bc714e8 100644
--- a/src/drivers/driver.h
+++ b/src/drivers/driver.h
@@ -29,6 +29,19 @@
 #define HOSTAPD_CHAN_HT40MINUS 0x00000020
 #define HOSTAPD_CHAN_HT40 0x00000040
 
+/*
+ * DFS functionality is enabled.
+ */
+#define DFS_ENABLED			BIT(0)
+
+/*
+ * DFS Channel Availability Check Time - the time a system shall monitor a
+ * 'radar channel' for presence of radar prior to initiating a TX, spec defines
+ * it as 60 seconds.
+ * Driver will block any attempt to enable the TX prior this minimal CAC time.
+ */
+#define DFS_MIN_CAC_TIME_SEC		60
+
 /**
  * struct hostapd_channel_data - Channel information
  */
@@ -904,6 +917,16 @@ struct hostapd_freq_params {
 				 * enabled, secondary channel above primary */
 };
 
+struct hostapd_channel_switch {
+	int freq;
+	int tx_block;			/* immediately block the tx on the
+					 * operational channel
+					 * (prior channel switch) */
+	int post_switch_block_tx;	/* block tx on the target ch (after
+					 * channel switch) */
+	int ch_switch_count;
+};
+
 enum wpa_driver_if_type {
 	/**
 	 * WPA_IF_STATION - Station mode interface
@@ -2603,6 +2626,31 @@ struct wpa_driver_ops {
 	 * avoid frequency conflict in single channel concurrency.
 	 */
 	int (*switch_channel)(void *priv, unsigned int freq);
+
+	/**
+	 * hapd_channel_switch - Perform an AP channel switch
+	 * @priv: Private driver interface data
+	 * @params: Channels switch parameters
+	 * Returns: 0 on success, -1 on failure
+	 */
+	int (*hapd_channel_switch)(void *priv,
+				   struct hostapd_channel_switch *params);
+
+	/**
+	 * enable_tx - Enable TX
+	 * @priv: Private driver interface data
+	 * @freq: Frequency (in MHz) of the channel
+	 * Returns: 0 on success, -1 on failure
+	 */
+	int (*enable_tx)(void *priv, int freq);
+
+	/**
+	 * start_radar_detection - Listen for radar interference on the channel.
+	 * @priv: Private driver interface data
+	 * @freq: Frequency (in MHz) of the channel
+	 * Returns: 0 on success, -1 on failure
+	 */
+	int (*start_radar_detection)(void *priv, int freq);
 };
 
 
-- 
1.7.5.4

