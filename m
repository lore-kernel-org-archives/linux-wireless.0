Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail022-1.exch022.serverdata.net ([64.78.22.98]:37846 "EHLO
	mail022-1.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754674Ab2K1NXh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2012 08:23:37 -0500
Message-ID: <50B61054.3090604@posedge.com> (sfid-20121128_142340_682764_9F204D1A)
Date: Wed, 28 Nov 2012 18:53:32 +0530
From: Saravana <saravanad@posedge.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: add debugfs file for current tx rate
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add a debugfs file showing the current tx rate.
The information available in the rc_stats file
doesn't evidently provides us the current tx rate.
This patch adds the support for the same.

Signed-off-by: Saravana <saravanad@posedge.com>
---
 net/mac80211/debugfs_sta.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
index 89281d2..b10ae46 100644
--- a/net/mac80211/debugfs_sta.c
+++ b/net/mac80211/debugfs_sta.c
@@ -321,6 +321,20 @@ static ssize_t sta_ht_capa_read(struct file *file, char __user *userbuf,
 }
 STA_OPS(ht_capa);
 
+static ssize_t sta_current_tx_rate_read(struct file *file, char __user *userbuf,
+				      size_t count, loff_t *ppos)
+{
+	struct sta_info *sta = file->private_data;
+	struct rate_info rinfo;
+	u16 rate;
+	sta_set_rate_info_tx(sta, &sta->last_tx_rate, &rinfo);
+	rate = cfg80211_calculate_bitrate(&rinfo);
+
+	return mac80211_format_buffer(userbuf, count, ppos, "%d.%d MBit/s\n",
+					rate/10, rate%10);
+}
+STA_OPS(current_tx_rate);
+
 #define DEBUGFS_ADD(name) \
 	debugfs_create_file(#name, 0400, \
 		sta->debugfs.dir, sta, &sta_ ##name## _ops);
@@ -369,6 +383,7 @@ void ieee80211_sta_debugfs_add(struct sta_info *sta)
 	DEBUGFS_ADD(dev);
 	DEBUGFS_ADD(last_signal);
 	DEBUGFS_ADD(ht_capa);
+	DEBUGFS_ADD(current_tx_rate);
 
 	DEBUGFS_ADD_COUNTER(rx_packets, rx_packets);
 	DEBUGFS_ADD_COUNTER(tx_packets, tx_packets);
