Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog118.obsmtp.com ([74.125.149.244]:53356 "EHLO
	na3sys009aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751161Ab2AZMmX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jan 2012 07:42:23 -0500
Received: by yhjj72 with SMTP id j72so184318yhj.36
        for <linux-wireless@vger.kernel.org>; Thu, 26 Jan 2012 04:42:22 -0800 (PST)
From: Victor Goldenshtein <victorg@ti.com>
To: <hostap@lists.shmoo.com>
Cc: <linux-wireless@vger.kernel.org>, <kgiori@qca.qualcomm.com>,
	<mcgrof@frijolero.org>, <zefir.kurtisi@neratec.com>,
	<adrian.chadd@gmail.com>, <j@w1.fi>, <johannes@sipsolutions.net>,
	<coelho@ti.com>, <assaf@ti.com>, <yoni.divinsky@ti.com>,
	<igalc@ti.com>, <adrian@freebsd.org>, <nbd@nbd.name>
Subject: [RFC 1/7] hostapd: implement dfs drv ops functions
Date: Thu, 26 Jan 2012 14:41:23 +0200
Message-Id: <1327581689-22090-2-git-send-email-victorg@ti.com> (sfid-20120126_134227_069604_3CFFC812)
In-Reply-To: <1327581689-22090-1-git-send-email-victorg@ti.com>
References: <1327581689-22090-1-git-send-email-victorg@ti.com>
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

Signed-off-by: Victor Goldenshtein <victorg@ti.com>
---
 src/ap/ap_config.h   |    3 +++
 src/ap/ap_drv_ops.c  |   34 ++++++++++++++++++++++++++++++++++
 src/ap/ap_drv_ops.h  |    4 ++++
 src/drivers/driver.h |   34 ++++++++++++++++++++++++++++++++++
 4 files changed, 75 insertions(+), 0 deletions(-)

diff --git a/src/ap/ap_config.h b/src/ap/ap_config.h
index 485092d..eddc9b7 100644
--- a/src/ap/ap_config.h
+++ b/src/ap/ap_config.h
@@ -410,6 +410,9 @@ struct hostapd_config {
 
 	int ieee80211d;
 
+	/* DFS */
+	int channel_switch_count;
+
 	struct hostapd_tx_queue_params tx_queue[NUM_TX_QUEUES];
 
 	/*
diff --git a/src/ap/ap_drv_ops.c b/src/ap/ap_drv_ops.c
index 429c187..628f90e 100644
--- a/src/ap/ap_drv_ops.c
+++ b/src/ap/ap_drv_ops.c
@@ -590,3 +590,37 @@ int hostapd_drv_sta_disassoc(struct hostapd_data *hapd,
 	return hapd->driver->sta_disassoc(hapd->drv_priv, hapd->own_addr, addr,
 					  reason);
 }
+
+
+int hostapd_enable_tx(struct hostapd_data *hapd)
+{
+	if (!hapd->driver || !hapd->driver->enable_tx)
+		return 0;
+	return hapd->driver->enable_tx(hapd->drv_priv);
+}
+
+
+int hostapd_channel_switch(struct hostapd_data *hapd, int channel, int freq,
+			   u8 tx_block, u8 post_switch_block_tx)
+{
+	struct hostapd_channel_switch params;
+
+	if (!hapd->driver || !hapd->driver->channel_switch)
+		return 0;
+
+	params.channel = channel;
+	params.freq = freq;
+	params.tx_block = tx_block;
+	params.post_switch_block_tx = post_switch_block_tx;
+	params.ch_switch_count = hapd->iface->conf->channel_switch_count;
+
+	return hapd->driver->channel_switch(hapd->drv_priv, &params);
+}
+
+int hostapd_start_radar_detection(struct hostapd_data *hapd)
+{
+	if (!hapd->driver || !hapd->driver->start_radar_detection)
+		return 0;
+
+	return hapd->driver->start_radar_detection(hapd->drv_priv);
+}
diff --git a/src/ap/ap_drv_ops.h b/src/ap/ap_drv_ops.h
index 835cdde..051f6fa 100644
--- a/src/ap/ap_drv_ops.h
+++ b/src/ap/ap_drv_ops.h
@@ -100,6 +100,10 @@ int hostapd_sta_assoc(struct hostapd_data *hapd, const u8 *addr,
 		      int reassoc, u16 status, const u8 *ie, size_t len);
 int hostapd_add_tspec(struct hostapd_data *hapd, const u8 *addr,
 		      u8 *tspec_ie, size_t tspec_ielen);
+int hostapd_enable_tx(struct hostapd_data *hapd);
+int hostapd_channel_switch(struct hostapd_data *hapd, int channel, int freq,
+			   u8 tx_block, u8 post_switch_block_tx);
+int hostapd_start_radar_detection(struct hostapd_data *hapd);
 
 
 #include "drivers/driver.h"
diff --git a/src/drivers/driver.h b/src/drivers/driver.h
index d72c83b..512b4c3 100644
--- a/src/drivers/driver.h
+++ b/src/drivers/driver.h
@@ -847,6 +847,17 @@ struct hostapd_freq_params {
 				 * enabled, secondary channel above primary */
 };
 
+struct hostapd_channel_switch {
+	int freq;
+	int channel;
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
@@ -2483,6 +2494,29 @@ struct wpa_driver_ops {
 	 */
 	void (*poll_client)(void *priv, const u8 *own_addr,
 			    const u8 *addr, int qos);
+
+	/**
+	 * enable_tx - Enable TX
+	 * @priv: Private driver interface data
+	 * Returns: 0 on success, -1 on failure
+	 */
+	int (*enable_tx)(void *priv);
+
+	/**
+	 * channel_switch - Perform a channel switch
+	 * @priv: Private driver interface data
+	 * @params: Channels switch parameters
+	 * Returns: 0 on success, -1 on failure
+	 */
+	int (*channel_switch)(void *priv,
+			      struct hostapd_channel_switch *params);
+
+	/**
+	 * start_radar_detection - Listen for radar interference on the channel.
+	 * @priv: Private driver interface data
+	 * Returns: 0 on success, -1 on failure
+	 */
+	int (*start_radar_detection)(void *priv);
 };
 
 
-- 
1.7.5.4

