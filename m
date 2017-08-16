Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:34981 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752274AbdHPNSI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 Aug 2017 09:18:08 -0400
Received: by mail-pg0-f65.google.com with SMTP id l64so5260335pge.2
        for <linux-wireless@vger.kernel.org>; Wed, 16 Aug 2017 06:18:08 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Subject: [v2 05/11] rsi: handle station connection in AP mode
Date: Wed, 16 Aug 2017 18:43:12 +0530
Message-Id: <1502889198-4478-6-git-send-email-amitkarwar@gmail.com> (sfid-20170816_151811_652034_9F5BB9FE)
In-Reply-To: <1502889198-4478-1-git-send-email-amitkarwar@gmail.com>
References: <1502889198-4478-1-git-send-email-amitkarwar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>

Station structures are maintained in driver with required
fields. When mac80211 callback sta_add is called, driver
iterates through list of connected stations to check available
index and assigns station id which is important for further
communication to that station. Then peer notify frame is send
to firmware to inform the firmware about new station connection.

Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_91x_mac80211.c | 78 ++++++++++++++++++++++++++---
 drivers/net/wireless/rsi/rsi_91x_mgmt.c     | 49 +++++++++++-------
 drivers/net/wireless/rsi/rsi_mgmt.h         |  9 +++-
 3 files changed, 110 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_mac80211.c b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
index 6038a2f..b1c0849 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mac80211.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
@@ -626,10 +626,12 @@ static void rsi_mac80211_bss_info_changed(struct ieee80211_hw *hw,
 			rsi_send_rx_filter_frame(common, rx_filter_word);
 		}
 		rsi_inform_bss_status(common,
+				      STA_OPMODE,
 				      bss_conf->assoc,
 				      bss_conf->bssid,
 				      bss_conf->qos,
-				      bss_conf->aid);
+				      bss_conf->aid,
+				      NULL, 0);
 		adapter->ps_info.dtim_interval_duration = bss->dtim_period;
 		adapter->ps_info.listen_interval = conf->listen_interval;
 
