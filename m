Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:44037 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754084AbaJ2Rox (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2014 13:44:53 -0400
Received: by mail-wg0-f49.google.com with SMTP id x13so2442312wgg.22
        for <linux-wireless@vger.kernel.org>; Wed, 29 Oct 2014 10:44:51 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, forest@alittletooquiet.net,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH v2 03/34] staging: vt6655: mac8021 conversion: add new tx functions
Date: Wed, 29 Oct 2014 17:43:38 +0000
Message-Id: <1414604649-9105-4-git-send-email-tvboxspy@gmail.com> (sfid-20141029_184458_107736_3CF7CF21)
In-Reply-To: <1414604649-9105-1-git-send-email-tvboxspy@gmail.com>
References: <1414604649-9105-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

vnt_fill_txkey a mac80211 repacement for s_vFillTxKey

vnt_generate_fifo_header mac80211 replacement for vGenerateFIFOHeader

vnt_beacon_make for making and despatching beacon.

vnt_beacon_enable to enabling beacon

struct vnt_tx_fifo_head is also added to replace typedef
struct tagSTxBufHead that will be removed later.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/desc.h |   1 +
 drivers/staging/vt6655/rxtx.c | 311 ++++++++++++++++++++++++++++++++++++++++++
 drivers/staging/vt6655/rxtx.h |  14 ++
 3 files changed, 326 insertions(+)

