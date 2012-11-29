Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail022-1.exch022.serverdata.net ([64.78.22.98]:57952 "EHLO
	mail022-1.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754625Ab2K2OYY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Nov 2012 09:24:24 -0500
Message-ID: <50B77013.6040508@posedge.com> (sfid-20121129_152427_274417_AAE6BECC)
Date: Thu, 29 Nov 2012 19:54:19 +0530
From: Saravana <saravanad@posedge.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: add debugfs file for last rx rate
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add a debugfs file showing the rate at which
the last packet is received.

Signed-off-by: Saravana <saravanad@posedge.com>
---
 net/mac80211/debugfs_sta.c |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
index 1090c24..3173fed 100644
--- a/net/mac80211/debugfs_sta.c
+++ b/net/mac80211/debugfs_sta.c
@@ -336,6 +336,22 @@ static ssize_t sta_current_tx_rate_read(struct file *file, char __user *userbuf,
 }
 STA_OPS(current_tx_rate);
 
+static ssize_t sta_last_rx_rate_read(struct file *file, char __user *userbuf,
+				      size_t count, loff_t *ppos)
+{
+	struct sta_info *sta = file->private_data;
+	struct rate_info rinfo;
+	u16 rate;
+
+	sta_set_rate_info_rx(sta, &rinfo);
+
+	rate = cfg80211_calculate_bitrate(&rinfo);
+
+	return mac80211_format_buffer(userbuf, count, ppos, "%d.%d MBit/s\n",
+					rate/10, rate%10);
+}
+STA_OPS(last_rx_rate);
+
 #define DEBUGFS_ADD(name) \
 	debugfs_create_file(#name, 0400, \
 		sta->debugfs.dir, sta, &sta_ ##name## _ops);
@@ -386,6 +402,7 @@ void ieee80211_sta_debugfs_add(struct sta_info *sta)
 	DEBUGFS_ADD(ht_capa);
 	DEBUGFS_ADD(last_ack_signal);
 	DEBUGFS_ADD(current_tx_rate);
+	DEBUGFS_ADD(last_rx_rate);
 
 	DEBUGFS_ADD_COUNTER(rx_packets, rx_packets);
 	DEBUGFS_ADD_COUNTER(tx_packets, tx_packets);
