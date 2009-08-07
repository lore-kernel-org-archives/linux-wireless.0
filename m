Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54605 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753599AbZHGPyQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Aug 2009 11:54:16 -0400
Subject: [PATCH] cfg80211: fix alignment problem in scan request
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Ivan Kuten <ivan.kuten@promwad.com>,
	Yauhen Kharuzhy <yauhen.kharuzhy@promwad.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 07 Aug 2009 17:54:07 +0200
Message-Id: <1249660447.7194.9.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The memory layout for scan requests was rather wrong,
we put the scan SSIDs before the channels which could
lead to the channel pointers being unaligned in memory.
It turns out that using a pointer to the channel array
isn't necessary anyway since we can embed a zero-length
array into the struct.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/net/cfg80211.h     |    4 +++-
 net/mac80211/ieee80211_i.h |    2 +-
 net/mac80211/main.c        |   16 ++++++++--------
 net/mac80211/scan.c        |   10 +++++-----
 net/wireless/nl80211.c     |    3 +--
 net/wireless/scan.c        |    4 ++--
 net/wireless/sme.c         |    3 +--
 7 files changed, 21 insertions(+), 21 deletions(-)

--- wireless-testing.orig/include/net/cfg80211.h	2009-08-07 17:49:05.000000000 +0200
+++ wireless-testing/include/net/cfg80211.h	2009-08-07 17:49:06.000000000 +0200
@@ -559,7 +559,6 @@ struct cfg80211_ssid {
 struct cfg80211_scan_request {
 	struct cfg80211_ssid *ssids;
 	int n_ssids;
-	struct ieee80211_channel **channels;
 	u32 n_channels;
 	const u8 *ie;
 	size_t ie_len;
@@ -568,6 +567,9 @@ struct cfg80211_scan_request {
 	struct wiphy *wiphy;
 	struct net_device *dev;
 	bool aborted;
+
+	/* keep last */
+	struct ieee80211_channel *channels[0];
 };
 
 /**
--- wireless-testing.orig/net/wireless/nl80211.c	2009-08-07 17:49:05.000000000 +0200
+++ wireless-testing/net/wireless/nl80211.c	2009-08-07 17:49:06.000000000 +0200
@@ -3002,10 +3002,9 @@ static int nl80211_trigger_scan(struct s
 		goto out;
 	}
 
-	request->channels = (void *)((char *)request + sizeof(*request));
 	request->n_channels = n_channels;
 	if (n_ssids)
-		request->ssids = (void *)(request->channels + n_channels);
+		request->ssids = (void *)&request->channels[n_channels];
 	request->n_ssids = n_ssids;
 	if (ie_len) {
 		if (request->ssids)
--- wireless-testing.orig/net/wireless/scan.c	2009-08-07 17:49:05.000000000 +0200
+++ wireless-testing/net/wireless/scan.c	2009-08-07 17:49:06.000000000 +0200
@@ -612,8 +612,8 @@ int cfg80211_wext_siwscan(struct net_dev
 
 	creq->wiphy = wiphy;
 	creq->dev = dev;
-	creq->ssids = (void *)(creq + 1);
-	creq->channels = (void *)(creq->ssids + 1);
+	/* SSIDs come after channels */
+	creq->ssids = (void *)&creq->channels[n_channels];
 	creq->n_channels = n_channels;
 	creq->n_ssids = 1;
 
--- wireless-testing.orig/net/wireless/sme.c	2009-08-07 17:49:05.000000000 +0200
+++ wireless-testing/net/wireless/sme.c	2009-08-07 17:49:06.000000000 +0200
@@ -65,7 +65,6 @@ static int cfg80211_conn_scan(struct wir
 	if (!request)
 		return -ENOMEM;
 
-	request->channels = (void *)((char *)request + sizeof(*request));
 	if (wdev->conn->params.channel)
 		request->channels[0] = wdev->conn->params.channel;
 	else {
@@ -82,7 +81,7 @@ static int cfg80211_conn_scan(struct wir
 		}
 	}
 	request->n_channels = n_channels;
-	request->ssids = (void *)(request->channels + n_channels);
+	request->ssids = (void *)&request->channels[n_channels];
 	request->n_ssids = 1;
 
 	memcpy(request->ssids[0].ssid, wdev->conn->params.ssid,
--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2009-08-07 17:49:05.000000000 +0200
+++ wireless-testing/net/mac80211/ieee80211_i.h	2009-08-07 17:49:06.000000000 +0200
@@ -715,7 +715,7 @@ struct ieee80211_local {
 	struct mutex scan_mtx;
 	unsigned long scanning;
 	struct cfg80211_ssid scan_ssid;
-	struct cfg80211_scan_request int_scan_req;
+	struct cfg80211_scan_request *int_scan_req;
 	struct cfg80211_scan_request *scan_req;
 	struct ieee80211_channel *scan_channel;
 	const u8 *orig_ies;
--- wireless-testing.orig/net/mac80211/main.c	2009-08-07 17:49:05.000000000 +0200
+++ wireless-testing/net/mac80211/main.c	2009-08-07 17:49:06.000000000 +0200
@@ -765,9 +765,9 @@ int ieee80211_register_hw(struct ieee802
 		supp_ht = supp_ht || sband->ht_cap.ht_supported;
 	}
 
-	local->int_scan_req.n_channels = channels;
-	local->int_scan_req.channels = kzalloc(sizeof(void *) * channels, GFP_KERNEL);
-	if (!local->int_scan_req.channels)
+	local->int_scan_req = kzalloc(sizeof(*local->int_scan_req) +
+				      sizeof(void *) * channels, GFP_KERNEL);
+	if (!local->int_scan_req)
 		return -ENOMEM;
 
 	/* if low-level driver supports AP, we also support VLAN */
@@ -882,13 +882,13 @@ int ieee80211_register_hw(struct ieee802
 
 	/* alloc internal scan request */
 	i = 0;
-	local->int_scan_req.ssids = &local->scan_ssid;
-	local->int_scan_req.n_ssids = 1;
+	local->int_scan_req->ssids = &local->scan_ssid;
+	local->int_scan_req->n_ssids = 1;
 	for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
 		if (!hw->wiphy->bands[band])
 			continue;
 		for (j = 0; j < hw->wiphy->bands[band]->n_channels; j++) {
-			local->int_scan_req.channels[i] =
+			local->int_scan_req->channels[i] =
 				&hw->wiphy->bands[band]->channels[j];
 			i++;
 		}
@@ -920,7 +920,7 @@ int ieee80211_register_hw(struct ieee802
  fail_workqueue:
 	wiphy_unregister(local->hw.wiphy);
  fail_wiphy_register:
-	kfree(local->int_scan_req.channels);
+	kfree(local->int_scan_req->channels);
 	return result;
 }
 EXPORT_SYMBOL(ieee80211_register_hw);
@@ -962,7 +962,7 @@ void ieee80211_unregister_hw(struct ieee
 	wiphy_unregister(local->hw.wiphy);
 	ieee80211_wep_free(local);
 	ieee80211_led_exit(local);
-	kfree(local->int_scan_req.channels);
+	kfree(local->int_scan_req);
 }
 EXPORT_SYMBOL(ieee80211_unregister_hw);
 
--- wireless-testing.orig/net/mac80211/scan.c	2009-08-07 17:49:05.000000000 +0200
+++ wireless-testing/net/mac80211/scan.c	2009-08-07 17:49:06.000000000 +0200
@@ -277,7 +277,7 @@ void ieee80211_scan_completed(struct iee
 	if (test_bit(SCAN_HW_SCANNING, &local->scanning))
 		ieee80211_restore_scan_ies(local);
 
-	if (local->scan_req != &local->int_scan_req)
+	if (local->scan_req != local->int_scan_req)
 		cfg80211_scan_done(local->scan_req, aborted);
 	local->scan_req = NULL;
 
@@ -423,7 +423,7 @@ static int __ieee80211_start_scan(struct
 	local->scan_req = req;
 	local->scan_sdata = sdata;
 
-	if (req != &local->int_scan_req &&
+	if (req != local->int_scan_req &&
 	    sdata->vif.type == NL80211_IFTYPE_STATION &&
 	    !list_empty(&ifmgd->work_list)) {
 		/* actually wait for the work it's doing to finish/time out */
@@ -743,10 +743,10 @@ int ieee80211_request_internal_scan(stru
 	if (local->scan_req)
 		goto unlock;
 
-	memcpy(local->int_scan_req.ssids[0].ssid, ssid, IEEE80211_MAX_SSID_LEN);
-	local->int_scan_req.ssids[0].ssid_len = ssid_len;
+	memcpy(local->int_scan_req->ssids[0].ssid, ssid, IEEE80211_MAX_SSID_LEN);
+	local->int_scan_req->ssids[0].ssid_len = ssid_len;
 
-	ret = __ieee80211_start_scan(sdata, &sdata->local->int_scan_req);
+	ret = __ieee80211_start_scan(sdata, sdata->local->int_scan_req);
  unlock:
 	mutex_unlock(&local->scan_mtx);
 	return ret;


