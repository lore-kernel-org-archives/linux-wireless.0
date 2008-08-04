Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:6330 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751822AbYHDIDw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Aug 2008 04:03:52 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 04/10] iwlwifi: implement iwl5000_calc_rssi
Date: Mon,  4 Aug 2008 16:00:42 +0800
Message-Id: <1217836848-24288-5-git-send-email-yi.zhu@intel.com> (sfid-20080804_100358_461307_C48CBAEB)
In-Reply-To: <1217836848-24288-4-git-send-email-yi.zhu@intel.com>
References: <1217836848-24288-1-git-send-email-yi.zhu@intel.com>
 <1217836848-24288-2-git-send-email-yi.zhu@intel.com>
 <1217836848-24288-3-git-send-email-yi.zhu@intel.com>
 <1217836848-24288-4-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch implements rssi calculation for 5000 HW.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c     |   35 ++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-5000.c     |   39 ++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-commands.h |   35 +++++++++++++----
 drivers/net/wireless/iwlwifi/iwl-core.h     |    2 +
 drivers/net/wireless/iwlwifi/iwl-rx.c       |   57 +++++++--------------------
 5 files changed, 118 insertions(+), 50 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index e261bc9..5cd10da 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -2258,6 +2258,40 @@ static void iwl4965_rx_reply_tx(struct iwl_priv *priv,
 		IWL_ERROR("TODO:  Implement Tx ABORT REQUIRED!!!\n");
 }
 
+static int iwl4965_calc_rssi(struct iwl_priv *priv,
+			     struct iwl_rx_phy_res *rx_resp)
+{
+	/* data from PHY/DSP regarding signal strength, etc.,
+	 *   contents are always there, not configurable by host.  */
+	struct iwl4965_rx_non_cfg_phy *ncphy =
+	    (struct iwl4965_rx_non_cfg_phy *)rx_resp->non_cfg_phy_buf;
+	u32 agc = (le16_to_cpu(ncphy->agc_info) & IWL49_AGC_DB_MASK)
+			>> IWL49_AGC_DB_POS;
+
+	u32 valid_antennae =
+	    (le16_to_cpu(rx_resp->phy_flags) & IWL49_RX_PHY_FLAGS_ANTENNAE_MASK)
+			>> IWL49_RX_PHY_FLAGS_ANTENNAE_OFFSET;
+	u8 max_rssi = 0;
+	u32 i;
+
+	/* Find max rssi among 3 possible receivers.
+	 * These values are measured by the digital signal processor (DSP).
+	 * They should stay fairly constant even as the signal strength varies,
+	 *   if the radio's automatic gain control (AGC) is working right.
+	 * AGC value (see below) will provide the "interesting" info. */
+	for (i = 0; i < 3; i++)
+		if (valid_antennae & (1 << i))
+			max_rssi = max(ncphy->rssi_info[i << 1], max_rssi);
+
+	IWL_DEBUG_STATS("Rssi In A %d B %d C %d Max %d AGC dB %d\n",
+		ncphy->rssi_info[0], ncphy->rssi_info[2], ncphy->rssi_info[4],
+		max_rssi, agc);
+
+	/* dBm = max_rssi dB - agc dB - constant.
+	 * Higher AGC (higher radio gain) means lower signal. */
+	return max_rssi - agc - IWL_RSSI_OFFSET;
+}
+
 
 /* Set up 4965-specific Rx frame reply handlers */
 static void iwl4965_rx_handler_setup(struct iwl_priv *priv)
@@ -2289,6 +2323,7 @@ static struct iwl_hcmd_utils_ops iwl4965_hcmd_utils = {
 	.chain_noise_reset = iwl4965_chain_noise_reset,
 	.gain_computation = iwl4965_gain_computation,
 	.rts_tx_cmd_flag = iwl4965_rts_tx_cmd_flag,
+	.calc_rssi = iwl4965_calc_rssi,
 };
 
 static struct iwl_lib_ops iwl4965_lib = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 56dbc81..c5b104f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -1459,6 +1459,44 @@ static void iwl5000_temperature(struct iwl_priv *priv)
 	priv->temperature = le32_to_cpu(priv->statistics.general.temperature);
 }
 
