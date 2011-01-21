Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:40986 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103Ab1AUC7w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Jan 2011 21:59:52 -0500
Received: by iyj18 with SMTP id 18so1245111iyj.19
        for <linux-wireless@vger.kernel.org>; Thu, 20 Jan 2011 18:59:52 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19768.63097.509242.367090@gargle.gargle.HOWL>
Date: Fri, 21 Jan 2011 08:29:05 +0530
To: linux-wireless@vger.kernel.org
CC: ath9k-devel@lists.ath9k.org
Subject: [RFC/WIP 01/33] ath9k_htc: Allow upto two simultaneous interfaces
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <Sujith.Manoharan@atheros.com>

Multiple interfaces can be configured if a slot is free
on the target. Monitor mode also requires a slot.

The maximum number of stations that can be handled in
the firmware is 8, manage the station slots accordingly.

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc.h          |    7 +
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |  148 +++++++++++++++++--------
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c |   29 ++++-
 3 files changed, 130 insertions(+), 54 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index 6354986..ff6bfd9 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -204,6 +204,8 @@ struct ath9k_htc_target_stats {
 	__be32 ht_tx_xretries;
 } __packed;
 
+#define ATH9K_HTC_MAX_VIF 2
+
 struct ath9k_htc_vif {
 	u8 index;
 };
@@ -358,6 +360,11 @@ struct ath9k_htc_priv {
 	enum htc_endpoint_id data_vi_ep;
 	enum htc_endpoint_id data_vo_ep;
 
+	u8 vif_slot;
+	u8 mon_vif_idx;
+	u8 sta_slot;
+	u8 vif_sta_pos[ATH9K_HTC_MAX_VIF];
+
 	u16 op_flags;
 	u16 curtxpow;
 	u16 txpowlimit;
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index f14f37d..e8e512a 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -236,6 +236,13 @@ err:
 	return ret;
 }
 
+/*
+ * Monitor mode handling is a tad complicated because the firmware requires
+ * an interface to be created exclusively, while mac80211 doesn't associate
+ * an interface with the mode.
+ *
+ * So, for now, only one monitor interface can be configured.
+ */
 static void __ath9k_htc_remove_monitor_interface(struct ath9k_htc_priv *priv)
 {
 	struct ath_common *common = ath9k_hw_common(priv->ah);
@@ -245,9 +252,10 @@ static void __ath9k_htc_remove_monitor_interface(struct ath9k_htc_priv *priv)
 
 	memset(&hvif, 0, sizeof(struct ath9k_htc_target_vif));
 	memcpy(&hvif.myaddr, common->macaddr, ETH_ALEN);
-	hvif.index = 0; /* Should do for now */
+	hvif.index = priv->mon_vif_idx;
 	WMI_CMD_BUF(WMI_VAP_REMOVE_CMDID, &hvif);
 	priv->nvifs--;
+	priv->vif_slot &= ~(1 << priv->mon_vif_idx);
 }
 
 static int ath9k_htc_add_monitor_interface(struct ath9k_htc_priv *priv)
@@ -255,51 +263,69 @@ static int ath9k_htc_add_monitor_interface(struct ath9k_htc_priv *priv)
 	struct ath_common *common = ath9k_hw_common(priv->ah);
 	struct ath9k_htc_target_vif hvif;
 	struct ath9k_htc_target_sta tsta;
-	int ret = 0;
+	int ret = 0, sta_idx;
 	u8 cmd_rsp;
 
-	if (priv->nvifs > 0)
-		return -ENOBUFS;
+	if ((priv->nvifs >= ATH9K_HTC_MAX_VIF) ||
+	    (priv->nstations >= ATH9K_HTC_MAX_STA)) {
+		ret = -ENOBUFS;
+		goto err_vif;
+	}
 
-	if (priv->nstations >= ATH9K_HTC_MAX_STA)
-		return -ENOBUFS;
+	sta_idx = ffz(priv->sta_slot);
+	if ((sta_idx < 0) || (sta_idx > ATH9K_HTC_MAX_STA)) {
+		ret = -ENOBUFS;
+		goto err_vif;
+	}
 
 	/*
 	 * Add an interface.
 	 */
-
 	memset(&hvif, 0, sizeof(struct ath9k_htc_target_vif));
 	memcpy(&hvif.myaddr, common->macaddr, ETH_ALEN);
 
 	hvif.opmode = cpu_to_be32(HTC_M_MONITOR);
-	priv->ah->opmode = NL80211_IFTYPE_MONITOR;
-	hvif.index = priv->nvifs;
+	hvif.index = ffz(priv->vif_slot);
 
 	WMI_CMD_BUF(WMI_VAP_CREATE_CMDID, &hvif);
 	if (ret)
