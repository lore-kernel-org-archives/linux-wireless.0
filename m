Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:51665 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752629Ab3E0JLI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 May 2013 05:11:08 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 1/2] cfg80211/mac80211: clean up cfg80211 SME APIs
Date: Mon, 27 May 2013 11:11:01 +0200
Message-Id: <1369645862-29054-2-git-send-email-johannes@sipsolutions.net> (sfid-20130527_111113_946240_19FB717E)
In-Reply-To: <1369645862-29054-1-git-send-email-johannes@sipsolutions.net>
References: <1369645862-29054-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Do some cleanups in the cfg80211 SME APIs, which are
only used by mac80211.

Most of these functions get a frame passed, and there
isn't really any reason to export multiple functions
as cfg80211 can check the frame type instead, do that.

Additionally, the API functions have confusing names
like cfg80211_send_...() which was meant to indicate
that it sends an event to userspace, but gets a bit
confusing when there's both TX and RX and they're not
all clearly labeled.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/cfg80211.h | 91 ++++++++++++++++++++------------------------------
 net/mac80211/mlme.c    | 44 ++++++++++++------------
 net/mac80211/rx.c      | 26 ++++++---------
 net/wireless/mlme.c    | 86 +++++++++++++++++++++++++++++------------------
 net/wireless/nl80211.c | 30 ++++++++---------
 net/wireless/trace.h   | 46 ++++++++++++++++++-------
 6 files changed, 170 insertions(+), 153 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 9f45d74..cba6c5b 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -3427,59 +3427,66 @@ void cfg80211_put_bss(struct wiphy *wiphy, struct cfg80211_bss *bss);
 void cfg80211_unlink_bss(struct wiphy *wiphy, struct cfg80211_bss *bss);
 
 /**
- * cfg80211_send_rx_auth - notification of processed authentication
+ * cfg80211_rx_mlme_mgmt - notification of processed MLME management frame
  * @dev: network device
  * @buf: authentication frame (header + body)
  * @len: length of the frame data
  *
- * This function is called whenever an authentication has been processed in
- * station mode. The driver is required to call either this function or
- * cfg80211_send_auth_timeout() to indicate the result of cfg80211_ops::auth()
- * call. This function may sleep. The caller must hold the corresponding wdev's
- * mutex.
+ * This function is called whenever an authentication, disassociation or
+ * deauthentication frame has been received and processed in station mode.
+ * After being asked to authenticate via cfg80211_ops::auth() the driver must
+ * call either this function or cfg80211_auth_timeout().
+ * After being asked to associate via cfg80211_ops::assoc() the driver must
+ * call either this function or cfg80211_auth_timeout().
+ * While connected, the driver must calls this for received and processed
+ * disassociation and deauthentication frames. If the frame couldn't be used
+ * because it was unprotected, the driver must call the function
+ * cfg80211_rx_unprot_mlme_mgmt() instead.
+ *
+ * This function may sleep. The caller must hold the corresponding wdev's mutex.
  */
-void cfg80211_send_rx_auth(struct net_device *dev, const u8 *buf, size_t len);
+void cfg80211_rx_mlme_mgmt(struct net_device *dev, const u8 *buf, size_t len);
 
 /**
- * cfg80211_send_auth_timeout - notification of timed out authentication
+ * cfg80211_auth_timeout - notification of timed out authentication
  * @dev: network device
  * @addr: The MAC address of the device with which the authentication timed out
  *
  * This function may sleep. The caller must hold the corresponding wdev's
  * mutex.
  */
-void cfg80211_send_auth_timeout(struct net_device *dev, const u8 *addr);
+void cfg80211_auth_timeout(struct net_device *dev, const u8 *addr);
 
 /**
- * cfg80211_send_rx_assoc - notification of processed association
+ * cfg80211_rx_assoc_resp - notification of processed association response
  * @dev: network device
- * @bss: the BSS struct association was requested for, the struct reference
- *	is owned by cfg80211 after this call
- * @buf: (re)association response frame (header + body)
+ * @bss: the BSS that association was requested with, ownership of the pointer
+ *	moves to cfg80211 in this call
+ * @buf: authentication frame (header + body)
  * @len: length of the frame data
  *
- * This function is called whenever a (re)association response has been
- * processed in station mode. The driver is required to call either this
- * function or cfg80211_send_assoc_timeout() to indicate the result of
- * cfg80211_ops::assoc() call. This function may sleep. The caller must hold
- * the corresponding wdev's mutex.
+ * After being asked to associate via cfg80211_ops::assoc() the driver must
+ * call either this function or cfg80211_auth_timeout().
+ *
+ * This function may sleep. The caller must hold the corresponding wdev's mutex.
  */
