Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:48933 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753713Ab3F1TEk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Jun 2013 15:04:40 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH] mac80211/minstrel_ht: fix cck rate sampling
Date: Fri, 28 Jun 2013 21:04:35 +0200
Message-Id: <1372446275-43012-1-git-send-email-nbd@openwrt.org> (sfid-20130628_210448_947236_983D286E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The CCK group needs special treatment to set the right flags and rate
index. Add this missing check to prevent setting broken rates for tx
packets.

Cc: stable@vger.kernel.org # 3.10
Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 net/mac80211/rc80211_minstrel_ht.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index 5b2d301..f5aed96 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -804,10 +804,18 @@ minstrel_ht_get_rate(void *priv, struct ieee80211_sta *sta, void *priv_sta,
 
 	sample_group = &minstrel_mcs_groups[sample_idx / MCS_GROUP_RATES];
 	info->flags |= IEEE80211_TX_CTL_RATE_CTRL_PROBE;
+	rate->count = 1;
+
+	if (sample_idx / MCS_GROUP_RATES == MINSTREL_CCK_GROUP) {
+		int idx = sample_idx % ARRAY_SIZE(mp->cck_rates);
+		rate->idx = mp->cck_rates[idx];
+		rate->flags = 0;
+		return;
+	}
+
 	rate->idx = sample_idx % MCS_GROUP_RATES +
 		    (sample_group->streams - 1) * MCS_GROUP_RATES;
 	rate->flags = IEEE80211_TX_RC_MCS | sample_group->flags;
-	rate->count = 1;
 }
 
 static void
-- 
1.8.0.2