-		return ret;
+		goto err_vif;
+
+	/*
+	 * Assign the monitor interface index as a special case here.
+	 * This is needed when the interface is brought down.
+	 */
+	priv->mon_vif_idx = hvif.index;
+	priv->vif_slot |= (1 << hvif.index);
+
+	/*
+	 * Set the hardware mode to monitor only if there are no
+	 * other interfaces.
+	 */
+	if (!priv->nvifs)
+		priv->ah->opmode = NL80211_IFTYPE_MONITOR;
 
 	priv->nvifs++;
 
 	/*
 	 * Associate a station with the interface for packet injection.
 	 */
-
 	memset(&tsta, 0, sizeof(struct ath9k_htc_target_sta));
 
 	memcpy(&tsta.macaddr, common->macaddr, ETH_ALEN);
 
 	tsta.is_vif_sta = 1;
-	tsta.sta_index = priv->nstations;
+	tsta.sta_index = sta_idx;
 	tsta.vif_index = hvif.index;
 	tsta.maxampdu = 0xffff;
 
 	WMI_CMD_BUF(WMI_NODE_CREATE_CMDID, &tsta);
 	if (ret) {
 		ath_err(common, "Unable to add station entry for monitor mode\n");
-		goto err_vif;
+		goto err_sta;
 	}
 
+	priv->sta_slot |= (1 << sta_idx);
 	priv->nstations++;
 
 	/*
@@ -310,15 +336,23 @@ static int ath9k_htc_add_monitor_interface(struct ath9k_htc_priv *priv)
 		ath_dbg(common, ATH_DBG_CONFIG,
 			"Failed to update capability in target\n");
 
+	priv->vif_sta_pos[priv->mon_vif_idx] = sta_idx;
 	priv->ah->is_monitoring = true;
 
+	ath_dbg(common, ATH_DBG_CONFIG,
+		"Attached a monitor interface at idx: %d, sta idx: %d\n",
+		priv->mon_vif_idx, sta_idx);
+
 	return 0;
 
-err_vif:
+err_sta:
 	/*
 	 * Remove the interface from the target.
 	 */
 	__ath9k_htc_remove_monitor_interface(priv);
+err_vif:
+	ath_dbg(common, ATH_DBG_FATAL, "Unable to attach a monitor interface\n");
+
 	return ret;
 }
 
@@ -330,7 +364,7 @@ static int ath9k_htc_remove_monitor_interface(struct ath9k_htc_priv *priv)
 
 	__ath9k_htc_remove_monitor_interface(priv);
 
-	sta_idx = 0; /* Only single interface, for now */
+	sta_idx = priv->vif_sta_pos[priv->mon_vif_idx];
 
 	WMI_CMD_BUF(WMI_NODE_REMOVE_CMDID, &sta_idx);
 	if (ret) {
@@ -338,9 +372,14 @@ static int ath9k_htc_remove_monitor_interface(struct ath9k_htc_priv *priv)
 		return ret;
 	}
 
+	priv->sta_slot &= ~(1 << sta_idx);
 	priv->nstations--;
 	priv->ah->is_monitoring = false;
 
+	ath_dbg(common, ATH_DBG_CONFIG,
+		"Removed a monitor interface at idx: %d, sta idx: %d\n",
+		priv->mon_vif_idx, sta_idx);
+
 	return 0;
 }
 
