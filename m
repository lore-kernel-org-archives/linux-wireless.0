Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:31482 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932254AbZKMT4o (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Nov 2009 14:56:44 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 09/16] iwlwifi: align tx/rx statistics debugfs format
Date: Fri, 13 Nov 2009 11:56:31 -0800
Message-Id: <1258142198-3223-10-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1258142198-3223-1-git-send-email-reinette.chatre@intel.com>
References: <1258142198-3223-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Align the format for tx_statistics and rx_statistics debugfs output for
better readability

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-debugfs.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index 45a5edd..ba9c96f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -131,21 +131,22 @@ static ssize_t iwl_dbgfs_tx_statistics_read(struct file *file,
 
 	int cnt;
 	ssize_t ret;
-	const size_t bufsz = 100 + sizeof(char) * 24 * (MANAGEMENT_MAX + CONTROL_MAX);
+	const size_t bufsz = 100 +
+		sizeof(char) * 50 * (MANAGEMENT_MAX + CONTROL_MAX);
 	buf = kzalloc(bufsz, GFP_KERNEL);
 	if (!buf)
 		return -ENOMEM;
 	pos += scnprintf(buf + pos, bufsz - pos, "Management:\n");
 	for (cnt = 0; cnt < MANAGEMENT_MAX; cnt++) {
 		pos += scnprintf(buf + pos, bufsz - pos,
-				 "\t%s\t\t: %u\n",
+				 "\t%25s\t\t: %u\n",
 				 get_mgmt_string(cnt),
 				 priv->tx_stats.mgmt[cnt]);
 	}
 	pos += scnprintf(buf + pos, bufsz - pos, "Control\n");
 	for (cnt = 0; cnt < CONTROL_MAX; cnt++) {
 		pos += scnprintf(buf + pos, bufsz - pos,
-				 "\t%s\t\t: %u\n",
+				 "\t%25s\t\t: %u\n",
 				 get_ctrl_string(cnt),
 				 priv->tx_stats.ctrl[cnt]);
 	}
@@ -190,7 +191,7 @@ static ssize_t iwl_dbgfs_rx_statistics_read(struct file *file,
 	int cnt;
 	ssize_t ret;
 	const size_t bufsz = 100 +
-		sizeof(char) * 24 * (MANAGEMENT_MAX + CONTROL_MAX);
+		sizeof(char) * 50 * (MANAGEMENT_MAX + CONTROL_MAX);
 	buf = kzalloc(bufsz, GFP_KERNEL);
 	if (!buf)
 		return -ENOMEM;
@@ -198,14 +199,14 @@ static ssize_t iwl_dbgfs_rx_statistics_read(struct file *file,
 	pos += scnprintf(buf + pos, bufsz - pos, "Management:\n");
 	for (cnt = 0; cnt < MANAGEMENT_MAX; cnt++) {
 		pos += scnprintf(buf + pos, bufsz - pos,
-				 "\t%s\t\t: %u\n",
+				 "\t%25s\t\t: %u\n",
 				 get_mgmt_string(cnt),
 				 priv->rx_stats.mgmt[cnt]);
 	}
 	pos += scnprintf(buf + pos, bufsz - pos, "Control:\n");
 	for (cnt = 0; cnt < CONTROL_MAX; cnt++) {
 		pos += scnprintf(buf + pos, bufsz - pos,
-				 "\t%s\t\t: %u\n",
+				 "\t%25s\t\t: %u\n",
 				 get_ctrl_string(cnt),
 				 priv->rx_stats.ctrl[cnt]);
 	}
-- 
1.5.6.3

