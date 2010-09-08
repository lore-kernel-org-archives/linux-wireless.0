Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:35620 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756654Ab0IHX0E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Sep 2010 19:26:04 -0400
Received: by mail-pv0-f174.google.com with SMTP id 2so253118pvg.19
        for <linux-wireless@vger.kernel.org>; Wed, 08 Sep 2010 16:26:04 -0700 (PDT)
From: Steve deRosier <steve@cozybit.com>
To: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Cc: johannes@sipsolutions.net, javier@cozybit.com,
	Steve deRosier <steve@cozybit.com>
Subject: [PATCH 8/9] libertas_tf: updated with beacon code
Date: Wed,  8 Sep 2010 16:25:28 -0700
Message-Id: <1283988329-44549-9-git-send-email-steve@cozybit.com>
In-Reply-To: <1283988329-44549-1-git-send-email-steve@cozybit.com>
References: <1283988329-44549-1-git-send-email-steve@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Steve deRosier <steve@cozybit.com>
---
 drivers/net/wireless/libertas_tf/cmd.c         |    2 +-
 drivers/net/wireless/libertas_tf/if_sdio.c     |    5 +-
 drivers/net/wireless/libertas_tf/libertas_tf.h |    6 ++
 drivers/net/wireless/libertas_tf/main.c        |   88 ++++++++++++++++++------
 4 files changed, 78 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/libertas_tf/cmd.c b/drivers/net/wireless/libertas_tf/cmd.c
index 738a2ff..8c15e35 100644
--- a/drivers/net/wireless/libertas_tf/cmd.c
+++ b/drivers/net/wireless/libertas_tf/cmd.c
@@ -354,7 +354,7 @@ void lbtf_set_bssid(struct lbtf_private *priv, bool activate, const u8 *bssid)
 {
 	struct cmd_ds_set_bssid cmd;
 	lbtf_deb_enter(LBTF_DEB_CMD);
-
+	lbtf_deb_cmd("Set BSSID: %pM a: %d", bssid, activate);
 	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
 	cmd.activate = activate ? 1 : 0;
 	if (activate)
diff --git a/drivers/net/wireless/libertas_tf/if_sdio.c b/drivers/net/wireless/libertas_tf/if_sdio.c
index 5074f8b..09c028f 100644
--- a/drivers/net/wireless/libertas_tf/if_sdio.c
+++ b/drivers/net/wireless/libertas_tf/if_sdio.c
@@ -303,8 +303,11 @@ static int if_sdio_handle_event(struct if_sdio_card *card,
 			failure = (tmp & 0xff00) >> 8;
 			lbtf_deb_stats("Got feedback event. retry: %d, failure: %d", retrycnt, failure);
 			lbtf_send_tx_feedback(card->priv, retrycnt, failure);
-		} else if (event == LBTF_EVENT_BCN_SENT)
+		} else if (event == LBTF_EVENT_BCN_SENT) {
 			lbtf_bcn_sent(card->priv);
+		} else {
+			lbtf_deb_stats("UNKNOWN HOST EVENT: 0x%x", event);
+		}
 
 	ret = 0;
 
