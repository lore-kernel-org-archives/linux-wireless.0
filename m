Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:36656 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753982AbdGJMpW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Jul 2017 08:45:22 -0400
Received: by mail-pf0-f193.google.com with SMTP id z6so14396306pfk.3
        for <linux-wireless@vger.kernel.org>; Mon, 10 Jul 2017 05:45:17 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Subject: [v2 07/17] rsi: Update baseband RF programming frame
Date: Mon, 10 Jul 2017 18:10:38 +0530
Message-Id: <1499690448-9956-8-git-send-email-amitkarwar@gmail.com> (sfid-20170710_144537_661790_B7F339E3)
In-Reply-To: <1499690448-9956-1-git-send-email-amitkarwar@gmail.com>
References: <1499690448-9956-1-git-send-email-amitkarwar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>

Baseband RF programming frame configured to device is modified
to use common descriptor structure.

Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_91x_mgmt.c | 24 +++++++++++++-----------
 drivers/net/wireless/rsi/rsi_mgmt.h     | 12 ++++++++++++
 2 files changed, 25 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_mgmt.c b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
index a1a60f7..ead3573 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mgmt.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
@@ -577,34 +577,36 @@ int rsi_send_aggregation_params_frame(struct rsi_common *common,
 static int rsi_program_bb_rf(struct rsi_common *common)
 {
 	struct sk_buff *skb;
-	struct rsi_mac_frame *mgmt_frame;
+	struct rsi_bb_rf_prog *bb_rf_prog;
+	u16 frame_len = sizeof(struct rsi_bb_rf_prog);
 
 	rsi_dbg(MGMT_TX_ZONE, "%s: Sending program BB/RF frame\n", __func__);
 
-	skb = dev_alloc_skb(FRAME_DESC_SZ);
+	skb = dev_alloc_skb(frame_len);
 	if (!skb) {
 		rsi_dbg(ERR_ZONE, "%s: Failed in allocation of skb\n",
 			__func__);
 		return -ENOMEM;
 	}
 
-	memset(skb->data, 0, FRAME_DESC_SZ);
-	mgmt_frame = (struct rsi_mac_frame *)skb->data;
+	memset(skb->data, 0, frame_len);
+	bb_rf_prog = (struct rsi_bb_rf_prog *)skb->data;
 
-	mgmt_frame->desc_word[0] = cpu_to_le16(RSI_WIFI_MGMT_Q << 12);
-	mgmt_frame->desc_word[1] = cpu_to_le16(BBP_PROG_IN_TA);
-	mgmt_frame->desc_word[4] = cpu_to_le16(common->endpoint);
+	rsi_set_len_qno(&bb_rf_prog->desc_dword0.len_qno, 0, RSI_WIFI_MGMT_Q);
+	bb_rf_prog->desc_dword0.frame_type = BBP_PROG_IN_TA;
+	bb_rf_prog->endpoint = common->endpoint;
+	bb_rf_prog->rf_power_mode = common->wlan_rf_power_mode;
 
 	if (common->rf_reset) {
-		mgmt_frame->desc_word[7] =  cpu_to_le16(RF_RESET_ENABLE);
+		bb_rf_prog->flags =  cpu_to_le16(RF_RESET_ENABLE);
 		rsi_dbg(MGMT_TX_ZONE, "%s: ===> RF RESET REQUEST SENT <===\n",
 			__func__);
 		common->rf_reset = 0;
 	}
 	common->bb_rf_prog_count = 1;
-	mgmt_frame->desc_word[7] |= cpu_to_le16(PUT_BBP_RESET |
-				     BBP_REG_WRITE | (RSI_RF_TYPE << 4));
-	skb_put(skb, FRAME_DESC_SZ);
+	bb_rf_prog->flags |= cpu_to_le16(PUT_BBP_RESET | BBP_REG_WRITE |
+					 (RSI_RF_TYPE << 4));
+	skb_put(skb, frame_len);
 
 	return rsi_send_internal_mgmt_frame(common, skb);
 }
diff --git a/drivers/net/wireless/rsi/rsi_mgmt.h b/drivers/net/wireless/rsi/rsi_mgmt.h
index 68863c8..d44c79f 100644
--- a/drivers/net/wireless/rsi/rsi_mgmt.h
+++ b/drivers/net/wireless/rsi/rsi_mgmt.h
@@ -294,6 +294,18 @@ struct rsi_aggr_params {
 	u8 peer_id;
 } __packed;
 
+struct rsi_bb_rf_prog {
+	struct rsi_cmd_desc_dword0 desc_dword0;
+	__le16 reserved1;
+	u8 rf_power_mode;
+	u8 reserved2;
+	u8 endpoint;
+	u8 reserved3;
+	__le16 reserved4;
+	__le16 reserved5;
+	__le16 flags;
+} __packed;
+
 struct rsi_vap_caps {
 	__le16 desc_word[8];
 	u8 mac_addr[6];
-- 
2.7.4
