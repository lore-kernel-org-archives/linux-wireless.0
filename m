Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:56823 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753283Ab3CCLtz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Mar 2013 06:49:55 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH 2/2] mac80211/minstrel_ht: fix spacing between sample attempts
Date: Sun,  3 Mar 2013 12:49:52 +0100
Message-Id: <1362311392-83648-2-git-send-email-nbd@openwrt.org> (sfid-20130303_125005_735877_A914CD40)
In-Reply-To: <1362311392-83648-1-git-send-email-nbd@openwrt.org>
References: <1362311392-83648-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A sample attempt should only count in mi->sample_tries if the sample
attempt wasn't skipped based on slower rate criteria.
This patch increases the sampling frequency for potentially desirable
rates and thus enables faster recovery from interference or collisions.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 net/mac80211/rc80211_minstrel_ht.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index 1b69924..da4ec73 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -640,7 +640,6 @@ minstrel_get_sample_rate(struct minstrel_priv *mp, struct minstrel_ht_sta *mi)
 	if (!mi->sample_tries)
 		return -1;
 
-	mi->sample_tries--;
 	mg = &mi->groups[mi->sample_group];
 	sample_idx = sample_table[mg->column][mg->index];
 	mr = &mg->rates[sample_idx];
@@ -677,6 +676,7 @@ minstrel_get_sample_rate(struct minstrel_priv *mp, struct minstrel_ht_sta *mi)
 		if (mi->sample_slow++ > 2)
 			return -1;
 	}
+	mi->sample_tries--;
 
 	return sample_idx;
 }
-- 
1.8.0.2

