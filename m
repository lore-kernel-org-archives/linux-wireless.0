Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f43.google.com ([74.125.83.43]:57422 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756362Ab3KFM4W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Nov 2013 07:56:22 -0500
Received: by mail-ee0-f43.google.com with SMTP id b47so2511277eek.16
        for <linux-wireless@vger.kernel.org>; Wed, 06 Nov 2013 04:56:21 -0800 (PST)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH v3 2/3] mac80211: DFS setup chandef for radar_event correctly
Date: Wed,  6 Nov 2013 13:55:52 +0100
Message-Id: <1383742553-28149-2-git-send-email-janusz.dziedzic@tieto.com> (sfid-20131106_135626_290423_FB6A863C)
In-Reply-To: <1383742553-28149-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1383742553-28149-1-git-send-email-janusz.dziedzic@tieto.com>
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

