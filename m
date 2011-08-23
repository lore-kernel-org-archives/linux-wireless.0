Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:38816 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752504Ab1HWPez (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Aug 2011 11:34:55 -0400
Received: by mail-bw0-f54.google.com with SMTP id t8so259165bka.13
        for <linux-wireless@vger.kernel.org>; Tue, 23 Aug 2011 08:34:53 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: coelho@ti.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 1/2] wl12xx: add support for multiple SSIDs in sched_scan
Date: Tue, 23 Aug 2011 18:34:44 +0300
Message-Id: <1314113685-27437-2-git-send-email-coelho@ti.com> (sfid-20110823_173529_553240_06D10BD7)
In-Reply-To: <1314113685-27437-1-git-send-email-coelho@ti.com>
References: <1314113685-27437-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The wl12xx firmwares support multiple SSIDs in a single sched_scan
run.  This patch implements support for it.

We use three different types os sched_scan: FILTER_ANY (ie. not
filtering, only wildcard SSID in the probe_reqs); FILTER_LIST (ie. send out
probe_reqs with the specified SSIDs and only report if they are
found); and FILTER_DISABLED (ie. send out probe_reqs with the
specified SSIDs, but report anything found).

Since we still don't have proper filter support in nl80211/cfg80211
yet, we cannot use filters when the wildcard SSID is used.  Thus, we
will not filter anything if the wildcard SSID is specified.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/wl12xx/main.c |    2 +-
 drivers/net/wireless/wl12xx/scan.c |   63 ++++++++++++++++++++++++++++++++----
 2 files changed, 57 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index ac09d77..e944de1 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -4475,7 +4475,7 @@ int wl1271_init_ieee80211(struct wl1271 *wl)
 	wl->hw->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION) |
 		BIT(NL80211_IFTYPE_ADHOC) | BIT(NL80211_IFTYPE_AP);
 	wl->hw->wiphy->max_scan_ssids = 1;
-	wl->hw->wiphy->max_sched_scan_ssids = 1;
+	wl->hw->wiphy->max_sched_scan_ssids = 8;
 	/*
 	 * Maximum length of elements in scanning probe request templates
 	 * should be the maximum length possible for a template, without
diff --git a/drivers/net/wireless/wl12xx/scan.c b/drivers/net/wireless/wl12xx/scan.c
index 7229eaa..af9d53c 100644
--- a/drivers/net/wireless/wl12xx/scan.c
+++ b/drivers/net/wireless/wl12xx/scan.c
@@ -473,6 +473,48 @@ wl1271_scan_sched_scan_channels(struct wl1271 *wl,
 		cfg->passive[2] || cfg->active[2];
 }
 
+/* Returns 0 if no wildcard is used, 1 if wildcard is used or a
+ * negative value on error */
+static int
+wl12xx_scan_sched_scan_ssid_list(struct wl1271 *wl,
+				 struct cfg80211_sched_scan_request *req)
+{
+	struct wl1271_cmd_sched_scan_ssid_list *cmd = NULL;
+	struct cfg80211_ssid *ssid = req->ssids;
+	int ret, wildcard = 0;
+
+	wl1271_debug(DEBUG_CMD, "cmd sched scan ssid list");
+
+	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
+	if (!cmd)
+		return -ENOMEM;
+
+	while ((cmd->n_ssids < req->n_ssids) && ssid) {
+		if (ssid->ssid_len == 0)
+			wildcard = 1;
+		cmd->ssids[cmd->n_ssids].type = SCAN_SSID_TYPE_HIDDEN;
+		cmd->ssids[cmd->n_ssids].len = ssid->ssid_len;
+		memcpy(cmd->ssids[cmd->n_ssids].ssid, ssid->ssid,
+		       ssid->ssid_len);
+		ssid++;
+		cmd->n_ssids++;
+	}
+
+	wl1271_dump(DEBUG_SCAN, "SSID_LIST: ", cmd, sizeof(*cmd));
+
+	ret = wl1271_cmd_send(wl, CMD_CONNECTION_SCAN_SSID_CFG, cmd,
+			      sizeof(*cmd), 0);
+	if (ret < 0) {
+		wl1271_error("cmd sched scan ssid list failed");
+		goto out;
+	}
+
+	ret = wildcard;
+out:
+	kfree(cmd);
+	return ret;
+}
+
 int wl1271_scan_sched_scan_config(struct wl1271 *wl,
 				  struct cfg80211_sched_scan_request *req,
 				  struct ieee80211_sched_scan_ies *ies)
@@ -504,14 +546,21 @@ int wl1271_scan_sched_scan_config(struct wl1271 *wl,
 	for (i = 0; i < SCAN_MAX_CYCLE_INTERVALS; i++)
 		cfg->intervals[i] = cpu_to_le32(req->interval);
 
-	if (!force_passive && req->ssids[0].ssid_len && req->ssids[0].ssid) {
-		cfg->filter_type = SCAN_SSID_FILTER_SPECIFIC;
-		cfg->ssid_len = req->ssids[0].ssid_len;
-		memcpy(cfg->ssid, req->ssids[0].ssid,
-		       req->ssids[0].ssid_len);
-	} else {
+	cfg->ssid_len = 0;
+	if (req->n_ssids == 0) {
+		wl1271_debug(DEBUG_SCAN, "using SCAN_SSID_FILTER_ANY");
 		cfg->filter_type = SCAN_SSID_FILTER_ANY;
-		cfg->ssid_len = 0;
+	} else {
+		ret = wl12xx_scan_sched_scan_ssid_list(wl, req);
+		if (ret < 0)
+			goto out;
+		if (ret) {
+			wl1271_debug(DEBUG_SCAN, "using SCAN_SSID_FILTER_DISABLED");
+			cfg->filter_type = SCAN_SSID_FILTER_DISABLED;
+		} else {
+			wl1271_debug(DEBUG_SCAN, "using SCAN_SSID_FILTER_LIST");
+			cfg->filter_type = SCAN_SSID_FILTER_LIST;
+		}
 	}
 
 	if (!wl1271_scan_sched_scan_channels(wl, req, cfg)) {
-- 
1.7.1

