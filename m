Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:33580 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752150AbeCEOtH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Mar 2018 09:49:07 -0500
Received: by mail-pf0-f194.google.com with SMTP id q13so7285534pff.0
        for <linux-wireless@vger.kernel.org>; Mon, 05 Mar 2018 06:49:07 -0800 (PST)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Subject: [PATCH 05/10] rsi: roaming enhancements
Date: Mon,  5 Mar 2018 20:06:55 +0530
Message-Id: <1520260620-4694-6-git-send-email-amitkarwar@gmail.com> (sfid-20180305_154914_988913_9B31FC20)
In-Reply-To: <1520260620-4694-1-git-send-email-amitkarwar@gmail.com>
References: <1520260620-4694-1-git-send-email-amitkarwar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>

To support roaming below changes are done:
* Station notify frame is send to firmware after sending assoc
  request. This will avoid dropping of first EAPOL frame due to
  delay in creation of station control block in firmware.
* Data queues are unblocked after sending station notify in open
  mode, after configuring key in WEP mode, and after receiving
  EAPOL4 confirm in WPA mode.
* Initial EAPOL frames priority is chaged to MGMT, rekey EAPOL
  frames priority changed to VO.
* Data frames with wrong BSSID are dropped.

Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
---
 drivers/net/wireless/rsi/rsi_91x_core.c     | 16 +++++++++++++++
 drivers/net/wireless/rsi/rsi_91x_hal.c      | 24 +++++++++++++++++++---
 drivers/net/wireless/rsi/rsi_91x_mac80211.c | 29 ++++++++++++++++----------
 drivers/net/wireless/rsi/rsi_91x_mgmt.c     | 32 +++++++++++++++++------------
 drivers/net/wireless/rsi/rsi_main.h         |  1 +
 drivers/net/wireless/rsi/rsi_mgmt.h         | 11 +++++++++-
 6 files changed, 85 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_core.c b/drivers/net/wireless/rsi/rsi_91x_core.c
index f5d1756..3ca468b9 100644
--- a/drivers/net/wireless/rsi/rsi_91x_core.c
+++ b/drivers/net/wireless/rsi/rsi_91x_core.c
@@ -411,6 +411,18 @@ void rsi_core_xmit(struct rsi_common *common, struct sk_buff *skb)
 	if ((ieee80211_is_mgmt(wh->frame_control)) ||
 	    (ieee80211_is_ctl(wh->frame_control)) ||
 	    (ieee80211_is_qos_nullfunc(wh->frame_control))) {
+		if (ieee80211_is_assoc_req(wh->frame_control) ||
+		    ieee80211_is_reassoc_req(wh->frame_control)) {
+			struct ieee80211_bss_conf *bss = &vif->bss_conf;
+
+			common->eapol4_confirm = false;
+			rsi_hal_send_sta_notify_frame(common,
+						      RSI_IFTYPE_STATION,
+						      STA_CONNECTED, bss->bssid,
+						      bss->qos, bss->aid, 0,
+						      vif);
+		}
+
 		q_num = MGMT_SOFT_Q;
 		skb->priority = q_num;
 
@@ -450,6 +462,10 @@ void rsi_core_xmit(struct rsi_common *common, struct sk_buff *skb)
 							      tid, 0);
 			}
 		}
