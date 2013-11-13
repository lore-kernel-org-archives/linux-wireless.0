Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:41393 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966Ab3KMWHo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Nov 2013 17:07:44 -0500
Received: by mail-wi0-f170.google.com with SMTP id f4so2108700wiw.1
        for <linux-wireless@vger.kernel.org>; Wed, 13 Nov 2013 14:07:43 -0800 (PST)
From: Karl Beldan <karl.beldan@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Felix Fietkau <nbd@openwrt.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>
Subject: [PATCH v2] mac80211: minstrel_ht: fix rates selection
Date: Wed, 13 Nov 2013 23:07:07 +0100
Message-Id: <1384380427-12950-1-git-send-email-karl.beldan@gmail.com> (sfid-20131113_230748_688272_51001DCB)
In-Reply-To: <5283ED31.1050606@openwrt.org>
References: <5283ED31.1050606@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Karl Beldan <karl.beldan@rivierawaves.com>

When initializing rates selections starting indexes upon stats update,
the minstrel_sta->max_* rates should be 'group * MCS_GROUP_RATES + i'
not 'i'. This affects settings where one of the peers does not support
any of the rates of the group 0 (i.e. when ht_cap.mcs.rx_mask[0] == 0).

Signed-off-by: Karl Beldan <karl.beldan@rivierawaves.com>
---
 net/mac80211/rc80211_minstrel_ht.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index 53db728..e2a57e2 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -277,13 +277,15 @@ minstrel_ht_update_stats(struct minstrel_priv *mp, struct minstrel_ht_sta *mi)
 			if (!(mg->supported & BIT(i)))
 				continue;
 
+			index = MCS_GROUP_RATES * group + i;
+
 			/* initialize rates selections starting indexes */
 			if (!mg_rates_valid) {
 				mg->max_tp_rate = mg->max_tp_rate2 =
 					mg->max_prob_rate = i;
 				if (!mi_rates_valid) {
 					mi->max_tp_rate = mi->max_tp_rate2 =
-						mi->max_prob_rate = i;
+						mi->max_prob_rate = index;
 					mi_rates_valid = true;
 				}
 				mg_rates_valid = true;
@@ -291,7 +293,6 @@ minstrel_ht_update_stats(struct minstrel_priv *mp, struct minstrel_ht_sta *mi)
 
 			mr = &mg->rates[i];
 			mr->retry_updated = false;
-			index = MCS_GROUP_RATES * group + i;
 			minstrel_calc_rate_ewma(mr);
 			minstrel_ht_calc_tp(mi, group, i);
 
-- 
1.8.2

