Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:33260 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753360AbdFMOwQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Jun 2017 10:52:16 -0400
Received: by mail-pg0-f67.google.com with SMTP id a70so19227768pge.0
        for <linux-wireless@vger.kernel.org>; Tue, 13 Jun 2017 07:52:16 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, Alexey.Brodkin@synopsys.com,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Karun Eagalapati <karun256@gmail.com>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>
Subject: [PATCH 12/20] rsi: separate function for management packet descriptor
Date: Tue, 13 Jun 2017 20:19:00 +0530
Message-Id: <1497365348-2305-13-git-send-email-amit.karwar@redpinesignals.com> (sfid-20170613_170120_079353_0B3A670F)
In-Reply-To: <1497365348-2305-1-git-send-email-amit.karwar@redpinesignals.com>
References: <1497365348-2305-1-git-send-email-amit.karwar@redpinesignals.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Karun Eagalapati <karun256@gmail.com>

management packet descriptor preparation code is moved a separate
function.

Signed-off-by: Karun Eagalapati <karun256@gmail.com>
Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_91x_hal.c | 135 +++++++++++++++++++++------------
 drivers/net/wireless/rsi/rsi_hal.h     |  10 +--
 drivers/net/wireless/rsi/rsi_main.h    |   7 ++
 drivers/net/wireless/rsi/rsi_mgmt.h    |   1 +
 4 files changed, 101 insertions(+), 52 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_hal.c b/drivers/net/wireless/rsi/rsi_91x_hal.c
index 461352a..bc2ee8c 100644
--- a/drivers/net/wireless/rsi/rsi_91x_hal.c
+++ b/drivers/net/wireless/rsi/rsi_91x_hal.c
@@ -25,6 +25,92 @@ static struct ta_metadata metadata_flash_content[] = {
 	{"rsi/rs9113_wlan_qspi.rps", 0x00010000},
 };
 
