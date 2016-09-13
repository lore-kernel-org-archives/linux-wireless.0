Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:36787 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751488AbcIMOaP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Sep 2016 10:30:15 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] cfg80211: disallow shared key authentication with key index 4
Date: Tue, 13 Sep 2016 16:29:02 +0200
Message-Id: <1473776942-30433-1-git-send-email-johannes@sipsolutions.net> (sfid-20160913_163721_876287_1CC4575A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Key index 4 can only be used for an IGTK, so the range checks
for shared key authentication should treat 4 as an error, fix
that in the code.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/mlme.c    | 2 +-
 net/wireless/nl80211.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index c284d883c349..d6abb0704db5 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -222,7 +222,7 @@ int cfg80211_mlme_auth(struct cfg80211_registered_device *rdev,
 	ASSERT_WDEV_LOCK(wdev);
 
 	if (auth_type == NL80211_AUTHTYPE_SHARED_KEY)
-		if (!key || !key_len || key_idx < 0 || key_idx > 4)
+		if (!key || !key_len || key_idx < 0 || key_idx > 3)
 			return -EINVAL;
 
 	if (wdev->current_bss &&
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index aca8f820d155..739d0a780d83 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -7391,7 +7391,7 @@ static int nl80211_authenticate(struct sk_buff *skb, struct genl_info *info)
 		    (key.p.cipher != WLAN_CIPHER_SUITE_WEP104 ||
 		     key.p.key_len != WLAN_KEY_LEN_WEP104))
 			return -EINVAL;
-		if (key.idx > 4)
+		if (key.idx > 3)
 			return -EINVAL;
 	} else {
 		key.p.key_len = 0;
-- 
2.8.1
