Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:3746 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932557AbcJZVmi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Oct 2016 17:42:38 -0400
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
        Jouni Malinen <jouni@qca.qualcomm.com>
Subject: [PATCH v2 1/9] cfg80211: Rename SAE_DATA to more generic AUTH_DATA
Date: Thu, 27 Oct 2016 00:41:58 +0300
Message-ID: <1477518126-823-2-git-send-email-jouni@qca.qualcomm.com> (sfid-20161026_234323_944048_2362BD85)
In-Reply-To: <1477518126-823-1-git-send-email-jouni@qca.qualcomm.com>
References: <1477518126-823-1-git-send-email-jouni@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds defines and nl80211 extensions to allow FILS Authentication to
be implemented similarly to SAE. FILS does not need the special rules
for the Authentication transaction number and Status code fields, but it
does need to add non-IE fields. The previously used
NL80211_ATTR_SAE_DATA can be reused for this to avoid having to
duplicate that implementation. Rename that attribute to more generic
NL80211_ATTR_AUTH_DATA (with backwards compatibility define for
NL80211_SAE_DATA).

Also document the special rules related to the Authentication
transaction number and Status code fiels.

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 include/net/cfg80211.h       | 10 +++++-----
 include/uapi/linux/nl80211.h | 13 ++++++++++---
 net/mac80211/mlme.c          | 12 ++++++------
 net/wireless/core.h          |  2 +-
 net/wireless/mlme.c          |  6 +++---
 net/wireless/nl80211.c       | 18 +++++++++---------
 6 files changed, 34 insertions(+), 27 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index d1ffbc3..843ab8a 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1785,9 +1785,9 @@ struct cfg80211_bss {
  * @key_len: length of WEP key for shared key authentication
  * @key_idx: index of WEP key for shared key authentication
  * @key: WEP key for shared key authentication
- * @sae_data: Non-IE data to use with SAE or %NULL. This starts with
- *	Authentication transaction sequence number field.
- * @sae_data_len: Length of sae_data buffer in octets
+ * @auth_data: IE and non-IE data to use with SAE/FILS or %NULL. This starts
+ *	with Authentication transaction sequence number field.
+ * @auth_data_len: Length of auth_data buffer in octets
  */
 struct cfg80211_auth_request {
 	struct cfg80211_bss *bss;
@@ -1796,8 +1796,8 @@ struct cfg80211_auth_request {
 	enum nl80211_auth_type auth_type;
 	const u8 *key;
 	u8 key_len, key_idx;
-	const u8 *sae_data;
-	size_t sae_data_len;
+	const u8 *auth_data;
+	size_t auth_data_len;
 };
 
 /**
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 1362d24..6f74714 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1638,8 +1638,14 @@ enum nl80211_commands {
  *	the connection request from a station. nl80211_connect_failed_reason
  *	enum has different reasons of connection failure.
  *
- * @NL80211_ATTR_SAE_DATA: SAE elements in Authentication frames. This starts
- *	with the Authentication transaction sequence number field.
+ * @NL80211_ATTR_AUTH_DATA: Fields and elements in Authentication frames. This
+ *	starts with the Authentication transaction sequence number field and is
+ *	used with authentication algorithms that need special fields to be added
+ *	into the frames (SAE and FILS). Currently, only the SAE cases use the
+ *	initial two fields (Authentication transaction sequence number and
+ *	Status code). However, those fields are included in the attribute data
+ *	for all authentication algorithms to keep the attribute definition
+ *	consistent.
  *
  * @NL80211_ATTR_VHT_CAPABILITY: VHT Capability information element (from
  *	association request when used with NL80211_CMD_NEW_STATION)
@@ -2195,7 +2201,7 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_CONN_FAILED_REASON,
 
-	NL80211_ATTR_SAE_DATA,
+	NL80211_ATTR_AUTH_DATA,
 
 	NL80211_ATTR_VHT_CAPABILITY,
 
@@ -2347,6 +2353,7 @@ enum nl80211_attrs {
 #define NL80211_ATTR_SCAN_GENERATION NL80211_ATTR_GENERATION
 #define	NL80211_ATTR_MESH_PARAMS NL80211_ATTR_MESH_CONFIG
 #define NL80211_ATTR_IFACE_SOCKET_OWNER NL80211_ATTR_SOCKET_OWNER
+#define NL80211_ATTR_SAE_DATA NL80211_ATTR_AUTH_DATA
 
 /*
  * Allow user space programs to use #ifdef on new attributes by defining them
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index c8d3a9b..32fd295 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -4483,20 +4483,20 @@ int ieee80211_mgd_auth(struct ieee80211_sub_if_data *sdata,
 		return -EOPNOTSUPP;
 	}
 
-	auth_data = kzalloc(sizeof(*auth_data) + req->sae_data_len +
+	auth_data = kzalloc(sizeof(*auth_data) + req->auth_data_len +
 			    req->ie_len, GFP_KERNEL);
 	if (!auth_data)
 		return -ENOMEM;
 
 	auth_data->bss = req->bss;
 
-	if (req->sae_data_len >= 4) {
-		__le16 *pos = (__le16 *) req->sae_data;
+	if (req->auth_data_len >= 4) {
+		__le16 *pos = (__le16 *) req->auth_data;
 		auth_data->sae_trans = le16_to_cpu(pos[0]);
 		auth_data->sae_status = le16_to_cpu(pos[1]);
-		memcpy(auth_data->data, req->sae_data + 4,
-		       req->sae_data_len - 4);
-		auth_data->data_len += req->sae_data_len - 4;
+		memcpy(auth_data->data, req->auth_data + 4,
+		       req->auth_data_len - 4);
+		auth_data->data_len += req->auth_data_len - 4;
 	}
 
 	if (req->ie && req->ie_len) {
diff --git a/net/wireless/core.h b/net/wireless/core.h
index 21e3188..fb2fcd5 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -345,7 +345,7 @@ int cfg80211_mlme_auth(struct cfg80211_registered_device *rdev,
 		       const u8 *ssid, int ssid_len,
 		       const u8 *ie, int ie_len,
 		       const u8 *key, int key_len, int key_idx,
-		       const u8 *sae_data, int sae_data_len);
+		       const u8 *auth_data, int auth_data_len);
 int cfg80211_mlme_assoc(struct cfg80211_registered_device *rdev,
 			struct net_device *dev,
 			struct ieee80211_channel *chan,
diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index cbb48e2..bd1f7a1 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -204,14 +204,14 @@ int cfg80211_mlme_auth(struct cfg80211_registered_device *rdev,
 		       const u8 *ssid, int ssid_len,
 		       const u8 *ie, int ie_len,
 		       const u8 *key, int key_len, int key_idx,
-		       const u8 *sae_data, int sae_data_len)
+		       const u8 *auth_data, int auth_data_len)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_auth_request req = {
 		.ie = ie,
 		.ie_len = ie_len,
-		.sae_data = sae_data,
-		.sae_data_len = sae_data_len,
+		.auth_data = auth_data,
+		.auth_data_len = auth_data_len,
 		.auth_type = auth_type,
 		.key = key,
 		.key_len = key_len,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index ad49a4c..1a51bd4 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -357,7 +357,7 @@ enum nl80211_multicast_groups {
 	[NL80211_ATTR_BG_SCAN_PERIOD] = { .type = NLA_U16 },
 	[NL80211_ATTR_WDEV] = { .type = NLA_U64 },
 	[NL80211_ATTR_USER_REG_HINT_TYPE] = { .type = NLA_U32 },
-	[NL80211_ATTR_SAE_DATA] = { .type = NLA_BINARY, },
+	[NL80211_ATTR_AUTH_DATA] = { .type = NLA_BINARY, },
 	[NL80211_ATTR_VHT_CAPABILITY] = { .len = NL80211_VHT_CAPABILITY_LEN },
 	[NL80211_ATTR_SCAN_FLAGS] = { .type = NLA_U32 },
 	[NL80211_ATTR_P2P_CTWINDOW] = { .type = NLA_U8 },
@@ -7728,8 +7728,8 @@ static int nl80211_authenticate(struct sk_buff *skb, struct genl_info *info)
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
 	struct net_device *dev = info->user_ptr[1];
 	struct ieee80211_channel *chan;
-	const u8 *bssid, *ssid, *ie = NULL, *sae_data = NULL;
-	int err, ssid_len, ie_len = 0, sae_data_len = 0;
+	const u8 *bssid, *ssid, *ie = NULL, *auth_data = NULL;
+	int err, ssid_len, ie_len = 0, auth_data_len = 0;
 	enum nl80211_auth_type auth_type;
 	struct key_parse key;
 	bool local_state_change;
@@ -7810,16 +7810,16 @@ static int nl80211_authenticate(struct sk_buff *skb, struct genl_info *info)
 		return -EINVAL;
 
 	if (auth_type == NL80211_AUTHTYPE_SAE &&
-	    !info->attrs[NL80211_ATTR_SAE_DATA])
+	    !info->attrs[NL80211_ATTR_AUTH_DATA])
 		return -EINVAL;
 
-	if (info->attrs[NL80211_ATTR_SAE_DATA]) {
+	if (info->attrs[NL80211_ATTR_AUTH_DATA]) {
 		if (auth_type != NL80211_AUTHTYPE_SAE)
 			return -EINVAL;
-		sae_data = nla_data(info->attrs[NL80211_ATTR_SAE_DATA]);
-		sae_data_len = nla_len(info->attrs[NL80211_ATTR_SAE_DATA]);
+		auth_data = nla_data(info->attrs[NL80211_ATTR_AUTH_DATA]);
+		auth_data_len = nla_len(info->attrs[NL80211_ATTR_AUTH_DATA]);
 		/* need to include at least Auth Transaction and Status Code */
-		if (sae_data_len < 4)
+		if (auth_data_len < 4)
 			return -EINVAL;
 	}
 
@@ -7836,7 +7836,7 @@ static int nl80211_authenticate(struct sk_buff *skb, struct genl_info *info)
 	err = cfg80211_mlme_auth(rdev, dev, chan, auth_type, bssid,
 				 ssid, ssid_len, ie, ie_len,
 				 key.p.key, key.p.key_len, key.idx,
-				 sae_data, sae_data_len);
+				 auth_data, auth_data_len);
 	wdev_unlock(dev->ieee80211_ptr);
 	return err;
 }
-- 
1.9.1
