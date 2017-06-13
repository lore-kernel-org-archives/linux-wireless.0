Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:33943 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753311AbdFMOw2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Jun 2017 10:52:28 -0400
Received: by mail-pf0-f196.google.com with SMTP id d5so9727368pfe.1
        for <linux-wireless@vger.kernel.org>; Tue, 13 Jun 2017 07:52:27 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, Alexey.Brodkin@synopsys.com,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        "pavani.muthyala" <pavani.muthyala@redpinesignals.com>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>
Subject: [PATCH 14/20] rsi: data packet descriptor enhancements
Date: Tue, 13 Jun 2017 20:19:02 +0530
Message-Id: <1497365348-2305-15-git-send-email-amit.karwar@redpinesignals.com> (sfid-20170613_170120_365164_A66C4F3C)
In-Reply-To: <1497365348-2305-1-git-send-email-amit.karwar@redpinesignals.com>
References: <1497365348-2305-1-git-send-email-amit.karwar@redpinesignals.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "pavani.muthyala" <pavani.muthyala@redpinesignals.com>

This patch covers some enhancements in data packet descriptor
preparation especially for EAPOL, multicast/broadcast packets.

Signed-off-by: pavani.muthyala <pavani.muthyala@redpinesignals.com>
Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_91x_hal.c | 63 +++++++++++++++++++++++++++-------
 drivers/net/wireless/rsi/rsi_hal.h     |  3 +-
 drivers/net/wireless/rsi/rsi_mgmt.h    |  3 ++
 3 files changed, 55 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_hal.c b/drivers/net/wireless/rsi/rsi_91x_hal.c
index 8a66edd..20cb608 100644
--- a/drivers/net/wireless/rsi/rsi_91x_hal.c
+++ b/drivers/net/wireless/rsi/rsi_91x_hal.c
@@ -122,14 +122,18 @@ static int rsi_prepare_mgmt_desc(struct rsi_common *common, struct sk_buff *skb)
 int rsi_send_data_pkt(struct rsi_common *common, struct sk_buff *skb)
 {
 	struct rsi_hw *adapter = common->priv;
-	struct ieee80211_hdr *tmp_hdr;
+	struct ieee80211_hdr *wh = NULL;
 	struct ieee80211_tx_info *info;
+	struct ieee80211_vif *vif = NULL;
 	struct skb_info *tx_params;
 	struct ieee80211_bss_conf *bss;
 	struct rsi_data_desc *data_desc;
+	struct xtended_desc *xtend_desc;
 	int status;
 	u8 ieee80211_size = MIN_802_11_HDR_LEN;
-	u8 extnd_size;
+	u8 header_size = 0;
+	u8 vap_id = 0;
+	u8 dword_align_bytes = 0;
 	u16 seq_num;
 
 	info = IEEE80211_SKB_CB(skb);
@@ -140,23 +144,34 @@ int rsi_send_data_pkt(struct rsi_common *common, struct sk_buff *skb)
 		status = -EINVAL;
 		goto err;
 	}
