Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:36832 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751871AbdGFOnA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Jul 2017 10:43:00 -0400
Received: by mail-pf0-f194.google.com with SMTP id z6so554776pfk.3
        for <linux-wireless@vger.kernel.org>; Thu, 06 Jul 2017 07:42:55 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Pavani Muthyala <pavani.muthyala@redpinesignals.com>
Subject: [v3 14/21] rsi: data packet descriptor code cleanup
Date: Thu,  6 Jul 2017 20:07:17 +0530
Message-Id: <1499351844-2046-15-git-send-email-amitkarwar@gmail.com> (sfid-20170706_164303_844170_8698464C)
In-Reply-To: <1499351844-2046-1-git-send-email-amitkarwar@gmail.com>
References: <1499351844-2046-1-git-send-email-amitkarwar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Pavani Muthyala <pavani.muthyala@redpinesignals.com>

Currently this descriptor is prepared with the help of __le16
pointer. This patch makes use of a structure to prepare the
descriptor in a cleaner way.

Signed-off-by: Pavani Muthyala <pavani.muthyala@redpinesignals.com>
Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_91x_hal.c | 41 +++++++++++++++++-----------------
 drivers/net/wireless/rsi/rsi_hal.h     | 13 +++++++++++
 drivers/net/wireless/rsi/rsi_mgmt.h    |  3 +++
 3 files changed, 36 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_hal.c b/drivers/net/wireless/rsi/rsi_91x_hal.c
index f8ccb1c..9da2fc8 100644
--- a/drivers/net/wireless/rsi/rsi_91x_hal.c
+++ b/drivers/net/wireless/rsi/rsi_91x_hal.c
@@ -123,10 +123,10 @@ int rsi_send_data_pkt(struct rsi_common *common, struct sk_buff *skb)
 	struct ieee80211_tx_info *info;
 	struct skb_info *tx_params;
 	struct ieee80211_bss_conf *bss;
+	struct rsi_data_desc *data_desc;
 	int status;
 	u8 ieee80211_size = MIN_802_11_HDR_LEN;
 	u8 extnd_size;
-	__le16 *frame_desc;
 	u16 seq_num;
 
 	info = IEEE80211_SKB_CB(skb);
@@ -150,12 +150,12 @@ int rsi_send_data_pkt(struct rsi_common *common, struct sk_buff *skb)
 	}
 
 	skb_push(skb, (FRAME_DESC_SZ + extnd_size));
-	frame_desc = (__le16 *)&skb->data[0];
-	memset((u8 *)frame_desc, 0, FRAME_DESC_SZ);
+	data_desc = (struct rsi_data_desc *)skb->data;
+	memset(data_desc, 0, sizeof(*data_desc));
 
 	if (ieee80211_is_data_qos(tmp_hdr->frame_control)) {
 		ieee80211_size += 2;
-		frame_desc[6] |= cpu_to_le16(BIT(12));
+		data_desc->mac_flags |= cpu_to_le16(RSI_QOS_ENABLE);
 	}
 
 	if ((!(info->flags & IEEE80211_TX_INTFL_DONT_ENCRYPT)) &&
@@ -164,35 +164,34 @@ int rsi_send_data_pkt(struct rsi_common *common, struct sk_buff *skb)
 			ieee80211_size += 4;
 		else
 			ieee80211_size += 8;
-		frame_desc[6] |= cpu_to_le16(BIT(15));
+		data_desc->mac_flags |= cpu_to_le16(RSI_ENCRYPT_PKT);
 	}
+	rsi_set_len_qno(&data_desc->len_qno, (skb->len - FRAME_DESC_SZ),
+			RSI_WIFI_DATA_Q);
+	data_desc->header_len = ieee80211_size;
+	data_desc->xtend_desc_size = extnd_size;
 
