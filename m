Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:59222 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753215Ab3EPVDs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 May 2013 17:03:48 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 9/9] cfg80211: remove some locked wrappers from sme API
Date: Thu, 16 May 2013 23:03:38 +0200
Message-Id: <1368738218-7597-10-git-send-email-johannes@sipsolutions.net> (sfid-20130516_230356_712109_086FBA3A)
In-Reply-To: <1368738218-7597-1-git-send-email-johannes@sipsolutions.net>
References: <1368738218-7597-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

By making all the API functions require wdev locking we
can clean up the API a bit, getting rid of the locking
version of each function. This also decreases the size
of cfg80211 by a small amount.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/core.c     |  4 ++--
 net/wireless/core.h     | 11 ++---------
 net/wireless/nl80211.c  | 10 ++++++++--
 net/wireless/sme.c      | 41 +++++++----------------------------------
 net/wireless/util.c     |  2 ++
 net/wireless/wext-sme.c | 23 +++++++++++------------
 6 files changed, 32 insertions(+), 59 deletions(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index afcb9ec..ee42287 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -755,8 +755,8 @@ void cfg80211_leave(struct cfg80211_registered_device *rdev,
 		wdev->wext.ie_len = 0;
 		wdev->wext.connect.auth_type = NL80211_AUTHTYPE_AUTOMATIC;
 #endif
-		__cfg80211_disconnect(rdev, dev,
-				      WLAN_REASON_DEAUTH_LEAVING, true);
+		cfg80211_disconnect(rdev, dev,
+				    WLAN_REASON_DEAUTH_LEAVING, true);
 		wdev_unlock(wdev);
 		break;
 	case NL80211_IFTYPE_MESH_POINT:
diff --git a/net/wireless/core.h b/net/wireless/core.h
index c8f87df..b4b4a56 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -328,18 +328,11 @@ void cfg80211_oper_and_vht_capa(struct ieee80211_vht_cap *vht_capa,
 				const struct ieee80211_vht_cap *vht_capa_mask);
 
 /* SME */
-int __cfg80211_connect(struct cfg80211_registered_device *rdev,
-		       struct net_device *dev,
-		       struct cfg80211_connect_params *connect,
-		       struct cfg80211_cached_keys *connkeys,
-		       const u8 *prev_bssid);
 int cfg80211_connect(struct cfg80211_registered_device *rdev,
 		     struct net_device *dev,
 		     struct cfg80211_connect_params *connect,
-		     struct cfg80211_cached_keys *connkeys);
-int __cfg80211_disconnect(struct cfg80211_registered_device *rdev,
-			  struct net_device *dev, u16 reason,
-			  bool wextev);
+		     struct cfg80211_cached_keys *connkeys,
+		     const u8 *prev_bssid);
 int cfg80211_disconnect(struct cfg80211_registered_device *rdev,
 			struct net_device *dev, u16 reason,
 			bool wextev);
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 514a683..57ba1a6 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -6676,7 +6676,9 @@ static int nl80211_connect(struct sk_buff *skb, struct genl_info *info)
 		       sizeof(connect.vht_capa));
 	}
 
-	err = cfg80211_connect(rdev, dev, &connect, connkeys);
+	wdev_lock(dev->ieee80211_ptr);
+	err = cfg80211_connect(rdev, dev, &connect, connkeys, NULL);
+	wdev_unlock(dev->ieee80211_ptr);
 	if (err)
 		kfree(connkeys);
 	return err;
@@ -6687,6 +6689,7 @@ static int nl80211_disconnect(struct sk_buff *skb, struct genl_info *info)
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
 	struct net_device *dev = info->user_ptr[1];
 	u16 reason;
+	int ret;
 
 	if (!info->attrs[NL80211_ATTR_REASON_CODE])
 		reason = WLAN_REASON_DEAUTH_LEAVING;
@@ -6700,7 +6703,10 @@ static int nl80211_disconnect(struct sk_buff *skb, struct genl_info *info)
 	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_P2P_CLIENT)
 		return -EOPNOTSUPP;
 
-	return cfg80211_disconnect(rdev, dev, reason, true);
+	wdev_lock(dev->ieee80211_ptr);
+	ret = cfg80211_disconnect(rdev, dev, reason, true);
+	wdev_unlock(dev->ieee80211_ptr);
+	return ret;
 }
 
 static int nl80211_wiphy_netns(struct sk_buff *skb, struct genl_info *info)
diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index e167bf9..a3dba36 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -757,11 +757,11 @@ void cfg80211_disconnected(struct net_device *dev, u16 reason,
 }
 EXPORT_SYMBOL(cfg80211_disconnected);
 
-int __cfg80211_connect(struct cfg80211_registered_device *rdev,
-		       struct net_device *dev,
-		       struct cfg80211_connect_params *connect,
-		       struct cfg80211_cached_keys *connkeys,
-		       const u8 *prev_bssid)
+int cfg80211_connect(struct cfg80211_registered_device *rdev,
+		     struct net_device *dev,
+		     struct cfg80211_connect_params *connect,
+		     struct cfg80211_cached_keys *connkeys,
+		     const u8 *prev_bssid)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_bss *bss = NULL;
@@ -908,22 +908,8 @@ int __cfg80211_connect(struct cfg80211_registered_device *rdev,
 	}
 }
 