diff --git a/drivers/net/wireless/libertas_tf/libertas_tf.h b/drivers/net/wireless/libertas_tf/libertas_tf.h
index c7588fd..db6dd7b 100644
--- a/drivers/net/wireless/libertas_tf/libertas_tf.h
+++ b/drivers/net/wireless/libertas_tf/libertas_tf.h
@@ -241,6 +241,8 @@ struct lbtf_private {
 
 	struct sk_buff *skb_to_tx;
 	struct sk_buff *tx_skb;
+	struct sk_buff *tx_skb_old;
+	struct sk_buff_head tx_skb_buf;
 
 	/** NIC Operation characteristics */
 	u16 mac_control;
@@ -267,6 +269,10 @@ struct lbtf_private {
 	u8 resp_idx;
 	u8 resp_buf[2][LBS_UPLD_SIZE];
 	u32 resp_len[2];
+	
+	/* beacon status info */
+	bool beacon_enable;
+	u16 beacon_int;
 
 };
 
diff --git a/drivers/net/wireless/libertas_tf/main.c b/drivers/net/wireless/libertas_tf/main.c
index cc2217c..6c4a1b6 100644
--- a/drivers/net/wireless/libertas_tf/main.c
+++ b/drivers/net/wireless/libertas_tf/main.c
@@ -272,6 +272,7 @@ static void lbtf_tx_work(struct work_struct *work)
 	if (priv->vif &&
 		 (priv->vif->type == NL80211_IFTYPE_AP) &&
 		 (!skb_queue_empty(&priv->bc_ps_buf))) {
+		lbtf_deb_tx("bc_ps_buf");
 		skb = skb_dequeue(&priv->bc_ps_buf);
 	}
 	else if (priv->skb_to_tx) {
@@ -306,15 +307,13 @@ static void lbtf_tx_work(struct work_struct *work)
 
 	lbtf_deb_hex(LBTF_DEB_TX, "TX Data ", skb->data, min_t(unsigned int, skb->len, 100));
 
-	WARN_ON(priv->tx_skb);
-
 	spin_lock_irq(&priv->driver_lock);
-	priv->tx_skb = skb;
+	skb_queue_tail(&priv->tx_skb_buf, skb);
 	err = priv->hw_host_to_card(priv, MVMS_DAT, skb->data, skb->len);
 	spin_unlock_irq(&priv->driver_lock);
 	if (err) {
 		dev_kfree_skb_any(skb);
-		priv->tx_skb = NULL;
+		skb_dequeue_tail(&priv->tx_skb_buf);
 		pr_err("TX error: %d", err);
 	}
 	lbtf_deb_tx("TX success");
@@ -417,8 +416,10 @@ static int lbtf_op_add_interface(struct ieee80211_hw *hw,
 	u8 null_addr[ETH_ALEN] = {0};
 	struct lbtf_private *priv = hw->priv;
 	lbtf_deb_enter(LBTF_DEB_MACOPS);
-	if (priv->vif != NULL)
+	if (priv->vif != NULL) {
+		lbtf_deb_macops("priv->vif != NULL");
 		return -EOPNOTSUPP;
+	}
 
 	priv->vif = vif;
 	switch (vif->type) {
@@ -431,6 +432,7 @@ static int lbtf_op_add_interface(struct ieee80211_hw *hw,
 		break;
 	default:
 		priv->vif = NULL;
+		lbtf_deb_macops("Unsupported interface mode: %d", vif->type);
 		return -EOPNOTSUPP;
 	}
 
@@ -548,7 +550,10 @@ static void lbtf_op_bss_info_changed(struct ieee80211_hw *hw,
 	struct sk_buff *beacon;
 	lbtf_deb_enter(LBTF_DEB_MACOPS);
 
-	if (changes & (BSS_CHANGED_BEACON | BSS_CHANGED_BEACON_INT)) {
+	lbtf_deb_macops("bss info changed: 0x%x", changes);
+	if (changes & (BSS_CHANGED_BEACON | 
+	               BSS_CHANGED_BEACON_INT | 
+	               BSS_CHANGED_BEACON_ENABLED)) {
 		switch (priv->vif->type) {
 		case NL80211_IFTYPE_AP:
 		case NL80211_IFTYPE_MESH_POINT:
@@ -556,7 +561,10 @@ static void lbtf_op_bss_info_changed(struct ieee80211_hw *hw,
 			if (beacon) {
 				lbtf_beacon_set(priv, beacon);
 				kfree_skb(beacon);
-				lbtf_beacon_ctrl(priv, 1,
+				priv->beacon_enable = bss_conf->enable_beacon;
+				priv->beacon_int = bss_conf->beacon_int;
+				lbtf_set_bssid(priv, 1, bss_conf->bssid);
+				lbtf_beacon_ctrl(priv, bss_conf->enable_beacon,
 						 bss_conf->beacon_int);
 			}
 			break;
@@ -565,6 +573,21 @@ static void lbtf_op_bss_info_changed(struct ieee80211_hw *hw,
 		}
 	}
 
+	if (changes & (BSS_CHANGED_BEACON_INT | 
+	               BSS_CHANGED_BEACON_ENABLED)) {
+		switch (priv->vif->type) {
+		case NL80211_IFTYPE_AP:
+		case NL80211_IFTYPE_MESH_POINT:
+				priv->beacon_enable = bss_conf->enable_beacon;
+				priv->beacon_int = bss_conf->beacon_int;
+				lbtf_beacon_ctrl(priv, bss_conf->enable_beacon,
+						 bss_conf->beacon_int);
+			break;
+		default:
+			break;
+		}
+	}
+
 	if (changes & BSS_CHANGED_BSSID) {
 		bool activate = !is_zero_ether_addr(bss_conf->bssid);
 		lbtf_set_bssid(priv, activate, bss_conf->bssid);
@@ -688,6 +711,7 @@ struct lbtf_private *lbtf_add_card(void *card, struct device *dmdev, u8 mac_addr
 	priv->hw = hw;
 	priv->card = card;
 	priv->tx_skb = NULL;
+	priv->tx_skb_old = NULL;
 
 	hw->queues = 1;
 	hw->flags = IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING;
@@ -701,8 +725,11 @@ struct lbtf_private *lbtf_add_card(void *card, struct device *dmdev, u8 mac_addr
 	hw->wiphy->bands[IEEE80211_BAND_2GHZ] = &priv->band;
 	hw->wiphy->interface_modes =
 		BIT(NL80211_IFTYPE_STATION) |
-		BIT(NL80211_IFTYPE_ADHOC);
+		BIT(NL80211_IFTYPE_ADHOC) |
+		BIT(NL80211_IFTYPE_AP) |
+		BIT(NL80211_IFTYPE_MESH_POINT);
 	skb_queue_head_init(&priv->bc_ps_buf);
+	skb_queue_head_init(&priv->tx_skb_buf);
 
 	SET_IEEE80211_DEV(hw, dmdev);
 
@@ -758,15 +785,20 @@ EXPORT_SYMBOL_GPL(lbtf_remove_card);
 void lbtf_send_tx_feedback(struct lbtf_private *priv, u8 retrycnt, u8 fail)
 {
 	struct ieee80211_tx_info *info;
+	struct sk_buff *skb = NULL;
 	lbtf_deb_enter(LBTF_DEB_MAIN);
 
-	if(priv->tx_skb == 0) {
-		lbtf_deb_stats("tx_skb is null");
+	if (!skb_queue_empty(&priv->tx_skb_buf)) {
+		skb = skb_dequeue(&priv->tx_skb_buf);
+	}
+	
+	if(skb == 0) {
+		lbtf_deb_stats("skb is null");
 	} else {
 
-		lbtf_deb_stats("tx_skb is ok");
+		lbtf_deb_stats("skb is ok");
 
-		info = IEEE80211_SKB_CB(priv->tx_skb);
+		info = IEEE80211_SKB_CB(skb);
 		ieee80211_tx_info_clear_status(info);
 		/*
 		 * Commented out, otherwise we never go beyond 1Mbit/s using mac80211
@@ -777,15 +809,14 @@ void lbtf_send_tx_feedback(struct lbtf_private *priv, u8 retrycnt, u8 fail)
 		if (!(info->flags & IEEE80211_TX_CTL_NO_ACK) && !fail) {
 			info->flags |= IEEE80211_TX_STAT_ACK;
 		}
-		skb_pull(priv->tx_skb, sizeof(struct txpd));
-		ieee80211_tx_status_irqsafe(priv->hw, priv->tx_skb);
+		skb_pull(skb, sizeof(struct txpd));
+		ieee80211_tx_status_irqsafe(priv->hw, skb);
 	}
 
-		priv->tx_skb = NULL;
-		if (!priv->skb_to_tx && skb_queue_empty(&priv->bc_ps_buf))
-			ieee80211_wake_queues(priv->hw);
-		else
-			queue_work(lbtf_wq, &priv->tx_work);
+	if (!priv->skb_to_tx && skb_queue_empty(&priv->bc_ps_buf))
+		ieee80211_wake_queues(priv->hw);
+	else
+		queue_work(lbtf_wq, &priv->tx_work);
 
 	lbtf_deb_leave(LBTF_DEB_MAIN);
 }
@@ -810,7 +841,7 @@ void lbtf_host_to_card_done(struct lbtf_private *priv )
 		lbtf_deb_main("Got done on command.");
 	}
 
-	lbtf_deb_leave(LBTF_DEB_THREAD);
+	lbtf_deb_leave(LBTF_DEB_MAIN);
 }
 EXPORT_SYMBOL_GPL(lbtf_host_to_card_done);
 
@@ -818,6 +849,18 @@ void lbtf_bcn_sent(struct lbtf_private *priv)
 {
 	struct sk_buff *skb = NULL;
 
+	lbtf_deb_enter(LBTF_DEB_MAIN);
+
+	if (!priv) {
+		lbtf_deb_main("got bcn sent with priv == NULL");
+		return;
+	}
+
+	if (!priv->vif) {
+		lbtf_deb_main("got bcn sent with vif == NULL");
+		return;
+	}
+
 	if (priv->vif->type != NL80211_IFTYPE_AP)
 		return;
 
@@ -837,9 +880,12 @@ void lbtf_bcn_sent(struct lbtf_private *priv)
 	skb = ieee80211_beacon_get(priv->hw, priv->vif);
 
 	if (skb) {
-		lbtf_beacon_set(priv, skb);
+ 		lbtf_beacon_set(priv, skb);
 		kfree_skb(skb);
+ 		lbtf_beacon_ctrl(priv, priv->beacon_enable, priv->beacon_int);
 	}
+
+	lbtf_deb_leave(LBTF_DEB_MAIN);
 }
 EXPORT_SYMBOL_GPL(lbtf_bcn_sent);
 
-- 
1.7.0

