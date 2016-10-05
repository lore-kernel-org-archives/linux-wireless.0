Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f66.google.com ([209.85.220.66]:34220 "EHLO
        mail-pa0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752220AbcJENJV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Oct 2016 09:09:21 -0400
Received: by mail-pa0-f66.google.com with SMTP id r9so10624847paz.1
        for <linux-wireless@vger.kernel.org>; Wed, 05 Oct 2016 06:09:20 -0700 (PDT)
Received: from symbol-HP-ZBook-15 ([140.101.159.249])
        by smtp.gmail.com with ESMTPSA id d19sm11434285pfd.59.2016.10.05.06.09.18
        for <linux-wireless@vger.kernel.org>
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 05 Oct 2016 06:09:19 -0700 (PDT)
Date: Wed, 5 Oct 2016 18:39:16 +0530
From: Souptick Joarder <jrdr.linux@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] [wl18xx] Fix memory leakage if kzalloc fails
Message-ID: <20161005130916.GA22804@symbol-HP-ZBook-15> (sfid-20161005_150924_192854_6D325B0F)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch is added to properly handle memory leak if kzalloc fails
in wl18xx_scan_send() and wl18xx_scan_sched_scan_config()

Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
Signed-off-by: Rameshwar Sahu <sahu.rameshwar73@gmail.com>
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
