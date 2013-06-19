Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:43277 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756639Ab3FSNxr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Jun 2013 09:53:47 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 1/2] cfg80211: require passing BSS struct back to cfg80211_assoc_timeout
Date: Wed, 19 Jun 2013 15:53:36 +0200
Message-Id: <1371650017-14293-1-git-send-email-johannes@sipsolutions.net> (sfid-20130619_155405_104292_D5B25261)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Doing so will allow us to hold the BSS (not just ref it) over the
association process, thus ensuring that it doesn't time out and
gets invisible to the user (e.g. in 'iw wlan0 link'.)

This also fixes a leak in mac80211 where it doesn't always release
the BSS struct properly in all cases where calling this function.
This leak was reported by Ben Greear.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/cfg80211.h | 16 ++++++++--------
 net/mac80211/mlme.c    | 15 +++++++--------
 net/wireless/mlme.c    |  8 +++++---
 3 files changed, 20 insertions(+), 19 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index e3a39fc..7b0730a 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1459,7 +1459,8 @@ const u8 *ieee80211_bss_get_ie(struct cfg80211_bss *bss, u8 ie);
  * This structure provides information needed to complete IEEE 802.11
  * authentication.
  *
- * @bss: The BSS to authenticate with.
+ * @bss: The BSS to authenticate with, the callee must obtain a reference
+ *	to it if it needs to keep it.
  * @auth_type: Authentication type (algorithm)
  * @ie: Extra IEs to add to Authentication frame or %NULL
  * @ie_len: Length of ie buffer in octets
@@ -1497,11 +1498,10 @@ enum cfg80211_assoc_req_flags {
  *
  * This structure provides information needed to complete IEEE 802.11
  * (re)association.
- * @bss: The BSS to associate with. If the call is successful the driver
- *	is given a reference that it must release, normally via a call to
- *	cfg80211_send_rx_assoc(), or, if association timed out, with a
- *	call to cfg80211_put_bss() (in addition to calling
- *	cfg80211_send_assoc_timeout())
+ * @bss: The BSS to associate with. If the call is successful the driver is
+ *	given a reference that it must give back to cfg80211_send_rx_assoc()
+ *	or to cfg80211_assoc_timeout(). To ensure proper refcounting, new
+ *	association requests while already associating must be rejected.
  * @ie: Extra IEs to add to (Re)Association Request frame or %NULL
  * @ie_len: Length of ie buffer in octets
  * @use_mfp: Use management frame protection (IEEE 802.11w) in this association
@@ -3522,11 +3522,11 @@ void cfg80211_rx_assoc_resp(struct net_device *dev,
 /**
  * cfg80211_assoc_timeout - notification of timed out association
  * @dev: network device
- * @addr: The MAC address of the device with which the association timed out
+ * @bss: The BSS entry with which association timed out.
  *
  * This function may sleep. The caller must hold the corresponding wdev's mutex.
  */
-void cfg80211_assoc_timeout(struct net_device *dev, const u8 *addr);
+void cfg80211_assoc_timeout(struct net_device *dev, struct cfg80211_bss *bss);
 
 /**
  * cfg80211_tx_mlme_mgmt - notification of transmitted deauth/disassoc frame
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index e0939eb..08b3e71 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2722,8 +2722,7 @@ static void ieee80211_rx_mgmt_assoc_resp(struct ieee80211_sub_if_data *sdata,
 		if (!ieee80211_assoc_success(sdata, bss, mgmt, len)) {
 			/* oops -- internal error -- send timeout for now */
 			ieee80211_destroy_assoc_data(sdata, false);
-			cfg80211_put_bss(sdata->local->hw.wiphy, bss);
-			cfg80211_assoc_timeout(sdata->dev, mgmt->bssid);
+			cfg80211_assoc_timeout(sdata->dev, bss);
 			return;
 		}
 		sdata_info(sdata, "associated\n");
@@ -3440,13 +3439,10 @@ void ieee80211_sta_work(struct ieee80211_sub_if_data *sdata)
 	    time_after(jiffies, ifmgd->assoc_data->timeout)) {
 		if ((ifmgd->assoc_data->need_beacon && !ifmgd->have_beacon) ||
 		    ieee80211_do_assoc(sdata)) {
-			u8 bssid[ETH_ALEN];
-
-			memcpy(bssid, ifmgd->assoc_data->bss->bssid, ETH_ALEN);
+			struct cfg80211_bss *bss = ifmgd->assoc_data->bss;
 
 			ieee80211_destroy_assoc_data(sdata, false);
-
-			cfg80211_assoc_timeout(sdata->dev, bssid);
+			cfg80211_assoc_timeout(sdata->dev, bss);
 		}
 	} else if (ifmgd->assoc_data && ifmgd->assoc_data->timeout_started)
 		run_again(sdata, ifmgd->assoc_data->timeout);
@@ -4372,8 +4368,11 @@ void ieee80211_mgd_stop(struct ieee80211_sub_if_data *sdata)
 	cancel_work_sync(&ifmgd->chswitch_work);
 
 	sdata_lock(sdata);
-	if (ifmgd->assoc_data)
+	if (ifmgd->assoc_data) {
+		struct cfg80211_bss *bss = ifmgd->assoc_data->bss;
 		ieee80211_destroy_assoc_data(sdata, false);
+		cfg80211_assoc_timeout(sdata->dev, bss);
+	}
 	if (ifmgd->auth_data)
 		ieee80211_destroy_auth_data(sdata, false);
 	del_timer_sync(&ifmgd->timer);
diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index a61a44b..dd6f79d 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -131,16 +131,18 @@ void cfg80211_auth_timeout(struct net_device *dev, const u8 *addr)
 }
 EXPORT_SYMBOL(cfg80211_auth_timeout);
 
-void cfg80211_assoc_timeout(struct net_device *dev, const u8 *addr)
+void cfg80211_assoc_timeout(struct net_device *dev, struct cfg80211_bss *bss)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct wiphy *wiphy = wdev->wiphy;
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
 
-	trace_cfg80211_send_assoc_timeout(dev, addr);
+	trace_cfg80211_send_assoc_timeout(dev, bss->bssid);
 
-	nl80211_send_assoc_timeout(rdev, dev, addr, GFP_KERNEL);
+	nl80211_send_assoc_timeout(rdev, dev, bss->bssid, GFP_KERNEL);
 	cfg80211_sme_assoc_timeout(wdev);
+
+	cfg80211_put_bss(wiphy, bss);
 }
 EXPORT_SYMBOL(cfg80211_assoc_timeout);
 
-- 
1.8.0

