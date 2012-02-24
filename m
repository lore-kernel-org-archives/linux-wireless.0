Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60439 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754675Ab2BXMwN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Feb 2012 07:52:13 -0500
Message-Id: <20120224125138.609741071@sipsolutions.net> (sfid-20120224_135226_098354_858388F6)
Date: Fri, 24 Feb 2012 13:50:51 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 1/4] cfg80211: remove cookies from callbacks
References: <20120224125050.809601111@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

In "cfg80211: no cookies in cfg80211_send_XXX()"
Holger Schurig removed the cookies in the calls
from mac80211 to cfg80211, but the ones in the
other direction were left in. Remove them now.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/cfg80211.h     |    6 ++----
 net/mac80211/cfg.c         |   12 ++++--------
 net/mac80211/ieee80211_i.h |    6 ++----
 net/mac80211/mlme.c        |   28 ++++++++++++++--------------
 net/wireless/mlme.c        |    6 +++---
 5 files changed, 25 insertions(+), 33 deletions(-)

--- a/include/net/cfg80211.h	2012-02-24 13:48:35.000000000 +0100
+++ b/include/net/cfg80211.h	2012-02-24 13:50:18.000000000 +0100
@@ -1587,11 +1587,9 @@ struct cfg80211_ops {
 	int	(*assoc)(struct wiphy *wiphy, struct net_device *dev,
 			 struct cfg80211_assoc_request *req);
 	int	(*deauth)(struct wiphy *wiphy, struct net_device *dev,
-			  struct cfg80211_deauth_request *req,
-			  void *cookie);
+			  struct cfg80211_deauth_request *req);
 	int	(*disassoc)(struct wiphy *wiphy, struct net_device *dev,
-			    struct cfg80211_disassoc_request *req,
-			    void *cookie);
+			    struct cfg80211_disassoc_request *req);
 
 	int	(*connect)(struct wiphy *wiphy, struct net_device *dev,
 			   struct cfg80211_connect_params *sme);
--- a/net/mac80211/cfg.c	2012-02-24 13:48:35.000000000 +0100
+++ b/net/mac80211/cfg.c	2012-02-24 13:50:18.000000000 +0100
@@ -1595,19 +1595,15 @@ static int ieee80211_assoc(struct wiphy
 }
 
 static int ieee80211_deauth(struct wiphy *wiphy, struct net_device *dev,
-			    struct cfg80211_deauth_request *req,
-			    void *cookie)
+			    struct cfg80211_deauth_request *req)
 {
-	return ieee80211_mgd_deauth(IEEE80211_DEV_TO_SUB_IF(dev),
-				    req, cookie);
+	return ieee80211_mgd_deauth(IEEE80211_DEV_TO_SUB_IF(dev), req);
 }
 
 static int ieee80211_disassoc(struct wiphy *wiphy, struct net_device *dev,
-			      struct cfg80211_disassoc_request *req,
-			      void *cookie)
+			      struct cfg80211_disassoc_request *req)
 {
-	return ieee80211_mgd_disassoc(IEEE80211_DEV_TO_SUB_IF(dev),
-				      req, cookie);
+	return ieee80211_mgd_disassoc(IEEE80211_DEV_TO_SUB_IF(dev), req);
 }
 
 static int ieee80211_join_ibss(struct wiphy *wiphy, struct net_device *dev,
--- a/net/mac80211/ieee80211_i.h	2012-02-24 13:48:35.000000000 +0100
+++ b/net/mac80211/ieee80211_i.h	2012-02-24 13:50:18.000000000 +0100
@@ -1156,11 +1156,9 @@ int ieee80211_mgd_auth(struct ieee80211_
 int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 			struct cfg80211_assoc_request *req);
 int ieee80211_mgd_deauth(struct ieee80211_sub_if_data *sdata,
-			 struct cfg80211_deauth_request *req,
-			 void *cookie);
+			 struct cfg80211_deauth_request *req);
 int ieee80211_mgd_disassoc(struct ieee80211_sub_if_data *sdata,
-			   struct cfg80211_disassoc_request *req,
-			   void *cookie);
+			   struct cfg80211_disassoc_request *req);
 void ieee80211_send_pspoll(struct ieee80211_local *local,
 			   struct ieee80211_sub_if_data *sdata);
 void ieee80211_recalc_ps(struct ieee80211_local *local, s32 latency);
--- a/net/mac80211/mlme.c	2012-02-24 13:50:16.000000000 +0100
+++ b/net/mac80211/mlme.c	2012-02-24 13:50:18.000000000 +0100
@@ -612,8 +612,9 @@ static void ieee80211_send_assoc(struct
 }
 
 static void ieee80211_send_deauth_disassoc(struct ieee80211_sub_if_data *sdata,
-					   const u8 *bssid, u16 stype, u16 reason,
-					   void *cookie, bool send_frame)
+					   const u8 *bssid, u16 stype,
+					   u16 reason, bool cfg80211_locked,
+					   bool send_frame)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
@@ -637,12 +638,12 @@ static void ieee80211_send_deauth_disass
 	mgmt->u.deauth.reason_code = cpu_to_le16(reason);
 
 	if (stype == IEEE80211_STYPE_DEAUTH)
