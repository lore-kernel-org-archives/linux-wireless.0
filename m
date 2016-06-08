Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:48958 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758183AbcFHRH4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Jun 2016 13:07:56 -0400
From: Maya Erez <qca_merez@qualcomm.com>
Cc: Lior David <qca_liord@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qualcomm.com,
	Maya Erez <qca_merez@qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 2/2] wil6210: abort P2P search when stopping P2P device
Date: Wed,  8 Jun 2016 20:07:48 +0300
Message-Id: <1465405668-15881-3-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20160608_190800_355164_82E268D4)
In-Reply-To: <1465405668-15881-1-git-send-email-qca_merez@qca.qualcomm.com>
References: <1465405668-15881-1-git-send-email-qca_merez@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Lior David <qca_liord@qca.qualcomm.com>

The nl80211 layer expects P2P search operation to be aborted
if needed when stopping P2P device. If the P2P search operation
is still running after returning from stop_p2p_device
it causes a WARN_ON and possibly a kernel crash.
Fix this by aborting the P2P search in wil_cfg80211_stop_p2p_device
and preventing P2P search from being started on a stopped P2P
device.
Note, the fix does not cover the case where a regular scan
is started on the P2P device. It will be completed in the
future when support is added for aborting a scan operation.

Signed-off-by: Lior David <qca_liord@qca.qualcomm.com>
Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c | 16 ++++++++++++++++
 drivers/net/wireless/ath/wil6210/wil6210.h  |  1 +
 2 files changed, 17 insertions(+)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index 5769811..62bf933 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -378,6 +378,10 @@ static int wil_cfg80211_scan(struct wiphy *wiphy,
 	/* social scan on P2P_DEVICE is handled as p2p search */
 	if (wdev->iftype == NL80211_IFTYPE_P2P_DEVICE &&
 	    wil_p2p_is_social_scan(request)) {
+		if (!wil->p2p.p2p_dev_started) {
+			wil_err(wil, "P2P search requested on stopped P2P device\n");
+			return -EIO;
+		}
 		wil->scan_request = request;
 		wil->radio_wdev = wdev;
 		rc = wil_p2p_search(wil, request);
@@ -1351,6 +1355,7 @@ static int wil_cfg80211_start_p2p_device(struct wiphy *wiphy,
 	struct wil6210_priv *wil = wiphy_to_wil(wiphy);
 
 	wil_dbg_misc(wil, "%s: entered\n", __func__);
+	wil->p2p.p2p_dev_started = 1;
 	return 0;
 }
 
@@ -1358,8 +1363,19 @@ static void wil_cfg80211_stop_p2p_device(struct wiphy *wiphy,
 					 struct wireless_dev *wdev)
 {
 	struct wil6210_priv *wil = wiphy_to_wil(wiphy);
+	u8 started;
 
 	wil_dbg_misc(wil, "%s: entered\n", __func__);
+	mutex_lock(&wil->mutex);
+	started = wil_p2p_stop_discovery(wil);
+	if (started && wil->scan_request) {
+		cfg80211_scan_done(wil->scan_request, 1);
+		wil->scan_request = NULL;
+		wil->radio_wdev = wil->wdev;
+	}
+	mutex_unlock(&wil->mutex);
+
+	wil->p2p.p2p_dev_started = 0;
 }
 
 static struct cfg80211_ops wil_cfg80211_ops = {
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 1feaf5a..ecab4af 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -458,6 +458,7 @@ struct wil_tid_crypto_rx {
 struct wil_p2p_info {
 	struct ieee80211_channel listen_chan;
 	u8 discovery_started;
+	u8 p2p_dev_started;
 	u64 cookie;
 	struct timer_list discovery_timer; /* listen/search duration */
 	struct work_struct discovery_expired_work; /* listen/search expire */
-- 
1.8.5.2

