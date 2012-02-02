Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:44318 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755427Ab2BBLvM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Feb 2012 06:51:12 -0500
Received: by mail-wi0-f174.google.com with SMTP id s10so1677445wic.19
        for <linux-wireless@vger.kernel.org>; Thu, 02 Feb 2012 03:51:11 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>, Eyal Shapira <eyal@wizery.com>,
	Eyal Shapira <eyal@wizey.com>, Igal Chernobelsky <igalc@ti.com>
Subject: [PATCH 3/4] wl12xx: use split scan for normal scan
Date: Thu,  2 Feb 2012 13:54:28 +0200
Message-Id: <1328183669-21059-4-git-send-email-eliad@wizery.com> (sfid-20120202_125117_487796_4EDF0095)
In-Reply-To: <1328183669-21059-1-git-send-email-eliad@wizery.com>
References: <1328183669-21059-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

Split scan allows the FW to schedule other activities
during a scan which may be a long operation. This is
achieved by setting a trigger TID to ANY_TID and a scan
trigger timeout other than 0. The default one is set to 50ms.

Signed-off-by: Eyal Shapira <eyal@wizey.com>
Signed-off-by: Igal Chernobelsky <igalc@ti.com>
Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/conf.h |    8 ++++++++
 drivers/net/wireless/wl12xx/main.c |    1 +
 drivers/net/wireless/wl12xx/scan.c |    8 +++++---
 drivers/net/wireless/wl12xx/scan.h |    2 +-
 4 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/conf.h b/drivers/net/wireless/wl12xx/conf.h
index 823535c..cc50faa 100644
--- a/drivers/net/wireless/wl12xx/conf.h
+++ b/drivers/net/wireless/wl12xx/conf.h
@@ -1082,6 +1082,14 @@ struct conf_scan_settings {
 	 */
 	u16 num_probe_reqs;
 
+	/*
+	 * Scan trigger (split scan) timeout. The FW will split the scan
+	 * operation into slices of the given time and allow the FW to schedule
+	 * other tasks in between.
+	 *
+	 * Range: u32 Microsecs
+	 */
+	u32 split_scan_timeout;
 };
 
 struct conf_sched_scan_settings {
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 1a12d8c..52efe7d 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -272,6 +272,7 @@ static struct conf_drv_settings default_conf = {
 		.min_dwell_time_passive       = 100000,
 		.max_dwell_time_passive       = 100000,
 		.num_probe_reqs               = 2,
+		.split_scan_timeout           = 50000,
 	},
 	.sched_scan = {
 		/* sched_scan requires dwell times in TU instead of TU/1000 */
diff --git a/drivers/net/wireless/wl12xx/scan.c b/drivers/net/wireless/wl12xx/scan.c
index e3566ca..e43a6b2 100644
--- a/drivers/net/wireless/wl12xx/scan.c
+++ b/drivers/net/wireless/wl12xx/scan.c
@@ -172,6 +172,9 @@ static int wl1271_scan_send(struct wl1271 *wl, struct ieee80211_vif *vif,
 		goto out;
 	}
 
+	if (wl->conf.scan.split_scan_timeout)
+		scan_options |= WL1271_SCAN_OPT_SPLIT_SCAN;
+
 	if (passive)
 		scan_options |= WL1271_SCAN_OPT_PASSIVE;
 
@@ -198,7 +201,7 @@ static int wl1271_scan_send(struct wl1271 *wl, struct ieee80211_vif *vif,
 
 	cmd->params.tx_rate = cpu_to_le32(basic_rate);
 	cmd->params.n_probe_reqs = wl->conf.scan.num_probe_reqs;
-	cmd->params.tid_trigger = 0;
+	cmd->params.tid_trigger = CONF_TX_AC_ANY_TID;
 	cmd->params.scan_tag = WL1271_SCAN_DEFAULT_TAG;
 
 	if (band == IEEE80211_BAND_2GHZ)
@@ -223,8 +226,7 @@ static int wl1271_scan_send(struct wl1271 *wl, struct ieee80211_vif *vif,
 		goto out;
 	}
 
-	/* disable the timeout */
-	trigger->timeout = 0;
+	trigger->timeout = cpu_to_le32(wl->conf.scan.split_scan_timeout);
 	ret = wl1271_cmd_send(wl, CMD_TRIGGER_SCAN_TO, trigger,
 			      sizeof(*trigger), 0);
 	if (ret < 0) {
diff --git a/drivers/net/wireless/wl12xx/scan.h b/drivers/net/wireless/wl12xx/scan.h
index a7ed43d..96ff457 100644
--- a/drivers/net/wireless/wl12xx/scan.h
+++ b/drivers/net/wireless/wl12xx/scan.h
@@ -48,7 +48,7 @@ void wl1271_scan_sched_scan_results(struct wl1271 *wl);
 #define WL1271_SCAN_CURRENT_TX_PWR     0
 #define WL1271_SCAN_OPT_ACTIVE         0
 #define WL1271_SCAN_OPT_PASSIVE	       1
-#define WL1271_SCAN_OPT_TRIGGERED_SCAN 2
+#define WL1271_SCAN_OPT_SPLIT_SCAN     2
 #define WL1271_SCAN_OPT_PRIORITY_HIGH  4
 /* scan even if we fail to enter psm */
 #define WL1271_SCAN_OPT_FORCE          8
-- 
1.7.6.401.g6a319

