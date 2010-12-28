Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:65350 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752510Ab0L1XCZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Dec 2010 18:02:25 -0500
Received: by pzk35 with SMTP id 35so714133pzk.19
        for <linux-wireless@vger.kernel.org>; Tue, 28 Dec 2010 15:02:24 -0800 (PST)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: mwl8k-devel@cozybit.com, buytenh@wantstofly.org,
	Nishant Sarmukadam <nishants@marvell.com>,
	Pradeep Nemavat <pnemavat@marvell.com>,
	Thomas Pedersen <thomas@cozybit.com>
Subject: [PATCH 2/4] mwl8k: Add encapsulation of data packet for crypto
Date: Tue, 28 Dec 2010 15:01:35 -0800
Message-Id: <1293577297-25755-3-git-send-email-thomas@cozybit.com>
In-Reply-To: <1293577297-25755-1-git-send-email-thomas@cozybit.com>
References: <1293577297-25755-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Nishant Sarmukadam <nishants@marvell.com>

Different head and tail pads will be needed for crypto depending on
the crypto mode. Add support to encapsulate the packets with
appropriate pad values. Also, fill the header in case of CCMP.

Signed-off-by: Nishant Sarmukadam <nishants@marvell.com>
Signed-off-by: Pradeep Nemavat <pnemavat@marvell.com>
Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 drivers/net/wireless/mwl8k.c |  114 ++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 109 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 771283b..508828c 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -232,6 +232,14 @@ struct mwl8k_priv {
 	struct completion firmware_loading_complete;
 };
 
+#define MAX_WEP_KEY_LEN         13
+#define NUM_WEP_KEYS            4
+
+struct mwl8k_ccmp_tx_iv {
+	__u16 tx_iv_pn_l2;
+	__u32 tx_iv_pn_u4;
+};
+
 /* Per interface specific private data */
 struct mwl8k_vif {
 	struct list_head list;
@@ -242,12 +250,23 @@ struct mwl8k_vif {
 
 	/* Non AMPDU sequence number assigned by driver.  */
 	u16 seqno;
+
+	/* Saved WEP keys */
+	struct {
+		u8 enabled;
+		u8 key[sizeof(struct ieee80211_key_conf) + MAX_WEP_KEY_LEN];
+	} wep_key_conf[NUM_WEP_KEYS];
+
+	/* CCMP Crypto counters for Group cast data */
+	struct mwl8k_ccmp_tx_iv ccmp_tx_iv;
 };
 #define MWL8K_VIF(_vif) ((struct mwl8k_vif *)&((_vif)->drv_priv))
 
 struct mwl8k_sta {
 	/* Index into station database. Returned by UPDATE_STADB.  */
 	u8 peer_id;
+	/* CCMP crypto counter for station */
+	struct mwl8k_ccmp_tx_iv ccmp_tx_iv;
 };
 #define MWL8K_STA(_sta) ((struct mwl8k_sta *)&((_sta)->drv_priv))
 
@@ -747,17 +766,97 @@ mwl8k_add_dma_header(struct sk_buff *skb, int hdr_pad, int tail_pad)
 		memset(((void *)&tr->wh) + hdrlen, 0,
 					sizeof(tr->wh) + hdr_pad - hdrlen);
 
-	if (tail_pad)
-		skb_put(skb, tail_pad);
-
 	/*
 	 * Firmware length is the length of the fully formed "802.11
 	 * payload".  That is, everything except for the 802.11 header.
 	 * This includes all crypto material including the MIC.
 	 */
-	tr->fwlen = cpu_to_le16(skb->len - sizeof(*tr));
+	tr->fwlen = cpu_to_le16(skb->len - sizeof(*tr) + tail_pad);
+}
+
+#define CCMP_EXT_IV (1<<5)
+
+static void
+fill_ccmp_header(u8 *ccmp_hdr, struct mwl8k_ccmp_tx_iv *tx_iv, u8 key_id)
+{
+	*(__le16 *)ccmp_hdr = cpu_to_le16(tx_iv->tx_iv_pn_l2);
+	ccmp_hdr[2] = 0;
+	ccmp_hdr[3] = CCMP_EXT_IV | key_id << 6;
+	*(__le32 *)&ccmp_hdr[4] = cpu_to_le32(tx_iv->tx_iv_pn_u4);
+
+	tx_iv->tx_iv_pn_l2++;
+	if (tx_iv->tx_iv_pn_l2 == 0)
+		tx_iv->tx_iv_pn_u4++;
 }
 
