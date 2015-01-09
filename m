Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f45.google.com ([209.85.218.45]:43953 "EHLO
	mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758196AbbAITSg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Jan 2015 14:18:36 -0500
Received: by mail-oi0-f45.google.com with SMTP id x69so13264728oia.4
        for <linux-wireless@vger.kernel.org>; Fri, 09 Jan 2015 11:18:36 -0800 (PST)
From: Bob Copeland <me@bobcopeland.com>
To: linux-wireless@vger.kernel.org
Cc: Eugene Krasnikov <k.eugene.e@gmail.com>,
	Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 8/8] wcn36xx: initiate TX BA sessions
Date: Fri,  9 Jan 2015 14:15:52 -0500
Message-Id: <1420830952-9624-9-git-send-email-me@bobcopeland.com> (sfid-20150109_201848_413142_D7934F8C)
In-Reply-To: <1420830952-9624-1-git-send-email-me@bobcopeland.com>
References: <1420830952-9624-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently, wcn36xx only asks for a TX BA session if it has
already established one for RX.  Thus, two wcn36xx devices cannot
do a-mpdu between themselves since they both wait for the other
to go first.  Fix this by starting a BA session after a few QoS
data frames have been sent to a STA.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath/wcn36xx/main.c    |   14 ++++++++-
 drivers/net/wireless/ath/wcn36xx/txrx.c    |   45 +++++++++++++++++++++++++++-
 drivers/net/wireless/ath/wcn36xx/wcn36xx.h |   20 +++++++++++++
 3 files changed, 77 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/main.c b/drivers/net/wireless/ath/wcn36xx/main.c
