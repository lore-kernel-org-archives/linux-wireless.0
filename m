Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:33988 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751242AbdH3Jnp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Aug 2017 05:43:45 -0400
Received: by mail-pf0-f194.google.com with SMTP id p69so4008709pfk.1
        for <linux-wireless@vger.kernel.org>; Wed, 30 Aug 2017 02:43:45 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Subject: [PATCH 5/8] rsi: tx and rx path enhancements for p2p mode
Date: Wed, 30 Aug 2017 15:08:25 +0530
Message-Id: <1504085908-2163-6-git-send-email-amitkarwar@gmail.com> (sfid-20170830_114412_659624_9383BEF1)
In-Reply-To: <1504085908-2163-1-git-send-email-amitkarwar@gmail.com>
References: <1504085908-2163-1-git-send-email-amitkarwar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>

Data descriptor is updated to include vap_id. TX command frame
key config also updated to include vap_id.

Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_91x_core.c     |  9 +++++++--
 drivers/net/wireless/rsi/rsi_91x_hal.c      | 26 ++++++++++++++++++--------
 drivers/net/wireless/rsi/rsi_91x_mac80211.c | 23 +++++++++++++++++++----
 drivers/net/wireless/rsi/rsi_91x_mgmt.c     |  4 ++--
 drivers/net/wireless/rsi/rsi_mgmt.h         |  3 ++-
 5 files changed, 48 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_core.c b/drivers/net/wireless/rsi/rsi_91x_core.c
index 432d6eb..bc18a19 100644
--- a/drivers/net/wireless/rsi/rsi_91x_core.c
+++ b/drivers/net/wireless/rsi/rsi_91x_core.c
@@ -95,6 +95,8 @@ static u32 rsi_get_num_pkts_dequeue(struct rsi_common *common, u8 q_num)
 	s16 txop = common->tx_qinfo[q_num].txop * 32;
 	__le16 r_txop;
 	struct ieee80211_rate rate;
+	struct ieee80211_hdr *wh;
+	struct ieee80211_vif *vif;
 
 	rate.bitrate = RSI_RATE_MCS0 * 5 * 10; /* Convert to Kbps */
 	if (q_num == VI_Q)
