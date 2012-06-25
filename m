Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:35564 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410Ab2FYHsS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jun 2012 03:48:18 -0400
Received: by wgbdr13 with SMTP id dr13so3811932wgb.1
        for <linux-wireless@vger.kernel.org>; Mon, 25 Jun 2012 00:48:17 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] mac80211: don't require associated->beacon_ies for ps
Date: Mon, 25 Jun 2012 10:48:25 +0300
Message-Id: <1340610505-7713-1-git-send-email-eliad@wizery.com> (sfid-20120625_094822_312359_214E82A4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

beacon_ies is needed only in order to extract the dtim
period. However, even if it's missing we can still enter
ps with dtim=1 (which also happens if the TIM ie is invalid).

Most drivers don't use conf.max_sleep_period/ps_dtim_period
anyway, and this check prevents them from entering ps if
they don't have beacon (but only probe response), even though
the beacon is not needed at all.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 net/mac80211/mlme.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 339b686..426877d 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -903,9 +903,6 @@ static bool ieee80211_powersave_allowed(struct ieee80211_sub_if_data *sdata)
 	if (!mgd->associated)
 		return false;
 
-	if (!mgd->associated->beacon_ies)
-		return false;
-
 	if (mgd->flags & (IEEE80211_STA_BEACON_POLL |
 			  IEEE80211_STA_CONNECTION_POLL))
 		return false;
-- 
1.7.6.401.g6a319

