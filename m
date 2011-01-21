Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:34731 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751854Ab1AUDCi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Jan 2011 22:02:38 -0500
Received: by pzk35 with SMTP id 35so218284pzk.19
        for <linux-wireless@vger.kernel.org>; Thu, 20 Jan 2011 19:02:38 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19768.63264.224607.272161@gargle.gargle.HOWL>
Date: Fri, 21 Jan 2011 08:31:52 +0530
To: linux-wireless@vger.kernel.org
CC: ath9k-devel@lists.ath9k.org
Subject: [RFC/WIP 18/33] ath9k_htc: Add beacon slots
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <Sujith.Manoharan@atheros.com>

Beacon transmission is now handled through a slot mechanism.
This allows multiple beaconing interfaces to be be present.

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc.h            |   13 ++-
 drivers/net/wireless/ath/ath9k/htc_drv_beacon.c |  126 ++++++++++++++++++++---
 drivers/net/wireless/ath/ath9k/htc_drv_init.c   |    5 +-
 drivers/net/wireless/ath/ath9k/htc_drv_main.c   |   12 ++-
 drivers/net/wireless/ath/ath9k/wmi.c            |    4 +-
 5 files changed, 140 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index 4c11ffe..6b3f0f3 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -243,6 +243,7 @@ struct ath9k_htc_target_stats {
 struct ath9k_htc_vif {
 	u8 index;
 	u16 seq_no;
+	int bslot;
 };
 
 struct ath9k_vif_iter_data {
@@ -350,10 +351,14 @@ struct ath_led {
 	int brightness;
 };
 
+#define BSTUCK_THRESHOLD 10
+
 struct htc_beacon_config {
+	struct ieee80211_vif *bslot[ATH9K_HTC_MAX_BCN_VIF];
 	u16 beacon_interval;
 	u16 dtim_period;
 	u16 bmiss_timeout;
+	u32 bmiss_cnt;
 };
 
 struct ath_btcoex {
@@ -409,7 +414,6 @@ struct ath9k_htc_priv {
 	u16 txpowlimit;
 	u16 nvifs;
 	u16 nstations;
-	u32 bmiss_cnt;
 	bool rearm_ani;
 	bool reconfig_beacon;
 
@@ -420,7 +424,6 @@ struct ath9k_htc_priv {
 	bool tx_queues_stop;
 	spinlock_t tx_lock;
 
-	struct ieee80211_vif *vif;
 	struct htc_beacon_config cur_beacon_conf;
 	unsigned int rxfilter;
 	struct tasklet_struct swba_tasklet;
@@ -468,11 +471,15 @@ static inline void ath_read_cachesize(struct ath_common *common, int *csz)
 
 void ath9k_htc_reset(struct ath9k_htc_priv *priv);
 
+void ath9k_htc_assign_bslot(struct ath9k_htc_priv *priv,
+			    struct ieee80211_vif *vif);
+void ath9k_htc_remove_bslot(struct ath9k_htc_priv *priv,
+			    struct ieee80211_vif *vif);
 void ath9k_htc_beaconq_config(struct ath9k_htc_priv *priv);
 void ath9k_htc_beacon_config(struct ath9k_htc_priv *priv,
 			     struct ieee80211_vif *vif);
 void ath9k_htc_beacon_reconfig(struct ath9k_htc_priv *priv);
-void ath9k_htc_swba(struct ath9k_htc_priv *priv, u8 beacon_pending);
+void ath9k_htc_swba(struct ath9k_htc_priv *priv);
 
 void ath9k_htc_rxep(void *priv, struct sk_buff *skb,
 		    enum htc_endpoint_id ep_id);
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
index e897a56..b4431a9 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
@@ -173,12 +173,14 @@ static void ath9k_htc_beacon_config_ap(struct ath9k_htc_priv *priv,
 		imask |= ATH9K_INT_SWBA;
 
 	ath_dbg(common, ATH_DBG_CONFIG,
-		"AP Beacon config, intval: %d, nexttbtt: %u imask: 0x%x\n",
-		bss_conf->beacon_interval, nexttbtt, imask);
+		"AP Beacon config, intval: %d, nexttbtt: %u "
+		"imask: 0x%x, tsf_reset: %d\n",
+		bss_conf->beacon_interval, nexttbtt, imask,
+		!!(intval & ATH9K_BEACON_RESET_TSF));
 
 	WMI_CMD(WMI_DISABLE_INTR_CMDID);
 	ath9k_hw_beaconinit(priv->ah, nexttbtt, intval);
-	priv->bmiss_cnt = 0;
+	priv->cur_beacon_conf.bmiss_cnt = 0;
 	htc_imask = cpu_to_be32(imask);
 	WMI_CMD_BUF(WMI_ENABLE_INTR_CMDID, &htc_imask);
 }
@@ -205,7 +207,7 @@ static void ath9k_htc_beacon_config_adhoc(struct ath9k_htc_priv *priv,
 
 	WMI_CMD(WMI_DISABLE_INTR_CMDID);
 	ath9k_hw_beaconinit(priv->ah, nexttbtt, intval);
-	priv->bmiss_cnt = 0;
+	priv->cur_beacon_conf.bmiss_cnt = 0;
 	htc_imask = cpu_to_be32(imask);
 	WMI_CMD_BUF(WMI_ENABLE_INTR_CMDID, &htc_imask);
 }
@@ -216,9 +218,11 @@ void ath9k_htc_beaconep(void *drv_priv, struct sk_buff *skb,
 	dev_kfree_skb_any(skb);
 }
 
-void ath9k_htc_swba(struct ath9k_htc_priv *priv, u8 beacon_pending)
+static void ath9k_htc_send_beacon(struct ath9k_htc_priv *priv,
+				  int slot)
 {
-	struct ath9k_htc_vif *avp = (void *)priv->vif->drv_priv;
+	struct ieee80211_vif *vif;
+	struct ath9k_htc_vif *avp;
 	struct tx_beacon_header beacon_hdr;
 	struct ath9k_htc_tx_ctl tx_ctl;
 	struct ieee80211_tx_info *info;
@@ -228,21 +232,18 @@ void ath9k_htc_swba(struct ath9k_htc_priv *priv, u8 beacon_pending)
 	memset(&beacon_hdr, 0, sizeof(struct tx_beacon_header));
 	memset(&tx_ctl, 0, sizeof(struct ath9k_htc_tx_ctl));
 
-	/* FIXME: Handle BMISS */
-	if (beacon_pending != 0) {
-		priv->bmiss_cnt++;
-		return;
-	}
-
 	spin_lock_bh(&priv->beacon_lock);
 
+	vif = priv->cur_beacon_conf.bslot[slot];
+	avp = (struct ath9k_htc_vif *)vif->drv_priv;
+
 	if (unlikely(priv->op_flags & OP_SCANNING)) {
 		spin_unlock_bh(&priv->beacon_lock);
 		return;
 	}
 
 	/* Get a new beacon */
-	beacon = ieee80211_beacon_get(priv->hw, priv->vif);
+	beacon = ieee80211_beacon_get(priv->hw, vif);
 	if (!beacon) {
 		spin_unlock_bh(&priv->beacon_lock);
 		return;
@@ -267,6 +268,69 @@ void ath9k_htc_swba(struct ath9k_htc_priv *priv, u8 beacon_pending)
 	spin_unlock_bh(&priv->beacon_lock);
 }
 
+static int ath9k_htc_choose_bslot(struct ath9k_htc_priv *priv)
+{
+	struct ath_common *common = ath9k_hw_common(priv->ah);
+	unsigned long flags;
+	u64 tsf;
+	u32 tsftu;
+	u16 intval;
+	int slot;
+
+	intval = priv->cur_beacon_conf.beacon_interval & ATH9K_BEACON_PERIOD;
+
+	spin_lock_irqsave(&priv->wmi->wmi_lock, flags);
+	tsf = priv->wmi->tsf;
+	spin_unlock_irqrestore(&priv->wmi->wmi_lock, flags);
+
+	tsftu = TSF_TO_TU(tsf >> 32, tsf);
+	slot = ((tsftu % intval) * ATH9K_HTC_MAX_BCN_VIF) / intval;
+	slot = ATH9K_HTC_MAX_BCN_VIF - slot - 1;
+
+	ath_dbg(common, ATH_DBG_BEACON,
+		"Choose slot: %d, tsf: %llu, tsftu: %u, intval: %u\n",
+		slot, tsf, tsftu, intval);
+
+	return slot;
+}
+
+void ath9k_htc_swba(struct ath9k_htc_priv *priv)
+{
+	struct ath_common *common = ath9k_hw_common(priv->ah);
+	unsigned long flags;
+	int slot;
+
+	spin_lock_irqsave(&priv->wmi->wmi_lock, flags);
+	if (priv->wmi->beacon_pending != 0) {
+		spin_unlock_irqrestore(&priv->wmi->wmi_lock, flags);
+		priv->cur_beacon_conf.bmiss_cnt++;
+		if (priv->cur_beacon_conf.bmiss_cnt > BSTUCK_THRESHOLD) {
+			ath_dbg(common, ATH_DBG_BEACON,
+				"Beacon stuck, HW reset\n");
+			ath9k_htc_reset(priv);
+		}
+		return;
+	}
+	spin_unlock_irqrestore(&priv->wmi->wmi_lock, flags);
+
+	if (priv->cur_beacon_conf.bmiss_cnt) {
+		ath_dbg(common, ATH_DBG_BEACON,
+			"Resuming beacon xmit after %u misses\n",
+			priv->cur_beacon_conf.bmiss_cnt);
+		priv->cur_beacon_conf.bmiss_cnt = 0;
+	}
+
+	slot = ath9k_htc_choose_bslot(priv);
+	spin_lock_bh(&priv->beacon_lock);
+	if (priv->cur_beacon_conf.bslot[slot] == NULL) {
+		spin_unlock_bh(&priv->beacon_lock);
+		return;
+	}
+	spin_unlock_bh(&priv->beacon_lock);
+
+	ath9k_htc_send_beacon(priv, slot);
+}
+
 /* Currently, only for IBSS */
 void ath9k_htc_beaconq_config(struct ath9k_htc_priv *priv)
 {
@@ -298,6 +362,42 @@ void ath9k_htc_beaconq_config(struct ath9k_htc_priv *priv)
 	}
 }
 
+void ath9k_htc_assign_bslot(struct ath9k_htc_priv *priv,
+			    struct ieee80211_vif *vif)
+{
+	struct ath_common *common = ath9k_hw_common(priv->ah);
+	struct ath9k_htc_vif *avp = (struct ath9k_htc_vif *)vif->drv_priv;
+	int i = 0;
+
+	spin_lock_bh(&priv->beacon_lock);
+	for (i = 0; i < ATH9K_HTC_MAX_BCN_VIF; i++) {
+		if (priv->cur_beacon_conf.bslot[i] == NULL) {
+			avp->bslot = i;
+			break;
+		}
+	}
+
+	priv->cur_beacon_conf.bslot[avp->bslot] = vif;
+	spin_unlock_bh(&priv->beacon_lock);
+
+	ath_dbg(common, ATH_DBG_CONFIG,
+		"Added interface at beacon slot: %d\n", avp->bslot);
+}
+
+void ath9k_htc_remove_bslot(struct ath9k_htc_priv *priv,
+			    struct ieee80211_vif *vif)
+{
+	struct ath_common *common = ath9k_hw_common(priv->ah);
+	struct ath9k_htc_vif *avp = (struct ath9k_htc_vif *)vif->drv_priv;
+
+	spin_lock_bh(&priv->beacon_lock);
+	priv->cur_beacon_conf.bslot[avp->bslot] = NULL;
+	spin_unlock_bh(&priv->beacon_lock);
+
+	ath_dbg(common, ATH_DBG_CONFIG,
+		"Removed interface at beacon slot: %d\n", avp->bslot);
+}
+
 void ath9k_htc_beacon_config(struct ath9k_htc_priv *priv,
 			     struct ieee80211_vif *vif)
 {
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index 8e04586..37a41fe 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -649,7 +649,7 @@ static int ath9k_init_priv(struct ath9k_htc_priv *priv,
 {
 	struct ath_hw *ah = NULL;
 	struct ath_common *common;
-	int ret = 0, csz = 0;
+	int i, ret = 0, csz = 0;
 
 	priv->op_flags |= OP_INVALID;
 
@@ -711,6 +711,9 @@ static int ath9k_init_priv(struct ath9k_htc_priv *priv,
 	if (ret)
 		goto err_queues;
 
+	for (i = 0; i < ATH9K_HTC_MAX_BCN_VIF; i++)
+		priv->cur_beacon_conf.bslot[i] = NULL;
+
 	ath9k_init_crypto(priv);
 	ath9k_init_channels_rates(priv);
 	ath9k_init_misc(priv);
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index 6494c7e..4980525 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -1273,9 +1273,13 @@ static int ath9k_htc_add_interface(struct ieee80211_hw *hw,
 
 	priv->vif_slot |= (1 << avp->index);
 	priv->nvifs++;
-	priv->vif = vif;
 
 	INC_VIF(priv, vif->type);
+
+	if ((vif->type == NL80211_IFTYPE_AP) ||
+	    (vif->type == NL80211_IFTYPE_ADHOC))
+		ath9k_htc_assign_bslot(priv, vif);
+
 	ath9k_htc_set_opmode(priv);
 
 	if (priv->ah->opmode == NL80211_IFTYPE_AP)
@@ -1312,12 +1316,16 @@ static void ath9k_htc_remove_interface(struct ieee80211_hw *hw,
 	priv->vif_slot &= ~(1 << avp->index);
 
 	ath9k_htc_remove_station(priv, vif, NULL);
-	priv->vif = NULL;
 
 	if (priv->ah->opmode == NL80211_IFTYPE_AP)
 		cancel_delayed_work_sync(&priv->ath9k_ani_work);
 
 	DEC_VIF(priv, vif->type);
+
+	if ((vif->type == NL80211_IFTYPE_AP) ||
+	    (vif->type == NL80211_IFTYPE_ADHOC))
+		ath9k_htc_remove_bslot(priv, vif);
+
 	ath9k_htc_set_opmode(priv);
 
 	ath_dbg(common, ATH_DBG_CONFIG, "Detach Interface at idx: %d\n", avp->index);
diff --git a/drivers/net/wireless/ath/ath9k/wmi.c b/drivers/net/wireless/ath/ath9k/wmi.c
index 5c36c66..768194d 100644
--- a/drivers/net/wireless/ath/ath9k/wmi.c
+++ b/drivers/net/wireless/ath/ath9k/wmi.c
@@ -124,7 +124,7 @@ void ath9k_swba_tasklet(unsigned long data)
 {
 	struct ath9k_htc_priv *priv = (struct ath9k_htc_priv *)data;
 
-	ath9k_htc_swba(priv, priv->wmi->beacon_pending);
+	ath9k_htc_swba(priv);
 }
 
 void ath9k_fatal_work(struct work_struct *work)
@@ -171,8 +171,10 @@ static void ath9k_wmi_ctrl_rx(void *priv, struct sk_buff *skb,
 		case WMI_SWBA_EVENTID:
 			swba = (struct wmi_event_swba *) wmi_event;
 
+			spin_lock(&wmi->wmi_lock);
 			wmi->tsf = be64_to_cpu(swba->tsf);
 			wmi->beacon_pending = swba->beacon_pending;
+			spin_unlock(&wmi->wmi_lock);
 
 			tasklet_schedule(&wmi->drv_priv->swba_tasklet);
 			break;
-- 
1.7.3.5

