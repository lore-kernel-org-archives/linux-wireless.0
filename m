Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:36539 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753769AbZKTUFH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Nov 2009 15:05:07 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 06/19] iwl3945: removed unused struct and definitions
Date: Fri, 20 Nov 2009 12:04:57 -0800
Message-Id: <1258747510-21233-7-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1258747510-21233-1-git-send-email-reinette.chatre@intel.com>
References: <1258747510-21233-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Reinette Chatre <reinette.chatre@intel.com>

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.h |    9 ---------
 drivers/net/wireless/iwlwifi/iwl-dev.h  |    8 --------
 2 files changed, 0 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
index 2b0d65c..a41f0e0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -221,19 +221,10 @@ struct iwl3945_ibss_seq {
  * for use by iwl-*.c
  *
  *****************************************************************************/
-extern int iwl3945_power_init_handle(struct iwl_priv *priv);
-extern int iwl3945_eeprom_init(struct iwl_priv *priv);
 extern int iwl3945_calc_db_from_ratio(int sig_ratio);
 extern int iwl3945_calc_sig_qual(int rssi_dbm, int noise_dbm);
-extern int iwl3945_tx_queue_init(struct iwl_priv *priv,
-			     struct iwl_tx_queue *txq, int count, u32 id);
 extern void iwl3945_rx_replenish(void *data);
 extern void iwl3945_rx_queue_reset(struct iwl_priv *priv, struct iwl_rx_queue *rxq);
-extern void iwl3945_tx_queue_free(struct iwl_priv *priv, struct iwl_tx_queue *txq);
-extern int iwl3945_send_cmd_pdu(struct iwl_priv *priv, u8 id, u16 len,
-			    const void *data);
-extern int __must_check iwl3945_send_cmd(struct iwl_priv *priv,
-					 struct iwl_host_cmd *cmd);
 extern unsigned int iwl3945_fill_beacon_frame(struct iwl_priv *priv,
 					struct ieee80211_hdr *hdr,int left);
 extern void iwl3945_dump_nic_event_log(struct iwl_priv *priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 1c1ed4b..4ded190 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -544,14 +544,6 @@ struct iwl_qos_info {
 	struct iwl_qosparam_cmd def_qos_parm;
 };
 
-
-struct iwl3945_station_entry {
-	struct iwl3945_addsta_cmd sta;
-	struct iwl_tid_data tid[MAX_TID_COUNT];
-	u8 used;
-	struct iwl_hw_key keyinfo;
-};
-
 struct iwl_station_entry {
 	struct iwl_addsta_cmd sta;
 	struct iwl_tid_data tid[MAX_TID_COUNT];
-- 
1.5.6.3

