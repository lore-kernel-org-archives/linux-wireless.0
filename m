Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40292 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751870Ab1KCI1K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Nov 2011 04:27:10 -0400
Subject: [PATCH] nl80211: fix HT capability attribute validation
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Nov 2011 09:27:01 +0100
Message-ID: <1320308821.3950.4.camel@jlt3.sipsolutions.net> (sfid-20111103_092716_362338_3AF0AF8B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Since the NL80211_ATTR_HT_CAPABILITY attribute is
used as a struct, it needs a minimum, not maximum
length. Enforce that properly. Not doing so could
potentially lead to reading after the buffer.

Cc: stable@vger.kernel.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/nl80211.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/net/wireless/nl80211.c	2011-11-03 09:00:25.000000000 +0100
+++ b/net/wireless/nl80211.c	2011-11-03 09:16:21.000000000 +0100
@@ -132,8 +132,7 @@ static const struct nla_policy nl80211_p
 	[NL80211_ATTR_MESH_CONFIG] = { .type = NLA_NESTED },
 	[NL80211_ATTR_SUPPORT_MESH_AUTH] = { .type = NLA_FLAG },
 
-	[NL80211_ATTR_HT_CAPABILITY] = { .type = NLA_BINARY,
-					 .len = NL80211_HT_CAPABILITY_LEN },
+	[NL80211_ATTR_HT_CAPABILITY] = { .len = NL80211_HT_CAPABILITY_LEN },
 
 	[NL80211_ATTR_MGMT_SUBTYPE] = { .type = NLA_U8 },
 	[NL80211_ATTR_IE] = { .type = NLA_BINARY,


