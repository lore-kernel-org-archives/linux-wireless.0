Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:45045 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752631AbXGaC7K (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jul 2007 22:59:10 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 3/7] iwlwifi: Endianity fix for TX host command
Date: Tue, 31 Jul 2007 10:56:32 +0800
Message-Id: <11858506013260-git-send-email-yi.zhu@intel.com>
In-Reply-To: <11858505994113-git-send-email-yi.zhu@intel.com>
References: <11858505963374-git-send-email-yi.zhu@intel.com>
 <118585059814-git-send-email-yi.zhu@intel.com>
 <11858505994113-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch fixes endnianity issues in TX host command.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwl-3945-hw.h  |   10 ++++++++++
 drivers/net/wireless/iwl-4965-hw.h  |   10 +++++++++-
 drivers/net/wireless/iwl-4965.c     |   26 ++++++++++++++------------
 drivers/net/wireless/iwl-base.c     |   10 ++++++----
 drivers/net/wireless/iwl-commands.h |    2 +-
 drivers/net/wireless/iwl-hw.h       |   10 +++++-----
 6 files changed, 45 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/iwl-3945-hw.h b/drivers/net/wireless/iwl-3945-hw.h
index b127450..81c7263 100644
--- a/drivers/net/wireless/iwl-3945-hw.h
+++ b/drivers/net/wireless/iwl-3945-hw.h
@@ -87,4 +87,14 @@ struct iwl_tfd_frame {
 	u8 reserved[28];
 } __attribute__ ((packed));
 
+static inline u8 iwl_hw_get_rate(__le16 rate_n_flags)
+{
+	return le16_to_cpu(rate_n_flags) & 0xFF;
+}
+
+static inline u16 iwl_hw_get_rate_n_flags(__le16 rate_n_flags)
+{
+	return le16_to_cpu(rate_n_flags);
+}
+
 #endif
diff --git a/drivers/net/wireless/iwl-4965-hw.h b/drivers/net/wireless/iwl-4965-hw.h
index 5dec78b..61229c8 100644
--- a/drivers/net/wireless/iwl-4965-hw.h
+++ b/drivers/net/wireless/iwl-4965-hw.h
@@ -768,10 +768,18 @@ struct iwl4965_rx_mpdu_res_start {
 	__le16 reserved;
 } __attribute__ ((packed));
 
-static inline u8 iwl4965_get_rate(__le32 rate_n_flags)
+static inline u8 iwl_hw_get_rate(__le32 rate_n_flags)
 {
 	return le32_to_cpu(rate_n_flags) & 0xFF;
 }
