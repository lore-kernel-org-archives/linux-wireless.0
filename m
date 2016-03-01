Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:31443 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752895AbcCARSn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Mar 2016 12:18:43 -0500
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Lior David <qca_liord@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com,
	Maya Erez <qca_merez@qca.qualcomm.com>
Subject: [PATCH v2 11/15] wil6210: fix race conditions in p2p listen and search
Date: Tue,  1 Mar 2016 19:18:14 +0200
Message-Id: <1456852698-26808-12-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20160301_181902_033533_8C356B22)
In-Reply-To: <1456852698-26808-1-git-send-email-qca_merez@qca.qualcomm.com>
References: <1456852698-26808-1-git-send-email-qca_merez@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Lior David <qca_liord@qca.qualcomm.com>

Fix 2 race conditions found during test runs of P2P discovery:
1. Because wil_p2p_cancel_listen was not protected, user space
could start a new P2P listen/search before wmi_stop_discovery
completed. This caused a crash in the firmware.
2. In P2P listen, when listen timer expires and user space calls
cancel_remain_on_channel at the same time, code could send the
cfg80211_remain_on_channel_expired notification twice.

Added protections with wil->mutex to several places that call
wmi_stop_discovery.

Signed-off-by: Lior David <qca_liord@qca.qualcomm.com>
Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c |  9 +++--
 drivers/net/wireless/ath/wil6210/main.c     |  2 +-
 drivers/net/wireless/ath/wil6210/p2p.c      | 63 ++++++++++++++++++++---------
 drivers/net/wireless/ath/wil6210/wil6210.h  |  4 +-
 4 files changed, 53 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index 24f9829..e867c76 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -387,7 +387,7 @@ static int wil_cfg80211_scan(struct wiphy *wiphy,
 		return rc;
 	}
 
-	wil_p2p_stop_discovery(wil);
+	(void)wil_p2p_stop_discovery(wil);
 
 	wil_dbg_misc(wil, "Start scan_request 0x%p\n", request);
 	wil_dbg_misc(wil, "SSID count: %d", request->n_ssids);
@@ -868,6 +868,9 @@ static int wil_cfg80211_set_default_key(struct wiphy *wiphy,
 					u8 key_index, bool unicast,
 					bool multicast)
 {
+	struct wil6210_priv *wil = wiphy_to_wil(wiphy);
+
+	wil_dbg_misc(wil, "%s: entered\n", __func__);
 	return 0;
 }
 