-
-	tmp_hdr = (struct ieee80211_hdr *)&skb->data[0];
-	seq_num = (le16_to_cpu(tmp_hdr->seq_ctrl) >> 4);
-
-	extnd_size = ((uintptr_t)skb->data & 0x3);
-
-	if ((FRAME_DESC_SZ + extnd_size) > skb_headroom(skb)) {
+	header_size = FRAME_DESC_SZ + sizeof(struct xtended_desc);
+	if (header_size > skb_headroom(skb)) {
 		rsi_dbg(ERR_ZONE, "%s: Unable to send pkt\n", __func__);
 		status = -ENOSPC;
 		goto err;
 	}
+	skb_push(skb, header_size);
+	dword_align_bytes = ((unsigned long)skb->data & 0x3f);
+	if (header_size > skb_headroom(skb)) {
+		rsi_dbg(ERR_ZONE, "%s: Not enough headroom\n", __func__);
+		status = -ENOSPC;
+		goto err;
+	}
+	skb_push(skb, dword_align_bytes);
+	header_size += dword_align_bytes;
 
-	skb_push(skb, (FRAME_DESC_SZ + extnd_size));
+	tx_params->internal_hdr_size = header_size;
 	data_desc = (struct rsi_data_desc *)skb->data;
-	memset(data_desc, 0, sizeof(*data_desc));
+	memset(data_desc, 0, header_size);
+
+	xtend_desc = (struct xtended_desc *)&skb->data[FRAME_DESC_SZ];
+	wh = (struct ieee80211_hdr *)&skb->data[header_size];
+	seq_num = (le16_to_cpu(wh->seq_ctrl) >> 4);
+	vif = adapter->vifs[0];
 
-	if (ieee80211_is_data_qos(tmp_hdr->frame_control)) {
+	data_desc->xtend_desc_size = header_size - FRAME_DESC_SZ;
+
+	if (ieee80211_is_data_qos(wh->frame_control)) {
 		ieee80211_size += 2;
 		data_desc->mac_flags |= cpu_to_le16(RSI_QOS_ENABLE);
 	}
@@ -172,7 +187,6 @@ int rsi_send_data_pkt(struct rsi_common *common, struct sk_buff *skb)
 	data_desc->length = skb->len - FRAME_DESC_SZ;
 	data_desc->q_num = RSI_WIFI_DATA_Q;
 	data_desc->header_len = ieee80211_size;
-	data_desc->xtend_desc_size = extnd_size;
 
 	if (common->min_rate != RSI_RATE_AUTO) {
 		/* Send fixed rate */
@@ -190,11 +204,34 @@ int rsi_send_data_pkt(struct rsi_common *common, struct sk_buff *skb)
 
 	}
 
+	if (skb->protocol == cpu_to_be16(ETH_P_PAE)) {
+		rsi_dbg(INFO_ZONE, "*** Tx EAPOL ***\n");
+
+		data_desc->frame_info = cpu_to_le16(RATE_INFO_ENABLE);
+		if (common->band == NL80211_BAND_5GHZ)
+			data_desc->rate_info = cpu_to_le16(RSI_RATE_6);
+		else
+			data_desc->rate_info = cpu_to_le16(RSI_RATE_1);
+		data_desc->mac_flags |= cpu_to_le16(RSI_REKEY_PURPOSE);
+		data_desc->misc_flags |= RSI_FETCH_RETRY_CNT_FRM_HST;
+#define EAPOL_RETRY_CNT 15
+		xtend_desc->retry_cnt = EAPOL_RETRY_CNT;
+	}
+
 	data_desc->mac_flags = cpu_to_le16(seq_num & 0xfff);
 	data_desc->qid = skb->priority & 0xf;
 	data_desc->tid = tx_params->tid & 0xf;
 	data_desc->sta_id = tx_params->sta_id;
 
+	if ((is_broadcast_ether_addr(wh->addr1)) ||
+	    (is_multicast_ether_addr(wh->addr1))) {
+		data_desc->frame_info = cpu_to_le16(RATE_INFO_ENABLE);
+		data_desc->frame_info |= cpu_to_le16(RSI_BROADCAST_PKT);
+		data_desc->qid = skb->priority & 0xf;
+		data_desc->tid = tx_params->tid & 0xf;
+		data_desc->sta_id = vap_id;
+	}
+
 	status = adapter->host_intf_ops->write_pkt(common->priv, skb->data,
 						   skb->len);
 	if (status)
diff --git a/drivers/net/wireless/rsi/rsi_hal.h b/drivers/net/wireless/rsi/rsi_hal.h
index b137de2..9d6c6f9 100644
--- a/drivers/net/wireless/rsi/rsi_hal.h
+++ b/drivers/net/wireless/rsi/rsi_hal.h
@@ -143,7 +143,8 @@ struct rsi_data_desc {
 	u16 q_num :4;
 	u16 length : 12;
 #endif
-	u16 reserved;
+	u8 cfm_frame_type;
+	u8 misc_flags;
 	u8 xtend_desc_size;
 	u8 header_len;
 	__le16 frame_info;
diff --git a/drivers/net/wireless/rsi/rsi_mgmt.h b/drivers/net/wireless/rsi/rsi_mgmt.h
index 2a223a6..78ea1c7 100644
--- a/drivers/net/wireless/rsi/rsi_mgmt.h
+++ b/drivers/net/wireless/rsi/rsi_mgmt.h
@@ -64,7 +64,10 @@
 #define RATE_INFO_ENABLE                BIT(0)
 #define RSI_BROADCAST_PKT               BIT(9)
 #define RSI_DESC_REQUIRE_CFM_TO_HOST	BIT(2)
+#define RSI_ADD_DELTA_TSF_VAP_ID	BIT(3)
+#define RSI_FETCH_RETRY_CNT_FRM_HST	BIT(4)
 #define RSI_QOS_ENABLE			BIT(12)
+#define RSI_REKEY_PURPOSE		BIT(13)
 #define RSI_ENCRYPT_PKT			BIT(15)
 
 #define UPPER_20_ENABLE                 (0x2 << 12)
-- 
2.7.4
