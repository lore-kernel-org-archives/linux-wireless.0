Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:34003 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756430Ab0FQJ1A (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jun 2010 05:27:00 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 17 Jun 2010 02:27:00 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19481.60104.126860.616742@gargle.gargle.HOWL>
Date: Thu, 17 Jun 2010 14:58:40 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/2] ath9k_htc: Handle buffered frames in AP mode
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use the CAB endpoint to send buffered multicast or
broadcast frames after each SWBA event.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc.h            |    4 ++-
 drivers/net/wireless/ath/ath9k/htc_drv_beacon.c |   42 ++++++++++++++++++++--
 drivers/net/wireless/ath/ath9k/htc_drv_init.c   |    3 +-
 drivers/net/wireless/ath/ath9k/htc_drv_main.c   |    2 +-
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c   |   13 +++++--
 drivers/net/wireless/ath/ath9k/wmi.c            |    1 +
 6 files changed, 55 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index 58f52a1..8583bf8 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -402,6 +402,7 @@ static inline void ath_read_cachesize(struct ath_common *common, int *csz)
 void ath9k_htc_beaconq_config(struct ath9k_htc_priv *priv);
 void ath9k_htc_beacon_config(struct ath9k_htc_priv *priv,
 			     struct ieee80211_vif *vif);
+void ath9k_htc_send_buffered(struct ath9k_htc_priv *priv);
 void ath9k_htc_swba(struct ath9k_htc_priv *priv, u8 beacon_pending);
 
 void ath9k_htc_rxep(void *priv, struct sk_buff *skb,
@@ -417,7 +418,8 @@ void ath9k_ani_work(struct work_struct *work);;
 
 int ath9k_tx_init(struct ath9k_htc_priv *priv);
 void ath9k_tx_tasklet(unsigned long data);
-int ath9k_htc_tx_start(struct ath9k_htc_priv *priv, struct sk_buff *skb);
+int ath9k_htc_tx_start(struct ath9k_htc_priv *priv, struct sk_buff *skb,
+		       bool is_cab);
 void ath9k_tx_cleanup(struct ath9k_htc_priv *priv);
 bool ath9k_htc_txq_setup(struct ath9k_htc_priv *priv, int subtype);
 int ath9k_htc_cabq_setup(struct ath9k_htc_priv *priv);
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
index bd1506e..8901732 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
@@ -138,8 +138,8 @@ static void ath9k_htc_beacon_config_sta(struct ath9k_htc_priv *priv,
 	WMI_CMD_BUF(WMI_ENABLE_INTR_CMDID, &htc_imask);
 }
 
-static void ath9k_htc_beacon_config_adhoc(struct ath9k_htc_priv *priv,
-					  struct htc_beacon_config *bss_conf)
+static void ath9k_htc_beacon_config_gen(struct ath9k_htc_priv *priv,
+					struct htc_beacon_config *bss_conf)
 {
 	struct ath_common *common = ath9k_hw_common(priv->ah);
 	enum ath9k_int imask = 0;
@@ -155,7 +155,7 @@ static void ath9k_htc_beacon_config_adhoc(struct ath9k_htc_priv *priv,
 		imask |= ATH9K_INT_SWBA;
 
 	ath_print(common, ATH_DBG_BEACON,
-		  "IBSS Beacon config, intval: %d, imask: 0x%x\n",
+		  "Beacon config, intval: %d, imask: 0x%x\n",
 		  bss_conf->beacon_interval, imask);
 
 	WMI_CMD(WMI_DISABLE_INTR_CMDID);
@@ -171,6 +171,39 @@ void ath9k_htc_beaconep(void *drv_priv, struct sk_buff *skb,
 	dev_kfree_skb_any(skb);
 }
 
+void ath9k_htc_send_buffered(struct ath9k_htc_priv *priv)
+{
+	struct ath_common *common = ath9k_hw_common(priv->ah);
+	struct sk_buff *skb;
+	struct ieee80211_hdr *hdr;
+	int padpos, padsize, ret;
+
+	skb = ieee80211_get_buffered_bc(priv->hw, priv->vif);
+	while(skb) {
+		hdr = (struct ieee80211_hdr *) skb->data;
+
+		padpos = ath9k_cmn_padpos(hdr->frame_control);
+		padsize = padpos & 3;
+		if (padsize && skb->len > padpos) {
+			if (skb_headroom(skb) < padsize) {
+				dev_kfree_skb_any(skb);
+				goto next;
+			}
+			skb_push(skb, padsize);
+			memmove(skb->data, skb->data + padsize, padpos);
+		}
+
+		ret = ath9k_htc_tx_start(priv, skb, true);
+		if (ret != 0) {
+			ath_print(common, ATH_DBG_FATAL,
+				  "Failed to send CAB frame\n");
+			dev_kfree_skb_any(skb);
+		}
+	next:
+		skb = ieee80211_get_buffered_bc(priv->hw, priv->vif);
+	}
+}
+
 void ath9k_htc_swba(struct ath9k_htc_priv *priv, u8 beacon_pending)
 {
 	struct ath9k_htc_vif *avp = (void *)priv->vif->drv_priv;
@@ -268,7 +301,8 @@ void ath9k_htc_beacon_config(struct ath9k_htc_priv *priv,
 		ath9k_htc_beacon_config_sta(priv, cur_conf);
 		break;
 	case NL80211_IFTYPE_ADHOC:
-		ath9k_htc_beacon_config_adhoc(priv, cur_conf);
+	case NL80211_IFTYPE_AP:
+		ath9k_htc_beacon_config_gen(priv, cur_conf);
 		break;
 	default:
 		ath_print(common, ATH_DBG_CONFIG,
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index e1840b1..02651ff 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -696,7 +696,8 @@ static void ath9k_set_hw_capab(struct ath9k_htc_priv *priv,
 		IEEE80211_HW_HAS_RATE_CONTROL |
 		IEEE80211_HW_RX_INCLUDES_FCS |
 		IEEE80211_HW_SUPPORTS_PS |
-		IEEE80211_HW_PS_NULLFUNC_STACK;
+		IEEE80211_HW_PS_NULLFUNC_STACK |
+		IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING;
 
 	hw->wiphy->interface_modes =
 		BIT(NL80211_IFTYPE_STATION) |
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index 2869cff..f8c1217 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -1118,7 +1118,7 @@ static int ath9k_htc_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 		memmove(skb->data, skb->data + padsize, padpos);
 	}
 
-	ret = ath9k_htc_tx_start(priv, skb);
+	ret = ath9k_htc_tx_start(priv, skb, false);
 	if (ret != 0) {
 		if (ret == -ENOMEM) {
 			ath_print(ath9k_hw_common(priv->ah), ATH_DBG_XMIT,
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index bd0b4ac..4d4b9b8 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -72,7 +72,8 @@ int ath_htc_txq_update(struct ath9k_htc_priv *priv, int qnum,
 	return error;
 }
 
-int ath9k_htc_tx_start(struct ath9k_htc_priv *priv, struct sk_buff *skb)
+int ath9k_htc_tx_start(struct ath9k_htc_priv *priv, struct sk_buff *skb,
+		       bool is_cab)
 {
 	struct ieee80211_hdr *hdr;
 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
@@ -140,6 +141,11 @@ int ath9k_htc_tx_start(struct ath9k_htc_priv *priv, struct sk_buff *skb)
 		tx_fhdr = skb_push(skb, sizeof(tx_hdr));
 		memcpy(tx_fhdr, (u8 *) &tx_hdr, sizeof(tx_hdr));
 
+		if (is_cab) {
+			epid = priv->cab_ep;
+			goto send;
+		}
+
 		qnum = skb_get_queue_mapping(skb);
 
 		switch (qnum) {
@@ -183,7 +189,7 @@ int ath9k_htc_tx_start(struct ath9k_htc_priv *priv, struct sk_buff *skb)
 		memcpy(tx_fhdr, (u8 *) &mgmt_hdr, sizeof(mgmt_hdr));
 		epid = priv->mgmt_ep;
 	}
-
+send:
 	return htc_send(priv->htc, skb, epid, &tx_ctl);
 }
 
@@ -281,7 +287,8 @@ void ath9k_htc_txep(void *drv_priv, struct sk_buff *skb,
 	} else if ((ep_id == priv->data_bk_ep) ||
 		   (ep_id == priv->data_be_ep) ||
 		   (ep_id == priv->data_vi_ep) ||
-		   (ep_id == priv->data_vo_ep)) {
+		   (ep_id == priv->data_vo_ep) ||
+		   (ep_id == priv->cab_ep)) {
 		skb_pull(skb, sizeof(struct tx_frame_hdr));
 	} else {
 		ath_print(common, ATH_DBG_FATAL,
diff --git a/drivers/net/wireless/ath/ath9k/wmi.c b/drivers/net/wireless/ath/ath9k/wmi.c
index 6260faa..0b35f16 100644
--- a/drivers/net/wireless/ath/ath9k/wmi.c
+++ b/drivers/net/wireless/ath/ath9k/wmi.c
@@ -149,6 +149,7 @@ void ath9k_wmi_tasklet(unsigned long data)
 	case WMI_SWBA_EVENTID:
 		swba_hdr = (struct wmi_swba *) wmi_event;
 		ath9k_htc_swba(priv, swba_hdr->beacon_pending);
+		ath9k_htc_send_buffered(priv);
 		break;
 	case WMI_FATAL_EVENTID:
 		break;
-- 
1.7.1