@@ -903,9 +906,7 @@ static int wil_cancel_remain_on_channel(struct wiphy *wiphy,
 
 	wil_dbg_misc(wil, "%s()\n", __func__);
 
-	wil_p2p_cancel_listen(wil, cookie);
-
-	return 0;
+	return wil_p2p_cancel_listen(wil, cookie);
 }
 
 /**
diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index e09e9bb..05a4ae7 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -984,7 +984,7 @@ int __wil_down(struct wil6210_priv *wil)
 	}
 	wil_enable_irq(wil);
 
-	wil_p2p_stop_discovery(wil);
+	(void)wil_p2p_stop_discovery(wil);
 
 	if (wil->scan_request) {
 		wil_dbg_misc(wil, "Abort scan_request 0x%p\n",
diff --git a/drivers/net/wireless/ath/wil6210/p2p.c b/drivers/net/wireless/ath/wil6210/p2p.c
index d223648..2c1b895 100644
--- a/drivers/net/wireless/ath/wil6210/p2p.c
+++ b/drivers/net/wireless/ath/wil6210/p2p.c
@@ -156,26 +156,42 @@ out:
 	return rc;
 }
 
-void wil_p2p_stop_discovery(struct wil6210_priv *wil)
+u8 wil_p2p_stop_discovery(struct wil6210_priv *wil)
 {
 	struct wil_p2p_info *p2p = &wil->p2p;
+	u8 started = p2p->discovery_started;
 
 	if (p2p->discovery_started) {
 		del_timer_sync(&p2p->discovery_timer);
 		p2p->discovery_started = 0;
 		wmi_stop_discovery(wil);
 	}
+
+	return started;
 }
 
-void wil_p2p_cancel_listen(struct wil6210_priv *wil, u64 cookie)
+int wil_p2p_cancel_listen(struct wil6210_priv *wil, u64 cookie)
 {
 	struct wil_p2p_info *p2p = &wil->p2p;
+	u8 started;
+
+	mutex_lock(&wil->mutex);
 
-	if (cookie != p2p->cookie)
+	if (cookie != p2p->cookie) {
 		wil_info(wil, "%s: Cookie mismatch: 0x%016llx vs. 0x%016llx\n",
 			 __func__, p2p->cookie, cookie);
+		mutex_unlock(&wil->mutex);
+		return -ENOENT;
+	}
+
+	started = wil_p2p_stop_discovery(wil);
+
+	mutex_unlock(&wil->mutex);
 
-	wil_p2p_stop_discovery(wil);
+	if (!started) {
+		wil_err(wil, "%s: listen not started\n", __func__);
+		return -ENOENT;
+	}
 
 	mutex_lock(&wil->p2p_wdev_mutex);
 	cfg80211_remain_on_channel_expired(wil->radio_wdev,
@@ -184,6 +200,7 @@ void wil_p2p_cancel_listen(struct wil6210_priv *wil, u64 cookie)
 					   GFP_KERNEL);
 	wil->radio_wdev = wil->wdev;
 	mutex_unlock(&wil->p2p_wdev_mutex);
+	return 0;
 }
 
 void wil_p2p_listen_expired(struct work_struct *work)
@@ -192,18 +209,23 @@ void wil_p2p_listen_expired(struct work_struct *work)
 			struct wil_p2p_info, discovery_expired_work);
 	struct wil6210_priv *wil = container_of(p2p,
 			struct wil6210_priv, p2p);
+	u8 started;
 
 	wil_dbg_misc(wil, "%s()\n", __func__);
 
-	wil_p2p_stop_discovery(wil);
+	mutex_lock(&wil->mutex);
+	started = wil_p2p_stop_discovery(wil);
+	mutex_unlock(&wil->mutex);
 
-	mutex_lock(&wil->p2p_wdev_mutex);
-	cfg80211_remain_on_channel_expired(wil->radio_wdev,
-					   p2p->cookie,
-					   &p2p->listen_chan,
-					   GFP_KERNEL);
-	wil->radio_wdev = wil->wdev;
-	mutex_unlock(&wil->p2p_wdev_mutex);
+	if (started) {
+		mutex_lock(&wil->p2p_wdev_mutex);
+		cfg80211_remain_on_channel_expired(wil->radio_wdev,
+						   p2p->cookie,
+						   &p2p->listen_chan,
+						   GFP_KERNEL);
+		wil->radio_wdev = wil->wdev;
+		mutex_unlock(&wil->p2p_wdev_mutex);
+	}
 
 }
 
@@ -213,14 +235,19 @@ void wil_p2p_search_expired(struct work_struct *work)
 			struct wil_p2p_info, discovery_expired_work);
 	struct wil6210_priv *wil = container_of(p2p,
 			struct wil6210_priv, p2p);
+	u8 started;
 
 	wil_dbg_misc(wil, "%s()\n", __func__);
 
-	wil_p2p_stop_discovery(wil);
+	mutex_lock(&wil->mutex);
+	started = wil_p2p_stop_discovery(wil);
+	mutex_unlock(&wil->mutex);
 
-	mutex_lock(&wil->p2p_wdev_mutex);
-	cfg80211_scan_done(wil->scan_request, 0);
-	wil->scan_request = NULL;
-	wil->radio_wdev = wil->wdev;
-	mutex_unlock(&wil->p2p_wdev_mutex);
+	if (started) {
+		mutex_lock(&wil->p2p_wdev_mutex);
+		cfg80211_scan_done(wil->scan_request, 0);
+		wil->scan_request = NULL;
+		wil->radio_wdev = wil->wdev;
+		mutex_unlock(&wil->p2p_wdev_mutex);
+	}
 }
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 9b77a08..68f60ea 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -775,8 +775,8 @@ int wil_p2p_search(struct wil6210_priv *wil,
 		   struct cfg80211_scan_request *request);
 int wil_p2p_listen(struct wil6210_priv *wil, unsigned int duration,
 		   struct ieee80211_channel *chan, u64 *cookie);
-void wil_p2p_stop_discovery(struct wil6210_priv *wil);
-void wil_p2p_cancel_listen(struct wil6210_priv *wil, u64 cookie);
+u8 wil_p2p_stop_discovery(struct wil6210_priv *wil);
+int wil_p2p_cancel_listen(struct wil6210_priv *wil, u64 cookie);
 void wil_p2p_listen_expired(struct work_struct *work);
 void wil_p2p_search_expired(struct work_struct *work);
 
-- 
1.8.5.2