@@ -352,12 +391,16 @@ static int ath9k_htc_add_station(struct ath9k_htc_priv *priv,
 	struct ath9k_htc_target_sta tsta;
 	struct ath9k_htc_vif *avp = (struct ath9k_htc_vif *) vif->drv_priv;
 	struct ath9k_htc_sta *ista;
-	int ret;
+	int ret, sta_idx;
 	u8 cmd_rsp;
 
 	if (priv->nstations >= ATH9K_HTC_MAX_STA)
 		return -ENOBUFS;
 
+	sta_idx = ffz(priv->sta_slot);
+	if ((sta_idx < 0) || (sta_idx > ATH9K_HTC_MAX_STA))
+		return -ENOBUFS;
+
 	memset(&tsta, 0, sizeof(struct ath9k_htc_target_sta));
 
 	if (sta) {
@@ -367,13 +410,13 @@ static int ath9k_htc_add_station(struct ath9k_htc_priv *priv,
 		tsta.associd = common->curaid;
 		tsta.is_vif_sta = 0;
 		tsta.valid = true;
-		ista->index = priv->nstations;
+		ista->index = sta_idx;
 	} else {
 		memcpy(&tsta.macaddr, vif->addr, ETH_ALEN);
 		tsta.is_vif_sta = 1;
 	}
 
-	tsta.sta_index = priv->nstations;
+	tsta.sta_index = sta_idx;
 	tsta.vif_index = avp->index;
 	tsta.maxampdu = 0xffff;
 	if (sta && sta->ht_cap.ht_supported)
@@ -388,12 +431,21 @@ static int ath9k_htc_add_station(struct ath9k_htc_priv *priv,
 		return ret;
 	}
 
-	if (sta)
+	if (sta) {
 		ath_dbg(common, ATH_DBG_CONFIG,
 			"Added a station entry for: %pM (idx: %d)\n",
 			sta->addr, tsta.sta_index);
+	} else {
+		ath_dbg(common, ATH_DBG_CONFIG,
+			"Added a station entry for VIF %d (idx: %d)\n",
+			avp->index, tsta.sta_index);
+	}
 
+	priv->sta_slot |= (1 << sta_idx);
 	priv->nstations++;
+	if (!sta)
+		priv->vif_sta_pos[avp->index] = sta_idx;
+
 	return 0;
 }
 
@@ -402,6 +454,7 @@ static int ath9k_htc_remove_station(struct ath9k_htc_priv *priv,
 				    struct ieee80211_sta *sta)
 {
 	struct ath_common *common = ath9k_hw_common(priv->ah);
+	struct ath9k_htc_vif *avp = (struct ath9k_htc_vif *) vif->drv_priv;
 	struct ath9k_htc_sta *ista;
 	int ret;
 	u8 cmd_rsp, sta_idx;
@@ -410,7 +463,7 @@ static int ath9k_htc_remove_station(struct ath9k_htc_priv *priv,
 		ista = (struct ath9k_htc_sta *) sta->drv_priv;
 		sta_idx = ista->index;
 	} else {
-		sta_idx = 0;
+		sta_idx = priv->vif_sta_pos[avp->index];
 	}
 
 	WMI_CMD_BUF(WMI_NODE_REMOVE_CMDID, &sta_idx);
@@ -422,12 +475,19 @@ static int ath9k_htc_remove_station(struct ath9k_htc_priv *priv,
 		return ret;
 	}
 
-	if (sta)
+	if (sta) {
 		ath_dbg(common, ATH_DBG_CONFIG,
 			"Removed a station entry for: %pM (idx: %d)\n",
 			sta->addr, sta_idx);
+	} else {
+		ath_dbg(common, ATH_DBG_CONFIG,
+			"Removed a station entry for VIF %d (idx: %d)\n",
+			avp->index, sta_idx);
+	}
 
+	priv->sta_slot &= ~(1 << sta_idx);
 	priv->nstations--;
+
 	return 0;
 }
 
@@ -1047,21 +1107,16 @@ static void ath9k_htc_stop(struct ieee80211_hw *hw)
 	WMI_CMD(WMI_STOP_RECV_CMDID);
 	skb_queue_purge(&priv->tx_queue);
 
-	/* Remove monitor interface here */
-	if (ah->opmode == NL80211_IFTYPE_MONITOR) {
-		if (ath9k_htc_remove_monitor_interface(priv))
-			ath_err(common, "Unable to remove monitor interface\n");
-		else
-			ath_dbg(common, ATH_DBG_CONFIG,
-				"Monitor interface removed\n");
-	}
-
 	if (ah->btcoex_hw.enabled) {
 		ath9k_hw_btcoex_disable(ah);
 		if (ah->btcoex_hw.scheme == ATH_BTCOEX_CFG_3WIRE)
 			ath_htc_cancel_btcoex_work(priv);
 	}
 
+	/* Remove a monitor interface if it's present. */
+	if (priv->ah->is_monitoring)
+		ath9k_htc_remove_monitor_interface(priv);
+
 	ath9k_hw_phy_disable(ah);
 	ath9k_hw_disable(ah);
 	ath9k_htc_ps_restore(priv);
@@ -1085,8 +1140,7 @@ static int ath9k_htc_add_interface(struct ieee80211_hw *hw,
 
 	mutex_lock(&priv->mutex);
 
-	/* Only one interface for now */
-	if (priv->nvifs > 0) {
+	if (priv->nvifs >= ATH9K_HTC_MAX_VIF) {
 		ret = -ENOBUFS;
 		goto out;
 	}
@@ -1109,13 +1163,8 @@ static int ath9k_htc_add_interface(struct ieee80211_hw *hw,
 		goto out;
 	}
 
-	ath_dbg(common, ATH_DBG_CONFIG,
-		"Attach a VIF of type: %d\n", vif->type);
-
-	priv->ah->opmode = vif->type;
-
 	/* Index starts from zero on the target */
-	avp->index = hvif.index = priv->nvifs;
+	avp->index = hvif.index = ffz(priv->vif_slot);
 	hvif.rtsthreshold = cpu_to_be16(2304);
 	WMI_CMD_BUF(WMI_VAP_CREATE_CMDID, &hvif);
 	if (ret)
@@ -1136,7 +1185,13 @@ static int ath9k_htc_add_interface(struct ieee80211_hw *hw,
 		ath_dbg(common, ATH_DBG_CONFIG,
 			"Failed to update capability in target\n");
 
+	priv->ah->opmode = vif->type;
+	priv->vif_slot |= (1 << avp->index);
 	priv->vif = vif;
+
+	ath_dbg(common, ATH_DBG_CONFIG,
+		"Attach a VIF of type: %d at idx: %d\n", vif->type, avp->index);
+
 out:
 	ath9k_htc_ps_restore(priv);
 	mutex_unlock(&priv->mutex);
@@ -1154,8 +1209,6 @@ static void ath9k_htc_remove_interface(struct ieee80211_hw *hw,
 	int ret = 0;
 	u8 cmd_rsp;
 
-	ath_dbg(common, ATH_DBG_CONFIG, "Detach Interface\n");
-
 	mutex_lock(&priv->mutex);
 	ath9k_htc_ps_wakeup(priv);
 
@@ -1164,10 +1217,13 @@ static void ath9k_htc_remove_interface(struct ieee80211_hw *hw,
 	hvif.index = avp->index;
 	WMI_CMD_BUF(WMI_VAP_REMOVE_CMDID, &hvif);
 	priv->nvifs--;
+	priv->vif_slot &= ~(1 << avp->index);
 
 	ath9k_htc_remove_station(priv, vif, NULL);
 	priv->vif = NULL;
 
+	ath_dbg(common, ATH_DBG_CONFIG, "Detach Interface at idx: %d\n", avp->index);
+
 	ath9k_htc_ps_restore(priv);
 	mutex_unlock(&priv->mutex);
 }
@@ -1203,13 +1259,11 @@ static int ath9k_htc_config(struct ieee80211_hw *hw, u32 changed)
 	 * IEEE80211_CONF_CHANGE_CHANNEL is handled.
 	 */
 	if (changed & IEEE80211_CONF_CHANGE_MONITOR) {
-		if (conf->flags & IEEE80211_CONF_MONITOR) {
-			if (ath9k_htc_add_monitor_interface(priv))
-				ath_err(common, "Failed to set monitor mode\n");
-			else
-				ath_dbg(common, ATH_DBG_CONFIG,
-					"HW opmode set to Monitor mode\n");
-		}
+		if ((conf->flags & IEEE80211_CONF_MONITOR) &&
+		    !priv->ah->is_monitoring)
+			ath9k_htc_add_monitor_interface(priv);
+		else if (priv->ah->is_monitoring)
+			ath9k_htc_remove_monitor_interface(priv);
 	}
 
 	if (changed & IEEE80211_CONF_CHANGE_CHANNEL) {
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index 7a5ffca..d5f0f41 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -84,7 +84,9 @@ int ath9k_htc_tx_start(struct ath9k_htc_priv *priv, struct sk_buff *skb)
 	struct ieee80211_hdr *hdr;
 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_sta *sta = tx_info->control.sta;
+	struct ieee80211_vif *vif = tx_info->control.vif;
 	struct ath9k_htc_sta *ista;
+	struct ath9k_htc_vif *avp;
 	struct ath9k_htc_tx_ctl tx_ctl;
 	enum htc_endpoint_id epid;
 	u16 qnum;
@@ -95,18 +97,31 @@ int ath9k_htc_tx_start(struct ath9k_htc_priv *priv, struct sk_buff *skb)
 	hdr = (struct ieee80211_hdr *) skb->data;
 	fc = hdr->frame_control;
 
-	if (tx_info->control.vif &&
-			(struct ath9k_htc_vif *) tx_info->control.vif->drv_priv)
-		vif_idx = ((struct ath9k_htc_vif *)
-				tx_info->control.vif->drv_priv)->index;
-	else
-		vif_idx = priv->nvifs;
+	/*
+	 * Find out on which interface this packet has to be
+	 * sent out.
+	 */
+	if (vif) {
+		avp = (struct ath9k_htc_vif *) vif->drv_priv;
+		vif_idx = avp->index;
+	} else {
+		if (!priv->ah->is_monitoring) {
+			ath_dbg(ath9k_hw_common(priv->ah), ATH_DBG_XMIT,
+				"VIF is null, but no monitor interface !\n");
+			return -EINVAL;
+		}
 
+		vif_idx = priv->mon_vif_idx;
+	}
+
+	/*
+	 * Find out which station this packet is destined for.
+	 */
 	if (sta) {
 		ista = (struct ath9k_htc_sta *) sta->drv_priv;
 		sta_idx = ista->index;
 	} else {
-		sta_idx = 0;
+		sta_idx = priv->vif_sta_pos[vif_idx];
 	}
 
 	memset(&tx_ctl, 0, sizeof(struct ath9k_htc_tx_ctl));
-- 
1.7.3.5

