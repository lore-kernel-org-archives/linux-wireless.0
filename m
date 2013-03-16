Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:39492 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755675Ab3CPQAb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Mar 2013 12:00:31 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH 3/3] mac80211/minstrel_ht: do not sample actively used rates
Date: Sat, 16 Mar 2013 17:00:27 +0100
Message-Id: <1363449627-10884-3-git-send-email-nbd@openwrt.org> (sfid-20130316_170037_565194_DB0E5122)
In-Reply-To: <1363449627-10884-2-git-send-email-nbd@openwrt.org>
References: <1363449627-10884-1-git-send-email-nbd@openwrt.org>
 <1363449627-10884-2-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

max_tp_rate2 and max_prob_rate tend to get used occasionally during
retransmission, which is more useful for the statistics than probing
with individual probe packets.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 net/mac80211/rc80211_minstrel_ht.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index 0fc9449..d2b264d 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -648,10 +648,13 @@ minstrel_get_sample_rate(struct minstrel_priv *mp, struct minstrel_ht_sta *mi)
 	/*
 	 * Sampling might add some overhead (RTS, no aggregation)
 	 * to the frame. Hence, don't use sampling for the currently
-	 * used max TP rate.
+	 * used rates.
 	 */
-	if (sample_idx == mi->max_tp_rate)
+	if (sample_idx == mi->max_tp_rate ||
+	    sample_idx == mi->max_tp_rate2 ||
+	    sample_idx == mi->max_prob_rate)
 		return -1;
+
 	/*
 	 * Do not sample if the probability is already higher than 95%
 	 * to avoid wasting airtime.
-- 
1.8.0.2

