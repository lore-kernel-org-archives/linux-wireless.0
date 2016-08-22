Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:11997 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751287AbcHVJn3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Aug 2016 05:43:29 -0400
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Lior David <qca_liord@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com,
        Maya Erez <qca_merez@qca.qualcomm.com>
Subject: [PATCH 1/4] wil6210: fix protection of wil->scan_request
Date: Mon, 22 Aug 2016 12:42:19 +0300
Message-Id: <1471858942-23766-2-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20160822_114335_146057_197E468A)
In-Reply-To: <1471858942-23766-1-git-send-email-qca_merez@qca.qualcomm.com>
References: <1471858942-23766-1-git-send-email-qca_merez@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Lior David <qca_liord@qca.qualcomm.com>

Currently the places that check wil->scan_request and
call cfg80211_scan_done are not consistently protected,
so there is a risk that cfg80211_scan_done will be called
with NULL scan_request, causing a kernel crash.
Fix this by using p2p_wdev_mutex in few other places
that access scan_request. This makes sense since
scan_request may point to p2p_wdev, and it is not worth
the extra complexity of adding a new mutex.

Signed-off-by: Lior David <qca_liord@qca.qualcomm.com>
Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c | 3 +++
 drivers/net/wireless/ath/wil6210/main.c     | 4 ++++
 drivers/net/wireless/ath/wil6210/wil6210.h  | 2 +-
 drivers/net/wireless/ath/wil6210/wmi.c      | 4 ++--
 4 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index ffacc76..d117240 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -354,10 +354,13 @@ static int wil_cfg80211_scan(struct wiphy *wiphy,
 	wil_dbg_misc(wil, "%s(), wdev=0x%p iftype=%d\n",
 		     __func__, wdev, wdev->iftype);
 
+	mutex_lock(&wil->p2p_wdev_mutex);
 	if (wil->scan_request) {
 		wil_err(wil, "Already scanning\n");
+		mutex_unlock(&wil->p2p_wdev_mutex);
 		return -EAGAIN;
 	}
+	mutex_unlock(&wil->p2p_wdev_mutex);
 
 	/* check we are client side */
 	switch (wdev->iftype) {
diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index d0b180c..7b7619c 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -852,6 +852,7 @@ int wil_reset(struct wil6210_priv *wil, bool load_fw)
 	bitmap_zero(wil->status, wil_status_last);
 	mutex_unlock(&wil->wmi_mutex);
 
+	mutex_lock(&wil->p2p_wdev_mutex);
 	if (wil->scan_request) {
 		struct cfg80211_scan_info info = {
 			.aborted = true,
@@ -863,6 +864,7 @@ int wil_reset(struct wil6210_priv *wil, bool load_fw)
 		cfg80211_scan_done(wil->scan_request, &info);
 		wil->scan_request = NULL;
 	}
+	mutex_unlock(&wil->p2p_wdev_mutex);
 
 	wil_mask_irq(wil);
 
@@ -1055,6 +1057,7 @@ int __wil_down(struct wil6210_priv *wil)
 
 	wil_p2p_stop_radio_operations(wil);
 
+	mutex_lock(&wil->p2p_wdev_mutex);
 	if (wil->scan_request) {
 		struct cfg80211_scan_info info = {
 			.aborted = true,
@@ -1066,6 +1069,7 @@ int __wil_down(struct wil6210_priv *wil)
 		cfg80211_scan_done(wil->scan_request, &info);
 		wil->scan_request = NULL;
 	}
+	mutex_unlock(&wil->p2p_wdev_mutex);
 
 	wil_reset(wil, false);
 
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 6087691..1eb7fe7 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -657,7 +657,7 @@ struct wil6210_priv {
 
 	/* P2P_DEVICE vif */
 	struct wireless_dev *p2p_wdev;
-	struct mutex p2p_wdev_mutex; /* protect @p2p_wdev */
+	struct mutex p2p_wdev_mutex; /* protect @p2p_wdev and @scan_request */
 	struct wireless_dev *radio_wdev;
 
 	/* High Access Latency Policy voting */
diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index 4d92541..0b109b2 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -424,6 +424,7 @@ static void wmi_evt_tx_mgmt(struct wil6210_priv *wil, int id, void *d, int len)
 static void wmi_evt_scan_complete(struct wil6210_priv *wil, int id,
 				  void *d, int len)
 {
+	mutex_lock(&wil->p2p_wdev_mutex);
 	if (wil->scan_request) {
 		struct wmi_scan_complete_event *data = d;
 		struct cfg80211_scan_info info = {
@@ -435,14 +436,13 @@ static void wmi_evt_scan_complete(struct wil6210_priv *wil, int id,
 			     wil->scan_request, info.aborted);
 
 		del_timer_sync(&wil->scan_timer);
-		mutex_lock(&wil->p2p_wdev_mutex);
 		cfg80211_scan_done(wil->scan_request, &info);
 		wil->radio_wdev = wil->wdev;
-		mutex_unlock(&wil->p2p_wdev_mutex);
 		wil->scan_request = NULL;
 	} else {
 		wil_err(wil, "SCAN_COMPLETE while not scanning\n");
 	}
+	mutex_unlock(&wil->p2p_wdev_mutex);
 }
 
 static void wmi_evt_connect(struct wil6210_priv *wil, int id, void *d, int len)
-- 
1.9.1
