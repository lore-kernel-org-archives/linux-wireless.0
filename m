Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:60933 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752900AbaESJ2I (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 May 2014 05:28:08 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Antonio Quartulli <antonio@open-mesh.com>,
	Felix Fietkau <nbd@openwrt.org>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: minstrel-ht: small clarifications
Date: Mon, 19 May 2014 11:27:50 +0200
Message-Id: <1400491670-17865-1-git-send-email-johannes@sipsolutions.net> (sfid-20140519_112812_517344_55D117CB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Antonio and I were looking over this code and some things
didn't immediately make sense, so we came up with two small
clarifications.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/rc80211_minstrel_ht.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index bccaf854a309..4e916ad51a20 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -22,7 +22,7 @@
 #define MCS_NBITS (AVG_PKT_SIZE << 3)
 
 /* Number of symbols for a packet with (bps) bits per symbol */
-#define MCS_NSYMS(bps) ((MCS_NBITS + (bps) - 1) / (bps))
+#define MCS_NSYMS(bps) DIV_ROUND_UP(MCS_NBITS, (bps))
 
 /* Transmission time (nanoseconds) for a packet containing (syms) symbols */
 #define MCS_SYMBOL_TIME(sgi, syms)					\
@@ -226,8 +226,9 @@ minstrel_ht_calc_tp(struct minstrel_ht_sta *mi, int group, int rate)
 		nsecs = 1000 * mi->overhead / MINSTREL_TRUNC(mi->avg_ampdu_len);
 
 	nsecs += minstrel_mcs_groups[group].duration[rate];
-	tp = 1000000 * ((prob * 1000) / nsecs);
 
+	/* prob is scaled - see MINSTREL_FRAC above */
+	tp = 1000000 * ((prob * 1000) / nsecs);
 	mr->cur_tp = MINSTREL_TRUNC(tp);
 }
 
-- 
2.0.0.rc0

