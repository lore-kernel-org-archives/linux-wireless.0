Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:41783 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753783AbYEECYO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 May 2008 22:24:14 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 09/25] iwlwifi: Fix unconditional access to station->tidp[].agg.
Date: Mon,  5 May 2008 10:22:36 +0800
Message-Id: <1209954172-3092-10-git-send-email-yi.zhu@intel.com> (sfid-20080505_042355_901266_9372B099)
In-Reply-To: <1209954172-3092-9-git-send-email-yi.zhu@intel.com>
References: <1209954172-3092-1-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-2-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-3-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-4-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-5-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-6-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-7-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-8-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-9-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: David S. Miller <davem@davemloft.net>

Reportred by Ingo Molnar:

drivers/net/wireless/iwlwifi/iwl-debugfs.c: In function 'iwl_dbgfs_stations_read':
drivers/net/wireless/iwlwifi/iwl-debugfs.c:256: error: 'struct iwl4965_tid_data' has no member named 'agg'

Needs CONFIG_IWL4965_HT protection.

Signed-off-by: David S. Miller <davem@davemloft.net>
---
 drivers/net/wireless/iwlwifi/iwl-debugfs.c |   18 ++++++++++++------
 1 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index b310f70..ad25806 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -239,28 +239,34 @@ static ssize_t iwl_dbgfs_stations_read(struct file *file, char __user *user_buf,
 					"ps_status: %u\n", station->ps_status);
 			pos += scnprintf(buf + pos, bufsz - pos, "tid data:\n");
 			pos += scnprintf(buf + pos, bufsz - pos,
-					"seq_num\t\ttxq_id\t");
+					"seq_num\t\ttxq_id");
+#ifdef CONFIG_IWL4965_HT
 			pos += scnprintf(buf + pos, bufsz - pos,
-					"frame_count\twait_for_ba\t");
+					"\tframe_count\twait_for_ba\t");
 			pos += scnprintf(buf + pos, bufsz - pos,
 					"start_idx\tbitmap0\t");
 			pos += scnprintf(buf + pos, bufsz - pos,
-					"bitmap1\trate_n_flags\n");
+					"bitmap1\trate_n_flags");
+#endif
+			pos += scnprintf(buf + pos, bufsz - pos, "\n");
 
 			for (j = 0; j < MAX_TID_COUNT; j++) {
 				pos += scnprintf(buf + pos, bufsz - pos,
-						"[%d]:\t\t%u\t", j,
+						"[%d]:\t\t%u", j,
 						station->tid[j].seq_number);
+#ifdef CONFIG_IWL4965_HT
 				pos += scnprintf(buf + pos, bufsz - pos,
-						"%u\t\t%u\t\t%u\t\t",
+						"\t%u\t\t%u\t\t%u\t\t",
 						station->tid[j].agg.txq_id,
 						station->tid[j].agg.frame_count,
 						station->tid[j].agg.wait_for_ba);
 				pos += scnprintf(buf + pos, bufsz - pos,
-						"%u\t%llu\t%u\n",
+						"%u\t%llu\t%u",
 						station->tid[j].agg.start_idx,
 						(unsigned long long)station->tid[j].agg.bitmap,
 						station->tid[j].agg.rate_n_flags);
+#endif
+				pos += scnprintf(buf + pos, bufsz - pos, "\n");
 			}
 			pos += scnprintf(buf + pos, bufsz - pos, "\n");
 		}
-- 
1.5.3.6

