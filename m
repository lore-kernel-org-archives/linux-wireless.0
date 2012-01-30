Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:47536 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752543Ab2A3L5m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jan 2012 06:57:42 -0500
Received: by mail-wi0-f174.google.com with SMTP id s10so3321396wic.19
        for <linux-wireless@vger.kernel.org>; Mon, 30 Jan 2012 03:57:41 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 03/12] wl12xx: use dev_role_id for sched scan
Date: Mon, 30 Jan 2012 14:00:48 +0200
Message-Id: <1327924857-1250-4-git-send-email-eliad@wizery.com> (sfid-20120130_125748_754688_47435533)
In-Reply-To: <1327924857-1250-1-git-send-email-eliad@wizery.com>
References: <1327924857-1250-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

sched_scan is used only when the sta is
not associated, and thus should use
the dev role (instead of sta role)

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/scan.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/scan.c b/drivers/net/wireless/wl12xx/scan.c
index 3e3f2f5..6adc733 100644
--- a/drivers/net/wireless/wl12xx/scan.c
+++ b/drivers/net/wireless/wl12xx/scan.c
@@ -670,7 +670,7 @@ int wl1271_scan_sched_scan_config(struct wl1271 *wl,
 	if (!force_passive && cfg->active[0]) {
 		u8 band = IEEE80211_BAND_2GHZ;
 		ret = wl12xx_cmd_build_probe_req(wl, wlvif,
-						 wlvif->role_id, band,
+						 wlvif->dev_role_id, band,
 						 req->ssids[0].ssid,
 						 req->ssids[0].ssid_len,
 						 ies->ie[band],
@@ -684,7 +684,7 @@ int wl1271_scan_sched_scan_config(struct wl1271 *wl,
 	if (!force_passive && cfg->active[1]) {
 		u8 band = IEEE80211_BAND_5GHZ;
 		ret = wl12xx_cmd_build_probe_req(wl, wlvif,
-						 wlvif->role_id, band,
+						 wlvif->dev_role_id, band,
 						 req->ssids[0].ssid,
 						 req->ssids[0].ssid_len,
 						 ies->ie[band],
-- 
1.7.6.401.g6a319

