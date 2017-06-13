Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:36853 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753748AbdFMOwH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Jun 2017 10:52:07 -0400
Received: by mail-pf0-f195.google.com with SMTP id y7so21961690pfd.3
        for <linux-wireless@vger.kernel.org>; Tue, 13 Jun 2017 07:52:07 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, Alexey.Brodkin@synopsys.com,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        "pavani.muthyala" <pavani.muthyala@redpinesignals.com>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>
Subject: [PATCH 11/20] rsi: management frame descriptor preparation cleanup
Date: Tue, 13 Jun 2017 20:18:59 +0530
Message-Id: <1497365348-2305-12-git-send-email-amit.karwar@redpinesignals.com> (sfid-20170613_170120_531331_8C795B6A)
In-Reply-To: <1497365348-2305-1-git-send-email-amit.karwar@redpinesignals.com>
References: <1497365348-2305-1-git-send-email-amit.karwar@redpinesignals.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "pavani.muthyala" <pavani.muthyala@redpinesignals.com>

Currently this descriptor is prepared with the help of __le16
pointer. This patch makes use of a structure to prepare the
descriptor in a cleaner way.

Signed-off-by: pavani.muthyala <pavani.muthyala@redpinesignals.com>
Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_91x_hal.c | 37 +++++++++++++++++-----------------
 drivers/net/wireless/rsi/rsi_hal.h     | 23 +++++++++++++++++++++
 2 files changed, 41 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_hal.c b/drivers/net/wireless/rsi/rsi_91x_hal.c
index 7c9224f..461352a 100644
--- a/drivers/net/wireless/rsi/rsi_91x_hal.c
+++ b/drivers/net/wireless/rsi/rsi_91x_hal.c
@@ -138,9 +138,9 @@ int rsi_send_mgmt_pkt(struct rsi_common *common,
 	struct ieee80211_bss_conf *bss;
 	struct ieee80211_hw *hw = adapter->hw;
 	struct ieee80211_conf *conf = &hw->conf;
+	struct rsi_mgmt_desc *mgmt_desc;
 	struct skb_info *tx_params;
 	int status = -E2BIG;
-	__le16 *msg;
 	u8 extnd_size;
 	u8 vap_id = 0;
 
@@ -176,44 +176,43 @@ int rsi_send_mgmt_pkt(struct rsi_common *common,
 
 	skb_push(skb, FRAME_DESC_SZ);
 	memset(skb->data, 0, FRAME_DESC_SZ);
-	msg = (__le16 *)skb->data;
+	mgmt_desc = (struct rsi_mgmt_desc *)skb->data;
 
 	if (skb->len > MAX_MGMT_PKT_SIZE) {
 		rsi_dbg(INFO_ZONE, "%s: Dropping mgmt pkt > 512\n", __func__);
 		goto err;
 	}
 
-	msg[0] = cpu_to_le16((skb->len - FRAME_DESC_SZ) |
-			    (RSI_WIFI_MGMT_Q << 12));
-	msg[1] = cpu_to_le16(TX_DOT11_MGMT);
-	msg[2] = cpu_to_le16(MIN_802_11_HDR_LEN << 8);
-	msg[3] = cpu_to_le16(RATE_INFO_ENABLE);
-	msg[6] = cpu_to_le16(le16_to_cpu(wh->seq_ctrl) >> 4);
+	mgmt_desc->length = skb->len - FRAME_DESC_SZ;
+	mgmt_desc->q_num = RSI_WIFI_MGMT_Q;
+	mgmt_desc->frame_type = TX_DOT11_MGMT;
+	mgmt_desc->header_len = MIN_802_11_HDR_LEN;
+	mgmt_desc->info_cap |= cpu_to_le16(RATE_INFO_ENABLE);
+	mgmt_desc->seq_ctrl = cpu_to_le16(le16_to_cpu(wh->seq_ctrl) >> 4);
 
 	if (wh->addr1[0] & BIT(0))
-		msg[3] |= cpu_to_le16(RSI_BROADCAST_PKT);
+		mgmt_desc->info_cap |= cpu_to_le16(RSI_BROADCAST_PKT);
 
 	if (common->band == NL80211_BAND_2GHZ)
-		msg[4] = cpu_to_le16(RSI_11B_MODE);
+		mgmt_desc->rate_info = RSI_11B_MODE;
 	else
-		msg[4] = cpu_to_le16((RSI_RATE_6 & 0x0f) | RSI_11G_MODE);
+		mgmt_desc->rate_info = (RSI_RATE_6 & 0x0f) | RSI_11G_MODE;
 
 	if (conf_is_ht40(conf)) {
-		msg[4] = cpu_to_le16(0xB | RSI_11G_MODE);
-		msg[5] = cpu_to_le16(0x6);
+		mgmt_desc->rate_info = 0xB | RSI_11G_MODE;
+		mgmt_desc->bbp_info = BBP_INFO_40MHZ;
 	}
 
 	/* Indicate to firmware to give cfm */
 	if ((skb->data[16] == IEEE80211_STYPE_PROBE_REQ) && (!bss->assoc)) {
-		msg[1] |= cpu_to_le16(BIT(10));
-		msg[7] = cpu_to_le16(PROBEREQ_CONFIRM);
+		mgmt_desc->misc_flags |= BIT(2);
+		mgmt_desc->cfm_frame_type = PROBEREQ_CONFIRM;
 		common->mgmt_q_block = true;
 	}
+	mgmt_desc->vap_info = vap_id << 8;
 
-	msg[7] |= cpu_to_le16(vap_id << 8);
-
-	status = adapter->host_intf_ops->write_pkt(common->priv, (u8 *)msg,
-						   skb->len);
+	status = adapter->host_intf_ops->write_pkt(common->priv,
+						   (u8 *)mgmt_desc, skb->len);
 	if (status)
 		rsi_dbg(ERR_ZONE, "%s: Failed to write the packet\n", __func__);
 
diff --git a/drivers/net/wireless/rsi/rsi_hal.h b/drivers/net/wireless/rsi/rsi_hal.h
index 3179e86..921123e 100644
--- a/drivers/net/wireless/rsi/rsi_hal.h
+++ b/drivers/net/wireless/rsi/rsi_hal.h
@@ -99,6 +99,8 @@
 #define RSI_DEV_OPMODE_WIFI_ALONE	1
 #define RSI_DEV_COEX_MODE_WIFI_ALONE	1
 
+#define BBP_INFO_40MHZ 0x6
+
 struct bl_header {
 	__le32 flags;
 	__le32 image_no;
@@ -112,6 +114,27 @@ struct ta_metadata {
 	unsigned int address;
 };
 
+struct rsi_mgmt_desc {
+#ifdef __LITTLE_ENDIAN
+	u16 length : 12;
+	u16 q_num :4;
+#else
+	u16 q_num :4;
+	u16 length : 12;
+#endif
+	u8 frame_type;
+	u8 misc_flags;
+	u8 reserved1;
+	u8 header_len;
+	__le16 info_cap;
+	u8 rate_info;
+	u8 reserved2;
+	u16 bbp_info;
+	__le16 seq_ctrl;
+	u8 cfm_frame_type;
+	u8 vap_info;
+} __packed;
+
 int rsi_hal_device_init(struct rsi_hw *adapter);
 
 #endif
-- 
2.7.4
