Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rhcavuit02.kulnet.kuleuven.be ([134.58.240.130]:48073 "EHLO
	cavuit02.kulnet.kuleuven.be" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753112AbbHEOC3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Aug 2015 10:02:29 -0400
From: Bertold Van den Bergh <bertold.vandenbergh@esat.kuleuven.be>
To: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Cc: Bertold Van den Bergh <bertold.vandenbergh@esat.kuleuven.be>
Subject: [PATCH 1/5] nl80211: Allow setting multicast rate on OCB interfaces
Date: Wed,  5 Aug 2015 16:02:21 +0200
Message-Id: <1438783341-27778-1-git-send-email-bertold.vandenbergh@esat.kuleuven.be> (sfid-20150805_160238_758535_7A3F46AA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Allow setting multicast rate on OCB interfaces.
Current behaviour results in EOPNOTSUPP when attempting this.

Signed-off-by: Bertold Van den Bergh <bertold.vandenbergh@esat.kuleuven.be>
---
 net/wireless/nl80211.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 76b4157..1f27efd 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -7390,7 +7390,8 @@ static int nl80211_set_mcast_rate(struct sk_buff *skb, struct genl_info *info)
 	int err;
 
 	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_ADHOC &&
-	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_MESH_POINT)
+	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_MESH_POINT &&
+	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_OCB)
 		return -EOPNOTSUPP;
 
 	if (!rdev->ops->set_mcast_rate)
-- 
1.9.1

