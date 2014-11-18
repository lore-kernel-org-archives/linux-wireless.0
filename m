Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static.88-198-24-112.clients.your-server.de ([88.198.24.112]:35257
	"EHLO nbd.name" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932436AbaKRVfj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Nov 2014 16:35:39 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, j@w1.fi, thomas@net.t-labs.tu-berlin.de
Subject: [PATCH 3.18] mac80211: minstrel_ht: fix a crash in rate sorting
Date: Tue, 18 Nov 2014 22:35:31 +0100
Message-Id: <1416346531-61703-1-git-send-email-nbd@openwrt.org> (sfid-20141118_223542_144637_52590697)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The commit 5935839ad73583781b8bbe8d91412f6826e218a4
"mac80211: improve minstrel_ht rate sorting by throughput & probability"

introduced a crash on rate sorting that occurs when the rate added to
the sorting array is faster than all the previous rates. Due to an
off-by-one error, it reads the rate index from tp_list[-1], which
contains uninitialized stack garbage, and then uses the resulting index
for accessing the group rate stats, leading to a crash if the garbage
value is big enough.

Cc: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
Reported-by: Jouni Malinen <j@w1.fi>
Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 net/mac80211/rc80211_minstrel_ht.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index c50fd94..7b038a4 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -394,19 +394,16 @@ minstrel_ht_sort_best_tp_rates(struct minstrel_ht_sta *mi, u16 index,
 	cur_thr = mi->groups[cur_group].rates[cur_idx].cur_tp;
 	cur_prob = mi->groups[cur_group].rates[cur_idx].probability;
 
-	tmp_group = tp_list[j - 1] / MCS_GROUP_RATES;
-	tmp_idx = tp_list[j - 1] % MCS_GROUP_RATES;
-	tmp_thr = mi->groups[tmp_group].rates[tmp_idx].cur_tp;
-	tmp_prob = mi->groups[tmp_group].rates[tmp_idx].probability;
-
-	while (j > 0 && (cur_thr > tmp_thr ||
-	      (cur_thr == tmp_thr && cur_prob > tmp_prob))) {
-		j--;
+	do {
 		tmp_group = tp_list[j - 1] / MCS_GROUP_RATES;
 		tmp_idx = tp_list[j - 1] % MCS_GROUP_RATES;
 		tmp_thr = mi->groups[tmp_group].rates[tmp_idx].cur_tp;
 		tmp_prob = mi->groups[tmp_group].rates[tmp_idx].probability;
-	}
+		if (cur_thr < tmp_thr ||
+		    (cur_thr == tmp_thr && cur_prob <= tmp_prob))
+			break;
+		j--;
+	} while (j > 0);
 
 	if (j < MAX_THR_RATES - 1) {
 		memmove(&tp_list[j + 1], &tp_list[j], (sizeof(*tp_list) *
-- 
2.1.2

