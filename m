Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:35029 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751242AbdH3Jnd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Aug 2017 05:43:33 -0400
Received: by mail-pg0-f65.google.com with SMTP id r133so4718712pgr.2
        for <linux-wireless@vger.kernel.org>; Wed, 30 Aug 2017 02:43:33 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Subject: [PATCH 2/8] rsi: add/remove interface enhancements for p2p
Date: Wed, 30 Aug 2017 15:08:22 +0530
Message-Id: <1504085908-2163-3-git-send-email-amitkarwar@gmail.com> (sfid-20170830_114411_631236_B6C6184F)
In-Reply-To: <1504085908-2163-1-git-send-email-amitkarwar@gmail.com>
References: <1504085908-2163-1-git-send-email-amitkarwar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>

STA_OPMODE and AP_OPMODE macros are renamed to RSI_OPMODE_STA
and RSI_OPMODE_AP. New opmodes are added to this list for P2P
support. Mapping of mac80211 interface types to rsi interface
types are added.
Add and remove interface callbacks are handled for P2P mode.

Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_91x_mac80211.c | 117 +++++++++++++++++-----------
 drivers/net/wireless/rsi/rsi_91x_mgmt.c     |  12 +--
 drivers/net/wireless/rsi/rsi_main.h         |   6 +-
 drivers/net/wireless/rsi/rsi_mgmt.h         |   9 ++-
 4 files changed, 89 insertions(+), 55 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_mac80211.c b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
index 992ac6c..db69d87 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mac80211.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
@@ -355,6 +355,24 @@ static void rsi_mac80211_stop(struct ieee80211_hw *hw)
 	mutex_unlock(&common->mutex);
 }
 
+static int rsi_map_intf_mode(enum nl80211_iftype vif_type)
+{
+	switch (vif_type) {
+	case NL80211_IFTYPE_STATION:
+		return RSI_OPMODE_STA;
+	case NL80211_IFTYPE_AP:
+		return RSI_OPMODE_AP;
+	case NL80211_IFTYPE_P2P_DEVICE:
+		return RSI_OPMODE_P2P_CLIENT;
+	case NL80211_IFTYPE_P2P_CLIENT:
+		return RSI_OPMODE_P2P_CLIENT;
+	case NL80211_IFTYPE_P2P_GO:
+		return RSI_OPMODE_P2P_GO;
+	default:
+		return RSI_OPMODE_UNSUPPORTED;
+	}
+}
+
 /**
  * rsi_mac80211_add_interface() - This function is called when a netdevice
  *				  attached to the hardware is enabled.
@@ -368,54 +386,62 @@ static int rsi_mac80211_add_interface(struct ieee80211_hw *hw,
 {
 	struct rsi_hw *adapter = hw->priv;
 	struct rsi_common *common = adapter->priv;
+	struct vif_priv *vif_info = (struct vif_priv *)vif->drv_priv;
 	enum opmode intf_mode;
-	int ret = -EOPNOTSUPP;
+	enum vap_status vap_status;
+	int vap_idx = -1, i;
 
 	vif->driver_flags |= IEEE80211_VIF_SUPPORTS_UAPSD;
 	mutex_lock(&common->mutex);
 
-	if (adapter->sc_nvifs > 1) {
-		mutex_unlock(&common->mutex);
-		return -EOPNOTSUPP;
-	}
-
-	switch (vif->type) {
-	case NL80211_IFTYPE_STATION:
-		rsi_dbg(INFO_ZONE, "Station Mode");
-		intf_mode = STA_OPMODE;
-		break;
-	case NL80211_IFTYPE_AP:
-		rsi_dbg(INFO_ZONE, "AP Mode");
-		intf_mode = AP_OPMODE;
-		break;
-	default:
+	intf_mode = rsi_map_intf_mode(vif->type);
+	if (intf_mode == RSI_OPMODE_UNSUPPORTED) {
 		rsi_dbg(ERR_ZONE,
 			"%s: Interface type %d not supported\n", __func__,
 			vif->type);
-		goto out;
+		mutex_unlock(&common->mutex);
+		return -EOPNOTSUPP;
+	}
+	if ((vif->type == NL80211_IFTYPE_P2P_DEVICE) ||
+	    (vif->type == NL80211_IFTYPE_P2P_CLIENT) ||
+	    (vif->type == NL80211_IFTYPE_P2P_GO))
+		common->p2p_enabled = true;
+
+	/* Get free vap index */
+	for (i = 0; i < RSI_MAX_VIFS; i++) {
+		if (!adapter->vifs[i]) {
+			vap_idx = i;
+			break;
+		}
+	}
+	if (vap_idx < 0) {
+		rsi_dbg(ERR_ZONE, "Reject: Max VAPs reached\n");
+		mutex_unlock(&common->mutex);
+		return -EOPNOTSUPP;
 	}
