Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:37140 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754857Ab1FFJVj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jun 2011 05:21:39 -0400
Received: by mail-ww0-f44.google.com with SMTP id 36so3582178wwa.1
        for <linux-wireless@vger.kernel.org>; Mon, 06 Jun 2011 02:21:38 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 3/4] wl12xx: enable/disable beacon filtering on ap suspend/resume
Date: Mon,  6 Jun 2011 12:21:54 +0300
Message-Id: <1307352115-28969-3-git-send-email-eliad@wizery.com> (sfid-20110606_112142_415996_5968AD30)
In-Reply-To: <1307352115-28969-1-git-send-email-eliad@wizery.com>
References: <1307352115-28969-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Beacon filtering needs to be enabled so AP won't wake up by
by every received beacon.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c |   49 +++++++++++++++++++++++++++++------
 1 files changed, 40 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 4f20711..97f565c 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -1467,13 +1467,10 @@ static struct notifier_block wl1271_dev_notifier = {
 	.notifier_call = wl1271_dev_notify,
 };
 
-static int wl1271_configure_suspend(struct wl1271 *wl)
+static int wl1271_configure_suspend_sta(struct wl1271 *wl)
 {
 	int ret;
 
-	if (wl->bss_type != BSS_TYPE_STA_BSS)
-		return 0;
-
 	mutex_lock(&wl->mutex);
 
 	ret = wl1271_ps_elp_wakeup(wl);
@@ -1518,11 +1515,41 @@ out:
 
 }
 
+static int wl1271_configure_suspend_ap(struct wl1271 *wl)
+{
+	int ret;
+
+	mutex_lock(&wl->mutex);
+
+	ret = wl1271_ps_elp_wakeup(wl);
+	if (ret < 0)
+		goto out_unlock;
+
+	ret = wl1271_acx_set_ap_beacon_filter(wl, true);
+
+	wl1271_ps_elp_sleep(wl);
+out_unlock:
+	mutex_unlock(&wl->mutex);
+	return ret;
+
+}
+
+static int wl1271_configure_suspend(struct wl1271 *wl)
+{
+	if (wl->bss_type == BSS_TYPE_STA_BSS)
+		return wl1271_configure_suspend_sta(wl);
+	if (wl->bss_type == BSS_TYPE_AP_BSS)
+		return wl1271_configure_suspend_ap(wl);
+	return 0;
+}
+
 static void wl1271_configure_resume(struct wl1271 *wl)
 {
 	int ret;
+	bool is_sta = wl->bss_type == BSS_TYPE_STA_BSS;
+	bool is_ap = wl->bss_type == BSS_TYPE_AP_BSS;
 
-	if (wl->bss_type != BSS_TYPE_STA_BSS)
+	if (!is_sta && !is_ap)
 		return;
 
 	mutex_lock(&wl->mutex);
@@ -1530,10 +1557,14 @@ static void wl1271_configure_resume(struct wl1271 *wl)
 	if (ret < 0)
 		goto out;
 
-	/* exit psm if it wasn't configured */
-	if (!test_bit(WL1271_FLAG_PSM_REQUESTED, &wl->flags))
-		wl1271_ps_set_mode(wl, STATION_ACTIVE_MODE,
-				   wl->basic_rate, true);
+	if (is_sta) {
+		/* exit psm if it wasn't configured */
+		if (!test_bit(WL1271_FLAG_PSM_REQUESTED, &wl->flags))
+			wl1271_ps_set_mode(wl, STATION_ACTIVE_MODE,
+					   wl->basic_rate, true);
+	} else if (is_ap) {
+		wl1271_acx_set_ap_beacon_filter(wl, false);
+	}
 
 	wl1271_ps_elp_sleep(wl);
 out:
-- 
1.7.0.4

