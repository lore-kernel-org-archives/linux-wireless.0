Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:56009 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496Ab1AUDC4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Jan 2011 22:02:56 -0500
Received: by mail-iy0-f174.google.com with SMTP id 18so1246881iyj.19
        for <linux-wireless@vger.kernel.org>; Thu, 20 Jan 2011 19:02:56 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19768.63282.419046.995240@gargle.gargle.HOWL>
Date: Fri, 21 Jan 2011 08:32:10 +0530
To: linux-wireless@vger.kernel.org
CC: ath9k-devel@lists.ath9k.org
Subject: [RFC/WIP 20/33] ath9k_htc: Add TSF adjust capability
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
index 6b3f0f3..bd1610f 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -244,6 +244,7 @@ struct ath9k_htc_vif {
 	u8 index;
 	u16 seq_no;
 	int bslot;
+	__le64 tsfadjust;
 };
 
 struct ath9k_vif_iter_data {
@@ -475,6 +476,8 @@ void ath9k_htc_assign_bslot(struct ath9k_htc_priv *priv,
 			    struct ieee80211_vif *vif);
 void ath9k_htc_remove_bslot(struct ath9k_htc_priv *priv,
 			    struct ieee80211_vif *vif);
+void ath9k_htc_set_tsfadjust(struct ath9k_htc_priv *priv,
+			     struct ieee80211_vif *vif);
 void ath9k_htc_beaconq_config(struct ath9k_htc_priv *priv);
 void ath9k_htc_beacon_config(struct ath9k_htc_priv *priv,
 			     struct ieee80211_vif *vif);
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
index 0803c25..64934cf 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
@@ -237,6 +237,7 @@ static void ath9k_htc_send_beacon(struct ath9k_htc_priv *priv,
 	struct tx_beacon_header beacon_hdr;
 	struct ath9k_htc_tx_ctl tx_ctl;
 	struct ieee80211_tx_info *info;
+	struct ieee80211_mgmt *mgmt;
 	struct sk_buff *beacon;
 	u8 *tx_fhdr;
 
@@ -260,6 +261,13 @@ static void ath9k_htc_send_beacon(struct ath9k_htc_priv *priv,
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
@@ -409,6 +417,34 @@ void ath9k_htc_remove_bslot(struct ath9k_htc_priv *priv,
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
 void ath9k_htc_beacon_config(struct ath9k_htc_priv *priv,
 			     struct ieee80211_vif *vif)
 {
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index 4980525..5f8e54c 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -1282,8 +1282,10 @@ static int ath9k_htc_add_interface(struct ieee80211_hw *hw,
 
 	ath9k_htc_set_opmode(priv);
 
-	if (priv->ah->opmode == NL80211_IFTYPE_AP)
+	if (priv->ah->opmode == NL80211_IFTYPE_AP) {
+		ath9k_hw_set_tsfadjust(priv->ah, 1);
 		ath_start_ani(priv);
+	}
 
 	ath_dbg(common, ATH_DBG_CONFIG,
 		"Attach a VIF of type: %d at idx: %d\n", vif->type, avp->index);
@@ -1621,6 +1623,7 @@ static void ath9k_htc_bss_info_changed(struct ieee80211_hw *hw,
 	if ((changed & BSS_CHANGED_BEACON_ENABLED) && bss_conf->enable_beacon) {
 		ath_dbg(common, ATH_DBG_CONFIG,
 			"Beacon enabled for BSS: %pM\n", bss_conf->bssid);
+		ath9k_htc_set_tsfadjust(priv, vif);
 		priv->op_flags |= OP_ENABLE_BEACON;
 		ath9k_htc_beacon_config(priv, vif);
 	}
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index 04d8248..127a99b 100644
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
1.7.3.5

