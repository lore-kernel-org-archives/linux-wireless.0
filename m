Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:54843 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752532AbYLSCpA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2008 21:45:00 -0500
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Tomas Winkler <tomas.winkler@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 06/43] iwlwifi: 3945 drop usage of union tsf
Date: Fri, 19 Dec 2008 10:37:06 +0800
Message-Id: <1229654263-21454-7-git-send-email-yi.zhu@intel.com> (sfid-20081219_034507_822758_DE60B225)
In-Reply-To: <1229654263-21454-6-git-send-email-yi.zhu@intel.com>
References: <1229654263-21454-1-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-2-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-3-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-4-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-5-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-6-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch replaces union tsf with u64
This also allows to use iwl_error_res
and iwl_rxon_time_cmd instead of 3945 structures

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Acked-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945-commands.h |   33 +---------------------
 drivers/net/wireless/iwlwifi/iwl-3945.h          |    7 ++--
 drivers/net/wireless/iwlwifi/iwl3945-base.c      |   18 ++++--------
 3 files changed, 10 insertions(+), 48 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-commands.h b/drivers/net/wireless/iwlwifi/iwl-3945-commands.h
index fe71e0a..42ef51f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-commands.h
@@ -173,25 +173,6 @@ struct iwl3945_alive_resp {
 	__le32 is_valid;
 } __attribute__ ((packed));
 
