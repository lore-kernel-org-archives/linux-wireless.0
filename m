Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:36180 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751231AbdFWOKZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 23 Jun 2017 10:10:25 -0400
Received: by mail-pf0-f193.google.com with SMTP id y7so7541233pfd.3
        for <linux-wireless@vger.kernel.org>; Fri, 23 Jun 2017 07:10:25 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>
Subject: [PATCH 03/17] rsi: Update in tx command frame radio capabilities
Date: Fri, 23 Jun 2017 19:37:22 +0530
Message-Id: <1498226856-6305-4-git-send-email-amit.karwar@redpinesignals.com> (sfid-20170623_161029_748747_5A24BDA9)
In-Reply-To: <1498226856-6305-1-git-send-email-amit.karwar@redpinesignals.com>
References: <1498226856-6305-1-git-send-email-amit.karwar@redpinesignals.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>

Radio capabilities frame is updated to use common descriptor
structure. Also, few changes to this frame is done like hardware
queues are increase to 12 from 8, default channel number is included.

Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_91x_mgmt.c | 56 ++++++++++++++++++---------------
 drivers/net/wireless/rsi/rsi_main.h     |  7 ++++-
 drivers/net/wireless/rsi/rsi_mgmt.h     | 13 +++++++-
 3 files changed, 48 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_mgmt.c b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
index c1782a2..77cb36a 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mgmt.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
@@ -301,10 +301,11 @@ static int rsi_load_radio_caps(struct rsi_common *common)
 		      0xf0, 0xf0, 0xf0, 0xf0,
 		      0xf0, 0xf0, 0xf0, 0xf0};
 	struct sk_buff *skb;
+	u16 frame_len = sizeof(struct rsi_radio_caps);
 
 	rsi_dbg(INFO_ZONE, "%s: Sending rate symbol req frame\n", __func__);
 
