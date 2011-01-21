Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:56009 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752700Ab1AUDDO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Jan 2011 22:03:14 -0500
Received: by mail-iy0-f174.google.com with SMTP id 18so1246881iyj.19
        for <linux-wireless@vger.kernel.org>; Thu, 20 Jan 2011 19:03:14 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19768.63300.589868.940308@gargle.gargle.HOWL>
Date: Fri, 21 Jan 2011 08:32:28 +0530
To: linux-wireless@vger.kernel.org
CC: ath9k-devel@lists.ath9k.org
Subject: [RFC/WIP 22/33] ath9k_htc: Handle buffered frames in AP mode
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <Sujith.Manoharan@atheros.com>

Use the CAB endpoint to send buffered multicast or
broadcast frames after each SWBA event.

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc.h            |    6 +++-
 drivers/net/wireless/ath/ath9k/htc_drv_beacon.c |   43 +++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/htc_drv_init.c   |    3 +-
 drivers/net/wireless/ath/ath9k/htc_drv_main.c   |    5 ++-
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c   |   14 ++++++--
 5 files changed, 65 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index bd1610f..912cce8 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -291,6 +291,7 @@ struct ath9k_htc_tx_ctl {
 
 #define TX_STAT_INC(c) (hif_dev->htc_handle->drv_priv->debug.tx_stats.c++)
 #define RX_STAT_INC(c) (hif_dev->htc_handle->drv_priv->debug.rx_stats.c++)
+#define CAB_STAT_INC   priv->debug.tx_stats.cab_queued++
 
 #define TX_QSTAT_INC(q) (priv->debug.tx_stats.queue_stats[q]++)
 
@@ -300,6 +301,7 @@ struct ath_tx_stats {
 	u32 skb_queued;
 	u32 skb_completed;
 	u32 skb_dropped;
+	u32 cab_queued;
 	u32 queue_stats[WME_NUM_AC];
 };
 
@@ -323,6 +325,7 @@ struct ath9k_debug {
 
 #define TX_STAT_INC(c) do { } while (0)
 #define RX_STAT_INC(c) do { } while (0)
+#define CAB_STAT_INC   do { } while (0)
 
 #define TX_QSTAT_INC(c) do { } while (0)
 
@@ -499,7 +502,8 @@ void ath_start_ani(struct ath9k_htc_priv *priv);
 
 int ath9k_tx_init(struct ath9k_htc_priv *priv);
 void ath9k_tx_tasklet(unsigned long data);
-int ath9k_htc_tx_start(struct ath9k_htc_priv *priv, struct sk_buff *skb);
+int ath9k_htc_tx_start(struct ath9k_htc_priv *priv,
+		       struct sk_buff *skb, bool is_cab);
 void ath9k_tx_cleanup(struct ath9k_htc_priv *priv);
 bool ath9k_htc_txq_setup(struct ath9k_htc_priv *priv, int subtype);
 int ath9k_htc_cabq_setup(struct ath9k_htc_priv *priv);
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
index c480469..927bb27 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
@@ -275,6 +275,48 @@ void ath9k_htc_beaconep(void *drv_priv, struct sk_buff *skb,
 	dev_kfree_skb_any(skb);
 }
 
+static void ath9k_htc_send_buffered(struct ath9k_htc_priv *priv,
+				    int slot)
+{
+	struct ath_common *common = ath9k_hw_common(priv->ah);
+	struct ieee80211_vif *vif;
+	struct sk_buff *skb;
+	struct ieee80211_hdr *hdr;
+	int padpos, padsize, ret;
+
+	spin_lock_bh(&priv->beacon_lock);
+
+	vif = priv->cur_beacon_conf.bslot[slot];
+
+	skb = ieee80211_get_buffered_bc(priv->hw, vif);
+
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
+			ath_dbg(common, ATH_DBG_FATAL,
+				"Failed to send CAB frame\n");
+			dev_kfree_skb_any(skb);
+		}
+	next:
+		skb = ieee80211_get_buffered_bc(priv->hw, vif);
+	}
+
+	spin_unlock_bh(&priv->beacon_lock);
+}
+
 static void ath9k_htc_send_beacon(struct ath9k_htc_priv *priv,
 				  int slot)
 {
@@ -393,6 +435,7 @@ void ath9k_htc_swba(struct ath9k_htc_priv *priv)
 	}
 	spin_unlock_bh(&priv->beacon_lock);
 
