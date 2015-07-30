Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:51683 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751382AbbG3TuL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jul 2015 15:50:11 -0400
From: Yaniv Machani <yanivma@ti.com>
To: <linux-wireless@vger.kernel.org>
CC: <yanivma@ti.com>, Eliad Peller <eliad@wizery.com>,
	Eyal Shapira <eyal@wizery.com>
Subject: [PATCH 2/4] wl18xx: use long intervals in sched scan
Date: Thu, 30 Jul 2015 22:38:20 +0300
Message-ID: <1438285102-32751-2-git-send-email-yanivma@ti.com> (sfid-20150730_215025_093815_3B673357)
In-Reply-To: <1438285102-32751-1-git-send-email-yanivma@ti.com>
References: <1438285102-32751-1-git-send-email-yanivma@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

Add support for long intervals on sched scan.

If configured, the original request interval will
be used num_short_interval times, and then the
long interval will be used.

While on it, fix the scan command field names
to reflect the expected value is in ms (rather
than secs).

These values will be taken from the conf file,
so bump its version accordingly.

Signed-off-by: Eyal Shapira <eyal@wizery.com>
Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/ti/wl18xx/main.c |    2 ++
 drivers/net/wireless/ti/wl18xx/scan.c |   17 ++++++++++++++---
 drivers/net/wireless/ti/wl18xx/scan.h |    4 ++--
 drivers/net/wireless/ti/wlcore/conf.h |   11 ++++++++++-
 drivers/net/wireless/ti/wlcore/scan.h |    6 ++++++
 5 files changed, 34 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index 2984056..62aabdd 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -422,6 +422,8 @@ static struct wlcore_conf wl18xx_conf = {
 		.num_probe_reqs			= 2,
 		.rssi_threshold			= -90,
 		.snr_threshold			= 0,
+		.num_short_intervals		= SCAN_MAX_SHORT_INTERVALS,
+		.long_interval			= 30000,
 	},
 	.ht = {
 		.rx_ba_win_size = 32,
diff --git a/drivers/net/wireless/ti/wl18xx/scan.c b/drivers/net/wireless/ti/wl18xx/scan.c
index 98666f2..ec2eb14 100644
--- a/drivers/net/wireless/ti/wl18xx/scan.c
+++ b/drivers/net/wireless/ti/wl18xx/scan.c
@@ -223,9 +223,20 @@ int wl18xx_scan_sched_scan_config(struct wl1271 *wl,
 				    SCAN_TYPE_PERIODIC);
 	wl18xx_adjust_channels(cmd, cmd_channels);
 
-	cmd->short_cycles_sec = 0;
-	cmd->long_cycles_sec = cpu_to_le16(req->interval);
-	cmd->short_cycles_count = 0;
+	if (c->num_short_intervals && c->long_interval &&
+	    c->long_interval > req->interval) {
+		cmd->short_cycles_msec = cpu_to_le16(req->interval);
+		cmd->long_cycles_msec = cpu_to_le16(c->long_interval);
+		cmd->short_cycles_count = c->num_short_intervals;
+	} else {
+		cmd->short_cycles_msec = 0;
+		cmd->long_cycles_msec = cpu_to_le16(req->interval);
+		cmd->short_cycles_count = 0;
+	}
+	wl1271_debug(DEBUG_SCAN, "short_interval: %d, long_interval: %d, num_short: %d",
+		     le16_to_cpu(cmd->short_cycles_msec),
+		     le16_to_cpu(cmd->long_cycles_msec),
+		     cmd->short_cycles_count);
 
 	cmd->total_cycles = 0;
 
diff --git a/drivers/net/wireless/ti/wl18xx/scan.h b/drivers/net/wireless/ti/wl18xx/scan.h
index 2e636aa..66a763f 100644
--- a/drivers/net/wireless/ti/wl18xx/scan.h
+++ b/drivers/net/wireless/ti/wl18xx/scan.h
@@ -74,8 +74,8 @@ struct wl18xx_cmd_scan_params {
 	u8 dfs;		   /* number of dfs channels in 5ghz */
 	u8 passive_active; /* number of passive before active channels 2.4ghz */
 
-	__le16 short_cycles_sec;
-	__le16 long_cycles_sec;
+	__le16 short_cycles_msec;
+	__le16 long_cycles_msec;
 	u8 short_cycles_count;
 	u8 total_cycles; /* 0 - infinite */
 	u8 padding[2];
diff --git a/drivers/net/wireless/ti/wlcore/conf.h b/drivers/net/wireless/ti/wlcore/conf.h
index 166add0..52a9d1b 100644
--- a/drivers/net/wireless/ti/wlcore/conf.h
+++ b/drivers/net/wireless/ti/wlcore/conf.h
@@ -1186,6 +1186,15 @@ struct conf_sched_scan_settings {
 
 	/* SNR threshold to be used for filtering */
 	s8 snr_threshold;
+
+	/*
+	 * number of short intervals scheduled scan cycles before
+	 * switching to long intervals
+	 */
+	u8 num_short_intervals;
+
+	/* interval between each long scheduled scan cycle (in ms) */
+	u16 long_interval;
 } __packed;
 
 struct conf_ht_setting {
@@ -1352,7 +1361,7 @@ struct conf_recovery_settings {
  * version, the two LSB are the lower driver's private conf
  * version.
  */
-#define WLCORE_CONF_VERSION	(0x0006 << 16)
+#define WLCORE_CONF_VERSION	(0x0007 << 16)
 #define WLCORE_CONF_MASK	0xffff0000
 #define WLCORE_CONF_SIZE	(sizeof(struct wlcore_conf_header) +	\
 				 sizeof(struct wlcore_conf))
diff --git a/drivers/net/wireless/ti/wlcore/scan.h b/drivers/net/wireless/ti/wlcore/scan.h
index 4dadd0c..782eb29 100644
--- a/drivers/net/wireless/ti/wlcore/scan.h
+++ b/drivers/net/wireless/ti/wlcore/scan.h
@@ -83,6 +83,12 @@ struct wl1271_cmd_trigger_scan_to {
 #define MAX_CHANNELS_5GHZ	42
 
 #define SCAN_MAX_CYCLE_INTERVALS 16
+
+/* The FW intervals can take up to 16 entries.
+ * The 1st entry isn't used (scan is immediate). The last
+ * entry should be used for the long_interval
+ */
+#define SCAN_MAX_SHORT_INTERVALS (SCAN_MAX_CYCLE_INTERVALS - 2)
 #define SCAN_MAX_BANDS 3
 
 enum {
-- 
1.7.9