-		if (cookie)
+		if (cfg80211_locked)
 			__cfg80211_send_deauth(sdata->dev, (u8 *)mgmt, skb->len);
 		else
 			cfg80211_send_deauth(sdata->dev, (u8 *)mgmt, skb->len);
 	else
-		if (cookie)
+		if (cfg80211_locked)
 			__cfg80211_send_disassoc(sdata->dev, (u8 *)mgmt, skb->len);
 		else
 			cfg80211_send_disassoc(sdata->dev, (u8 *)mgmt, skb->len);
@@ -1696,7 +1697,7 @@ static void __ieee80211_connection_loss(
 	ieee80211_send_deauth_disassoc(sdata, bssid,
 				       IEEE80211_STYPE_DEAUTH,
 				       WLAN_REASON_DISASSOC_DUE_TO_INACTIVITY,
-				       NULL, true);
+				       false, true);
 
 	mutex_lock(&local->mtx);
 	ieee80211_recalc_idle(local);
@@ -2706,8 +2707,8 @@ static void ieee80211_sta_connection_los
 	 * but that's not a problem.
 	 */
 	ieee80211_send_deauth_disassoc(sdata, bssid,
-			IEEE80211_STYPE_DEAUTH, reason,
-			NULL, true);
+				       IEEE80211_STYPE_DEAUTH,
+				       reason, false, true);
 
 	mutex_lock(&local->mtx);
 	ieee80211_recalc_idle(local);
@@ -3436,8 +3437,7 @@ int ieee80211_mgd_assoc(struct ieee80211
 }
 
 int ieee80211_mgd_deauth(struct ieee80211_sub_if_data *sdata,
-			 struct cfg80211_deauth_request *req,
-			 void *cookie)
+			 struct cfg80211_deauth_request *req)
 {
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	bool assoc_bss = false;
@@ -3458,8 +3458,9 @@ int ieee80211_mgd_deauth(struct ieee8021
 	printk(KERN_DEBUG "%s: deauthenticating from %pM by local choice (reason=%d)\n",
 	       sdata->name, req->bssid, req->reason_code);
 
-	ieee80211_send_deauth_disassoc(sdata, req->bssid, IEEE80211_STYPE_DEAUTH,
-				       req->reason_code, cookie, true);
+	ieee80211_send_deauth_disassoc(sdata, req->bssid,
+				       IEEE80211_STYPE_DEAUTH,
+				       req->reason_code, true, true);
 	if (assoc_bss)
 		sta_info_flush(sdata->local, sdata);
 
@@ -3471,8 +3472,7 @@ int ieee80211_mgd_deauth(struct ieee8021
 }
 
 int ieee80211_mgd_disassoc(struct ieee80211_sub_if_data *sdata,
-			   struct cfg80211_disassoc_request *req,
-			   void *cookie)
+			   struct cfg80211_disassoc_request *req)
 {
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	u8 bssid[ETH_ALEN];
@@ -3500,7 +3500,7 @@ int ieee80211_mgd_disassoc(struct ieee80
 
 	ieee80211_send_deauth_disassoc(sdata, req->bss->bssid,
 			IEEE80211_STYPE_DISASSOC, req->reason_code,
-			cookie, !req->local_state_change);
+			true, !req->local_state_change);
 	sta_info_flush(sdata->local, sdata);
 
 	mutex_lock(&sdata->local->mtx);
--- a/net/wireless/mlme.c	2012-02-24 13:48:35.000000000 +0100
+++ b/net/wireless/mlme.c	2012-02-24 13:50:18.000000000 +0100
@@ -455,7 +455,7 @@ int __cfg80211_mlme_deauth(struct cfg802
 		return 0;
 	}
 
-	return rdev->ops->deauth(&rdev->wiphy, dev, &req, wdev);
+	return rdev->ops->deauth(&rdev->wiphy, dev, &req);
 }
 
 int cfg80211_mlme_deauth(struct cfg80211_registered_device *rdev,
@@ -500,7 +500,7 @@ static int __cfg80211_mlme_disassoc(stru
 	else
 		return -ENOTCONN;
 
-	return rdev->ops->disassoc(&rdev->wiphy, dev, &req, wdev);
+	return rdev->ops->disassoc(&rdev->wiphy, dev, &req);
 }
 
 int cfg80211_mlme_disassoc(struct cfg80211_registered_device *rdev,
@@ -541,7 +541,7 @@ void cfg80211_mlme_down(struct cfg80211_
 
 	memcpy(bssid, wdev->current_bss->pub.bssid, ETH_ALEN);
 	req.bssid = bssid;
-	rdev->ops->deauth(&rdev->wiphy, dev, &req, wdev);
+	rdev->ops->deauth(&rdev->wiphy, dev, &req);
 
 	if (wdev->current_bss) {
 		cfg80211_unhold_bss(wdev->current_bss);


