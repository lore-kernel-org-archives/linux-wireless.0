Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:59401 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752277Ab3CBUUZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Mar 2013 15:20:25 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH 1/3] minstrel_ht: improve accuracy of throughput metric at high data rates
Date: Sat,  2 Mar 2013 21:20:12 +0100
Message-Id: <1362255614-30859-1-git-send-email-nbd@openwrt.org> (sfid-20130302_212028_262389_49A8C0D1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

At high data rates the average frame transmission durations are small
enough for rounding errors to matter, sometimes causing minstrel to use
slightly lower transmit rates than necessary.
To fix this, change the unit of the duration value to nanoseconds
instead of microseconds, and reorder the multiplications/divisions when
calculating the throughput metric so that they don't overflow or
truncate prematurely.
At 2-stream HT40 this makes TCP throughput a bit more stable.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 net/mac80211/rc80211_minstrel_ht.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index 3af141c..0b5cdd9 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -26,11 +26,11 @@
 /* Number of symbols for a packet with (bps) bits per symbol */
 #define MCS_NSYMS(bps) ((MCS_NBITS + (bps) - 1) / (bps))
 
-/* Transmission time for a packet containing (syms) symbols */
+/* Transmission time (nanoseconds) for a packet containing (syms) symbols */
 #define MCS_SYMBOL_TIME(sgi, syms)					\
 	(sgi ?								\
-	  ((syms) * 18 + 4) / 5 :	/* syms * 3.6 us */		\
-	  (syms) << 2			/* syms * 4 us */		\
+	  ((syms) * 18000 + 4000) / 5 :	/* syms * 3.6 us */		\
+	  ((syms) * 1000) << 2		/* syms * 4 us */		\
 	)
 
 /* Transmit duration for the raw data part of an average sized packet */
@@ -64,9 +64,9 @@
 }
 
 #define CCK_DURATION(_bitrate, _short, _len)		\
-	(10 /* SIFS */ +				\
+	(1000 * (10 /* SIFS */ +			\
 	 (_short ? 72 + 24 : 144 + 48 ) +		\
-	 (8 * (_len + 4) * 10) / (_bitrate))
+	 (8 * (_len + 4) * 10) / (_bitrate)))
 
 #define CCK_ACK_DURATION(_bitrate, _short)			\
 	(CCK_DURATION((_bitrate > 10 ? 20 : 10), false, 60) +	\
@@ -211,7 +211,8 @@ static void
 minstrel_ht_calc_tp(struct minstrel_ht_sta *mi, int group, int rate)
 {
 	struct minstrel_rate_stats *mr;
-	unsigned int usecs = 0;
+	unsigned int nsecs = 0;
+	unsigned int tp;
 
 	mr = &mi->groups[group].rates[rate];
 
@@ -221,10 +222,12 @@ minstrel_ht_calc_tp(struct minstrel_ht_sta *mi, int group, int rate)
 	}
 
 	if (group != MINSTREL_CCK_GROUP)
-		usecs = mi->overhead / MINSTREL_TRUNC(mi->avg_ampdu_len);
+		nsecs = 1000 * mi->overhead / MINSTREL_TRUNC(mi->avg_ampdu_len);
 
-	usecs += minstrel_mcs_groups[group].duration[rate];
-	mr->cur_tp = MINSTREL_TRUNC((1000000 / usecs) * mr->probability);
+	nsecs += minstrel_mcs_groups[group].duration[rate];
+	tp = 1000000 * ((mr->probability * 1000) / nsecs);
+
+	mr->cur_tp = MINSTREL_TRUNC(tp);
 }
 
 /*
@@ -536,7 +539,7 @@ minstrel_calc_retransmit(struct minstrel_priv *mp, struct minstrel_ht_sta *mi,
 	mr->retry_updated = true;
 
 	group = &minstrel_mcs_groups[index / MCS_GROUP_RATES];
-	tx_time_data = group->duration[index % MCS_GROUP_RATES] * ampdu_len;
+	tx_time_data = group->duration[index % MCS_GROUP_RATES] * ampdu_len / 1000;
 
 	/* Contention time for first 2 tries */
 	ctime = (t_slot * cw) >> 1;
-- 
1.8.0.2

