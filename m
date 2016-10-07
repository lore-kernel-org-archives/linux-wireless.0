Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:34960 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752398AbcJGGt1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 7 Oct 2016 02:49:27 -0400
Received: by mail-pf0-f195.google.com with SMTP id t25so2367550pfg.2
        for <linux-wireless@vger.kernel.org>; Thu, 06 Oct 2016 23:49:27 -0700 (PDT)
Date: Fri, 7 Oct 2016 12:19:23 +0530
From: Souptick Joarder <jrdr.linux@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>,
        Julian Calaby <julian.calaby@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: Rameshwar Sahu <sahu.rameshwar73@gmail.com>
Subject: [PATCH] wl18xx: Handle kfree() in better way when kzalloc fails
Message-ID: <20161007064923.GA3404@symbol-HP-ZBook-15> (sfid-20161007_084947_718154_2F19A852)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch is added to handle kfree and return error in a better way
if kzalloc fails in wl18xx_scan_send() and wl18xx_scan_sched_scan_config().

Signed-off-by: Souptick joarder <jrdr.linux@gmail.com>
---
 drivers/net/wireless/ti/wl18xx/scan.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ti/wl18xx/scan.c b/drivers/net/wireless/ti/wl18xx/scan.c
index 4e522154..aed22e1 100644
--- a/drivers/net/wireless/ti/wl18xx/scan.c
+++ b/drivers/net/wireless/ti/wl18xx/scan.c
@@ -41,14 +41,13 @@ static void wl18xx_adjust_channels(struct wl18xx_cmd_scan_params *cmd,
 static int wl18xx_scan_send(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 			    struct cfg80211_scan_request *req)
 {
-	struct wl18xx_cmd_scan_params *cmd;
+	struct wl18xx_cmd_scan_params *cmd = NULL;
 	struct wlcore_scan_channels *cmd_channels = NULL;
 	int ret;
 
 	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
 	if (!cmd) {
-		ret = -ENOMEM;
-		goto out;
+		return -ENOMEM;
 	}
 
 	/* scan on the dev role if the regular one is not started */
@@ -59,7 +58,7 @@ static int wl18xx_scan_send(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 
 	if (WARN_ON(cmd->role_id == WL12XX_INVALID_ROLE_ID)) {
 		ret = -EINVAL;
-		goto out;
+		goto err_cmd_free;
 	}
 
 	cmd->scan_type = SCAN_TYPE_SEARCH;
@@ -84,7 +83,7 @@ static int wl18xx_scan_send(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 	cmd_channels = kzalloc(sizeof(*cmd_channels), GFP_KERNEL);
 	if (!cmd_channels) {
 		ret = -ENOMEM;
-		goto out;
+		goto err_cmd_free;
 	}
 
 	wlcore_set_scan_chan_params(wl, cmd_channels, req->channels,
@@ -153,6 +152,7 @@ static int wl18xx_scan_send(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 
 out:
 	kfree(cmd_channels);
+err_cmd_free:
 	kfree(cmd);
 	return ret;
 }
@@ -171,7 +171,7 @@ int wl18xx_scan_sched_scan_config(struct wl1271 *wl,
 				  struct cfg80211_sched_scan_request *req,
 				  struct ieee80211_scan_ies *ies)
 {
-	struct wl18xx_cmd_scan_params *cmd;
+	struct wl18xx_cmd_scan_params *cmd = NULL;
 	struct wlcore_scan_channels *cmd_channels = NULL;
 	struct conf_sched_scan_settings *c = &wl->conf.sched_scan;
 	int ret;
@@ -185,15 +185,14 @@ int wl18xx_scan_sched_scan_config(struct wl1271 *wl,
 
 	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
 	if (!cmd) {
-		ret = -ENOMEM;
-		goto out;
+		return -ENOMEM;
 	}
 
 	cmd->role_id = wlvif->role_id;
 
 	if (WARN_ON(cmd->role_id == WL12XX_INVALID_ROLE_ID)) {
 		ret = -EINVAL;
-		goto out;
+		goto err_cmd_free;
 	}
 
 	cmd->scan_type = SCAN_TYPE_PERIODIC;
@@ -218,7 +217,7 @@ int wl18xx_scan_sched_scan_config(struct wl1271 *wl,
 	cmd_channels = kzalloc(sizeof(*cmd_channels), GFP_KERNEL);
 	if (!cmd_channels) {
 		ret = -ENOMEM;
-		goto out;
+		goto err_cmd_free;
 	}
 
 	/* configure channels */
@@ -296,6 +295,7 @@ int wl18xx_scan_sched_scan_config(struct wl1271 *wl,
 
 out:
 	kfree(cmd_channels);
+err_cmd_free:
 	kfree(cmd);
 	return ret;
 }
-- 
1.9.1
