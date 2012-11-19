Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36914 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752955Ab2KSQXD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2012 11:23:03 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: sujith@msujith.org, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: fix channel context warning on suspend
Date: Mon, 19 Nov 2012 17:23:31 +0100
Message-Id: <1353342211-21473-1-git-send-email-johannes@sipsolutions.net> (sfid-20121119_172307_851080_E363FEF2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

If suspending with an idle interface that isn't
actually operating, the channel context warning
in ieee80211_vif_release_channel() triggers. Fix
this by modifying the warning, it should only be
warning if we're not suspending and get here.

Reported-by: Sujith Manoharan <sujith@msujith.org>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/chan.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index a2b06d4..58220eb 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -376,7 +376,8 @@ int ieee80211_vif_use_channel(struct ieee80211_sub_if_data *sdata,
 
 void ieee80211_vif_release_channel(struct ieee80211_sub_if_data *sdata)
 {
-	WARN_ON(sdata->dev && netif_carrier_ok(sdata->dev));
+	WARN_ON(sdata->dev && netif_carrier_ok(sdata->dev) &&
+		!sdata->local->quiescing);
 
 	mutex_lock(&sdata->local->chanctx_mtx);
 	__ieee80211_vif_release_channel(sdata);
-- 
1.8.0

