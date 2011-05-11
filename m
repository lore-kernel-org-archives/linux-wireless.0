Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52784 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752718Ab1EKCAv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2011 22:00:51 -0400
Received: by pzk9 with SMTP id 9so29390pzk.19
        for <linux-wireless@vger.kernel.org>; Tue, 10 May 2011 19:00:51 -0700 (PDT)
From: Daniel Halperin <dhalperi@cs.washington.edu>
Content-Type: text/plain; charset=us-ascii
Subject: [PATCH] mac80211: fix contention time computation in minstrel, minstrel_ht
Date: Tue, 10 May 2011 19:00:45 -0700
Message-Id: <263D03B2-F1B6-4DFB-83DB-2CC9253A29A5@cs.washington.edu> (sfid-20110511_040055_157384_0A44ABCF)
To: linux-wireless <linux-wireless@vger.kernel.org>, nbd@openwrt.org
Mime-Version: 1.0 (Apple Message framework v1084)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When transmitting a frame, the transmitter waits a random number of
slots between 0 and cw. Thus, the contention time is (cw / 2) * t_slot
which we can represent instead as (cw * t_slot) >> 1. Also fix a few
other accounting bugs around contention time, and add comments.

Signed-off-by: Daniel Halperin <dhalperi@cs.washington.edu>
---
 net/mac80211/rc80211_minstrel.c    |    4 ++--
 net/mac80211/rc80211_minstrel_ht.c |   27 +++++++++++++++++++++------
 2 files changed, 23 insertions(+), 8 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel.c b/net/mac80211/rc80211_minstrel.c
index 778c604..8adac67 100644
--- a/net/mac80211/rc80211_minstrel.c
+++ b/net/mac80211/rc80211_minstrel.c
@@ -417,8 +417,8 @@ minstrel_rate_init(void *priv, struct ieee80211_supported_band *sband,
 			tx_time_single = mr->ack_time + mr->perfect_tx_time;
 
 			/* contention window */
-			tx_time_single += t_slot + min(cw, mp->cw_max);
-			cw = (cw << 1) | 1;
+			tx_time_single += (t_slot * cw) >> 1;
+			cw = min((cw << 1) | 1, mp->cw_max);
 
 			tx_time += tx_time_single;
 			tx_time_cts += tx_time_single + mi->sp_ack_dur;
diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index c06aa3a..333b511 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -464,6 +464,7 @@ minstrel_calc_retransmit(struct minstrel_priv *mp, struct minstrel_ht_sta *mi,
 	const struct mcs_group *group;
 	unsigned int tx_time, tx_time_rtscts, tx_time_data;
 	unsigned int cw = mp->cw_min;
+	unsigned int ctime = 0;
 	unsigned int t_slot = 9; /* FIXME */
 	unsigned int ampdu_len = MINSTREL_TRUNC(mi->avg_ampdu_len);
 
@@ -480,13 +481,27 @@ minstrel_calc_retransmit(struct minstrel_priv *mp, struct minstrel_ht_sta *mi,
 
 	group = &minstrel_mcs_groups[index / MCS_GROUP_RATES];
 	tx_time_data = group->duration[index % MCS_GROUP_RATES] * ampdu_len;
-	tx_time = 2 * (t_slot + mi->overhead + tx_time_data);
-	tx_time_rtscts = 2 * (t_slot + mi->overhead_rtscts + tx_time_data);
+
+	/* Contention time for first 2 tries */
+	ctime = (t_slot * cw) >> 1;
+	cw = min((cw << 1) | 1, mp->cw_max);
+	ctime += (t_slot * cw) >> 1;
+	cw = min((cw << 1) | 1, mp->cw_max);
+
+	/* Total TX time for data and Contention after first 2 tries */
+	tx_time = ctime + 2 * (mi->overhead + tx_time_data);
+	tx_time_rtscts = ctime + 2 * (mi->overhead_rtscts + tx_time_data);
+
+	/* See how many more tries we can fit inside segment size */
 	do {
-		cw = (cw << 1) | 1;
-		cw = min(cw, mp->cw_max);
-		tx_time += cw + t_slot + mi->overhead;
-		tx_time_rtscts += cw + t_slot + mi->overhead_rtscts;
+		/* Contention time for this try */
+		ctime = (t_slot * cw) >> 1;
+		cw = min((cw << 1) | 1, mp->cw_max);
+
+		/* Total TX time after this try */
+		tx_time += ctime + mi->overhead + tx_time_data;
+		tx_time_rtscts += ctime + mi->overhead_rtscts + tx_time_data;
+
 		if (tx_time_rtscts < mp->segment_size)
 			mr->retry_count_rtscts++;
 	} while ((tx_time < mp->segment_size) &&
-- 
1.7.0.4


