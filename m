Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f42.google.com ([74.125.83.42]:40900 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754961AbaBFI7C (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Feb 2014 03:59:02 -0500
Received: by mail-ee0-f42.google.com with SMTP id b15so726209eek.29
        for <linux-wireless@vger.kernel.org>; Thu, 06 Feb 2014 00:59:01 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH] ath10k: implement sta_rc_update()
Date: Thu,  6 Feb 2014 09:54:01 +0100
Message-Id: <1391676841-11107-1-git-send-email-michal.kazior@tieto.com> (sfid-20140206_095908_576386_16BD888C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This allows dynamic changes of bandwidth/nss/smps,
e.g. via ht/vht operation mode change
notification.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.h |  11 +++
 drivers/net/wireless/ath/ath10k/mac.c  | 149 +++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi.h  |   6 ++
 3 files changed, 166 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index c0b00e1..147348a 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -228,6 +228,17 @@ struct ath10k_peer {
 	struct ieee80211_key_conf *keys[WMI_MAX_KEY_INDEX + 1];
 };
 
+struct ath10k_sta {
+	struct ath10k_vif *arvif;
+
+	u32 changed; /* IEEE80211_RC_* */
+	u32 bw;
+	u32 nss;
+	u32 smps;
+
+	struct work_struct update_wk;
+};
+
 #define ATH10K_VDEV_SETUP_TIMEOUT_HZ (5*HZ)
 
 struct ath10k_vif {
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 144b4d6..afb841d 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -3056,6 +3056,69 @@ exit:
 	return ret;
 }
 
+static void ath10k_sta_rc_update_wk(struct work_struct *wk)
+{
+	struct ath10k *ar;
+	struct ath10k_vif *arvif;
+	struct ath10k_sta *arsta;
+	struct ieee80211_sta *sta;
+	u32 changed, bw, nss, smps;
+	int err;
+
+	arsta = container_of(wk, struct ath10k_sta, update_wk);
+	sta = container_of((void *)arsta, struct ieee80211_sta, drv_priv);
+	arvif = arsta->arvif;
+	ar = arvif->ar;
+
+	spin_lock_bh(&ar->data_lock);
+
+	changed = arsta->changed;
+	arsta->changed = 0;
+
+	bw = arsta->bw;
+	nss = arsta->nss;
+	smps = arsta->smps;
+
+	spin_unlock_bh(&ar->data_lock);
+
+	mutex_lock(&ar->conf_mutex);
+
+	if (changed & IEEE80211_RC_BW_CHANGED) {
+		ath10k_dbg(ATH10K_DBG_MAC, "mac update sta %pM peer bw %d\n",
+			   sta->addr, bw);
+
+		err = ath10k_wmi_peer_set_param(ar, arvif->vdev_id, sta->addr,
+						WMI_PEER_CHAN_WIDTH, bw);
+		if (err)
+			ath10k_warn("failed to update STA %pM peer bw %d: %d\n",
+				    sta->addr, bw, err);
+	}
+
+	if (changed & IEEE80211_RC_NSS_CHANGED) {
+		ath10k_dbg(ATH10K_DBG_MAC, "mac update sta %pM nss %d\n",
+			   sta->addr, nss);
+
+		err = ath10k_wmi_peer_set_param(ar, arvif->vdev_id, sta->addr,
+						WMI_PEER_NSS, nss);
+		if (err)
+			ath10k_warn("failed to update STA %pM nss %d: %d\n",
+				    sta->addr, nss, err);
+	}
+
+	if (changed & IEEE80211_RC_SMPS_CHANGED) {
+		ath10k_dbg(ATH10K_DBG_MAC, "mac update sta %pM smps %d\n",
+			   sta->addr, smps);
+
+		err = ath10k_wmi_peer_set_param(ar, arvif->vdev_id, sta->addr,
+						WMI_PEER_SMPS_STATE, smps);
+		if (err)
+			ath10k_warn("failed to update STA %pM smps %d: %d\n",
+				    sta->addr, smps, err);
+	}
+
+	mutex_unlock(&ar->conf_mutex);
+}
+
 static int ath10k_sta_state(struct ieee80211_hw *hw,
 			    struct ieee80211_vif *vif,
 			    struct ieee80211_sta *sta,
@@ -3064,9 +3127,15 @@ static int ath10k_sta_state(struct ieee80211_hw *hw,
 {
 	struct ath10k *ar = hw->priv;
 	struct ath10k_vif *arvif = ath10k_vif_to_arvif(vif);
+	struct ath10k_sta *arsta = (struct ath10k_sta *)sta->drv_priv;
 	int max_num_peers;
 	int ret = 0;
 
+	/* cancel must be done outside the mutex to avoid deadlock */
+	if ((old_state == IEEE80211_STA_NONE &&
+	     new_state == IEEE80211_STA_NOTEXIST))
+		cancel_work_sync(&arsta->update_wk);
+
 	mutex_lock(&ar->conf_mutex);
 
 	if (old_state == IEEE80211_STA_NOTEXIST &&
@@ -3091,6 +3160,10 @@ static int ath10k_sta_state(struct ieee80211_hw *hw,
 			   "mac vdev %d peer create %pM (new sta) num_peers %d\n",
 			   arvif->vdev_id, sta->addr, ar->num_peers);
 
+		memset(&arsta, 0, sizeof(*arsta));
+		arsta->arvif = arvif;
+		INIT_WORK(&arsta->update_wk, ath10k_sta_rc_update_wk);
+
 		ret = ath10k_peer_create(ar, arvif->vdev_id, sta->addr);
 		if (ret)
 			ath10k_warn("Failed to add peer %pM for vdev %d when adding a new sta: %i\n",
@@ -3854,6 +3927,80 @@ static void ath10k_channel_switch_beacon(struct ieee80211_hw *hw,
 	return;
 }
 
+static void ath10k_sta_rc_update(struct ieee80211_hw *hw,
+				 struct ieee80211_vif *vif,
+				 struct ieee80211_sta *sta,
+				 u32 changed)
+{
+	struct ath10k *ar = hw->priv;
+	struct ath10k_sta *arsta = (struct ath10k_sta *)sta->drv_priv;
+	u32 bw, smps;
+
+	spin_lock_bh(&ar->data_lock);
+
+	if (changed & IEEE80211_RC_BW_CHANGED) {
+		bw = WMI_PEER_CHWIDTH_20MHZ;
+
+		switch (sta->bandwidth) {
+		case IEEE80211_STA_RX_BW_20:
+			bw = WMI_PEER_CHWIDTH_20MHZ;
+			break;
+		case IEEE80211_STA_RX_BW_40:
+			bw = WMI_PEER_CHWIDTH_40MHZ;
+			break;
+		case IEEE80211_STA_RX_BW_80:
+			bw = WMI_PEER_CHWIDTH_80MHZ;
+			break;
+		case IEEE80211_STA_RX_BW_160:
+			ath10k_warn("unsupported STA BW: %d\n", sta->bandwidth);
+			bw = WMI_PEER_CHWIDTH_20MHZ;
+			break;
+		}
+
+		arsta->bw = bw;
+	}
+
+	if (changed & IEEE80211_RC_NSS_CHANGED)
+		arsta->nss = sta->rx_nss;
+
+	if (changed & IEEE80211_RC_SMPS_CHANGED) {
+		smps = WMI_PEER_SMPS_PS_NONE;
+
+		switch (sta->smps_mode) {
+		case IEEE80211_SMPS_AUTOMATIC:
+		case IEEE80211_SMPS_OFF:
+			smps = WMI_PEER_SMPS_PS_NONE;
+			break;
+		case IEEE80211_SMPS_STATIC:
+			smps = WMI_PEER_SMPS_STATIC;
+			break;
+		case IEEE80211_SMPS_DYNAMIC:
+			smps = WMI_PEER_SMPS_DYNAMIC;
+			break;
+		case IEEE80211_SMPS_NUM_MODES:
+			ath10k_warn("invalid smps mode: %d\n", sta->smps_mode);
+			smps = WMI_PEER_SMPS_PS_NONE;
+			break;
+		}
+
+		arsta->smps = smps;
+	}
+
+	if (changed & IEEE80211_RC_SUPP_RATES_CHANGED) {
+		/* FIXME: Not implemented. Probably the only way to do it would
+		 * be to re-assoc the peer. */
+		changed &= ~IEEE80211_RC_SUPP_RATES_CHANGED;
+		ath10k_dbg(ATH10K_DBG_MAC,
+			   "mac sta rc update - supp rates changed - not implemented\n");
+	}
+
+	arsta->changed |= changed;
+
+	spin_unlock_bh(&ar->data_lock);
+
+	ieee80211_queue_work(hw, &arsta->update_wk);
+}
+
 static const struct ieee80211_ops ath10k_ops = {
 	.tx				= ath10k_tx,
 	.start				= ath10k_start,
@@ -3878,6 +4025,7 @@ static const struct ieee80211_ops ath10k_ops = {
 	.get_survey			= ath10k_get_survey,
 	.set_bitrate_mask		= ath10k_set_bitrate_mask,
 	.channel_switch_beacon		= ath10k_channel_switch_beacon,
+	.sta_rc_update			= ath10k_sta_rc_update,
 #ifdef CONFIG_PM
 	.suspend			= ath10k_suspend,
 	.resume				= ath10k_resume,
@@ -4253,6 +4401,7 @@ int ath10k_mac_register(struct ath10k *ar)
 	ar->hw->wiphy->max_scan_ie_len = WLAN_SCAN_PARAMS_MAX_IE_LEN;
 
 	ar->hw->vif_data_size = sizeof(struct ath10k_vif);
+	ar->hw->sta_data_size = sizeof(struct ath10k_sta);
 
 	ar->hw->max_listen_interval = ATH10K_MAX_HW_LISTEN_INTERVAL;
 
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 083079f..6df4f95 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -3876,6 +3876,12 @@ enum wmi_peer_smps_state {
 	WMI_PEER_SMPS_DYNAMIC = 0x2
 };
 
+enum wmi_peer_chwidth {
+	WMI_PEER_CHWIDTH_20MHZ = 0,
+	WMI_PEER_CHWIDTH_40MHZ = 1,
+	WMI_PEER_CHWIDTH_80MHZ = 2,
+};
+
 enum wmi_peer_param {
 	WMI_PEER_SMPS_STATE = 0x1, /* see %wmi_peer_smps_state */
 	WMI_PEER_AMPDU      = 0x2,
-- 
1.8.5.3

