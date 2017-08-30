Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:38860 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751242AbdH3Jnk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Aug 2017 05:43:40 -0400
Received: by mail-pf0-f195.google.com with SMTP id r187so3999037pfr.5
        for <linux-wireless@vger.kernel.org>; Wed, 30 Aug 2017 02:43:40 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Subject: [PATCH 4/8] rsi: handle peer connection and disconnection in p2p mode
Date: Wed, 30 Aug 2017 15:08:24 +0530
Message-Id: <1504085908-2163-5-git-send-email-amitkarwar@gmail.com> (sfid-20170830_114412_409671_824F1BF0)
In-Reply-To: <1504085908-2163-1-git-send-email-amitkarwar@gmail.com>
References: <1504085908-2163-1-git-send-email-amitkarwar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>

Parameter 'vif' is passed to inform_bss_status function to
check the type of vif and to get vap_id.

Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_91x_core.c     |  9 ++++--
 drivers/net/wireless/rsi/rsi_91x_hal.c      | 47 +++++++++++++++++------------
 drivers/net/wireless/rsi/rsi_91x_mac80211.c | 22 +++++++++-----
 drivers/net/wireless/rsi/rsi_91x_mgmt.c     | 15 +++++----
 drivers/net/wireless/rsi/rsi_hal.h          |  3 +-
 drivers/net/wireless/rsi/rsi_main.h         |  2 ++
 drivers/net/wireless/rsi/rsi_mgmt.h         |  5 ++-
 7 files changed, 64 insertions(+), 39 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_core.c b/drivers/net/wireless/rsi/rsi_91x_core.c
index d212196..432d6eb 100644
--- a/drivers/net/wireless/rsi/rsi_91x_core.c
+++ b/drivers/net/wireless/rsi/rsi_91x_core.c
@@ -361,8 +361,8 @@ void rsi_core_xmit(struct rsi_common *common, struct sk_buff *skb)
 	struct rsi_hw *adapter = common->priv;
 	struct ieee80211_tx_info *info;
 	struct skb_info *tx_params;
-	struct ieee80211_hdr *wh;
-	struct ieee80211_vif *vif = adapter->vifs[0];
+	struct ieee80211_hdr *wh = NULL;
+	struct ieee80211_vif *vif;
 	u8 q_num, tid = 0;
 	struct rsi_sta *rsta = NULL;
 
@@ -381,6 +381,11 @@ void rsi_core_xmit(struct rsi_common *common, struct sk_buff *skb)
 	wh = (struct ieee80211_hdr *)&skb->data[0];
 	tx_params->sta_id = 0;
 
+	vif = rsi_get_vif(adapter, wh->addr2);
+	if (!vif)
+		goto xmit_fail;
+	tx_params->vif = vif;
+	tx_params->vap_id = ((struct vif_priv *)vif->drv_priv)->vap_id;
 	if ((ieee80211_is_mgmt(wh->frame_control)) ||
 	    (ieee80211_is_ctl(wh->frame_control)) ||
 	    (ieee80211_is_qos_nullfunc(wh->frame_control))) {
diff --git a/drivers/net/wireless/rsi/rsi_91x_hal.c b/drivers/net/wireless/rsi/rsi_91x_hal.c
index 070dfd6..d0b119e 100644
--- a/drivers/net/wireless/rsi/rsi_91x_hal.c
+++ b/drivers/net/wireless/rsi/rsi_91x_hal.c
@@ -42,7 +42,7 @@ static int rsi_prepare_mgmt_desc(struct rsi_common *common, struct sk_buff *skb)
 	struct ieee80211_hdr *wh = NULL;
 	struct ieee80211_tx_info *info;
 	struct ieee80211_conf *conf = &adapter->hw->conf;
-	struct ieee80211_vif *vif = adapter->vifs[0];
+	struct ieee80211_vif *vif;
 	struct rsi_mgmt_desc *mgmt_desc;
 	struct skb_info *tx_params;
 	struct ieee80211_bss_conf *bss = NULL;
@@ -57,6 +57,7 @@ static int rsi_prepare_mgmt_desc(struct rsi_common *common, struct sk_buff *skb)
 
 	info = IEEE80211_SKB_CB(skb);
 	tx_params = (struct skb_info *)info->driver_data;
+	vif = tx_params->vif;
 
 	/* Update header size */
 	header_size = FRAME_DESC_SZ + sizeof(struct xtended_desc);
@@ -78,7 +79,7 @@ static int rsi_prepare_mgmt_desc(struct rsi_common *common, struct sk_buff *skb)
 
 	tx_params->internal_hdr_size = header_size;
 	memset(&skb->data[0], 0, header_size);
-	bss = &info->control.vif->bss_conf;
+	bss = &vif->bss_conf;
 	wh = (struct ieee80211_hdr *)&skb->data[header_size];
 
 	mgmt_desc = (struct rsi_mgmt_desc *)skb->data;
@@ -95,10 +96,10 @@ static int rsi_prepare_mgmt_desc(struct rsi_common *common, struct sk_buff *skb)
 
 	mgmt_desc->seq_ctrl =
 		cpu_to_le16(IEEE80211_SEQ_TO_SN(le16_to_cpu(wh->seq_ctrl)));
-	if (common->band == NL80211_BAND_2GHZ)
-		mgmt_desc->rate_info = RSI_RATE_1;
+	if ((common->band == NL80211_BAND_2GHZ) && !common->p2p_enabled)
+		mgmt_desc->rate_info = cpu_to_le16(RSI_RATE_1);
 	else
-		mgmt_desc->rate_info = RSI_RATE_6;
+		mgmt_desc->rate_info = cpu_to_le16(RSI_RATE_6);
 
 	if (conf_is_ht40(conf))
 		mgmt_desc->bbp_info = cpu_to_le16(FULL40M_ENABLE);
@@ -121,7 +122,8 @@ static int rsi_prepare_mgmt_desc(struct rsi_common *common, struct sk_buff *skb)
 		xtend_desc->retry_cnt = PROBE_RESP_RETRY_CNT;
 	}
 
