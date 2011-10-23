Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41955 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753706Ab1JWGWD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Oct 2011 02:22:03 -0400
Received: by mail-bw0-f46.google.com with SMTP id zt19so6690457bkb.19
        for <linux-wireless@vger.kernel.org>; Sat, 22 Oct 2011 23:22:02 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Eliad Peller <eliad@wizery.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 2/2] wl12xx: handle idle changes per-interface
Date: Sun, 23 Oct 2011 08:21:55 +0200
Message-Id: <1319350915-31222-2-git-send-email-arik@wizery.com> (sfid-20111023_082208_653732_02A2B1D3)
In-Reply-To: <1319350915-31222-1-git-send-email-arik@wizery.com>
References: <1319350915-31222-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

Idle changes are currently handled per hardware.
However, some operations should be done only per-interface.

Signed-off-by: Eliad Peller <eliad@wizery.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c |   13 ++++++-------
 1 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 75adc76..b65816d 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -2540,13 +2540,6 @@ static int wl12xx_config_vif(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 		}
 	}
 
-	if (changed & IEEE80211_CONF_CHANGE_IDLE && !is_ap) {
-		ret = wl1271_sta_handle_idle(wl, wlvif,
-					conf->flags & IEEE80211_CONF_IDLE);
-		if (ret < 0)
-			wl1271_warning("idle mode change failed %d", ret);
-	}
-
 	/*
 	 * if mac80211 changes the PSM mode, make sure the mode is not
 	 * incorrectly changed after the pspoll failure active window.
@@ -3619,6 +3612,12 @@ static void wl1271_bss_info_changed_sta(struct wl1271 *wl,
 		do_join = true;
 	}
 
+	if (changed & BSS_CHANGED_IDLE) {
+		ret = wl1271_sta_handle_idle(wl, wlvif, bss_conf->idle);
+		if (ret < 0)
+			wl1271_warning("idle mode change failed %d", ret);
+	}
+
 	if ((changed & BSS_CHANGED_CQM)) {
 		bool enable = false;
 		if (bss_conf->cqm_rssi_thold)
-- 
1.7.5.4

