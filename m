Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:63574 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756108Ab0GAPTX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Jul 2010 11:19:23 -0400
Received: by pvc7 with SMTP id 7so859300pvc.19
        for <linux-wireless@vger.kernel.org>; Thu, 01 Jul 2010 08:19:23 -0700 (PDT)
From: tom.leiming@gmail.com
To: nbd@openwrt.org
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH] minstrel_ht: fix updating rate with best probability
Date: Thu,  1 Jul 2010 23:18:42 +0800
Message-Id: <1277997522-3478-1-git-send-email-tom.leiming@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ming Lei <tom.leiming@gmail.com>

The throughput should be considered when updating rate
with best probability.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 net/mac80211/rc80211_minstrel_ht.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index 52c8503..8fba6f4 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -240,6 +240,7 @@ minstrel_ht_update_stats(struct minstrel_priv *mp, struct minstrel_ht_sta *mi)
 			     MINSTREL_FRAC(3, 4)) || mr->probability > cur_prob) {
 				mg->max_prob_rate = index;
 				cur_prob = mr->probability;
+				cur_prob_tp = mr->cur_tp;
 			}
 
 			if (mr->cur_tp > cur_tp) {
@@ -275,6 +276,7 @@ minstrel_ht_update_stats(struct minstrel_priv *mp, struct minstrel_ht_sta *mi)
 		    minstrel_mcs_groups[group].streams == 1) {
 			mi->max_prob_rate = mg->max_prob_rate;
 			cur_prob = mr->cur_prob;
+			cur_prob_tp = mr->cur_tp;
 		}
 
 		mr = minstrel_get_ratestats(mi, mg->max_tp_rate);
-- 
1.6.2.5