-	skb = dev_alloc_skb(sizeof(struct rsi_radio_caps));
+	skb = dev_alloc_skb(frame_len);
 
 	if (!skb) {
 		rsi_dbg(ERR_ZONE, "%s: Failed in allocation of skb\n",
@@ -312,37 +313,40 @@ static int rsi_load_radio_caps(struct rsi_common *common)
 		return -ENOMEM;
 	}
 
-	memset(skb->data, 0, sizeof(struct rsi_radio_caps));
+	memset(skb->data, 0, frame_len);
 	radio_caps = (struct rsi_radio_caps *)skb->data;
 
-	radio_caps->desc_word[1] = cpu_to_le16(RADIO_CAPABILITIES);
-	radio_caps->desc_word[4] = cpu_to_le16(RSI_RF_TYPE << 8);
+	radio_caps->desc_dword0.frame_type = RADIO_CAPABILITIES;
+	radio_caps->channel_num = common->channel;
+	radio_caps->rf_model = RSI_RF_TYPE;
 
 	if (common->channel_width == BW_40MHZ) {
-		radio_caps->desc_word[7] |= cpu_to_le16(RSI_LMAC_CLOCK_80MHZ);
-		radio_caps->desc_word[7] |= cpu_to_le16(RSI_ENABLE_40MHZ);
+		radio_caps->radio_cfg_info = RSI_LMAC_CLOCK_80MHZ;
+		radio_caps->radio_cfg_info |= RSI_ENABLE_40MHZ;
 
 		if (common->fsm_state == FSM_MAC_INIT_DONE) {
 			struct ieee80211_hw *hw = adapter->hw;
 			struct ieee80211_conf *conf = &hw->conf;
+
 			if (conf_is_ht40_plus(conf)) {
-				radio_caps->desc_word[5] =
-					cpu_to_le16(LOWER_20_ENABLE);
-				radio_caps->desc_word[5] |=
-					cpu_to_le16(LOWER_20_ENABLE >> 12);
+				radio_caps->radio_cfg_info =
+					RSI_CMDDESC_LOWER_20_ENABLE;
+				radio_caps->radio_info =
+					RSI_CMDDESC_LOWER_20_ENABLE;
 			} else if (conf_is_ht40_minus(conf)) {
-				radio_caps->desc_word[5] =
-					cpu_to_le16(UPPER_20_ENABLE);
-				radio_caps->desc_word[5] |=
-					cpu_to_le16(UPPER_20_ENABLE >> 12);
+				radio_caps->radio_cfg_info =
+					RSI_CMDDESC_UPPER_20_ENABLE;
+				radio_caps->radio_info =
+					RSI_CMDDESC_UPPER_20_ENABLE;
 			} else {
-				radio_caps->desc_word[5] =
-					cpu_to_le16(BW_40MHZ << 12);
-				radio_caps->desc_word[5] |=
-					cpu_to_le16(FULL40M_ENABLE);
+				radio_caps->radio_cfg_info =
+					RSI_CMDDESC_40MHZ;
+				radio_caps->radio_info =
+					RSI_CMDDESC_FULL_40_ENABLE;
 			}
 		}
 	}
+	radio_caps->radio_info |= radio_id;
 
 	radio_caps->sifs_tx_11n = cpu_to_le16(SIFS_TX_11N_VALUE);
 	radio_caps->sifs_tx_11b = cpu_to_le16(SIFS_TX_11B_VALUE);
@@ -351,8 +355,6 @@ static int rsi_load_radio_caps(struct rsi_common *common)
 	radio_caps->cck_ack_tout = cpu_to_le16(CCK_ACK_TOUT_VALUE);
 	radio_caps->preamble_type = cpu_to_le16(LONG_PREAMBLE);
 
-	radio_caps->desc_word[7] |= cpu_to_le16(radio_id << 8);
-
 	for (ii = 0; ii < MAX_HW_QUEUES; ii++) {
 		radio_caps->qos_params[ii].cont_win_min_q = cpu_to_le16(3);
 		radio_caps->qos_params[ii].cont_win_max_q = cpu_to_le16(0x3f);
@@ -360,7 +362,7 @@ static int rsi_load_radio_caps(struct rsi_common *common)
 		radio_caps->qos_params[ii].txop_q = 0;
 	}
 
-	for (ii = 0; ii < MAX_HW_QUEUES - 4; ii++) {
+	for (ii = 0; ii < NUM_EDCA_QUEUES; ii++) {
 		radio_caps->qos_params[ii].cont_win_min_q =
 			cpu_to_le16(common->edca_params[ii].cw_min);
 		radio_caps->qos_params[ii].cont_win_max_q =
@@ -371,17 +373,19 @@ static int rsi_load_radio_caps(struct rsi_common *common)
 			cpu_to_le16(common->edca_params[ii].txop);
 	}
 
+	radio_caps->qos_params[BROADCAST_HW_Q].txop_q = cpu_to_le16(0xffff);
+	radio_caps->qos_params[MGMT_HW_Q].txop_q = 0;
+	radio_caps->qos_params[BEACON_HW_Q].txop_q = cpu_to_le16(0xffff);
+
 	memcpy(&common->rate_pwr[0], &gc[0], 40);
 	for (ii = 0; ii < 20; ii++)
 		radio_caps->gcpd_per_rate[inx++] =
 			cpu_to_le16(common->rate_pwr[ii]  & 0x00FF);
 
-	radio_caps->desc_word[0] = cpu_to_le16((sizeof(struct rsi_radio_caps) -
-						FRAME_DESC_SZ) |
-					       (RSI_WIFI_MGMT_Q << 12));
-
+	rsi_set_len_qno(&radio_caps->desc_dword0.len_qno,
+			(frame_len - FRAME_DESC_SZ), RSI_WIFI_MGMT_Q);
 
-	skb_put(skb, (sizeof(struct rsi_radio_caps)));
+	skb_put(skb, frame_len);
 
 	return rsi_send_internal_mgmt_frame(common, skb);
 }
diff --git a/drivers/net/wireless/rsi/rsi_main.h b/drivers/net/wireless/rsi/rsi_main.h
index d3bf7ac..08a0e6f 100644
--- a/drivers/net/wireless/rsi/rsi_main.h
+++ b/drivers/net/wireless/rsi/rsi_main.h
@@ -59,11 +59,16 @@ extern __printf(2, 3) void rsi_dbg(u32 zone, const char *fmt, ...);
 #define MAC_80211_HDR_FRAME_CONTROL     0
 #define WME_NUM_AC                      4
 #define NUM_SOFT_QUEUES                 5
-#define MAX_HW_QUEUES                   8
+#define MAX_HW_QUEUES                   12
 #define INVALID_QUEUE                   0xff
 #define MAX_CONTINUOUS_VO_PKTS          8
 #define MAX_CONTINUOUS_VI_PKTS          4
 
+/* Hardware queue info */
+#define BROADCAST_HW_Q			9
+#define MGMT_HW_Q			10
+#define BEACON_HW_Q			11
+
 /* Queue information */
 #define RSI_COEX_Q			0x0
 #define RSI_WIFI_MGMT_Q                 0x4
diff --git a/drivers/net/wireless/rsi/rsi_mgmt.h b/drivers/net/wireless/rsi/rsi_mgmt.h
index 6f7f181..3b4bd85 100644
--- a/drivers/net/wireless/rsi/rsi_mgmt.h
+++ b/drivers/net/wireless/rsi/rsi_mgmt.h
@@ -70,6 +70,10 @@
 #define RSI_REKEY_PURPOSE		BIT(13)
 #define RSI_ENCRYPT_PKT			BIT(15)
 
+#define RSI_CMDDESC_40MHZ		BIT(4)
+#define RSI_CMDDESC_UPPER_20_ENABLE	BIT(5)
+#define RSI_CMDDESC_LOWER_20_ENABLE	BIT(6)
+#define RSI_CMDDESC_FULL_40_ENABLE	(BIT(5) | BIT(6))
 #define UPPER_20_ENABLE                 (0x2 << 12)
 #define LOWER_20_ENABLE                 (0x4 << 12)
 #define FULL40M_ENABLE                  0x6
@@ -317,7 +321,14 @@ struct qos_params {
 } __packed;
 
 struct rsi_radio_caps {
-	__le16 desc_word[8];
+	struct rsi_cmd_desc_dword0 desc_dword0;
+	struct rsi_cmd_desc_dword0 desc_dword1;
+	u8 channel_num;
+	u8 rf_model;
+	__le16 ppe_ack_rate;
+	__le16 mode_11j;
+	u8 radio_cfg_info;
+	u8 radio_info;
 	struct qos_params qos_params[MAX_HW_QUEUES];
 	u8 num_11n_rates;
 	u8 num_11ac_rates;
-- 
2.7.4
