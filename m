Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:32306 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758519Ab0AOVns (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jan 2010 16:43:48 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>, Zhu Yi <yi.zhu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 3/9] iwlwifi: add num_of_sos_stats to statistics counter
Date: Fri, 15 Jan 2010 13:43:35 -0800
Message-Id: <1263591821-14867-4-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1263591821-14867-1-git-send-email-reinette.chatre@intel.com>
References: <1263591821-14867-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

When uCode detects number of beacon missed consecutively above the
internal missed beacon threshold (set by uCode), it will reset and
re-tune the radio in order to get out of bad PHY state.

This "num_of_sos_states" counter monitors number of time uCode
encounters this bad condition and has to re-tune the radio.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-commands.h |    7 ++++++-
 drivers/net/wireless/iwlwifi/iwl-debugfs.c  |    8 +++++++-
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 3320cce..8dc34a3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -3095,7 +3095,12 @@ struct statistics_general {
 	__le32 ttl_timestamp;
 	struct statistics_div div;
 	__le32 rx_enable_counter;
-	__le32 reserved1;
+	/*
+	 * num_of_sos_states:
+	 *  count the number of times we have to re-tune
+	 *  in order to get out of bad PHY status
+	 */
+	__le32 num_of_sos_states;
 	__le32 reserved2;
 	__le32 reserved3;
 } __attribute__ ((packed));
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index 2264cbd..19c7fab 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -1728,7 +1728,7 @@ static ssize_t iwl_dbgfs_ucode_general_stats_read(struct file *file,
 	struct iwl_priv *priv = file->private_data;
 	int pos = 0;
 	char *buf;
-	int bufsz = sizeof(struct statistics_general) * 8 + 250;
+	int bufsz = sizeof(struct statistics_general) * 10 + 300;
 	ssize_t ret;
 	struct statistics_general *general, *accum_general;
 	struct statistics_general *delta_general, *max_general;
@@ -1828,6 +1828,12 @@ static ssize_t iwl_dbgfs_ucode_general_stats_read(struct file *file,
 			 accum_general->rx_enable_counter,
 			 delta_general->rx_enable_counter,
 			 max_general->rx_enable_counter);
+	pos += scnprintf(buf + pos, bufsz - pos, ucode_stats_format,
+			 "num_of_sos_states:",
+			 le32_to_cpu(general->num_of_sos_states),
+			 accum_general->num_of_sos_states,
+			 delta_general->num_of_sos_states,
+			 max_general->num_of_sos_states);
 	ret = simple_read_from_buffer(user_buf, count, ppos, buf, pos);
 	kfree(buf);
 	return ret;
-- 
1.6.3.3