-	frame_desc[0] = cpu_to_le16((skb->len - FRAME_DESC_SZ) |
-				    (RSI_WIFI_DATA_Q << 12));
-	frame_desc[2] = cpu_to_le16((extnd_size) | (ieee80211_size) << 8);
-
-	if (common->min_rate != 0xffff) {
+	if (common->min_rate != RSI_RATE_AUTO) {
 		/* Send fixed rate */
-		frame_desc[3] = cpu_to_le16(RATE_INFO_ENABLE);
-		frame_desc[4] = cpu_to_le16(common->min_rate);
+		data_desc->frame_info = cpu_to_le16(RATE_INFO_ENABLE);
+		data_desc->rate_info = cpu_to_le16(common->min_rate);
 
 		if (conf_is_ht40(&common->priv->hw->conf))
-			frame_desc[5] = cpu_to_le16(FULL40M_ENABLE);
+			data_desc->bbp_info = cpu_to_le16(FULL40M_ENABLE);
 
 		if (common->vif_info[0].sgi) {
 			if (common->min_rate & 0x100) /* Only MCS rates */
-				frame_desc[4] |=
+				data_desc->rate_info |=
 					cpu_to_le16(ENABLE_SHORTGI_RATE);
 		}
-
 	}
 
-	frame_desc[6] |= cpu_to_le16(seq_num & 0xfff);
-	frame_desc[7] = cpu_to_le16(((tx_params->tid & 0xf) << 4) |
-				    (skb->priority & 0xf) |
-				    (tx_params->sta_id << 8));
+	data_desc->mac_flags = cpu_to_le16(seq_num & 0xfff);
+	data_desc->qid_tid = ((skb->priority & 0xf) |
+			      ((tx_params->tid & 0xf) << 4));
+	data_desc->sta_id = tx_params->sta_id;
 
-	status = adapter->host_intf_ops->write_pkt(common->priv, skb->data,
+	status = adapter->host_intf_ops->write_pkt(adapter, skb->data,
 						   skb->len);
 	if (status)
 		rsi_dbg(ERR_ZONE, "%s: Failed to write pkt\n",
@@ -200,7 +199,7 @@ int rsi_send_data_pkt(struct rsi_common *common, struct sk_buff *skb)
 
 err:
 	++common->tx_stats.total_tx_pkt_freed[skb->priority];
-	rsi_indicate_tx_status(common->priv, skb, status);
+	rsi_indicate_tx_status(adapter, skb, status);
 	return status;
 }
 
diff --git a/drivers/net/wireless/rsi/rsi_hal.h b/drivers/net/wireless/rsi/rsi_hal.h
index adbe54e..2ae5863 100644
--- a/drivers/net/wireless/rsi/rsi_hal.h
+++ b/drivers/net/wireless/rsi/rsi_hal.h
@@ -129,6 +129,19 @@ struct rsi_mgmt_desc {
 	u8 vap_info;
 } __packed;
 
+struct rsi_data_desc {
+	__le16 len_qno;
+	u16 reserved;
+	u8 xtend_desc_size;
+	u8 header_len;
+	__le16 frame_info;
+	__le16 rate_info;
+	__le16 bbp_info;
+	__le16 mac_flags;
+	u8 qid_tid;
+	u8 sta_id;
+} __packed;
+
 int rsi_hal_device_init(struct rsi_hw *adapter);
 
 #endif
diff --git a/drivers/net/wireless/rsi/rsi_mgmt.h b/drivers/net/wireless/rsi/rsi_mgmt.h
index 8e05e0b..058dfe5 100644
--- a/drivers/net/wireless/rsi/rsi_mgmt.h
+++ b/drivers/net/wireless/rsi/rsi_mgmt.h
@@ -64,6 +64,8 @@
 #define RATE_INFO_ENABLE                BIT(0)
 #define RSI_BROADCAST_PKT               BIT(9)
 #define RSI_DESC_REQUIRE_CFM_TO_HOST	BIT(2)
+#define RSI_QOS_ENABLE			BIT(12)
+#define RSI_ENCRYPT_PKT			BIT(15)
 
 #define UPPER_20_ENABLE                 (0x2 << 12)
 #define LOWER_20_ENABLE                 (0x4 << 12)
@@ -122,6 +124,7 @@
 #define RSI_RATE_MCS6                   0x106
 #define RSI_RATE_MCS7                   0x107
 #define RSI_RATE_MCS7_SG                0x307
+#define RSI_RATE_AUTO			0xffff
 
 #define BW_20MHZ                        0
 #define BW_40MHZ                        1
-- 
2.7.4
