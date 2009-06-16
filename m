Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f189.google.com ([209.85.216.189]:61826 "EHLO
	mail-px0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020AbZFPSbH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jun 2009 14:31:07 -0400
Received: by pxi27 with SMTP id 27so1132323pxi.33
        for <linux-wireless@vger.kernel.org>; Tue, 16 Jun 2009 11:31:09 -0700 (PDT)
From: Andrey Yurovsky <andrey@cozybit.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: John Linville <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Andrey Yurovsky <andrey@cozybit.com>
Subject: [PATCH] cfg80211: allow adding/deleting stations on mesh
Date: Tue, 16 Jun 2009 11:31:04 -0700
Message-Id: <1245177064-31861-1-git-send-email-andrey@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Commit b2a151a288 added a check that prevents adding or deleting
stations on non-AP interfaces.  Adding and deleting stations is
supported for Mesh Point interfaces, so add Mesh Point to that check as
well.

Signed-off-by: Andrey Yurovsky <andrey@cozybit.com>
---
 net/wireless/nl80211.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index e18856c..b28c641 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1763,7 +1763,8 @@ static int nl80211_new_station(struct sk_buff *skb, struct genl_info *info)
 		goto out_rtnl;
 
 	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP &&
-	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP_VLAN) {
+	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP_VLAN &&
+	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_MESH_POINT) {
 		err = -EINVAL;
 		goto out;
 	}
@@ -1812,7 +1813,8 @@ static int nl80211_del_station(struct sk_buff *skb, struct genl_info *info)
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

