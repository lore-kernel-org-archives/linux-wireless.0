Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f171.google.com ([74.125.82.171]:40177 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606AbaBJLsA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Feb 2014 06:48:00 -0500
Received: by mail-we0-f171.google.com with SMTP id u56so4167213wes.16
        for <linux-wireless@vger.kernel.org>; Mon, 10 Feb 2014 03:47:59 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 11/18] wlcore: don't stop sched_scan on interface removal
Date: Mon, 10 Feb 2014 13:47:27 +0200
Message-Id: <1392032854-28126-12-git-send-email-eliad@wizery.com> (sfid-20140210_130006_258853_1B888AD0)
In-Reply-To: <1392032854-28126-1-git-send-email-eliad@wizery.com>
References: <1392032854-28126-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Barak Bercovitz <barak@wizery.com>

Stopping sched scan on interface removal (during recovery)
is no longer needed, as sched scanning is automatically
restarted by mac80211.

Signed-off-by: Barak Bercovitz <barak@wizery.com>
Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/ti/wlcore/main.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 73bf251..bea2938 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -2582,10 +2582,8 @@ static void __wl1271_op_remove_interface(struct wl1271 *wl,
 		ieee80211_scan_completed(wl->hw, true);
 	}
 
-	if (wl->sched_vif == wlvif) {
-		ieee80211_sched_scan_stopped(wl->hw);
+	if (wl->sched_vif == wlvif)
 		wl->sched_vif = NULL;
-	}
 
 	if (wl->roc_vif == vif) {
 		wl->roc_vif = NULL;
-- 
1.8.5.2.229.g4448466.dirty

