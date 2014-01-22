Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:40033 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878AbaAVJQ2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jan 2014 04:16:28 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:256)
	(Exim 4.82)
	(envelope-from <johannes@sipsolutions.net>)
	id 1W5tv9-0001Su-FS
	for linux-wireless@vger.kernel.org; Wed, 22 Jan 2014 10:16:27 +0100
Message-ID: <1390382185.4334.19.camel@jlt4.sipsolutions.net> (sfid-20140122_101632_398677_25D89820)
Subject: [PATCH] nl80211: check channel switch validity better
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 22 Jan 2014 10:16:25 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Before allowing userspace to initiate a channel switch, check
that it's actually connected in some sense. Also use a more
appropriate error code for the not connected case.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/nl80211.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 6e78c62..0c2ef08 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -5799,10 +5799,15 @@ static int nl80211_channel_switch(struct sk_buff *skb, struct genl_info *info)
 
 		/* useless if AP is not running */
 		if (!wdev->beacon_interval)
-			return -EINVAL;
+			return -ENOTCONN;
 		break;
 	case NL80211_IFTYPE_ADHOC:
+		if (!wdev->ssid_len)
+			return -ENOTCONN;
+		break;
 	case NL80211_IFTYPE_MESH_POINT:
+		if (!wdev->mesh_id_len)
+			return -ENOTCONN;
 		break;
 	default:
 		return -EOPNOTSUPP;
-- 
1.8.5.1



