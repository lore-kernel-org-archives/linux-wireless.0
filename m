Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh04.mail.saunalahti.fi ([62.142.5.110]:51479 "EHLO
	emh04.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755966Ab3H2KfE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Aug 2013 06:35:04 -0400
From: Luciano Coelho <luciano.coelho@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] cfg80211: use the correct macro to check for active monitor support
Date: Thu, 29 Aug 2013 13:26:57 +0300
Message-Id: <1377772017-24764-1-git-send-email-luciano.coelho@intel.com> (sfid-20130829_123509_300315_529A334C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use MONITOR_FLAG_ACTIVE, which is a flag mask, instead of
NL80211_MNTR_FLAG_ACTIVE, which is a flag index, when checking if the
hardware supports active monitoring.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---
 net/wireless/nl80211.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index af8d84a..626dc3b 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2421,7 +2421,7 @@ static int nl80211_set_interface(struct sk_buff *skb, struct genl_info *info)
 		change = true;
 	}
 
-	if (flags && (*flags & NL80211_MNTR_FLAG_ACTIVE) &&
+	if (flags && (*flags & MONITOR_FLAG_ACTIVE) &&
 	    !(rdev->wiphy.features & NL80211_FEATURE_ACTIVE_MONITOR))
 		return -EOPNOTSUPP;
 
@@ -2483,7 +2483,7 @@ static int nl80211_new_interface(struct sk_buff *skb, struct genl_info *info)
 				  info->attrs[NL80211_ATTR_MNTR_FLAGS] : NULL,
 				  &flags);
 
-	if (!err && (flags & NL80211_MNTR_FLAG_ACTIVE) &&
+	if (!err && (flags & MONITOR_FLAG_ACTIVE) &&
 	    !(rdev->wiphy.features & NL80211_FEATURE_ACTIVE_MONITOR))
 		return -EOPNOTSUPP;
 
-- 
1.7.10.4

