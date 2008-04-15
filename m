Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:54268 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751304AbYDOEQQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Apr 2008 00:16:16 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 02/12] iwlwifi: replace sprintf with scnprintf for debugfs output
Date: Mon, 14 Apr 2008 21:16:04 -0700
Message-Id: <1208232974-3828-3-git-send-email-reinette.chatre@intel.com> (sfid-20080415_051623_303330_3A0745C3)
In-Reply-To: <1208232974-3828-2-git-send-email-reinette.chatre@intel.com>
References: <1208232974-3828-1-git-send-email-reinette.chatre@intel.com>
 <1208232974-3828-2-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>

The buffersize allocated is not accurate.
Writing to these buffers with scnprintf is safer.

Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-debugfs.c |   71 +++++++++++++++++-----------
 1 files changed, 43 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index 23632e5..cbea477 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -102,10 +102,14 @@ static ssize_t iwl_dbgfs_tx_statistics_read(struct file *file,
 	struct iwl_priv *priv = (struct iwl_priv *)file->private_data;
 	char buf[256];
 	int pos = 0;
+	const size_t bufsz = sizeof(buf);
 
-	pos += sprintf(buf+pos, "mgmt: %u\n", priv->tx_stats[0].cnt);
-	pos += sprintf(buf+pos, "ctrl: %u\n", priv->tx_stats[1].cnt);
-	pos += sprintf(buf+pos, "data: %u\n", priv->tx_stats[2].cnt);
+	pos += scnprintf(buf + pos, bufsz - pos, "mgmt: %u\n",
+						priv->tx_stats[0].cnt);
+	pos += scnprintf(buf + pos, bufsz - pos, "ctrl: %u\n",
+						priv->tx_stats[1].cnt);
+	pos += scnprintf(buf + pos, bufsz - pos, "data: %u\n",
+						priv->tx_stats[2].cnt);
 
 	return simple_read_from_buffer(user_buf, count, ppos, buf, pos);
 }
@@ -117,10 +121,14 @@ static ssize_t iwl_dbgfs_rx_statistics_read(struct file *file,
 	struct iwl_priv *priv = (struct iwl_priv *)file->private_data;
 	char buf[256];
 	int pos = 0;
+	const size_t bufsz = sizeof(buf);
 
-	pos += sprintf(buf+pos, "mgmt: %u\n", priv->rx_stats[0].cnt);
-	pos += sprintf(buf+pos, "ctrl: %u\n", priv->rx_stats[1].cnt);
-	pos += sprintf(buf+pos, "data: %u\n", priv->rx_stats[2].cnt);
+	pos += scnprintf(buf + pos, bufsz - pos, "mgmt: %u\n",
+						priv->rx_stats[0].cnt);
+	pos += scnprintf(buf + pos, bufsz - pos, "ctrl: %u\n",
+						priv->rx_stats[1].cnt);
+	pos += scnprintf(buf + pos, bufsz - pos, "data: %u\n",
+						priv->rx_stats[2].cnt);
 
 	return simple_read_from_buffer(user_buf, count, ppos, buf, pos);
 }
@@ -138,6 +146,7 @@ static ssize_t iwl_dbgfs_sram_read(struct file *file,
 	int i;
 	int pos = 0;
 	struct iwl_priv *priv = (struct iwl_priv *)file->private_data;
+	const size_t bufsz = sizeof(buf);
 
 	printk(KERN_DEBUG "offset is: 0x%x\tlen is: 0x%x\n",
 	priv->dbgfs->sram_offset, priv->dbgfs->sram_len);
@@ -159,9 +168,9 @@ static ssize_t iwl_dbgfs_sram_read(struct file *file,
 				break;
 			}
 		}
-		pos += sprintf(buf+pos, "0x%08x ", val);
+		pos += scnprintf(buf + pos, bufsz - pos, "0x%08x ", val);
 	}
