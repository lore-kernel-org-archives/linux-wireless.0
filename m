Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f175.google.com ([209.85.215.175]:46425 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756583Ab3J1S1U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Oct 2013 14:27:20 -0400
Received: by mail-ea0-f175.google.com with SMTP id l15so1919369eak.20
        for <linux-wireless@vger.kernel.org>; Mon, 28 Oct 2013 11:27:19 -0700 (PDT)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH 2/5] mac80211: DFS setup chandef for radar_event correctly
Date: Mon, 28 Oct 2013 19:27:01 +0100
Message-Id: <1382984824-3729-2-git-send-email-janusz.dziedzic@tieto.com> (sfid-20131028_192723_834138_5059DBBB)
In-Reply-To: <1382984824-3729-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1382984824-3729-1-git-send-email-janusz.dziedzic@tieto.com>
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
index f704415..c286d9b 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -2275,17 +2275,15 @@ void ieee80211_dfs_radar_detected_work(struct work_struct *work)
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

