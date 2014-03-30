Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.neomailbox.net ([178.209.62.157]:17402 "EHLO
	s3.neomailbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752515AbaC3Ufj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Mar 2014 16:35:39 -0400
From: Antonio Quartulli <antonio@meshcoding.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: b.a.t.m.a.n@lists.open-mesh.org, linux-wireless@vger.kernel.org,
	devel@lists.open80211s.org,
	Antonio Quartulli <antonio@open-mesh.com>,
	Felix Fietkau <nbd@openwrt.org>
Subject: [RFCv2 4/6] mac80211: minstrel - implement get_expected_throughput() API
Date: Sun, 30 Mar 2014 22:35:02 +0200
Message-Id: <1396211704-4677-5-git-send-email-antonio@meshcoding.com> (sfid-20140330_223554_509991_81EFDCAD)
In-Reply-To: <1396211704-4677-1-git-send-email-antonio@meshcoding.com>
References: <1396211704-4677-1-git-send-email-antonio@meshcoding.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Antonio Quartulli <antonio@open-mesh.com>

Cc: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Antonio Quartulli <antonio@open-mesh.com>
---
 net/mac80211/rc80211_minstrel.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/net/mac80211/rc80211_minstrel.c b/net/mac80211/rc80211_minstrel.c
index 26fd94f..9434435d 100644
--- a/net/mac80211/rc80211_minstrel.c
+++ b/net/mac80211/rc80211_minstrel.c
@@ -657,6 +657,20 @@ minstrel_free(void *priv)
 	kfree(priv);
 }
 
+static u32
+minstrel_get_expected_throughput(void *priv, void *priv_sta,
+				 struct ieee80211_supported_band *sband)
+{
+	struct minstrel_sta_info *mi = priv_sta;
+	int idx = mi->max_tp_rate[0];
+	u32 bitrate, ret;
+
+	bitrate = sband->bitrates[mi->r[idx].rix].bitrate;
+	ret = bitrate * MINSTREL_TRUNC(mi->r[idx].probability * 1000) / 1000;
+
+	return ret;
+}
+
 const struct rate_control_ops mac80211_minstrel = {
 	.name = "minstrel",
 	.tx_status = minstrel_tx_status,
@@ -670,6 +684,7 @@ const struct rate_control_ops mac80211_minstrel = {
 	.add_sta_debugfs = minstrel_add_sta_debugfs,
 	.remove_sta_debugfs = minstrel_remove_sta_debugfs,
 #endif
+	.get_expected_throughput = minstrel_get_expected_throughput,
 };
 
 int __init
-- 
1.8.3.2

