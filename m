Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:55628 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754867AbZKSO1o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Nov 2009 09:27:44 -0500
Subject: [PATCH] mac80211: add per-station HT capability file
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 19 Nov 2009 14:26:11 +0100
Message-ID: <1258637171.7094.7.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is sometimes useful to debug HT issues
as it shows what exactly the stack thinks
the peer supports.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/debugfs_sta.c |   29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

--- wireless-testing.orig/net/mac80211/debugfs_sta.c	2009-11-19 01:05:45.000000000 +0100
+++ wireless-testing/net/mac80211/debugfs_sta.c	2009-11-19 01:27:32.000000000 +0100
@@ -157,6 +157,34 @@ static ssize_t sta_agg_status_read(struc
 }
 STA_OPS(agg_status);
 
+static ssize_t sta_ht_capa_read(struct file *file, char __user *userbuf,
+				size_t count, loff_t *ppos)
+{
+	char buf[200], *p = buf;
+	int i;
+	struct sta_info *sta = file->private_data;
+	struct ieee80211_sta_ht_cap *htc = &sta->sta.ht_cap;
+
+	p += scnprintf(p, sizeof(buf) + buf - p, "ht %ssupported\n",
+			htc->ht_supported ? "" : "not ");
+	if (htc->ht_supported) {
+		p += scnprintf(p, sizeof(buf)+buf-p, "cap: %#.2x\n", htc->cap);
+		p += scnprintf(p, sizeof(buf)+buf-p, "ampdu factor/density: %d/%d\n",
+				htc->ampdu_factor, htc->ampdu_density);
+		p += scnprintf(p, sizeof(buf)+buf-p, "MCS mask:");
+		for (i = 0; i < IEEE80211_HT_MCS_MASK_LEN; i++)
+			p += scnprintf(p, sizeof(buf)+buf-p, " %.2x",
+					htc->mcs.rx_mask[i]);
+		p += scnprintf(p, sizeof(buf)+buf-p, "\nMCS rx highest: %d\n",
+				le16_to_cpu(htc->mcs.rx_highest));
+		p += scnprintf(p, sizeof(buf)+buf-p, "MCS tx params: %x\n",
+				htc->mcs.tx_params);
+	}
+
+	return simple_read_from_buffer(userbuf, count, ppos, buf, p - buf);
+}
+STA_OPS(ht_capa);
+
 #define DEBUGFS_ADD(name) \
 	debugfs_create_file(#name, 0400, \
 		sta->debugfs.dir, sta, &sta_ ##name## _ops);
@@ -207,6 +235,7 @@ void ieee80211_sta_debugfs_add(struct st
 	DEBUGFS_ADD(last_signal);
 	DEBUGFS_ADD(last_noise);
 	DEBUGFS_ADD(wep_weak_iv_count);
+	DEBUGFS_ADD(ht_capa);
 }
 
 void ieee80211_sta_debugfs_remove(struct sta_info *sta)