-void cfg80211_send_rx_assoc(struct net_device *dev, struct cfg80211_bss *bss,
+void cfg80211_rx_assoc_resp(struct net_device *dev,
+			    struct cfg80211_bss *bss,
 			    const u8 *buf, size_t len);
 
 /**
- * cfg80211_send_assoc_timeout - notification of timed out association
+ * cfg80211_assoc_timeout - notification of timed out association
  * @dev: network device
  * @addr: The MAC address of the device with which the association timed out
  *
  * This function may sleep. The caller must hold the corresponding wdev's mutex.
  */
-void cfg80211_send_assoc_timeout(struct net_device *dev, const u8 *addr);
+void cfg80211_assoc_timeout(struct net_device *dev, const u8 *addr);
 
 /**
- * cfg80211_send_deauth - notification of processed deauthentication
+ * cfg80211_tx_mlme_mgmt - notification of transmitted deauth/disassoc frame
  * @dev: network device
- * @buf: deauthentication frame (header + body)
+ * @buf: 802.11 frame (header + body)
  * @len: length of the frame data
  *
  * This function is called whenever deauthentication has been processed in
@@ -3487,46 +3494,20 @@ void cfg80211_send_assoc_timeout(struct net_device *dev, const u8 *addr);
  * locally generated ones. This function may sleep. The caller must hold the
  * corresponding wdev's mutex.
  */
-void cfg80211_send_deauth(struct net_device *dev, const u8 *buf, size_t len);
+void cfg80211_tx_mlme_mgmt(struct net_device *dev, const u8 *buf, size_t len);
 
 /**
- * cfg80211_send_disassoc - notification of processed disassociation
- * @dev: network device
- * @buf: disassociation response frame (header + body)
- * @len: length of the frame data
- *
- * This function is called whenever disassociation has been processed in
- * station mode. This includes both received disassociation frames and locally
- * generated ones. This function may sleep. The caller must hold the
- * corresponding wdev's mutex.
- */
-void cfg80211_send_disassoc(struct net_device *dev, const u8 *buf, size_t len);
-
-/**
- * cfg80211_send_unprot_deauth - notification of unprotected deauthentication
+ * cfg80211_rx_unprot_mlme_mgmt - notification of unprotected mlme mgmt frame
  * @dev: network device
  * @buf: deauthentication frame (header + body)
  * @len: length of the frame data
  *
- * This function is called whenever a received Deauthentication frame has been
- * dropped in station mode because of MFP being used but the Deauthentication
- * frame was not protected. This function may sleep.
- */
-void cfg80211_send_unprot_deauth(struct net_device *dev, const u8 *buf,
-				 size_t len);
-
-/**
- * cfg80211_send_unprot_disassoc - notification of unprotected disassociation
- * @dev: network device
- * @buf: disassociation frame (header + body)
- * @len: length of the frame data
- *
- * This function is called whenever a received Disassociation frame has been
- * dropped in station mode because of MFP being used but the Disassociation
+ * This function is called whenever a received deauthentication or dissassoc
+ * frame has been dropped in station mode because of MFP being used but the
  * frame was not protected. This function may sleep.
  */
-void cfg80211_send_unprot_disassoc(struct net_device *dev, const u8 *buf,
-				   size_t len);
+void cfg80211_rx_unprot_mlme_mgmt(struct net_device *dev,
+				  const u8 *buf, size_t len);
 
 /**
  * cfg80211_michael_mic_failure - notification of Michael MIC failure (TKIP)
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index f44f4ca..42f03ae 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2151,7 +2151,8 @@ static void __ieee80211_disconnect(struct ieee80211_sub_if_data *sdata)
 					IEEE80211_MAX_QUEUE_MAP,
 					IEEE80211_QUEUE_STOP_REASON_CSA);
 
-	cfg80211_send_deauth(sdata->dev, frame_buf, IEEE80211_DEAUTH_FRAME_LEN);
+	cfg80211_tx_mlme_mgmt(sdata->dev, frame_buf,
+			      IEEE80211_DEAUTH_FRAME_LEN);
 	sdata_unlock(sdata);
 }
 
@@ -2298,7 +2299,7 @@ static void ieee80211_rx_mgmt_auth(struct ieee80211_sub_if_data *sdata,
 		sdata_info(sdata, "%pM denied authentication (status %d)\n",
 			   mgmt->sa, status_code);
 		ieee80211_destroy_auth_data(sdata, false);
-		cfg80211_send_rx_auth(sdata->dev, (u8 *)mgmt, len);
+		cfg80211_rx_mlme_mgmt(sdata->dev, (u8 *)mgmt, len);
 		return;
 	}
 
@@ -2333,7 +2334,7 @@ static void ieee80211_rx_mgmt_auth(struct ieee80211_sub_if_data *sdata,
 		 * Report auth frame to user space for processing since another
 		 * round of Authentication frames is still needed.
 		 */
-		cfg80211_send_rx_auth(sdata->dev, (u8 *)mgmt, len);
+		cfg80211_rx_mlme_mgmt(sdata->dev, (u8 *)mgmt, len);
 		return;
 	}
 