+static void mwl8k_encapsulate_tx_frame(struct sk_buff *skb)
+{
+	struct ieee80211_hdr *wh;
+	struct ieee80211_tx_info *tx_info;
+	struct ieee80211_key_conf *key_conf;
+	int header_pad;
+	int data_pad;
+
+	wh = (struct ieee80211_hdr *)skb->data;
+
+	tx_info = IEEE80211_SKB_CB(skb);
+
+	key_conf = NULL;
+	if (ieee80211_is_data(wh->frame_control))
+		key_conf = tx_info->control.hw_key;
+
+	/*
+	 * Make sure the packet header is in the DMA header format
+	 * (4-address without QoS), and insert the necessary crypto
+	 * padding between the header and the payload.
+	 *
+	 * We have the following header/trailer padding requirements:
+	 * - WEP: 4 header bytes (IV), 4 trailer bytes (ICV)
+	 * - TKIP: 8 header bytes (IV/EIV), 12 trailer bytes (8 MIC + 4 ICV)
+	 * - CCMP: 8 header bytes (PN/KeyId), 8 trailer bytes (MIC)
+	 */
+	header_pad = 0;
+	data_pad = 0;
+	if (key_conf != NULL) {
+		if (key_conf->alg == ALG_WEP) {
+			header_pad = 4;
+			data_pad = 4;
+		} else {
+			header_pad = 8;
+			if (key_conf->alg == ALG_TKIP)
+				data_pad = 12;
+			else /* CCMP */
+				data_pad = 8;
+		}
+	}
+
+	mwl8k_add_dma_header(skb, header_pad, data_pad);
+
+	wh = &((struct mwl8k_dma_data *)skb->data)->wh;
+
+	/*
+	 * Fill CCMP header.
+	 */
+	if ((key_conf != NULL) && key_conf->alg == ALG_CCMP) {
+		void *ccmp_hdr;
+		u8 key_id;
+		struct mwl8k_ccmp_tx_iv *tx_iv;
+
+		ccmp_hdr = skb->data + sizeof(struct mwl8k_dma_data);
+		/*
+		 * The key id is 1 for groupcast traffic and 0 for
+		 * unicast/pairwise traffic.
+		 */
+		if (is_multicast_ether_addr(wh->addr1)) {
+			key_id = 1;
+			tx_iv = &(MWL8K_VIF(tx_info->control.vif)->ccmp_tx_iv);
+		} else {
+			key_id = 0;
+			tx_iv = &(MWL8K_STA(tx_info->control.sta)->ccmp_tx_iv);
+		}
+		fill_ccmp_header(ccmp_hdr, tx_iv, key_id);
+	}
+}
 
 /*
  * Packet reception for 88w8366 AP firmware.
@@ -1451,7 +1550,7 @@ mwl8k_txq_xmit(struct ieee80211_hw *hw, int index, struct sk_buff *skb)
 	else
 		qos = 0;
 
-	mwl8k_add_dma_header(skb, 0, 0);
+	mwl8k_encapsulate_tx_frame(skb);
 	wh = &((struct mwl8k_dma_data *)skb->data)->wh;
 
 	tx_info = IEEE80211_SKB_CB(skb);
@@ -3477,6 +3576,8 @@ static int mwl8k_add_interface(struct ieee80211_hw *hw,
 	mwl8k_vif->vif = vif;
 	mwl8k_vif->macid = macid;
 	mwl8k_vif->seqno = 0;
+	mwl8k_vif->ccmp_tx_iv.tx_iv_pn_l2 = 1;
+	mwl8k_vif->ccmp_tx_iv.tx_iv_pn_u4 = 0;
 
 	/* Set the mac address.  */
 	mwl8k_cmd_set_mac_addr(hw, vif, vif->addr);
@@ -3875,6 +3976,9 @@ static int mwl8k_sta_add(struct ieee80211_hw *hw,
 	struct mwl8k_priv *priv = hw->priv;
 	int ret;
 
+	MWL8K_STA(sta)->ccmp_tx_iv.tx_iv_pn_l2 = 1;
+	MWL8K_STA(sta)->ccmp_tx_iv.tx_iv_pn_u4 = 0;
+
 	if (!priv->ap_fw) {
 		ret = mwl8k_cmd_update_stadb_add(hw, vif, sta);
 		if (ret >= 0) {
-- 
1.7.0.4