+/* This function prepares descriptor for given management packet */
+
+static int rsi_prepare_mgmt_desc(struct rsi_common *common, struct sk_buff *skb)
+{
+	struct rsi_hw *adapter = common->priv;
+	struct ieee80211_hdr *wh = NULL;
+	struct ieee80211_tx_info *info;
+	struct ieee80211_conf *conf = &adapter->hw->conf;
+	struct ieee80211_vif *vif = NULL;
+	struct rsi_mgmt_desc *mgmt_desc;
+	struct skb_info *tx_params;
+	int status = -EINVAL;
+	struct ieee80211_bss_conf *bss = NULL;
+	struct xtended_desc *xtend_desc = NULL;
+	u8 header_size;
+	u32 dword_align_bytes = 0;
+
+	info = IEEE80211_SKB_CB(skb);
+	tx_params = (struct skb_info *)info->driver_data;
+
+	/* Update header size */
+	header_size = FRAME_DESC_SZ + sizeof(struct xtended_desc);
+	if (header_size > skb_headroom(skb)) {
+		rsi_dbg(ERR_ZONE,
+			"%s: Failed to add extended descriptor\n",
+			__func__);
+		status = -ENOSPC;
+		return status;
+	}
+	skb_push(skb, header_size);
+	dword_align_bytes = ((unsigned long)skb->data & 0x3f);
+	if (dword_align_bytes > skb_headroom(skb)) {
+		rsi_dbg(ERR_ZONE,
+			"%s: Failed to add dword align\n", __func__);
+		status = -ENOSPC;
+		return status;
+	}
+	skb_push(skb, dword_align_bytes);
+	header_size += dword_align_bytes;
+
+	tx_params->internal_hdr_size = header_size;
+	memset(&skb->data[0], 0, header_size);
+	bss = &info->control.vif->bss_conf;
+	wh = (struct ieee80211_hdr *)&skb->data[header_size];
+	vif = adapter->vifs[0];
+
+	mgmt_desc = (struct rsi_mgmt_desc *)skb->data;
+	xtend_desc = (struct xtended_desc *)&skb->data[FRAME_DESC_SZ];
+
+	if (skb->len > MAX_MGMT_PKT_SIZE) {
+		rsi_dbg(INFO_ZONE, "%s: Dropping mgmt pkt > 512\n", __func__);
+		return status;
+	}
+	mgmt_desc->length = skb->len - FRAME_DESC_SZ;
+	mgmt_desc->q_num = RSI_WIFI_MGMT_Q;
+	mgmt_desc->frame_type = TX_DOT11_MGMT;
+	mgmt_desc->header_len = MIN_802_11_HDR_LEN;
+	mgmt_desc->xtend_desc_size = header_size - FRAME_DESC_SZ;
+	mgmt_desc->frame_info |= cpu_to_le16(RATE_INFO_ENABLE);
+	if (is_broadcast_ether_addr(wh->addr1))
+		mgmt_desc->frame_info |= cpu_to_le16(RSI_BROADCAST_PKT);
+
+	mgmt_desc->seq_ctrl =
+		cpu_to_le16(IEEE80211_SEQ_TO_SN(le16_to_cpu(wh->seq_ctrl)));
+	if (common->band == NL80211_BAND_2GHZ)
+		mgmt_desc->rate_info = RSI_RATE_1;
+	else
+		mgmt_desc->rate_info = RSI_RATE_6;
+
+	if (conf_is_ht40(conf))
+		mgmt_desc->bbp_info = cpu_to_le16(FULL40M_ENABLE);
+
+	if (ieee80211_is_probe_req(wh->frame_control)) {
+		if (!bss->assoc) {
+			rsi_dbg(INFO_ZONE,
+				"%s: blocking mgmt queue\n", __func__);
+			mgmt_desc->misc_flags = RSI_DESC_REQUIRE_CFM_TO_HOST;
+			xtend_desc->confirm_frame_type = PROBEREQ_CONFIRM;
+			common->mgmt_q_block = true;
+			rsi_dbg(INFO_ZONE, "Mgmt queue blocked\n");
+		}
+	}
+
+	return 0;
+}
+
 /**
  * rsi_send_data_pkt() - This function sends the recieved data packet from
  *			 driver to device.
@@ -133,16 +219,10 @@ int rsi_send_mgmt_pkt(struct rsi_common *common,
 		      struct sk_buff *skb)
 {
 	struct rsi_hw *adapter = common->priv;
-	struct ieee80211_hdr *wh;
 	struct ieee80211_tx_info *info;
-	struct ieee80211_bss_conf *bss;
-	struct ieee80211_hw *hw = adapter->hw;
-	struct ieee80211_conf *conf = &hw->conf;
-	struct rsi_mgmt_desc *mgmt_desc;
 	struct skb_info *tx_params;
 	int status = -E2BIG;
 	u8 extnd_size;
-	u8 vap_id = 0;
 
 	info = IEEE80211_SKB_CB(skb);
 	tx_params = (struct skb_info *)info->driver_data;
@@ -168,51 +248,12 @@ int rsi_send_mgmt_pkt(struct rsi_common *common,
 		return status;
 	}
 
-	bss = &info->control.vif->bss_conf;
-	wh = (struct ieee80211_hdr *)&skb->data[0];
-
 	if (FRAME_DESC_SZ > skb_headroom(skb))
 		goto err;
 
-	skb_push(skb, FRAME_DESC_SZ);
-	memset(skb->data, 0, FRAME_DESC_SZ);
-	mgmt_desc = (struct rsi_mgmt_desc *)skb->data;
-
-	if (skb->len > MAX_MGMT_PKT_SIZE) {
-		rsi_dbg(INFO_ZONE, "%s: Dropping mgmt pkt > 512\n", __func__);
-		goto err;
-	}
-
-	mgmt_desc->length = skb->len - FRAME_DESC_SZ;
-	mgmt_desc->q_num = RSI_WIFI_MGMT_Q;
-	mgmt_desc->frame_type = TX_DOT11_MGMT;
-	mgmt_desc->header_len = MIN_802_11_HDR_LEN;
-	mgmt_desc->info_cap |= cpu_to_le16(RATE_INFO_ENABLE);
-	mgmt_desc->seq_ctrl = cpu_to_le16(le16_to_cpu(wh->seq_ctrl) >> 4);
-
-	if (wh->addr1[0] & BIT(0))
-		mgmt_desc->info_cap |= cpu_to_le16(RSI_BROADCAST_PKT);
-
-	if (common->band == NL80211_BAND_2GHZ)
-		mgmt_desc->rate_info = RSI_11B_MODE;
-	else
-		mgmt_desc->rate_info = (RSI_RATE_6 & 0x0f) | RSI_11G_MODE;
-
-	if (conf_is_ht40(conf)) {
-		mgmt_desc->rate_info = 0xB | RSI_11G_MODE;
-		mgmt_desc->bbp_info = BBP_INFO_40MHZ;
-	}
-
-	/* Indicate to firmware to give cfm */
-	if ((skb->data[16] == IEEE80211_STYPE_PROBE_REQ) && (!bss->assoc)) {
-		mgmt_desc->misc_flags |= BIT(2);
-		mgmt_desc->cfm_frame_type = PROBEREQ_CONFIRM;
-		common->mgmt_q_block = true;
-	}
-	mgmt_desc->vap_info = vap_id << 8;
-
+	rsi_prepare_mgmt_desc(common, skb);
 	status = adapter->host_intf_ops->write_pkt(common->priv,
-						   (u8 *)mgmt_desc, skb->len);
+						   (u8 *)skb->data, skb->len);
 	if (status)
 		rsi_dbg(ERR_ZONE, "%s: Failed to write the packet\n", __func__);
 
