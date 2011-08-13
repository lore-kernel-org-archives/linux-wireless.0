Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:16165 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751314Ab1HMSS0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Aug 2011 14:18:26 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 03/60] iwlagn: use iwl_get_debug_level instead of iwl_debug_level
Date: Sat, 13 Aug 2011 10:37:39 -0700
Message-Id: <1313257116-2697-4-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110813_201829_819097_B88F895E)
In-Reply-To: <1313257116-2697-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1313257116-2697-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

The latter may return incomplete information.
For example, if one switched IWL_DL_TX on through sysfs, IWL_DL_TX bit would
have been set in priv->debug_level, but since iwl_alloc_traffic_mem looked at
iwl_debug_level only, it wouldn't have allocated the tx_traffic buffer.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c    |    8 ++++----
 drivers/net/wireless/iwlwifi/iwl-debugfs.c |    4 ++--
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index e1c5f59..0d8fd5b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1398,7 +1398,7 @@ int iwl_alloc_traffic_mem(struct iwl_priv *priv)
 {
 	u32 traffic_size = IWL_TRAFFIC_DUMP_SIZE;
 
-	if (iwl_debug_level & IWL_DL_TX) {
+	if (iwl_get_debug_level(priv) & IWL_DL_TX) {
 		if (!priv->tx_traffic) {
 			priv->tx_traffic =
 				kzalloc(traffic_size, GFP_KERNEL);
@@ -1406,7 +1406,7 @@ int iwl_alloc_traffic_mem(struct iwl_priv *priv)
 				return -ENOMEM;
 		}
 	}
-	if (iwl_debug_level & IWL_DL_RX) {
+	if (iwl_get_debug_level(priv) & IWL_DL_RX) {
 		if (!priv->rx_traffic) {
 			priv->rx_traffic =
 				kzalloc(traffic_size, GFP_KERNEL);
@@ -1433,7 +1433,7 @@ void iwl_dbg_log_tx_data_frame(struct iwl_priv *priv,
 	__le16 fc;
 	u16 len;
 
-	if (likely(!(iwl_debug_level & IWL_DL_TX)))
+	if (likely(!(iwl_get_debug_level(priv) & IWL_DL_TX)))
 		return;
 
 	if (!priv->tx_traffic)
@@ -1457,7 +1457,7 @@ void iwl_dbg_log_rx_data_frame(struct iwl_priv *priv,
 	__le16 fc;
 	u16 len;
 
-	if (likely(!(iwl_debug_level & IWL_DL_RX)))
+	if (likely(!(iwl_get_debug_level(priv) & IWL_DL_RX)))
 		return;
 
 	if (!priv->rx_traffic)
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index ec1485b..08fc2b2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -915,7 +915,7 @@ static ssize_t iwl_dbgfs_traffic_log_read(struct file *file,
 				"q[%d]: read_ptr: %u, write_ptr: %u\n",
 				cnt, q->read_ptr, q->write_ptr);
 	}
-	if (priv->tx_traffic && (iwl_debug_level & IWL_DL_TX)) {
+	if (priv->tx_traffic && (iwl_get_debug_level(priv) & IWL_DL_TX)) {
 		ptr = priv->tx_traffic;
 		pos += scnprintf(buf + pos, bufsz - pos,
 				"Tx Traffic idx: %u\n",	priv->tx_traffic_idx);
@@ -938,7 +938,7 @@ static ssize_t iwl_dbgfs_traffic_log_read(struct file *file,
 			"read: %u, write: %u\n",
 			 rxq->read, rxq->write);
 
-	if (priv->rx_traffic && (iwl_debug_level & IWL_DL_RX)) {
+	if (priv->rx_traffic && (iwl_get_debug_level(priv) & IWL_DL_RX)) {
 		ptr = priv->rx_traffic;
 		pos += scnprintf(buf + pos, bufsz - pos,
 				"Rx Traffic idx: %u\n",	priv->rx_traffic_idx);
-- 
1.7.0.4

