Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:39490 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750937Ab3CPQAb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Mar 2013 12:00:31 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH 1/3] mac80211/minstrel_ht: improve rate selection stability
Date: Sat, 16 Mar 2013 17:00:25 +0100
Message-Id: <1363449627-10884-1-git-send-email-nbd@openwrt.org> (sfid-20130316_170036_803370_15F85A2C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Under load, otherwise stable rates can easily fluctuate because of
collisions. In my tests on a clean channel, the success probability of
the max throughput rate often stays somewhere between 90% and 100% under
load. This can cause some unnecessary switching to lower rates.
This patch improves stability by treating success probability values
between 90% and 100% the same.
In my tests on a 3x3 HT20 link with lots of TCP traffic, it improves the
average throughput by a few mbit/s.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 net/mac80211/rc80211_minstrel_ht.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index 749552b..90499c4 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -202,14 +202,23 @@ minstrel_ht_calc_tp(struct minstrel_ht_sta *mi, int group, int rate)
 	struct minstrel_rate_stats *mr;
 	unsigned int nsecs = 0;
 	unsigned int tp;
+	unsigned int prob;
 
 	mr = &mi->groups[group].rates[rate];
+	prob = mr->probability;
 
-	if (mr->probability < MINSTREL_FRAC(1, 10)) {
+	if (prob < MINSTREL_FRAC(1, 10)) {
 		mr->cur_tp = 0;
 		return;
 	}
 
+	/*
+	 * For the throughput calculation, limit the probability value to 90% to
+	 * account for collision related packet error rate fluctuation
+	 */
+	if (prob > MINSTREL_FRAC(9, 10))
+		prob = MINSTREL_FRAC(9, 10);
+
 	if (group != MINSTREL_CCK_GROUP)
 		nsecs = 1000 * mi->overhead / MINSTREL_TRUNC(mi->avg_ampdu_len);
 
-- 
1.8.0.2

