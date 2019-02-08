Return-Path: <SRS0=Ms0V=QP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 573ACC282CB
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Feb 2019 12:32:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 26FFD2073D
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Feb 2019 12:32:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727174AbfBHMcB (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 8 Feb 2019 07:32:01 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:47440 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726565AbfBHMcA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Feb 2019 07:32:00 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC4)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gs5K1-0007Gh-RR; Fri, 08 Feb 2019 13:31:58 +0100
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3/4] cfg80211: add various struct element finding helpers
Date:   Fri,  8 Feb 2019 13:31:53 +0100
Message-Id: <20190208123154.22414-3-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20190208123154.22414-1-johannes@sipsolutions.net>
References: <20190208123154.22414-1-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

We currently have a number of helpers to find elements that just
return a u8 *, change those to return a struct element and add
inlines to deal with the u8 * compatibility.

Note that the match behaviour is changed to start the natch at
the data, so conversion from _ie_match to _elem_match need to
be done carefully.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/cfg80211.h | 135 ++++++++++++++++++++++++++++++++++++++---
 net/wireless/scan.c    |  39 ++++++------
 net/wireless/util.c    |   6 +-
 3 files changed, 148 insertions(+), 32 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 7f2739a90bdb..c077de7fbd8a 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2062,16 +2062,30 @@ struct cfg80211_bss {
 	u8 priv[0] __aligned(sizeof(void *));
 };
 
+/**
+ * ieee80211_bss_get_elem - find element with given ID
+ * @bss: the bss to search
+ * @id: the element ID
+ *
+ * Note that the return value is an RCU-protected pointer, so
+ * rcu_read_lock() must be held when calling this function.
+ * Return: %NULL if not found.
+ */
+const struct element *ieee80211_bss_get_elem(struct cfg80211_bss *bss, u8 id);
+
 /**
  * ieee80211_bss_get_ie - find IE with given ID
  * @bss: the bss to search
- * @ie: the IE ID
+ * @id: the element ID
  *
  * Note that the return value is an RCU-protected pointer, so
  * rcu_read_lock() must be held when calling this function.
  * Return: %NULL if not found.
  */
-const u8 *ieee80211_bss_get_ie(struct cfg80211_bss *bss, u8 ie);
+static inline const u8 *ieee80211_bss_get_ie(struct cfg80211_bss *bss, u8 id)
+{
+	return (void *)ieee80211_bss_get_elem(bss, id);
+}
 
 
 /**
@@ -4999,6 +5013,33 @@ void ieee80211_amsdu_to_8023s(struct sk_buff *skb, struct sk_buff_head *list,
 unsigned int cfg80211_classify8021d(struct sk_buff *skb,
 				    struct cfg80211_qos_map *qos_map);
 
+/**
+ * cfg80211_find_elem_match - match information element and byte array in data
+ *
+ * @eid: element ID
+ * @ies: data consisting of IEs
+ * @len: length of data
+ * @match: byte array to match
+ * @match_len: number of bytes in the match array
+ * @match_offset: offset in the IE data where the byte array should match.
+ *	Note the difference to cfg80211_find_ie_match() which considers
+ *	the offset to start from the element ID byte, but here we take
+ *	the data portion instead.
+ *
+ * Return: %NULL if the element ID could not be found or if
+ * the element is invalid (claims to be longer than the given
+ * data) or if the byte array doesn't match; otherwise return the
+ * requested element struct.
+ *
+ * Note: There are no checks on the element length other than
+ * having to fit into the given data and being large enough for the
+ * byte array to match.
+ */
+const struct element *
+cfg80211_find_elem_match(u8 eid, const u8 *ies, unsigned int len,
+			 const u8 *match, unsigned int match_len,
+			 unsigned int match_offset);
+
 /**
  * cfg80211_find_ie_match - match information element and byte array in data
  *
@@ -5023,9 +5064,44 @@ unsigned int cfg80211_classify8021d(struct sk_buff *skb,
  * having to fit into the given data and being large enough for the
  * byte array to match.
  */
