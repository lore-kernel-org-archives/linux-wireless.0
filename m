Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:65082 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754725Ab1CQS7K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Mar 2011 14:59:10 -0400
Received: by mail-iy0-f174.google.com with SMTP id 26so3126341iyb.19
        for <linux-wireless@vger.kernel.org>; Thu, 17 Mar 2011 11:59:10 -0700 (PDT)
From: Brian Cavagnolo <brian@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: buytenh@wantstofly.org, Brian Cavagnolo <brian@cozybit.com>
Subject: [PATCH 2/9] mwl8k: update to ap firmware API version 2
Date: Thu, 17 Mar 2011 11:58:42 -0700
Message-Id: <1300388329-15380-2-git-send-email-brian@cozybit.com>
In-Reply-To: <1300388329-15380-1-git-send-email-brian@cozybit.com>
References: <1300388329-15380-1-git-send-email-brian@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Firmware APIv2 adds the following enhancements:

-- capabilities are reported by the firmware
-- API supports up to 8 dedicated AMPDU streams
-- optional packet timestamping and expiration can be enabled.
   Specifically, packets that are queued in firmware for longer
   than 500ms will be dropped if this option is used.

Based on work by "Nishant Sarmukadam" <nishants@marvell.com>

Signed-off-by: Brian Cavagnolo <brian@cozybit.com>
---
 drivers/net/wireless/mwl8k.c |   41 ++++++++++++++++++++++++++++++++++-------
 1 files changed, 34 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 8fefed2..9db66d5 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -86,6 +86,7 @@ MODULE_PARM_DESC(ap_mode_default,
 
 #define MWL8K_RX_QUEUES		1
 #define MWL8K_TX_QUEUES		4
+#define MWL8K_MAX_AMPDU_QUEUES	8
 
 struct rxd_ops {
 	int rxd_size;
@@ -159,6 +160,9 @@ struct mwl8k_priv {
 	u32 ap_macids_supported;
 	u32 sta_macids_supported;
 
+	/* Ampdu stream information */
+	u8 num_ampdu_queues;
+
 	/* firmware access */
 	struct mutex fw_mutex;
 	struct task_struct *fw_mutex_owner;
@@ -190,8 +194,8 @@ struct mwl8k_priv {
 	int pending_tx_pkts;
 
 	struct mwl8k_rx_queue rxq[MWL8K_RX_QUEUES];
-	struct mwl8k_tx_queue txq[MWL8K_TX_QUEUES];
-	u32 txq_offset[MWL8K_TX_QUEUES];
+	struct mwl8k_tx_queue txq[MWL8K_TX_QUEUES + MWL8K_MAX_AMPDU_QUEUES];
+	u32 txq_offset[MWL8K_TX_QUEUES + MWL8K_MAX_AMPDU_QUEUES];
 
 	bool radio_on;
 	bool radio_short_preamble;
@@ -1322,7 +1326,7 @@ struct mwl8k_tx_desc {
 	__le16 pkt_len;
 	__u8 dest_MAC_addr[ETH_ALEN];
 	__le32 next_txd_phys_addr;
-	__le32 reserved;
+	__le32 timestamp;
 	__le16 rate_info;
 	__u8 peer_id;
 	__u8 tx_frag_cnt;
@@ -2023,13 +2027,16 @@ struct mwl8k_cmd_get_hw_spec_ap {
 	__le32 wcbbase2;
 	__le32 wcbbase3;
 	__le32 fw_api_version;
+	__le32 caps;
+	__le32 num_of_ampdu_queues;
+	__le32 wcbbase_ampdu[MWL8K_MAX_AMPDU_QUEUES];
 } __packed;
 
 static int mwl8k_cmd_get_hw_spec_ap(struct ieee80211_hw *hw)
 {
 	struct mwl8k_priv *priv = hw->priv;
 	struct mwl8k_cmd_get_hw_spec_ap *cmd;
-	int rc;
+	int rc, i;
 	u32 api_version;
 
 	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
@@ -2061,10 +2068,17 @@ static int mwl8k_cmd_get_hw_spec_ap(struct ieee80211_hw *hw)
 		priv->num_mcaddrs = le16_to_cpu(cmd->num_mcaddrs);
 		priv->fw_rev = le32_to_cpu(cmd->fw_rev);
 		priv->hw_rev = cmd->hw_rev;
-		mwl8k_setup_2ghz_band(hw);
+		mwl8k_set_caps(hw, le32_to_cpu(cmd->caps));
 		priv->ap_macids_supported = 0x000000ff;
 		priv->sta_macids_supported = 0x00000000;
-
+		priv->num_ampdu_queues = le32_to_cpu(cmd->num_of_ampdu_queues);
+		if (priv->num_ampdu_queues > MWL8K_MAX_AMPDU_QUEUES) {
+			wiphy_warn(hw->wiphy, "fw reported %d ampdu queues"
+				   " but we only support %d.\n",
+				   priv->num_ampdu_queues,
+				   MWL8K_MAX_AMPDU_QUEUES);
+			priv->num_ampdu_queues = MWL8K_MAX_AMPDU_QUEUES;
+		}
 		off = le32_to_cpu(cmd->rxwrptr) & 0xffff;
 		iowrite32(priv->rxq[0].rxd_dma, priv->sram + off);
 
@@ -2075,6 +2089,10 @@ static int mwl8k_cmd_get_hw_spec_ap(struct ieee80211_hw *hw)
 		priv->txq_offset[1] = le32_to_cpu(cmd->wcbbase1) & 0xffff;
 		priv->txq_offset[2] = le32_to_cpu(cmd->wcbbase2) & 0xffff;
 		priv->txq_offset[3] = le32_to_cpu(cmd->wcbbase3) & 0xffff;
+
+		for (i = 0; i < priv->num_ampdu_queues; i++)
+			priv->txq_offset[i + MWL8K_TX_QUEUES] =
+				le32_to_cpu(cmd->wcbbase_ampdu[i]) & 0xffff;
 	}
 
 done:
@@ -2103,6 +2121,14 @@ struct mwl8k_cmd_set_hw_spec {
 	__le32 total_rxd;
 } __packed;
 
+/* If enabled, MWL8K_SET_HW_SPEC_FLAG_ENABLE_LIFE_TIME_EXPIRY will cause
+ * packets to expire 500 ms after the timestamp in the tx descriptor.  That is,
+ * the packets that are queued for more than 500ms, will be dropped in the
+ * hardware. This helps minimizing the issues caused due to head-of-line
+ * blocking where a slow client can hog the bandwidth and affect traffic to a
+ * faster client.
+ */
+#define MWL8K_SET_HW_SPEC_FLAG_ENABLE_LIFE_TIME_EXPIRY	0x00000400
 #define MWL8K_SET_HW_SPEC_FLAG_HOST_DECR_MGMT		0x00000080
 #define MWL8K_SET_HW_SPEC_FLAG_HOSTFORM_PROBERESP	0x00000020
 #define MWL8K_SET_HW_SPEC_FLAG_HOSTFORM_BEACON		0x00000010
@@ -4434,7 +4460,7 @@ enum {
 	MWL8366,
 };
 
-#define MWL8K_8366_AP_FW_API 1
+#define MWL8K_8366_AP_FW_API 2
 #define _MWL8K_8366_AP_FW(api) "mwl8k/fmimage_8366_ap-" #api ".fw"
 #define MWL8K_8366_AP_FW(api) _MWL8K_8366_AP_FW(api)
 
@@ -4650,6 +4676,7 @@ static int mwl8k_probe_hw(struct ieee80211_hw *hw)
 	 * total number of queues from the result CMD_GET_HW_SPEC, so for this
 	 * case we must initialize the tx queues after.
 	 */
+	priv->num_ampdu_queues = 0;
 	if (!priv->ap_fw) {
 		rc = mwl8k_init_txqs(hw);
 		if (rc)
-- 
1.7.1.1

