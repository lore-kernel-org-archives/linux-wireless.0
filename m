Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:24363 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751213Ab1DENkC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Apr 2011 09:40:02 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 05 Apr 2011 06:39:37 -0700
From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
To: <linux-wireless@vger.kernel.org>
CC: <johannes@sipsolutions.net>,
	Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
Subject: [RFC] mac80211: Add station uptime in debugfs
Date: Tue, 5 Apr 2011 19:09:55 +0530
Message-ID: <1302010795-2522-1-git-send-email-mshajakhan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>

Add station uptime parameter in debugfs. This will be helpful to get a
measure of stability of connection and also during stress testing.

Signed-off-by: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
---
 net/mac80211/debugfs_sta.c |   22 ++++++++++++++++++++++
 net/mac80211/sta_info.c    |    1 +
 net/mac80211/sta_info.h    |    2 ++
 3 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
index c04a139..cc79e76 100644
--- a/net/mac80211/debugfs_sta.c
+++ b/net/mac80211/debugfs_sta.c
@@ -73,6 +73,27 @@ static ssize_t sta_flags_read(struct file *file, char __user *userbuf,
 }
 STA_OPS(flags);
 
+static ssize_t sta_station_uptime_read(struct file *file, char __user *userbuf,
+					size_t count, loff_t *ppos)
+{
+	struct sta_info *sta = file->private_data;
+	struct tm result;
+	unsigned long uptime_msecs;
+	unsigned long  uptime_secs;
+	char buf[100];
+	int res;
+	uptime_msecs = jiffies_to_msecs(jiffies - (sta->sta_uptime));
+	uptime_secs = uptime_msecs / 1000;
+	uptime_msecs %= 1000;
+	time_to_tm(uptime_secs, 0, &result);
+	res = scnprintf(buf, sizeof(buf),
+			"days  - %d\nclock - %d:%d:%d\nmsecs - %lu\n",
+			result.tm_yday, result.tm_hour,
+			result.tm_min, result.tm_sec, uptime_msecs);
+	return simple_read_from_buffer(userbuf, count, ppos, buf, res);
+}
+STA_OPS(station_uptime);
+
 static ssize_t sta_num_ps_buf_frames_read(struct file *file,
 					  char __user *userbuf,
 					  size_t count, loff_t *ppos)
@@ -324,6 +345,7 @@ void ieee80211_sta_debugfs_add(struct sta_info *sta)
 	DEBUGFS_ADD(flags);
 	DEBUGFS_ADD(num_ps_buf_frames);
 	DEBUGFS_ADD(inactive_ms);
+	DEBUGFS_ADD(station_uptime);
 	DEBUGFS_ADD(last_seq_ctrl);
 	DEBUGFS_ADD(agg_status);
 	DEBUGFS_ADD(dev);
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 999f8fb..08b9f51 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -244,6 +244,7 @@ struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
 	sta->local = local;
 	sta->sdata = sdata;
 	sta->last_rx = jiffies;
+	sta->sta_uptime = jiffies;
 
 	ewma_init(&sta->avg_signal, 1024, 8);
 
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 43238e9..e704270 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -226,6 +226,7 @@ enum plink_state {
  * @rx_bytes: Number of bytes received from this STA
  * @wep_weak_iv_count: number of weak WEP IVs received from this station
  * @last_rx: time (in jiffies) when last frame was received from this STA
+ * @sta_uptime: time (in jiffies) when the station gets associated
  * @num_duplicates: number of duplicate frames received from this STA
  * @rx_fragments: number of received MPDUs
  * @rx_dropped: number of dropped MPDUs from this STA
@@ -295,6 +296,7 @@ struct sta_info {
 	unsigned long rx_packets, rx_bytes;
 	unsigned long wep_weak_iv_count;
 	unsigned long last_rx;
+	unsigned long sta_uptime;
 	unsigned long num_duplicates;
 	unsigned long rx_fragments;
 	unsigned long rx_dropped;
-- 
1.7.0.4

