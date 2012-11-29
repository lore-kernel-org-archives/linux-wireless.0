Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail022-1.exch022.serverdata.net ([64.78.22.98]:55896 "EHLO
	mail022-1.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753039Ab2K2Nwm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Nov 2012 08:52:42 -0500
Message-ID: <50B768A5.1040701@posedge.com> (sfid-20121129_145245_070820_F092E5EB)
Date: Thu, 29 Nov 2012 19:22:37 +0530
From: Saravana <saravanad@posedge.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: [PATCH v2] mac80211: add debugfs file for current tx rate
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
index 1566941..1090c24 100644
--- a/net/mac80211/debugfs_sta.c
+++ b/net/mac80211/debugfs_sta.c
@@ -322,6 +322,20 @@ static ssize_t sta_ht_capa_read(struct file *file, char __user *userbuf,
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
@@ -371,6 +385,7 @@ void ieee80211_sta_debugfs_add(struct sta_info *sta)
 	DEBUGFS_ADD(last_signal);
 	DEBUGFS_ADD(ht_capa);
 	DEBUGFS_ADD(last_ack_signal);
+	DEBUGFS_ADD(current_tx_rate);
 
 	DEBUGFS_ADD_COUNTER(rx_packets, rx_packets);
 	DEBUGFS_ADD_COUNTER(tx_packets, tx_packets);
