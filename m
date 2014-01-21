Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.neomailbox.net ([178.209.62.157]:27812 "EHLO
	s3.neomailbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754021AbaAULLJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jan 2014 06:11:09 -0500
From: Antonio Quartulli <antonio@meshcoding.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Antonio Quartulli <antonio@open-mesh.com>
Subject: [RFC 3/5] mac80211: minstrel - implement get_minstrel_best_rate() API
Date: Tue, 21 Jan 2014 12:09:49 +0100
Message-Id: <1390302591-3352-4-git-send-email-antonio@meshcoding.com> (sfid-20140121_121122_944148_A028BE3C)
In-Reply-To: <1390302591-3352-1-git-send-email-antonio@meshcoding.com>
References: <1390302591-3352-1-git-send-email-antonio@meshcoding.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Antonio Quartulli <antonio@open-mesh.com>

Signed-off-by: Antonio Quartulli <antonio@open-mesh.com>
---
 net/mac80211/rc80211_minstrel.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/net/mac80211/rc80211_minstrel.c b/net/mac80211/rc80211_minstrel.c
index f3d88b0..748b5db 100644
--- a/net/mac80211/rc80211_minstrel.c
+++ b/net/mac80211/rc80211_minstrel.c
@@ -657,6 +657,17 @@ minstrel_free(void *priv)
 	kfree(priv);
 }
 
+static void
+minstrel_get_minstrel_best_rate(void *priv, void *priv_sta,
+				struct ieee80211_minstrel_rate_info *info)
+{
+	struct minstrel_sta_info *mi = priv_sta;
+	int idx = mi->max_tp_rate[0];
+
+	info->rate.idx = mi->r[idx].rix;
+	info->prob = MINSTREL_TRUNC(mi->r[idx].probability * 1000);
+}
+
 struct rate_control_ops mac80211_minstrel = {
 	.name = "minstrel",
 	.tx_status = minstrel_tx_status,
@@ -670,6 +681,7 @@ struct rate_control_ops mac80211_minstrel = {
 	.add_sta_debugfs = minstrel_add_sta_debugfs,
 	.remove_sta_debugfs = minstrel_remove_sta_debugfs,
 #endif
+	.get_minstrel_best_rate = minstrel_get_minstrel_best_rate,
 };
 
 int __init
-- 
1.8.5.3

