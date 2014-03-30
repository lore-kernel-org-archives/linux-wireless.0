Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.neomailbox.net ([178.209.62.157]:43188 "EHLO
	s3.neomailbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752523AbaC3Ufj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Mar 2014 16:35:39 -0400
From: Antonio Quartulli <antonio@meshcoding.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: b.a.t.m.a.n@lists.open-mesh.org, linux-wireless@vger.kernel.org,
	devel@lists.open80211s.org,
	Antonio Quartulli <antonio@open-mesh.com>,
	Felix Fietkau <nbd@openwrt.org>
Subject: [RFCv2 5/6] mac80211: minstrel_ht - implement get_expected_throughput() API
Date: Sun, 30 Mar 2014 22:35:03 +0200
Message-Id: <1396211704-4677-6-git-send-email-antonio@meshcoding.com> (sfid-20140330_223549_320482_49585135)
In-Reply-To: <1396211704-4677-1-git-send-email-antonio@meshcoding.com>
References: <1396211704-4677-1-git-send-email-antonio@meshcoding.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Antonio Quartulli <antonio@open-mesh.com>

Cc: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Antonio Quartulli <antonio@open-mesh.com>
---
 net/mac80211/rc80211_minstrel_ht.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index bccaf85..480f657 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -1031,6 +1031,24 @@ minstrel_ht_free(void *priv)
 	mac80211_minstrel.free(priv);
 }
 
+static u32
+minstrel_ht_get_expected_throughput(void *priv, void *priv_sta,
+				    struct ieee80211_supported_band *sband)
+{
+	struct minstrel_ht_sta_priv *msp = priv_sta;
+	struct minstrel_ht_sta *mi = &msp->ht;
+	int i, j;
+
+	if (!msp->is_ht)
+		return mac80211_minstrel.get_expected_throughput(priv, priv_sta,
+								 sband);
+
+	i = mi->max_tp_rate / MCS_GROUP_RATES;
+	j = mi->max_tp_rate % MCS_GROUP_RATES;
+
+	return mi->groups[i].rates[j].cur_tp;
+}
+
 static const struct rate_control_ops mac80211_minstrel_ht = {
 	.name = "minstrel_ht",
 	.tx_status = minstrel_ht_tx_status,
@@ -1045,6 +1063,7 @@ static const struct rate_control_ops mac80211_minstrel_ht = {
 	.add_sta_debugfs = minstrel_ht_add_sta_debugfs,
 	.remove_sta_debugfs = minstrel_ht_remove_sta_debugfs,
 #endif
+	.get_expected_throughput = minstrel_ht_get_expected_throughput,
 };
 
 
-- 
1.8.3.2