-int cfg80211_connect(struct cfg80211_registered_device *rdev,
-		     struct net_device *dev,
-		     struct cfg80211_connect_params *connect,
-		     struct cfg80211_cached_keys *connkeys)
-{
-	int err;
-
-	wdev_lock(dev->ieee80211_ptr);
-	err = __cfg80211_connect(rdev, dev, connect, connkeys, NULL);
-	wdev_unlock(dev->ieee80211_ptr);
-
-	return err;
-}
-
-int __cfg80211_disconnect(struct cfg80211_registered_device *rdev,
-			  struct net_device *dev, u16 reason, bool wextev)
+int cfg80211_disconnect(struct cfg80211_registered_device *rdev,
+			struct net_device *dev, u16 reason, bool wextev)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	int err;
@@ -980,19 +966,6 @@ int __cfg80211_disconnect(struct cfg80211_registered_device *rdev,
 	return 0;
 }
 
-int cfg80211_disconnect(struct cfg80211_registered_device *rdev,
-			struct net_device *dev,
-			u16 reason, bool wextev)
-{
-	int err;
-
-	wdev_lock(dev->ieee80211_ptr);
-	err = __cfg80211_disconnect(rdev, dev, reason, wextev);
-	wdev_unlock(dev->ieee80211_ptr);
-
-	return err;
-}
-
 void cfg80211_sme_disassoc(struct net_device *dev,
 			   struct cfg80211_internal_bss *bss)
 {
diff --git a/net/wireless/util.c b/net/wireless/util.c
index a694c61..65efc37 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -835,8 +835,10 @@ int cfg80211_change_iface(struct cfg80211_registered_device *rdev,
 			break;
 		case NL80211_IFTYPE_STATION:
 		case NL80211_IFTYPE_P2P_CLIENT:
+			wdev_lock(dev->ieee80211_ptr);
 			cfg80211_disconnect(rdev, dev,
 					    WLAN_REASON_DEAUTH_LEAVING, true);
+			wdev_unlock(dev->ieee80211_ptr);
 			break;
 		case NL80211_IFTYPE_MESH_POINT:
 			/* mesh should be handled? */
diff --git a/net/wireless/wext-sme.c b/net/wireless/wext-sme.c
index aeefd68..a53f8404 100644
--- a/net/wireless/wext-sme.c
+++ b/net/wireless/wext-sme.c
@@ -54,8 +54,8 @@ int cfg80211_mgd_wext_connect(struct cfg80211_registered_device *rdev,
 	if (wdev->wext.prev_bssid_valid)
 		prev_bssid = wdev->wext.prev_bssid;
 
-	err = __cfg80211_connect(rdev, wdev->netdev,
-				 &wdev->wext.connect, ck, prev_bssid);
+	err = cfg80211_connect(rdev, wdev->netdev,
+			       &wdev->wext.connect, ck, prev_bssid);
 	if (err)
 		kfree(ck);
 
@@ -100,8 +100,8 @@ int cfg80211_mgd_wext_siwfreq(struct net_device *dev,
 		/* if SSID set, we'll try right again, avoid event */
 		if (wdev->wext.connect.ssid_len)
 			event = false;
-		err = __cfg80211_disconnect(rdev, dev,
-					    WLAN_REASON_DEAUTH_LEAVING, event);
+		err = cfg80211_disconnect(rdev, dev,
+					  WLAN_REASON_DEAUTH_LEAVING, event);
 		if (err)
 			goto out;
 	}
@@ -199,8 +199,8 @@ int cfg80211_mgd_wext_siwessid(struct net_device *dev,
 		/* if SSID set now, we'll try to connect, avoid event */
 		if (len)
 			event = false;
-		err = __cfg80211_disconnect(rdev, dev,
-					    WLAN_REASON_DEAUTH_LEAVING, event);
+		err = cfg80211_disconnect(rdev, dev,
+					  WLAN_REASON_DEAUTH_LEAVING, event);
 		if (err)
 			goto out;
 	}
@@ -288,8 +288,8 @@ int cfg80211_mgd_wext_siwap(struct net_device *dev,
 		    ether_addr_equal(bssid, wdev->wext.connect.bssid))
 			goto out;
 
-		err = __cfg80211_disconnect(rdev, dev,
-					    WLAN_REASON_DEAUTH_LEAVING, false);
+		err = cfg80211_disconnect(rdev, dev,
+					  WLAN_REASON_DEAUTH_LEAVING, false);
 		if (err)
 			goto out;
 	}
@@ -365,8 +365,8 @@ int cfg80211_wext_siwgenie(struct net_device *dev,
 	wdev->wext.ie_len = ie_len;
 
 	if (wdev->sme_state != CFG80211_SME_IDLE) {
-		err = __cfg80211_disconnect(rdev, dev,
-					    WLAN_REASON_DEAUTH_LEAVING, false);
+		err = cfg80211_disconnect(rdev, dev,
+					  WLAN_REASON_DEAUTH_LEAVING, false);
 		if (err)
 			goto out;
 	}
@@ -402,8 +402,7 @@ int cfg80211_wext_siwmlme(struct net_device *dev,
 	switch (mlme->cmd) {
 	case IW_MLME_DEAUTH:
 	case IW_MLME_DISASSOC:
-		err = __cfg80211_disconnect(rdev, dev, mlme->reason_code,
-					    true);
+		err = cfg80211_disconnect(rdev, dev, mlme->reason_code, true);
 		break;
 	default:
 		err = -EOPNOTSUPP;
-- 
1.8.0

