Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f175.google.com ([74.125.82.175]:51107 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757180Ab3KMRla (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Nov 2013 12:41:30 -0500
Received: by mail-we0-f175.google.com with SMTP id t60so746157wes.6
        for <linux-wireless@vger.kernel.org>; Wed, 13 Nov 2013 09:41:29 -0800 (PST)
From: Karl Beldan <karl.beldan@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Felix Fietkau <nbd@openwrt.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>
Subject: [PATCH] mac80211: minstrel_ht: fix rates selection
Date: Wed, 13 Nov 2013 18:41:00 +0100
Message-Id: <1384364460-4452-1-git-send-email-karl.beldan@gmail.com> (sfid-20131113_184133_492589_692976D6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Karl Beldan <karl.beldan@rivierawaves.com>

When initializing rates selections starting indexes upon stats update,
the minstrel_sta->max_* rates should be 'group * MCS_GROUP_RATES + i'
not 'i'. This affects settings where one of the peers does not support
any of the rates of the group 0 (i.e. when ht_cap.mcs.rx_mask[0] == 0).

Signed-off-by: Karl Beldan <karl.beldan@rivierawaves.com>
---
 net/mac80211/rc80211_minstrel_ht.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index 88c932e..6c173a2 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -390,7 +390,8 @@ minstrel_ht_update_stats(struct minstrel_priv *mp, struct minstrel_ht_sta *mi)
 					mg->max_prob_rate = i;
 				if (!mi_rates_valid) {
 					mi->max_tp_rate = mi->max_tp_rate2 =
-						mi->max_prob_rate = i;
+						mi->max_prob_rate =
+						group * MCS_GROUP_RATES + i;
 					mi_rates_valid = true;
 				}
 				mg_rates_valid = true;
-- 
1.8.2