+/* Calc max signal level (dBm) among 3 possible receivers */
+static int iwl5000_calc_rssi(struct iwl_priv *priv,
+			     struct iwl_rx_phy_res *rx_resp)
+{
+	/* data from PHY/DSP regarding signal strength, etc.,
+	 *   contents are always there, not configurable by host
+	 */
+	struct iwl5000_non_cfg_phy *ncphy =
+		(struct iwl5000_non_cfg_phy *)rx_resp->non_cfg_phy_buf;
+	u32 val, rssi_a, rssi_b, rssi_c, max_rssi;
+	u8 agc;
+
+	val  = le32_to_cpu(ncphy->non_cfg_phy[IWL50_RX_RES_AGC_IDX]);
+	agc = (val & IWL50_OFDM_AGC_MSK) >> IWL50_OFDM_AGC_BIT_POS;
+
+	/* Find max rssi among 3 possible receivers.
+	 * These values are measured by the digital signal processor (DSP).
+	 * They should stay fairly constant even as the signal strength varies,
+	 *   if the radio's automatic gain control (AGC) is working right.
+	 * AGC value (see below) will provide the "interesting" info.
+	 */
+	val = le32_to_cpu(ncphy->non_cfg_phy[IWL50_RX_RES_RSSI_AB_IDX]);
+	rssi_a = (val & IWL50_OFDM_RSSI_A_MSK) >> IWL50_OFDM_RSSI_A_BIT_POS;
+	rssi_b = (val & IWL50_OFDM_RSSI_B_MSK) >> IWL50_OFDM_RSSI_B_BIT_POS;
+	val = le32_to_cpu(ncphy->non_cfg_phy[IWL50_RX_RES_RSSI_C_IDX]);
+	rssi_c = (val & IWL50_OFDM_RSSI_C_MSK) >> IWL50_OFDM_RSSI_C_BIT_POS;
+
+	max_rssi = max_t(u32, rssi_a, rssi_b);
+	max_rssi = max_t(u32, max_rssi, rssi_c);
+
+	IWL_DEBUG_STATS("Rssi In A %d B %d C %d Max %d AGC dB %d\n",
+		rssi_a, rssi_b, rssi_c, max_rssi, agc);
+
+	/* dBm = max_rssi dB - agc dB - constant.
+	 * Higher AGC (higher radio gain) means lower signal. */
+	return max_rssi - agc - IWL_RSSI_OFFSET;
+}
+
 static struct iwl_hcmd_ops iwl5000_hcmd = {
 	.rxon_assoc = iwl5000_send_rxon_assoc,
 };
@@ -1469,6 +1507,7 @@ static struct iwl_hcmd_utils_ops iwl5000_hcmd_utils = {
 	.gain_computation = iwl5000_gain_computation,
 	.chain_noise_reset = iwl5000_chain_noise_reset,
 	.rts_tx_cmd_flag = iwl5000_rts_tx_cmd_flag,
+	.calc_rssi = iwl5000_calc_rssi,
 };
 
 static struct iwl_lib_ops iwl5000_lib = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 5e57f3a..28b5b09 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -1075,10 +1075,12 @@ struct iwl4965_rx_frame {
 } __attribute__ ((packed));
 
 /* Fixed (non-configurable) rx data from phy */