@@ -2350,7 +2351,7 @@ static void ieee80211_rx_mgmt_auth(struct ieee80211_sub_if_data *sdata,
 	}
 	mutex_unlock(&sdata->local->sta_mtx);
 
-	cfg80211_send_rx_auth(sdata->dev, (u8 *)mgmt, len);
+	cfg80211_rx_mlme_mgmt(sdata->dev, (u8 *)mgmt, len);
 	return;
  out_err:
 	mutex_unlock(&sdata->local->sta_mtx);
@@ -2383,7 +2384,7 @@ static void ieee80211_rx_mgmt_deauth(struct ieee80211_sub_if_data *sdata,
 
 	ieee80211_set_disassoc(sdata, 0, 0, false, NULL);
 
-	cfg80211_send_deauth(sdata->dev, (u8 *)mgmt, len);
+	cfg80211_rx_mlme_mgmt(sdata->dev, (u8 *)mgmt, len);
 }
 
 
@@ -2409,7 +2410,7 @@ static void ieee80211_rx_mgmt_disassoc(struct ieee80211_sub_if_data *sdata,
 
 	ieee80211_set_disassoc(sdata, 0, 0, false, NULL);
 
-	cfg80211_send_disassoc(sdata->dev, (u8 *)mgmt, len);
+	cfg80211_rx_mlme_mgmt(sdata->dev, (u8 *)mgmt, len);
 }
 
 static void ieee80211_get_rates(struct ieee80211_supported_band *sband,
@@ -2707,7 +2708,7 @@ static void ieee80211_rx_mgmt_assoc_resp(struct ieee80211_sub_if_data *sdata,
 			/* oops -- internal error -- send timeout for now */
 			ieee80211_destroy_assoc_data(sdata, false);
 			cfg80211_put_bss(sdata->local->hw.wiphy, bss);
-			cfg80211_send_assoc_timeout(sdata->dev, mgmt->bssid);
+			cfg80211_assoc_timeout(sdata->dev, mgmt->bssid);
 			return;
 		}
 		sdata_info(sdata, "associated\n");
@@ -2720,7 +2721,7 @@ static void ieee80211_rx_mgmt_assoc_resp(struct ieee80211_sub_if_data *sdata,
 		ieee80211_destroy_assoc_data(sdata, true);
 	}
 
-	cfg80211_send_rx_assoc(sdata->dev, bss, (u8 *)mgmt, len);
+	cfg80211_rx_assoc_resp(sdata->dev, bss, (u8 *)mgmt, len);
 }
 
 static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
@@ -3113,8 +3114,8 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 		ieee80211_set_disassoc(sdata, IEEE80211_STYPE_DEAUTH,
 				       WLAN_REASON_DEAUTH_LEAVING,
 				       true, deauth_buf);
-		cfg80211_send_deauth(sdata->dev, deauth_buf,
-				     sizeof(deauth_buf));
+		cfg80211_tx_mlme_mgmt(sdata->dev, deauth_buf,
+				      sizeof(deauth_buf));
 		return;
 	}
 
