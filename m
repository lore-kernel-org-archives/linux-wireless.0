Return-Path: <SRS0=RvtO=QS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 350B3C282CE
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 14:29:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0FA2120675
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 14:29:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729979AbfBKO3U (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 11 Feb 2019 09:29:20 -0500
Received: from mail.w1.fi ([212.71.239.96]:36126 "EHLO
        li674-96.members.linode.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729402AbfBKO3T (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Feb 2019 09:29:19 -0500
Received: from localhost (localhost [127.0.0.1])
        by li674-96.members.linode.com (Postfix) with ESMTP id AEF9511C62;
        Mon, 11 Feb 2019 14:29:17 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at w1.fi
Received: from li674-96.members.linode.com ([127.0.0.1])
        by localhost (mail.w1.fi [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id EqK6VRwyLBTa; Mon, 11 Feb 2019 14:29:16 +0000 (UTC)
From:   Jouni Malinen <j@w1.fi>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>
Subject: [PATCH] cfg80211: Use const more consistently in for_each_element macros
Date:   Mon, 11 Feb 2019 16:29:04 +0200
Message-Id: <1549895344-15021-1-git-send-email-j@w1.fi>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Enforce the first argument to be a correct type of a pointer to struct
element and avoid unnecessary typecasts from const to non-const pointers
(the change in validate_ie_attr() is needed to make this part work). In
addition, avoid signed/unsigned comparison within for_each_element() and
mark struct element packed just in case.

Signed-off-by: Jouni Malinen <j@w1.fi>
---
 include/linux/ieee80211.h | 18 +++++++++---------
 net/wireless/nl80211.c    |  2 +-
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 8da5ba9..8584c14 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -3284,16 +3284,16 @@ struct element {
 	u8 id;
 	u8 datalen;
 	u8 data[];
-};
+} __packed;
 
 /* element iteration helpers */
-#define for_each_element(element, _data, _datalen)			\
-	for (element = (void *)(_data);					\
-	     (u8 *)(_data) + (_datalen) - (u8 *)element >=		\
-		sizeof(*element) &&					\
-	     (u8 *)(_data) + (_datalen) - (u8 *)element >=		\
-		sizeof(*element) + element->datalen;			\
-	     element = (void *)(element->data + element->datalen))
+#define for_each_element(_elem, _data, _datalen)			\
+	for (_elem = (const struct element *)(_data);			\
+	     (const u8 *)(_data) + (_datalen) - (const u8 *)_elem >=	\
+		(int)sizeof(*_elem) &&					\
+	     (const u8 *)(_data) + (_datalen) - (const u8 *)_elem >=	\
+		(int)sizeof(*_elem) + _elem->datalen;			\
+	     _elem = (const struct element *)(_elem->data + _elem->datalen))
 
 #define for_each_element_id(element, _id, data, datalen)		\
 	for_each_element(element, data, datalen)			\
@@ -3330,7 +3330,7 @@ struct element {
 static inline bool for_each_element_completed(const struct element *element,
 					      const void *data, size_t datalen)
 {
-	return (u8 *)element == (u8 *)data + datalen;
+	return (const u8 *)element == (const u8 *)data + datalen;
 }
 
 #endif /* LINUX_IEEE80211_H */
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 5d85f60..80878b4 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -205,7 +205,7 @@ static int validate_ie_attr(const struct nlattr *attr,
 {
 	const u8 *data = nla_data(attr);
 	unsigned int len = nla_len(attr);
-	struct element *elem;
+	const struct element *elem;
 
 	for_each_element(elem, data, len) {
 		/* nothing */
-- 
2.7.4