@@ -106,8 +108,10 @@ static u32 rsi_get_num_pkts_dequeue(struct rsi_common *common, u8 q_num)
 		return 0;
 
 	do {
+		wh = (struct ieee80211_hdr *)skb->data;
+		vif = rsi_get_vif(adapter, wh->addr2);
 		r_txop = ieee80211_generic_frame_duration(adapter->hw,
-							  adapter->vifs[0],
+							  vif,
 							  common->band,
 							  skb->len, &rate);
 		txop -= le16_to_cpu(r_txop);
@@ -403,7 +407,8 @@ void rsi_core_xmit(struct rsi_common *common, struct sk_buff *skb)
 		q_num = skb->priority;
 		tx_params->tid = tid;
 
-		if ((vif->type == NL80211_IFTYPE_AP) &&
+		if (((vif->type == NL80211_IFTYPE_AP) ||
+		     (vif->type == NL80211_IFTYPE_P2P_GO)) &&
 		    (!is_broadcast_ether_addr(wh->addr1)) &&
 		    (!is_multicast_ether_addr(wh->addr1))) {
 			rsta = rsi_find_sta(common, wh->addr1);
diff --git a/drivers/net/wireless/rsi/rsi_91x_hal.c b/drivers/net/wireless/rsi/rsi_91x_hal.c
index d0b119e..7e8e5d4 100644
--- a/drivers/net/wireless/rsi/rsi_91x_hal.c
+++ b/drivers/net/wireless/rsi/rsi_91x_hal.c
@@ -157,7 +157,8 @@ static int rsi_prepare_data_desc(struct rsi_common *common, struct sk_buff *skb)
 	u16 seq_num;
 
 	info = IEEE80211_SKB_CB(skb);
-	bss = &info->control.vif->bss_conf;
+	vif = info->control.vif;
+	bss = &vif->bss_conf;
 	tx_params = (struct skb_info *)info->driver_data;
 
 	header_size = FRAME_DESC_SZ + sizeof(struct xtended_desc);
@@ -181,7 +182,6 @@ static int rsi_prepare_data_desc(struct rsi_common *common, struct sk_buff *skb)
 	xtend_desc = (struct xtended_desc *)&skb->data[FRAME_DESC_SZ];
 	wh = (struct ieee80211_hdr *)&skb->data[header_size];
 	seq_num = IEEE80211_SEQ_TO_SN(le16_to_cpu(wh->seq_ctrl));
-	vif = adapter->vifs[0];
 
 	data_desc->xtend_desc_size = header_size - FRAME_DESC_SZ;
 
@@ -190,7 +190,8 @@ static int rsi_prepare_data_desc(struct rsi_common *common, struct sk_buff *skb)
 		data_desc->mac_flags |= cpu_to_le16(RSI_QOS_ENABLE);
 	}
 
-	if ((vif->type == NL80211_IFTYPE_STATION) &&
+	if (((vif->type == NL80211_IFTYPE_STATION) ||
+	     (vif->type == NL80211_IFTYPE_P2P_CLIENT)) &&
 	    (adapter->ps_state == PS_ENABLED))
 		wh->frame_control |= cpu_to_le16(RSI_SET_PS_ENABLE);
 
@@ -246,17 +247,23 @@ static int rsi_prepare_data_desc(struct rsi_common *common, struct sk_buff *skb)
 		data_desc->frame_info |= cpu_to_le16(RSI_BROADCAST_PKT);
 		data_desc->sta_id = vap_id;
 
-		if (vif->type == NL80211_IFTYPE_AP) {
+		if ((vif->type == NL80211_IFTYPE_AP) ||
+		    (vif->type == NL80211_IFTYPE_P2P_GO)) {
 			if (common->band == NL80211_BAND_5GHZ)
 				data_desc->rate_info = cpu_to_le16(RSI_RATE_6);
 			else
 				data_desc->rate_info = cpu_to_le16(RSI_RATE_1);
 		}
 	}
-	if ((vif->type == NL80211_IFTYPE_AP) &&
+	if (((vif->type == NL80211_IFTYPE_AP) ||
+	     (vif->type == NL80211_IFTYPE_P2P_GO)) &&
 	    (ieee80211_has_moredata(wh->frame_control)))
 		data_desc->frame_info |= cpu_to_le16(MORE_DATA_PRESENT);
 
+	data_desc->rate_info |=
+		cpu_to_le16((tx_params->vap_id << RSI_DESC_VAP_ID_OFST) &
+			    RSI_DESC_VAP_ID_MASK);
+
 	return 0;
 }
 
@@ -264,7 +271,7 @@ static int rsi_prepare_data_desc(struct rsi_common *common, struct sk_buff *skb)
 int rsi_send_data_pkt(struct rsi_common *common, struct sk_buff *skb)
 {
 	struct rsi_hw *adapter = common->priv;
-	struct ieee80211_vif *vif = adapter->vifs[0];
+	struct ieee80211_vif *vif;
 	struct ieee80211_tx_info *info;
 	struct ieee80211_bss_conf *bss;
 	int status = -EINVAL;
@@ -277,9 +284,12 @@ int rsi_send_data_pkt(struct rsi_common *common, struct sk_buff *skb)
 	info = IEEE80211_SKB_CB(skb);
 	if (!info->control.vif)
 		goto err;
-	bss = &info->control.vif->bss_conf;
+	vif = info->control.vif;
+	bss = &vif->bss_conf;
 
-	if ((vif->type == NL80211_IFTYPE_STATION) && (!bss->assoc))
+	if (((vif->type == NL80211_IFTYPE_STATION) ||
+	     (vif->type == NL80211_IFTYPE_P2P_CLIENT)) &&
+	    (!bss->assoc))
 		goto err;
 
 	status = rsi_prepare_data_desc(common, skb);
diff --git a/drivers/net/wireless/rsi/rsi_91x_mac80211.c b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
index ce2f911..b1550bc 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mac80211.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
@@ -879,7 +879,8 @@ static int rsi_hal_key_config(struct ieee80211_hw *hw,
 						  RSI_PAIRWISE_KEY,
 						  key->keyidx,
 						  key->cipher,
-						  sta_id);
+						  sta_id,
+						  vif);
 			if (status)
 				return status;
 		}
@@ -891,7 +892,8 @@ static int rsi_hal_key_config(struct ieee80211_hw *hw,
 				key_type,
 				key->keyidx,
 				key->cipher,
-				sta_id);
+				sta_id,
+				vif);
 }
 
 /**
@@ -1165,7 +1167,9 @@ static void rsi_fill_rx_status(struct ieee80211_hw *hw,
 			       struct rsi_common *common,
 			       struct ieee80211_rx_status *rxs)
 {
-	struct ieee80211_bss_conf *bss = &common->priv->vifs[0]->bss_conf;
+	struct rsi_hw *adapter = common->priv;
+	struct ieee80211_vif *vif;
+	struct ieee80211_bss_conf *bss = NULL;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct skb_info *rx_params = (struct skb_info *)info->driver_data;
 	struct ieee80211_hdr *hdr;
@@ -1173,6 +1177,7 @@ static void rsi_fill_rx_status(struct ieee80211_hw *hw,
 	u8 hdrlen = 0;
 	u8 channel = rx_params->channel;
 	s32 freq;
+	int i;
 
 	hdr = ((struct ieee80211_hdr *)(skb->data));
 	hdrlen = ieee80211_hdrlen(hdr->frame_control);
@@ -1201,6 +1206,15 @@ static void rsi_fill_rx_status(struct ieee80211_hw *hw,
 		rxs->flag |= RX_FLAG_IV_STRIPPED;
 	}
 
+	for (i = 0; i < RSI_MAX_VIFS; i++) {
+		vif = adapter->vifs[i];
+		if (!vif)
+			continue;
+		if (vif->type == NL80211_IFTYPE_STATION)
+			bss = &vif->bss_conf;
+	}
+	if (!bss)
+		return;
 	/* CQM only for connected AP beacons, the RSSI is a weighted avg */
 	if (bss->assoc && !(memcmp(bss->bssid, hdr->addr2, ETH_ALEN))) {
 		if (ieee80211_is_beacon(hdr->frame_control))
@@ -1363,7 +1377,8 @@ static int rsi_mac80211_sta_add(struct ieee80211_hw *hw,
 							 RSI_PAIRWISE_KEY,
 							 key->keyidx,
 							 key->cipher,
-							 sta_idx);
+							 sta_idx,
+							 vif);
 			}
 
 			common->num_stations++;
