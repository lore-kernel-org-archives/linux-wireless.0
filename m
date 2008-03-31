Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:45233 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753132AbYDALsy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Apr 2008 07:48:54 -0400
Message-Id: <20080331172434.424899000@sipsolutions.net> (sfid-20080401_124930_081212_9BF1F180)
References: <20080331172258.541914000@sipsolutions.net>
Date: Mon, 31 Mar 2008 19:23:00 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Tomas Winkler <tomasw@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/6] mac80211: fix sta_info_destroy(NULL)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

sta_info_destroy(NULL) should be valid, but currently isn't because
the argument is dereferenced before the NULL check. There are no
users that currently pass in NULL, i.e. all check before calling the
function, but I want to change that.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/sta_info.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- everything.orig/net/mac80211/sta_info.c	2008-03-31 18:21:58.000000000 +0200
+++ everything/net/mac80211/sta_info.c	2008-03-31 18:22:24.000000000 +0200
@@ -129,16 +129,18 @@ struct sta_info *sta_info_get_by_idx(str
 
 void sta_info_destroy(struct sta_info *sta)
 {
-	struct ieee80211_local *local = sta->local;
+	struct ieee80211_local *local;
 	struct sk_buff *skb;
 	int i;
 	DECLARE_MAC_BUF(mbuf);
 
+	ASSERT_RTNL();
+	might_sleep();
+
 	if (!sta)
 		return;
 
-	ASSERT_RTNL();
-	might_sleep();
+	local = sta->local;
 
 	rate_control_remove_sta_debugfs(sta);
 	ieee80211_sta_debugfs_remove(sta);

-- 

