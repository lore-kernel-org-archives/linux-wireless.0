Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:29219 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753071Ab0AHSEo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jan 2010 13:04:44 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>, Zhu Yi <yi.zhu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 2/4] iwlwifi: ucode statistics data structure update
Date: Fri,  8 Jan 2010 10:04:42 -0800
Message-Id: <1262973884-2551-3-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1262973884-2551-1-git-send-email-reinette.chatre@intel.com>
References: <1262973884-2551-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Update data structure to match latest statistics report from uCode.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-commands.h |    6 +++---
 drivers/net/wireless/iwlwifi/iwl-debugfs.c  |    3 +++
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 28f3800..6bfc63f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -2984,7 +2984,7 @@ struct statistics_rx_ht_phy {
 	__le32 agg_crc32_good;
 	__le32 agg_mpdu_cnt;
 	__le32 agg_cnt;
-	__le32 reserved2;
+	__le32 unsupport_mcs;
 } __attribute__ ((packed));
 
 #define INTERFERENCE_DATA_AVAILABLE      cpu_to_le32(1)
@@ -3087,8 +3087,8 @@ struct statistics_div {
 } __attribute__ ((packed));
 
 struct statistics_general {
-	__le32 temperature;
-	__le32 temperature_m;
+	__le32 temperature;   /* radio temperature */
+	__le32 temperature_m; /* for 5000 and up, this is radio voltage */
 	struct statistics_dbg dbg;
 	__le32 sleep_time;
 	__le32 slots_out;
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index ee5aed1..510bad9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -1387,6 +1387,9 @@ static ssize_t iwl_dbgfs_ucode_rx_stats_read(struct file *file,
 			 accum_ht->agg_mpdu_cnt);
 	pos += scnprintf(buf + pos, bufsz - pos, "agg_cnt:\t\t%u\t\t\t%u\n",
 			 le32_to_cpu(ht->agg_cnt), accum_ht->agg_cnt);
+	pos += scnprintf(buf + pos, bufsz - pos, "unsupport_mcs:\t\t%u\t\t\t%u\n",
+			 le32_to_cpu(ht->unsupport_mcs),
+			 accum_ht->unsupport_mcs);
 
 	ret = simple_read_from_buffer(user_buf, count, ppos, buf, pos);
 	kfree(buf);
-- 
1.5.6.3