index 972bb3e..0783d2e 100644
--- a/drivers/net/wireless/ath/wcn36xx/main.c
+++ b/drivers/net/wireless/ath/wcn36xx/main.c
@@ -797,6 +797,7 @@ static int wcn36xx_sta_add(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	wcn36xx_dbg(WCN36XX_DBG_MAC, "mac sta add vif %p sta %pM\n",
 		    vif, sta->addr);
 
+	spin_lock_init(&sta_priv->ampdu_lock);
 	vif_priv->sta = sta_priv;
 	sta_priv->vif = vif_priv;
 	/*
@@ -875,21 +876,32 @@ static int wcn36xx_ampdu_action(struct ieee80211_hw *hw,
 			get_sta_index(vif, sta_priv));
 		wcn36xx_smd_add_ba(wcn);
 		wcn36xx_smd_trigger_ba(wcn, get_sta_index(vif, sta_priv));
-		ieee80211_start_tx_ba_session(sta, tid, 0);
 		break;
 	case IEEE80211_AMPDU_RX_STOP:
 		wcn36xx_smd_del_ba(wcn, tid, get_sta_index(vif, sta_priv));
 		break;
 	case IEEE80211_AMPDU_TX_START:
+		spin_lock_bh(&sta_priv->ampdu_lock);
+		sta_priv->ampdu_state[tid] = WCN36XX_AMPDU_START;
+		spin_unlock_bh(&sta_priv->ampdu_lock);
+
 		ieee80211_start_tx_ba_cb_irqsafe(vif, sta->addr, tid);
 		break;
 	case IEEE80211_AMPDU_TX_OPERATIONAL:
+		spin_lock_bh(&sta_priv->ampdu_lock);
+		sta_priv->ampdu_state[tid] = WCN36XX_AMPDU_OPERATIONAL;
+		spin_unlock_bh(&sta_priv->ampdu_lock);
+
 		wcn36xx_smd_add_ba_session(wcn, sta, tid, ssn, 1,
 			get_sta_index(vif, sta_priv));
 		break;
 	case IEEE80211_AMPDU_TX_STOP_FLUSH:
 	case IEEE80211_AMPDU_TX_STOP_FLUSH_CONT:
 	case IEEE80211_AMPDU_TX_STOP_CONT:
+		spin_lock_bh(&sta_priv->ampdu_lock);
+		sta_priv->ampdu_state[tid] = WCN36XX_AMPDU_NONE;
+		spin_unlock_bh(&sta_priv->ampdu_lock);
+
 		ieee80211_stop_tx_ba_cb_irqsafe(vif, sta->addr, tid);
 		break;
 	default:
diff --git a/drivers/net/wireless/ath/wcn36xx/txrx.c b/drivers/net/wireless/ath/wcn36xx/txrx.c
index 7f0d9e6..9bec823 100644
--- a/drivers/net/wireless/ath/wcn36xx/txrx.c
+++ b/drivers/net/wireless/ath/wcn36xx/txrx.c
@@ -111,6 +111,42 @@ static inline struct wcn36xx_vif *get_vif_by_addr(struct wcn36xx *wcn,
 	wcn36xx_warn("vif %pM not found\n", addr);
 	return NULL;
 }
+
+static void wcn36xx_tx_start_ampdu(struct wcn36xx *wcn,
+				   struct wcn36xx_sta *sta_priv,
+				   struct sk_buff *skb)
+{
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
+	struct ieee80211_sta *sta;
+	u8 *qc, tid;
+
+	if (!conf_is_ht(&wcn->hw->conf))
+		return;
+
+	sta = wcn36xx_priv_to_sta(sta_priv);
+
+	if (WARN_ON(!ieee80211_is_data_qos(hdr->frame_control)))
+		return;
+
+	if (skb_get_queue_mapping(skb) == IEEE80211_AC_VO)
+		return;
+
+	qc = ieee80211_get_qos_ctl(hdr);
+	tid = qc[0] & IEEE80211_QOS_CTL_TID_MASK;
+
+	spin_lock(&sta_priv->ampdu_lock);
+	if (sta_priv->ampdu_state[tid] != WCN36XX_AMPDU_NONE)
+		goto out_unlock;
+
+	if (sta_priv->non_agg_frame_ct++ >= WCN36XX_AMPDU_START_THRESH) {
+		sta_priv->ampdu_state[tid] = WCN36XX_AMPDU_START;
+		sta_priv->non_agg_frame_ct = 0;
+		ieee80211_start_tx_ba_session(sta, tid, 0);
+	}
+out_unlock:
+	spin_unlock(&sta_priv->ampdu_lock);
+}
+
 static void wcn36xx_set_tx_data(struct wcn36xx_tx_bd *bd,
 				struct wcn36xx *wcn,
 				struct wcn36xx_vif **vif_priv,
@@ -121,6 +157,8 @@ static void wcn36xx_set_tx_data(struct wcn36xx_tx_bd *bd,
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	struct ieee80211_vif *vif = NULL;
 	struct wcn36xx_vif *__vif_priv = NULL;
+	bool is_data_qos;
+
 	bd->bd_rate = WCN36XX_BD_RATE_DATA;
 
 	/*
@@ -160,11 +198,16 @@ static void wcn36xx_set_tx_data(struct wcn36xx_tx_bd *bd,
 	}
 	*vif_priv = __vif_priv;
 
+	is_data_qos = ieee80211_is_data_qos(hdr->frame_control);
+
 	wcn36xx_set_tx_pdu(bd,
-			   ieee80211_is_data_qos(hdr->frame_control) ?
+			   is_data_qos ?
 			   sizeof(struct ieee80211_qos_hdr) :
 			   sizeof(struct ieee80211_hdr_3addr),
 			   skb->len, sta_priv ? sta_priv->tid : 0);
+
+	if (sta_priv && is_data_qos)
+		wcn36xx_tx_start_ampdu(wcn, sta_priv, skb);
 }
 
 static void wcn36xx_set_tx_mgmt(struct wcn36xx_tx_bd *bd,
diff --git a/drivers/net/wireless/ath/wcn36xx/wcn36xx.h b/drivers/net/wireless/ath/wcn36xx/wcn36xx.h
index f0fb81d..7b41e83 100644
--- a/drivers/net/wireless/ath/wcn36xx/wcn36xx.h
+++ b/drivers/net/wireless/ath/wcn36xx/wcn36xx.h
@@ -32,6 +32,9 @@
 #define WLAN_NV_FILE               "wlan/prima/WCNSS_qcom_wlan_nv.bin"
 #define WCN36XX_AGGR_BUFFER_SIZE 64
 
+/* How many frames until we start a-mpdu TX session */
+#define WCN36XX_AMPDU_START_THRESH	20
+
 extern unsigned int wcn36xx_dbg_mask;
 
 enum wcn36xx_debug_mask {
@@ -74,6 +77,13 @@ enum wcn36xx_debug_mask {
 			       buf, len, false);		\
 } while (0)
 
+enum wcn36xx_ampdu_state {
+	WCN36XX_AMPDU_NONE,
+	WCN36XX_AMPDU_INIT,
+	WCN36XX_AMPDU_START,
+	WCN36XX_AMPDU_OPERATIONAL,
+};
+
 #define WCN36XX_HW_CHANNEL(__wcn) (__wcn->hw->conf.chandef.chan->hw_value)
 #define WCN36XX_BAND(__wcn) (__wcn->hw->conf.chandef.chan->band)
 #define WCN36XX_CENTER_FREQ(__wcn) (__wcn->hw->conf.chandef.chan->center_freq)
@@ -165,6 +175,10 @@ struct wcn36xx_sta {
 	bool is_data_encrypted;
 	/* Rates */
 	struct wcn36xx_hal_supported_rates supported_rates;
+
+	spinlock_t ampdu_lock;		/* protects next two fields */
+	enum wcn36xx_ampdu_state ampdu_state[16];
+	int non_agg_frame_ct;
 };
 struct wcn36xx_dxe_ch;
 struct wcn36xx {
@@ -243,4 +257,10 @@ static inline bool wcn36xx_is_fw_version(struct wcn36xx *wcn,
 }
 void wcn36xx_set_default_rates(struct wcn36xx_hal_supported_rates *rates);
 
+static inline
+struct ieee80211_sta *wcn36xx_priv_to_sta(struct wcn36xx_sta *sta_priv)
+{
+	return container_of((void *)sta_priv, struct ieee80211_sta, drv_priv);
+}
+
 #endif	/* _WCN36XX_H_ */
-- 
1.7.10.4

