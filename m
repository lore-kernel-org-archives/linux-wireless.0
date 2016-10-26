Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:17312 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932684AbcJZVqq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Oct 2016 17:46:46 -0400
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
        Jouni Malinen <jouni@qca.qualcomm.com>
Subject: [PATCH v2 6/9] cfg80211: Add KEK/nonces for FILS association frames
Date: Thu, 27 Oct 2016 00:42:03 +0300
Message-ID: <1477518126-823-7-git-send-email-jouni@qca.qualcomm.com> (sfid-20161026_234651_261336_C22B00BA)
In-Reply-To: <1477518126-823-1-git-send-email-jouni@qca.qualcomm.com>
References: <1477518126-823-1-git-send-email-jouni@qca.qualcomm.com>
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
 net/wireless/nl80211.c       | 12 ++++++++++++
 4 files changed, 32 insertions(+)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 793a017..fe84932 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -2096,6 +2096,9 @@ enum ieee80211_key_len {
 #define IEEE80211_GCMP_MIC_LEN		16
 #define IEEE80211_GCMP_PN_LEN		6
 
+#define FILS_NONCE_LEN			16
+#define FILS_MAX_KEK_LEN		64
+
 /* Public action codes */
 enum ieee80211_pub_actioncode {
 	WLAN_PUB_ACTION_EXT_CHANSW_ANN = 4,
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index e1bc478..083fd6d 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1838,6 +1838,12 @@ enum cfg80211_assoc_req_flags {
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
@@ -1849,6 +1855,9 @@ struct cfg80211_assoc_request {
 	struct ieee80211_ht_cap ht_capa;
 	struct ieee80211_ht_cap ht_capa_mask;
 	struct ieee80211_vht_cap vht_capa, vht_capa_mask;
+	const u8 *fils_kek;
+	size_t fils_kek_len;
+	const u8 *fils_nonces;
 };
 
 /**
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index dcf8f6f..efa8a49 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1942,6 +1942,11 @@ enum nl80211_commands {
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
@@ -2342,6 +2347,9 @@ enum nl80211_attrs {
 	NL80211_ATTR_NAN_FUNC,
 	NL80211_ATTR_NAN_MATCH,
 
+	NL80211_ATTR_FILS_KEK,
+	NL80211_ATTR_FILS_NONCES,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 893e321..ec26261 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -414,6 +414,9 @@ enum nl80211_multicast_groups {
 	[NL80211_ATTR_NAN_MASTER_PREF] = { .type = NLA_U8 },
 	[NL80211_ATTR_NAN_DUAL] = { .type = NLA_U8 },
 	[NL80211_ATTR_NAN_FUNC] = { .type = NLA_NESTED },
+	[NL80211_ATTR_FILS_KEK] = { .type = NLA_BINARY,
+				    .len = FILS_MAX_KEK_LEN },
+	[NL80211_ATTR_FILS_NONCES] = { .len = 2 * FILS_NONCE_LEN },
 };
 
 /* policy for the key attributes */
@@ -8032,6 +8035,15 @@ static int nl80211_associate(struct sk_buff *skb, struct genl_info *info)
 		req.flags |= ASSOC_REQ_USE_RRM;
 	}
 
+	if (info->attrs[NL80211_ATTR_FILS_KEK]) {
+		req.fils_kek = nla_data(info->attrs[NL80211_ATTR_FILS_KEK]);
+		req.fils_kek_len = nla_len(info->attrs[NL80211_ATTR_FILS_KEK]);
+		if (!info->attrs[NL80211_ATTR_FILS_NONCES])
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
