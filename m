Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:60714 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932560Ab0EMVuR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 May 2010 17:50:17 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 07/17] iwlwifi: improve station debugfs
Date: Thu, 13 May 2010 14:49:49 -0700
Message-Id: <1273787399-9280-8-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1273787399-9280-1-git-send-email-reinette.chatre@intel.com>
References: <1273787399-9280-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The stations debugfs entry doesn't even show
the stations' MAC addresses Also, the TID
information is formatted very oddly, and
misses the important tfds_in_queue variable.
Fix this to make the file more useful.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-debugfs.c |   60 +++++++++++----------------
 1 files changed, 25 insertions(+), 35 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index 9793050..5e12c96 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -303,45 +303,35 @@ static ssize_t iwl_dbgfs_stations_read(struct file *file, char __user *user_buf,
 
 	for (i = 0; i < max_sta; i++) {
 		station = &priv->stations[i];
-		if (station->used) {
-			pos += scnprintf(buf + pos, bufsz - pos,
-					"station %d:\ngeneral data:\n", i+1);
-			pos += scnprintf(buf + pos, bufsz - pos, "id: %u\n",
-					station->sta.sta.sta_id);
-			pos += scnprintf(buf + pos, bufsz - pos, "mode: %u\n",
-					station->sta.mode);
-			pos += scnprintf(buf + pos, bufsz - pos,
-					"flags: 0x%x\n",
-					station->sta.station_flags_msk);
-			pos += scnprintf(buf + pos, bufsz - pos, "tid data:\n");
-			pos += scnprintf(buf + pos, bufsz - pos,
-					"seq_num\t\ttxq_id");
-			pos += scnprintf(buf + pos, bufsz - pos,
-					"\tframe_count\twait_for_ba\t");
-			pos += scnprintf(buf + pos, bufsz - pos,
-					"start_idx\tbitmap0\t");
-			pos += scnprintf(buf + pos, bufsz - pos,
-					"bitmap1\trate_n_flags");
-			pos += scnprintf(buf + pos, bufsz - pos, "\n");
+		if (!station->used)
+			continue;
+		pos += scnprintf(buf + pos, bufsz - pos,
+				 "station %d - addr: %pM, flags: %#x\n",
+				 i, station->sta.sta.addr,
+				 station->sta.station_flags_msk);
+		pos += scnprintf(buf + pos, bufsz - pos,
+				"TID\tseq_num\ttxq_id\tframes\ttfds\t");
+		pos += scnprintf(buf + pos, bufsz - pos,
+				"start_idx\tbitmap\t\t\trate_n_flags\n");
 
-			for (j = 0; j < MAX_TID_COUNT; j++) {
-				pos += scnprintf(buf + pos, bufsz - pos,
-						"[%d]:\t\t%u", j,
-						station->tid[j].seq_number);
-				pos += scnprintf(buf + pos, bufsz - pos,
-						"\t%u\t\t%u\t\t%u\t\t",
-						station->tid[j].agg.txq_id,
-						station->tid[j].agg.frame_count,
-						station->tid[j].agg.wait_for_ba);
+		for (j = 0; j < MAX_TID_COUNT; j++) {
+			pos += scnprintf(buf + pos, bufsz - pos,
+				"%d:\t%#x\t%#x\t%u\t%u\t%u\t\t%#.16llx\t%#x",
+				j, station->tid[j].seq_number,
+				station->tid[j].agg.txq_id,
+				station->tid[j].agg.frame_count,
+				station->tid[j].tfds_in_queue,
+				station->tid[j].agg.start_idx,
+				station->tid[j].agg.bitmap,
+				station->tid[j].agg.rate_n_flags);
+
+			if (station->tid[j].agg.wait_for_ba)
 				pos += scnprintf(buf + pos, bufsz - pos,
-						"%u\t%llu\t%u",
-						station->tid[j].agg.start_idx,
-						(unsigned long long)station->tid[j].agg.bitmap,
-						station->tid[j].agg.rate_n_flags);
-				pos += scnprintf(buf + pos, bufsz - pos, "\n");
-			}
+						 " - waitforba");
 			pos += scnprintf(buf + pos, bufsz - pos, "\n");
 		}
+
+		pos += scnprintf(buf + pos, bufsz - pos, "\n");
 	}
 
 	ret = simple_read_from_buffer(user_buf, count, ppos, buf, pos);
-- 
1.6.3.3

