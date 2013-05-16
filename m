Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:59220 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753521Ab3EPVDq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 May 2013 17:03:46 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 8/9] cfg80211: remove some locked wrappers from mlme API
Date: Thu, 16 May 2013 23:03:37 +0200
Message-Id: <1368738218-7597-9-git-send-email-johannes@sipsolutions.net> (sfid-20130516_230353_238111_78187963)
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
 net/wireless/core.h    |  25 ++---------
 net/wireless/mlme.c    | 120 ++++++++++---------------------------------------
 net/wireless/nl80211.c |  34 +++++++++-----
 net/wireless/sme.c     |  40 ++++++++---------
 4 files changed, 70 insertions(+), 149 deletions(-)

diff --git a/net/wireless/core.h b/net/wireless/core.h
index d21a0fc..c8f87df 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -282,38 +282,21 @@ int cfg80211_stop_ap(struct cfg80211_registered_device *rdev,
 		     struct net_device *dev);
 
 /* MLME */
-int __cfg80211_mlme_auth(struct cfg80211_registered_device *rdev,
-			 struct net_device *dev,
-			 struct ieee80211_channel *chan,
-			 enum nl80211_auth_type auth_type,
-			 const u8 *bssid,
-			 const u8 *ssid, int ssid_len,
-			 const u8 *ie, int ie_len,
-			 const u8 *key, int key_len, int key_idx,
-			 const u8 *sae_data, int sae_data_len);
 int cfg80211_mlme_auth(struct cfg80211_registered_device *rdev,
-		       struct net_device *dev, struct ieee80211_channel *chan,
-		       enum nl80211_auth_type auth_type, const u8 *bssid,
+		       struct net_device *dev,
+		       struct ieee80211_channel *chan,
+		       enum nl80211_auth_type auth_type,
+		       const u8 *bssid,
 		       const u8 *ssid, int ssid_len,
 		       const u8 *ie, int ie_len,
 		       const u8 *key, int key_len, int key_idx,
 		       const u8 *sae_data, int sae_data_len);
-int __cfg80211_mlme_assoc(struct cfg80211_registered_device *rdev,
-			  struct net_device *dev,
-			  struct ieee80211_channel *chan,
-			  const u8 *bssid,
-			  const u8 *ssid, int ssid_len,
-			  struct cfg80211_assoc_request *req);
 int cfg80211_mlme_assoc(struct cfg80211_registered_device *rdev,
 			struct net_device *dev,
 			struct ieee80211_channel *chan,
 			const u8 *bssid,
 			const u8 *ssid, int ssid_len,
 			struct cfg80211_assoc_request *req);
