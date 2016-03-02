Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:30993 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751821AbcCBV2u (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Mar 2016 16:28:50 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Arik Nemtsov <arik@wizery.com>,
	Arik Nemtsov <arikx.nemtsov@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 3/3] mac80211: recalc min_def chanctx even when chandef is identical
Date: Wed,  2 Mar 2016 23:28:33 +0200
Message-Id: <1456954113-4682-3-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160302_222853_585848_B0964FB9)
In-Reply-To: <1456954113-4682-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1456954113-4682-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

The min_def chanctx is affected not only by the current chandef, but
sometimes also by other stations on the vif. There's a valid scenario
where a TDLS peer can widen its BW, thereby causing the min_def
to increase.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/mac80211/chan.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index 2839811..74142d0 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -343,8 +343,10 @@ static void ieee80211_change_chanctx(struct ieee80211_local *local,
 				     struct ieee80211_chanctx *ctx,
 				     const struct cfg80211_chan_def *chandef)
 {
-	if (cfg80211_chandef_identical(&ctx->conf.def, chandef))
+	if (cfg80211_chandef_identical(&ctx->conf.def, chandef)) {
+		ieee80211_recalc_chanctx_min_def(local, ctx);
 		return;
+	}
 
 	WARN_ON(!cfg80211_chandef_compatible(&ctx->conf.def, chandef));
 
-- 
2.5.0

