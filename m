Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:39454 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756282AbbDXJNK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Apr 2015 05:13:10 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: enable hash table shrinking
Date: Fri, 24 Apr 2015 11:13:07 +0200
Message-Id: <1429866787-7872-1-git-send-email-johannes@sipsolutions.net> (sfid-20150424_111317_428690_9D83F390)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The hashtable behaviour change was merged into the tree
at about the same time as the mac80211 use of rhashtable,
but of course these don't really conflict in the normal
sense. Enable hash table shrinking now.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/sta_info.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 39893178a1a9..2880f2ae99ab 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -66,6 +66,7 @@
 
 static const struct rhashtable_params sta_rht_params = {
 	.nelem_hint = 3, /* start small */
+	.automatic_shrinking = true,
 	.head_offset = offsetof(struct sta_info, hash_node),
 	.key_offset = offsetof(struct sta_info, sta.addr),
 	.key_len = ETH_ALEN,
-- 
2.1.4

