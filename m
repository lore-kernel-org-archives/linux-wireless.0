Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.neomailbox.net ([178.209.62.157]:45039 "EHLO
	s3.neomailbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754599AbaDNOEG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Apr 2014 10:04:06 -0400
From: Antonio Quartulli <antonio@meshcoding.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: b.a.t.m.a.n@lists.open-mesh.org, linux-wireless@vger.kernel.org,
	devel@lists.open80211s.org,
	Antonio Quartulli <antonio@open-mesh.com>,
	Felix Fietkau <nbd@openwrt.org>
Subject: [PATCH 5/7] mac80211: minstrel - implement get_expected_throughput() API
Date: Mon, 14 Apr 2014 16:03:23 +0200
Message-Id: <1397484205-20905-5-git-send-email-antonio@meshcoding.com> (sfid-20140414_160424_366758_ED2B55E9)
In-Reply-To: <1397484205-20905-1-git-send-email-antonio@meshcoding.com>
References: <1397484205-20905-1-git-send-email-antonio@meshcoding.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Antonio Quartulli <antonio@open-mesh.com>

Cc: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Antonio Quartulli <antonio@open-mesh.com>
---
 net/mac80211/rc80211_minstrel.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/net/mac80211/rc80211_minstrel.c b/net/mac80211/rc80211_minstrel.c
index 26fd94f..cd40bc0 100644
--- a/net/mac80211/rc80211_minstrel.c
+++ b/net/mac80211/rc80211_minstrel.c
@@ -657,6 +657,18 @@ minstrel_free(void *priv)
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
+	return bitrate * MINSTREL_TRUNC(mi->r[idx].probability * 1000) / 100;
+}
+
 const struct rate_control_ops mac80211_minstrel = {
 	.name = "minstrel",
 	.tx_status = minstrel_tx_status,
@@ -670,6 +682,7 @@ const struct rate_control_ops mac80211_minstrel = {
 	.add_sta_debugfs = minstrel_add_sta_debugfs,
 	.remove_sta_debugfs = minstrel_remove_sta_debugfs,
 #endif
+	.get_expected_throughput = minstrel_get_expected_throughput,
 };
 
 int __init
-- 
1.8.3.2

