Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56004 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753814Ab3BUTLz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Feb 2013 14:11:55 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: greearb@candelatech.com, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3/3] cfg80211: refactor association parameters
Date: Thu, 21 Feb 2013 20:11:46 +0100
Message-Id: <1361473906-14941-4-git-send-email-johannes@sipsolutions.net> (sfid-20130221_201201_502510_C0654F5B)
In-Reply-To: <1361473906-14941-1-git-send-email-johannes@sipsolutions.net>
References: <1361473906-14941-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

cfg80211_mlme_assoc() has grown far too many arguments,
make the caller build almost all of the driver struct
and pass that to the function instead.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/core.h    | 21 +++++------------
 net/wireless/mlme.c    | 64 +++++++++++++-------------------------------------
 net/wireless/nl80211.c | 54 ++++++++++++++++++++----------------------
 net/wireless/sme.c     | 28 ++++++++++++----------
 4 files changed, 63 insertions(+), 104 deletions(-)

diff --git a/net/wireless/core.h b/net/wireless/core.h
index c2f94f2..9a2be8d 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -330,24 +330,15 @@ int cfg80211_mlme_auth(struct cfg80211_registered_device *rdev,
 int __cfg80211_mlme_assoc(struct cfg80211_registered_device *rdev,
 			  struct net_device *dev,
 			  struct ieee80211_channel *chan,
-			  const u8 *bssid, const u8 *prev_bssid,
+			  const u8 *bssid,
 			  const u8 *ssid, int ssid_len,
-			  const u8 *ie, int ie_len, bool use_mfp,
-			  struct cfg80211_crypto_settings *crypt,
-			  u32 assoc_flags, struct ieee80211_ht_cap *ht_capa,
-			  struct ieee80211_ht_cap *ht_capa_mask,
-			  struct ieee80211_vht_cap *vht_capa,
-			  struct ieee80211_vht_cap *vht_capa_mask);
+			  struct cfg80211_assoc_request *req);
 int cfg80211_mlme_assoc(struct cfg80211_registered_device *rdev,
-			struct net_device *dev, struct ieee80211_channel *chan,
-			const u8 *bssid, const u8 *prev_bssid,
+			struct net_device *dev,
+			struct ieee80211_channel *chan,
+			const u8 *bssid,
 			const u8 *ssid, int ssid_len,
-			const u8 *ie, int ie_len, bool use_mfp,
-			struct cfg80211_crypto_settings *crypt,
-			u32 assoc_flags, struct ieee80211_ht_cap *ht_capa,
-			struct ieee80211_ht_cap *ht_capa_mask,
-			struct ieee80211_vht_cap *vht_capa,
-			struct ieee80211_vht_cap *vht_capa_mask);
+			struct cfg80211_assoc_request *req);
 int __cfg80211_mlme_deauth(struct cfg80211_registered_device *rdev,
 			   struct net_device *dev, const u8 *bssid,
 			   const u8 *ie, int ie_len, u16 reason,
diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index 1372a13..ea484aa 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -387,26 +387,18 @@ void cfg80211_oper_and_vht_capa(struct ieee80211_vht_cap *vht_capa,
 int __cfg80211_mlme_assoc(struct cfg80211_registered_device *rdev,
 			  struct net_device *dev,
 			  struct ieee80211_channel *chan,
-			  const u8 *bssid, const u8 *prev_bssid,
+			  const u8 *bssid,
 			  const u8 *ssid, int ssid_len,
-			  const u8 *ie, int ie_len, bool use_mfp,
-			  struct cfg80211_crypto_settings *crypt,
-			  u32 assoc_flags, struct ieee80211_ht_cap *ht_capa,
-			  struct ieee80211_ht_cap *ht_capa_mask,
-			  struct ieee80211_vht_cap *vht_capa,
-			  struct ieee80211_vht_cap *vht_capa_mask)
+			  struct cfg80211_assoc_request *req)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
-	struct cfg80211_assoc_request req;
 	int err;
 	bool was_connected = false;
 
 	ASSERT_WDEV_LOCK(wdev);
 
-	memset(&req, 0, sizeof(req));
-
-	if (wdev->current_bss && prev_bssid &&
-	    ether_addr_equal(wdev->current_bss->pub.bssid, prev_bssid)) {
+	if (wdev->current_bss && req->prev_bssid &&
+	    ether_addr_equal(wdev->current_bss->pub.bssid, req->prev_bssid)) {
 		/*
 		 * Trying to reassociate: Allow this to proceed and let the old
 		 * association to be dropped when the new one is completed.
@@ -418,47 +410,30 @@ int __cfg80211_mlme_assoc(struct cfg80211_registered_device *rdev,
 	} else if (wdev->current_bss)
 		return -EALREADY;
 
-	req.ie = ie;
-	req.ie_len = ie_len;
-	memcpy(&req.crypto, crypt, sizeof(req.crypto));
-	req.use_mfp = use_mfp;
-	req.prev_bssid = prev_bssid;
-	req.flags = assoc_flags;
-	if (ht_capa)
-		memcpy(&req.ht_capa, ht_capa, sizeof(req.ht_capa));
-	if (ht_capa_mask)
-		memcpy(&req.ht_capa_mask, ht_capa_mask,
-		       sizeof(req.ht_capa_mask));
-	cfg80211_oper_and_ht_capa(&req.ht_capa_mask,
+	cfg80211_oper_and_ht_capa(&req->ht_capa_mask,
 				  rdev->wiphy.ht_capa_mod_mask);
-	if (vht_capa)
-		memcpy(&req.vht_capa, vht_capa, sizeof(req.vht_capa));
-	if (vht_capa_mask)
-		memcpy(&req.vht_capa_mask, vht_capa_mask,
-		       sizeof(req.vht_capa_mask));
-	cfg80211_oper_and_vht_capa(&req.vht_capa_mask,
+	cfg80211_oper_and_vht_capa(&req->vht_capa_mask,
 				   rdev->wiphy.vht_capa_mod_mask);
 
-	req.bss = cfg80211_get_bss(&rdev->wiphy, chan, bssid, ssid, ssid_len,
-				   WLAN_CAPABILITY_ESS, WLAN_CAPABILITY_ESS);
-	if (!req.bss) {
+	req->bss = cfg80211_get_bss(&rdev->wiphy, chan, bssid, ssid, ssid_len,
+				    WLAN_CAPABILITY_ESS, WLAN_CAPABILITY_ESS);
+	if (!req->bss) {
 		if (was_connected)
 			wdev->sme_state = CFG80211_SME_CONNECTED;
 		return -ENOENT;
 	}
 
-	err = cfg80211_can_use_chan(rdev, wdev, req.bss->channel,
-				    CHAN_MODE_SHARED);
+	err = cfg80211_can_use_chan(rdev, wdev, chan, CHAN_MODE_SHARED);
 	if (err)
 		goto out;
 
-	err = rdev_assoc(rdev, dev, &req);
+	err = rdev_assoc(rdev, dev, req);
 
 out:
 	if (err) {
 		if (was_connected)
 			wdev->sme_state = CFG80211_SME_CONNECTED;
-		cfg80211_put_bss(&rdev->wiphy, req.bss);
+		cfg80211_put_bss(&rdev->wiphy, req->bss);
 	}
 
 	return err;
@@ -467,24 +442,17 @@ out:
 int cfg80211_mlme_assoc(struct cfg80211_registered_device *rdev,
 			struct net_device *dev,
 			struct ieee80211_channel *chan,
-			const u8 *bssid, const u8 *prev_bssid,
+			const u8 *bssid,
 			const u8 *ssid, int ssid_len,
-			const u8 *ie, int ie_len, bool use_mfp,
-			struct cfg80211_crypto_settings *crypt,
-			u32 assoc_flags, struct ieee80211_ht_cap *ht_capa,
-			struct ieee80211_ht_cap *ht_capa_mask,
-			struct ieee80211_vht_cap *vht_capa,
-			struct ieee80211_vht_cap *vht_capa_mask)
+			struct cfg80211_assoc_request *req)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	int err;
 
 	mutex_lock(&rdev->devlist_mtx);
 	wdev_lock(wdev);
-	err = __cfg80211_mlme_assoc(rdev, dev, chan, bssid, prev_bssid,
-				    ssid, ssid_len, ie, ie_len, use_mfp, crypt,
-				    assoc_flags, ht_capa, ht_capa_mask,
-				    vht_capa, vht_capa_mask);
+	err = __cfg80211_mlme_assoc(rdev, dev, chan, bssid,
+				    ssid, ssid_len, req);
 	wdev_unlock(wdev);
 	mutex_unlock(&rdev->devlist_mtx);
 
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index a52107d..cf42014 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -5951,16 +5951,10 @@ static int nl80211_associate(struct sk_buff *skb, struct genl_info *info)
 {
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
 	struct net_device *dev = info->user_ptr[1];
-	struct cfg80211_crypto_settings crypto;
 	struct ieee80211_channel *chan;
-	const u8 *bssid, *ssid, *ie = NULL, *prev_bssid = NULL;
-	int err, ssid_len, ie_len = 0;
-	bool use_mfp = false;
-	u32 flags = 0;
-	struct ieee80211_ht_cap *ht_capa = NULL;
-	struct ieee80211_ht_cap *ht_capa_mask = NULL;
-	struct ieee80211_vht_cap *vht_capa = NULL;
-	struct ieee80211_vht_cap *vht_capa_mask = NULL;
+	struct cfg80211_assoc_request req = {};
+	const u8 *bssid, *ssid;
+	int err, ssid_len = 0;
 
 	if (!is_valid_ie_attr(info->attrs[NL80211_ATTR_IE]))
 		return -EINVAL;
@@ -5988,54 +5982,58 @@ static int nl80211_associate(struct sk_buff *skb, struct genl_info *info)
 	ssid_len = nla_len(info->attrs[NL80211_ATTR_SSID]);
 
 	if (info->attrs[NL80211_ATTR_IE]) {
-		ie = nla_data(info->attrs[NL80211_ATTR_IE]);
-		ie_len = nla_len(info->attrs[NL80211_ATTR_IE]);
+		req.ie = nla_data(info->attrs[NL80211_ATTR_IE]);
+		req.ie_len = nla_len(info->attrs[NL80211_ATTR_IE]);
 	}
 
 	if (info->attrs[NL80211_ATTR_USE_MFP]) {
 		enum nl80211_mfp mfp =
 			nla_get_u32(info->attrs[NL80211_ATTR_USE_MFP]);
 		if (mfp == NL80211_MFP_REQUIRED)
-			use_mfp = true;
+			req.use_mfp = true;
 		else if (mfp != NL80211_MFP_NO)
 			return -EINVAL;
 	}
 
 	if (info->attrs[NL80211_ATTR_PREV_BSSID])
-		prev_bssid = nla_data(info->attrs[NL80211_ATTR_PREV_BSSID]);
+		req.prev_bssid = nla_data(info->attrs[NL80211_ATTR_PREV_BSSID]);
 
 	if (nla_get_flag(info->attrs[NL80211_ATTR_DISABLE_HT]))
-		flags |= ASSOC_REQ_DISABLE_HT;
+		req.flags |= ASSOC_REQ_DISABLE_HT;
 
 	if (info->attrs[NL80211_ATTR_HT_CAPABILITY_MASK])
-		ht_capa_mask =
-			nla_data(info->attrs[NL80211_ATTR_HT_CAPABILITY_MASK]);
+		memcpy(&req.ht_capa_mask,
+		       nla_data(info->attrs[NL80211_ATTR_HT_CAPABILITY_MASK]),
+		       sizeof(req.ht_capa_mask));
 
 	if (info->attrs[NL80211_ATTR_HT_CAPABILITY]) {
-		if (!ht_capa_mask)
+		if (!info->attrs[NL80211_ATTR_HT_CAPABILITY_MASK])
 			return -EINVAL;
-		ht_capa = nla_data(info->attrs[NL80211_ATTR_HT_CAPABILITY]);
+		memcpy(&req.ht_capa,
+		       nla_data(info->attrs[NL80211_ATTR_HT_CAPABILITY]),
+		       sizeof(req.ht_capa));
 	}
 
 	if (nla_get_flag(info->attrs[NL80211_ATTR_DISABLE_VHT]))
-		flags |= ASSOC_REQ_DISABLE_VHT;
+		req.flags |= ASSOC_REQ_DISABLE_VHT;
 
 	if (info->attrs[NL80211_ATTR_VHT_CAPABILITY_MASK])
-		vht_capa_mask =
-			nla_data(info->attrs[NL80211_ATTR_VHT_CAPABILITY_MASK]);
+		memcpy(&req.vht_capa_mask,
+		       nla_data(info->attrs[NL80211_ATTR_VHT_CAPABILITY_MASK]),
+		       sizeof(req.vht_capa_mask));
 
 	if (info->attrs[NL80211_ATTR_VHT_CAPABILITY]) {
-		if (!vht_capa_mask)
+		if (!info->attrs[NL80211_ATTR_VHT_CAPABILITY_MASK])
 			return -EINVAL;
-		vht_capa = nla_data(info->attrs[NL80211_ATTR_VHT_CAPABILITY]);
+		memcpy(&req.vht_capa,
+		       nla_data(info->attrs[NL80211_ATTR_VHT_CAPABILITY]),
+		       sizeof(req.vht_capa));
 	}
 
-	err = nl80211_crypto_settings(rdev, info, &crypto, 1);
+	err = nl80211_crypto_settings(rdev, info, &req.crypto, 1);
 	if (!err)
-		err = cfg80211_mlme_assoc(rdev, dev, chan, bssid, prev_bssid,
-					  ssid, ssid_len, ie, ie_len, use_mfp,
-					  &crypto, flags, ht_capa, ht_capa_mask,
-					  vht_capa, vht_capa_mask);
+		err = cfg80211_mlme_assoc(rdev, dev, chan, bssid,
+					  ssid, ssid_len, &req);
 
 	return err;
 }
diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index 7da118c..bad4c4b 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -159,7 +159,7 @@ static int cfg80211_conn_do_work(struct wireless_dev *wdev)
 {
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
 	struct cfg80211_connect_params *params;
-	const u8 *prev_bssid = NULL;
+	struct cfg80211_assoc_request req = {};
 	int err;
 
 	ASSERT_WDEV_LOCK(wdev);
@@ -186,18 +186,20 @@ static int cfg80211_conn_do_work(struct wireless_dev *wdev)
 		BUG_ON(!rdev->ops->assoc);
 		wdev->conn->state = CFG80211_CONN_ASSOCIATING;
 		if (wdev->conn->prev_bssid_valid)
-			prev_bssid = wdev->conn->prev_bssid;
-		err = __cfg80211_mlme_assoc(rdev, wdev->netdev,
-					    params->channel, params->bssid,
-					    prev_bssid,
-					    params->ssid, params->ssid_len,
-					    params->ie, params->ie_len,
-					    params->mfp != NL80211_MFP_NO,
-					    &params->crypto,
-					    params->flags, &params->ht_capa,
-					    &params->ht_capa_mask,
-					    &params->vht_capa,
-					    &params->vht_capa_mask);
+			req.prev_bssid = wdev->conn->prev_bssid;
+		req.ie = params->ie;
+		req.ie_len = params->ie_len;
+		req.use_mfp = params->mfp != NL80211_MFP_NO;
+		req.crypto = params->crypto;
+		req.flags = params->flags;
+		req.ht_capa = params->ht_capa;
+		req.ht_capa_mask = params->ht_capa_mask;
+		req.vht_capa = params->vht_capa;
+		req.vht_capa_mask = params->vht_capa_mask;
+
+		err = __cfg80211_mlme_assoc(rdev, wdev->netdev, params->channel,
+					    params->bssid, params->ssid,
+					    params->ssid_len, &req);
 		if (err)
 			__cfg80211_mlme_deauth(rdev, wdev->netdev, params->bssid,
 					       NULL, 0,
-- 
1.8.0