@@ -3232,7 +3233,8 @@ static void ieee80211_sta_connection_lost(struct ieee80211_sub_if_data *sdata,
 	ieee80211_set_disassoc(sdata, IEEE80211_STYPE_DEAUTH, reason,
 			       tx, frame_buf);
 
-	cfg80211_send_deauth(sdata->dev, frame_buf, IEEE80211_DEAUTH_FRAME_LEN);
+	cfg80211_tx_mlme_mgmt(sdata->dev, frame_buf,
+			      IEEE80211_DEAUTH_FRAME_LEN);
 }
 
 static int ieee80211_probe_auth(struct ieee80211_sub_if_data *sdata)
@@ -3423,7 +3425,7 @@ void ieee80211_sta_work(struct ieee80211_sub_if_data *sdata)
 
 			ieee80211_destroy_auth_data(sdata, false);
 
-			cfg80211_send_auth_timeout(sdata->dev, bssid);
+			cfg80211_auth_timeout(sdata->dev, bssid);
 		}
 	} else if (ifmgd->auth_data && ifmgd->auth_data->timeout_started)
 		run_again(sdata, ifmgd->auth_data->timeout);
@@ -3439,7 +3441,7 @@ void ieee80211_sta_work(struct ieee80211_sub_if_data *sdata)
 
 			ieee80211_destroy_assoc_data(sdata, false);
 
-			cfg80211_send_assoc_timeout(sdata->dev, bssid);
+			cfg80211_assoc_timeout(sdata->dev, bssid);
 		}
 	} else if (ifmgd->assoc_data && ifmgd->assoc_data->timeout_started)
 		run_again(sdata, ifmgd->assoc_data->timeout);
@@ -3988,8 +3990,8 @@ int ieee80211_mgd_auth(struct ieee80211_sub_if_data *sdata,
 				       WLAN_REASON_UNSPECIFIED,
 				       false, frame_buf);
 
-		cfg80211_send_deauth(sdata->dev, frame_buf,
-				     sizeof(frame_buf));
+		cfg80211_tx_mlme_mgmt(sdata->dev, frame_buf,
+				      sizeof(frame_buf));
 	}
 
 	sdata_info(sdata, "authenticate with %pM\n", req->bss->bssid);
@@ -4051,8 +4053,8 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 				       WLAN_REASON_UNSPECIFIED,
 				       false, frame_buf);
 
