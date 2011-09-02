Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:45076 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750933Ab1IBL2l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Sep 2011 07:28:41 -0400
Received: by mail-bw0-f42.google.com with SMTP id s6so4699390bka.1
        for <linux-wireless@vger.kernel.org>; Fri, 02 Sep 2011 04:28:40 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: coelho@ti.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 1/3] wl12xx: add support for sched_scan filters
Date: Fri,  2 Sep 2011 14:28:21 +0300
Message-Id: <1314962903-29574-2-git-send-email-coelho@ti.com> (sfid-20110902_132846_769634_E8B59A2D)
In-Reply-To: <1314962903-29574-1-git-send-email-coelho@ti.com>
References: <1314962903-29574-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Implement support for filtering in scheduled scans.

With this commit we now use the match sets passed by cfg80211 to
filter on SSIDs.  Due to the nature of the wl12xx firmware API, we
don't allow SSIDs to be sent in the probe requests if they are not
going to match any of the filters.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/wl12xx/scan.c |  107 ++++++++++++++++++++++++------------
 1 files changed, 72 insertions(+), 35 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/scan.c b/drivers/net/wireless/wl12xx/scan.c
index af4ad23..793f143 100644
--- a/drivers/net/wireless/wl12xx/scan.c
+++ b/drivers/net/wireless/wl12xx/scan.c
@@ -473,34 +473,77 @@ wl1271_scan_sched_scan_channels(struct wl1271 *wl,
 		cfg->passive[2] || cfg->active[2];
 }
 
-/* Returns 0 if no wildcard is used, 1 if wildcard is used or a
- * negative value on error */
+/* Returns the scan type to be used or a negative value on error */
 static int
 wl12xx_scan_sched_scan_ssid_list(struct wl1271 *wl,
 				 struct cfg80211_sched_scan_request *req)
 {
 	struct wl1271_cmd_sched_scan_ssid_list *cmd = NULL;
-	struct cfg80211_ssid *ssid = req->ssids;
-	int ret, wildcard = 0;
+	struct cfg80211_match_set *sets = req->match_sets;
+	struct cfg80211_ssid *ssids = req->ssids;
+	int ret = 0, type, i, j;
 
 	wl1271_debug(DEBUG_CMD, "cmd sched scan ssid list");
 
+	/* No filter, no ssids or only bcast ssid */
+	if (!req->n_match_sets &&
+	    (!req->n_ssids ||
+	     (req->n_ssids == 1 && req->ssids[0].ssid_len == 0))) {
+		type = SCAN_SSID_FILTER_ANY;
+		goto out;
+	}
+
 	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
-	if (!cmd)
-		return -ENOMEM;
+	if (!cmd) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	if (!req->n_match_sets) {
+		/* No filter, with ssids */
+		type = SCAN_SSID_FILTER_DISABLED;
+
+		for (i = 0; i < req->n_ssids; i++) {
+			cmd->ssids[cmd->n_ssids].type = (ssids[i].ssid_len)?
+				SCAN_SSID_TYPE_HIDDEN : SCAN_SSID_TYPE_PUBLIC;
+			cmd->ssids[cmd->n_ssids].len = ssids[i].ssid_len;
+			memcpy(cmd->ssids[cmd->n_ssids].ssid, ssids[i].ssid,
+			       ssids[i].ssid_len);
+			cmd->n_ssids++;
+		}
+	} else {
+		type = SCAN_SSID_FILTER_LIST;
 
-	while ((cmd->n_ssids < req->n_ssids) && ssid) {
-		if (ssid->ssid_len == 0) {
-			wildcard = 1;
+		/* Add all SSIDs from the filters */
+		for (i = 0; i < req->n_match_sets; i++) {
 			cmd->ssids[cmd->n_ssids].type = SCAN_SSID_TYPE_PUBLIC;
-		} else {
-			cmd->ssids[cmd->n_ssids].type = SCAN_SSID_TYPE_HIDDEN;
+			cmd->ssids[cmd->n_ssids].len = sets[i].ssid.ssid_len;
+			memcpy(cmd->ssids[cmd->n_ssids].ssid,
+			       sets[i].ssid.ssid, sets[i].ssid.ssid_len);
+			cmd->n_ssids++;
+		}
+		if ((req->n_ssids > 1) ||
+		    (req->n_ssids == 1 && req->ssids[0].ssid_len > 0)) {
+			/*
+			 * Mark all the SSIDs passed in the SSID list as HIDDEN,
+			 * so they're used in probe requests.
+			 */
+			for (i = 0; i < req->n_ssids; i++) {
+				for (j = 0; j < cmd->n_ssids; j++)
+					if (!memcmp(req->ssids[i].ssid,
+						   cmd->ssids[j].ssid,
+						   req->ssids[i].ssid_len)) {
+						cmd->ssids[j].type =
+							SCAN_SSID_TYPE_HIDDEN;
+						break;
+					}
+				/* Fail if SSID isn't present in the filters */
+				if (j == req->n_ssids) {
+					ret = -EINVAL;
+					goto out_free;
+				}
+			}
 		}
-		cmd->ssids[cmd->n_ssids].len = ssid->ssid_len;
-		memcpy(cmd->ssids[cmd->n_ssids].ssid, ssid->ssid,
-		       ssid->ssid_len);
-		ssid++;
-		cmd->n_ssids++;
 	}
 
 	wl1271_dump(DEBUG_SCAN, "SSID_LIST: ", cmd, sizeof(*cmd));
@@ -509,13 +552,15 @@ wl12xx_scan_sched_scan_ssid_list(struct wl1271 *wl,
 			      sizeof(*cmd), 0);
 	if (ret < 0) {
 		wl1271_error("cmd sched scan ssid list failed");
-		goto out;
+		goto out_free;
 	}
 
-	ret = wildcard;
-out:
+out_free:
 	kfree(cmd);
-	return ret;
+out:
+	if (ret < 0)
+		return ret;
+	return type;
 }
 
 int wl1271_scan_sched_scan_config(struct wl1271 *wl,
@@ -550,21 +595,13 @@ int wl1271_scan_sched_scan_config(struct wl1271 *wl,
 		cfg->intervals[i] = cpu_to_le32(req->interval);
 
 	cfg->ssid_len = 0;
-	if (req->n_ssids == 0) {
-		wl1271_debug(DEBUG_SCAN, "using SCAN_SSID_FILTER_ANY");
-		cfg->filter_type = SCAN_SSID_FILTER_ANY;
-	} else {
-		ret = wl12xx_scan_sched_scan_ssid_list(wl, req);
-		if (ret < 0)
-			goto out;
-		if (ret) {
-			wl1271_debug(DEBUG_SCAN, "using SCAN_SSID_FILTER_DISABLED");
-			cfg->filter_type = SCAN_SSID_FILTER_DISABLED;
-		} else {
-			wl1271_debug(DEBUG_SCAN, "using SCAN_SSID_FILTER_LIST");
-			cfg->filter_type = SCAN_SSID_FILTER_LIST;
-		}
-	}
+	ret = wl12xx_scan_sched_scan_ssid_list(wl, req);
+	if (ret < 0)
+		goto out;
+
+	cfg->filter_type = ret;
+
+	wl1271_debug(DEBUG_SCAN, "filter_type = %d", cfg->filter_type);
 
 	if (!wl1271_scan_sched_scan_channels(wl, req, cfg)) {
 		wl1271_error("scan channel list is empty");
-- 
1.7.1