diff --git a/drivers/staging/vt6655/desc.h b/drivers/staging/vt6655/desc.h
index 8f510c6..9068c3e 100644
--- a/drivers/staging/vt6655/desc.h
+++ b/drivers/staging/vt6655/desc.h
@@ -287,6 +287,7 @@ typedef struct tagTDES1 {
 STDES1;
 
 typedef struct tagDEVICE_TD_INFO {
+	void *mic_hdr;
 	struct sk_buff *skb;
 	unsigned char *buf;
 	dma_addr_t          skb_dma;
diff --git a/drivers/staging/vt6655/rxtx.c b/drivers/staging/vt6655/rxtx.c
index da7c0a8..99ce5a3 100644
--- a/drivers/staging/vt6655/rxtx.c
+++ b/drivers/staging/vt6655/rxtx.c
@@ -2994,3 +2994,314 @@ void vDMA0_tx_80211(struct vnt_private *pDevice, struct sk_buff *skb,
 	// Poll Transmit the adapter
 	MACvTransmit0(pDevice->PortOffset);
 }
+
+static void vnt_fill_txkey(struct ieee80211_hdr *hdr, u8 *key_buffer,
+			   struct ieee80211_key_conf *tx_key,
+			   struct sk_buff *skb,	u16 payload_len,
+			   struct vnt_mic_hdr *mic_hdr)
+{
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
+			       tx_key->key, WLAN_KEY_LEN_WEP40);
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
+		ether_addr_copy(mic_hdr->mic_addr2, hdr->addr2);
+
+		ieee80211_get_key_tx_seq(tx_key, &seq);
+
+		memcpy(mic_hdr->ccmp_pn, seq.ccmp.pn, IEEE80211_CCMP_PN_LEN);
+
+		if (ieee80211_has_a4(hdr->frame_control))
+			mic_hdr->hlen = cpu_to_be16(28);
+		else
+			mic_hdr->hlen = cpu_to_be16(22);
+
+		ether_addr_copy(mic_hdr->addr1, hdr->addr1);
+		ether_addr_copy(mic_hdr->addr2, hdr->addr2);
+		ether_addr_copy(mic_hdr->addr3, hdr->addr3);
+
+		mic_hdr->frame_control = cpu_to_le16(
+			le16_to_cpu(hdr->frame_control) & 0xc78f);
+		mic_hdr->seq_ctrl = cpu_to_le16(
+				le16_to_cpu(hdr->seq_ctrl) & 0xf);
+
+		if (ieee80211_has_a4(hdr->frame_control))
+			ether_addr_copy(mic_hdr->addr4, hdr->addr4);
+
+		memcpy(key_buffer, tx_key->key, WLAN_KEY_LEN_CCMP);
+
+		break;
+	default:
+		break;
+	}
+}
+
+int vnt_generate_fifo_header(struct vnt_private *priv, u32 dma_idx,
+			     PSTxDesc head_td, struct sk_buff *skb)
+{
+	PDEVICE_TD_INFO td_info = head_td->pTDInfo;
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct ieee80211_tx_rate *tx_rate = &info->control.rates[0];
+	struct ieee80211_rate *rate;
+	struct ieee80211_key_conf *tx_key;
+	struct ieee80211_hdr *hdr;
+	struct vnt_tx_fifo_head *tx_buffer_head =
+			(struct vnt_tx_fifo_head *)td_info->buf;
+	u32 frag;
+	u16 tx_body_size = skb->len, current_rate;
+	u8 pkt_type;
+	bool is_pspoll = false;
+
+	memset(tx_buffer_head, 0, sizeof(*tx_buffer_head));
+
+	hdr = (struct ieee80211_hdr *)(skb->data);
+
+	rate = ieee80211_get_tx_rate(priv->hw, info);
+
+	current_rate = rate->hw_value;
+	if (priv->wCurrentRate != current_rate &&
+			!(priv->hw->conf.flags & IEEE80211_CONF_OFFCHANNEL)) {
+		priv->wCurrentRate = current_rate;
+
+		RFbSetPower(priv, priv->wCurrentRate,
+			    priv->hw->conf.chandef.chan->hw_value);
+	}
+
+	if (current_rate > RATE_11M)
+		pkt_type = (u8)priv->byPacketType;
+	else
+		pkt_type = PK_TYPE_11B;
+
+	/*Set fifo controls */
+	if (pkt_type == PK_TYPE_11A)
+		tx_buffer_head->fifo_ctl = 0;
+	else if (pkt_type == PK_TYPE_11B)
+		tx_buffer_head->fifo_ctl = cpu_to_le16(FIFOCTL_11B);
+	else if (pkt_type == PK_TYPE_11GB)
+		tx_buffer_head->fifo_ctl = cpu_to_le16(FIFOCTL_11GB);
+	else if (pkt_type == PK_TYPE_11GA)
+		tx_buffer_head->fifo_ctl = cpu_to_le16(FIFOCTL_11GA);
+
+	/* generate interrupt */
+	tx_buffer_head->fifo_ctl |= cpu_to_le16(FIFOCTL_GENINT);
+
+	if (!ieee80211_is_data(hdr->frame_control)) {
+		tx_buffer_head->fifo_ctl |= cpu_to_le16(FIFOCTL_TMOEN);
+		tx_buffer_head->fifo_ctl |= cpu_to_le16(FIFOCTL_ISDMA0);
+		tx_buffer_head->time_stamp =
+			cpu_to_le16(DEFAULT_MGN_LIFETIME_RES_64us);
+	} else {
+		tx_buffer_head->time_stamp =
+			cpu_to_le16(DEFAULT_MSDU_LIFETIME_RES_64us);
+	}
+
+	if (!(info->flags & IEEE80211_TX_CTL_NO_ACK))
+		tx_buffer_head->fifo_ctl |= cpu_to_le16(FIFOCTL_NEEDACK);
+
+	if (ieee80211_has_retry(hdr->frame_control))
+		tx_buffer_head->fifo_ctl |= cpu_to_le16(FIFOCTL_LRETRY);
+
+	if (tx_rate->flags & IEEE80211_TX_RC_USE_SHORT_PREAMBLE)
+		priv->byPreambleType = PREAMBLE_SHORT;
+	else
+		priv->byPreambleType = PREAMBLE_LONG;
+
+	if (tx_rate->flags & IEEE80211_TX_RC_USE_RTS_CTS)
+		tx_buffer_head->fifo_ctl |= cpu_to_le16(FIFOCTL_RTS);
+
+	if (ieee80211_has_a4(hdr->frame_control)) {
+		tx_buffer_head->fifo_ctl |= cpu_to_le16(FIFOCTL_LHEAD);
+		priv->bLongHeader = true;
+	}
+
+	if (info->flags & IEEE80211_TX_CTL_NO_PS_BUFFER)
+		is_pspoll = true;
+
+	tx_buffer_head->frag_ctl =
+			cpu_to_le16(ieee80211_get_hdrlen_from_skb(skb) << 10);
+
+	if (info->control.hw_key) {
+		tx_key = info->control.hw_key;
+
+		switch (info->control.hw_key->cipher) {
+		case WLAN_CIPHER_SUITE_WEP40:
+		case WLAN_CIPHER_SUITE_WEP104:
+			tx_buffer_head->frag_ctl |= cpu_to_le16(FRAGCTL_LEGACY);
+			break;
+		case WLAN_CIPHER_SUITE_TKIP:
+			tx_buffer_head->frag_ctl |= cpu_to_le16(FRAGCTL_TKIP);
+			break;
+		case WLAN_CIPHER_SUITE_CCMP:
+			tx_buffer_head->frag_ctl |= cpu_to_le16(FRAGCTL_AES);
+		default:
+			break;
+		}
+	}
+
+	tx_buffer_head->current_rate = cpu_to_le16(current_rate);
+
+	/* legacy rates TODO use ieee80211_tx_rate */
+	if (current_rate >= RATE_18M && ieee80211_is_data(hdr->frame_control)) {
+		if (priv->byAutoFBCtrl == AUTO_FB_0)
+			tx_buffer_head->fifo_ctl |=
+						cpu_to_le16(FIFOCTL_AUTO_FB_0);
+		else if (priv->byAutoFBCtrl == AUTO_FB_1)
+			tx_buffer_head->fifo_ctl |=
+						cpu_to_le16(FIFOCTL_AUTO_FB_1);
+
+	}
+
+	tx_buffer_head->frag_ctl |= cpu_to_le16(FRAGCTL_NONFRAG);
+
+	s_cbFillTxBufHead(priv, pkt_type, (u8 *)tx_buffer_head, skb->len,
+			  dma_idx, head_td, NULL, (u8 *)skb->data,
+			  false, NULL, is_pspoll, &frag);
+
+	if (info->control.hw_key) {
+		tx_key = info->control.hw_key;
+		if (tx_key->keylen > 0)
+			vnt_fill_txkey(hdr, tx_buffer_head->tx_key,
+				tx_key, skb, tx_body_size, td_info->mic_hdr);
+	}
+
+	return 0;
+}
+
+static int vnt_beacon_xmit(struct vnt_private *priv,
+			   struct sk_buff *skb)
+{
+	struct vnt_tx_short_buf_head *short_head =
+		(struct vnt_tx_short_buf_head *)priv->tx_beacon_bufs;
+	struct ieee80211_mgmt *mgmt_hdr = (struct ieee80211_mgmt *)
+				(priv->tx_beacon_bufs + sizeof(*short_head));
+	struct ieee80211_tx_info *info;
+	u32 frame_size = skb->len + 4;
+	u16 current_rate;
+
+	memset(priv->tx_beacon_bufs, 0, sizeof(*short_head));
+
+	if (priv->byBBType == BB_TYPE_11A) {
+		current_rate = RATE_6M;
+
+		/* Get SignalField,ServiceField,Length */
+		vnt_get_phy_field(priv, frame_size, current_rate,
+				  PK_TYPE_11A, &short_head->ab);
+
+		/* Get Duration and TimeStampOff */
+		short_head->duration =
+			cpu_to_le16((u16)s_uGetDataDuration(priv, DATADUR_B,
+				    frame_size, PK_TYPE_11A, current_rate,
+				    false, 0, 0, 1, AUTO_FB_NONE));
+
+		short_head->time_stamp_off =
+				vnt_time_stamp_off(priv, current_rate);
+	} else {
+		current_rate = RATE_1M;
+		short_head->fifo_ctl |= cpu_to_le16(FIFOCTL_11B);
+
+		/* Get SignalField,ServiceField,Length */
+		vnt_get_phy_field(priv, frame_size, current_rate,
+				  PK_TYPE_11B, &short_head->ab);
+
+		/* Get Duration and TimeStampOff */
+		short_head->duration =
+			cpu_to_le16((u16)s_uGetDataDuration(priv, DATADUR_B,
+				    frame_size, PK_TYPE_11B, current_rate,
+				    false, 0, 0, 1, AUTO_FB_NONE));
+
+		short_head->time_stamp_off =
+			vnt_time_stamp_off(priv, current_rate);
+	}
+
+	short_head->fifo_ctl |= cpu_to_le16(FIFOCTL_GENINT);
+
+	/* Copy Beacon */
+	memcpy(mgmt_hdr, skb->data, skb->len);
+
+	/* time stamp always 0 */
+	mgmt_hdr->u.beacon.timestamp = 0;
+
+	info = IEEE80211_SKB_CB(skb);
+	if (info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ) {
+		struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)mgmt_hdr;
+
+		hdr->duration_id = 0;
+		hdr->seq_ctrl = cpu_to_le16(priv->wSeqCounter << 4);
+	}
+
+	priv->wSeqCounter++;
+	if (priv->wSeqCounter > 0x0fff)
+		priv->wSeqCounter = 0;
+
+	priv->wBCNBufLen = sizeof(*short_head) + skb->len;
+
+	MACvSetCurrBCNTxDescAddr(priv->PortOffset, priv->tx_beacon_dma);
+
+	MACvSetCurrBCNLength(priv->PortOffset, priv->wBCNBufLen);
+	/* Set auto Transmit on */
+	MACvRegBitsOn(priv->PortOffset, MAC_REG_TCR, TCR_AUTOBCNTX);
+	/* Poll Transmit the adapter */
+	MACvTransmitBCN(priv->PortOffset);
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
+		      struct ieee80211_bss_conf *conf)
+{
+	int ret;
+
+	VNSvOutPortB(priv->PortOffset + MAC_REG_TFTCTL, TFTCTL_TSFCNTRST);
+
+	VNSvOutPortB(priv->PortOffset + MAC_REG_TFTCTL, TFTCTL_TSFCNTREN);
+
+	CARDvSetFirstNextTBTT(priv->PortOffset, conf->beacon_int);
+
+	CARDbSetBeaconPeriod(priv, conf->beacon_int);
+
+	ret = vnt_beacon_make(priv, vif);
+
+	return ret;
+}
diff --git a/drivers/staging/vt6655/rxtx.h b/drivers/staging/vt6655/rxtx.h
index 8ee6288..145713d 100644
--- a/drivers/staging/vt6655/rxtx.h
+++ b/drivers/staging/vt6655/rxtx.h
@@ -173,6 +173,14 @@ struct vnt_cts_fb {
 	u16 reserved2;
 } __packed;
 
+struct vnt_tx_fifo_head {
+	u8 tx_key[WLAN_KEY_LEN_CCMP];
+	__le16 fifo_ctl;
+	__le16 time_stamp;
+	__le16 frag_ctl;
+	__le16 current_rate;
+} __packed;
+
 struct vnt_tx_short_buf_head {
 	__le16 fifo_ctl;
 	u16 time_stamp;
@@ -215,4 +223,10 @@ void vDMA0_tx_80211(struct vnt_private *, struct sk_buff *skb,
 CMD_STATUS csMgmt_xmit(struct vnt_private *, PSTxMgmtPacket pPacket);
 CMD_STATUS csBeacon_xmit(struct vnt_private *, PSTxMgmtPacket pPacket);
 
+int vnt_generate_fifo_header(struct vnt_private *, u32,
+			     PSTxDesc head_td, struct sk_buff *);
+int vnt_beacon_make(struct vnt_private *, struct ieee80211_vif *);
+int vnt_beacon_enable(struct vnt_private *, struct ieee80211_vif *,
+		      struct ieee80211_bss_conf *);
+
 #endif // __RXTX_H__
-- 
2.1.0