-#define RX_PHY_FLAGS_ANTENNAE_OFFSET		(4)
-#define RX_PHY_FLAGS_ANTENNAE_MASK		(0x70)
-#define IWL_AGC_DB_MASK 	(0x3f80)	/* MASK(7,13) */
-#define IWL_AGC_DB_POS		(7)
+
+#define IWL49_RX_RES_PHY_CNT 14
+#define IWL49_RX_PHY_FLAGS_ANTENNAE_OFFSET	(4)
+#define IWL49_RX_PHY_FLAGS_ANTENNAE_MASK	(0x70)
+#define IWL49_AGC_DB_MASK			(0x3f80)	/* MASK(7,13) */
+#define IWL49_AGC_DB_POS			(7)
 struct iwl4965_rx_non_cfg_phy {
 	__le16 ant_selection;	/* ant A bit 4, ant B bit 5, ant C bit 6 */
 	__le16 agc_info;	/* agc code 0:6, agc dB 7:13, reserved 14:15 */
@@ -1086,12 +1088,30 @@ struct iwl4965_rx_non_cfg_phy {
 	u8 pad[0];
 } __attribute__ ((packed));
 
+
+#define IWL50_RX_RES_PHY_CNT 8
+#define IWL50_RX_RES_AGC_IDX     1
+#define IWL50_RX_RES_RSSI_AB_IDX 2
+#define IWL50_RX_RES_RSSI_C_IDX  3
+#define IWL50_OFDM_AGC_MSK 0xfe00
+#define IWL50_OFDM_AGC_BIT_POS 9
+#define IWL50_OFDM_RSSI_A_MSK 0x00ff
+#define IWL50_OFDM_RSSI_A_BIT_POS 0
+#define IWL50_OFDM_RSSI_B_MSK 0xff0000
+#define IWL50_OFDM_RSSI_B_BIT_POS 16
+#define IWL50_OFDM_RSSI_C_MSK 0x00ff
+#define IWL50_OFDM_RSSI_C_BIT_POS 0
+
+struct iwl5000_non_cfg_phy {
+	__le32 non_cfg_phy[IWL50_RX_RES_PHY_CNT];  /* upto 8 phy entries */
+} __attribute__ ((packed));
+
+
 /*
  * REPLY_RX = 0xc3 (response only, not a command)
  * Used only for legacy (non 11n) frames.
  */
-#define RX_RES_PHY_CNT 14
-struct iwl4965_rx_phy_res {
+struct iwl_rx_phy_res {
 	u8 non_cfg_phy_cnt;     /* non configurable DSP phy data byte count */
 	u8 cfg_phy_cnt;		/* configurable DSP phy data byte count */
 	u8 stat_id;		/* configurable DSP phy data set ID */
@@ -1100,8 +1120,7 @@ struct iwl4965_rx_phy_res {
 	__le32 beacon_time_stamp; /* beacon at on-air rise */
 	__le16 phy_flags;	/* general phy flags: band, modulation, ... */
 	__le16 channel;		/* channel number */
-	__le16 non_cfg_phy[RX_RES_PHY_CNT];	/* upto 14 phy entries */
-	__le32 reserved2;
+	u8 non_cfg_phy_buf[32]; /* for various implementations of non_cfg_phy */
 	__le32 rate_n_flags;	/* RATE_MCS_* */
 	__le16 byte_count;	/* frame's byte-count */
 	__le16 reserved3;
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index eaefa42..64f139e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -95,6 +95,8 @@ struct iwl_hcmd_utils_ops {
 	void (*chain_noise_reset)(struct iwl_priv *priv);
 	void (*rts_tx_cmd_flag)(struct ieee80211_tx_info *info,
 			__le32 *tx_flags);
+	int  (*calc_rssi)(struct iwl_priv *priv,
+			  struct iwl_rx_phy_res *rx_resp);
 };
 
 struct iwl_lib_ops {
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index 4b26a16..b92a580 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -909,8 +909,8 @@ static void iwl_pass_packet_to_mac80211(struct iwl_priv *priv,
 				       struct ieee80211_rx_status *stats)
 {
 	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
-	struct iwl4965_rx_phy_res *rx_start = (include_phy) ?
-	    (struct iwl4965_rx_phy_res *)&(pkt->u.raw[0]) : NULL;
+	struct iwl_rx_phy_res *rx_start = (include_phy) ?
+	    (struct iwl_rx_phy_res *)&(pkt->u.raw[0]) : NULL;
 	struct ieee80211_hdr *hdr;
 	u16 len;
 	__le32 *rx_end;
@@ -919,7 +919,7 @@ static void iwl_pass_packet_to_mac80211(struct iwl_priv *priv,
 	u32 ampdu_status_legacy;
 
 	if (!include_phy && priv->last_phy_res[0])
-		rx_start = (struct iwl4965_rx_phy_res *)&priv->last_phy_res[1];
+		rx_start = (struct iwl_rx_phy_res *)&priv->last_phy_res[1];
 
 	if (!rx_start) {
 		IWL_ERROR("MPDU frame without a PHY data\n");
@@ -931,8 +931,8 @@ static void iwl_pass_packet_to_mac80211(struct iwl_priv *priv,
 
 		len = le16_to_cpu(rx_start->byte_count);
 
-		rx_end = (__le32 *) ((u8 *) &pkt->u.raw[0] +
-				  sizeof(struct iwl4965_rx_phy_res) +
+		rx_end = (__le32 *)((u8 *) &pkt->u.raw[0] +
+				  sizeof(struct iwl_rx_phy_res) +
 				  rx_start->cfg_phy_cnt + len);
 
 	} else {
@@ -980,40 +980,13 @@ static void iwl_pass_packet_to_mac80211(struct iwl_priv *priv,
 }
 
 /* Calc max signal level (dBm) among 3 possible receivers */
-static int iwl_calc_rssi(struct iwl_priv *priv,
-			     struct iwl4965_rx_phy_res *rx_resp)
+static inline int iwl_calc_rssi(struct iwl_priv *priv,
+				struct iwl_rx_phy_res *rx_resp)
 {
-	/* data from PHY/DSP regarding signal strength, etc.,
-	 *   contents are always there, not configurable by host.  */
-	struct iwl4965_rx_non_cfg_phy *ncphy =
-	    (struct iwl4965_rx_non_cfg_phy *)rx_resp->non_cfg_phy;
-	u32 agc = (le16_to_cpu(ncphy->agc_info) & IWL_AGC_DB_MASK)
-			>> IWL_AGC_DB_POS;
-
-	u32 valid_antennae =
-	    (le16_to_cpu(rx_resp->phy_flags) & RX_PHY_FLAGS_ANTENNAE_MASK)
-			>> RX_PHY_FLAGS_ANTENNAE_OFFSET;
-	u8 max_rssi = 0;
-	u32 i;
-
-	/* Find max rssi among 3 possible receivers.
-	 * These values are measured by the digital signal processor (DSP).
-	 * They should stay fairly constant even as the signal strength varies,
-	 *   if the radio's automatic gain control (AGC) is working right.
-	 * AGC value (see below) will provide the "interesting" info. */
-	for (i = 0; i < 3; i++)
-		if (valid_antennae & (1 << i))
-			max_rssi = max(ncphy->rssi_info[i << 1], max_rssi);
-
-	IWL_DEBUG_STATS("Rssi In A %d B %d C %d Max %d AGC dB %d\n",
-		ncphy->rssi_info[0], ncphy->rssi_info[2], ncphy->rssi_info[4],
-		max_rssi, agc);
-
-	/* dBm = max_rssi dB - agc dB - constant.
-	 * Higher AGC (higher radio gain) means lower signal. */
-	return max_rssi - agc - IWL_RSSI_OFFSET;
+	return priv->cfg->ops->utils->calc_rssi(priv, rx_resp);
 }
 
+
 static void iwl_sta_modify_ps_wake(struct iwl_priv *priv, int sta_id)
 {
 	unsigned long flags;
@@ -1076,9 +1049,9 @@ void iwl_rx_reply_rx(struct iwl_priv *priv,
 	 *   this rx packet for legacy frames,
 	 *   or phy data cached from REPLY_RX_PHY_CMD for HT frames. */
 	int include_phy = (pkt->hdr.cmd == REPLY_RX);
-	struct iwl4965_rx_phy_res *rx_start = (include_phy) ?
-		(struct iwl4965_rx_phy_res *)&(pkt->u.raw[0]) :
-		(struct iwl4965_rx_phy_res *)&priv->last_phy_res[1];
+	struct iwl_rx_phy_res *rx_start = (include_phy) ?
+		(struct iwl_rx_phy_res *)&(pkt->u.raw[0]) :
+		(struct iwl_rx_phy_res *)&priv->last_phy_res[1];
 	__le32 *rx_end;
 	unsigned int len = 0;
 	u16 fc;
@@ -1105,7 +1078,7 @@ void iwl_rx_reply_rx(struct iwl_priv *priv,
 
 	if (!include_phy) {
 		if (priv->last_phy_res[0])
-			rx_start = (struct iwl4965_rx_phy_res *)
+			rx_start = (struct iwl_rx_phy_res *)
 				&priv->last_phy_res[1];
 		else
 			rx_start = NULL;
@@ -1122,7 +1095,7 @@ void iwl_rx_reply_rx(struct iwl_priv *priv,
 
 		len = le16_to_cpu(rx_start->byte_count);
 		rx_end = (__le32 *)(pkt->u.raw + rx_start->cfg_phy_cnt +
-				  sizeof(struct iwl4965_rx_phy_res) + len);
+				  sizeof(struct iwl_rx_phy_res) + len);
 	} else {
 		struct iwl4965_rx_mpdu_res_start *amsdu =
 			(struct iwl4965_rx_mpdu_res_start *)pkt->u.raw;
@@ -1231,6 +1204,6 @@ void iwl_rx_reply_rx_phy(struct iwl_priv *priv,
 	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
 	priv->last_phy_res[0] = 1;
 	memcpy(&priv->last_phy_res[1], &(pkt->u.raw[0]),
-	       sizeof(struct iwl4965_rx_phy_res));
+	       sizeof(struct iwl_rx_phy_res));
 }
 EXPORT_SYMBOL(iwl_rx_reply_rx_phy);
-- 
1.5.3.6

