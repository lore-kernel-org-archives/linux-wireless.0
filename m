Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.fem.tu-ilmenau.de ([141.24.220.54]:59233 "EHLO
        mail.fem.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752903AbcJDUby (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Oct 2016 16:31:54 -0400
From: Michael Braun <michael-dev@fami-braun.de>
To: johannes@sipsolutions.net
Cc: Michael Braun <michael-dev@fami-braun.de>,
        linux-wireless@vger.kernel.org, projekt-wlan@fem.tu-ilmenau.de
Subject: [PATCH 1/3] mac80211: remove unnecessary num_mcast_sta user
Date: Tue,  4 Oct 2016 22:31:47 +0200
Message-Id: <1475613109-17609-1-git-send-email-michael-dev@fami-braun.de> (sfid-20161004_223158_691662_AA1542B8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Checking for num_mcast_sta in __ieee80211_request_smps_ap() is unnecessary,
as sta list will be empty in this case anyway, so list_for_each_entry(sta,
...) will exit immediately.

Signed-off-by: Michael Braun <michael-dev@fami-braun.de>
---
 net/mac80211/cfg.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 543b1d4..24133f5 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2313,13 +2313,6 @@ int __ieee80211_request_smps_ap(struct ieee80211_sub_if_data *sdata,
 	    smps_mode == IEEE80211_SMPS_AUTOMATIC)
 		return 0;
 
-	 /* If no associated stations, there's no need to do anything */
-	if (!atomic_read(&sdata->u.ap.num_mcast_sta)) {
-		sdata->smps_mode = smps_mode;
-		ieee80211_queue_work(&sdata->local->hw, &sdata->recalc_smps);
-		return 0;
-	}
-
 	ht_dbg(sdata,
 	       "SMPS %d requested in AP mode, sending Action frame to %d stations\n",
 	       smps_mode, atomic_read(&sdata->u.ap.num_mcast_sta));
-- 
2.1.4
