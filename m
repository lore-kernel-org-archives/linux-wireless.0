Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:38436 "EHLO
	mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756669AbbJ2GM1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Oct 2015 02:12:27 -0400
Received: by wmeg8 with SMTP id g8so18554861wme.1
        for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2015 23:12:26 -0700 (PDT)
From: Ola Olsson <ola1olsson@gmail.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Ola Olsson <ola1olsson@gmail.com>,
	Ola Olsson <ola.olsson@sonymobile.com>
Subject: [PATCH] nl80211: Fix potential memory leak from parse_acl_data
Date: Thu, 29 Oct 2015 07:04:58 +0100
Message-Id: <1446098698-10079-1-git-send-email-ola1olsson@gmail.com> (sfid-20151029_071302_857449_02346E4C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If parse_acl_data succeeds but the subsequent parsing of smps
attributes fails, there will be a memory leak due to early returns.
Fix that.

Signed-off-by: Ola Olsson <ola.olsson@sonymobile.com>
---
 net/wireless/nl80211.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index d693c9d..40ef5d6 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3432,12 +3432,6 @@ static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
 					   wdev->iftype))
 		return -EINVAL;
 
-	if (info->attrs[NL80211_ATTR_ACL_POLICY]) {
-		params.acl = parse_acl_data(&rdev->wiphy, info);
-		if (IS_ERR(params.acl))
-			return PTR_ERR(params.acl);
-	}
-
 	if (info->attrs[NL80211_ATTR_SMPS_MODE]) {
 		params.smps_mode =
 			nla_get_u8(info->attrs[NL80211_ATTR_SMPS_MODE]);
@@ -3461,6 +3455,12 @@ static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
 		params.smps_mode = NL80211_SMPS_OFF;
 	}
 
+	if (info->attrs[NL80211_ATTR_ACL_POLICY]) {
+		params.acl = parse_acl_data(&rdev->wiphy, info);
+		if (IS_ERR(params.acl))
+			return PTR_ERR(params.acl);
+	}
+
 	wdev_lock(wdev);
 	err = rdev_start_ap(rdev, dev, &params);
 	if (!err) {
-- 
1.7.9.5