-	if ((vif->type == NL80211_IFTYPE_AP) &&
+	if (((vif->type == NL80211_IFTYPE_AP) ||
+	     (vif->type == NL80211_IFTYPE_P2P_GO)) &&
 	    (ieee80211_is_action(wh->frame_control))) {
 		struct rsi_sta *rsta = rsi_find_sta(common, wh->addr1);
 
@@ -130,6 +132,10 @@ static int rsi_prepare_mgmt_desc(struct rsi_common *common, struct sk_buff *skb)
 		else
 			return -EINVAL;
 	}
+	mgmt_desc->rate_info |=
+		cpu_to_le16((tx_params->vap_id << RSI_DESC_VAP_ID_OFST) &
+			    RSI_DESC_VAP_ID_MASK);
+
 	return 0;
 }
 
@@ -306,21 +312,11 @@ int rsi_send_mgmt_pkt(struct rsi_common *common,
 	struct ieee80211_tx_info *info;
 	struct skb_info *tx_params;
 	int status = -E2BIG;
-	u8 extnd_size;
 
 	info = IEEE80211_SKB_CB(skb);
 	tx_params = (struct skb_info *)info->driver_data;
-	extnd_size = ((uintptr_t)skb->data & 0x3);
 
 	if (tx_params->flags & INTERNAL_MGMT_PKT) {
-		skb->data[1] |= BIT(7); /* Immediate Wakeup bit*/
-		if ((extnd_size) > skb_headroom(skb)) {
-			rsi_dbg(ERR_ZONE, "%s: Unable to send pkt\n", __func__);
-			dev_kfree_skb(skb);
-			return -ENOSPC;
-		}
-		skb_push(skb, extnd_size);
-		skb->data[extnd_size + 4] = extnd_size;
 		status = adapter->host_intf_ops->write_pkt(common->priv,
 							   (u8 *)skb->data,
 							   skb->len);
@@ -352,12 +348,23 @@ int rsi_prepare_beacon(struct rsi_common *common, struct sk_buff *skb)
 	struct rsi_data_desc *bcn_frm;
 	struct ieee80211_hw *hw = common->priv->hw;
 	struct ieee80211_conf *conf = &hw->conf;
+	struct ieee80211_vif *vif;
 	struct sk_buff *mac_bcn;
-	u8 vap_id = 0;
-	u16 tim_offset;
-
+	u8 vap_id = 0, i;
+	u16 tim_offset = 0;
+
+	for (i = 0; i < RSI_MAX_VIFS; i++) {
+		vif = adapter->vifs[i];
+		if (!vif)
+			continue;
+		if ((vif->type == NL80211_IFTYPE_AP) ||
+		    (vif->type == NL80211_IFTYPE_P2P_GO))
+			break;
+	}
+	if (!vif)
+		return -EINVAL;
 	mac_bcn = ieee80211_beacon_get_tim(adapter->hw,
-					   adapter->vifs[adapter->sc_nvifs - 1],
+					   vif,
 					   &tim_offset, NULL);
 	if (!mac_bcn) {
 		rsi_dbg(ERR_ZONE, "Failed to get beacon from mac80211\n");
diff --git a/drivers/net/wireless/rsi/rsi_91x_mac80211.c b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
index 6780c1c..ce2f911 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mac80211.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
@@ -718,7 +718,7 @@ static void rsi_mac80211_bss_info_changed(struct ieee80211_hw *hw,
 				      bss_conf->bssid,
 				      bss_conf->qos,
 				      bss_conf->aid,
-				      NULL, 0);
+				      NULL, 0, vif);
 		adapter->ps_info.dtim_interval_duration = bss->dtim_period;
 		adapter->ps_info.listen_interval = conf->listen_interval;
 
@@ -862,7 +862,8 @@ static int rsi_hal_key_config(struct ieee80211_hw *hw,
 	rsi_dbg(ERR_ZONE, "%s: Cipher 0x%x key_type: %d key_len: %d\n",
 		__func__, key->cipher, key_type, key->keylen);
 
-	if (vif->type == NL80211_IFTYPE_AP) {
+	if ((vif->type == NL80211_IFTYPE_AP) ||
+	    (vif->type == NL80211_IFTYPE_P2P_GO)) {
 		if (sta) {
 			rsta = rsi_find_sta(adapter->priv, sta->addr);
 			if (rsta)
@@ -1297,7 +1298,8 @@ static int rsi_mac80211_sta_add(struct ieee80211_hw *hw,
 
 	mutex_lock(&common->mutex);
 
-	if (vif->type == NL80211_IFTYPE_AP) {
+	if ((vif->type == NL80211_IFTYPE_AP) ||
+	    (vif->type == NL80211_IFTYPE_P2P_GO)) {
 		u8 cnt;
 		int sta_idx = -1;
 		int free_index = -1;
@@ -1348,7 +1350,7 @@ static int rsi_mac80211_sta_add(struct ieee80211_hw *hw,
 			rsi_dbg(INFO_ZONE, "Indicate bss status to device\n");
 			rsi_inform_bss_status(common, RSI_OPMODE_AP, 1,
 					      sta->addr, sta->wme, sta->aid,
-					      sta, sta_idx);
+					      sta, sta_idx, vif);
 
 			if (common->key) {
 				struct ieee80211_key_conf *key = common->key;
@@ -1368,7 +1370,8 @@ static int rsi_mac80211_sta_add(struct ieee80211_hw *hw,
 		}
 	}
 
-	if (vif->type == NL80211_IFTYPE_STATION) {
+	if ((vif->type == NL80211_IFTYPE_STATION) ||
+	    (vif->type == NL80211_IFTYPE_P2P_CLIENT)) {
 		rsi_set_min_rate(hw, sta, common);
 		if (sta->ht_cap.ht_supported) {
 			common->vif_info[0].is_ht = true;
@@ -1409,7 +1412,8 @@ static int rsi_mac80211_sta_remove(struct ieee80211_hw *hw,
 
 	mutex_lock(&common->mutex);
 
-	if (vif->type == NL80211_IFTYPE_AP) {
+	if ((vif->type == NL80211_IFTYPE_AP) ||
+	    (vif->type == NL80211_IFTYPE_P2P_GO)) {
 		u8 sta_idx, cnt;
 
 		/* Send peer notify to device */
@@ -1422,7 +1426,8 @@ static int rsi_mac80211_sta_remove(struct ieee80211_hw *hw,
 			if (!memcmp(rsta->sta->addr, sta->addr, ETH_ALEN)) {
 				rsi_inform_bss_status(common, RSI_OPMODE_AP, 0,
 						      sta->addr, sta->wme,
-						      sta->aid, sta, sta_idx);
+						      sta->aid, sta, sta_idx,
+						      vif);
 				rsta->sta = NULL;
 				rsta->sta_id = -1;
 				for (cnt = 0; cnt < IEEE80211_NUM_TIDS; cnt++)
@@ -1436,7 +1441,8 @@ static int rsi_mac80211_sta_remove(struct ieee80211_hw *hw,
 			rsi_dbg(ERR_ZONE, "%s: No station found\n", __func__);
 	}
 
-	if (vif->type == NL80211_IFTYPE_STATION) {
+	if ((vif->type == NL80211_IFTYPE_STATION) ||
+	    (vif->type == NL80211_IFTYPE_P2P_CLIENT)) {
 		/* Resetting all the fields to default values */
 		memcpy((u8 *)bss->bssid, (u8 *)sta->addr, ETH_ALEN);
 		bss->qos = sta->wme;
diff --git a/drivers/net/wireless/rsi/rsi_91x_mgmt.c b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
index aaf5f32..428369b 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mgmt.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
@@ -460,12 +460,12 @@ static int rsi_hal_send_sta_notify_frame(struct rsi_common *common,
 					 const unsigned char *bssid,
 					 u8 qos_enable,
 					 u16 aid,
-					 u16 sta_id)
+					 u16 sta_id,
+					 struct ieee80211_vif *vif)
 {
-	struct ieee80211_vif *vif = common->priv->vifs[0];
 	struct sk_buff *skb = NULL;
 	struct rsi_peer_notify *peer_notify;
-	u16 vap_id = 0;
+	u16 vap_id = ((struct vif_priv *)vif->drv_priv)->vap_id;
 	int status;
 	u16 frame_len = sizeof(struct rsi_peer_notify);
 
@@ -1318,7 +1318,8 @@ void rsi_inform_bss_status(struct rsi_common *common,
 			   u8 qos_enable,
 			   u16 aid,
 			   struct ieee80211_sta *sta,
-			   u16 sta_id)
+			   u16 sta_id,
+			   struct ieee80211_vif *vif)
 {
 	if (status) {
 		if (opmode == RSI_OPMODE_STA)
@@ -1328,7 +1329,8 @@ void rsi_inform_bss_status(struct rsi_common *common,
 					      STA_CONNECTED,
 					      addr,
 					      qos_enable,
-					      aid, sta_id);
+					      aid, sta_id,
+					      vif);
 		if (common->min_rate == 0xffff)
 			rsi_send_auto_rate_request(common, sta, sta_id);
 		if (opmode == RSI_OPMODE_STA) {
@@ -1343,7 +1345,8 @@ void rsi_inform_bss_status(struct rsi_common *common,
 					      STA_DISCONNECTED,
 					      addr,
 					      qos_enable,
-					      aid, sta_id);
+					      aid, sta_id,
+					      vif);
 		if (opmode == RSI_OPMODE_STA)
 			rsi_send_block_unblock_frame(common, true);
 	}
diff --git a/drivers/net/wireless/rsi/rsi_hal.h b/drivers/net/wireless/rsi/rsi_hal.h
index 7c14505..ad0d653 100644
--- a/drivers/net/wireless/rsi/rsi_hal.h
+++ b/drivers/net/wireless/rsi/rsi_hal.h
@@ -121,8 +121,7 @@ struct rsi_mgmt_desc {
 	u8 xtend_desc_size;
 	u8 header_len;
 	__le16 frame_info;
-	u8 rate_info;
-	u8 reserved1;
+	__le16 rate_info;
 	__le16 bbp_info;
 	__le16 seq_ctrl;
 	u8 reserved2;
diff --git a/drivers/net/wireless/rsi/rsi_main.h b/drivers/net/wireless/rsi/rsi_main.h
index fd07b37..34089ab 100644
--- a/drivers/net/wireless/rsi/rsi_main.h
+++ b/drivers/net/wireless/rsi/rsi_main.h
@@ -124,6 +124,8 @@ struct skb_info {
 	s8 tid;
 	s8 sta_id;
 	u8 internal_hdr_size;
+	struct ieee80211_vif *vif;
+	u8 vap_id;
 };
 
 enum edca_queue {
diff --git a/drivers/net/wireless/rsi/rsi_mgmt.h b/drivers/net/wireless/rsi/rsi_mgmt.h
index 08e3b43..a82552cf 100644
--- a/drivers/net/wireless/rsi/rsi_mgmt.h
+++ b/drivers/net/wireless/rsi/rsi_mgmt.h
@@ -189,6 +189,8 @@
 	 IEEE80211_WMM_IE_STA_QOSINFO_AC_BE | \
 	 IEEE80211_WMM_IE_STA_QOSINFO_AC_BK)
 
+#define RSI_DESC_VAP_ID_MASK		0xC000
+#define RSI_DESC_VAP_ID_OFST		14
 #define RSI_DATA_DESC_MAC_BBP_INFO	BIT(0)
 #define RSI_DATA_DESC_NO_ACK_IND	BIT(9)
 #define RSI_DATA_DESC_QOS_EN		BIT(12)
@@ -623,7 +625,8 @@ int rsi_send_vap_dynamic_update(struct rsi_common *common);
 int rsi_send_block_unblock_frame(struct rsi_common *common, bool event);
 void rsi_inform_bss_status(struct rsi_common *common, enum opmode opmode,
 			   u8 status, const u8 *addr, u8 qos_enable, u16 aid,
-			   struct ieee80211_sta *sta, u16 sta_id);
+			   struct ieee80211_sta *sta, u16 sta_id,
+			   struct ieee80211_vif *vif);
 void rsi_indicate_pkt_to_os(struct rsi_common *common, struct sk_buff *skb);
 int rsi_mac80211_attach(struct rsi_common *common);
 void rsi_indicate_tx_status(struct rsi_hw *common, struct sk_buff *skb,
-- 
2.7.4
