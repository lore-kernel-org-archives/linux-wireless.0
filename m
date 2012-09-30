Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kvm.w1.fi ([128.177.28.162]:47111 "EHLO
	jmaline2.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751214Ab2I3Qax (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Sep 2012 12:30:53 -0400
Message-Id: <20120930163045.967149941@w1.fi> (sfid-20120930_183131_956652_9E471EF8)
Date: Sun, 30 Sep 2012 19:29:39 +0300
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>
Subject: [PATCH 3/4] cfg80211: Allow user space to specify non-IEs to SAE Authentication
References: <20120930162936.046757966@w1.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SAE extends Authentication frames with fields that are not information
elements. NL80211_ATTR_IE is not suitable for these, so introduce a new
attribute that can be used to specify the fields needed for SAE in
station mode.

Signed-off-by: Jouni Malinen <j@w1.fi>
---
 include/linux/nl80211.h |   11 +++++++++++
 include/net/cfg80211.h  |    5 +++++
 net/wireless/core.h     |    6 ++++--
 net/wireless/mlme.c     |   11 ++++++++---
 net/wireless/nl80211.c  |   21 ++++++++++++++++++---
 net/wireless/sme.c      |    2 +-
 6 files changed, 47 insertions(+), 9 deletions(-)

Index: wireless-testing/include/linux/nl80211.h
===================================================================
--- wireless-testing.orig/include/linux/nl80211.h	2012-09-30 19:16:51.271842606 +0300
+++ wireless-testing/include/linux/nl80211.h	2012-09-30 19:16:57.679842484 +0300
@@ -1273,6 +1273,9 @@ enum nl80211_commands {
  *	the connection request from a station. nl80211_connect_failed_reason
  *	enum has different reasons of connection failure.
  *
+ * @NL80211_ATTR_SAE_DATA: SAE elements in Authentication frames. This starts
+ *	with the Authentication transaction sequence number field.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1530,6 +1533,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_CONN_FAILED_REASON,
 
+	NL80211_ATTR_SAE_DATA,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -2489,6 +2494,7 @@ enum nl80211_bss_status {
  * @NL80211_AUTHTYPE_SHARED_KEY: Shared Key authentication (WEP only)
  * @NL80211_AUTHTYPE_FT: Fast BSS Transition (IEEE 802.11r)
  * @NL80211_AUTHTYPE_NETWORK_EAP: Network EAP (some Cisco APs and mainly LEAP)
+ * @NL80211_AUTHTYPE_SAE: Simultaneous authentication of equals
  * @__NL80211_AUTHTYPE_NUM: internal
  * @NL80211_AUTHTYPE_MAX: maximum valid auth algorithm
  * @NL80211_AUTHTYPE_AUTOMATIC: determine automatically (if necessary by
@@ -2500,6 +2506,7 @@ enum nl80211_auth_type {
 	NL80211_AUTHTYPE_SHARED_KEY,
 	NL80211_AUTHTYPE_FT,
 	NL80211_AUTHTYPE_NETWORK_EAP,
+	NL80211_AUTHTYPE_SAE,
 
 	/* keep last */
 	__NL80211_AUTHTYPE_NUM,
@@ -3028,6 +3035,9 @@ enum nl80211_ap_sme_features {
  *	in the interface combinations, even when it's only used for scan
  *	and remain-on-channel. This could be due to, for example, the
  *	remain-on-channel implementation requiring a channel context.
+ * @NL80211_FEATURE_SAE: This driver supports simultaneous authentication of
+ *	equals (SAE) with user space SME (NL80211_CMD_AUTHENTICATE) in station
+ *	mode
  */
 enum nl80211_feature_flags {
 	NL80211_FEATURE_SK_TX_STATUS			= 1 << 0,
@@ -3035,6 +3045,7 @@ enum nl80211_feature_flags {
 	NL80211_FEATURE_INACTIVITY_TIMER		= 1 << 2,
 	NL80211_FEATURE_CELL_BASE_REG_HINTS		= 1 << 3,
 	NL80211_FEATURE_P2P_DEVICE_NEEDS_CHANNEL	= 1 << 4,
+	NL80211_FEATURE_SAE				= 1 << 5,
 };
 
 /**
Index: wireless-testing/include/net/cfg80211.h
===================================================================
--- wireless-testing.orig/include/net/cfg80211.h	2012-09-30 19:16:51.283842606 +0300
+++ wireless-testing/include/net/cfg80211.h	2012-09-30 19:16:57.679842484 +0300
@@ -1152,6 +1152,9 @@ const u8 *ieee80211_bss_get_ie(struct cf
  * @key_len: length of WEP key for shared key authentication
  * @key_idx: index of WEP key for shared key authentication
  * @key: WEP key for shared key authentication
+ * @sae_data: Non-IE data to use with SAE or %NULL. This starts with
+ *	Authentication transaction sequence number field.
+ * @sae_data_len: Length of sae_data buffer in octets
  */
 struct cfg80211_auth_request {
 	struct cfg80211_bss *bss;
@@ -1160,6 +1163,8 @@ struct cfg80211_auth_request {
 	enum nl80211_auth_type auth_type;
 	const u8 *key;
 	u8 key_len, key_idx;
+	const u8 *sae_data;
+	size_t sae_data_len;
 };
 
 /**
Index: wireless-testing/net/wireless/core.h
===================================================================
--- wireless-testing.orig/net/wireless/core.h	2012-09-30 19:16:51.303842606 +0300
+++ wireless-testing/net/wireless/core.h	2012-09-30 19:16:57.679842484 +0300
@@ -320,13 +320,15 @@ int __cfg80211_mlme_auth(struct cfg80211
 			 const u8 *bssid,
 			 const u8 *ssid, int ssid_len,
 			 const u8 *ie, int ie_len,
-			 const u8 *key, int key_len, int key_idx);
+			 const u8 *key, int key_len, int key_idx,
+			 const u8 *sae_data, int sae_data_len);
 int cfg80211_mlme_auth(struct cfg80211_registered_device *rdev,
 		       struct net_device *dev, struct ieee80211_channel *chan,
 		       enum nl80211_auth_type auth_type, const u8 *bssid,
 		       const u8 *ssid, int ssid_len,
 		       const u8 *ie, int ie_len,
-		       const u8 *key, int key_len, int key_idx);
+		       const u8 *key, int key_len, int key_idx,
+		       const u8 *sae_data, int sae_data_len);
 int __cfg80211_mlme_assoc(struct cfg80211_registered_device *rdev,
 			  struct net_device *dev,
 			  struct ieee80211_channel *chan,
Index: wireless-testing/net/wireless/mlme.c
===================================================================
--- wireless-testing.orig/net/wireless/mlme.c	2012-09-30 19:16:51.323842605 +0300
+++ wireless-testing/net/wireless/mlme.c	2012-09-30 19:16:57.679842484 +0300
@@ -273,7 +273,8 @@ int __cfg80211_mlme_auth(struct cfg80211
 			 const u8 *bssid,
 			 const u8 *ssid, int ssid_len,
 			 const u8 *ie, int ie_len,
-			 const u8 *key, int key_len, int key_idx)
+			 const u8 *key, int key_len, int key_idx,
+			 const u8 *sae_data, int sae_data_len)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_auth_request req;
@@ -293,6 +294,8 @@ int __cfg80211_mlme_auth(struct cfg80211
 
 	req.ie = ie;
 	req.ie_len = ie_len;
+	req.sae_data = sae_data;
+	req.sae_data_len = sae_data_len;
 	req.auth_type = auth_type;
 	req.bss = cfg80211_get_bss(&rdev->wiphy, chan, bssid, ssid, ssid_len,
 				   WLAN_CAPABILITY_ESS, WLAN_CAPABILITY_ESS);
@@ -319,7 +322,8 @@ int cfg80211_mlme_auth(struct cfg80211_r
 		       enum nl80211_auth_type auth_type, const u8 *bssid,
 		       const u8 *ssid, int ssid_len,
 		       const u8 *ie, int ie_len,
-		       const u8 *key, int key_len, int key_idx)
+		       const u8 *key, int key_len, int key_idx,
+		       const u8 *sae_data, int sae_data_len)
 {
 	int err;
 
@@ -327,7 +331,8 @@ int cfg80211_mlme_auth(struct cfg80211_r
 	wdev_lock(dev->ieee80211_ptr);
 	err = __cfg80211_mlme_auth(rdev, dev, chan, auth_type, bssid,
 				   ssid, ssid_len, ie, ie_len,
-				   key, key_len, key_idx);
+				   key, key_len, key_idx,
+				   sae_data, sae_data_len);
 	wdev_unlock(dev->ieee80211_ptr);
 	mutex_unlock(&rdev->devlist_mtx);
 
Index: wireless-testing/net/wireless/nl80211.c
===================================================================
--- wireless-testing.orig/net/wireless/nl80211.c	2012-09-30 19:16:51.311842605 +0300
+++ wireless-testing/net/wireless/nl80211.c	2012-09-30 19:16:57.683842484 +0300
@@ -355,6 +355,7 @@ static const struct nla_policy nl80211_p
 	[NL80211_ATTR_BG_SCAN_PERIOD] = { .type = NLA_U16 },
 	[NL80211_ATTR_WDEV] = { .type = NLA_U64 },
 	[NL80211_ATTR_USER_REG_HINT_TYPE] = { .type = NLA_U32 },
+	[NL80211_ATTR_SAE_DATA] = { .type = NLA_BINARY, },
 };
 
 /* policy for the key attributes */
@@ -4868,8 +4869,8 @@ static int nl80211_authenticate(struct s
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
 	struct net_device *dev = info->user_ptr[1];
 	struct ieee80211_channel *chan;
-	const u8 *bssid, *ssid, *ie = NULL;
-	int err, ssid_len, ie_len = 0;
+	const u8 *bssid, *ssid, *ie = NULL, *sae_data = NULL;
+	int err, ssid_len, ie_len = 0, sae_data_len = 0;
 	enum nl80211_auth_type auth_type;
 	struct key_parse key;
 	bool local_state_change;
@@ -4948,6 +4949,19 @@ static int nl80211_authenticate(struct s
 	if (!nl80211_valid_auth_type(auth_type))
 		return -EINVAL;
 
+	if (auth_type == NL80211_AUTHTYPE_SAE &&
+	    !info->attrs[NL80211_ATTR_SAE_DATA])
+		return -EINVAL;
+	if (info->attrs[NL80211_ATTR_SAE_DATA]) {
+		if (auth_type != NL80211_AUTHTYPE_SAE)
+			return -EINVAL;
+		sae_data = nla_data(info->attrs[NL80211_ATTR_SAE_DATA]);
+		sae_data_len = nla_len(info->attrs[NL80211_ATTR_SAE_DATA]);
+		/* need to include at least Auth Transaction and Status Code */
+		if (sae_data_len < 4)
+			return -EINVAL;
+	}
+
 	local_state_change = !!info->attrs[NL80211_ATTR_LOCAL_STATE_CHANGE];
 
 	/*
@@ -4959,7 +4973,8 @@ static int nl80211_authenticate(struct s
 
 	return cfg80211_mlme_auth(rdev, dev, chan, auth_type, bssid,
 				  ssid, ssid_len, ie, ie_len,
-				  key.p.key, key.p.key_len, key.idx);
+				  key.p.key, key.p.key_len, key.idx,
+				  sae_data, sae_data_len);
 }
 
 static int nl80211_crypto_settings(struct cfg80211_registered_device *rdev,
Index: wireless-testing/net/wireless/sme.c
===================================================================
--- wireless-testing.orig/net/wireless/sme.c	2012-09-30 19:16:51.295842606 +0300
+++ wireless-testing/net/wireless/sme.c	2012-09-30 19:16:57.683842484 +0300
@@ -179,7 +179,7 @@ static int cfg80211_conn_do_work(struct
 					    params->ssid, params->ssid_len,
 					    NULL, 0,
 					    params->key, params->key_len,
-					    params->key_idx);
+					    params->key_idx, NULL, 0);
 	case CFG80211_CONN_ASSOCIATE_NEXT:
 		BUG_ON(!rdev->ops->assoc);
 		wdev->conn->state = CFG80211_CONN_ASSOCIATING;

