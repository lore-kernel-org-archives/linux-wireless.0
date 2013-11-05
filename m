Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f176.google.com ([209.85.215.176]:41826 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754765Ab3KENtD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Nov 2013 08:49:03 -0500
Received: by mail-ea0-f176.google.com with SMTP id m14so886327eaj.7
        for <linux-wireless@vger.kernel.org>; Tue, 05 Nov 2013 05:49:02 -0800 (PST)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH v2 2/5] mac80211: DFS setup chandef for radar_event correctly
Date: Tue,  5 Nov 2013 14:48:46 +0100
Message-Id: <1383659329-11023-2-git-send-email-janusz.dziedzic@tieto.com> (sfid-20131105_144909_597980_11A30813)
In-Reply-To: <1383659329-11023-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1383659329-11023-1-git-send-email-janusz.dziedzic@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Setup chandef for radar event correctly, before we
will clear this in ieee80211_dfs_cac_cancel() function.

Without this patch mac80211 will report wrong channel
width in case we will get radar event during active CAC.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Reviewed-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 net/mac80211/util.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 6110be9..0571f49 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -2280,17 +2280,15 @@ void ieee80211_dfs_radar_detected_work(struct work_struct *work)
 {
 	struct ieee80211_local *local =
 		container_of(work, struct ieee80211_local, radar_detected_work);
-	struct cfg80211_chan_def chandef;
+	struct cfg80211_chan_def chandef = local->hw.conf.chandef;
 
 	ieee80211_dfs_cac_cancel(local);
 
 	if (local->use_chanctx)
 		/* currently not handled */
 		WARN_ON(1);
-	else {
-		chandef = local->hw.conf.chandef;
+	else
 		cfg80211_radar_event(local->hw.wiphy, &chandef, GFP_KERNEL);
-	}
 }
 
 void ieee80211_radar_detected(struct ieee80211_hw *hw)
-- 
1.7.9.5

