Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:37341 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751865AbdHCOdK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 3 Aug 2017 10:33:10 -0400
Received: by mail-pf0-f193.google.com with SMTP id p13so1667286pfd.4
        for <linux-wireless@vger.kernel.org>; Thu, 03 Aug 2017 07:33:10 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Pavani Muthyala <pavani.muthyala@redpinesignals.com>
Subject: [v2 2/8] rsi: update set_antenna command frame
Date: Thu,  3 Aug 2017 19:58:58 +0530
Message-Id: <1501770544-6746-3-git-send-email-amitkarwar@gmail.com> (sfid-20170803_163313_167758_EA435EFD)
In-Reply-To: <1501770544-6746-1-git-send-email-amitkarwar@gmail.com>
References: <1501770544-6746-1-git-send-email-amitkarwar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Pavani Muthyala <pavani.muthyala@redpinesignals.com>

TX command frame set_antenna is modified to use common
descriptor structure. Also it's subframe type is set.

Signed-off-by: Pavani Muthyala <pavani.muthyala@redpinesignals.com>
Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_91x_mgmt.c | 13 +++++++------
 drivers/net/wireless/rsi/rsi_mgmt.h     | 11 +++++++++++
 2 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_mgmt.c b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
index c488f4b..e00d4ed 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mgmt.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
@@ -1407,7 +1407,7 @@ int rsi_send_rx_filter_frame(struct rsi_common *common, u16 rx_filter_word)
  */
 int rsi_set_antenna(struct rsi_common *common, u8 antenna)
 {
-	struct rsi_mac_frame *cmd_frame;
+	struct rsi_ant_sel_frame *ant_sel_frame;
 	struct sk_buff *skb;
 
 	skb = dev_alloc_skb(FRAME_DESC_SZ);
@@ -1418,12 +1418,13 @@ int rsi_set_antenna(struct rsi_common *common, u8 antenna)
 	}
 
 	memset(skb->data, 0, FRAME_DESC_SZ);
-	cmd_frame = (struct rsi_mac_frame *)skb->data;
-
-	cmd_frame->desc_word[1] = cpu_to_le16(ANT_SEL_FRAME);
-	cmd_frame->desc_word[3] = cpu_to_le16(antenna & 0x00ff);
-	cmd_frame->desc_word[0] = cpu_to_le16(RSI_WIFI_MGMT_Q << 12);
 
+	ant_sel_frame = (struct rsi_ant_sel_frame *)skb->data;
+	ant_sel_frame->desc_dword0.frame_type = ANT_SEL_FRAME;
+	ant_sel_frame->sub_frame_type = ANTENNA_SEL_TYPE;
+	ant_sel_frame->ant_value = cpu_to_le16(antenna & ANTENNA_MASK_VALUE);
+	rsi_set_len_qno(&ant_sel_frame->desc_dword0.len_qno,
+			0, RSI_WIFI_MGMT_Q);
 	skb_put(skb, FRAME_DESC_SZ);
 
 	return rsi_send_internal_mgmt_frame(common, skb);
diff --git a/drivers/net/wireless/rsi/rsi_mgmt.h b/drivers/net/wireless/rsi/rsi_mgmt.h
index cb0b17e..1060edc 100644
--- a/drivers/net/wireless/rsi/rsi_mgmt.h
+++ b/drivers/net/wireless/rsi/rsi_mgmt.h
@@ -155,6 +155,8 @@
 
 #define ANTENNA_SEL_INT			0x02 /* RF_OUT_2 / Integerated */
 #define ANTENNA_SEL_UFL			0x03 /* RF_OUT_1 / U.FL */
+#define ANTENNA_MASK_VALUE		0x00ff
+#define ANTENNA_SEL_TYPE		1
 
 /* Rx filter word definitions */
 #define PROMISCOUS_MODE			BIT(0)
@@ -348,6 +350,15 @@ struct rsi_vap_caps {
 	__le16 beacon_miss_threshold;
 } __packed;
 
+struct rsi_ant_sel_frame {
+	struct rsi_cmd_desc_dword0 desc_dword0;
+	u8 reserved;
+	u8 sub_frame_type;
+	__le16 ant_value;
+	__le32 reserved1;
+	__le32 reserved2;
+} __packed;
+
 /* Key descriptor flags */
 #define RSI_KEY_TYPE_BROADCAST	BIT(1)
 #define RSI_WEP_KEY		BIT(2)
-- 
2.7.4
