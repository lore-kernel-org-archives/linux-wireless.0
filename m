Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:36841 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751202Ab3CARhp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Mar 2013 12:37:45 -0500
From: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, johannes.berg@intel.com,
	nbd@openwrt.org, thomas@net.t-labs.tu-berlin.de
Subject: [PATCH 6/7] mac80211: treat minstrel success probabilities below 10% as implausible
Date: Fri,  1 Mar 2013 18:37:35 +0100
Message-Id: <1362159456-39448-7-git-send-email-thomas@net.t-labs.tu-berlin.de> (sfid-20130301_183750_111123_76ED4780)
In-Reply-To: <1362159456-39448-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
References: <1362159456-39448-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Based on minstrel_ht this patch treats success probabilities below 10% as
implausible values for throughput calculation in minstrel's statistics.
Current throughput per rate with such a low success probability is reset
to 0 MBit/s.

Signed-off-by: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
---
 net/mac80211/rc80211_minstrel.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/rc80211_minstrel.c b/net/mac80211/rc80211_minstrel.c
index c28e60a..8af71f6 100644
--- a/net/mac80211/rc80211_minstrel.c
+++ b/net/mac80211/rc80211_minstrel.c
@@ -92,7 +92,6 @@ minstrel_update_stats(struct minstrel_priv *mp, struct minstrel_sta_info *mi)
 			mr->probability = minstrel_ewma(mr->probability,
 							mr->cur_prob,
 							EWMA_LEVEL);
-			mr->cur_tp = mr->probability * (1000000 / usecs);
 		} else
 			mr->sample_skipped++;
 
@@ -101,6 +100,12 @@ minstrel_update_stats(struct minstrel_priv *mp, struct minstrel_sta_info *mi)
 		mr->success = 0;
 		mr->attempts = 0;
 
+		/* Update throughput per rate, reset thr. below 10% success */
+		if (mr->probability < MINSTREL_FRAC(10, 100))
+			mr->cur_tp = 0;
+		else
+			mr->cur_tp = mr->probability * (1000000 / usecs);
+
 		/* Sample less often below the 10% chance of success.
 		 * Sample less often above the 95% chance of success. */
 		if (mr->probability > MINSTREL_FRAC(95, 100) ||
-- 
1.8.1.1