+	ath9k_htc_send_buffered(priv, slot);
 	ath9k_htc_send_beacon(priv, slot);
 }
 
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index 37a41fe..dc96c06 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -748,7 +748,8 @@ static void ath9k_set_hw_capab(struct ath9k_htc_priv *priv,
 		IEEE80211_HW_HAS_RATE_CONTROL |
 		IEEE80211_HW_RX_INCLUDES_FCS |
 		IEEE80211_HW_SUPPORTS_PS |
-		IEEE80211_HW_PS_NULLFUNC_STACK;
+		IEEE80211_HW_PS_NULLFUNC_STACK |
+		IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING;
 
 	hw->wiphy->interface_modes =
 		BIT(NL80211_IFTYPE_STATION) |
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index 5f8e54c..cc05177 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -806,6 +806,9 @@ static ssize_t read_file_xmit(struct file *file, char __user *user_buf,
 	len += snprintf(buf + len, sizeof(buf) - len,
 			"%20s : %10u\n", "SKBs dropped",
 			priv->debug.tx_stats.skb_dropped);
+	len += snprintf(buf + len, sizeof(buf) - len,
+			"%20s : %10u\n", "CAB queued",
+			priv->debug.tx_stats.cab_queued);
 
 	len += snprintf(buf + len, sizeof(buf) - len,
 			"%20s : %10u\n", "BE queued",
@@ -1056,7 +1059,7 @@ static int ath9k_htc_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 		memmove(skb->data, skb->data + padsize, padpos);
 	}
 
-	ret = ath9k_htc_tx_start(priv, skb);
+	ret = ath9k_htc_tx_start(priv, skb, false);
 	if (ret != 0) {
 		if (ret == -ENOMEM) {
 			ath_dbg(ath9k_hw_common(priv->ah), ATH_DBG_XMIT,
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index 127a99b..3dd87a5 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -79,7 +79,8 @@ int ath_htc_txq_update(struct ath9k_htc_priv *priv, int qnum,
 	return error;
 }
 
-int ath9k_htc_tx_start(struct ath9k_htc_priv *priv, struct sk_buff *skb)
+int ath9k_htc_tx_start(struct ath9k_htc_priv *priv,
+		       struct sk_buff *skb, bool is_cab)
 {
 	struct ieee80211_hdr *hdr;
 	struct ieee80211_mgmt *mgmt;
@@ -170,6 +171,12 @@ int ath9k_htc_tx_start(struct ath9k_htc_priv *priv, struct sk_buff *skb)
 		tx_fhdr = skb_push(skb, sizeof(tx_hdr));
 		memcpy(tx_fhdr, (u8 *) &tx_hdr, sizeof(tx_hdr));
 
+		if (is_cab) {
+			CAB_STAT_INC;
+			epid = priv->cab_ep;
+			goto send;
+		}
+
 		qnum = skb_get_queue_mapping(skb);
 
 		switch (qnum) {
@@ -222,7 +229,7 @@ int ath9k_htc_tx_start(struct ath9k_htc_priv *priv, struct sk_buff *skb)
 		memcpy(tx_fhdr, (u8 *) &mgmt_hdr, sizeof(mgmt_hdr));
 		epid = priv->mgmt_ep;
 	}
-
+send:
 	return htc_send(priv->htc, skb, epid, &tx_ctl);
 }
 
@@ -326,7 +333,8 @@ void ath9k_htc_txep(void *drv_priv, struct sk_buff *skb,
 	} else if ((ep_id == priv->data_bk_ep) ||
 		   (ep_id == priv->data_be_ep) ||
 		   (ep_id == priv->data_vi_ep) ||
-		   (ep_id == priv->data_vo_ep)) {
+		   (ep_id == priv->data_vo_ep) ||
+		   (ep_id == priv->cab_ep)) {
 		skb_pull(skb, sizeof(struct tx_frame_hdr));
 	} else {
 		ath_err(common, "Unsupported TX EPID: %d\n", ep_id);
-- 
1.7.3.5

