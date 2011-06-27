Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:61927 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757663Ab1F0KGn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jun 2011 06:06:43 -0400
Received: by wwe5 with SMTP id 5so4605232wwe.1
        for <linux-wireless@vger.kernel.org>; Mon, 27 Jun 2011 03:06:42 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 2/3] wl12xx: add stop_scan command
Date: Mon, 27 Jun 2011 13:06:44 +0300
Message-Id: <1309169205-27966-2-git-send-email-eliad@wizery.com> (sfid-20110627_121214_510678_4FDB9E23)
In-Reply-To: <1309169205-27966-1-git-send-email-eliad@wizery.com>
References: <1309169205-27966-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

define wl1271_scan_stop() to cancel an ongoing hw scan.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/scan.c |   27 +++++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/scan.h |    1 +
 2 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/scan.c b/drivers/net/wireless/wl12xx/scan.c
index f37e5a3..e5e5c35 100644
--- a/drivers/net/wireless/wl12xx/scan.c
+++ b/drivers/net/wireless/wl12xx/scan.c
@@ -321,6 +321,33 @@ int wl1271_scan(struct wl1271 *wl, const u8 *ssid, size_t ssid_len,
 	return 0;
 }
 
+int wl1271_scan_stop(struct wl1271 *wl)
+{
+	struct wl1271_cmd_header *cmd = NULL;
+	int ret = 0;
+
+	if (WARN_ON(wl->scan.state == WL1271_SCAN_STATE_IDLE))
+		return -EINVAL;
+
+	wl1271_debug(DEBUG_CMD, "cmd scan stop");
+
+	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
+	if (!cmd) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	ret = wl1271_cmd_send(wl, CMD_STOP_SCAN, cmd,
+			      sizeof(*cmd), 0);
+	if (ret < 0) {
+		wl1271_error("cmd stop_scan failed");
+		goto out;
+	}
+out:
+	kfree(cmd);
+	return ret;
+}
+
 static int
 wl1271_scan_get_sched_scan_channels(struct wl1271 *wl,
 				    struct cfg80211_sched_scan_request *req,
diff --git a/drivers/net/wireless/wl12xx/scan.h b/drivers/net/wireless/wl12xx/scan.h
index c833195..b13f297 100644
--- a/drivers/net/wireless/wl12xx/scan.h
+++ b/drivers/net/wireless/wl12xx/scan.h
@@ -28,6 +28,7 @@
 
 int wl1271_scan(struct wl1271 *wl, const u8 *ssid, size_t ssid_len,
 		struct cfg80211_scan_request *req);
+int wl1271_scan_stop(struct wl1271 *wl);
 int wl1271_scan_build_probe_req(struct wl1271 *wl,
 				const u8 *ssid, size_t ssid_len,
 				const u8 *ie, size_t ie_len, u8 band);
-- 
1.7.0.4

