Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:40424 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754034Ab1EOIKe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 May 2011 04:10:34 -0400
Received: by wya21 with SMTP id 21so2759832wya.19
        for <linux-wireless@vger.kernel.org>; Sun, 15 May 2011 01:10:33 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 1/3] wl12xx: add support for rx streaming
Date: Sun, 15 May 2011 11:10:28 +0300
Message-Id: <1305447030-10704-1-git-send-email-eliad@wizery.com> (sfid-20110515_101040_792658_EFE58520)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

wl12xx supports the "rx streaming" feature:

When in ps mode, and @timeout msecs have been passed since
the last rx/tx, it issues trigger packets (QoS-null/PS-Poll packets,
according to the ac type) in const intervals (in order to reduce
the rx time).

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
v1->v2:
	use only tid=0 for trigger packets

 drivers/net/wireless/wl12xx/acx.c  |   47 ++++++++++++++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/acx.h  |   14 ++++++++++
 drivers/net/wireless/wl12xx/conf.h |   25 +++++++++++++++++++
 drivers/net/wireless/wl12xx/main.c |    5 ++++
 4 files changed, 91 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/acx.c b/drivers/net/wireless/wl12xx/acx.c
index c6ee530..edb389d 100644
--- a/drivers/net/wireless/wl12xx/acx.c
+++ b/drivers/net/wireless/wl12xx/acx.c
@@ -1577,6 +1577,53 @@ out:
 	return ret;
 }
 
+int wl1271_acx_ps_rx_streaming(struct wl1271 *wl, bool enable)
+{
+	struct wl1271_acx_ps_rx_streaming *rx_streaming;
+	u32 conf_queues, enable_queues;
+	int i, ret = 0;
+
+	wl1271_debug(DEBUG_ACX, "acx ps rx streaming");
+
+	rx_streaming = kzalloc(sizeof(*rx_streaming), GFP_KERNEL);
+	if (!rx_streaming) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	conf_queues = wl->conf.rx_streaming.queues;
+	if (enable)
+		enable_queues = conf_queues;
+	else
+		enable_queues = 0;
+
+	for (i = 0; i < 8; i++) {
+		/*
+		 * Skip non-changed queues, to avoid redundant acxs.
+		 * this check assumes conf.rx_streaming.queues can't
+		 * be changed while rx_streaming is enabled.
+		 */
+		if (!(conf_queues & BIT(i)))
+			continue;
+
+		rx_streaming->tid = i;
+		rx_streaming->enable = enable_queues & BIT(i);
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
+	}
+out:
+	kfree(rx_streaming);
+	return ret;
+}
+
 int wl1271_acx_max_tx_retry(struct wl1271 *wl)
 {
 	struct wl1271_acx_max_tx_retry *acx = NULL;
diff --git a/drivers/net/wireless/wl12xx/acx.h b/drivers/net/wireless/wl12xx/acx.h
index 9a895e3..f1d5531 100644
--- a/drivers/net/wireless/wl12xx/acx.h
+++ b/drivers/net/wireless/wl12xx/acx.h
@@ -1153,6 +1153,19 @@ struct wl1271_acx_fw_tsf_information {
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
 
@@ -1384,6 +1397,7 @@ int wl1271_acx_set_ba_session(struct wl1271 *wl,
 int wl1271_acx_set_ba_receiver_session(struct wl1271 *wl, u8 tid_index, u16 ssn,
 				       bool enable);
 int wl1271_acx_tsf_info(struct wl1271 *wl, u64 *mactime);
+int wl1271_acx_ps_rx_streaming(struct wl1271 *wl, bool enable);
 int wl1271_acx_max_tx_retry(struct wl1271 *wl);
 int wl1271_acx_config_ps(struct wl1271 *wl);
 int wl1271_acx_set_inconnection_sta(struct wl1271 *wl, u8 *addr);
diff --git a/drivers/net/wireless/wl12xx/conf.h b/drivers/net/wireless/wl12xx/conf.h
index 1ab6c86..2b60a43 100644
--- a/drivers/net/wireless/wl12xx/conf.h
+++ b/drivers/net/wireless/wl12xx/conf.h
@@ -1245,6 +1245,30 @@ struct conf_fm_coex {
 	u8 swallow_clk_diff;
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
+	 * Range: 0 (disabled), 10 - 100
+	 */
+	u8 interval;
+};
+
 struct conf_drv_settings {
 	struct conf_sg_settings sg;
 	struct conf_rx_settings rx;
@@ -1260,6 +1284,7 @@ struct conf_drv_settings {
 	struct conf_memory_settings mem_wl127x;
 	struct conf_memory_settings mem_wl128x;
 	struct conf_fm_coex fm_coex;
+	struct conf_rx_streaming_settings rx_streaming;
 	u8 hci_io_ds;
 };
 
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 610be03..6aa294e 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -361,6 +361,11 @@ static struct conf_drv_settings default_conf = {
 		.fm_disturbed_band_margin     = 0xff,       /* default */
 		.swallow_clk_diff             = 0xff,       /* default */
 	},
+	.rx_streaming = {
+		.duration                      = 150,
+		.queues                        = 0x1,
+		.interval                      = 20,
+	},
 	.hci_io_ds = HCI_IO_DS_6MA,
 };
 
-- 
1.7.0.4

