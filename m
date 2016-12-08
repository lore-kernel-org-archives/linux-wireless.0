Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:51400 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932602AbcLHQ2M (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Dec 2016 11:28:12 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] cfg80211/mac80211: fix BSS leaks when abandoning assoc attempts
Date: Thu,  8 Dec 2016 17:28:07 +0100
Message-Id: <20161208162807.12467-1-johannes@sipsolutions.net> (sfid-20161208_172820_915806_E6C58A17)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When mac80211 abandons an association attempt, it may free
all the data structures, but inform cfg80211 and userspace
about it only by sending the deauth frame it received, in
which case cfg80211 has no link to the BSS struct that was
used and will not cfg80211_unhold_bss() it.

Fix this by providing a way to inform cfg80211 of this with
the BSS entry passed, so that it can clean up properly, and
use this ability in the appropriate places in mac80211.

This isn't ideal: some code is more or less duplicated and
tracing is missing. However, it's a fairly small change and
it's thus easier to backport - cleanups can come later.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/cfg80211.h | 11 +++++++++++
 net/mac80211/mlme.c    | 21 ++++++++++++---------
 net/wireless/core.h    |  1 +
 net/wireless/mlme.c    | 12 ++++++++++++
 net/wireless/sme.c     | 14 ++++++++++++++
 5 files changed, 50 insertions(+), 9 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index ef42749f785f..ca2ac1ce5862 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -4675,6 +4675,17 @@ void cfg80211_rx_assoc_resp(struct net_device *dev,
 void cfg80211_assoc_timeout(struct net_device *dev, struct cfg80211_bss *bss);
 
 /**
+ * cfg80211_abandon_assoc - notify cfg80211 of abandoned association attempt
+ * @dev: network device
+ * @bss: The BSS entry with which association was abandoned.
+ *
+ * Call this whenever - for reasons reported through other API, like deauth RX,
+ * an association attempt was abandoned.
+ * This function may sleep. The caller must hold the corresponding wdev's mutex.
+ */
+void cfg80211_abandon_assoc(struct net_device *dev, struct cfg80211_bss *bss);
+
+/**
  * cfg80211_tx_mlme_mgmt - notification of transmitted deauth/disassoc frame
  * @dev: network device
  * @buf: 802.11 frame (header + body)
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 68172d5d2ca0..8a6344518674 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2514,7 +2514,7 @@ static void ieee80211_destroy_auth_data(struct ieee80211_sub_if_data *sdata,
 }
 
 static void ieee80211_destroy_assoc_data(struct ieee80211_sub_if_data *sdata,
-					 bool assoc)
+					 bool assoc, bool abandon)
 {
 	struct ieee80211_mgd_assoc_data *assoc_data = sdata->u.mgd.assoc_data;
 
@@ -2537,6 +2537,9 @@ static void ieee80211_destroy_assoc_data(struct ieee80211_sub_if_data *sdata,
 		mutex_lock(&sdata->local->mtx);
 		ieee80211_vif_release_channel(sdata);
 		mutex_unlock(&sdata->local->mtx);
+
+		if (abandon)
+			cfg80211_abandon_assoc(sdata->dev, assoc_data->bss);
 	}
 
 	kfree(assoc_data);
@@ -2769,7 +2772,7 @@ static void ieee80211_rx_mgmt_deauth(struct ieee80211_sub_if_data *sdata,
 			   bssid, reason_code,
 			   ieee80211_get_reason_code_string(reason_code));
 
-		ieee80211_destroy_assoc_data(sdata, false);
+		ieee80211_destroy_assoc_data(sdata, false, true);
 
 		cfg80211_rx_mlme_mgmt(sdata->dev, (u8 *)mgmt, len);
 		return;
@@ -3178,14 +3181,14 @@ static void ieee80211_rx_mgmt_assoc_resp(struct ieee80211_sub_if_data *sdata,
 	if (status_code != WLAN_STATUS_SUCCESS) {
 		sdata_info(sdata, "%pM denied association (code=%d)\n",
 			   mgmt->sa, status_code);
-		ieee80211_destroy_assoc_data(sdata, false);
+		ieee80211_destroy_assoc_data(sdata, false, false);
 		event.u.mlme.status = MLME_DENIED;
 		event.u.mlme.reason = status_code;
 		drv_event_callback(sdata->local, sdata, &event);
 	} else {
 		if (!ieee80211_assoc_success(sdata, bss, mgmt, len)) {
 			/* oops -- internal error -- send timeout for now */
-			ieee80211_destroy_assoc_data(sdata, false);
+			ieee80211_destroy_assoc_data(sdata, false, false);
 			cfg80211_assoc_timeout(sdata->dev, bss);
 			return;
 		}
@@ -3198,7 +3201,7 @@ static void ieee80211_rx_mgmt_assoc_resp(struct ieee80211_sub_if_data *sdata,
 		 * recalc after assoc_data is NULL but before associated
 		 * is set can cause the interface to go idle
 		 */
-		ieee80211_destroy_assoc_data(sdata, true);
+		ieee80211_destroy_assoc_data(sdata, true, false);
 
 		/* get uapsd queues configuration */
 		uapsd_queues = 0;
@@ -3897,7 +3900,7 @@ void ieee80211_sta_work(struct ieee80211_sub_if_data *sdata)
 				.u.mlme.status = MLME_TIMEOUT,
 			};
 
