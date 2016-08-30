Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:48590 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756831AbcH3GAV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 30 Aug 2016 02:00:21 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: kamil.toman@gmail.com, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH] mac80211: TDLS: don't require beaconing for AP BW
Date: Tue, 30 Aug 2016 08:00:12 +0200
Message-Id: <1472536812-6659-1-git-send-email-johannes@sipsolutions.net> (sfid-20160830_080025_407141_0393906D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

Stop downgrading TDLS chandef when reaching the AP BW. The AP provides
the necessary regulatory protection in this case.

This fixes https://bugzilla.kernel.org/show_bug.cgi?id=153961

Reported-by: Kamil Toman <kamil.toman@gmail.com>
Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/tdls.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/tdls.c b/net/mac80211/tdls.c
index b5d28f14b9cf..afca7d103684 100644
--- a/net/mac80211/tdls.c
+++ b/net/mac80211/tdls.c
@@ -333,10 +333,11 @@ ieee80211_tdls_chandef_vht_upgrade(struct ieee80211_sub_if_data *sdata,
 	if (!uc.center_freq1)
 		return;
 
-	/* proceed to downgrade the chandef until usable or the same */
+	/* proceed to downgrade the chandef until usable or the same as AP BW */
 	while (uc.width > max_width ||
-	       !cfg80211_reg_can_beacon_relax(sdata->local->hw.wiphy, &uc,
-					      sdata->wdev.iftype))
+	       (uc.width > sta->tdls_chandef.width &&
+		!cfg80211_reg_can_beacon_relax(sdata->local->hw.wiphy, &uc,
+					       sdata->wdev.iftype)))
 		ieee80211_chandef_downgrade(&uc);
 
 	if (!cfg80211_chandef_identical(&uc, &sta->tdls_chandef)) {
-- 
2.8.1