diff --git a/drivers/net/wireless/rsi/rsi_hal.h b/drivers/net/wireless/rsi/rsi_hal.h
index 921123e..aa58125 100644
--- a/drivers/net/wireless/rsi/rsi_hal.h
+++ b/drivers/net/wireless/rsi/rsi_hal.h
@@ -124,14 +124,14 @@ struct rsi_mgmt_desc {
 #endif
 	u8 frame_type;
 	u8 misc_flags;
-	u8 reserved1;
+	u8 xtend_desc_size;
 	u8 header_len;
-	__le16 info_cap;
+	__le16 frame_info;
 	u8 rate_info;
-	u8 reserved2;
-	u16 bbp_info;
+	u8 reserved1;
+	__le16 bbp_info;
 	__le16 seq_ctrl;
-	u8 cfm_frame_type;
+	u8 reserved2;
 	u8 vap_info;
 } __packed;
 
diff --git a/drivers/net/wireless/rsi/rsi_main.h b/drivers/net/wireless/rsi/rsi_main.h
index fc99c17..4b4312e 100644
--- a/drivers/net/wireless/rsi/rsi_main.h
+++ b/drivers/net/wireless/rsi/rsi_main.h
@@ -103,6 +103,7 @@ struct skb_info {
 	u16 channel;
 	s8 tid;
 	s8 sta_id;
+	u8 internal_hdr_size;
 };
 
 enum edca_queue {
@@ -156,6 +157,12 @@ struct cqm_info {
 	u32 rssi_hyst;
 };
 
+struct xtended_desc {
+	u8 confirm_frame_type;
+	u8 retry_cnt;
+	u16 reserved;
+};
+
 struct rsi_hw;
 
 struct rsi_common {
diff --git a/drivers/net/wireless/rsi/rsi_mgmt.h b/drivers/net/wireless/rsi/rsi_mgmt.h
index f5cc4c6..04c491d 100644
--- a/drivers/net/wireless/rsi/rsi_mgmt.h
+++ b/drivers/net/wireless/rsi/rsi_mgmt.h
@@ -63,6 +63,7 @@
 #define RF_RESET_ENABLE                 BIT(3)
 #define RATE_INFO_ENABLE                BIT(0)
 #define RSI_BROADCAST_PKT               BIT(9)
+#define RSI_DESC_REQUIRE_CFM_TO_HOST	BIT(2)
 
 #define UPPER_20_ENABLE                 (0x2 << 12)
 #define LOWER_20_ENABLE                 (0x4 << 12)
-- 
2.7.4
