Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:62939 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932316Ab0AOVnx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jan 2010 16:43:53 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 8/9] iwlwifi: remove extra statistics request from debugfs
Date: Fri, 15 Jan 2010 13:43:40 -0800
Message-Id: <1263591821-14867-9-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1263591821-14867-1-git-send-email-reinette.chatre@intel.com>
References: <1263591821-14867-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

When reading current ucode statistics information from debugfs, in
current implementation, it will always send a new "statistics request" to
uCode. In normal operation, uCode should report the statistics per beacon
interval. Remove this extra request to reduce the additional command exchanges
between driver and uCode.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-debugfs.c |   41 ----------------------------
 1 files changed, 0 insertions(+), 41 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index a3d461f..38e2f9f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -1109,16 +1109,6 @@ static ssize_t iwl_dbgfs_ucode_rx_stats_read(struct file *file,
 	if (!iwl_is_alive(priv))
 		return -EAGAIN;
 
-	/* make request to uCode to retrieve statistics information */
-	mutex_lock(&priv->mutex);
-	ret = iwl_send_statistics_request(priv, CMD_SYNC, false);
-	mutex_unlock(&priv->mutex);
-
-	if (ret) {
-		IWL_ERR(priv,
-			"Error sending statistics request: %zd\n", ret);
-		return -EAGAIN;
-	}
 	buf = kzalloc(bufsz, GFP_KERNEL);
 	if (!buf) {
 		IWL_ERR(priv, "Can not allocate Buffer\n");
@@ -1552,16 +1542,6 @@ static ssize_t iwl_dbgfs_ucode_tx_stats_read(struct file *file,
 	if (!iwl_is_alive(priv))
 		return -EAGAIN;
 
-	/* make request to uCode to retrieve statistics information */
-	mutex_lock(&priv->mutex);
-	ret = iwl_send_statistics_request(priv, CMD_SYNC, false);
-	mutex_unlock(&priv->mutex);
-
-	if (ret) {
-		IWL_ERR(priv,
-			"Error sending statistics request: %zd\n", ret);
-		return -EAGAIN;
-	}
 	buf = kzalloc(bufsz, GFP_KERNEL);
 	if (!buf) {
 		IWL_ERR(priv, "Can not allocate Buffer\n");
@@ -1739,16 +1719,6 @@ static ssize_t iwl_dbgfs_ucode_general_stats_read(struct file *file,
 	if (!iwl_is_alive(priv))
 		return -EAGAIN;
 
-	/* make request to uCode to retrieve statistics information */
-	mutex_lock(&priv->mutex);
-	ret = iwl_send_statistics_request(priv, CMD_SYNC, false);
-	mutex_unlock(&priv->mutex);
-
-	if (ret) {
-		IWL_ERR(priv,
-			"Error sending statistics request: %zd\n", ret);
-		return -EAGAIN;
-	}
 	buf = kzalloc(bufsz, GFP_KERNEL);
 	if (!buf) {
 		IWL_ERR(priv, "Can not allocate Buffer\n");
@@ -1986,23 +1956,12 @@ static ssize_t iwl_dbgfs_tx_power_read(struct file *file,
 	struct iwl_priv *priv = file->private_data;
 	char buf[128];
 	int pos = 0;
-	ssize_t ret;
 	const size_t bufsz = sizeof(buf);
 	struct statistics_tx *tx;
 
 	if (!iwl_is_alive(priv))
 		pos += scnprintf(buf + pos, bufsz - pos, "N/A\n");
 	else {
-		/* make request to uCode to retrieve statistics information */
-		mutex_lock(&priv->mutex);
-		ret = iwl_send_statistics_request(priv, CMD_SYNC, false);
-		mutex_unlock(&priv->mutex);
-
-		if (ret) {
-			IWL_ERR(priv, "Error sending statistics request: %zd\n",
-				ret);
-			return -EAGAIN;
-		}
 		tx = &priv->statistics.tx;
 		if (tx->tx_power.ant_a ||
 		    tx->tx_power.ant_b ||
-- 
1.6.3.3

