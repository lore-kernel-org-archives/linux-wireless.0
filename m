Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:58302 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753193Ab2K1JnJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2012 04:43:09 -0500
Received: by mail-wg0-f44.google.com with SMTP id dr13so3507300wgb.1
        for <linux-wireless@vger.kernel.org>; Wed, 28 Nov 2012 01:43:09 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 07/20] wlcore: set 5Ghz probe-req template for DFS channels
Date: Wed, 28 Nov 2012 11:42:36 +0200
Message-Id: <1354095769-8724-8-git-send-email-arik@wizery.com> (sfid-20121128_104316_408194_3BAC8AE4)
In-Reply-To: <1354095769-8724-1-git-send-email-arik@wizery.com>
References: <1354095769-8724-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Even passive scans on DFS channels require us to send probe requests, so
configure the probe-req in this case.

Also use this opportunity to prevent the code from crashing in case no
SSIDs are sent from above. This will likely happen in the DFS case
introduced. Even a passive scan might need the probe request configured
because of DFS channels.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wl18xx/scan.c |   52 ++++++++++++++++-----------------
 1 file changed, 26 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/ti/wl18xx/scan.c b/drivers/net/wireless/ti/wl18xx/scan.c
index daaebad..1df88d5 100644
--- a/drivers/net/wireless/ti/wl18xx/scan.c
+++ b/drivers/net/wireless/ti/wl18xx/scan.c
@@ -108,27 +108,27 @@ static int wl18xx_scan_send(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 	if (cmd->active[0]) {
 		u8 band = IEEE80211_BAND_2GHZ;
 		ret = wl12xx_cmd_build_probe_req(wl, wlvif,
-						 cmd->role_id, band,
-						 req->ssids[0].ssid,
-						 req->ssids[0].ssid_len,
-						 req->ie,
-						 req->ie_len,
-						 false);
+				 cmd->role_id, band,
+				 req->ssids ? req->ssids[0].ssid : NULL,
+				 req->ssids ? req->ssids[0].ssid_len : 0,
+				 req->ie,
+				 req->ie_len,
+				 false);
 		if (ret < 0) {
 			wl1271_error("2.4GHz PROBE request template failed");
 			goto out;
 		}
 	}
 
-	if (cmd->active[1]) {
+	if (cmd->active[1] || cmd->dfs) {
 		u8 band = IEEE80211_BAND_5GHZ;
 		ret = wl12xx_cmd_build_probe_req(wl, wlvif,
-						 cmd->role_id, band,
-						 req->ssids[0].ssid,
-						 req->ssids[0].ssid_len,
-						 req->ie,
-						 req->ie_len,
-						 false);
+				 cmd->role_id, band,
+				 req->ssids ? req->ssids[0].ssid : NULL,
+				 req->ssids ? req->ssids[0].ssid_len : 0,
+				 req->ie,
+				 req->ie_len,
+				 false);
 		if (ret < 0) {
 			wl1271_error("5GHz PROBE request template failed");
 			goto out;
@@ -230,27 +230,27 @@ int wl18xx_scan_sched_scan_config(struct wl1271 *wl,
 	if (cmd->active[0]) {
 		u8 band = IEEE80211_BAND_2GHZ;
 		ret = wl12xx_cmd_build_probe_req(wl, wlvif,
-						 cmd->role_id, band,
-						 req->ssids[0].ssid,
-						 req->ssids[0].ssid_len,
-						 ies->ie[band],
-						 ies->len[band],
-						 true);
+				 cmd->role_id, band,
+				 req->ssids ? req->ssids[0].ssid : NULL,
+				 req->ssids ? req->ssids[0].ssid_len : 0,
+				 ies->ie[band],
+				 ies->len[band],
+				 true);
 		if (ret < 0) {
 			wl1271_error("2.4GHz PROBE request template failed");
 			goto out;
 		}
 	}
 
-	if (cmd->active[1]) {
+	if (cmd->active[1] || cmd->dfs) {
 		u8 band = IEEE80211_BAND_5GHZ;
 		ret = wl12xx_cmd_build_probe_req(wl, wlvif,
-						 cmd->role_id, band,
-						 req->ssids[0].ssid,
-						 req->ssids[0].ssid_len,
-						 ies->ie[band],
-						 ies->len[band],
-						 true);
+				 cmd->role_id, band,
+				 req->ssids ? req->ssids[0].ssid : NULL,
+				 req->ssids ? req->ssids[0].ssid_len : 0,
+				 ies->ie[band],
+				 ies->len[band],
+				 true);
 		if (ret < 0) {
 			wl1271_error("5GHz PROBE request template failed");
 			goto out;
-- 
1.7.9.5

