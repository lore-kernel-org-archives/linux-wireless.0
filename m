Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:33093 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755648AbYBMTfH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Feb 2008 14:35:07 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 3/3] iwlwifi: Add tx_ant_num hw setting variable
Date: Wed, 13 Feb 2008 11:32:31 -0800
Message-Id: <1202931151-4141-4-git-send-email-reinette.chatre@intel.com> (sfid-20080213_193515_062685_61D3D1FE)
In-Reply-To: <1202931151-4141-3-git-send-email-reinette.chatre@intel.com>
References: <1202931151-4141-1-git-send-email-reinette.chatre@intel.com>
 <1202931151-4141-2-git-send-email-reinette.chatre@intel.com>
 <1202931151-4141-3-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

Added tx_ant_num variable into hw_setting
This will be used for scanning TX antenna toggling
On the way removed ac_queue_num unused

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c |    3 ++-
 drivers/net/wireless/iwlwifi/iwl-3945.h |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-4965.c |    4 +++-
 drivers/net/wireless/iwlwifi/iwl-4965.h |    4 ++--
 4 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 50d927b..82d2827 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -2300,7 +2300,6 @@ int iwl3945_hw_set_hw_setting(struct iwl3945_priv *priv)
 		return -ENOMEM;
 	}
 
-	priv->hw_setting.ac_queue_count = AC_NUM;
 	priv->hw_setting.rx_buf_size = IWL_RX_BUF_SIZE;
 	priv->hw_setting.max_pkt_size = 2342;
 	priv->hw_setting.tx_cmd_len = sizeof(struct iwl3945_tx_cmd);
@@ -2308,6 +2307,8 @@ int iwl3945_hw_set_hw_setting(struct iwl3945_priv *priv)
 	priv->hw_setting.max_rxq_log = RX_QUEUE_SIZE_LOG;
 	priv->hw_setting.max_stations = IWL3945_STATION_COUNT;
 	priv->hw_setting.bcast_sta_id = IWL3945_BROADCAST_ID;
+
+	priv->hw_setting.tx_ant_num = 2;
 	return 0;
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
index 393cff6..dde389d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -508,8 +508,8 @@ struct iwl3945_ibss_seq {
 /**
  * struct iwl3945_driver_hw_info
  * @max_txq_num: Max # Tx queues supported
- * @ac_queue_count: # Tx queues for EDCA Access Categories (AC)
  * @tx_cmd_len: Size of Tx command (but not including frame itself)
+ * @tx_ant_num: Number of TX antennas
  * @max_rxq_size: Max # Rx frames in Rx queue (must be power-of-2)
  * @rx_buf_size:
  * @max_pkt_size:
@@ -521,8 +521,8 @@ struct iwl3945_ibss_seq {
  */
 struct iwl3945_driver_hw_info {
 	u16 max_txq_num;
-	u16 ac_queue_count;
 	u16 tx_cmd_len;
+	u16 tx_ant_num;
 	u16 max_rxq_size;
 	u32 rx_buf_size;
 	u32 max_pkt_size;
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index cc141f8..237d3b2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -1794,7 +1794,6 @@ int iwl4965_hw_set_hw_setting(struct iwl4965_priv *priv)
 	memset(priv->hw_setting.shared_virt, 0, sizeof(struct iwl4965_shared));
 
 	priv->hw_setting.max_txq_num = iwl4965_param_queues_num;
-	priv->hw_setting.ac_queue_count = AC_NUM;
 	priv->hw_setting.tx_cmd_len = sizeof(struct iwl4965_tx_cmd);
 	priv->hw_setting.max_rxq_size = RX_QUEUE_SIZE;
 	priv->hw_setting.max_rxq_log = RX_QUEUE_SIZE_LOG;
@@ -1805,6 +1804,9 @@ int iwl4965_hw_set_hw_setting(struct iwl4965_priv *priv)
 	priv->hw_setting.max_pkt_size = priv->hw_setting.rx_buf_size - 256;
 	priv->hw_setting.max_stations = IWL4965_STATION_COUNT;
 	priv->hw_setting.bcast_sta_id = IWL4965_BROADCAST_ID;
+
+	priv->hw_setting.tx_ant_num = 2;
+
 	return 0;
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.h b/drivers/net/wireless/iwlwifi/iwl-4965.h
index 67189ab..ce17e4f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.h
@@ -580,8 +580,8 @@ struct iwl4965_ibss_seq {
 /**
  * struct iwl4965_driver_hw_info
  * @max_txq_num: Max # Tx queues supported
- * @ac_queue_count: # Tx queues for EDCA Access Categories (AC)
  * @tx_cmd_len: Size of Tx command (but not including frame itself)
+ * @tx_ant_num: Number of TX antennas
  * @max_rxq_size: Max # Rx frames in Rx queue (must be power-of-2)
  * @rx_buffer_size:
  * @max_rxq_log: Log-base-2 of max_rxq_size
@@ -592,8 +592,8 @@ struct iwl4965_ibss_seq {
  */
 struct iwl4965_driver_hw_info {
 	u16 max_txq_num;
-	u16 ac_queue_count;
 	u16 tx_cmd_len;
+	u16 tx_ant_num;
 	u16 max_rxq_size;
 	u32 rx_buf_size;
 	u32 max_pkt_size;
-- 
1.5.3.4

