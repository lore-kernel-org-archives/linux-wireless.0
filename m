Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:59499 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754753Ab3CENUV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Mar 2013 08:20:21 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH] mac80211/minstrel_ht: disable multiple consecutive sample attempts
Date: Tue,  5 Mar 2013 14:20:19 +0100
Message-Id: <1362489619-75636-1-git-send-email-nbd@openwrt.org> (sfid-20130305_142025_483996_1FCC124F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The last minstrel_ht changes increased the sampling frequency for
potentially useful rates to decrease the response time to rate
fluctuations. This caused an increase in sampling frequency that can
slightly reduce throughput, so this patch limits the sampling attempts
to one per rate instead of two.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 net/mac80211/rc80211_minstrel_ht.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index da4ec73..aa59539 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -480,7 +480,7 @@ minstrel_ht_tx_status(void *priv, struct ieee80211_supported_band *sband,
 
 	if (!mi->sample_wait && !mi->sample_tries && mi->sample_count > 0) {
 		mi->sample_wait = 16 + 2 * MINSTREL_TRUNC(mi->avg_ampdu_len);
-		mi->sample_tries = 2;
+		mi->sample_tries = 1;
 		mi->sample_count--;
 	}
 
-- 
1.8.0.2

