Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:37796 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751829AbdHAJK2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 1 Aug 2017 05:10:28 -0400
Received: by mail-pg0-f68.google.com with SMTP id 83so1714358pgb.4
        for <linux-wireless@vger.kernel.org>; Tue, 01 Aug 2017 02:10:28 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Karun Eagalapati <karun256@gmail.com>
Subject: [PATCH 8/8] rsi: RTS threshold configuration
Date: Tue,  1 Aug 2017 14:35:52 +0530
Message-Id: <1501578352-10795-9-git-send-email-amitkarwar@gmail.com> (sfid-20170801_111031_952441_C92E16A3)
In-Reply-To: <1501578352-10795-1-git-send-email-amitkarwar@gmail.com>
References: <1501578352-10795-1-git-send-email-amitkarwar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Karun Eagalapati <karun256@gmail.com>

Provision is added for configuring RTS threshold by sending
vap dynamic update frame to firmware.

Signed-off-by: Karun Eagalapati <karun256@gmail.com>
Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_91x_mac80211.c |  9 +++++++++
 drivers/net/wireless/rsi/rsi_91x_mgmt.c     | 31 +++++++++++++++++++++++++++++
 drivers/net/wireless/rsi/rsi_main.h         |  1 +
 drivers/net/wireless/rsi/rsi_mgmt.h         | 14 +++++++++++++
 4 files changed, 55 insertions(+)

diff --git a/drivers/net/wireless/rsi/rsi_91x_mac80211.c b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
index dfa952e..29ffe61 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mac80211.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
@@ -497,6 +497,15 @@ static int rsi_mac80211_config(struct ieee80211_hw *hw,
 		spin_unlock_irqrestore(&adapter->ps_lock, flags);
 	}
 
+	/* RTS threshold */
+	if (changed & WIPHY_PARAM_RTS_THRESHOLD) {
+		rsi_dbg(INFO_ZONE, "RTS threshold\n");
+		if ((common->rts_threshold) <= IEEE80211_MAX_RTS_THRESHOLD) {
+			rsi_dbg(INFO_ZONE,
+				"%s: Sending vap updates....\n", __func__);
+			status = rsi_send_vap_dynamic_update(common);
+		}
+	}
 	mutex_unlock(&common->mutex);
 
 	return status;
diff --git a/drivers/net/wireless/rsi/rsi_91x_mgmt.c b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
index 2568945..c6e8a20 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mgmt.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
@@ -1057,6 +1057,37 @@ int rsi_send_radio_params_update(struct rsi_common *common)
 	return rsi_send_internal_mgmt_frame(common, skb);
 }
 
+/* This function programs the threshold. */
+int rsi_send_vap_dynamic_update(struct rsi_common *common)
+{
+	struct sk_buff *skb;
+	struct rsi_dynamic_s *dynamic_frame;
+
+	rsi_dbg(MGMT_TX_ZONE,
+		"%s: Sending vap update indication frame\n", __func__);
+
+	skb = dev_alloc_skb(sizeof(struct rsi_dynamic_s));
+	if (!skb)
+		return -ENOMEM;
+
+	memset(skb->data, 0, sizeof(struct rsi_dynamic_s));
+	dynamic_frame = (struct rsi_dynamic_s *)skb->data;
+	rsi_set_len_qno(&dynamic_frame->desc_dword0.len_qno,
+			sizeof(dynamic_frame->frame_body), RSI_WIFI_MGMT_Q);
+
+	dynamic_frame->desc_dword0.frame_type = VAP_DYNAMIC_UPDATE;
+	dynamic_frame->desc_dword2.pkt_info =
+					cpu_to_le32(common->rts_threshold);
+	/* Beacon miss threshold */
+	dynamic_frame->frame_body.keep_alive_period =
+					cpu_to_le16(RSI_DEF_KEEPALIVE);
+	dynamic_frame->desc_dword3.sta_id = 0; /* vap id */
+
+	skb_put(skb, sizeof(struct rsi_dynamic_s));
+
+	return rsi_send_internal_mgmt_frame(common, skb);
+}
+
 /**
  * rsi_compare() - This function is used to compare two integers
  * @a: pointer to the first integer
diff --git a/drivers/net/wireless/rsi/rsi_main.h b/drivers/net/wireless/rsi/rsi_main.h
index d2cc47e..d05b5e0 100644
--- a/drivers/net/wireless/rsi/rsi_main.h
+++ b/drivers/net/wireless/rsi/rsi_main.h
@@ -58,6 +58,7 @@ extern __printf(2, 3) void rsi_dbg(u32 zone, const char *fmt, ...);
 #define IEEE80211_ADDR_LEN              6
 #define FRAME_DESC_SZ                   16
 #define MIN_802_11_HDR_LEN              24
+#define RSI_DEF_KEEPALIVE               90
 
 #define DATA_QUEUE_WATER_MARK           400
 #define MIN_DATA_QUEUE_WATER_MARK       300
diff --git a/drivers/net/wireless/rsi/rsi_mgmt.h b/drivers/net/wireless/rsi/rsi_mgmt.h
index b22103f..201a465 100644
--- a/drivers/net/wireless/rsi/rsi_mgmt.h
+++ b/drivers/net/wireless/rsi/rsi_mgmt.h
@@ -239,6 +239,7 @@ enum cmd_frame_type {
 	CW_MODE_REQ,
 	PER_CMD_PKT,
 	ANT_SEL_FRAME = 0x20,
+	VAP_DYNAMIC_UPDATE = 0x27,
 	COMMON_DEV_CONFIG = 0x28,
 	RADIO_PARAMS_UPDATE = 0x29
 };
@@ -374,6 +375,18 @@ struct rsi_ant_sel_frame {
 	__le32 reserved2;
 } __packed;
 
+struct rsi_dynamic_s {
+	struct rsi_cmd_desc_dword0 desc_dword0;
+	struct rsi_cmd_desc_dword1 desc_dword1;
+	struct rsi_cmd_desc_dword2 desc_dword2;
+	struct rsi_cmd_desc_dword3 desc_dword3;
+	struct framebody {
+		__le16 data_rate;
+		__le16 mgmt_rate;
+		__le16 keep_alive_period;
+	} frame_body;
+} __packed;
+
 /* Key descriptor flags */
 #define RSI_KEY_TYPE_BROADCAST	BIT(1)
 #define RSI_WEP_KEY		BIT(2)
@@ -585,6 +598,7 @@ int rsi_hal_load_key(struct rsi_common *common, u8 *data, u16 key_len,
 		     u8 key_type, u8 key_id, u32 cipher);
 int rsi_set_channel(struct rsi_common *common,
 		    struct ieee80211_channel *channel);
+int rsi_send_vap_dynamic_update(struct rsi_common *common);
 int rsi_send_block_unblock_frame(struct rsi_common *common, bool event);
 void rsi_inform_bss_status(struct rsi_common *common, u8 status,
 			   const u8 *bssid, u8 qos_enable, u16 aid);
-- 
2.7.4
