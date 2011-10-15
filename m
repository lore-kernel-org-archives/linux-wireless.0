Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51667 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813Ab1JOUZg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Oct 2011 16:25:36 -0400
Received: by bkbzt19 with SMTP id zt19so1620363bkb.19
        for <linux-wireless@vger.kernel.org>; Sat, 15 Oct 2011 13:25:34 -0700 (PDT)
From: Guy Eilam <guy@wizery.com>
To: coelho@ti.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] wl12xx: set scan probe requests rate according to the no_cck flag
Date: Sat, 15 Oct 2011 22:23:43 +0200
Message-Id: <1318710223-29285-1-git-send-email-guy@wizery.com> (sfid-20111015_222558_717881_0097BF06)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Set the TX rate of probe requests during scanning according to the
no_cck flag in the scan request struct.

Signed-off-by: Guy Eilam <guy@wizery.com>
---
 drivers/net/wireless/wl12xx/scan.c |   15 ++++++++++++---
 1 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/scan.c b/drivers/net/wireless/wl12xx/scan.c
index 5a6ae29..9a6bba4 100644
--- a/drivers/net/wireless/wl12xx/scan.c
+++ b/drivers/net/wireless/wl12xx/scan.c
@@ -184,7 +184,6 @@ static int wl1271_scan_send(struct wl1271 *wl, enum ieee80211_band band,
 
 	cmd->params.tx_rate = cpu_to_le32(basic_rate);
 	cmd->params.n_probe_reqs = wl->conf.scan.num_probe_reqs;
-	cmd->params.tx_rate = cpu_to_le32(basic_rate);
 	cmd->params.tid_trigger = 0;
 	cmd->params.scan_tag = WL1271_SCAN_DEFAULT_TAG;
 
@@ -243,7 +242,12 @@ void wl1271_scan_stm(struct wl1271 *wl)
 
 	case WL1271_SCAN_STATE_2GHZ_ACTIVE:
 		band = IEEE80211_BAND_2GHZ;
-		rate = wl1271_tx_min_rate_get(wl, wl->bitrate_masks[band]);
+		if (wl->scan.req->no_cck)
+			rate = wl1271_tx_min_rate_get(wl,
+						 CONF_TX_RATE_MASK_BASIC_P2P);
+		else
+			rate = wl1271_tx_min_rate_get(wl,
+						 CONF_TX_RATE_MASK_BASIC);
 		ret = wl1271_scan_send(wl, band, false, rate);
 		if (ret == WL1271_NOTHING_TO_SCAN) {
 			wl->scan.state = WL1271_SCAN_STATE_2GHZ_PASSIVE;
@@ -254,7 +258,12 @@ void wl1271_scan_stm(struct wl1271 *wl)
 
 	case WL1271_SCAN_STATE_2GHZ_PASSIVE:
 		band = IEEE80211_BAND_2GHZ;
-		rate = wl1271_tx_min_rate_get(wl, wl->bitrate_masks[band]);
+		if (wl->scan.req->no_cck)
+			rate = wl1271_tx_min_rate_get(wl,
+						 CONF_TX_RATE_MASK_BASIC_P2P);
+		else
+			rate = wl1271_tx_min_rate_get(wl,
+						 CONF_TX_RATE_MASK_BASIC);
 		ret = wl1271_scan_send(wl, band, true, rate);
 		if (ret == WL1271_NOTHING_TO_SCAN) {
 			if (wl->enable_11a)
-- 
1.7.4.1