+	vif_info->vap_id = vap_idx;
+	adapter->vifs[vap_idx] = vif;
+	adapter->sc_nvifs++;
+	vap_status = VAP_ADD;
 
-	adapter->vifs[adapter->sc_nvifs++] = vif;
-	ret = rsi_set_vap_capabilities(common, intf_mode, common->mac_addr,
-				       0, VAP_ADD);
-	if (ret) {
+	if (rsi_set_vap_capabilities(common, intf_mode, vif->addr,
+				     vif_info->vap_id, vap_status)) {
 		rsi_dbg(ERR_ZONE, "Failed to set VAP capabilities\n");
-		goto out;
+		mutex_unlock(&common->mutex);
+		return -EINVAL;
 	}
 
-	if (vif->type == NL80211_IFTYPE_AP) {
-		int i;
-
+	if ((vif->type == NL80211_IFTYPE_AP) ||
+	    (vif->type == NL80211_IFTYPE_P2P_GO)) {
 		rsi_send_rx_filter_frame(common, DISALLOW_BEACONS);
 		common->min_rate = RSI_RATE_AUTO;
 		for (i = 0; i < common->max_stations; i++)
 			common->stations[i].sta = NULL;
 	}
 
-out:
 	mutex_unlock(&common->mutex);
 
-	return ret;
+	return 0;
 }
 
 /**
@@ -432,6 +458,7 @@ static void rsi_mac80211_remove_interface(struct ieee80211_hw *hw,
 	struct rsi_hw *adapter = hw->priv;
 	struct rsi_common *common = adapter->priv;
 	enum opmode opmode;
+	int i;
 
 	rsi_dbg(INFO_ZONE, "Remove Interface Called\n");
 
@@ -442,23 +469,22 @@ static void rsi_mac80211_remove_interface(struct ieee80211_hw *hw,
 		return;
 	}
 
-	switch (vif->type) {
-	case NL80211_IFTYPE_STATION:
-		opmode = STA_OPMODE;
-		break;
-	case NL80211_IFTYPE_AP:
-		opmode = AP_OPMODE;
-		break;
-	default:
+	opmode = rsi_map_intf_mode(vif->type);
+	if (opmode == RSI_OPMODE_UNSUPPORTED) {
+		rsi_dbg(ERR_ZONE, "Opmode error : %d\n", opmode);
 		mutex_unlock(&common->mutex);
 		return;
 	}
-	rsi_set_vap_capabilities(common, opmode, vif->addr,
-				 0, VAP_DELETE);
-	adapter->sc_nvifs--;
-
-	if (!memcmp(adapter->vifs[0], vif, sizeof(struct ieee80211_vif)))
-		adapter->vifs[0] = NULL;
+	for (i = 0; i < RSI_MAX_VIFS; i++) {
+		if (!adapter->vifs[i])
+			continue;
+		if (vif == adapter->vifs[i]) {
+			rsi_set_vap_capabilities(common, opmode, vif->addr,
+						 i, VAP_DELETE);
+			adapter->sc_nvifs--;
+			adapter->vifs[i] = NULL;
+		}
+	}
 	mutex_unlock(&common->mutex);
 }
 
@@ -652,7 +678,7 @@ static void rsi_mac80211_bss_info_changed(struct ieee80211_hw *hw,
 			rsi_send_rx_filter_frame(common, rx_filter_word);
 		}
 		rsi_inform_bss_status(common,
-				      STA_OPMODE,
+				      RSI_OPMODE_STA,
 				      bss_conf->assoc,
 				      bss_conf->bssid,
 				      bss_conf->qos,
@@ -1285,8 +1311,9 @@ static int rsi_mac80211_sta_add(struct ieee80211_hw *hw,
 
 			/* Send peer notify to device */
 			rsi_dbg(INFO_ZONE, "Indicate bss status to device\n");
-			rsi_inform_bss_status(common, AP_OPMODE, 1, sta->addr,
-					      sta->wme, sta->aid, sta, sta_idx);
+			rsi_inform_bss_status(common, RSI_OPMODE_AP, 1,
+					      sta->addr, sta->wme, sta->aid,
+					      sta, sta_idx);
 
 			if (common->key) {
 				struct ieee80211_key_conf *key = common->key;
@@ -1358,7 +1385,7 @@ static int rsi_mac80211_sta_remove(struct ieee80211_hw *hw,
 			if (!rsta->sta)
 				continue;
 			if (!memcmp(rsta->sta->addr, sta->addr, ETH_ALEN)) {
-				rsi_inform_bss_status(common, AP_OPMODE, 0,
+				rsi_inform_bss_status(common, RSI_OPMODE_AP, 0,
 						      sta->addr, sta->wme,
 						      sta->aid, sta, sta_idx);
 				rsta->sta = NULL;
diff --git a/drivers/net/wireless/rsi/rsi_91x_mgmt.c b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
index f7b550f..082329d 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mgmt.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
@@ -482,9 +482,9 @@ static int rsi_hal_send_sta_notify_frame(struct rsi_common *common,
 	memset(skb->data, 0, frame_len);
 	peer_notify = (struct rsi_peer_notify *)skb->data;
 
-	if (opmode == STA_OPMODE)
+	if (opmode == RSI_OPMODE_STA)
 		peer_notify->command = cpu_to_le16(PEER_TYPE_AP << 1);
-	else if (opmode == AP_OPMODE)
+	else if (opmode == RSI_OPMODE_AP)
 		peer_notify->command = cpu_to_le16(PEER_TYPE_STA << 1);
 
 	switch (notify_event) {
@@ -1321,7 +1321,7 @@ void rsi_inform_bss_status(struct rsi_common *common,
 			   u16 sta_id)
 {
 	if (status) {
-		if (opmode == STA_OPMODE)
+		if (opmode == RSI_OPMODE_STA)
 			common->hw_data_qs_blocked = true;
 		rsi_hal_send_sta_notify_frame(common,
 					      opmode,
@@ -1331,12 +1331,12 @@ void rsi_inform_bss_status(struct rsi_common *common,
 					      aid, sta_id);
 		if (common->min_rate == 0xffff)
 			rsi_send_auto_rate_request(common, sta, sta_id);
-		if (opmode == STA_OPMODE) {
+		if (opmode == RSI_OPMODE_STA) {
 			if (!rsi_send_block_unblock_frame(common, false))
 				common->hw_data_qs_blocked = false;
 		}
 	} else {
-		if (opmode == STA_OPMODE)
+		if (opmode == RSI_OPMODE_STA)
 			common->hw_data_qs_blocked = true;
 		rsi_hal_send_sta_notify_frame(common,
 					      opmode,
@@ -1344,7 +1344,7 @@ void rsi_inform_bss_status(struct rsi_common *common,
 					      addr,
 					      qos_enable,
 					      aid, sta_id);
-		if (opmode == STA_OPMODE)
+		if (opmode == RSI_OPMODE_STA)
 			rsi_send_block_unblock_frame(common, true);
 	}
 }
diff --git a/drivers/net/wireless/rsi/rsi_main.h b/drivers/net/wireless/rsi/rsi_main.h
index 2c18dde..a4837fa 100644
--- a/drivers/net/wireless/rsi/rsi_main.h
+++ b/drivers/net/wireless/rsi/rsi_main.h
@@ -60,7 +60,7 @@ enum RSI_FSM_STATES {
 extern u32 rsi_zone_enabled;
 extern __printf(2, 3) void rsi_dbg(u32 zone, const char *fmt, ...);
 
-#define RSI_MAX_VIFS                    1
+#define RSI_MAX_VIFS                    3
 #define NUM_EDCA_QUEUES                 4
 #define IEEE80211_ADDR_LEN              6
 #define FRAME_DESC_SZ                   16
@@ -157,6 +157,7 @@ struct vif_priv {
 	bool is_ht;
 	bool sgi;
 	u16 seq_start;
+	int vap_id;
 };
 
 struct rsi_event {
@@ -270,6 +271,9 @@ struct rsi_common {
 	int num_stations;
 	int max_stations;
 	struct ieee80211_key_conf *key;
+
+	/* Wi-Fi direct mode related */
+	bool p2p_enabled;
 };
 
 enum host_intf {
diff --git a/drivers/net/wireless/rsi/rsi_mgmt.h b/drivers/net/wireless/rsi/rsi_mgmt.h
index c6e1fa6..8bd7dfa 100644
--- a/drivers/net/wireless/rsi/rsi_mgmt.h
+++ b/drivers/net/wireless/rsi/rsi_mgmt.h
@@ -200,8 +200,11 @@
 #define RSI_DATA_DESC_INSERT_SEQ_NO	BIT(2)
 
 enum opmode {
-	AP_OPMODE = 0,
-	STA_OPMODE,
+	RSI_OPMODE_UNSUPPORTED = -1,
+	RSI_OPMODE_AP = 0,
+	RSI_OPMODE_STA,
+	RSI_OPMODE_P2P_GO,
+	RSI_OPMODE_P2P_CLIENT
 };
 
 enum vap_status {
@@ -363,9 +366,9 @@ struct rsi_vap_caps {
 	u8 vif_type;
 	u8 channel_bw;
 	__le16 antenna_info;
+	__le16 token;
 	u8 radioid_macid;
 	u8 vap_id;
-	__le16 reserved3;
 	u8 mac_addr[6];
 	__le16 keep_alive_period;
 	u8 bssid[6];
-- 
2.7.4
