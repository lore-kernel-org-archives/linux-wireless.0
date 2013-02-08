Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:59060 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760023Ab3BHMiH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2013 07:38:07 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH 2/3] mac80211/minstrel_ht: remove the sampling bypass check for the lowest rate
Date: Fri,  8 Feb 2013 13:38:02 +0100
Message-Id: <1360327083-57298-2-git-send-email-nbd@openwrt.org> (sfid-20130208_133818_541168_3533B870)
In-Reply-To: <1360327083-57298-1-git-send-email-nbd@openwrt.org>
References: <1360327083-57298-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It's more of an unnecessary micro-optimization and it prevents switching
from long-GI to short-GI in HT20/single-stream for the lowest rate

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 net/mac80211/rc80211_minstrel_ht.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index 9f9c453..5bb316a 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -231,10 +231,6 @@ minstrel_ht_update_stats(struct minstrel_priv *mp, struct minstrel_ht_sta *mi)
 			if (!mr->cur_tp)
 				continue;
 
-			/* ignore the lowest rate of each single-stream group */
-			if (!i && minstrel_mcs_groups[group].streams == 1)
-				continue;
-
 			if ((mr->cur_tp > cur_prob_tp && mr->probability >
 			     MINSTREL_FRAC(3, 4)) || mr->probability > cur_prob) {
 				mg->max_prob_rate = index;
-- 
1.8.0.2

