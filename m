Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:56235 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751341AbYDOXCI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Apr 2008 19:02:08 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Tomas Winkler <tomas.winkler@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 03/11] iwlwifi: support different num of tx and rx antennas
Date: Tue, 15 Apr 2008 16:01:39 -0700
Message-Id: <1208300507-25628-4-git-send-email-reinette.chatre@intel.com> (sfid-20080416_000231_810483_F6B19C85)
In-Reply-To: <1208300507-25628-3-git-send-email-reinette.chatre@intel.com>
References: <1208300507-25628-1-git-send-email-reinette.chatre@intel.com>
 <1208300507-25628-2-git-send-email-reinette.chatre@intel.com>
 <1208300507-25628-3-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch adds infrastructure for supporting different
number of tx and rx antennas

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965-commands.h |    9 ++++-----
 drivers/net/wireless/iwlwifi/iwl-4965.c          |    7 +++++--
 drivers/net/wireless/iwlwifi/iwl-4965.h          |    7 +++++--
 3 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-commands.h b/drivers/net/wireless/iwlwifi/iwl-4965-commands.h
index 65cd8ae..7aa7f0b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-commands.h
@@ -269,11 +269,10 @@ struct iwl_cmd_header {
  *          10 B active, A inactive
  *          11 Both active
  */
-#define RATE_MCS_ANT_A_POS	14
-#define RATE_MCS_ANT_B_POS	15
-#define RATE_MCS_ANT_A_MSK	0x4000
-#define RATE_MCS_ANT_B_MSK	0x8000
-#define RATE_MCS_ANT_AB_MSK	0xc000
+#define RATE_MCS_ANT_POS       14
+#define RATE_MCS_ANT_A_MSK     0x04000
+#define RATE_MCS_ANT_B_MSK     0x08000
+#define RATE_MCS_ANT_AB_MSK    0x0C000
 
 
 /**
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index a1e91db..e647be7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -410,7 +410,7 @@ void iwl4965_hwrate_to_tx_control(struct iwl_priv *priv, u32 rate_n_flags,
 	int rate_index;
 
 	control->antenna_sel_tx =
-		((rate_n_flags & RATE_MCS_ANT_AB_MSK) >> RATE_MCS_ANT_A_POS);
+		((rate_n_flags & RATE_MCS_ANT_AB_MSK) >> RATE_MCS_ANT_POS);
 	if (rate_n_flags & RATE_MCS_HT_MSK)
 		control->flags |= IEEE80211_TXCTL_OFDM_HT;
 	if (rate_n_flags & RATE_MCS_GF_MSK)
@@ -2040,7 +2040,10 @@ int iwl4965_hw_set_hw_params(struct iwl_priv *priv)
 	priv->hw_params.max_stations = IWL4965_STATION_COUNT;
 	priv->hw_params.bcast_sta_id = IWL4965_BROADCAST_ID;
 
-	priv->hw_params.tx_ant_num = 2;
+	priv->hw_params.tx_chains_num = 2;
+	priv->hw_params.rx_chains_num = 2;
+	priv->hw_params.valid_tx_ant = (IWL_ANTENNA_MAIN | IWL_ANTENNA_AUX);
+	priv->hw_params.valid_rx_ant = (IWL_ANTENNA_MAIN | IWL_ANTENNA_AUX);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.h b/drivers/net/wireless/iwlwifi/iwl-4965.h
index c127c91..cf909e8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.h
@@ -580,11 +580,14 @@ struct iwl4965_ibss_seq {
 struct iwl_hw_params {
 	u16 max_txq_num;
 	u16 tx_cmd_len;
-	u16 tx_ant_num;
+	u8  tx_chains_num;
+	u8  rx_chains_num;
+	u8  valid_tx_ant;
+	u8  valid_rx_ant;
 	u16 max_rxq_size;
+	u16 max_rxq_log;
 	u32 rx_buf_size;
 	u32 max_pkt_size;
-	u16 max_rxq_log;
 	u8  max_stations;
 	u8  bcast_sta_id;
 };
-- 
1.5.3.4