+		if (skb->protocol == cpu_to_be16(ETH_P_PAE)) {
+			q_num = MGMT_SOFT_Q;
+			skb->priority = q_num;
+		}
 		if (rsi_prepare_data_desc(common, skb)) {
 			rsi_dbg(ERR_ZONE, "Failed to prepare data desc\n");
 			goto xmit_fail;
diff --git a/drivers/net/wireless/rsi/rsi_91x_hal.c b/drivers/net/wireless/rsi/rsi_91x_hal.c
index 7e04daf..ac40507 100644
--- a/drivers/net/wireless/rsi/rsi_91x_hal.c
+++ b/drivers/net/wireless/rsi/rsi_91x_hal.c
@@ -235,6 +235,18 @@ int rsi_prepare_data_desc(struct rsi_common *common, struct sk_buff *skb)
 		data_desc->misc_flags |= RSI_FETCH_RETRY_CNT_FRM_HST;
 #define EAPOL_RETRY_CNT 15
 		xtend_desc->retry_cnt = EAPOL_RETRY_CNT;
+
+		if (common->eapol4_confirm)
+			skb->priority = VO_Q;
+		else
+			rsi_set_len_qno(&data_desc->len_qno,
+					(skb->len - FRAME_DESC_SZ),
+					RSI_WIFI_MGMT_Q);
+		if ((skb->len - header_size) == EAPOL4_PACKET_LEN) {
+			data_desc->misc_flags |=
+				RSI_DESC_REQUIRE_CFM_TO_HOST;
+			xtend_desc->confirm_frame_type = EAPOL4_CONFIRM;
+		}
 	}
 
 	data_desc->mac_flags = cpu_to_le16(seq_num & 0xfff);
@@ -274,8 +286,11 @@ int rsi_send_data_pkt(struct rsi_common *common, struct sk_buff *skb)
 	struct rsi_hw *adapter = common->priv;
 	struct ieee80211_vif *vif;
 	struct ieee80211_tx_info *info;
+	struct skb_info *tx_params;
 	struct ieee80211_bss_conf *bss;
+	struct ieee80211_hdr *wh;
 	int status = -EINVAL;
+	u8 header_size;
 
 	if (!skb)
 		return 0;
@@ -287,10 +302,13 @@ int rsi_send_data_pkt(struct rsi_common *common, struct sk_buff *skb)
 		goto err;
 	vif = info->control.vif;
 	bss = &vif->bss_conf;
+	tx_params = (struct skb_info *)info->driver_data;
+	header_size = tx_params->internal_hdr_size;
+	wh = (struct ieee80211_hdr *)&skb->data[header_size];
 
-	if (((vif->type == NL80211_IFTYPE_STATION) ||
-	     (vif->type == NL80211_IFTYPE_P2P_CLIENT)) &&
-	    (!bss->assoc))
+	if ((vif->type == NL80211_IFTYPE_STATION ||
+	     vif->type == NL80211_IFTYPE_P2P_CLIENT) &&
+	    !(bss->assoc && ether_addr_equal(wh->addr1, bss->bssid)))
 		goto err;
 
 	status = rsi_send_pkt_to_bus(common, skb);
diff --git a/drivers/net/wireless/rsi/rsi_91x_mac80211.c b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
index 4957690..ef7cabf 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mac80211.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
@@ -816,7 +816,8 @@ static void rsi_mac80211_bss_info_changed(struct ieee80211_hw *hw,
 				      bss_conf->bssid,
 				      bss_conf->qos,
 				      bss_conf->aid,
-				      NULL, 0, vif);
+				      NULL, 0,
+				      bss_conf->assoc_capability, vif);
 		adapter->ps_info.dtim_interval_duration = bss->dtim_period;
 		adapter->ps_info.listen_interval = conf->listen_interval;
 
@@ -985,14 +986,20 @@ static int rsi_hal_key_config(struct ieee80211_hw *hw,
 		}
 	}
 
