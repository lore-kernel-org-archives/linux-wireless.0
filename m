Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f187.google.com ([209.85.222.187]:49798 "EHLO
	mail-pz0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752781AbZFPXJk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jun 2009 19:09:40 -0400
Received: by pzk17 with SMTP id 17so2984444pzk.33
        for <linux-wireless@vger.kernel.org>; Tue, 16 Jun 2009 16:09:42 -0700 (PDT)
From: Andrey Yurovsky <andrey@cozybit.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	John Linville <linville@tuxdriver.com>,
	Andrey Yurovsky <andrey@cozybit.com>
Subject: [PATCH] cfg80211: allow setting station parameters in mesh
Date: Tue, 16 Jun 2009 16:09:37 -0700
Message-Id: <1245193777-23911-1-git-send-email-andrey@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mesh Point interfaces can also set parameters, for example plink_open is
used to manually establish peer links from user-space (currently via
iw).  Add Mesh Point to the check in nl80211_set_station.

Signed-off-by: Andrey Yurovsky <andrey@cozybit.com>
---
 net/wireless/nl80211.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index b28c641..54153c6 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1688,7 +1688,8 @@ static int nl80211_set_station(struct sk_buff *skb, struct genl_info *info)
 		goto out_rtnl;
 
 	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP &&
-	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP_VLAN) {
+	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP_VLAN &&
+	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_MESH_POINT) {
 		err = -EINVAL;
 		goto out;
 	}
-- 
1.5.6.3

