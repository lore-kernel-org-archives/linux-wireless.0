Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail022-1.exch022.serverdata.net ([64.78.22.98]:57828 "EHLO
	mail022-1.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751588Ab2KZFUH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2012 00:20:07 -0500
Message-ID: <50B2FC03.4050101@posedge.com> (sfid-20121126_062013_385056_61A6DD58)
Date: Mon, 26 Nov 2012 10:50:03 +0530
From: Saravana <saravanad@posedge.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: RFC[4/4] mac80211: add statistic to debugfs
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Provide additional statistic support to the debugfs.

Last Rx Rate:
  Currently there is no stats available in the debugfs for rx rate. This 
statistics adds the rate of the last received packet from the station.

Signed-off-by: Saravana <saravanad@posedge.com>
---
The diff file is generated from wireless-testing git tree.

net/mac80211/cfg.c         |   21 +++++++++++++--------
  net/mac80211/debugfs_sta.c |   15 +++++++++++++++
  net/mac80211/sta_info.h    |    2 ++
  3 files changed, 30 insertions(+), 8 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 6733b374..e45511a 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -396,6 +396,18 @@ void sta_set_rate_info_tx(struct sta_info *sta,
  	rate_idx_to_bitrate(rinfo, sta, rate->idx);
  }

+void sta_set_rate_info_rx(struct sta_info *sta,struct rate_info *rinfo)
+{
+	rinfo->flags = 0;
+	if (sta->last_rx_rate_flag & RX_FLAG_HT)
+		rinfo->flags |= RATE_INFO_FLAGS_MCS;
+	if (sta->last_rx_rate_flag & RX_FLAG_40MHZ)
+		rinfo->flags |= RATE_INFO_FLAGS_40_MHZ_WIDTH;
+	if (sta->last_rx_rate_flag & RX_FLAG_SHORT_GI)
+		rinfo->flags |= RATE_INFO_FLAGS_SHORT_GI;
+	rate_idx_to_bitrate(rinfo, sta, sta->last_rx_rate_idx);
+
+}
  static void sta_set_sinfo(struct sta_info *sta, struct station_info 
*sinfo)
  {
  	struct ieee80211_sub_if_data *sdata = sta->sdata;
@@ -443,14 +455,7 @@ static void sta_set_sinfo(struct sta_info *sta, 
struct station_info *sinfo)

  	sta_set_rate_info_tx(sta, &sta->last_tx_rate, &sinfo->txrate);

-	sinfo->rxrate.flags = 0;
-	if (sta->last_rx_rate_flag & RX_FLAG_HT)
-		sinfo->rxrate.flags |= RATE_INFO_FLAGS_MCS;
-	if (sta->last_rx_rate_flag & RX_FLAG_40MHZ)
-		sinfo->rxrate.flags |= RATE_INFO_FLAGS_40_MHZ_WIDTH;
-	if (sta->last_rx_rate_flag & RX_FLAG_SHORT_GI)
-		sinfo->rxrate.flags |= RATE_INFO_FLAGS_SHORT_GI;
-	rate_idx_to_bitrate(&sinfo->rxrate, sta, sta->last_rx_rate_idx);
+	sta_set_rate_info_rx(sta,&sinfo->rxrate);

  	if (ieee80211_vif_is_mesh(&sdata->vif)) {
  #ifdef CONFIG_MAC80211_MESH
diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
old mode 100644
new mode 100755
index 89281d2..16e738e
--- a/net/mac80211/debugfs_sta.c
+++ b/net/mac80211/debugfs_sta.c
@@ -321,6 +321,20 @@ static ssize_t sta_ht_capa_read(struct file *file, 
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
+	sta_set_rate_info_rx(sta,&rinfo);
+
+	rate = cfg80211_calculate_bitrate(&rinfo);
+
+	return mac80211_format_buffer(userbuf, count, ppos, "%d.%d 
MBit/s\n",rate/10,rate%10);
+}
+STA_OPS(last_rx_rate);
  #define DEBUGFS_ADD(name) \
  	debugfs_create_file(#name, 0400, \
  		sta->debugfs.dir, sta, &sta_ ##name## _ops);
@@ -369,6 +383,7 @@ void ieee80211_sta_debugfs_add(struct sta_info *sta)
  	DEBUGFS_ADD(dev);
  	DEBUGFS_ADD(last_signal);
  	DEBUGFS_ADD(ht_capa);
+	DEBUGFS_ADD(last_rx_rate);

  	DEBUGFS_ADD_COUNTER(rx_packets, rx_packets);
  	DEBUGFS_ADD_COUNTER(tx_packets, tx_packets);
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 776f3d0..122d853 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -550,6 +550,8 @@ int sta_info_flush(struct ieee80211_local *local,
  void sta_set_rate_info_tx(struct sta_info *sta,
  			  const struct ieee80211_tx_rate *rate,
  			  struct rate_info *rinfo);
+void sta_set_rate_info_rx(struct sta_info *sta,
+			struct rate_info *rinfo);
  void ieee80211_sta_expire(struct ieee80211_sub_if_data *sdata,
  			  unsigned long exp_time);