-	return rsi_hal_load_key(adapter->priv,
-				key->key,
-				key->keylen,
-				key_type,
-				key->keyidx,
-				key->cipher,
-				sta_id,
-				vif);
+	status = rsi_hal_load_key(adapter->priv, key->key, key->keylen,
+				  key_type, key->keyidx, key->cipher,
+				  sta_id, vif);
+	if (status)
+		return status;
+
+	if (vif->type == NL80211_IFTYPE_STATION && key->key &&
+	    (key->cipher == WLAN_CIPHER_SUITE_WEP104 ||
+	     key->cipher == WLAN_CIPHER_SUITE_WEP40)) {
+		if (!rsi_send_block_unblock_frame(adapter->priv, false))
+			adapter->priv->hw_data_qs_blocked = false;
+	}
+
+	return 0;
 }
 
 /**
@@ -1470,7 +1477,7 @@ static int rsi_mac80211_sta_add(struct ieee80211_hw *hw,
 			rsi_dbg(INFO_ZONE, "Indicate bss status to device\n");
 			rsi_inform_bss_status(common, RSI_OPMODE_AP, 1,
 					      sta->addr, sta->wme, sta->aid,
-					      sta, sta_idx, vif);
+					      sta, sta_idx, 0, vif);
 
 			if (common->key) {
 				struct ieee80211_key_conf *key = common->key;
@@ -1548,7 +1555,7 @@ static int rsi_mac80211_sta_remove(struct ieee80211_hw *hw,
 				rsi_inform_bss_status(common, RSI_OPMODE_AP, 0,
 						      sta->addr, sta->wme,
 						      sta->aid, sta, sta_idx,
-						      vif);
+						      0, vif);
 				rsta->sta = NULL;
 				rsta->sta_id = -1;
 				for (cnt = 0; cnt < IEEE80211_NUM_TIDS; cnt++)
diff --git a/drivers/net/wireless/rsi/rsi_91x_mgmt.c b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
index 6f995d5a..0444025 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mgmt.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
@@ -467,14 +467,10 @@ static int rsi_mgmt_pkt_to_core(struct rsi_common *common,
  *
  * Return: status: 0 on success, corresponding negative error code on failure.
  */
