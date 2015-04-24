Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:39500 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030227AbbDXJVV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Apr 2015 05:21:21 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 4/4] mac80211: clean up station debugfs
Date: Fri, 24 Apr 2015 11:21:13 +0200
Message-Id: <1429867273-18271-4-git-send-email-johannes@sipsolutions.net> (sfid-20150424_112128_696972_C6887FFC)
In-Reply-To: <1429867273-18271-1-git-send-email-johannes@sipsolutions.net>
References: <1429867273-18271-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Remove items that can be retrieved through nl80211. This also
removes two items (tx_packets and tx_bytes) where only the VO
counter was exposed since they are split up per AC but in the
debugfs file only the first AC was shown.

Also remove the useless "dev" file - the stations have long
been in a sub-directory of the netdev so there's no need for
that any more.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/debugfs_sta.c | 84 ----------------------------------------------
 1 file changed, 84 deletions(-)

diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
index 7ca601414000..06d52935036d 100644
--- a/net/mac80211/debugfs_sta.c
+++ b/net/mac80211/debugfs_sta.c
@@ -29,8 +29,6 @@ static ssize_t sta_ ##name## _read(struct file *file,			\
 				      format_string, sta->field);	\
 }
 #define STA_READ_D(name, field) STA_READ(name, field, "%d\n")
-#define STA_READ_U(name, field) STA_READ(name, field, "%u\n")
-#define STA_READ_S(name, field) STA_READ(name, field, "%s\n")
 
 #define STA_OPS(name)							\
 static const struct file_operations sta_ ##name## _ops = {		\
@@ -52,10 +50,7 @@ static const struct file_operations sta_ ##name## _ops = {		\
 		STA_OPS(name)
 
 STA_FILE(aid, sta.aid, D);
-STA_FILE(dev, sdata->name, S);
-STA_FILE(last_signal, last_signal, D);
 STA_FILE(last_ack_signal, last_ack_signal, D);
-STA_FILE(beacon_loss_count, beacon_loss_count, D);
 
 static ssize_t sta_flags_read(struct file *file, char __user *userbuf,
 			      size_t count, loff_t *ppos)
@@ -101,40 +96,6 @@ static ssize_t sta_num_ps_buf_frames_read(struct file *file,
 }
 STA_OPS(num_ps_buf_frames);
 
-static ssize_t sta_inactive_ms_read(struct file *file, char __user *userbuf,
-				    size_t count, loff_t *ppos)
-{
-	struct sta_info *sta = file->private_data;
-	return mac80211_format_buffer(userbuf, count, ppos, "%d\n",
-				      jiffies_to_msecs(jiffies - sta->last_rx));
-}
-STA_OPS(inactive_ms);
-
-
-static ssize_t sta_connected_time_read(struct file *file, char __user *userbuf,
-					size_t count, loff_t *ppos)
-{
-	struct sta_info *sta = file->private_data;
-	struct timespec uptime;
-	struct tm result;
-	long connected_time_secs;
-	char buf[100];
-	int res;
-	ktime_get_ts(&uptime);
-	connected_time_secs = uptime.tv_sec - sta->last_connected;
-	time_to_tm(connected_time_secs, 0, &result);
-	result.tm_year -= 70;
-	result.tm_mday -= 1;
-	res = scnprintf(buf, sizeof(buf),
-		"years  - %ld\nmonths - %d\ndays   - %d\nclock  - %d:%d:%d\n\n",
-			result.tm_year, result.tm_mon, result.tm_mday,
-			result.tm_hour, result.tm_min, result.tm_sec);
-	return simple_read_from_buffer(userbuf, count, ppos, buf, res);
-}
-STA_OPS(connected_time);
-
-
-
 static ssize_t sta_last_seq_ctrl_read(struct file *file, char __user *userbuf,
 				      size_t count, loff_t *ppos)
 {
@@ -359,37 +320,6 @@ static ssize_t sta_vht_capa_read(struct file *file, char __user *userbuf,
 }
 STA_OPS(vht_capa);
 
-static ssize_t sta_current_tx_rate_read(struct file *file, char __user *userbuf,
-					size_t count, loff_t *ppos)
-{
-	struct sta_info *sta = file->private_data;
-	struct rate_info rinfo;
-	u16 rate;
-	sta_set_rate_info_tx(sta, &sta->last_tx_rate, &rinfo);
-	rate = cfg80211_calculate_bitrate(&rinfo);
-
-	return mac80211_format_buffer(userbuf, count, ppos,
-				      "%d.%d MBit/s\n",
-				      rate/10, rate%10);
-}
-STA_OPS(current_tx_rate);
-
-static ssize_t sta_last_rx_rate_read(struct file *file, char __user *userbuf,
-				     size_t count, loff_t *ppos)
-{
-	struct sta_info *sta = file->private_data;
-	struct rate_info rinfo;
-	u16 rate;
-
-	sta_set_rate_info_rx(sta, &rinfo);
-
-	rate = cfg80211_calculate_bitrate(&rinfo);
-
-	return mac80211_format_buffer(userbuf, count, ppos,
-				      "%d.%d MBit/s\n",
-				      rate/10, rate%10);
-}
-STA_OPS(last_rx_rate);
 
 #define DEBUGFS_ADD(name) \
 	debugfs_create_file(#name, 0400, \
@@ -432,29 +362,15 @@ void ieee80211_sta_debugfs_add(struct sta_info *sta)
 
 	DEBUGFS_ADD(flags);
 	DEBUGFS_ADD(num_ps_buf_frames);
-	DEBUGFS_ADD(inactive_ms);
-	DEBUGFS_ADD(connected_time);
 	DEBUGFS_ADD(last_seq_ctrl);
 	DEBUGFS_ADD(agg_status);
-	DEBUGFS_ADD(dev);
-	DEBUGFS_ADD(last_signal);
-	DEBUGFS_ADD(beacon_loss_count);
 	DEBUGFS_ADD(ht_capa);
 	DEBUGFS_ADD(vht_capa);
 	DEBUGFS_ADD(last_ack_signal);
-	DEBUGFS_ADD(current_tx_rate);
-	DEBUGFS_ADD(last_rx_rate);
 
-	DEBUGFS_ADD_COUNTER(rx_packets, rx_packets);
-	DEBUGFS_ADD_COUNTER(tx_packets, tx_packets);
-	DEBUGFS_ADD_COUNTER(rx_bytes, rx_bytes);
-	DEBUGFS_ADD_COUNTER(tx_bytes, tx_bytes);
 	DEBUGFS_ADD_COUNTER(rx_duplicates, num_duplicates);
 	DEBUGFS_ADD_COUNTER(rx_fragments, rx_fragments);
-	DEBUGFS_ADD_COUNTER(rx_dropped, rx_dropped);
 	DEBUGFS_ADD_COUNTER(tx_filtered, tx_filtered_count);
-	DEBUGFS_ADD_COUNTER(tx_retry_failed, tx_retry_failed);
-	DEBUGFS_ADD_COUNTER(tx_retry_count, tx_retry_count);
 
 	if (sizeof(sta->driver_buffered_tids) == sizeof(u32))
 		debugfs_create_x32("driver_buffered_tids", 0400,
-- 
2.1.4