+static inline u16 iwl_hw_get_rate_n_flags(__le32 rate_n_flags)
+{
+	return le32_to_cpu(rate_n_flags) & 0xFFFF;
+}
+static inline __le32 iwl_hw_set_rate_n_flags(u8 rate, u16 flags)
+{
+	return cpu_to_le32(flags|rate);
+}
 #if 0
 
 union iwl_dram_scratch_union {
diff --git a/drivers/net/wireless/iwl-4965.c b/drivers/net/wireless/iwl-4965.c
index 9f4d83a..19591a6 100644
--- a/drivers/net/wireless/iwl-4965.c
+++ b/drivers/net/wireless/iwl-4965.c
@@ -2660,7 +2660,7 @@ void iwl_hw_build_tx_cmd_rate(struct iwl_priv *priv,
 			      struct ieee80211_hdr *hdr, int sta_id,
 			      int is_hcca)
 {
-	int rate = ctrl->tx_rate;
+	u8 rate;
 	u8 rts_retry_limit = 0;
 	u8 data_retry_limit = 0;
 	u32 tx_flags;
@@ -2700,7 +2700,7 @@ void iwl_hw_build_tx_cmd_rate(struct iwl_priv *priv,
 
 	cmd->cmd.tx.rts_retry_limit = rts_retry_limit;
 	cmd->cmd.tx.data_retry_limit = data_retry_limit;
-	cmd->cmd.tx.rate.s.rate = rate;
+	cmd->cmd.tx.rate_n_flags = iwl_hw_set_rate_n_flags(rate, 0);
 	cmd->cmd.tx.tx_flags = tx_flags;
 }
 
@@ -2737,9 +2737,11 @@ int iwl_hw_get_beacon_cmd(struct iwl_priv *priv,
 	tx_beacon_cmd->tx.len = frame_size;
 
 	if ((rate == IWL_RATE_1M_PLCP) || (rate >= IWL_RATE_2M_PLCP))
-		tx_beacon_cmd->tx.rate.rate_n_flags = rate|RATE_MCS_CCK_MSK;
+		tx_beacon_cmd->tx.rate_n_flags =
+			iwl_hw_set_rate_n_flags(rate, RATE_MCS_CCK_MSK);
 	else
-		tx_beacon_cmd->tx.rate.rate_n_flags = rate;
+		tx_beacon_cmd->tx.rate_n_flags =
+			iwl_hw_set_rate_n_flags(rate, 0);
 
 	tx_beacon_cmd->tx.tx_flags = (TX_CMD_FLG_SEQ_CTL_MSK |
 				TX_CMD_FLG_TSF_MSK | TX_CMD_FLG_STA_RATE_MSK);
@@ -3249,6 +3251,7 @@ int iwl4965_tx_cmd(struct iwl_priv *priv, struct iwl_cmd *out_cmd,
 	u8 unicast = 0;
 	u8 is_data = 1;
 	u16 fc;
+	u16 rate_flags;
 	int rate_index = min(ctrl->tx_rate & 0xffff, IWL_RATE_COUNT - 1);
 #ifdef CONFIG_IWLWIFI_HT
 #ifdef CONFIG_IWLWIFI_HT_AGG
@@ -3290,29 +3293,28 @@ int iwl4965_tx_cmd(struct iwl_priv *priv, struct iwl_cmd *out_cmd,
 	/* Hard coded to start at the highest retry fallback position
 	 * until the 4965 specific rate control algorithm is tied in */
 	tx->initial_rate_index = LINK_QUAL_MAX_RETRY_NUM - 1;
-	tx->rate.s.rate = iwl_rates[rate_index].plcp;
 
 	/* Alternate between antenna A and B for successive frames */
 	if (priv->use_ant_b_for_management_frame) {
 		priv->use_ant_b_for_management_frame = 0;
-		tx->rate.rate_n_flags |= RATE_MCS_ANT_B_MSK;
-		tx->rate.rate_n_flags &= ~RATE_MCS_ANT_A_MSK;
+		rate_flags = RATE_MCS_ANT_B_MSK;
 	} else {
 		priv->use_ant_b_for_management_frame = 1;
-		tx->rate.rate_n_flags |= RATE_MCS_ANT_A_MSK;
-		tx->rate.rate_n_flags &= ~RATE_MCS_ANT_B_MSK;
+		rate_flags = RATE_MCS_ANT_A_MSK;
 	}
 
 	if (!unicast || !is_data ) {
 		if ((rate_index >= IWL_FIRST_CCK_RATE) &&
 		    (rate_index <= IWL_LAST_CCK_RATE))
-			tx->rate.rate_n_flags |= RATE_MCS_CCK_MSK;
-
+			rate_flags |= RATE_MCS_CCK_MSK;
 	} else {
 		tx->initial_rate_index = 0;
 		tx->tx_flags |= TX_CMD_FLG_STA_RATE_MSK;
 	}
 
+	tx->rate_n_flags = iwl_hw_set_rate_n_flags(iwl_rates[rate_index].plcp,
+						rate_flags);
+
 	if (ieee80211_is_probe_request(fc))
 		tx->tx_flags |= TX_CMD_FLG_TSF_MSK;
 	else if (ieee80211_is_back_request(fc))
@@ -3825,7 +3827,7 @@ static void iwl4965_rx_reply_rx(struct iwl_priv *priv,
 			(rx_start->phy_flags & RX_RES_PHY_FLAGS_BAND_24_MSK) ?
 			MODE_IEEE80211G : MODE_IEEE80211A,
 		.antenna = 0,
-		.rate = iwl4965_get_rate(rx_start->rate_n_flags),
+		.rate = iwl_hw_get_rate(rx_start->rate_n_flags),
 		.flag = le16_to_cpu(rx_start->phy_flags),
 #ifdef CONFIG_IWLWIFI_HT_AGG
 		.ordered = 0
diff --git a/drivers/net/wireless/iwl-base.c b/drivers/net/wireless/iwl-base.c
index 574d01c..a2560d3 100644
--- a/drivers/net/wireless/iwl-base.c
+++ b/drivers/net/wireless/iwl-base.c
@@ -7087,8 +7087,9 @@ static void iwl_bg_request_scan(struct work_struct *data)
 #if IWL == 3945
 		scan->tx_cmd.rate = IWL_RATE_1M_PLCP;
 #elif IWL == 4965
-		scan->tx_cmd.rate.s.rate = IWL_RATE_1M_PLCP;
-		scan->tx_cmd.rate.s.flags = 0x80 | 0x2;
+		scan->tx_cmd.rate_n_flags =
+				iwl_hw_set_rate_n_flags(IWL_RATE_1M_PLCP,
+				RATE_MCS_ANT_B_MSK|RATE_MCS_CCK_MSK);
 #endif
 		scan->good_CRC_th = 0;
 		phymode = MODE_IEEE80211G;
@@ -7098,8 +7099,9 @@ static void iwl_bg_request_scan(struct work_struct *data)
 #if IWL == 3945
 		scan->tx_cmd.rate = IWL_RATE_6M_PLCP;
 #elif IWL == 4965
-		scan->tx_cmd.rate.s.rate = IWL_RATE_6M_PLCP;
-		scan->tx_cmd.rate.s.flags = 0x80;
+		scan->tx_cmd.rate_n_flags =
+				iwl_hw_set_rate_n_flags(IWL_RATE_6M_PLCP,
+				RATE_MCS_ANT_B_MSK);
 #endif
 		scan->good_CRC_th = IWL_GOOD_CRC_TH;
 		phymode = MODE_IEEE80211A;
diff --git a/drivers/net/wireless/iwl-commands.h b/drivers/net/wireless/iwl-commands.h
index e3f2977..0faf9c0 100644
--- a/drivers/net/wireless/iwl-commands.h
+++ b/drivers/net/wireless/iwl-commands.h
@@ -245,7 +245,7 @@ struct iwl_tx_cmd {
 	u8 tid_tspec;
 #elif IWL == 4965
 	struct iwl_dram_scratch scratch;
-	struct iwl_rate rate;
+	__le32 rate_n_flags;
 	u8 sta_id;
 #endif
 	u8 sec_ctl;
diff --git a/drivers/net/wireless/iwl-hw.h b/drivers/net/wireless/iwl-hw.h
index e73cf88..25a4728 100644
--- a/drivers/net/wireless/iwl-hw.h
+++ b/drivers/net/wireless/iwl-hw.h
@@ -322,11 +322,11 @@ enum {
  *          10 B active, A inactive
  *          11 Both active
  */
-#define RATE_MCS_ANT_A_POS 14
-#define RATE_MCS_ANT_B_POS 15
-#define RATE_MCS_ANT_A_MSK 	__constant_cpu_to_le16(0x4000)
-#define RATE_MCS_ANT_B_MSK 	__constant_cpu_to_le16(0x8000)
-#define RATE_MCS_ANT_AB_MSK 	__constant_cpu_to_le16(0xc000)
+#define RATE_MCS_ANT_A_POS	14
+#define RATE_MCS_ANT_B_POS	15
+#define RATE_MCS_ANT_A_MSK	0x4000
+#define RATE_MCS_ANT_B_MSK	0x8000
+#define RATE_MCS_ANT_AB_MSK	0xc000
 
 /*
  * WEP/CKIP group key command
-- 
1.5.2