-const u8 *cfg80211_find_ie_match(u8 eid, const u8 *ies, int len,
-				 const u8 *match, int match_len,
-				 int match_offset);
+static inline const u8 *
+cfg80211_find_ie_match(u8 eid, const u8 *ies, unsigned int len,
+		       const u8 *match, unsigned int match_len,
+		       unsigned int match_offset)
+{
+	/* match_offset can't be smaller than 2, unless match_len is
+	 * zero, in which case match_offset must be zero as well.
+	 */
+	if (WARN_ON((match_len && match_offset < 2) ||
+		    (!match_len && match_offset)))
+		return NULL;
+
+	return (void *)cfg80211_find_elem_match(eid, ies, len,
+						match, match_len,
+						match_offset ?
+							match_offset - 2 : 0);
+}
+
+/**
+ * cfg80211_find_elem - find information element in data
+ *
+ * @eid: element ID
+ * @ies: data consisting of IEs
+ * @len: length of data
+ *
+ * Return: %NULL if the element ID could not be found or if
+ * the element is invalid (claims to be longer than the given
+ * data) or if the byte array doesn't match; otherwise return the
+ * requested element struct.
+ *
+ * Note: There are no checks on the element length other than
+ * having to fit into the given data.
+ */
+static inline const struct element *
+cfg80211_find_elem(u8 eid, const u8 *ies, int len)
+{
+	return cfg80211_find_elem_match(eid, ies, len, NULL, 0, 0);
+}
 
 /**
  * cfg80211_find_ie - find information element in data
@@ -5047,6 +5123,28 @@ static inline const u8 *cfg80211_find_ie(u8 eid, const u8 *ies, int len)
 	return cfg80211_find_ie_match(eid, ies, len, NULL, 0, 0);
 }
 
+/**
+ * cfg80211_find_ext_elem - find information element with EID Extension in data
+ *
+ * @ext_eid: element ID Extension
+ * @ies: data consisting of IEs
+ * @len: length of data
+ *
+ * Return: %NULL if the etended element could not be found or if
+ * the element is invalid (claims to be longer than the given
+ * data) or if the byte array doesn't match; otherwise return the
+ * requested element struct.
+ *
+ * Note: There are no checks on the element length other than
+ * having to fit into the given data.
+ */
+static inline const struct element *
+cfg80211_find_ext_elem(u8 ext_eid, const u8 *ies, int len)
+{
+	return cfg80211_find_elem_match(WLAN_EID_EXTENSION, ies, len,
+					&ext_eid, 1, 0);
+}
+
 /**
  * cfg80211_find_ext_ie - find information element with EID Extension in data
  *
@@ -5068,6 +5166,25 @@ static inline const u8 *cfg80211_find_ext_ie(u8 ext_eid, const u8 *ies, int len)
 				      &ext_eid, 1, 2);
 }
 
+/**
+ * cfg80211_find_vendor_elem - find vendor specific information element in data
+ *
+ * @oui: vendor OUI
+ * @oui_type: vendor-specific OUI type (must be < 0xff), negative means any
+ * @ies: data consisting of IEs
+ * @len: length of data
+ *
+ * Return: %NULL if the vendor specific element ID could not be found or if the
+ * element is invalid (claims to be longer than the given data); otherwise
+ * return the element structure for the requested element.
+ *
+ * Note: There are no checks on the element length other than having to fit into
+ * the given data.
+ */
+const struct element *cfg80211_find_vendor_elem(unsigned int oui, int oui_type,
+						const u8 *ies,
+						unsigned int len);
+
 /**
  * cfg80211_find_vendor_ie - find vendor specific information element in data
  *
@@ -5084,8 +5201,12 @@ static inline const u8 *cfg80211_find_ext_ie(u8 ext_eid, const u8 *ies, int len)
  * Note: There are no checks on the element length other than having to fit into
  * the given data.
  */
