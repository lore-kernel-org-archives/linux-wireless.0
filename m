Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:39494 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751171Ab3CPQAb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Mar 2013 12:00:31 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH 2/3] mac80211/minstrel_ht: avoid useless sampling of high-probability slower rates
Date: Sat, 16 Mar 2013 17:00:26 +0100
Message-Id: <1363449627-10884-2-git-send-email-nbd@openwrt.org> (sfid-20130316_170038_198509_CDB0BDED)
In-Reply-To: <1363449627-10884-1-git-send-email-nbd@openwrt.org>
References: <1363449627-10884-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Slow rates that have >95% success probability do not need to be
monitored continuously. When the channel conditions change rapidly, the
slow sampling results are useless anyway. When conditions change slowly,
they will be monitored by gradual downgrading of the actively used
rates. This patch slightly improves throughput under good conditions.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 net/mac80211/rc80211_minstrel_ht.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index 90499c4..0fc9449 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -653,10 +653,10 @@ minstrel_get_sample_rate(struct minstrel_priv *mp, struct minstrel_ht_sta *mi)
 	if (sample_idx == mi->max_tp_rate)
 		return -1;
 	/*
-	 * When not using MRR, do not sample if the probability is already
-	 * higher than 95% to avoid wasting airtime
+	 * Do not sample if the probability is already higher than 95%
+	 * to avoid wasting airtime.
 	 */
-	if (!mp->has_mrr && (mr->probability > MINSTREL_FRAC(95, 100)))
+	if (mr->probability > MINSTREL_FRAC(95, 100))
 		return -1;
 
 	/*
-- 
1.8.0.2

