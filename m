Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:32818 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754080AbdFWOLD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 23 Jun 2017 10:11:03 -0400
Received: by mail-pf0-f194.google.com with SMTP id w12so7547517pfk.0
        for <linux-wireless@vger.kernel.org>; Fri, 23 Jun 2017 07:11:03 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>
Subject: [PATCH 14/17] rsi: update tx command frame block/unblock data
Date: Fri, 23 Jun 2017 19:37:33 +0530
Message-Id: <1498226856-6305-15-git-send-email-amit.karwar@redpinesignals.com> (sfid-20170623_161108_366321_2C85F542)
In-Reply-To: <1498226856-6305-1-git-send-email-amit.karwar@redpinesignals.com>
References: <1498226856-6305-1-git-send-email-amit.karwar@redpinesignals.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>

TX command frame block/unblock data is modified to
use common descriptor structure.

Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_91x_mgmt.c | 16 +++++++++-------
 drivers/net/wireless/rsi/rsi_mgmt.h     | 13 +++++++++++++
 2 files changed, 22 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_mgmt.c b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
index 3b1e4e4..c7f4964 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mgmt.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
@@ -1331,7 +1331,7 @@ static int rsi_eeprom_read(struct rsi_common *common)
  */
 int rsi_send_block_unblock_frame(struct rsi_common *common, bool block_event)
 {
-	struct rsi_mac_frame *mgmt_frame;
+	struct rsi_block_unblock_data *mgmt_frame;
 	struct sk_buff *skb;
 
 	rsi_dbg(MGMT_TX_ZONE, "%s: Sending block/unblock frame\n", __func__);
@@ -1344,23 +1344,25 @@ int rsi_send_block_unblock_frame(struct rsi_common *common, bool block_event)
 	}
 
 	memset(skb->data, 0, FRAME_DESC_SZ);
-	mgmt_frame = (struct rsi_mac_frame *)skb->data;
+	mgmt_frame = (struct rsi_block_unblock_data *)skb->data;
 
-	mgmt_frame->desc_word[0] = cpu_to_le16(RSI_WIFI_MGMT_Q << 12);
-	mgmt_frame->desc_word[1] = cpu_to_le16(BLOCK_HW_QUEUE);
+	rsi_set_len_qno(&mgmt_frame->desc_dword0.len_qno, 0, RSI_WIFI_MGMT_Q);
+	mgmt_frame->desc_dword0.frame_type = BLOCK_HW_QUEUE;
+	mgmt_frame->host_quiet_info = QUIET_INFO_VALID;
 
 	if (block_event) {
 		rsi_dbg(INFO_ZONE, "blocking the data qs\n");
-		mgmt_frame->desc_word[4] = cpu_to_le16(0xf);
+		mgmt_frame->block_q_bitmap = cpu_to_le16(0xf);
+		mgmt_frame->block_q_bitmap |= cpu_to_le16(0xf << 4);
 	} else {
 		rsi_dbg(INFO_ZONE, "unblocking the data qs\n");
-		mgmt_frame->desc_word[5] = cpu_to_le16(0xf);
+		mgmt_frame->unblock_q_bitmap = cpu_to_le16(0xf);
+		mgmt_frame->unblock_q_bitmap |= cpu_to_le16(0xf << 4);
 	}
 
 	skb_put(skb, FRAME_DESC_SZ);
 
 	return rsi_send_internal_mgmt_frame(common, skb);
-
 }
 
 /**
diff --git a/drivers/net/wireless/rsi/rsi_mgmt.h b/drivers/net/wireless/rsi/rsi_mgmt.h
index 5df64d3..cb0b17e 100644
--- a/drivers/net/wireless/rsi/rsi_mgmt.h
+++ b/drivers/net/wireless/rsi/rsi_mgmt.h
@@ -381,6 +381,19 @@ struct rsi_auto_rate {
 	__le16 supported_rates[40];
 } __packed;
 
+#define QUIET_INFO_VALID	BIT(0)
+#define QUIET_ENABLE		BIT(1)
+struct rsi_block_unblock_data {
+	struct rsi_cmd_desc_dword0 desc_dword0;
+	u8 xtend_desc_size;
+	u8 host_quiet_info;
+	__le16 reserved;
+	__le16 block_q_bitmap;
+	__le16 unblock_q_bitmap;
+	__le16 token;
+	__le16 flush_q_bitmap;
+} __packed;
+
 struct qos_params {
 	__le16 cont_win_min_q;
 	__le16 cont_win_max_q;
-- 
2.7.4