-int __cfg80211_mlme_deauth(struct cfg80211_registered_device *rdev,
-			   struct net_device *dev, const u8 *bssid,
-			   const u8 *ie, int ie_len, u16 reason,
-			   bool local_state_change);
 int cfg80211_mlme_deauth(struct cfg80211_registered_device *rdev,
 			 struct net_device *dev, const u8 *bssid,
 			 const u8 *ie, int ie_len, u16 reason,
diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index 80ffb01..7bde5d9 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -221,15 +221,15 @@ void cfg80211_michael_mic_failure(struct net_device *dev, const u8 *addr,
 EXPORT_SYMBOL(cfg80211_michael_mic_failure);
 
 /* some MLME handling for userspace SME */
-int __cfg80211_mlme_auth(struct cfg80211_registered_device *rdev,
-			 struct net_device *dev,
-			 struct ieee80211_channel *chan,
-			 enum nl80211_auth_type auth_type,
-			 const u8 *bssid,
-			 const u8 *ssid, int ssid_len,
-			 const u8 *ie, int ie_len,
-			 const u8 *key, int key_len, int key_idx,
-			 const u8 *sae_data, int sae_data_len)
+int cfg80211_mlme_auth(struct cfg80211_registered_device *rdev,
+		       struct net_device *dev,
+		       struct ieee80211_channel *chan,
+		       enum nl80211_auth_type auth_type,
+		       const u8 *bssid,
+		       const u8 *ssid, int ssid_len,
+		       const u8 *ie, int ie_len,
+		       const u8 *key, int key_len, int key_idx,
+		       const u8 *sae_data, int sae_data_len)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_auth_request req = {
@@ -271,28 +271,6 @@ out:
 	return err;
 }
 
-int cfg80211_mlme_auth(struct cfg80211_registered_device *rdev,
-		       struct net_device *dev, struct ieee80211_channel *chan,
-		       enum nl80211_auth_type auth_type, const u8 *bssid,
-		       const u8 *ssid, int ssid_len,
-		       const u8 *ie, int ie_len,
-		       const u8 *key, int key_len, int key_idx,
-		       const u8 *sae_data, int sae_data_len)
-{
-	int err;
-
-	ASSERT_RTNL();
-
-	wdev_lock(dev->ieee80211_ptr);
-	err = __cfg80211_mlme_auth(rdev, dev, chan, auth_type, bssid,
-				   ssid, ssid_len, ie, ie_len,
-				   key, key_len, key_idx,
-				   sae_data, sae_data_len);
-	wdev_unlock(dev->ieee80211_ptr);
-
-	return err;
-}
-
 /*  Do a logical ht_capa &= ht_capa_mask.  */
 void cfg80211_oper_and_ht_capa(struct ieee80211_ht_cap *ht_capa,
 			       const struct ieee80211_ht_cap *ht_capa_mask)
@@ -327,12 +305,12 @@ void cfg80211_oper_and_vht_capa(struct ieee80211_vht_cap *vht_capa,
 		p1[i] &= p2[i];
 }
 
-int __cfg80211_mlme_assoc(struct cfg80211_registered_device *rdev,
-			  struct net_device *dev,
-			  struct ieee80211_channel *chan,
-			  const u8 *bssid,
-			  const u8 *ssid, int ssid_len,
-			  struct cfg80211_assoc_request *req)
+int cfg80211_mlme_assoc(struct cfg80211_registered_device *rdev,
+			struct net_device *dev,
+			struct ieee80211_channel *chan,
+			const u8 *bssid,
+			const u8 *ssid, int ssid_len,
+			struct cfg80211_assoc_request *req)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	int err;
@@ -382,30 +360,10 @@ out:
 	return err;
 }
 
-int cfg80211_mlme_assoc(struct cfg80211_registered_device *rdev,
-			struct net_device *dev,
-			struct ieee80211_channel *chan,
-			const u8 *bssid,
-			const u8 *ssid, int ssid_len,
-			struct cfg80211_assoc_request *req)
-{
-	struct wireless_dev *wdev = dev->ieee80211_ptr;
-	int err;
-
-	ASSERT_RTNL();
-
-	wdev_lock(wdev);
-	err = __cfg80211_mlme_assoc(rdev, dev, chan, bssid,
-				    ssid, ssid_len, req);
-	wdev_unlock(wdev);
-
-	return err;
-}
-
-int __cfg80211_mlme_deauth(struct cfg80211_registered_device *rdev,
-			   struct net_device *dev, const u8 *bssid,
-			   const u8 *ie, int ie_len, u16 reason,
-			   bool local_state_change)
+int cfg80211_mlme_deauth(struct cfg80211_registered_device *rdev,
+			 struct net_device *dev, const u8 *bssid,
+			 const u8 *ie, int ie_len, u16 reason,
+			 bool local_state_change)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_deauth_request req = {
@@ -425,26 +383,10 @@ int __cfg80211_mlme_deauth(struct cfg80211_registered_device *rdev,
 	return rdev_deauth(rdev, dev, &req);
 }
 
-int cfg80211_mlme_deauth(struct cfg80211_registered_device *rdev,
-			 struct net_device *dev, const u8 *bssid,
-			 const u8 *ie, int ie_len, u16 reason,
-			 bool local_state_change)
-{
-	struct wireless_dev *wdev = dev->ieee80211_ptr;
-	int err;
-
-	wdev_lock(wdev);
-	err = __cfg80211_mlme_deauth(rdev, dev, bssid, ie, ie_len, reason,
-				     local_state_change);
-	wdev_unlock(wdev);
-
-	return err;
-}
-
-static int __cfg80211_mlme_disassoc(struct cfg80211_registered_device *rdev,
-				    struct net_device *dev, const u8 *bssid,
-				    const u8 *ie, int ie_len, u16 reason,
-				    bool local_state_change)
+int cfg80211_mlme_disassoc(struct cfg80211_registered_device *rdev,
+			   struct net_device *dev, const u8 *bssid,
+			   const u8 *ie, int ie_len, u16 reason,
+			   bool local_state_change)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_disassoc_request req = {
@@ -470,22 +412,6 @@ static int __cfg80211_mlme_disassoc(struct cfg80211_registered_device *rdev,
 	return rdev_disassoc(rdev, dev, &req);
 }
 
-int cfg80211_mlme_disassoc(struct cfg80211_registered_device *rdev,
-			   struct net_device *dev, const u8 *bssid,
-			   const u8 *ie, int ie_len, u16 reason,
-			   bool local_state_change)
-{
-	struct wireless_dev *wdev = dev->ieee80211_ptr;
-	int err;
-
-	wdev_lock(wdev);
-	err = __cfg80211_mlme_disassoc(rdev, dev, bssid, ie, ie_len, reason,
-				       local_state_change);
-	wdev_unlock(wdev);
-
-	return err;
-}
-
 void cfg80211_mlme_down(struct cfg80211_registered_device *rdev,
 			struct net_device *dev)
 {
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 638b1cb..514a683 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -5897,10 +5897,13 @@ static int nl80211_authenticate(struct sk_buff *skb, struct genl_info *info)
 	if (local_state_change)
 		return 0;
 
-	return cfg80211_mlme_auth(rdev, dev, chan, auth_type, bssid,
-				  ssid, ssid_len, ie, ie_len,
-				  key.p.key, key.p.key_len, key.idx,
-				  sae_data, sae_data_len);
+	wdev_lock(dev->ieee80211_ptr);
+	err = cfg80211_mlme_auth(rdev, dev, chan, auth_type, bssid,
+				 ssid, ssid_len, ie, ie_len,
+				 key.p.key, key.p.key_len, key.idx,
+				 sae_data, sae_data_len);
+	wdev_unlock(dev->ieee80211_ptr);
+	return err;
 }
 
 static int nl80211_crypto_settings(struct cfg80211_registered_device *rdev,
@@ -6067,9 +6070,12 @@ static int nl80211_associate(struct sk_buff *skb, struct genl_info *info)
 	}
 
 	err = nl80211_crypto_settings(rdev, info, &req.crypto, 1);
-	if (!err)
+	if (!err) {
+		wdev_lock(dev->ieee80211_ptr);
 		err = cfg80211_mlme_assoc(rdev, dev, chan, bssid,
 					  ssid, ssid_len, &req);
+		wdev_unlock(dev->ieee80211_ptr);
+	}
 
 	return err;
 }
@@ -6079,7 +6085,7 @@ static int nl80211_deauthenticate(struct sk_buff *skb, struct genl_info *info)
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
 	struct net_device *dev = info->user_ptr[1];
 	const u8 *ie = NULL, *bssid;
-	int ie_len = 0;
+	int ie_len = 0, err;
 	u16 reason_code;
 	bool local_state_change;
 
@@ -6114,8 +6120,11 @@ static int nl80211_deauthenticate(struct sk_buff *skb, struct genl_info *info)
 
 	local_state_change = !!info->attrs[NL80211_ATTR_LOCAL_STATE_CHANGE];
 
-	return cfg80211_mlme_deauth(rdev, dev, bssid, ie, ie_len, reason_code,
-				    local_state_change);
+	wdev_lock(dev->ieee80211_ptr);
+	err = cfg80211_mlme_deauth(rdev, dev, bssid, ie, ie_len, reason_code,
+				   local_state_change);
+	wdev_unlock(dev->ieee80211_ptr);
+	return err;
 }
 
 static int nl80211_disassociate(struct sk_buff *skb, struct genl_info *info)
@@ -6123,7 +6132,7 @@ static int nl80211_disassociate(struct sk_buff *skb, struct genl_info *info)
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
 	struct net_device *dev = info->user_ptr[1];
 	const u8 *ie = NULL, *bssid;
-	int ie_len = 0;
+	int ie_len = 0, err;
 	u16 reason_code;
 	bool local_state_change;
 
@@ -6158,8 +6167,11 @@ static int nl80211_disassociate(struct sk_buff *skb, struct genl_info *info)
 
 	local_state_change = !!info->attrs[NL80211_ATTR_LOCAL_STATE_CHANGE];
 
-	return cfg80211_mlme_disassoc(rdev, dev, bssid, ie, ie_len, reason_code,
-				      local_state_change);
+	wdev_lock(dev->ieee80211_ptr);
+	err = cfg80211_mlme_disassoc(rdev, dev, bssid, ie, ie_len, reason_code,
+				     local_state_change);
+	wdev_unlock(dev->ieee80211_ptr);
+	return err;
 }
 
 static bool
diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index 3925064..e167bf9 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -169,13 +169,13 @@ static int cfg80211_conn_do_work(struct wireless_dev *wdev)
 	case CFG80211_CONN_AUTHENTICATE_NEXT:
 		BUG_ON(!rdev->ops->auth);
 		wdev->conn->state = CFG80211_CONN_AUTHENTICATING;
-		return __cfg80211_mlme_auth(rdev, wdev->netdev,
-					    params->channel, params->auth_type,
-					    params->bssid,
-					    params->ssid, params->ssid_len,
-					    NULL, 0,
-					    params->key, params->key_len,
-					    params->key_idx, NULL, 0);
+		return cfg80211_mlme_auth(rdev, wdev->netdev,
+					  params->channel, params->auth_type,
+					  params->bssid,
+					  params->ssid, params->ssid_len,
+					  NULL, 0,
+					  params->key, params->key_len,
+					  params->key_idx, NULL, 0);
 	case CFG80211_CONN_ASSOCIATE_NEXT:
 		BUG_ON(!rdev->ops->assoc);
 		wdev->conn->state = CFG80211_CONN_ASSOCIATING;
@@ -191,19 +191,19 @@ static int cfg80211_conn_do_work(struct wireless_dev *wdev)
 		req.vht_capa = params->vht_capa;
 		req.vht_capa_mask = params->vht_capa_mask;
 
