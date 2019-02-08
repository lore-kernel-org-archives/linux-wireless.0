Return-Path: <SRS0=Ms0V=QP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD7E2C282CC
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Feb 2019 12:32:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A690D2073D
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Feb 2019 12:32:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727139AbfBHMcB (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 8 Feb 2019 07:32:01 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:47436 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726547AbfBHMcA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Feb 2019 07:32:00 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC4)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gs5K1-0007Gh-1b; Fri, 08 Feb 2019 13:31:57 +0100
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 1/4] cfg80211: add and use strongly typed element iteration macros
Date:   Fri,  8 Feb 2019 13:31:51 +0100
Message-Id: <20190208123154.22414-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.17.2
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

Rather than always iterating elements from frames with pure
u8 pointers, add a type "struct element" that encapsulates
the id/datalen/data format of them.

Then, add the element iteration macros
 * for_each_element
 * for_each_element_id
 * for_each_element_extid

which take, as their first 'argument', such a structure and
iterate through a given u8 array interpreting it as elements.

While at it and since we'll need it, also add
 * for_each_subelement
 * for_each_subelement_id
 * for_each_subelement_extid

which instead of taking data/length just take an outer element
and use its data/datalen.

Also add for_each_element_completed() to determine if any of
the loops above completed, i.e. it was able to parse all of
the elements successfully and no data remained.

Use for_each_element_id() in cfg80211_find_ie_match() as the
first user of this.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/linux/ieee80211.h | 53 +++++++++++++++++++++++++++++++++++++++
 net/wireless/scan.c       | 14 +++++------
 2 files changed, 59 insertions(+), 8 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 3b04e72315e1..371860f67885 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -3243,4 +3243,57 @@ static inline bool ieee80211_action_contains_tpc(struct sk_buff *skb)
 	return true;
 }
 
+struct element {
+	u8 id;
+	u8 datalen;
+	u8 data[];
+};
+
+/* element iteration helpers */
+#define for_each_element(element, _data, _datalen)			\
+	for (element = (void *)(_data);					\
+	     (u8 *)(_data) + (_datalen) - (u8 *)element >=		\
+		sizeof(*element) &&					\
+	     (u8 *)(_data) + (_datalen) - (u8 *)element >=		\
+		sizeof(*element) + element->datalen;			\
+	     element = (void *)(element->data + element->datalen))
+
+#define for_each_element_id(element, _id, data, datalen)		\
+	for_each_element(element, data, datalen)			\
+		if (element->id == (_id))
+
+#define for_each_element_extid(element, extid, data, datalen)		\
+	for_each_element(element, data, datalen)			\
+		if (element->id == WLAN_EID_EXTENSION &&		\
+		    element->datalen > 0 &&				\
+		    element->data[0] == (extid))
+
+#define for_each_subelement(sub, element)				\
+	for_each_element(sub, (element)->data, (element)->datalen)
+
+#define for_each_subelement_id(sub, id, element)			\
+	for_each_element_id(sub, id, (element)->data, (element)->datalen)
+
+#define for_each_subelement_extid(sub, extid, element)			\
+	for_each_element_extid(sub, extid, (element)->data, (element)->datalen)
+
+/**
+ * for_each_element_completed - determine if element parsing consumed all data
+ * @element: element pointer after for_each_element() or friends
+ * @data: same data pointer as passed to for_each_element() or friends
+ * @datalen: same data length as passed to for_each_element() or friends
+ *
+ * This function returns %true if all the data was parsed or considered
+ * while walking the elements. Only use this if your for_each_element()
+ * loop cannot be broken out of, otherwise it always returns %false.
+ *
+ * If some data was malformed, this returns %false since the last parsed
+ * element will not fill the whole remaining data.
+ */
+static inline bool for_each_element_completed(struct element *element,
+					      void *data, size_t datalen)
+{
+	return (u8 *)element == (u8 *)data + datalen;
+}
+
 #endif /* LINUX_IEEE80211_H */
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 5123667f4569..c7f64bb9c581 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -484,6 +484,8 @@ const u8 *cfg80211_find_ie_match(u8 eid, const u8 *ies, int len,
 				 const u8 *match, int match_len,
 				 int match_offset)
 {
+	const struct element *elem;
+
 	/* match_offset can't be smaller than 2, unless match_len is
 	 * zero, in which case match_offset must be zero as well.
 	 */
@@ -491,14 +493,10 @@ const u8 *cfg80211_find_ie_match(u8 eid, const u8 *ies, int len,
 		    (!match_len && match_offset)))
 		return NULL;
 
-	while (len >= 2 && len >= ies[1] + 2) {
-		if ((ies[0] == eid) &&
-		    (ies[1] + 2 >= match_offset + match_len) &&
-		    !memcmp(ies + match_offset, match, match_len))
-			return ies;
-
-		len -= ies[1] + 2;
-		ies += ies[1] + 2;
+	for_each_element_id(elem, eid, ies, len) {
+		if (elem->datalen >= match_offset - 2 + match_len &&
+		    !memcmp(elem->data + match_offset - 2, match, match_len))
+			return (void *)elem;
 	}
 
 	return NULL;
-- 
2.17.2