diff --git a/drivers/net/wireless/rsi/rsi_91x_mgmt.c b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
index 428369b..4e50cfd 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mgmt.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
@@ -716,9 +716,9 @@ int rsi_hal_load_key(struct rsi_common *common,
 		     u8 key_type,
 		     u8 key_id,
 		     u32 cipher,
-		     s16 sta_id)
+		     s16 sta_id,
+		     struct ieee80211_vif *vif)
 {
-	struct ieee80211_vif *vif = common->priv->vifs[0];
 	struct sk_buff *skb = NULL;
 	struct rsi_set_key *set_key;
 	u16 key_descriptor = 0;
diff --git a/drivers/net/wireless/rsi/rsi_mgmt.h b/drivers/net/wireless/rsi/rsi_mgmt.h
index a82552cf..331d64b 100644
--- a/drivers/net/wireless/rsi/rsi_mgmt.h
+++ b/drivers/net/wireless/rsi/rsi_mgmt.h
@@ -618,7 +618,8 @@ int rsi_send_aggregation_params_frame(struct rsi_common *common, u16 tid,
 				      u16 ssn, u8 buf_size, u8 event,
 				      u8 sta_id);
 int rsi_hal_load_key(struct rsi_common *common, u8 *data, u16 key_len,
-		     u8 key_type, u8 key_id, u32 cipher, s16 sta_id);
+		     u8 key_type, u8 key_id, u32 cipher, s16 sta_id,
+		     struct ieee80211_vif *vif);
 int rsi_set_channel(struct rsi_common *common,
 		    struct ieee80211_channel *channel);
 int rsi_send_vap_dynamic_update(struct rsi_common *common);
-- 
2.7.4