-			ieee80211_destroy_assoc_data(sdata, false);
+			ieee80211_destroy_assoc_data(sdata, false, false);
 			cfg80211_assoc_timeout(sdata->dev, bss);
 			drv_event_callback(sdata->local, sdata, &event);
 		}
@@ -4036,7 +4039,7 @@ void ieee80211_mgd_quiesce(struct ieee80211_sub_if_data *sdata)
 					       WLAN_REASON_DEAUTH_LEAVING,
 					       false, frame_buf);
 		if (ifmgd->assoc_data)
-			ieee80211_destroy_assoc_data(sdata, false);
+			ieee80211_destroy_assoc_data(sdata, false, true);
 		if (ifmgd->auth_data)
 			ieee80211_destroy_auth_data(sdata, false);
 		cfg80211_tx_mlme_mgmt(sdata->dev, frame_buf,
@@ -4945,7 +4948,7 @@ int ieee80211_mgd_deauth(struct ieee80211_sub_if_data *sdata,
 					       IEEE80211_STYPE_DEAUTH,
 					       req->reason_code, tx,
 					       frame_buf);
-		ieee80211_destroy_assoc_data(sdata, false);
+		ieee80211_destroy_assoc_data(sdata, false, true);
 		ieee80211_report_disconnect(sdata, frame_buf,
 					    sizeof(frame_buf), true,
 					    req->reason_code);
@@ -5020,7 +5023,7 @@ void ieee80211_mgd_stop(struct ieee80211_sub_if_data *sdata)
 	sdata_lock(sdata);
 	if (ifmgd->assoc_data) {
 		struct cfg80211_bss *bss = ifmgd->assoc_data->bss;
-		ieee80211_destroy_assoc_data(sdata, false);
+		ieee80211_destroy_assoc_data(sdata, false, false);
 		cfg80211_assoc_timeout(sdata->dev, bss);
 	}
 	if (ifmgd->auth_data)
diff --git a/net/wireless/core.h b/net/wireless/core.h
index fb2fcd5581fe..9820fa251daa 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -409,6 +409,7 @@ void cfg80211_sme_disassoc(struct wireless_dev *wdev);
 void cfg80211_sme_deauth(struct wireless_dev *wdev);
 void cfg80211_sme_auth_timeout(struct wireless_dev *wdev);
 void cfg80211_sme_assoc_timeout(struct wireless_dev *wdev);
+void cfg80211_sme_abandon_assoc(struct wireless_dev *wdev);
 
 /* internal helpers */
 bool cfg80211_supported_cipher_suite(struct wiphy *wiphy, u32 cipher);
diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index bd1f7a159d6a..4646cf5695b9 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -149,6 +149,18 @@ void cfg80211_assoc_timeout(struct net_device *dev, struct cfg80211_bss *bss)
 }
 EXPORT_SYMBOL(cfg80211_assoc_timeout);
 
+void cfg80211_abandon_assoc(struct net_device *dev, struct cfg80211_bss *bss)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct wiphy *wiphy = wdev->wiphy;
+
+	cfg80211_sme_abandon_assoc(wdev);
+
+	cfg80211_unhold_bss(bss_from_pub(bss));
+	cfg80211_put_bss(wiphy, bss);
+}
+EXPORT_SYMBOL(cfg80211_abandon_assoc);
+
 void cfg80211_tx_mlme_mgmt(struct net_device *dev, const u8 *buf, size_t len)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index 2b5bb380414b..5e0d19380302 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -39,6 +39,7 @@ struct cfg80211_conn {
 		CFG80211_CONN_ASSOCIATING,
 		CFG80211_CONN_ASSOC_FAILED,
 		CFG80211_CONN_DEAUTH,
+		CFG80211_CONN_ABANDON,
 		CFG80211_CONN_CONNECTED,
 	} state;
 	u8 bssid[ETH_ALEN], prev_bssid[ETH_ALEN];
@@ -206,6 +207,8 @@ static int cfg80211_conn_do_work(struct wireless_dev *wdev)
 		cfg80211_mlme_deauth(rdev, wdev->netdev, params->bssid,
 				     NULL, 0,
 				     WLAN_REASON_DEAUTH_LEAVING, false);
+		/* fall through */
+	case CFG80211_CONN_ABANDON:
 		/* free directly, disconnected event already sent */
 		cfg80211_sme_free(wdev);
 		return 0;
@@ -423,6 +426,17 @@ void cfg80211_sme_assoc_timeout(struct wireless_dev *wdev)
 	schedule_work(&rdev->conn_work);
 }
 
+void cfg80211_sme_abandon_assoc(struct wireless_dev *wdev)
+{
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
+
+	if (!wdev->conn)
+		return;
+
+	wdev->conn->state = CFG80211_CONN_ABANDON;
+	schedule_work(&rdev->conn_work);
+}
+
 static int cfg80211_sme_get_conn_ies(struct wireless_dev *wdev,
 				     const u8 *ies, size_t ies_len,
 				     const u8 **out_ies, size_t *out_ies_len)
-- 
2.9.3