-union tsf {
-	u8 byte[8];
-	__le16 word[4];
-	__le32 dw[2];
-};
-
-/*
- * REPLY_ERROR = 0x2 (response only, not a command)
- */
-struct iwl3945_error_resp {
-	__le32 error_type;
-	u8 cmd_id;
-	u8 reserved1;
-	__le16 bad_cmd_seq_num;
-	__le16 reserved2;
-	__le32 error_info;
-	union tsf timestamp;
-} __attribute__ ((packed));
-
 /******************************************************************************
  * (1)
  * RXON Commands & Responses:
@@ -246,18 +227,6 @@ struct iwl3945_rxon_assoc_cmd {
 } __attribute__ ((packed));
 
 /*
- * REPLY_RXON_TIMING = 0x14 (command, has simple generic response)
- */
-struct iwl3945_rxon_time_cmd {
-	union tsf timestamp;
-	__le16 beacon_interval;
-	__le16 atim_window;
-	__le32 beacon_init_val;
-	__le16 listen_interval;
-	__le16 reserved;
-} __attribute__ ((packed));
-
-/*
  * REPLY_CHANNEL_SWITCH = 0x72 (command, has simple generic response)
  */
 struct iwl3945_channel_switch_cmd {
@@ -783,7 +752,7 @@ struct iwl3945_rx_packet {
 		struct iwl3945_tx_resp tx_resp;
 		struct iwl_spectrum_notification spectrum_notif;
 		struct iwl_csa_notification csa_notif;
-		struct iwl3945_error_resp err_resp;
+		struct iwl_error_resp err_resp;
 		struct iwl_card_state_notif card_state_notif;
 		struct iwl3945_beacon_notif beacon_status;
 		struct iwl_add_sta_resp add_sta;
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
index 1c9e126..12ead38 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -337,7 +337,7 @@ struct iwl3945_cmd {
 		u16 val16;
 		u32 val32;
 		struct iwl_bt_cmd bt;
-		struct iwl3945_rxon_time_cmd rxon_time;
+		struct iwl_rxon_time_cmd rxon_time;
 		struct iwl_powertable_cmd powertable;
 		struct iwl_qosparam_cmd qosparam;
 		struct iwl3945_tx_cmd tx;
@@ -754,7 +754,7 @@ struct iwl3945_priv {
 	struct fw_desc ucode_boot;	/* bootstrap inst */
 
 
-	struct iwl3945_rxon_time_cmd rxon_timing;
+	struct iwl_rxon_time_cmd rxon_timing;
 
 	/* We declare this const so it can only be
 	 * changed via explicit cast within the
@@ -844,8 +844,7 @@ struct iwl3945_priv {
 	struct sk_buff *ibss_beacon;
 
 	/* Last Rx'd beacon timestamp */
-	u32 timestamp0;
-	u32 timestamp1;
+	u64 timestamp;
 	u16 beacon_int;
 	struct iwl3945_driver_hw_info hw_setting;
 	struct ieee80211_vif *vif;
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 0764f37..5f90445 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -2060,13 +2060,10 @@ static void iwl3945_setup_rxon_timing(struct iwl3945_priv *priv)
 	conf = ieee80211_get_hw_conf(priv->hw);
 
 	spin_lock_irqsave(&priv->lock, flags);
-	priv->rxon_timing.timestamp.dw[1] = cpu_to_le32(priv->timestamp1);
-	priv->rxon_timing.timestamp.dw[0] = cpu_to_le32(priv->timestamp0);
-
+	priv->rxon_timing.timestamp = cpu_to_le64(priv->timestamp);
 	priv->rxon_timing.listen_interval = INTEL_CONN_LISTEN_INTERVAL;
 
-	tsf = priv->timestamp1;
-	tsf = ((tsf << 32) | priv->timestamp0);
+	tsf = priv->timestamp;
 
 	beacon_int = priv->beacon_int;
 	spin_unlock_irqrestore(&priv->lock, flags);
@@ -6318,7 +6315,7 @@ static void iwl3945_post_associate(struct iwl3945_priv *priv)
 	priv->staging_rxon.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
 	iwl3945_commit_rxon(priv);
 
-	memset(&priv->rxon_timing, 0, sizeof(struct iwl3945_rxon_time_cmd));
+	memset(&priv->rxon_timing, 0, sizeof(struct iwl_rxon_time_cmd));
 	iwl3945_setup_rxon_timing(priv);
 	rc = iwl3945_send_cmd_pdu(priv, REPLY_RXON_TIMING,
 			      sizeof(priv->rxon_timing), &priv->rxon_timing);
@@ -6699,7 +6696,7 @@ static void iwl3945_config_ap(struct iwl3945_priv *priv)
 		iwl3945_commit_rxon(priv);
 
 		/* RXON Timing */
-		memset(&priv->rxon_timing, 0, sizeof(struct iwl3945_rxon_time_cmd));
+		memset(&priv->rxon_timing, 0, sizeof(struct iwl_rxon_time_cmd));
 		iwl3945_setup_rxon_timing(priv);
 		rc = iwl3945_send_cmd_pdu(priv, REPLY_RXON_TIMING,
 				sizeof(priv->rxon_timing), &priv->rxon_timing);
@@ -6949,9 +6946,7 @@ static void iwl3945_bss_info_changed(struct ieee80211_hw *hw,
 		if (bss_conf->assoc) {
 			priv->assoc_id = bss_conf->aid;
 			priv->beacon_int = bss_conf->beacon_int;
-			priv->timestamp0 = bss_conf->timestamp & 0xFFFFFFFF;
-			priv->timestamp1 = (bss_conf->timestamp >> 32) &
-					     0xFFFFFFFF;
+			priv->timestamp = bss_conf->timestamp;
 			priv->assoc_capability = bss_conf->assoc_capability;
 			priv->next_scan_jiffies = jiffies +
 					IWL_DELAY_NEXT_SCAN_AFTER_ASSOC;
@@ -7195,8 +7190,7 @@ static void iwl3945_mac_reset_tsf(struct ieee80211_hw *hw)
 	priv->ibss_beacon = NULL;
 
 	priv->beacon_int = priv->hw->conf.beacon_int;
-	priv->timestamp1 = 0;
-	priv->timestamp0 = 0;
+	priv->timestamp = 0;
 	if ((priv->iw_mode == NL80211_IFTYPE_STATION))
 		priv->beacon_int = 0;
 
-- 
1.5.3.6