-const u8 *cfg80211_find_vendor_ie(unsigned int oui, int oui_type,
-				  const u8 *ies, int len);
+static inline const u8 *
+cfg80211_find_vendor_ie(unsigned int oui, int oui_type,
+			const u8 *ies, unsigned int len)
+{
+	return (void *)cfg80211_find_vendor_elem(oui, oui_type, ies, len);
+}
 
 /**
  * cfg80211_send_layer2_update - send layer 2 update frame
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index c7f64bb9c581..d2c9ca5f4f57 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -480,48 +480,43 @@ void cfg80211_bss_expire(struct cfg80211_registered_device *rdev)
 	__cfg80211_bss_expire(rdev, jiffies - IEEE80211_SCAN_RESULT_EXPIRE);
 }
 
-const u8 *cfg80211_find_ie_match(u8 eid, const u8 *ies, int len,
-				 const u8 *match, int match_len,
-				 int match_offset)
+const struct element *
+cfg80211_find_elem_match(u8 eid, const u8 *ies, unsigned int len,
+			 const u8 *match, unsigned int match_len,
+			 unsigned int match_offset)
 {
 	const struct element *elem;
 
-	/* match_offset can't be smaller than 2, unless match_len is
-	 * zero, in which case match_offset must be zero as well.
-	 */
-	if (WARN_ON((match_len && match_offset < 2) ||
-		    (!match_len && match_offset)))
-		return NULL;
-
 	for_each_element_id(elem, eid, ies, len) {
-		if (elem->datalen >= match_offset - 2 + match_len &&
-		    !memcmp(elem->data + match_offset - 2, match, match_len))
-			return (void *)elem;
+		if (elem->datalen >= match_offset + match_len &&
+		    !memcmp(elem->data + match_offset, match, match_len))
+			return elem;
 	}
 
 	return NULL;
 }
-EXPORT_SYMBOL(cfg80211_find_ie_match);
+EXPORT_SYMBOL(cfg80211_find_elem_match);
 
-const u8 *cfg80211_find_vendor_ie(unsigned int oui, int oui_type,
-				  const u8 *ies, int len)
+const struct element *cfg80211_find_vendor_elem(unsigned int oui, int oui_type,
+						const u8 *ies,
+						unsigned int len)
 {
-	const u8 *ie;
+	const struct element *elem;
 	u8 match[] = { oui >> 16, oui >> 8, oui, oui_type };
 	int match_len = (oui_type < 0) ? 3 : sizeof(match);
 
 	if (WARN_ON(oui_type > 0xff))
 		return NULL;
 
-	ie = cfg80211_find_ie_match(WLAN_EID_VENDOR_SPECIFIC, ies, len,
-				    match, match_len, 2);
+	elem = cfg80211_find_elem_match(WLAN_EID_VENDOR_SPECIFIC, ies, len,
+					match, match_len, 0);
 
-	if (ie && (ie[1] < 4))
+	if (!elem || elem->datalen < 4)
 		return NULL;
 
-	return ie;
+	return elem;
 }
-EXPORT_SYMBOL(cfg80211_find_vendor_ie);
+EXPORT_SYMBOL(cfg80211_find_vendor_elem);
 
 static bool is_bss(struct cfg80211_bss *a, const u8 *bssid,
 		   const u8 *ssid, size_t ssid_len)
diff --git a/net/wireless/util.c b/net/wireless/util.c
index cd48cdd582c0..61fa33d0019e 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -776,7 +776,7 @@ unsigned int cfg80211_classify8021d(struct sk_buff *skb,
 }
 EXPORT_SYMBOL(cfg80211_classify8021d);
 
-const u8 *ieee80211_bss_get_ie(struct cfg80211_bss *bss, u8 ie)
+const struct element *ieee80211_bss_get_elem(struct cfg80211_bss *bss, u8 id)
 {
 	const struct cfg80211_bss_ies *ies;
 
@@ -784,9 +784,9 @@ const u8 *ieee80211_bss_get_ie(struct cfg80211_bss *bss, u8 ie)
 	if (!ies)
 		return NULL;
 
-	return cfg80211_find_ie(ie, ies->data, ies->len);
+	return cfg80211_find_elem(id, ies->data, ies->len);
 }
-EXPORT_SYMBOL(ieee80211_bss_get_ie);
+EXPORT_SYMBOL(ieee80211_bss_get_elem);
 
 void cfg80211_upload_connect_keys(struct wireless_dev *wdev)
 {
-- 
2.17.2

