Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:55690 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751291Ab1IBL2p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Sep 2011 07:28:45 -0400
Received: by mail-bw0-f54.google.com with SMTP id t8so3299038bka.41
        for <linux-wireless@vger.kernel.org>; Fri, 02 Sep 2011 04:28:44 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: coelho@ti.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 3/3] wl12xx: ignore sched scan match sets without SSID
Date: Fri,  2 Sep 2011 14:28:23 +0300
Message-Id: <1314962903-29574-4-git-send-email-coelho@ti.com> (sfid-20110902_132849_300965_680B5E05)
In-Reply-To: <1314962903-29574-1-git-send-email-coelho@ti.com>
References: <1314962903-29574-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For now, cfg80211 only support match sets with SSIDs, but in the
future more parameters will be added.  This patch ignores eventual
matches that do not contain SSIDs in preparation for the future.  This
change also affects the case where broadcast SSIDs are used.  Matching
a broadcast SSID will match everything, so they can be ignored.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/wl12xx/scan.c |   15 ++++++++++++---
 1 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/scan.c b/drivers/net/wireless/wl12xx/scan.c
index 793f143..e167651 100644
--- a/drivers/net/wireless/wl12xx/scan.c
+++ b/drivers/net/wireless/wl12xx/scan.c
@@ -481,12 +481,17 @@ wl12xx_scan_sched_scan_ssid_list(struct wl1271 *wl,
 	struct wl1271_cmd_sched_scan_ssid_list *cmd = NULL;
 	struct cfg80211_match_set *sets = req->match_sets;
 	struct cfg80211_ssid *ssids = req->ssids;
-	int ret = 0, type, i, j;
+	int ret = 0, type, i, j, n_match_ssids = 0;
 
 	wl1271_debug(DEBUG_CMD, "cmd sched scan ssid list");
 
+	/* count the match sets that contain SSIDs */
+	for (i = 0; i < req->n_match_sets; i++)
+		if (sets[i].ssid.ssid_len > 0)
+			n_match_ssids++;
+
 	/* No filter, no ssids or only bcast ssid */
-	if (!req->n_match_sets &&
+	if (!n_match_ssids &&
 	    (!req->n_ssids ||
 	     (req->n_ssids == 1 && req->ssids[0].ssid_len == 0))) {
 		type = SCAN_SSID_FILTER_ANY;
@@ -499,7 +504,7 @@ wl12xx_scan_sched_scan_ssid_list(struct wl1271 *wl,
 		goto out;
 	}
 
-	if (!req->n_match_sets) {
+	if (!n_match_ssids) {
 		/* No filter, with ssids */
 		type = SCAN_SSID_FILTER_DISABLED;
 
@@ -516,6 +521,10 @@ wl12xx_scan_sched_scan_ssid_list(struct wl1271 *wl,
 
 		/* Add all SSIDs from the filters */
 		for (i = 0; i < req->n_match_sets; i++) {
+			/* ignore sets without SSIDs */
+			if (!sets[i].ssid.ssid_len)
+				continue;
+
 			cmd->ssids[cmd->n_ssids].type = SCAN_SSID_TYPE_PUBLIC;
 			cmd->ssids[cmd->n_ssids].len = sets[i].ssid.ssid_len;
 			memcpy(cmd->ssids[cmd->n_ssids].ssid,
-- 
1.7.1

