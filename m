Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:58910 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563Ab2CDIzs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Mar 2012 03:55:48 -0500
Received: by wgbdr13 with SMTP id dr13so2663813wgb.1
        for <linux-wireless@vger.kernel.org>; Sun, 04 Mar 2012 00:55:47 -0800 (PST)
MIME-Version: 1.0
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 01/11] wl12xx: don't start dev role on ibss vifs
Date: Sun,  4 Mar 2012 10:55:45 +0200
Message-Id: <1330851355-24459-2-git-send-email-eliad@wizery.com> (sfid-20120304_095620_237655_0884EF34)
In-Reply-To: <1330851355-24459-1-git-send-email-eliad@wizery.com>
References: <1330851355-24459-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

device role is used for scanning and sending packets
before connection. however, since we don't need to
send packets before ibss creation, there is no need
to start the device on idle-off.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 418b2b8..93636ea 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -3746,10 +3746,8 @@ static void wl1271_bss_info_changed_sta(struct wl1271 *wl,
 			ibss_joined = true;
 		} else {
 			if (test_and_clear_bit(WLVIF_FLAG_IBSS_JOINED,
-					       &wlvif->flags)) {
+					       &wlvif->flags))
 				wl1271_unjoin(wl, wlvif);
-				wl12xx_start_dev(wl, wlvif);
-			}
 		}
 	}
 
@@ -3767,7 +3765,7 @@ static void wl1271_bss_info_changed_sta(struct wl1271 *wl,
 		do_join = true;
 	}
 
-	if (changed & BSS_CHANGED_IDLE) {
+	if (changed & BSS_CHANGED_IDLE && !is_ibss) {
 		ret = wl1271_sta_handle_idle(wl, wlvif, bss_conf->idle);
 		if (ret < 0)
 			wl1271_warning("idle mode change failed %d", ret);
-- 
1.7.6.401.g6a319