-static int rsi_hal_send_sta_notify_frame(struct rsi_common *common,
-					 enum opmode opmode,
-					 u8 notify_event,
-					 const unsigned char *bssid,
-					 u8 qos_enable,
-					 u16 aid,
-					 u16 sta_id,
-					 struct ieee80211_vif *vif)
+int rsi_hal_send_sta_notify_frame(struct rsi_common *common, enum opmode opmode,
+				  u8 notify_event, const unsigned char *bssid,
+				  u8 qos_enable, u16 aid, u16 sta_id,
+				  struct ieee80211_vif *vif)
 {
 	struct sk_buff *skb = NULL;
 	struct rsi_peer_notify *peer_notify;
@@ -1342,6 +1338,7 @@ void rsi_inform_bss_status(struct rsi_common *common,
 			   u16 aid,
 			   struct ieee80211_sta *sta,
 			   u16 sta_id,
+			   u16 assoc_cap,
 			   struct ieee80211_vif *vif)
 {
 	if (status) {
@@ -1356,10 +1353,10 @@ void rsi_inform_bss_status(struct rsi_common *common,
 					      vif);
 		if (common->min_rate == 0xffff)
 			rsi_send_auto_rate_request(common, sta, sta_id, vif);
-		if (opmode == RSI_OPMODE_STA) {
-			if (!rsi_send_block_unblock_frame(common, false))
-				common->hw_data_qs_blocked = false;
-		}
+		if (opmode == RSI_OPMODE_STA &&
+		    !(assoc_cap & DOT11_ASSOC_CAP_SECURITY) &&
+		    !rsi_send_block_unblock_frame(common, false))
+			common->hw_data_qs_blocked = false;
 	} else {
 		if (opmode == RSI_OPMODE_STA)
 			common->hw_data_qs_blocked = true;
@@ -2120,11 +2117,20 @@ int rsi_mgmt_pkt_recv(struct rsi_common *common, u8 *msg)
 			__func__);
 		return rsi_handle_card_ready(common, msg);
 	case TX_STATUS_IND:
-		if (msg[15] == PROBEREQ_CONFIRM) {
+		switch (msg[RSI_TX_STATUS_TYPE]) {
+		case PROBEREQ_CONFIRM:
 			common->mgmt_q_block = false;
 			rsi_dbg(INFO_ZONE, "%s: Mgmt queue unblocked\n",
 				__func__);
 			rsi_set_event(&common->probe_cfm_event);
+			break;
+		case EAPOL4_CONFIRM:
+			if (msg[RSI_TX_STATUS]) {
+				common->eapol4_confirm = true;
+				if (!rsi_send_block_unblock_frame(common,
+								  false))
+					common->hw_data_qs_blocked = false;
+			}
 		}
 		break;
 	case BEACON_EVENT_IND:
diff --git a/drivers/net/wireless/rsi/rsi_main.h b/drivers/net/wireless/rsi/rsi_main.h
index abc4f29..e2bbbbd 100644
--- a/drivers/net/wireless/rsi/rsi_main.h
+++ b/drivers/net/wireless/rsi/rsi_main.h
@@ -324,6 +324,7 @@ struct rsi_common {
 	bool fgscan_in_prog;
 	bool bgscan_en;
 	bool cancel_hwscan;
+	bool eapol4_confirm;
 };
 
 struct eepromrw_info {
diff --git a/drivers/net/wireless/rsi/rsi_mgmt.h b/drivers/net/wireless/rsi/rsi_mgmt.h
index 2513fb8..f21fdd4 100644
--- a/drivers/net/wireless/rsi/rsi_mgmt.h
+++ b/drivers/net/wireless/rsi/rsi_mgmt.h
@@ -33,6 +33,7 @@
 #define WMM_SHORT_SLOT_TIME             9
 #define SIFS_DURATION                   16
 
+#define EAPOL4_PACKET_LEN		0x85
 #define KEY_TYPE_CLEAR                  0
 #define RSI_PAIRWISE_KEY                1
 #define RSI_GROUP_KEY                   2
@@ -62,9 +63,12 @@
 #define RX_DOT11_MGMT                   0x02
 #define TX_STATUS_IND                   0x04
 #define BEACON_EVENT_IND		0x08
+#define EAPOL4_CONFIRM                  1
 #define PROBEREQ_CONFIRM                2
 #define CARD_READY_IND                  0x00
 #define SLEEP_NOTIFY_IND                0x06
+#define RSI_TX_STATUS_TYPE		15
+#define RSI_TX_STATUS			12
 
 #define RSI_DELETE_PEER                 0x0
 #define RSI_ADD_PEER                    0x1
@@ -226,6 +230,7 @@
 #define RSI_CHAN_DWELL_TIME		300
 #define RSI_CHAN_SET_TIME		50
 #define RSI_PROBE_CFM_TIME		50
+#define DOT11_ASSOC_CAP_SECURITY	BIT(4)
 
 enum opmode {
 	RSI_OPMODE_UNSUPPORTED = -1,
@@ -694,10 +699,14 @@ int rsi_set_channel(struct rsi_common *common,
 		    struct ieee80211_channel *channel);
 int rsi_send_vap_dynamic_update(struct rsi_common *common);
 int rsi_send_block_unblock_frame(struct rsi_common *common, bool event);
+int rsi_hal_send_sta_notify_frame(struct rsi_common *common, enum opmode opmode,
+				  u8 notify_event, const unsigned char *bssid,
+				  u8 qos_enable, u16 aid, u16 sta_id,
+				  struct ieee80211_vif *vif);
 void rsi_inform_bss_status(struct rsi_common *common, enum opmode opmode,
 			   u8 status, const u8 *addr, u8 qos_enable, u16 aid,
 			   struct ieee80211_sta *sta, u16 sta_id,
-			   struct ieee80211_vif *vif);
+			   u16 assoc_cap, struct ieee80211_vif *vif);
 void rsi_indicate_pkt_to_os(struct rsi_common *common, struct sk_buff *skb);
 int rsi_mac80211_attach(struct rsi_common *common);
 void rsi_indicate_tx_status(struct rsi_hw *common, struct sk_buff *skb,
-- 
2.7.4
