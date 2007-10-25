Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:44836 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754079AbXJYJWf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Oct 2007 05:22:35 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 06/30] iwlwifi: remove cck_flag from iwl_driver_hw_info
Date: Thu, 25 Oct 2007 17:15:27 +0800
Message-Id: <11933037601236-git-send-email-yi.zhu@intel.com> (sfid-20071025_102246_948719_73A6E73B)
In-Reply-To: <11933037584069-git-send-email-yi.zhu@intel.com>
References: <11933037512140-git-send-email-yi.zhu@intel.com>
 <11933037541699-git-send-email-yi.zhu@intel.com>
 <11933037553170-git-send-email-yi.zhu@intel.com>
 <119330375796-git-send-email-yi.zhu@intel.com>
 <11933037584069-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch remove cck_flag from iwl_driver_hw_info, this flag
is unused after spliting the iwl-base.c

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c     |    1 -
 drivers/net/wireless/iwlwifi/iwl-4965.c     |    2 --
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    6 ++++--
 drivers/net/wireless/iwlwifi/iwlwifi.h      |    3 +--
 4 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index b71457c..8b7db0c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -2210,7 +2210,6 @@ int iwl_hw_set_hw_setting(struct iwl_priv *priv)
 	priv->hw_setting.tx_cmd_len = sizeof(struct iwl_tx_cmd);
 	priv->hw_setting.max_rxq_size = RX_QUEUE_SIZE;
 	priv->hw_setting.max_rxq_log = RX_QUEUE_SIZE_LOG;
-	priv->hw_setting.cck_flag = 0;
 	priv->hw_setting.max_stations = IWL3945_STATION_COUNT;
 	priv->hw_setting.bcast_sta_id = IWL3945_BROADCAST_ID;
 	return 0;
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 1e5b122..4710f6e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -1720,8 +1720,6 @@ int iwl_hw_set_hw_setting(struct iwl_priv *priv)
 
 	priv->hw_setting.max_txq_num = iwl_param_queues_num;
 	priv->hw_setting.ac_queue_count = AC_NUM;
-
-	priv->hw_setting.cck_flag = RATE_MCS_CCK_MSK;
 	priv->hw_setting.tx_cmd_len = sizeof(struct iwl_tx_cmd);
 	priv->hw_setting.max_rxq_size = RX_QUEUE_SIZE;
 	priv->hw_setting.max_rxq_log = RX_QUEUE_SIZE_LOG;
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index ea8ab8c..a435977 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -505,8 +505,10 @@ u8 iwl_add_station(struct iwl_priv *priv, const u8 *addr, int is_ap, u8 flags)
 	station->sta.sta.sta_id = index;
 	station->sta.station_flags = 0;
 
-	rate = (priv->phymode == MODE_IEEE80211A) ? IWL_RATE_6M_PLCP :
-				IWL_RATE_1M_PLCP | priv->hw_setting.cck_flag;
+	if (priv->phymode == MODE_IEEE80211A)
+		rate = IWL_RATE_6M_PLCP;
+	else
+		rate =	IWL_RATE_1M_PLCP;
 
 	/* Turn on both antennas for the station... */
 	station->sta.rate_n_flags =
diff --git a/drivers/net/wireless/iwlwifi/iwlwifi.h b/drivers/net/wireless/iwlwifi/iwlwifi.h
index bcff696..c5c9c5d 100644
--- a/drivers/net/wireless/iwlwifi/iwlwifi.h
+++ b/drivers/net/wireless/iwlwifi/iwlwifi.h
@@ -527,11 +527,10 @@ struct iwl_ibss_seq {
 struct iwl_driver_hw_info {
 	u16 max_txq_num;
 	u16 ac_queue_count;
-	u32 rx_buffer_size;
 	u16 tx_cmd_len;
 	u16 max_rxq_size;
+	u32 rx_buffer_size;
 	u16 max_rxq_log;
-	u32 cck_flag;
 	u8  max_stations;
 	u8  bcast_sta_id;
 	void *shared_virt;
-- 
1.5.2
