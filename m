Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:59487 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754924Ab2CLMxK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Mar 2012 08:53:10 -0400
Received: by wejx9 with SMTP id x9so3177449wej.19
        for <linux-wireless@vger.kernel.org>; Mon, 12 Mar 2012 05:53:09 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] wl12xx: set do_join on BSS_CHANGED_ASSOC
Date: Mon, 12 Mar 2012 14:53:04 +0200
Message-Id: <1331556784-25291-1-git-send-email-eliad@wizery.com> (sfid-20120312_135313_989561_C18FCD18)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

wl12xx sets the do_join flag (which later starts the
sta role) when the bssid was changed and the sta is
associated. However, this no longer happens after
the "mac80211: remove spurious BSSID change flag"
patch.

Fix it by setting the do_join flag on BSS_CHANGED_ASSOC
(for IBSS, do_join is already set on BSS_CHANGED_IBSS)

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 7e0a096..ea654b8 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -3950,8 +3950,7 @@ static void wl1271_bss_info_changed_sta(struct wl1271 *wl,
 		wlvif->rssi_thold = bss_conf->cqm_rssi_thold;
 	}
 
-	if (changed & BSS_CHANGED_BSSID &&
-	    (is_ibss || bss_conf->assoc))
+	if (changed & BSS_CHANGED_BSSID)
 		if (!is_zero_ether_addr(bss_conf->bssid)) {
 			ret = wl12xx_cmd_build_null_data(wl, wlvif);
 			if (ret < 0)
@@ -3960,9 +3959,6 @@ static void wl1271_bss_info_changed_sta(struct wl1271 *wl,
 			ret = wl1271_build_qos_null_data(wl, vif);
 			if (ret < 0)
 				goto out;
-
-			/* Need to update the BSSID (for filtering etc) */
-			do_join = true;
 		}
 
 	if (changed & (BSS_CHANGED_ASSOC | BSS_CHANGED_HT)) {
@@ -3989,6 +3985,7 @@ sta_not_found:
 			int ieoffset;
 			wlvif->aid = bss_conf->aid;
 			wlvif->beacon_int = bss_conf->beacon_int;
+			do_join = true;
 			set_assoc = true;
 
 			/*
-- 
1.7.6.401.g6a319