@@ -1157,18 +1159,80 @@ static int rsi_mac80211_sta_add(struct ieee80211_hw *hw,
 {
 	struct rsi_hw *adapter = hw->priv;
 	struct rsi_common *common = adapter->priv;
+	bool sta_exist = false;
+	struct rsi_sta *rsta;
+
+	rsi_dbg(INFO_ZONE, "Station Add: %pM\n", sta->addr);
 
 	mutex_lock(&common->mutex);
 
-	rsi_set_min_rate(hw, sta, common);
+	if (vif->type == NL80211_IFTYPE_AP) {
+		u8 cnt;
+		int sta_idx = -1;
+		int free_index = -1;
+
+		/* Check if max stations reached */
+		if (common->num_stations >= common->max_stations) {
+			rsi_dbg(ERR_ZONE, "Reject: Max Stations exists\n");
+			mutex_unlock(&common->mutex);
+			return -EOPNOTSUPP;
+		}
+		for (cnt = 0; cnt < common->max_stations; cnt++) {
+			rsta = &common->stations[cnt];
 
-	if ((sta->ht_cap.cap & IEEE80211_HT_CAP_SGI_20) ||
-	    (sta->ht_cap.cap & IEEE80211_HT_CAP_SGI_40)) {
-		common->vif_info[0].sgi = true;
+			if (!rsta->sta) {
+				if (free_index < 0)
+					free_index = cnt;
+				continue;
+			}
+			if (!memcmp(rsta->sta->addr, sta->addr, ETH_ALEN)) {
+				rsi_dbg(INFO_ZONE, "Station exists\n");
+				sta_idx = cnt;
+				sta_exist = true;
+				break;
+			}
+		}
+		if (!sta_exist) {
+			if (free_index >= 0)
+				sta_idx = free_index;
+		}
+		if (sta_idx < 0) {
+			rsi_dbg(ERR_ZONE,
+				"%s: Some problem reaching here...\n",
+				__func__);
+			return -EINVAL;
+		}
+		rsta = &common->stations[sta_idx];
+		rsta->sta = sta;
+		rsta->sta_id = sta_idx;
+		for (cnt = 0; cnt < IEEE80211_NUM_TIDS; cnt++)
+			rsta->start_tx_aggr[cnt] = false;
+		for (cnt = 0; cnt < IEEE80211_NUM_TIDS; cnt++)
+			rsta->seq_start[cnt] = 0;
+		if (!sta_exist) {
+			rsi_dbg(INFO_ZONE, "New Station\n");
+
+			/* Send peer notify to device */
+			rsi_dbg(INFO_ZONE, "Indicate bss status to device\n");
+			rsi_inform_bss_status(common, AP_OPMODE, 1, sta->addr,
+					      sta->wme, sta->aid, sta, sta_idx);
+
+			common->num_stations++;
+		}
 	}
 
-	if (sta->ht_cap.ht_supported)
-		ieee80211_start_tx_ba_session(sta, 0, 0);
+	if (vif->type == NL80211_IFTYPE_STATION) {
+		rsi_set_min_rate(hw, sta, common);
+		if (sta->ht_cap.ht_supported) {
+			common->vif_info[0].is_ht = true;
+			common->bitrate_mask[NL80211_BAND_2GHZ] =
+					sta->supp_rates[NL80211_BAND_2GHZ];
+			if ((sta->ht_cap.cap & IEEE80211_HT_CAP_SGI_20) ||
+			    (sta->ht_cap.cap & IEEE80211_HT_CAP_SGI_40))
+				common->vif_info[0].sgi = true;
+			ieee80211_start_tx_ba_session(sta, 0, 0);
+		}
+	}
 
 	mutex_unlock(&common->mutex);
 
diff --git a/drivers/net/wireless/rsi/rsi_91x_mgmt.c b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
index e47fc0d..7c0f27a 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mgmt.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
@@ -455,12 +455,14 @@ static int rsi_mgmt_pkt_to_core(struct rsi_common *common,
  * Return: status: 0 on success, corresponding negative error code on failure.
  */
 static int rsi_hal_send_sta_notify_frame(struct rsi_common *common,
-					 u8 opmode,
+					 enum opmode opmode,
 					 u8 notify_event,
 					 const unsigned char *bssid,
 					 u8 qos_enable,
-					 u16 aid)
+					 u16 aid,
+					 u16 sta_id)
 {
+	struct ieee80211_vif *vif = common->priv->vifs[0];
 	struct sk_buff *skb = NULL;
 	struct rsi_peer_notify *peer_notify;
 	u16 vap_id = 0;
@@ -480,7 +482,10 @@ static int rsi_hal_send_sta_notify_frame(struct rsi_common *common,
 	memset(skb->data, 0, frame_len);
 	peer_notify = (struct rsi_peer_notify *)skb->data;
 
-	peer_notify->command = cpu_to_le16(opmode << 1);
+	if (opmode == STA_OPMODE)
+		peer_notify->command = cpu_to_le16(PEER_TYPE_AP << 1);
+	else if (opmode == AP_OPMODE)
+		peer_notify->command = cpu_to_le16(PEER_TYPE_STA << 1);
 
 	switch (notify_event) {
 	case STA_CONNECTED:
@@ -502,13 +507,15 @@ static int rsi_hal_send_sta_notify_frame(struct rsi_common *common,
 			(frame_len - FRAME_DESC_SZ),
 			RSI_WIFI_MGMT_Q);
 	peer_notify->desc.desc_dword0.frame_type = PEER_NOTIFY;
+	peer_notify->desc.desc_dword3.qid_tid = sta_id;
 	peer_notify->desc.desc_dword3.sta_id = vap_id;
 
 	skb_put(skb, frame_len);
 
 	status = rsi_send_internal_mgmt_frame(common, skb);
 
-	if (!status && qos_enable) {
+	if ((vif->type == NL80211_IFTYPE_STATION) &&
+	    (!status && qos_enable)) {
 		rsi_set_contention_vals(common);
 		status = rsi_load_radio_caps(common);
 	}
@@ -1279,32 +1286,40 @@ static int rsi_send_auto_rate_request(struct rsi_common *common)
  * Return: None.
  */
 void rsi_inform_bss_status(struct rsi_common *common,
+			   enum opmode opmode,
 			   u8 status,
-			   const unsigned char *bssid,
+			   const u8 *addr,
 			   u8 qos_enable,
-			   u16 aid)
+			   u16 aid,
+			   struct ieee80211_sta *sta,
+			   u16 sta_id)
 {
 	if (status) {
-		common->hw_data_qs_blocked = true;
+		if (opmode == STA_OPMODE)
+			common->hw_data_qs_blocked = true;
 		rsi_hal_send_sta_notify_frame(common,
-					      RSI_IFTYPE_STATION,
+					      opmode,
 					      STA_CONNECTED,
-					      bssid,
+					      addr,
 					      qos_enable,
-					      aid);
+					      aid, sta_id);
 		if (common->min_rate == 0xffff)
 			rsi_send_auto_rate_request(common);
-		if (!rsi_send_block_unblock_frame(common, false))
-			common->hw_data_qs_blocked = false;
+		if (opmode == STA_OPMODE) {
+			if (!rsi_send_block_unblock_frame(common, false))
+				common->hw_data_qs_blocked = false;
+		}
 	} else {
-		common->hw_data_qs_blocked = true;
+		if (opmode == STA_OPMODE)
+			common->hw_data_qs_blocked = true;
 		rsi_hal_send_sta_notify_frame(common,
-					      RSI_IFTYPE_STATION,
+					      opmode,
 					      STA_DISCONNECTED,
-					      bssid,
+					      addr,
 					      qos_enable,
-					      aid);
-		rsi_send_block_unblock_frame(common, true);
+					      aid, sta_id);
+		if (opmode == STA_OPMODE)
+			rsi_send_block_unblock_frame(common, true);
 	}
 }
 
diff --git a/drivers/net/wireless/rsi/rsi_mgmt.h b/drivers/net/wireless/rsi/rsi_mgmt.h
index a00aa10..a2e377f 100644
--- a/drivers/net/wireless/rsi/rsi_mgmt.h
+++ b/drivers/net/wireless/rsi/rsi_mgmt.h
@@ -209,6 +209,10 @@ enum vap_status {
 	VAP_UPDATE = 3
 };
 
+enum peer_type {
+	PEER_TYPE_AP,
+	PEER_TYPE_STA,
+};
 extern struct ieee80211_rate rsi_rates[12];
 extern const u16 rsi_mcsrates[8];
 
@@ -611,8 +615,9 @@ int rsi_set_channel(struct rsi_common *common,
 		    struct ieee80211_channel *channel);
 int rsi_send_vap_dynamic_update(struct rsi_common *common);
 int rsi_send_block_unblock_frame(struct rsi_common *common, bool event);
-void rsi_inform_bss_status(struct rsi_common *common, u8 status,
-			   const u8 *bssid, u8 qos_enable, u16 aid);
+void rsi_inform_bss_status(struct rsi_common *common, enum opmode opmode,
+			   u8 status, const u8 *addr, u8 qos_enable, u16 aid,
+			   struct ieee80211_sta *sta, u16 sta_id);
 void rsi_indicate_pkt_to_os(struct rsi_common *common, struct sk_buff *skb);
 int rsi_mac80211_attach(struct rsi_common *common);
 void rsi_indicate_tx_status(struct rsi_hw *common, struct sk_buff *skb,
-- 
2.7.4
