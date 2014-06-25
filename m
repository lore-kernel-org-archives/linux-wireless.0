Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:65453 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755347AbaFYUPN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jun 2014 16:15:13 -0400
Received: by mail-wg0-f49.google.com with SMTP id y10so2685494wgg.32
        for <linux-wireless@vger.kernel.org>; Wed, 25 Jun 2014 13:15:12 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 02/17] staging: vt6656: mac80211 conversion: Create tx functions
Date: Wed, 25 Jun 2014 21:14:23 +0100
Message-Id: <1403727278-6666-3-git-send-email-tvboxspy@gmail.com> (sfid-20140625_221653_935489_8014E850)
In-Reply-To: <1403727278-6666-1-git-send-email-tvboxspy@gmail.com>
References: <1403727278-6666-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Create vnt_fill_txkey as mac80211 replacement for s_vFillTxKey.

Create vnt_tx_packet which a merger of s_bPacketToWirelessUsb, nsDMA_tx_packet
and csMgmt_xmit using mac80211 signalling.

Create vnt_beacon_xmit as mac80211 replacement for csBeacon_xmit. Changing
header in vnt_beacon_buffer to struct ieee80211_mgmt deleting some of
old code. vnt_beacon_make is needed to make beacon for vnt_beacon_xmit.

Create vnt_beacon_enable as mac80211 call to enable beacon.

vnt_fill_ieee80211_rts is modified to use struct ieee80211_hdr instead of
struct ethhdr and access to tx_context.

In s_nsBulkOutIoCompleteWrite modify context handling

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>

---
 drivers/staging/vt6656/device.h  |   3 +-
 drivers/staging/vt6656/rxtx.c    | 437 ++++++++++++++++++++++++++++++++++++---
 drivers/staging/vt6656/rxtx.h    |   7 +-
 drivers/staging/vt6656/usbpipe.c |  28 +--
 4 files changed, 432 insertions(+), 43 deletions(-)

diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index 631f402..23fc5e2 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -223,7 +223,8 @@ struct vnt_rsp_card_init {
  */
 enum {
 	CONTEXT_DATA_PACKET = 1,
-	CONTEXT_MGMT_PACKET
+	CONTEXT_MGMT_PACKET,
+	CONTEXT_BEACON_PACKET
 };
 
 /* RCB (Receive Control Block) */
diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 3c19288..7f7c13a 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -578,24 +578,18 @@ static u16 vnt_rxtx_datahead_ab(struct vnt_usb_send_context *tx_context,
 	return le16_to_cpu(buf->duration);
 }
 
-static int vnt_fill_ieee80211_rts(struct vnt_private *priv,
-	struct ieee80211_rts *rts, struct ethhdr *eth_hdr,
-		__le16 duration)
+static int vnt_fill_ieee80211_rts(struct vnt_usb_send_context *tx_context,
+	struct ieee80211_rts *rts, __le16 duration)
 {
+	struct ieee80211_hdr *hdr =
+				(struct ieee80211_hdr *)tx_context->skb->data;
+
 	rts->duration = duration;
 	rts->frame_control =
 		cpu_to_le16(IEEE80211_FTYPE_CTL | IEEE80211_STYPE_RTS);
 
-	if (priv->op_mode == NL80211_IFTYPE_ADHOC ||
-				priv->op_mode == NL80211_IFTYPE_AP)
-		memcpy(rts->ra, eth_hdr->h_dest, ETH_ALEN);
-	else
-		memcpy(rts->ra, priv->abyBSSID, ETH_ALEN);
-
-	if (priv->op_mode == NL80211_IFTYPE_AP)
-		memcpy(rts->ta, priv->abyBSSID, ETH_ALEN);
-	else
-		memcpy(rts->ta, eth_hdr->h_source, ETH_ALEN);
+	memcpy(rts->ra, hdr->addr1, ETH_ALEN);
+	memcpy(rts->ta, hdr->addr2, ETH_ALEN);
 
 	return 0;
 }
@@ -620,7 +614,7 @@ static u16 vnt_rxtx_rts_g_head(struct vnt_usb_send_context *tx_context,
 	buf->duration_ba = s_uGetRTSCTSDuration(priv, RTSDUR_BA, frame_len,
 		pkt_type, current_rate, need_ack, fb_option);
 
-	vnt_fill_ieee80211_rts(priv, &buf->data, eth_hdr, buf->duration_aa);
+	vnt_fill_ieee80211_rts(tx_context, &buf->data, buf->duration_aa);
 
 	return vnt_rxtx_datahead_g(tx_context, pkt_type, current_rate,
 			&buf->data_head, frame_len, need_ack);
@@ -657,7 +651,7 @@ static u16 vnt_rxtx_rts_g_fb_head(struct vnt_usb_send_context *tx_context,
 	buf->rts_duration_aa_f1 = s_uGetRTSCTSDuration(priv, RTSDUR_AA_F1,
 		frame_len, pkt_type, priv->tx_rate_fb1, need_ack, fb_option);
 
-	vnt_fill_ieee80211_rts(priv, &buf->data, eth_hdr, buf->duration_aa);
+	vnt_fill_ieee80211_rts(tx_context, &buf->data, buf->duration_aa);
 
 	return vnt_rxtx_datahead_g_fb(tx_context, pkt_type, current_rate,
 			&buf->data_head, frame_len, need_ack);
@@ -677,7 +671,7 @@ static u16 vnt_rxtx_rts_ab_head(struct vnt_usb_send_context *tx_context,
 	buf->duration = s_uGetRTSCTSDuration(priv, RTSDUR_AA, frame_len,
 		pkt_type, current_rate, need_ack, fb_option);
 
-	vnt_fill_ieee80211_rts(priv, &buf->data, eth_hdr, buf->duration);
+	vnt_fill_ieee80211_rts(tx_context, &buf->data, buf->duration);
 
 	return vnt_rxtx_datahead_ab(tx_context, pkt_type, current_rate,
 			&buf->data_head, frame_len, need_ack);
@@ -703,7 +697,7 @@ static u16 vnt_rxtx_rts_a_fb_head(struct vnt_usb_send_context *tx_context,
 	buf->rts_duration_f1 = s_uGetRTSCTSDuration(priv, RTSDUR_AA_F1,
 		frame_len, pkt_type, priv->tx_rate_fb1, need_ack, fb_option);
 
-	vnt_fill_ieee80211_rts(priv, &buf->data, eth_hdr, buf->duration);
+	vnt_fill_ieee80211_rts(tx_context, &buf->data, buf->duration);
 
 	return vnt_rxtx_datahead_a_fb(tx_context, pkt_type, current_rate,
 			&buf->data_head, frame_len, need_ack);
@@ -1626,7 +1620,6 @@ CMD_STATUS csBeacon_xmit(struct vnt_private *pDevice,
 	struct vnt_tx_short_buf_head *short_head;
 	u32 cbFrameSize = pPacket->cbMPDULen + WLAN_FCS_LEN;
 	u32 cbHeaderSize = 0;
-	struct ieee80211_hdr *pMACHeader;
 	u16 wCurrentRate;
 	u32 cbFrameBodySize;
 	u32 cbReqCount;
@@ -1676,12 +1669,6 @@ CMD_STATUS csBeacon_xmit(struct vnt_private *pDevice,
 
 
 	/* Generate Beacon Header */
-	pMACHeader = &pTX_Buffer->hdr;
-
-	memcpy(pMACHeader, pPacket->p80211Header, pPacket->cbMPDULen);
-
-	pMACHeader->duration_id = 0;
-	pMACHeader->seq_ctrl = cpu_to_le16(pDevice->wSeqCounter << 4);
 	pDevice->wSeqCounter++;
 	if (pDevice->wSeqCounter > 0x0fff)
 		pDevice->wSeqCounter = 0;
@@ -2067,3 +2054,405 @@ int nsDMA_tx_packet(struct vnt_private *pDevice, struct sk_buff *skb)
 
 	return 0;
 }
+
+static void vnt_fill_txkey(struct vnt_usb_send_context *tx_context,
+	u8 *key_buffer, struct ieee80211_key_conf *tx_key, struct sk_buff *skb,
+	u16 payload_len, struct vnt_mic_hdr *mic_hdr)
+{
+	struct ieee80211_hdr *hdr = tx_context->hdr;
+	struct ieee80211_key_seq seq;
+	u8 *iv = ((u8 *)hdr + ieee80211_get_hdrlen_from_skb(skb));
+
+	/* strip header and icv len from payload */
+	payload_len -= ieee80211_get_hdrlen_from_skb(skb);
+	payload_len -= tx_key->icv_len;
+
+	switch (tx_key->cipher) {
+	case WLAN_CIPHER_SUITE_WEP40:
+	case WLAN_CIPHER_SUITE_WEP104:
+		memcpy(key_buffer, iv, 3);
+		memcpy(key_buffer + 3, tx_key->key, tx_key->keylen);
+
+		if (tx_key->keylen == WLAN_KEY_LEN_WEP40) {
+			memcpy(key_buffer + 8, iv, 3);
+			memcpy(key_buffer + 11,
+					tx_key->key, WLAN_KEY_LEN_WEP40);
+		}
+
+		break;
+	case WLAN_CIPHER_SUITE_TKIP:
+		ieee80211_get_tkip_p2k(tx_key, skb, key_buffer);
+
+		break;
+	case WLAN_CIPHER_SUITE_CCMP:
+
+		if (!mic_hdr)
+			return;
+
+		mic_hdr->id = 0x59;
+		mic_hdr->payload_len = cpu_to_be16(payload_len);
+		memcpy(mic_hdr->mic_addr2, hdr->addr2, ETH_ALEN);
+
+		ieee80211_get_key_tx_seq(tx_key, &seq);
+
+		mic_hdr->tsc_47_16 = cpu_to_be32((u32)seq.ccmp.pn[3] |
+						((u32)seq.ccmp.pn[2] << 8) |
+						((u32)seq.ccmp.pn[1] << 16) |
+						((u32)seq.ccmp.pn[0] << 24));
+
+		mic_hdr->tsc_15_0 = cpu_to_be16((u16)seq.ccmp.pn[5] |
+						((u16)seq.ccmp.pn[4] << 8));
+
+		if (ieee80211_has_a4(hdr->frame_control))
+			mic_hdr->hlen = cpu_to_be16(28);
+		else
+			mic_hdr->hlen = cpu_to_be16(22);
+
+		memcpy(mic_hdr->addr1, hdr->addr1, ETH_ALEN);
+		memcpy(mic_hdr->addr2, hdr->addr2, ETH_ALEN);
+		memcpy(mic_hdr->addr3, hdr->addr3, ETH_ALEN);
+
+		mic_hdr->frame_control = cpu_to_le16(
+			le16_to_cpu(hdr->frame_control) & 0xc78f);
+		mic_hdr->seq_ctrl = cpu_to_le16(
+				le16_to_cpu(hdr->seq_ctrl) & 0xf);
+
+		if (ieee80211_has_a4(hdr->frame_control))
+			memcpy(mic_hdr->addr4, hdr->addr4, ETH_ALEN);
+
+
+		memcpy(key_buffer, tx_key->key, WLAN_KEY_LEN_CCMP);
+
+		break;
+	default:
+		break;
+	}
+
+}
+
+int vnt_tx_packet(struct vnt_private *priv, struct sk_buff *skb)
+{
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct ieee80211_tx_rate *tx_rate = &info->control.rates[0];
+	struct ieee80211_rate *rate;
+	struct ieee80211_key_conf *tx_key;
+	struct ieee80211_hdr *hdr;
+	struct vnt_mic_hdr *mic_hdr = NULL;
+	struct vnt_tx_buffer *tx_buffer;
+	struct vnt_tx_fifo_head *tx_buffer_head;
+	struct vnt_usb_send_context *tx_context;
+	unsigned long flags;
+	u32 frame_size = 0;
+	u16 tx_bytes, tx_header_size, tx_body_size, current_rate, duration_id;
+	u8 pkt_type, fb_option = AUTO_FB_NONE;
+	bool need_rts = false, need_ack = false, is_pspoll = false;
+	bool need_mic = false;
+
+	hdr = (struct ieee80211_hdr *)(skb->data);
+
+	rate = ieee80211_get_tx_rate(priv->hw, info);
+
+	current_rate = rate->hw_value;
+	if (priv->wCurrentRate != current_rate) {
+		priv->wCurrentRate = current_rate;
+		bScheduleCommand(priv, WLAN_CMD_SETPOWER, NULL);
+	}
+
+	if (current_rate > RATE_11M)
+		pkt_type = priv->byPacketType;
+	else
+		pkt_type = PK_TYPE_11B;
+
+	spin_lock_irqsave(&priv->lock, flags);
+
+	tx_context = s_vGetFreeContext(priv);
+	if (!tx_context) {
+		dev_dbg(&priv->usb->dev, "%s No free context\n", __func__);
+		spin_unlock_irqrestore(&priv->lock, flags);
+		return -ENOMEM;
+	}
+
+	tx_context->skb = skb;
+
+	spin_unlock_irqrestore(&priv->lock, flags);
+
+	tx_buffer = (struct vnt_tx_buffer *)tx_context->data;
+	tx_buffer_head = &tx_buffer->fifo_head;
+	tx_body_size = skb->len;
+
+	frame_size = tx_body_size + 4;
+
+	/* Set time stamp */
+	tx_buffer_head->time_stamp = cpu_to_le16(DEFAULT_MGN_LIFETIME_RES_64us);
+
+	/*Set fifo controls */
+	if (pkt_type == PK_TYPE_11A)
+		tx_buffer_head->wFIFOCtl = 0;
+	else if (pkt_type == PK_TYPE_11B)
+		tx_buffer_head->wFIFOCtl = FIFOCTL_11B;
+	else if (pkt_type == PK_TYPE_11GB)
+		tx_buffer_head->wFIFOCtl = FIFOCTL_11GB;
+	else if (pkt_type == PK_TYPE_11GA)
+		tx_buffer_head->wFIFOCtl = FIFOCTL_11GA;
+
+	if (!ieee80211_is_data(hdr->frame_control)) {
+		tx_buffer_head->wFIFOCtl |= (FIFOCTL_GENINT |
+			FIFOCTL_ISDMA0);
+		tx_buffer_head->wFIFOCtl |= FIFOCTL_TMOEN;
+
+		tx_buffer_head->time_stamp =
+			cpu_to_le16(DEFAULT_MGN_LIFETIME_RES_64us);
+	} else {
+		tx_buffer_head->time_stamp =
+			cpu_to_le16(DEFAULT_MSDU_LIFETIME_RES_64us);
+	}
+
+	if (!(info->flags & IEEE80211_TX_CTL_NO_ACK)) {
+		tx_buffer_head->wFIFOCtl |= FIFOCTL_NEEDACK;
+		need_ack = true;
+	}
+
+	if (ieee80211_has_retry(hdr->frame_control))
+		tx_buffer_head->wFIFOCtl |= FIFOCTL_LRETRY;
+
+	if (tx_rate->flags & IEEE80211_TX_RC_USE_SHORT_PREAMBLE)
+		priv->byPreambleType = PREAMBLE_SHORT;
+	else
+		priv->byPreambleType = PREAMBLE_LONG;
+
+	if (tx_rate->flags & IEEE80211_TX_RC_USE_RTS_CTS) {
+		need_rts = true;
+		tx_buffer_head->wFIFOCtl |= FIFOCTL_RTS;
+	}
+
+	if (ieee80211_has_a4(hdr->frame_control))
+		tx_buffer_head->wFIFOCtl |= FIFOCTL_LHEAD;
+
+	if (info->flags & IEEE80211_TX_CTL_NO_PS_BUFFER)
+		is_pspoll = true;
+
+	tx_buffer_head->wFragCtl =
+			cpu_to_le16(ieee80211_get_hdrlen_from_skb(skb)) << 10;
+
+	if (info->control.hw_key) {
+		tx_key = info->control.hw_key;
+		switch (info->control.hw_key->cipher) {
+		case WLAN_CIPHER_SUITE_WEP40:
+		case WLAN_CIPHER_SUITE_WEP104:
+			tx_buffer_head->wFragCtl |= FRAGCTL_LEGACY;
+			break;
+		case WLAN_CIPHER_SUITE_TKIP:
+			tx_buffer_head->wFragCtl |= FRAGCTL_TKIP;
+			break;
+		case WLAN_CIPHER_SUITE_CCMP:
+			tx_buffer_head->wFragCtl |= FRAGCTL_AES;
+			need_mic = true;
+		default:
+			break;
+		}
+		frame_size += tx_key->icv_len;
+	}
+
+	/* legacy rates TODO use ieee80211_tx_rate */
+	if (current_rate >= RATE_18M && ieee80211_is_data(hdr->frame_control)) {
+		if (priv->byAutoFBCtrl == AUTO_FB_0) {
+			tx_buffer_head->wFIFOCtl |= FIFOCTL_AUTO_FB_0;
+
+			priv->tx_rate_fb0 =
+				wFB_Opt0[FB_RATE0][current_rate - RATE_18M];
+			priv->tx_rate_fb1 =
+				wFB_Opt0[FB_RATE1][current_rate - RATE_18M];
+
+			fb_option = AUTO_FB_0;
+		} else if (priv->byAutoFBCtrl == AUTO_FB_1) {
+			tx_buffer_head->wFIFOCtl |= FIFOCTL_AUTO_FB_1;
+
+			priv->tx_rate_fb0 =
+				wFB_Opt1[FB_RATE0][current_rate - RATE_18M];
+			priv->tx_rate_fb1 =
+				wFB_Opt1[FB_RATE1][current_rate - RATE_18M];
+
+			fb_option = AUTO_FB_1;
+		}
+	}
+
+	duration_id = s_vGenerateTxParameter(tx_context, pkt_type, current_rate,
+				tx_buffer, &mic_hdr, need_mic, frame_size,
+						need_ack, NULL, need_rts);
+
+	tx_header_size = tx_context->tx_hdr_size;
+	if (!tx_header_size) {
+		tx_context->in_use = false;
+		return -ENOMEM;
+	}
+
+	tx_buffer_head->wFragCtl |= (u16)FRAGCTL_NONFRAG;
+
+	tx_bytes = tx_header_size + tx_body_size;
+
+	memcpy(tx_context->hdr, skb->data, tx_body_size);
+
+	hdr->duration_id = cpu_to_le16(duration_id);
+
+	if (info->control.hw_key) {
+		tx_key = info->control.hw_key;
+		if (tx_key->keylen > 0)
+			vnt_fill_txkey(tx_context, tx_buffer_head->tx_key,
+				tx_key, skb, tx_body_size, mic_hdr);
+	}
+
+	priv->wSeqCounter = (le16_to_cpu(hdr->seq_ctrl) &
+						IEEE80211_SCTL_SEQ) >> 4;
+
+	tx_buffer->tx_byte_count = cpu_to_le16(tx_bytes);
+	tx_buffer->byPKTNO = (u8)(((current_rate << 4) & 0xf0) |
+		(priv->wSeqCounter & 0xf));
+	tx_buffer->byType = 0x00;
+
+	tx_bytes += 4;
+
+	tx_context->type = CONTEXT_DATA_PACKET;
+	tx_context->buf_len = tx_bytes;
+
+	spin_lock_irqsave(&priv->lock, flags);
+
+	if (PIPEnsSendBulkOut(priv, tx_context) != STATUS_PENDING) {
+		spin_unlock_irqrestore(&priv->lock, flags);
+		return -EIO;
+	}
+
+	spin_unlock_irqrestore(&priv->lock, flags);
+
+	return 0;
+}
+
+static int vnt_beacon_xmit(struct vnt_private *priv,
+	struct sk_buff *skb)
+{
+	struct vnt_beacon_buffer *beacon_buffer;
+	struct vnt_tx_short_buf_head *short_head;
+	struct ieee80211_tx_info *info;
+	struct vnt_usb_send_context *context;
+	struct ieee80211_mgmt *mgmt_hdr;
+	unsigned long flags;
+	u32 frame_size = skb->len + 4;
+	u16 current_rate, count;
+
+	spin_lock_irqsave(&priv->lock, flags);
+
+	context = s_vGetFreeContext(priv);
+	if (!context) {
+		dev_dbg(&priv->usb->dev, "%s No free context!\n", __func__);
+		spin_unlock_irqrestore(&priv->lock, flags);
+		return -ENOMEM;
+	}
+
+	context->skb = skb;
+
+	spin_unlock_irqrestore(&priv->lock, flags);
+
+	beacon_buffer = (struct vnt_beacon_buffer *)&context->data[0];
+	short_head = &beacon_buffer->short_head;
+
+	if (priv->byBBType == BB_TYPE_11A) {
+		current_rate = RATE_6M;
+
+		/* Get SignalField,ServiceField,Length */
+		vnt_get_phy_field(priv, frame_size, current_rate,
+			PK_TYPE_11A, &short_head->ab);
+
+		/* Get Duration and TimeStampOff */
+		short_head->duration = s_uGetDataDuration(priv,
+							PK_TYPE_11A, false);
+		short_head->time_stamp_off =
+				vnt_time_stamp_off(priv, current_rate);
+	} else {
+		current_rate = RATE_1M;
+		short_head->fifo_ctl |= FIFOCTL_11B;
+
+		/* Get SignalField,ServiceField,Length */
+		vnt_get_phy_field(priv, frame_size, current_rate,
+					PK_TYPE_11B, &short_head->ab);
+
+		/* Get Duration and TimeStampOff */
+		short_head->duration = s_uGetDataDuration(priv,
+						PK_TYPE_11B, false);
+		short_head->time_stamp_off =
+			vnt_time_stamp_off(priv, current_rate);
+	}
+
+	/* Generate Beacon Header */
+	mgmt_hdr = &beacon_buffer->mgmt_hdr;
+	memcpy(mgmt_hdr, skb->data, skb->len);
+
+	/* time stamp always 0 */
+	mgmt_hdr->u.beacon.timestamp = 0;
+
+	info = IEEE80211_SKB_CB(skb);
+	if (info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ) {
+		struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)mgmt_hdr;
+		hdr->duration_id = 0;
+		hdr->seq_ctrl = cpu_to_le16(priv->wSeqCounter << 4);
+	}
+
+	priv->wSeqCounter++;
+	if (priv->wSeqCounter > 0x0fff)
+		priv->wSeqCounter = 0;
+
+	count = sizeof(struct vnt_tx_short_buf_head) + skb->len;
+
+	beacon_buffer->tx_byte_count = cpu_to_le16(count);
+	beacon_buffer->byPKTNO = (u8)(((current_rate << 4) & 0xf0) |
+				((priv->wSeqCounter - 1) & 0x000f));
+	beacon_buffer->byType = 0x01;
+
+	context->type = CONTEXT_BEACON_PACKET;
+	context->buf_len = count + 4; /* USB header */
+
+	spin_lock_irqsave(&priv->lock, flags);
+
+	if (PIPEnsSendBulkOut(priv, context) != STATUS_PENDING)
+		ieee80211_free_txskb(priv->hw, context->skb);
+
+	spin_unlock_irqrestore(&priv->lock, flags);
+
+	return 0;
+}
+
+int vnt_beacon_make(struct vnt_private *priv, struct ieee80211_vif *vif)
+{
+	struct sk_buff *beacon;
+
+	beacon = ieee80211_beacon_get(priv->hw, vif);
+	if (!beacon)
+		return -ENOMEM;
+
+	if (vnt_beacon_xmit(priv, beacon)) {
+		ieee80211_free_txskb(priv->hw, beacon);
+		return -ENODEV;
+	}
+
+	return 0;
+}
+
+int vnt_beacon_enable(struct vnt_private *priv, struct ieee80211_vif *vif,
+	struct ieee80211_bss_conf *conf)
+{
+	int ret;
+
+	vnt_mac_reg_bits_off(priv, MAC_REG_TCR, TCR_AUTOBCNTX);
+
+	vnt_mac_reg_bits_off(priv, MAC_REG_TFTCTL, TFTCTL_TSFCNTREN);
+
+	vnt_mac_set_beacon_interval(priv, conf->beacon_int);
+
+	vnt_clear_current_tsf(priv);
+
+	vnt_mac_reg_bits_on(priv, MAC_REG_TFTCTL, TFTCTL_TSFCNTREN);
+
+	vnt_reset_next_tbtt(priv, conf->beacon_int);
+
+	ret = vnt_beacon_make(priv, vif);
+
+	return ret;
+}
diff --git a/drivers/staging/vt6656/rxtx.h b/drivers/staging/vt6656/rxtx.h
index 95a4e2c..65f7e26 100644
--- a/drivers/staging/vt6656/rxtx.h
+++ b/drivers/staging/vt6656/rxtx.h
@@ -247,7 +247,7 @@ struct vnt_beacon_buffer {
 	u8 byPKTNO;
 	__le16 tx_byte_count;
 	struct vnt_tx_short_buf_head short_head;
-	struct ieee80211_hdr hdr;
+	struct ieee80211_mgmt mgmt_hdr;
 } __packed;
 
 void vDMA0_tx_80211(struct vnt_private *, struct sk_buff *skb);
@@ -255,4 +255,9 @@ int nsDMA_tx_packet(struct vnt_private *, struct sk_buff *skb);
 CMD_STATUS csMgmt_xmit(struct vnt_private *, struct vnt_tx_mgmt *);
 CMD_STATUS csBeacon_xmit(struct vnt_private *, struct vnt_tx_mgmt *);
 
+int vnt_tx_packet(struct vnt_private *, struct sk_buff *);
+int vnt_beacon_make(struct vnt_private *, struct ieee80211_vif *);
+int vnt_beacon_enable(struct vnt_private *, struct ieee80211_vif *,
+	struct ieee80211_bss_conf *);
+
 #endif /* __RXTX_H__ */
diff --git a/drivers/staging/vt6656/usbpipe.c b/drivers/staging/vt6656/usbpipe.c
index e30150e..fd8776c 100644
--- a/drivers/staging/vt6656/usbpipe.c
+++ b/drivers/staging/vt6656/usbpipe.c
@@ -398,7 +398,7 @@ static void s_nsBulkOutIoCompleteWrite(struct urb *urb)
 {
 	struct vnt_usb_send_context *context = urb->context;
 	struct vnt_private *priv = context->priv;
-	u8 context_type = context->type;
+	struct ieee80211_tx_info *info;
 
 	switch (urb->status) {
 	case 0:
@@ -415,24 +415,18 @@ static void s_nsBulkOutIoCompleteWrite(struct urb *urb)
 		break;
 	}
 
-	if (!netif_device_present(priv->dev))
-		return;
-
-	if (CONTEXT_DATA_PACKET == context_type) {
-		if (context->skb != NULL) {
-			dev_kfree_skb_irq(context->skb);
-			context->skb = NULL;
-			dev_dbg(&priv->usb->dev,
-					"tx  %d bytes\n", context->buf_len);
-		}
-
-		priv->dev->trans_start = jiffies;
+	if (context->skb) {
+		info = IEEE80211_SKB_CB(context->skb);
+		ieee80211_tx_info_clear_status(info);
+		info->status.rates[0].idx = priv->wCurrentRate;
+		info->status.rates[0].count = 0;
+		if (!urb->status)
+			info->flags |= IEEE80211_TX_STAT_ACK;
+		ieee80211_tx_status_irqsafe(priv->hw, context->skb);
 	}
 
-	if (priv->bLinkPass == true) {
-		if (netif_queue_stopped(priv->dev))
-			netif_wake_queue(priv->dev);
-	}
+	if (context->type == CONTEXT_DATA_PACKET)
+		ieee80211_wake_queues(priv->hw);
 
 	context->in_use = false;
 
-- 
1.9.1

