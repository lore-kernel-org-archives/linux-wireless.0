Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail022-1.exch022.serverdata.net ([64.78.22.98]:56805 "EHLO
	mail022-1.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751136Ab2KZNmw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2012 08:42:52 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Mon, 26 Nov 2012 05:42:51 -0800
From: saravanad@posedge.com
To: <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: [RFC] mac80211: add debugfs file for last rx rate
Message-ID: <1d88d390652318a8561e107f4254a920@posedge.com> (sfid-20121126_144255_232752_FC7A3B61)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add a debugfs file showing the rate at which
the last packet is received.

Signed-off-by: Saravana <saravanad@posedge.com>
---
The diff file is generated from wireless-testing git tree.
net/mac80211/debugfs_sta.c |   16 ++++++++++++++++
  1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
index 89281d2..183ca01 100644
--- a/net/mac80211/debugfs_sta.c
+++ b/net/mac80211/debugfs_sta.c
@@ -321,6 +321,21 @@ static ssize_t sta_ht_capa_read(struct file *file, 
char __user *userbuf,
  }
  STA_OPS(ht_capa);

+static ssize_t sta_last_rx_rate_read(struct file *file, char __user 
*userbuf,
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
  #define DEBUGFS_ADD(name) \
  	debugfs_create_file(#name, 0400, \
  		sta->debugfs.dir, sta, &sta_ ##name## _ops);
@@ -369,6 +384,7 @@ void ieee80211_sta_debugfs_add(struct sta_info 
*sta)
  	DEBUGFS_ADD(dev);
  	DEBUGFS_ADD(last_signal);
  	DEBUGFS_ADD(ht_capa);
+	DEBUGFS_ADD(last_rx_rate);

  	DEBUGFS_ADD_COUNTER(rx_packets, rx_packets);
  	DEBUGFS_ADD_COUNTER(tx_packets, tx_packets);

