Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:46874 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751258AbeDTGL5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 20 Apr 2018 02:11:57 -0400
From: Srinivas Dasari <dasaris@codeaurora.org>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Srinivas Dasari <dasaris@codeaurora.org>
Subject: [PATCH] nl80211: Free connkeys on external authentication failure
Date: Fri, 20 Apr 2018 11:41:14 +0530
Message-Id: <1524204674-13997-1-git-send-email-dasaris@codeaurora.org> (sfid-20180420_081201_874309_DCEE366A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The failure scenario while processing
NL80211_ATTR_EXTERNAL_AUTH_SUPPORT does not free
the connkeys. This commit addresses the same.

Signed-off-by: Srinivas Dasari <dasaris@codeaurora.org>
---
 net/wireless/nl80211.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index ff28f8f..a052693 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -9214,6 +9214,7 @@ static int nl80211_connect(struct sk_buff *skb, struct genl_info *info)
 
 	if (nla_get_flag(info->attrs[NL80211_ATTR_EXTERNAL_AUTH_SUPPORT])) {
 		if (!info->attrs[NL80211_ATTR_SOCKET_OWNER]) {
+			kzfree(connkeys);
 			GENL_SET_ERR_MSG(info,
 					 "external auth requires connection ownership");
 			return -EINVAL;
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
