Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50104 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758710Ab3BTIkk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Feb 2013 03:40:40 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3.9 2/2] nl80211: remove TCP WoWLAN information
Date: Wed, 20 Feb 2013 09:40:34 +0100
Message-Id: <1361349634-9669-3-git-send-email-johannes@sipsolutions.net> (sfid-20130220_094046_168403_498D4677)
In-Reply-To: <1361349634-9669-1-git-send-email-johannes@sipsolutions.net>
References: <1361349634-9669-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Just like the radar information, the TCP WoWLAN capability
data can increase the wiphy information and make it too
big. Remove the TCP WoWLAN information; no driver supports
it and new userspace tools will be required as well.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/nl80211.c | 45 ---------------------------------------------
 1 file changed, 45 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index f4785a0..f8363b8 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -904,48 +904,6 @@ nla_put_failure:
 	return -ENOBUFS;
 }
 
-#ifdef CONFIG_PM
-static int nl80211_send_wowlan_tcp_caps(struct cfg80211_registered_device *rdev,
-					struct sk_buff *msg)
-{
-	const struct wiphy_wowlan_tcp_support *tcp = rdev->wiphy.wowlan.tcp;
-	struct nlattr *nl_tcp;
-
-	if (!tcp)
-		return 0;
-
-	nl_tcp = nla_nest_start(msg, NL80211_WOWLAN_TRIG_TCP_CONNECTION);
-	if (!nl_tcp)
-		return -ENOBUFS;
-
-	if (nla_put_u32(msg, NL80211_WOWLAN_TCP_DATA_PAYLOAD,
-			tcp->data_payload_max))
-		return -ENOBUFS;
-
-	if (nla_put_u32(msg, NL80211_WOWLAN_TCP_DATA_PAYLOAD,
-			tcp->data_payload_max))
-		return -ENOBUFS;
-
-	if (tcp->seq && nla_put_flag(msg, NL80211_WOWLAN_TCP_DATA_PAYLOAD_SEQ))
-		return -ENOBUFS;
-
-	if (tcp->tok && nla_put(msg, NL80211_WOWLAN_TCP_DATA_PAYLOAD_TOKEN,
-				sizeof(*tcp->tok), tcp->tok))
-		return -ENOBUFS;
-
-	if (nla_put_u32(msg, NL80211_WOWLAN_TCP_DATA_INTERVAL,
-			tcp->data_interval_max))
-		return -ENOBUFS;
-
-	if (nla_put_u32(msg, NL80211_WOWLAN_TCP_WAKE_PAYLOAD,
-			tcp->wake_payload_max))
-		return -ENOBUFS;
-
-	nla_nest_end(msg, nl_tcp);
-	return 0;
-}
-#endif
-
 static int nl80211_send_wiphy(struct sk_buff *msg, u32 portid, u32 seq, int flags,
 			      struct cfg80211_registered_device *dev)
 {
@@ -1320,9 +1278,6 @@ static int nl80211_send_wiphy(struct sk_buff *msg, u32 portid, u32 seq, int flag
 				goto nla_put_failure;
 		}
 
-		if (nl80211_send_wowlan_tcp_caps(dev, msg))
-			goto nla_put_failure;
-
 		nla_nest_end(msg, nl_wowlan);
 	}
 #endif
-- 
1.8.0

