Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51453 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752034Ab2G0LRv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jul 2012 07:17:51 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC 15/20] mac80211: convert ops checks to WARN_ON
Date: Fri, 27 Jul 2012 13:16:51 +0200
Message-Id: <1343387816-9414-16-git-send-email-johannes@sipsolutions.net> (sfid-20120727_131822_086563_DB7F5A73)
In-Reply-To: <1343387816-9414-1-git-send-email-johannes@sipsolutions.net>
References: <1343387816-9414-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's no need to BUG_ON when a driver registers
invalid operations, warn and return an error.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/main.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index f74e52a..820f717 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -545,6 +545,11 @@ struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
 	int priv_size, i;
 	struct wiphy *wiphy;
 
+	if (WARN_ON(!ops->tx || !ops->start || !ops->stop || !ops->config ||
+		    !ops->add_interface || !ops->remove_interface ||
+		    !ops->configure_filter))
+		return NULL;
+
 	if (WARN_ON(ops->sta_state && (ops->sta_add || ops->sta_remove)))
 		return NULL;
 
@@ -597,13 +602,6 @@ struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
 
 	local->hw.priv = (char *)local + ALIGN(sizeof(*local), NETDEV_ALIGN);
 
-	BUG_ON(!ops->tx);
-	BUG_ON(!ops->start);
-	BUG_ON(!ops->stop);
-	BUG_ON(!ops->config);
-	BUG_ON(!ops->add_interface);
-	BUG_ON(!ops->remove_interface);
-	BUG_ON(!ops->configure_filter);
 	local->ops = ops;
 
 	/* set up some defaults */
-- 
1.7.10.4

