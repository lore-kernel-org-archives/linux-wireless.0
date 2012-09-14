Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52621 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752811Ab2INMgl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Sep 2012 08:36:41 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 05/10] mac80211: check channel context methods
Date: Fri, 14 Sep 2012 14:37:08 +0200
Message-Id: <1347626233-21916-6-git-send-email-johannes@sipsolutions.net> (sfid-20120914_143650_014295_49988182)
In-Reply-To: <1347626233-21916-1-git-send-email-johannes@sipsolutions.net>
References: <1347626233-21916-1-git-send-email-johannes@sipsolutions.net>
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
index 9be3ef1..d709a5d 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -549,6 +549,13 @@ struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
 	if (WARN_ON(ops->sta_state && (ops->sta_add || ops->sta_remove)))
 		return NULL;
 
+	/* check all or no channel context operations exist */
+	i = !!ops->add_chanctx + !!ops->remove_chanctx +
+	    !!ops->change_chanctx + !!ops->assign_vif_chanctx +
+	    !!ops->unassign_vif_chanctx;
+	if (WARN_ON(i != 0 && i != 5))
+		return NULL;
+
 	/* Ensure 32-byte alignment of our private data and hw private data.
 	 * We use the wiphy priv data for both our ieee80211_local and for
 	 * the driver's private data
-- 
1.7.10.4

