Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:34244 "EHLO
	mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358AbbLKUFn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Dec 2015 15:05:43 -0500
Received: by mail-wm0-f44.google.com with SMTP id c17so24392408wmd.1
        for <linux-wireless@vger.kernel.org>; Fri, 11 Dec 2015 12:05:43 -0800 (PST)
From: Ola Olsson <ola1olsson@gmail.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Ola Olsson <ola1olsson@gmail.com>,
	Ola Olsson <ola.olsson@sonymobile.com>
Subject: [PATCH] nl80211: Fix potential memory leak in nl80211_connect
Date: Fri, 11 Dec 2015 21:04:52 +0100
Message-Id: <1449864292-24509-1-git-send-email-ola1olsson@gmail.com> (sfid-20151211_210548_307667_272C1A08)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Free cached keys if the last early return path is taken.

Signed-off-by: Ola Olsson <ola.olsson@sonymobile.com>
---
 net/wireless/nl80211.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index c71e274..4b5ff71 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -7941,8 +7941,10 @@ static int nl80211_connect(struct sk_buff *skb, struct genl_info *info)
 	if (nla_get_flag(info->attrs[NL80211_ATTR_USE_RRM])) {
 		if (!(rdev->wiphy.features &
 		      NL80211_FEATURE_DS_PARAM_SET_IE_IN_PROBES) ||
-		    !(rdev->wiphy.features & NL80211_FEATURE_QUIET))
+		    !(rdev->wiphy.features & NL80211_FEATURE_QUIET)) {
+			kzfree(connkeys);
 			return -EINVAL;
+		}
 		connect.flags |= ASSOC_REQ_USE_RRM;
 	}
 
-- 
1.7.9.5

