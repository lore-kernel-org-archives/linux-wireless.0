Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51463 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752142Ab2G0LSA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jul 2012 07:18:00 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC 16/20] mac80211: check channel context methods
Date: Fri, 27 Jul 2012 13:16:52 +0200
Message-Id: <1343387816-9414-17-git-send-email-johannes@sipsolutions.net> (sfid-20120727_131831_950573_6C01E1D0)
In-Reply-To: <1343387816-9414-1-git-send-email-johannes@sipsolutions.net>
References: <1343387816-9414-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Verify that the channel context methods are
all assigned by the driver or not used.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/main.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 820f717..96abcf2 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -553,6 +553,13 @@ struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
 	if (WARN_ON(ops->sta_state && (ops->sta_add || ops->sta_remove)))
 		return NULL;
 
+	/* check all or no channel context operations exist */
+	i = !!ops->add_chanctx + !!ops->remove_chanctx +
+	    !!ops->change_chantype + !!ops->assign_vif_chanctx +
+	    !!ops->unassign_vif_chanctx;
+	if (WARN_ON(i != 0 && i != 5))
+		return NULL;
+
 	/* Ensure 32-byte alignment of our private data and hw private data.
 	 * We use the wiphy priv data for both our ieee80211_local and for
 	 * the driver's private data
-- 
1.7.10.4

