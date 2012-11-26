Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail022-1.exch022.serverdata.net ([64.78.22.98]:57735 "EHLO
	mail022-1.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751393Ab2KZFSd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2012 00:18:33 -0500
Message-ID: <50B2FBA5.1020407@posedge.com> (sfid-20121126_061835_933883_C6A08B28)
Date: Mon, 26 Nov 2012 10:48:29 +0530
From: Saravana <saravanad@posedge.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: RFC[3/4] mac80211: add statistic to debugfs
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Provide additional statistic support to the debugfs.

Current Tx Rate:
     The rc_stats file in the debugfs provides the a more detailed 
information of individual rates(success, retries, PER etc). But the 
current tx rate may not be evidently interpreted from this. This 
statistic will provide the current tx rate evidently.


Signed-off-by: Saravana <saravanad@posedge.com>
---
The diff file is generated from wireless-testing git tree.

  net/mac80211/debugfs_sta.c |   15 +++++++++++++++
  1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
index 89281d2..c576848 100644
--- a/net/mac80211/debugfs_sta.c
+++ b/net/mac80211/debugfs_sta.c
@@ -321,6 +321,20 @@ static ssize_t sta_ht_capa_read(struct file *file, 
char __user *userbuf,
  }
  STA_OPS(ht_capa);

+static ssize_t sta_current_tx_rate_read(struct file *file, char __user 
*userbuf,
+				      size_t count, loff_t *ppos)
+{
+	struct sta_info *sta = file->private_data;
+	struct rate_info rinfo;
+	u16 rate;
+	sta_set_rate_info_tx(sta, &sta->last_tx_rate, &rinfo);
+	rate = cfg80211_calculate_bitrate(&rinfo);
+
+	return mac80211_format_buffer(userbuf, count, ppos, "%d.%d 
MBit/s\n",rate/10,rate%10);
+
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