-		cfg80211_send_deauth(sdata->dev, frame_buf,
-				     sizeof(frame_buf));
+		cfg80211_tx_mlme_mgmt(sdata->dev, frame_buf,
+				      sizeof(frame_buf));
 	}
 
 	if (ifmgd->auth_data && !ifmgd->auth_data->done) {
@@ -4305,8 +4307,8 @@ int ieee80211_mgd_deauth(struct ieee80211_sub_if_data *sdata,
 
  out:
 	if (report_frame)
-		cfg80211_send_deauth(sdata->dev, frame_buf,
-				     IEEE80211_DEAUTH_FRAME_LEN);
+		cfg80211_tx_mlme_mgmt(sdata->dev, frame_buf,
+				      IEEE80211_DEAUTH_FRAME_LEN);
 
 	return 0;
 }
@@ -4336,8 +4338,8 @@ int ieee80211_mgd_disassoc(struct ieee80211_sub_if_data *sdata,
 			       req->reason_code, !req->local_state_change,
 			       frame_buf);
 
-	cfg80211_send_disassoc(sdata->dev, frame_buf,
-			       IEEE80211_DEAUTH_FRAME_LEN);
+	cfg80211_tx_mlme_mgmt(sdata->dev, frame_buf,
+			      IEEE80211_DEAUTH_FRAME_LEN);
 
 	return 0;
 }
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index bdd7b4a..23dbcfc 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1747,27 +1747,21 @@ static int ieee80211_drop_unencrypted_mgmt(struct ieee80211_rx_data *rx)
 		if (unlikely(!ieee80211_has_protected(fc) &&
 			     ieee80211_is_unicast_robust_mgmt_frame(rx->skb) &&
 			     rx->key)) {
-			if (ieee80211_is_deauth(fc))
-				cfg80211_send_unprot_deauth(rx->sdata->dev,
-							    rx->skb->data,
-							    rx->skb->len);
-			else if (ieee80211_is_disassoc(fc))
-				cfg80211_send_unprot_disassoc(rx->sdata->dev,
-							      rx->skb->data,
-							      rx->skb->len);
+			if (ieee80211_is_deauth(fc) ||
+			    ieee80211_is_disassoc(fc))
+				cfg80211_rx_unprot_mlme_mgmt(rx->sdata->dev,
+							     rx->skb->data,
+							     rx->skb->len);
 			return -EACCES;
 		}
 		/* BIP does not use Protected field, so need to check MMIE */
 		if (unlikely(ieee80211_is_multicast_robust_mgmt_frame(rx->skb) &&
 			     ieee80211_get_mmie_keyidx(rx->skb) < 0)) {
-			if (ieee80211_is_deauth(fc))
-				cfg80211_send_unprot_deauth(rx->sdata->dev,
-							    rx->skb->data,
-							    rx->skb->len);
-			else if (ieee80211_is_disassoc(fc))
-				cfg80211_send_unprot_disassoc(rx->sdata->dev,
-							      rx->skb->data,
-							      rx->skb->len);
+			if (ieee80211_is_deauth(fc) ||
+			    ieee80211_is_disassoc(fc))
+				cfg80211_rx_unprot_mlme_mgmt(rx->sdata->dev,
+							     rx->skb->data,
+							     rx->skb->len);
 			return -EACCES;
 		}
 		/*
diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index 7bde5d9..4b9c2be 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -18,20 +18,7 @@
 #include "rdev-ops.h"
 
 
-void cfg80211_send_rx_auth(struct net_device *dev, const u8 *buf, size_t len)
-{
-	struct wireless_dev *wdev = dev->ieee80211_ptr;
-	struct wiphy *wiphy = wdev->wiphy;
-	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
-
-	trace_cfg80211_send_rx_auth(dev);
-
-	nl80211_send_rx_auth(rdev, dev, buf, len, GFP_KERNEL);
-	cfg80211_sme_rx_auth(dev, buf, len);
-}
-EXPORT_SYMBOL(cfg80211_send_rx_auth);
-
-void cfg80211_send_rx_assoc(struct net_device *dev, struct cfg80211_bss *bss,
+void cfg80211_rx_assoc_resp(struct net_device *dev, struct cfg80211_bss *bss,
 			    const u8 *buf, size_t len)
 {
 	u16 status_code;
@@ -84,10 +71,10 @@ void cfg80211_send_rx_assoc(struct net_device *dev, struct cfg80211_bss *bss,
 				  status_code,
 				  status_code == WLAN_STATUS_SUCCESS, bss);
 }
-EXPORT_SYMBOL(cfg80211_send_rx_assoc);
+EXPORT_SYMBOL(cfg80211_rx_assoc_resp);
 
-void cfg80211_send_deauth(struct net_device *dev,
-			  const u8 *buf, size_t len)
+static void cfg80211_process_deauth(struct net_device *dev,
+				    const u8 *buf, size_t len)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct wiphy *wiphy = wdev->wiphy;
@@ -96,9 +83,6 @@ void cfg80211_send_deauth(struct net_device *dev,
 	const u8 *bssid = mgmt->bssid;
 	bool was_current = false;
 
-	trace_cfg80211_send_deauth(dev);
-	ASSERT_WDEV_LOCK(wdev);
-
 	if (wdev->current_bss &&
 	    ether_addr_equal(wdev->current_bss->pub.bssid, bssid)) {
 		cfg80211_unhold_bss(wdev->current_bss);
@@ -123,10 +107,9 @@ void cfg80211_send_deauth(struct net_device *dev,
 					  false, NULL);
 	}
 }
-EXPORT_SYMBOL(cfg80211_send_deauth);
 
-void cfg80211_send_disassoc(struct net_device *dev,
-			    const u8 *buf, size_t len)
+static void cfg80211_process_disassoc(struct net_device *dev,
+				      const u8 *buf, size_t len)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct wiphy *wiphy = wdev->wiphy;
@@ -136,9 +119,6 @@ void cfg80211_send_disassoc(struct net_device *dev,
 	u16 reason_code;
 	bool from_ap;
 
-	trace_cfg80211_send_disassoc(dev);
-	ASSERT_WDEV_LOCK(wdev);
-
 	nl80211_send_disassoc(rdev, dev, buf, len, GFP_KERNEL);
 
 	if (wdev->sme_state != CFG80211_SME_CONNECTED)
@@ -153,15 +133,38 @@ void cfg80211_send_disassoc(struct net_device *dev,
 	} else
 		WARN_ON(1);
 
-
 	reason_code = le16_to_cpu(mgmt->u.disassoc.reason_code);
 
 	from_ap = !ether_addr_equal(mgmt->sa, dev->dev_addr);
 	__cfg80211_disconnected(dev, NULL, 0, reason_code, from_ap);
 }
-EXPORT_SYMBOL(cfg80211_send_disassoc);
 
-void cfg80211_send_auth_timeout(struct net_device *dev, const u8 *addr)
+void cfg80211_rx_mlme_mgmt(struct net_device *dev, const u8 *buf, size_t len)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct wiphy *wiphy = wdev->wiphy;
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
+	struct ieee80211_mgmt *mgmt = (void *)buf;
+
+	ASSERT_WDEV_LOCK(wdev);
+
+	trace_cfg80211_rx_mlme_mgmt(dev, buf, len);
+
+	if (WARN_ON(len < 2))
+		return;
+
+	if (ieee80211_is_auth(mgmt->frame_control)) {
+		nl80211_send_rx_auth(rdev, dev, buf, len, GFP_KERNEL);
+		cfg80211_sme_rx_auth(dev, buf, len);
+	} else if (ieee80211_is_deauth(mgmt->frame_control)) {
+		cfg80211_process_deauth(dev, buf, len);
+	} else if (ieee80211_is_disassoc(mgmt->frame_control)) {
+		cfg80211_process_disassoc(dev, buf, len);
+	}
+}
+EXPORT_SYMBOL(cfg80211_rx_mlme_mgmt);
+
+void cfg80211_auth_timeout(struct net_device *dev, const u8 *addr)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct wiphy *wiphy = wdev->wiphy;
@@ -175,9 +178,9 @@ void cfg80211_send_auth_timeout(struct net_device *dev, const u8 *addr)
 					  WLAN_STATUS_UNSPECIFIED_FAILURE,
 					  false, NULL);
 }
-EXPORT_SYMBOL(cfg80211_send_auth_timeout);
+EXPORT_SYMBOL(cfg80211_auth_timeout);
 
-void cfg80211_send_assoc_timeout(struct net_device *dev, const u8 *addr)
+void cfg80211_assoc_timeout(struct net_device *dev, const u8 *addr)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct wiphy *wiphy = wdev->wiphy;
@@ -191,7 +194,26 @@ void cfg80211_send_assoc_timeout(struct net_device *dev, const u8 *addr)
 					  WLAN_STATUS_UNSPECIFIED_FAILURE,
 					  false, NULL);
 }
-EXPORT_SYMBOL(cfg80211_send_assoc_timeout);
+EXPORT_SYMBOL(cfg80211_assoc_timeout);
+
+void cfg80211_tx_mlme_mgmt(struct net_device *dev, const u8 *buf, size_t len)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct ieee80211_mgmt *mgmt = (void *)buf;
+
+	ASSERT_WDEV_LOCK(wdev);
+
+	trace_cfg80211_tx_mlme_mgmt(dev, buf, len);
+
+	if (WARN_ON(len < 2))
+		return;
+
+	if (ieee80211_is_deauth(mgmt->frame_control))
+		cfg80211_process_deauth(dev, buf, len);
+	else
+		cfg80211_process_disassoc(dev, buf, len);
+}
+EXPORT_SYMBOL(cfg80211_tx_mlme_mgmt);
 
 void cfg80211_michael_mic_failure(struct net_device *dev, const u8 *addr,
 				  enum nl80211_key_type key_type, int key_id,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index a09f36b..afce10f 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -9302,31 +9302,27 @@ void nl80211_send_disassoc(struct cfg80211_registered_device *rdev,
 				NL80211_CMD_DISASSOCIATE, gfp);
 }
 
-void cfg80211_send_unprot_deauth(struct net_device *dev, const u8 *buf,
-				 size_t len)
+void cfg80211_rx_unprot_mlme_mgmt(struct net_device *dev, const u8 *buf,
+				  size_t len)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct wiphy *wiphy = wdev->wiphy;
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
+	const struct ieee80211_mgmt *mgmt = (void *)buf;
+	u32 cmd;
 
-	trace_cfg80211_send_unprot_deauth(dev);
-	nl80211_send_mlme_event(rdev, dev, buf, len,
-				NL80211_CMD_UNPROT_DEAUTHENTICATE, GFP_ATOMIC);
-}
-EXPORT_SYMBOL(cfg80211_send_unprot_deauth);
+	if (WARN_ON(len < 2))
+		return;
 
-void cfg80211_send_unprot_disassoc(struct net_device *dev, const u8 *buf,
-				   size_t len)
-{
-	struct wireless_dev *wdev = dev->ieee80211_ptr;
-	struct wiphy *wiphy = wdev->wiphy;
-	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
+	if (ieee80211_is_deauth(mgmt->frame_control))
+		cmd = NL80211_CMD_UNPROT_DEAUTHENTICATE;
+	else
+		cmd = NL80211_CMD_UNPROT_DISASSOCIATE;
 
-	trace_cfg80211_send_unprot_disassoc(dev);
-	nl80211_send_mlme_event(rdev, dev, buf, len,
-				NL80211_CMD_UNPROT_DISASSOCIATE, GFP_ATOMIC);
+	trace_cfg80211_rx_unprot_mlme_mgmt(dev, buf, len);
+	nl80211_send_mlme_event(rdev, dev, buf, len, cmd, GFP_ATOMIC);
 }
-EXPORT_SYMBOL(cfg80211_send_unprot_disassoc);
+EXPORT_SYMBOL(cfg80211_rx_unprot_mlme_mgmt);
 
 static void nl80211_send_mlme_timeout(struct cfg80211_registered_device *rdev,
 				      struct net_device *netdev, int cmd,
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index 23fafea..e1534baf 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -1911,24 +1911,46 @@ TRACE_EVENT(cfg80211_send_rx_assoc,
 		  NETDEV_PR_ARG, MAC_PR_ARG(bssid), CHAN_PR_ARG)
 );
 
-DEFINE_EVENT(netdev_evt_only, cfg80211_send_deauth,
-	TP_PROTO(struct net_device *netdev),
-	TP_ARGS(netdev)
+DECLARE_EVENT_CLASS(netdev_frame_event,
+	TP_PROTO(struct net_device *netdev, const u8 *buf, int len),
+	TP_ARGS(netdev, buf, len),
+	TP_STRUCT__entry(
+		NETDEV_ENTRY
+		__dynamic_array(u8, frame, len)
+	),
+	TP_fast_assign(
+		NETDEV_ASSIGN;
+		memcpy(__get_dynamic_array(frame), buf, len);
+	),
+	TP_printk(NETDEV_PR_FMT ", ftype:0x%.2x",
+		  NETDEV_PR_ARG,
+		  le16_to_cpup((__le16 *)__get_dynamic_array(frame)))
 );
 
-DEFINE_EVENT(netdev_evt_only, cfg80211_send_disassoc,
-	TP_PROTO(struct net_device *netdev),
-	TP_ARGS(netdev)
+DEFINE_EVENT(netdev_frame_event, cfg80211_rx_unprot_mlme_mgmt,
+	TP_PROTO(struct net_device *netdev, const u8 *buf, int len),
+	TP_ARGS(netdev, buf, len)
 );
 
-DEFINE_EVENT(netdev_evt_only, cfg80211_send_unprot_deauth,
-	TP_PROTO(struct net_device *netdev),
-	TP_ARGS(netdev)
+DEFINE_EVENT(netdev_frame_event, cfg80211_rx_mlme_mgmt,
+	TP_PROTO(struct net_device *netdev, const u8 *buf, int len),
+	TP_ARGS(netdev, buf, len)
 );
 
-DEFINE_EVENT(netdev_evt_only, cfg80211_send_unprot_disassoc,
-	TP_PROTO(struct net_device *netdev),
-	TP_ARGS(netdev)
+TRACE_EVENT(cfg80211_tx_mlme_mgmt,
+	TP_PROTO(struct net_device *netdev, const u8 *buf, int len),
+	TP_ARGS(netdev, buf, len),
+	TP_STRUCT__entry(
+		NETDEV_ENTRY
+		__dynamic_array(u8, frame, len)
+	),
+	TP_fast_assign(
+		NETDEV_ASSIGN;
+		memcpy(__get_dynamic_array(frame), buf, len);
+	),
+	TP_printk(NETDEV_PR_FMT ", ftype:0x%.2x",
+		  NETDEV_PR_ARG,
+		  le16_to_cpup((__le16 *)__get_dynamic_array(frame)))
 );
 
 DECLARE_EVENT_CLASS(netdev_mac_evt,
-- 
1.8.0

