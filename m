Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:16347 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753671AbcJYWpX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Oct 2016 18:45:23 -0400
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
        Jouni Malinen <jouni@qca.qualcomm.com>
Subject: [PATCH 5/8] cfg80211: Add KEK/nonces for FILS association frames
Date: Wed, 26 Oct 2016 01:44:46 +0300
Message-ID: <1477435489-8555-1-git-send-email-jouni@qca.qualcomm.com> (sfid-20161026_004531_494602_DCF8C73D)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The new nl80211 attributes can be used to provide KEK and nonces to
allow the driver to encrypt and decrypt FILS (Re)Association
Request/Response frames in station mode.

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 include/linux/ieee80211.h    |  3 +++
 include/net/cfg80211.h       |  9 +++++++++
 include/uapi/linux/nl80211.h |  8 ++++++++
 net/wireless/nl80211.c       | 17 +++++++++++++++++
 4 files changed, 37 insertions(+)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 9a523d9..a39beb9 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -2076,6 +2076,9 @@ enum ieee80211_key_len {
 #define IEEE80211_GCMP_MIC_LEN		16
 #define IEEE80211_GCMP_PN_LEN		6
 
+#define FILS_NONCE_LEN			16
+#define FILS_MAX_KEK_LEN		64
+
 /* Public action codes */
 enum ieee80211_pub_actioncode {
 	WLAN_PUB_ACTION_EXT_CHANSW_ANN = 4,
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 2667917..a3045f1 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1842,6 +1842,12 @@ enum cfg80211_assoc_req_flags {
  * @ht_capa_mask:  The bits of ht_capa which are to be used.
  * @vht_capa: VHT capability override
  * @vht_capa_mask: VHT capability mask indicating which fields to use
+ * @fils_kek: FILS KEK for protecting (Re)Association Request/Response frame or
+ *	%NULL if FILS is not used.
+ * @fils_kek_len: Length of fils_kek in octets
+ * @fils_nonces: FILS nonces (part of AAD) for protecting (Re)Association
+ *	Request/Response frame or %NULL if FILS is not used. This field starts
+ *	with 16 octets of STA Nonce followed by 16 octets of AP Nonce.
  */
 struct cfg80211_assoc_request {
 	struct cfg80211_bss *bss;
@@ -1853,6 +1859,9 @@ struct cfg80211_assoc_request {
 	struct ieee80211_ht_cap ht_capa;
 	struct ieee80211_ht_cap ht_capa_mask;
 	struct ieee80211_vht_cap vht_capa, vht_capa_mask;
+	const u8 *fils_kek;
+	size_t fils_kek_len;
+	const u8 *fils_nonces;
 };
 
 /**
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 5d36e83..b468a89 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1938,6 +1938,11 @@ enum nl80211_commands {
  *	attribute.
  * @NL80211_ATTR_NAN_MATCH: used to report a match. This is a nested attribute.
  *	See &enum nl80211_nan_match_attributes.
+ * @NL80211_ATTR_FILS_KEK: KEK for FILS (Re)Association Request/Response frame
+ *	protection.
+ * @NL80211_ATTR_FILS_NONCES: Nonces (part of AAD) for FILS (Re)Association
+ *	Request/Response frame protection. This attribute contains the 16 octet
+ *	STA Nonce followed by 16 octets of AP Nonce.
  *
  * @NUM_NL80211_ATTR: total number of nl80211_attrs available
  * @NL80211_ATTR_MAX: highest attribute number currently defined
@@ -2338,6 +2343,9 @@ enum nl80211_attrs {
 	NL80211_ATTR_NAN_FUNC,
 	NL80211_ATTR_NAN_MATCH,
 
+	NL80211_ATTR_FILS_KEK,
+	NL80211_ATTR_FILS_NONCES,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index ebd7eaf..a06145c 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -414,6 +414,10 @@ enum nl80211_multicast_groups {
 	[NL80211_ATTR_NAN_MASTER_PREF] = { .type = NLA_U8 },
 	[NL80211_ATTR_NAN_DUAL] = { .type = NLA_U8 },
 	[NL80211_ATTR_NAN_FUNC] = { .type = NLA_NESTED },
+	[NL80211_ATTR_FILS_KEK] = { .type = NLA_BINARY,
+				    .len = FILS_MAX_KEK_LEN },
+	[NL80211_ATTR_FILS_NONCES] = { .type = NLA_BINARY,
+				       .len = 2 * FILS_NONCE_LEN },
 };
 
 /* policy for the key attributes */
@@ -8019,6 +8023,19 @@ static int nl80211_associate(struct sk_buff *skb, struct genl_info *info)
 		req.flags |= ASSOC_REQ_USE_RRM;
 	}
 
+	if (info->attrs[NL80211_ATTR_FILS_KEK]) {
+		req.fils_kek = nla_data(info->attrs[NL80211_ATTR_FILS_KEK]);
+		req.fils_kek_len = nla_len(info->attrs[NL80211_ATTR_FILS_KEK]);
+	}
+
+	if (info->attrs[NL80211_ATTR_FILS_NONCES]) {
+		if (nla_len(info->attrs[NL80211_ATTR_FILS_NONCES]) !=
+		    2 * FILS_NONCE_LEN)
+			return -EINVAL;
+		req.fils_nonces =
+			nla_data(info->attrs[NL80211_ATTR_FILS_NONCES]);
+	}
+
 	err = nl80211_crypto_settings(rdev, info, &req.crypto, 1);
 	if (!err) {
 		wdev_lock(dev->ieee80211_ptr);
-- 
1.9.1
