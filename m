Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:41096 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754930Ab1CGCNB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Mar 2011 21:13:01 -0500
Received: by ywj3 with SMTP id 3so1451190ywj.19
        for <linux-wireless@vger.kernel.org>; Sun, 06 Mar 2011 18:13:01 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19828.16164.595483.968074@gargle.gargle.HOWL>
Date: Mon, 7 Mar 2011 07:42:52 +0530
To: linux-wireless@vger.kernel.org
CC: ath9k-devel@lists.ath9k.org
Subject: [RFC 03/34] ath9k_htc: Add TSF adjust capability
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <Sujith.Manoharan@atheros.com>

In multi-interface mode, beacons/probe responses that are
sent out must have their timestamp field updated. Calculate
the TSF adjustment value for each beaconing interface and set it
in the frame properly.

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc.h            |    3 ++
 drivers/net/wireless/ath/ath9k/htc_drv_beacon.c |   36 +++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/htc_drv_main.c   |    5 ++-
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c   |   12 +++++++-
 4 files changed, 54 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index f7897e8..4f86598 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -245,6 +245,7 @@ struct ath9k_htc_vif {
 	u16 seq_no;
 	bool beacon_configured;
 	int bslot;
+	__le64 tsfadjust;
 };
 
 struct ath9k_vif_iter_data {
@@ -477,6 +478,8 @@ void ath9k_htc_assign_bslot(struct ath9k_htc_priv *priv,
 			    struct ieee80211_vif *vif);
 void ath9k_htc_remove_bslot(struct ath9k_htc_priv *priv,
 			    struct ieee80211_vif *vif);
+void ath9k_htc_set_tsfadjust(struct ath9k_htc_priv *priv,
+			     struct ieee80211_vif *vif);
 void ath9k_htc_beaconq_config(struct ath9k_htc_priv *priv);
 void ath9k_htc_beacon_config(struct ath9k_htc_priv *priv,
 			     struct ieee80211_vif *vif);
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
index b4ff240..52b6907 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
@@ -238,6 +238,7 @@ static void ath9k_htc_send_beacon(struct ath9k_htc_priv *priv,
 	struct tx_beacon_header beacon_hdr;
 	struct ath9k_htc_tx_ctl tx_ctl;
 	struct ieee80211_tx_info *info;
+	struct ieee80211_mgmt *mgmt;
 	struct sk_buff *beacon;
 	u8 *tx_fhdr;
 
@@ -261,6 +262,13 @@ static void ath9k_htc_send_beacon(struct ath9k_htc_priv *priv,
 		return;
 	}
 
+	/*
+	 * Update the TSF adjust value here, the HW will
+	 * add this value for every beacon.
+	 */
+	mgmt = (struct ieee80211_mgmt *)beacon->data;
+	mgmt->u.beacon.timestamp = avp->tsfadjust;
+
 	info = IEEE80211_SKB_CB(beacon);
 	if (info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ) {
 		struct ieee80211_hdr *hdr =
@@ -410,6 +418,34 @@ void ath9k_htc_remove_bslot(struct ath9k_htc_priv *priv,
 		"Removed interface at beacon slot: %d\n", avp->bslot);
 }
 
+/*
+ * Calculate the TSF adjustment value for all slots
+ * other than zero.
+ */
+void ath9k_htc_set_tsfadjust(struct ath9k_htc_priv *priv,
+			     struct ieee80211_vif *vif)
+{
+	struct ath_common *common = ath9k_hw_common(priv->ah);
+	struct ath9k_htc_vif *avp = (struct ath9k_htc_vif *)vif->drv_priv;
+	struct htc_beacon_config *cur_conf = &priv->cur_beacon_conf;
+	u64 tsfadjust;
+
+	if (avp->bslot == 0)
+		return;
+
+	/*
+	 * The beacon interval cannot be different for multi-AP mode,
+	 * and we reach here only for VIF slots greater than zero,
+	 * so beacon_interval is guaranteed to be set in cur_conf.
+	 */
+	tsfadjust = cur_conf->beacon_interval * avp->bslot / ATH9K_HTC_MAX_BCN_VIF;
+	avp->tsfadjust = cpu_to_le64(TU_TO_USEC(tsfadjust));
+
+	ath_dbg(common, ATH_DBG_CONFIG,
+		"tsfadjust is: %llu for bslot: %d\n",
+		(unsigned long long)tsfadjust, avp->bslot);
+}
+
 static void ath9k_htc_beacon_iter(void *data, u8 *mac, struct ieee80211_vif *vif)
 {
 	bool *beacon_configured = (bool *)data;
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index 293a9b3..6926ac0 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -1291,8 +1291,10 @@ static int ath9k_htc_add_interface(struct ieee80211_hw *hw,
 	ath9k_htc_set_opmode(priv);
 
 	if ((priv->ah->opmode == NL80211_IFTYPE_AP) &&
-	    !(priv->op_flags & OP_ANI_RUNNING))
+	    !(priv->op_flags & OP_ANI_RUNNING)) {
+		ath9k_hw_set_tsfadjust(priv->ah, 1);
 		ath9k_htc_start_ani(priv);
+	}
 
 	ath_dbg(common, ATH_DBG_CONFIG,
 		"Attach a VIF of type: %d at idx: %d\n", vif->type, avp->index);
@@ -1652,6 +1654,7 @@ static void ath9k_htc_bss_info_changed(struct ieee80211_hw *hw,
 	if ((changed & BSS_CHANGED_BEACON_ENABLED) && bss_conf->enable_beacon) {
 		ath_dbg(common, ATH_DBG_CONFIG,
 			"Beacon enabled for BSS: %pM\n", bss_conf->bssid);
+		ath9k_htc_set_tsfadjust(priv, vif);
 		priv->op_flags |= OP_ENABLE_BEACON;
 		ath9k_htc_beacon_config(priv, vif);
 	}
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index 4a4f27b..b3f9485 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -82,11 +82,12 @@ int ath_htc_txq_update(struct ath9k_htc_priv *priv, int qnum,
 int ath9k_htc_tx_start(struct ath9k_htc_priv *priv, struct sk_buff *skb)
 {
 	struct ieee80211_hdr *hdr;
+	struct ieee80211_mgmt *mgmt;
 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_sta *sta = tx_info->control.sta;
 	struct ieee80211_vif *vif = tx_info->control.vif;
 	struct ath9k_htc_sta *ista;
-	struct ath9k_htc_vif *avp;
+	struct ath9k_htc_vif *avp = NULL;
 	struct ath9k_htc_tx_ctl tx_ctl;
 	enum htc_endpoint_id epid;
 	u16 qnum;
@@ -195,6 +196,15 @@ int ath9k_htc_tx_start(struct ath9k_htc_priv *priv, struct sk_buff *skb)
 
 		memset(&mgmt_hdr, 0, sizeof(struct tx_mgmt_hdr));
 
+		/*
+		 * Set the TSF adjust value for probe response
+		 * frame also.
+		 */
+		if (avp && unlikely(ieee80211_is_probe_resp(fc))) {
+			mgmt = (struct ieee80211_mgmt *)skb->data;
+			mgmt->u.probe_resp.timestamp = avp->tsfadjust;
+		}
+
 		tx_ctl.type = ATH9K_HTC_NORMAL;
 
 		mgmt_hdr.node_idx = sta_idx;
-- 
1.7.4.1

