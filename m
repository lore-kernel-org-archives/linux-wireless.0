Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52411 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752111AbYJOJyj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Oct 2008 05:54:39 -0400
Subject: [PATCH] nl80211: fix monitor flags
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 15 Oct 2008 11:54:04 +0200
Message-Id: <1224064444.27537.2.camel@johannes.berg> (sfid-20081015_115443_070469_C1AE23CE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

NLA_NESTED attributes cannot be empty, but we want to be able to
specify "no flags" (empty attribute) vs. "no change" (no attribute).
Therefore, remove the NLA_NESTED policy so it can work as an empty
attribute.

I guess I should have used a u32 for these flags instead, but we're
stuck with it now. Haven't noticed earlier because of a bug in iw...

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/wireless/nl80211.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- everything.orig/net/wireless/nl80211.c	2008-10-15 11:42:37.000000000 +0200
+++ everything/net/wireless/nl80211.c	2008-10-15 11:51:28.000000000 +0200
@@ -84,7 +84,7 @@ static struct nla_policy nl80211_policy[
 					       .len = NL80211_MAX_SUPP_RATES },
 	[NL80211_ATTR_STA_PLINK_ACTION] = { .type = NLA_U8 },
 	[NL80211_ATTR_STA_VLAN] = { .type = NLA_U32 },
-	[NL80211_ATTR_MNTR_FLAGS] = { .type = NLA_NESTED },
+	[NL80211_ATTR_MNTR_FLAGS] = { /* NLA_NESTED can't be empty */ },
 	[NL80211_ATTR_MESH_ID] = { .type = NLA_BINARY,
 				.len = IEEE80211_MAX_MESH_ID_LEN },
 	[NL80211_ATTR_MPATH_NEXT_HOP] = { .type = NLA_U32 },