-		err = __cfg80211_mlme_assoc(rdev, wdev->netdev, params->channel,
-					    params->bssid, params->ssid,
-					    params->ssid_len, &req);
+		err = cfg80211_mlme_assoc(rdev, wdev->netdev, params->channel,
+					  params->bssid, params->ssid,
+					  params->ssid_len, &req);
 		if (err)
-			__cfg80211_mlme_deauth(rdev, wdev->netdev, params->bssid,
-					       NULL, 0,
-					       WLAN_REASON_DEAUTH_LEAVING,
-					       false);
+			cfg80211_mlme_deauth(rdev, wdev->netdev, params->bssid,
+					     NULL, 0,
+					     WLAN_REASON_DEAUTH_LEAVING,
+					     false);
 		return err;
 	case CFG80211_CONN_DEAUTH_ASSOC_FAIL:
-		__cfg80211_mlme_deauth(rdev, wdev->netdev, params->bssid,
-				       NULL, 0,
-				       WLAN_REASON_DEAUTH_LEAVING, false);
+		cfg80211_mlme_deauth(rdev, wdev->netdev, params->bssid,
+				     NULL, 0,
+				     WLAN_REASON_DEAUTH_LEAVING, false);
 		/* return an error so that we call __cfg80211_connect_result() */
 		return -EINVAL;
 	default:
@@ -958,7 +958,7 @@ int __cfg80211_disconnect(struct cfg80211_registered_device *rdev,
 		}
 
 		/* wdev->conn->params.bssid must be set if > SCANNING */
-		err = __cfg80211_mlme_deauth(rdev, dev,
+		err = cfg80211_mlme_deauth(rdev, dev,
 					     wdev->conn->params.bssid,
 					     NULL, 0, reason, false);
 		if (err)
@@ -1015,6 +1015,6 @@ void cfg80211_sme_disassoc(struct net_device *dev,
 
 	memcpy(bssid, bss->pub.bssid, ETH_ALEN);
 
-	__cfg80211_mlme_deauth(rdev, dev, bssid, NULL, 0,
-			       WLAN_REASON_DEAUTH_LEAVING, false);
+	cfg80211_mlme_deauth(rdev, dev, bssid, NULL, 0,
+			     WLAN_REASON_DEAUTH_LEAVING, false);
 }
-- 
1.8.0

