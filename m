Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f175.google.com ([209.85.192.175]:33139 "EHLO
	mail-pf0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316AbcCRCVh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Mar 2016 22:21:37 -0400
Received: by mail-pf0-f175.google.com with SMTP id 4so15013528pfd.0
        for <linux-wireless@vger.kernel.org>; Thu, 17 Mar 2016 19:21:37 -0700 (PDT)
From: Julian Calaby <julian.calaby@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Johannes Berg <johannes.berg@intel.com>,
	Eliad Peller <eliad@wizery.com>,
	Tony Lindgren <tony@atomide.com>,
	Luciano Coelho <luca@coelho.fi>,
	Shahar Patury <shaharp@ti.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Eyal Reizer <eyalreizer@gmail.com>,
	Geliang Tang <geliangtang@163.com>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 03/19] wlcore: use to_delayed_work()
Date: Fri, 18 Mar 2016 13:21:28 +1100
Message-Id: <f51982068829589a8530789dfc61383d3b0cf021.1458262312.git.julian.calaby@gmail.com> (sfid-20160318_032141_484937_5F757088)
In-Reply-To: <cover.1458262312.git.julian.calaby@gmail.com>
References: <cover.1458262312.git.julian.calaby@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Geliang Tang <geliangtang@163.com>

Use to_delayed_work() instead of open-coding it.

Signed-off-by: Geliang Tang <geliangtang@163.com>
[Update commit message]
Signed-off-by: Julian Calaby <julian.calaby@gmail.com>
---
 drivers/net/wireless/ti/wlcore/main.c | 10 +++++-----
 drivers/net/wireless/ti/wlcore/ps.c   |  2 +-
 drivers/net/wireless/ti/wlcore/scan.c |  2 +-
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index dde3620..a872a07 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -243,7 +243,7 @@ static void wl12xx_tx_watchdog_work(struct work_struct *work)
 	struct delayed_work *dwork;
 	struct wl1271 *wl;
 
-	dwork = container_of(work, struct delayed_work, work);
+	dwork = to_delayed_work(work);
 	wl = container_of(dwork, struct wl1271, tx_watchdog_work);
 
 	mutex_lock(&wl->mutex);
@@ -2011,7 +2011,7 @@ static void wlcore_channel_switch_work(struct work_struct *work)
 	struct wl12xx_vif *wlvif;
 	int ret;
 
-	dwork = container_of(work, struct delayed_work, work);
+	dwork = to_delayed_work(work);
 	wlvif = container_of(dwork, struct wl12xx_vif, channel_switch_work);
 	wl = wlvif->wl;
 
@@ -2047,7 +2047,7 @@ static void wlcore_connection_loss_work(struct work_struct *work)
 	struct ieee80211_vif *vif;
 	struct wl12xx_vif *wlvif;
 
-	dwork = container_of(work, struct delayed_work, work);
+	dwork = to_delayed_work(work);
 	wlvif = container_of(dwork, struct wl12xx_vif, connection_loss_work);
 	wl = wlvif->wl;
 
@@ -2076,7 +2076,7 @@ static void wlcore_pending_auth_complete_work(struct work_struct *work)
 	unsigned long time_spare;
 	int ret;
 
-	dwork = container_of(work, struct delayed_work, work);
+	dwork = to_delayed_work(work);
 	wlvif = container_of(dwork, struct wl12xx_vif,
 			     pending_auth_complete_work);
 	wl = wlvif->wl;
@@ -5588,7 +5588,7 @@ static void wlcore_roc_complete_work(struct work_struct *work)
 	struct wl1271 *wl;
 	int ret;
 
-	dwork = container_of(work, struct delayed_work, work);
+	dwork = to_delayed_work(work);
 	wl = container_of(dwork, struct wl1271, roc_complete_work);
 
 	ret = wlcore_roc_completed(wl);
diff --git a/drivers/net/wireless/ti/wlcore/ps.c b/drivers/net/wireless/ti/wlcore/ps.c
index 4cd316e..d4420da 100644
--- a/drivers/net/wireless/ti/wlcore/ps.c
+++ b/drivers/net/wireless/ti/wlcore/ps.c
@@ -38,7 +38,7 @@ void wl1271_elp_work(struct work_struct *work)
 	struct wl12xx_vif *wlvif;
 	int ret;
 
-	dwork = container_of(work, struct delayed_work, work);
+	dwork = to_delayed_work(work);
 	wl = container_of(dwork, struct wl1271, elp_work);
 
 	wl1271_debug(DEBUG_PSM, "elp work");
diff --git a/drivers/net/wireless/ti/wlcore/scan.c b/drivers/net/wireless/ti/wlcore/scan.c
index 1e3d51c..a384f3f 100644
--- a/drivers/net/wireless/ti/wlcore/scan.c
+++ b/drivers/net/wireless/ti/wlcore/scan.c
@@ -38,7 +38,7 @@ void wl1271_scan_complete_work(struct work_struct *work)
 	struct wl12xx_vif *wlvif;
 	int ret;
 
-	dwork = container_of(work, struct delayed_work, work);
+	dwork = to_delayed_work(work);
 	wl = container_of(dwork, struct wl1271, scan_complete_work);
 
 	wl1271_debug(DEBUG_SCAN, "Scanning complete");
-- 
2.7.0

