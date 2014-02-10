Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f54.google.com ([74.125.82.54]:62360 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752399AbaBJLrt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Feb 2014 06:47:49 -0500
Received: by mail-wg0-f54.google.com with SMTP id x13so4168386wgg.9
        for <linux-wireless@vger.kernel.org>; Mon, 10 Feb 2014 03:47:48 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 04/18] wlcore: AP: don't start mac80211 PS on non-peer HLIDs
Date: Mon, 10 Feb 2014 13:47:20 +0200
Message-Id: <1392032854-28126-5-git-send-email-eliad@wizery.com> (sfid-20140210_124754_709831_EFA9E882)
In-Reply-To: <1392032854-28126-1-git-send-email-eliad@wizery.com>
References: <1392032854-28126-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

It seems the wl18xx FW sometimes sends spurious changes on the PSM state
of the broadcast HLID. This causes us to search for a station on a
non-peer link and fail, causing warnings in our log.

Prevent the driver from considering PSM changes for any non-peer HLIDs.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/ti/wlcore/ps.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wlcore/ps.c b/drivers/net/wireless/ti/wlcore/ps.c
index 26bfc36..b52516e 100644
--- a/drivers/net/wireless/ti/wlcore/ps.c
+++ b/drivers/net/wireless/ti/wlcore/ps.c
@@ -280,7 +280,11 @@ void wl12xx_ps_link_start(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 	struct ieee80211_sta *sta;
 	struct ieee80211_vif *vif = wl12xx_wlvif_to_vif(wlvif);
 
-	if (test_bit(hlid, &wl->ap_ps_map))
+	if (WARN_ON_ONCE(wlvif->bss_type != BSS_TYPE_AP_BSS))
+		return;
+
+	if (!test_bit(hlid, wlvif->ap.sta_hlid_map) ||
+	    test_bit(hlid, &wl->ap_ps_map))
 		return;
 
 	wl1271_debug(DEBUG_PSM, "start mac80211 PSM on hlid %d pkts %d "
-- 
1.8.5.2.229.g4448466.dirty

