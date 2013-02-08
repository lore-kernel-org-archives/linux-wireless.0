Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60258 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946791Ab3BHRZ4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2013 12:25:56 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC 08/14] mac80211: fix ieee80211_change_chandef name
Date: Fri,  8 Feb 2013 18:25:38 +0100
Message-Id: <1360344344-15742-9-git-send-email-johannes@sipsolutions.net> (sfid-20130208_183140_598955_1B85A508)
In-Reply-To: <1360344344-15742-1-git-send-email-johannes@sipsolutions.net>
References: <1360344344-15742-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This should be called ieee80211_change_chanctx() since
it changes the channel context, not a chandef.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/chan.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index 038f249..8fc56e4 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -9,7 +9,7 @@
 #include "ieee80211_i.h"
 #include "driver-ops.h"
 
-static void ieee80211_change_chandef(struct ieee80211_local *local,
+static void ieee80211_change_chanctx(struct ieee80211_local *local,
 				     struct ieee80211_chanctx *ctx,
 				     const struct cfg80211_chan_def *chandef)
 {
@@ -49,7 +49,7 @@ ieee80211_find_chanctx(struct ieee80211_local *local,
 		if (!compat)
 			continue;
 
-		ieee80211_change_chandef(local, ctx, compat);
+		ieee80211_change_chanctx(local, ctx, compat);
 
 		return ctx;
 	}
@@ -172,7 +172,7 @@ static void ieee80211_recalc_chanctx_chantype(struct ieee80211_local *local,
 	if (WARN_ON_ONCE(!compat))
 		return;
 
-	ieee80211_change_chandef(local, ctx, compat);
+	ieee80211_change_chanctx(local, ctx, compat);
 }
 
 static void ieee80211_unassign_vif_chanctx(struct ieee80211_sub_if_data *sdata,
-- 
1.8.0

