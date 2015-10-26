Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f47.google.com ([209.85.215.47]:32792 "EHLO
	mail-lf0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753567AbbJZJmi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Oct 2015 05:42:38 -0400
Received: by lffv3 with SMTP id v3so140913500lff.0
        for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2015 02:42:37 -0700 (PDT)
Received: from di ([80.233.186.214])
        by smtp.gmail.com with ESMTPSA id a143sm1778058lfe.21.2015.10.26.02.42.36
        for <linux-wireless@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Oct 2015 02:42:36 -0700 (PDT)
Date: Mon, 26 Oct 2015 11:42:36 +0200
From: Dmitry Ivanov <dmitrijs.ivanovs@ubnt.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] Minstrel_ht: use lowest rate last
Message-Id: <20151026114236.233d1b54e6c08f3ab2b4c41a@ubnt.com> (sfid-20151026_104242_249814_7D17020A)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Minstrel_ht: use lowest rate last as in minstrel.
It should improve robustness in environments with non-stationary noise.

Signed-off-by: Dmitry Ivanov <dima@ubnt.com>
---
 net/mac80211/rc80211_minstrel_ht.c | 8 +++++++-
 net/mac80211/rc80211_minstrel_ht.h | 2 ++
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index 3928dbd..8abbdcc 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -906,7 +906,12 @@ minstrel_ht_update_rates(struct minstrel_priv *mp, struct minstrel_ht_sta *mi)
 		minstrel_ht_set_rate(mp, mi, rates, i++, mi->max_prob_rate);
 	}
 
-	rates->rate[i].idx = -1;
+	/* Use lowest rate last */
+	rates->rate[i].idx = mi->lowest_rix;
+	rates->rate[i].count = mp->max_retry;
+	rates->rate[i].count_cts = mp->max_retry;
+	rates->rate[i].count_rts = mp->max_retry;
+
 	rate_control_set_rates(mp->hw, mi->sta, rates);
 }
 
@@ -1127,6 +1132,7 @@ minstrel_ht_update_caps(void *priv, struct ieee80211_supported_band *sband,
 	memset(mi, 0, sizeof(*mi));
 
 	mi->sta = sta;
+	mi->lowest_rix = rate_lowest_index(sband, sta);
 	mi->last_stats_update = jiffies;
 
 	ack_dur = ieee80211_frame_duration(sband->band, 10, 60, 1, 1, 0);
diff --git a/net/mac80211/rc80211_minstrel_ht.h b/net/mac80211/rc80211_minstrel_ht.h
index e8b52a9..90b8e39 100644
--- a/net/mac80211/rc80211_minstrel_ht.h
+++ b/net/mac80211/rc80211_minstrel_ht.h
@@ -73,6 +73,8 @@ struct minstrel_ht_sta {
 	/* ampdu length (EWMA) */
 	unsigned int avg_ampdu_len;
 
+	unsigned int lowest_rix;
+
 	/* overall sorted rate set */
 	u16 max_tp_rate[MAX_THR_RATES];
 	u16 max_prob_rate;
-- 
2.1.4

