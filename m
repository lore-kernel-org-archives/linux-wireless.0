Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:57663 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751775AbaL2GY0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Dec 2014 01:24:26 -0500
Received: by mail-wi0-f173.google.com with SMTP id r20so21086995wiv.12
        for <linux-wireless@vger.kernel.org>; Sun, 28 Dec 2014 22:24:25 -0800 (PST)
Received: from muse.ger.corp.intel.com (85-250-108-142.bb.netvision.net.il. [85.250.108.142])
        by mx.google.com with ESMTPSA id gb10sm23488030wjb.21.2014.12.28.22.24.23
        for <linux-wireless@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 28 Dec 2014 22:24:24 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: <linux-wireless@vger.kernel.org>
Subject: [PATCH 05/13] wlcore: enable AP wowlan
Date: Mon, 29 Dec 2014 08:24:05 +0200
Message-Id: <1419834253-18331-5-git-send-email-eliad@wizery.com> (sfid-20141229_072431_843387_838D3C49)
In-Reply-To: <1419834253-18331-1-git-send-email-eliad@wizery.com>
References: <1419834253-18331-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

configure wowlan when host is suspended in AP mode,
since the FW can now wake the host up on Rx.

Signed-off-by: Kobi Leibovitch <kobi.lev100@gmail.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/ti/wlcore/main.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index aaa836b..0d67e39 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -1707,7 +1707,8 @@ out:
 }
 
 static int wl1271_configure_suspend_ap(struct wl1271 *wl,
-				       struct wl12xx_vif *wlvif)
+					struct wl12xx_vif *wlvif,
+					struct cfg80211_wowlan *wow)
 {
 	int ret = 0;
 
@@ -1715,6 +1716,12 @@ static int wl1271_configure_suspend_ap(struct wl1271 *wl,
 		goto out;
 
 	ret = wl1271_acx_beacon_filter_opt(wl, wlvif, true);
+	if (ret < 0)
+		goto out;
+
+	ret = wl1271_configure_wowlan(wl, wow);
+	if (ret < 0)
+		goto out;
 
 out:
 	return ret;
@@ -1728,7 +1735,7 @@ static int wl1271_configure_suspend(struct wl1271 *wl,
 	if (wlvif->bss_type == BSS_TYPE_STA_BSS)
 		return wl1271_configure_suspend_sta(wl, wlvif, wow);
 	if (wlvif->bss_type == BSS_TYPE_AP_BSS)
-		return wl1271_configure_suspend_ap(wl, wlvif);
+		return wl1271_configure_suspend_ap(wl, wlvif, wow);
 	return 0;
 }
 
@@ -1741,12 +1748,13 @@ static void wl1271_configure_resume(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 	if ((!is_ap) && (!is_sta))
 		return;
 
-	if (is_sta && !test_bit(WLVIF_FLAG_STA_ASSOCIATED, &wlvif->flags))
+	if ((is_sta && !test_bit(WLVIF_FLAG_STA_ASSOCIATED, &wlvif->flags)) ||
+	    (is_ap && !test_bit(WLVIF_FLAG_AP_STARTED, &wlvif->flags)))
 		return;
 
-	if (is_sta) {
-		wl1271_configure_wowlan(wl, NULL);
+	wl1271_configure_wowlan(wl, NULL);
 
+	if (is_sta) {
 		if ((wl->conf.conn.suspend_wake_up_event ==
 		     wl->conf.conn.wake_up_event) &&
 		    (wl->conf.conn.suspend_listen_interval ==
-- 
1.8.5.2.229.g4448466.dirty

