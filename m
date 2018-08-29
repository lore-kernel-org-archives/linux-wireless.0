Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41246 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727121AbeH3Bj3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 29 Aug 2018 21:39:29 -0400
From: Jouni Malinen <jouni@codeaurora.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
        Arunk Khandavalli <akhandav@codeaurora.org>,
        Jouni Malinen <jouni@codeaurora.org>
Subject: [PATCH] cfg80211: nl80211_update_ft_ies() to validate NL80211_ATTR_IE
Date: Thu, 30 Aug 2018 00:40:16 +0300
Message-Id: <1535578816-23020-1-git-send-email-jouni@codeaurora.org> (sfid-20180829_234043_473195_EBAC18D6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arunk Khandavalli <akhandav@codeaurora.org>

nl80211_update_ft_ies() tried to validate NL80211_ATTR_IE with
is_valid_ie_attr() before dereferencing it, but that helper function
returns true in case of NULL pointer (i.e., attribute not included).
This can result to dereferencing a NULL pointer. Fix that by explicitly
checking that NL80211_ATTR_IE is included.

Fixes: 355199e02b83 ("cfg80211: Extend support for IEEE 802.11r Fast BSS Transition")
Signed-off-by: Arunk Khandavalli <akhandav@codeaurora.org>
Signed-off-by: Jouni Malinen <jouni@codeaurora.org>
---
 net/wireless/nl80211.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 62e6679..65ec49d 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -12206,6 +12206,7 @@ static int nl80211_update_ft_ies(struct sk_buff *skb, struct genl_info *info)
 		return -EOPNOTSUPP;
 
 	if (!info->attrs[NL80211_ATTR_MDID] ||
+	    !info->attrs[NL80211_ATTR_IE] ||
 	    !is_valid_ie_attr(info->attrs[NL80211_ATTR_IE]))
 		return -EINVAL;
 
-- 
2.7.4
