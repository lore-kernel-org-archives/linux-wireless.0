Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:63692 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751463Ab1BBJMY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Feb 2011 04:12:24 -0500
Received: by wwa36 with SMTP id 36so8015126wwa.1
        for <linux-wireless@vger.kernel.org>; Wed, 02 Feb 2011 01:12:22 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/3] wl12xx: add support for rx streaming
Date: Wed,  2 Feb 2011 11:12:17 +0200
Message-Id: <1296637939-26729-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

wl1271 supports a feature called "rx streaming".
when in ps mode, and @timeout msecs have passed since last tx, it issues
trigger packets (QoS-null/PS-Poll according to the ac type) in const
intervals (in order to reduce rx time).

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
Note: this patchset is rebased on top of the new firmware api patchset,
      although the feature exists in the older firmware as well.
 drivers/net/wireless/wl12xx/acx.c  |   37 ++++++++++++++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/acx.h  |   14 +++++++++++++
 drivers/net/wireless/wl12xx/conf.h |   25 ++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/main.c |    7 +++++-
 4 files changed, 82 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/acx.c b/drivers/net/wireless/wl12xx/acx.c
index 33840d9..54aec2e 100644
--- a/drivers/net/wireless/wl12xx/acx.c
+++ b/drivers/net/wireless/wl12xx/acx.c
@@ -1489,6 +1489,43 @@ out:
 	return ret;
 }
 
+int wl1271_acx_ps_rx_streaming(struct wl1271 *wl)
+{
+	struct wl1271_acx_ps_rx_streaming *rx_streaming;
+	u32 rx_streaming_queues;
+	int ret, i;
+
+	wl1271_debug(DEBUG_ACX, "acx ps rx streaming");
+
+	rx_streaming = kzalloc(sizeof(*rx_streaming), GFP_KERNEL);
+	if (!rx_streaming) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	rx_streaming_queues = wl->conf.rx_streaming.queues;
+	for (i = 0; i < 8; i++) {
+		rx_streaming->tid = i;
+		rx_streaming->enable = rx_streaming_queues & 1;
+		rx_streaming->period = wl->conf.rx_streaming.interval;
+		rx_streaming->timeout = wl->conf.rx_streaming.interval;
+
+		ret = wl1271_cmd_configure(wl, ACX_PS_RX_STREAMING,
+					   rx_streaming,
+					   sizeof(*rx_streaming));
+		if (ret < 0) {
+			wl1271_warning("acx ps rx streaming failed: %d", ret);
+			goto out;
+		}
+
+		rx_streaming_queues >>= 1;
+	}
+
+out:
+	kfree(rx_streaming);
+	return ret;
+}
+
 int wl1271_acx_max_tx_retry(struct wl1271 *wl)
 {
 	struct wl1271_acx_max_tx_retry *acx = NULL;
diff --git a/drivers/net/wireless/wl12xx/acx.h b/drivers/net/wireless/wl12xx/acx.h
index 9822e16..aa1fad8 100644
--- a/drivers/net/wireless/wl12xx/acx.h
+++ b/drivers/net/wireless/wl12xx/acx.h
@@ -1135,6 +1135,19 @@ struct wl1271_acx_fw_tsf_information {
 	u8 padding[3];
 } __packed;
 
+struct wl1271_acx_ps_rx_streaming {
+	struct acx_header header;
+
+	u8 tid;
+	u8 enable;
+
+	/* interval between triggers (10-100 msec) */
+	u8 period;
+
+	/* timeout before first trigger (0-200 msec) */
+	u8 timeout;
+} __packed;
+
 struct wl1271_acx_max_tx_retry {
 	struct acx_header header;
 
@@ -1288,6 +1301,7 @@ int wl1271_acx_set_ba_session(struct wl1271 *wl,
 int wl1271_acx_set_ba_receiver_session(struct wl1271 *wl, u8 tid_index, u16 ssn,
 				       bool enable);
 int wl1271_acx_tsf_info(struct wl1271 *wl, u64 *mactime);
+int wl1271_acx_ps_rx_streaming(struct wl1271 *wl);
 int wl1271_acx_max_tx_retry(struct wl1271 *wl);
 int wl1271_acx_config_ps(struct wl1271 *wl);
 
diff --git a/drivers/net/wireless/wl12xx/conf.h b/drivers/net/wireless/wl12xx/conf.h
index 856a8a2..85775c8 100644
--- a/drivers/net/wireless/wl12xx/conf.h
+++ b/drivers/net/wireless/wl12xx/conf.h
@@ -1191,6 +1191,30 @@ struct conf_memory_settings {
 	u8 tx_min;
 };
 
+struct conf_rx_streaming_settings {
+	/*
+	 * RX Streaming duration (in msec) from last tx/rx
+	 *
+	 * Range: u32
+	 */
+	u32 duration;
+
+	/*
+	 * Bitmap of tids to be polled during RX streaming.
+	 * (Note: it doesn't look like it really matters)
+	 *
+	 * Range: 0x1-0xff
+	 */
+	u8 queues;
+
+	/*
+	 * RX Streaming interval.
+	 * (Note:this value is also used as the rx streaming timeout)
+	 * Range: 10 - 100
+	 */
+	u8 interval;
+};
+
 struct conf_drv_settings {
 	struct conf_sg_settings sg;
 	struct conf_rx_settings rx;
@@ -1203,6 +1227,7 @@ struct conf_drv_settings {
 	struct conf_rf_settings rf;
 	struct conf_ht_setting ht;
 	struct conf_memory_settings mem;
+	struct conf_rx_streaming_settings rx_streaming;
 };
 
 #endif
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 6ef69a4..ff991c9 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -307,7 +307,12 @@ static struct conf_drv_settings default_conf = {
 		.min_req_tx_blocks            = 104,
 		.min_req_rx_blocks            = 22,
 		.tx_min                       = 27,
-	}
+	},
+	.rx_streaming = {
+		.duration                      = 30000,
+		.queues                        = 0xff,
+		.interval                      = 0,
+	},
 };
 
 static void __wl1271_op_remove_interface(struct wl1271 *wl);
-- 
1.7.0.4

