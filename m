Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40294 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753760Ab2IKNZt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Sep 2012 09:25:49 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC v2 05/12] mac80211: check channel context methods
Date: Tue, 11 Sep 2012 15:26:16 +0200
Message-Id: <1347369983-12459-6-git-send-email-johannes@sipsolutions.net> (sfid-20120911_152554_183527_E3BB6E7B)
In-Reply-To: <1347369983-12459-1-git-send-email-johannes@sipsolutions.net>
References: <1347369983-12459-1-git-send-email-johannes@sipsolutions.net>
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