-	pos += sprintf(buf+pos, "\n");
+	pos += scnprintf(buf + pos, bufsz - pos, "\n");
 	iwl_release_nic_access(priv);
 
 	ret = simple_read_from_buffer(user_buf, count, ppos, buf, pos);
@@ -210,44 +219,50 @@ static ssize_t iwl_dbgfs_stations_read(struct file *file, char __user *user_buf,
 	if(!buf)
 		return -ENOMEM;
 
-	pos += sprintf(buf+pos, "num of stations: %d\n\n",
+	pos += scnprintf(buf + pos, bufsz - pos, "num of stations: %d\n\n",
 			priv->num_stations);
 
 	for (i = 0; i < max_sta; i++) {
 		station = &priv->stations[i];
 		if (station->used) {
-			pos += sprintf(buf+pos, "station %d:\ngeneral data:\n",
-					i+1);
+			pos += scnprintf(buf + pos, bufsz - pos,
+					"station %d:\ngeneral data:\n", i+1);
 			print_mac(mac, station->sta.sta.addr);
-			pos += sprintf(buf+pos, "id: %u\n",
+			pos += scnprintf(buf + pos, bufsz - pos, "id: %u\n",
 					station->sta.sta.sta_id);
-			pos += sprintf(buf+pos, "mode: %u\n",
+			pos += scnprintf(buf + pos, bufsz - pos, "mode: %u\n",
 					station->sta.mode);
-			pos += sprintf(buf+pos, "flags: 0x%x\n",
+			pos += scnprintf(buf + pos, bufsz - pos,
+					"flags: 0x%x\n",
 					station->sta.station_flags_msk);
-			pos += sprintf(buf+pos, "ps_status: %u\n",
-					station->ps_status);
-
-			pos += sprintf(buf+pos, "tid data:\n");
-
-			pos += sprintf(buf+pos, "seq_num\t\ttxq_id\t");
-			pos += sprintf(buf+pos, "frame_count\twait_for_ba\t");
-			pos += sprintf(buf+pos, "start_idx\tbitmap0\t");
-			pos += sprintf(buf+pos, "bitmap1\trate_n_flags\n");
+			pos += scnprintf(buf + pos, bufsz - pos,
+					"ps_status: %u\n", station->ps_status);
+			pos += scnprintf(buf + pos, bufsz - pos, "tid data:\n");
+			pos += scnprintf(buf + pos, bufsz - pos,
+					"seq_num\t\ttxq_id\t");
+			pos += scnprintf(buf + pos, bufsz - pos,
+					"frame_count\twait_for_ba\t");
+			pos += scnprintf(buf + pos, bufsz - pos,
+					"start_idx\tbitmap0\t");
+			pos += scnprintf(buf + pos, bufsz - pos,
+					"bitmap1\trate_n_flags\n");
 
 			for (j = 0; j < MAX_TID_COUNT; j++) {
-				pos += sprintf(buf+pos, "[%d]:\t\t%u\t",
-						j, station->tid[j].seq_number);
-				pos += sprintf(buf+pos, "%u\t\t%u\t\t%u\t\t",
+				pos += scnprintf(buf + pos, bufsz - pos,
+						"[%d]:\t\t%u\t", j,
+						station->tid[j].seq_number);
+				pos += scnprintf(buf + pos, bufsz - pos,
+						"%u\t\t%u\t\t%u\t\t",
 						station->tid[j].agg.txq_id,
 						station->tid[j].agg.frame_count,
 						station->tid[j].agg.wait_for_ba);
-				pos += sprintf(buf+pos, "%u\t%llu\t%u\n",
+				pos += scnprintf(buf + pos, bufsz - pos,
+						"%u\t%llu\t%u\n",
 						station->tid[j].agg.start_idx,
 						(unsigned long long)station->tid[j].agg.bitmap,
 						station->tid[j].agg.rate_n_flags);
 			}
-			pos += sprintf(buf+pos, "\n");
+			pos += scnprintf(buf + pos, bufsz - pos, "\n");
 		}
 	}
 
-- 
1.5.3.4

