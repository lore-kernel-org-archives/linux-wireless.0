Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:52339 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752920Ab3H0O7w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Aug 2013 10:59:52 -0400
Received: by mail-wg0-f51.google.com with SMTP id b12so2101658wgh.6
        for <linux-wireless@vger.kernel.org>; Tue, 27 Aug 2013 07:59:51 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, nbd@openwrt.org,
	johannes@sipsolutions.net
Subject: [PATCH 1/2] mac80211: add fixed_rate management to minstrel rc
Date: Tue, 27 Aug 2013 16:59:46 +0200
Message-Id: <1377615587-6015-2-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20130827_165956_124424_9CBA2F61)
In-Reply-To: <1377615587-6015-1-git-send-email-lorenzo.bianconi83@gmail.com>
References: <1377615587-6015-1-git-send-email-lorenzo.bianconi83@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add the capability to use a fixed modulation rate to minstrel rate controller

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
---
 net/mac80211/rc80211_minstrel.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/net/mac80211/rc80211_minstrel.c b/net/mac80211/rc80211_minstrel.c
index 8b5f7ef..7fa1b36 100644
--- a/net/mac80211/rc80211_minstrel.c
+++ b/net/mac80211/rc80211_minstrel.c
@@ -203,6 +203,15 @@ minstrel_update_stats(struct minstrel_priv *mp, struct minstrel_sta_info *mi)
 	memcpy(mi->max_tp_rate, tmp_tp_rate, sizeof(mi->max_tp_rate));
 	mi->max_prob_rate = tmp_prob_rate;
 
+#ifdef CONFIG_MAC80211_DEBUGFS
+	/* use fixed index if set */
+	if (mp->fixed_rate_idx != -1) {
+		mi->max_tp_rate[0] = mp->fixed_rate_idx;
+		mi->max_tp_rate[1] = mp->fixed_rate_idx;
+		mi->max_prob_rate = mp->fixed_rate_idx;
+	}
+#endif
+
 	/* Reset update timer */
 	mi->stats_update = jiffies;
 
@@ -310,6 +319,11 @@ minstrel_get_rate(void *priv, struct ieee80211_sta *sta,
 	/* increase sum packet counter */
 	mi->packet_count++;
 
+#ifdef CONFIG_MAC80211_DEBUGFS
+	if (mp->fixed_rate_idx != -1)
+		return;
+#endif
+
 	delta = (mi->packet_count * sampling_ratio / 100) -
 			(mi->sample_count + mi->sample_deferred / 2);
 
-- 
1.8.1.2

