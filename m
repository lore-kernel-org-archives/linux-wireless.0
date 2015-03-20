Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f52.google.com ([209.85.215.52]:35124 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222AbbCTLA7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Mar 2015 07:00:59 -0400
Received: by labjg1 with SMTP id jg1so84066964lab.2
        for <linux-wireless@vger.kernel.org>; Fri, 20 Mar 2015 04:00:57 -0700 (PDT)
From: Marek Puzyniak <marek.puzyniak@tieto.com>
To: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Cc: Marek Puzyniak <marek.puzyniak@tieto.com>,
	Michal Kazior <michal.kazior@tieto.com>,
	Marek Kwaczynski <marek.kwaczynski@tieto.com>
Subject: [PATCH v4 6/6] ath10k: introduce basic tdls functionality
Date: Fri, 20 Mar 2015 12:02:59 +0100
Message-Id: <1426849379-7562-7-git-send-email-marek.puzyniak@tieto.com> (sfid-20150320_120102_252365_A32EF5E2)
In-Reply-To: <1426849379-7562-1-git-send-email-marek.puzyniak@tieto.com>
References: <1426849379-7562-1-git-send-email-marek.puzyniak@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch introduces tdls without tdls peer uapsd
and tdls channel switching.
Transmitting tdls data frames works only for ethernet
type frames, that's why data addressed to tdls sta
is in ethernet format.

This patch depends on:
mac80211: initialize rate control earlier for tdls station

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
Signed-off-by: Marek Kwaczynski <marek.kwaczynski@tieto.com>
Signed-off-by: Marek Puzyniak <marek.puzyniak@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 205 ++++++++++++++++++++++++++++++++--
 1 file changed, 197 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 3c25507..7368a04 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -582,6 +582,38 @@ static void ath10k_peer_cleanup_all(struct ath10k *ar)
 	ar->num_stations = 0;
 }
 
+static int ath10k_mac_tdls_peer_update(struct ath10k *ar, u32 vdev_id,
+				       struct ieee80211_sta *sta,
+				       enum wmi_tdls_peer_state state)
+{
+	int ret;
+	struct wmi_tdls_peer_update_cmd_arg arg = {};
+	struct wmi_tdls_peer_capab_arg cap = {};
+	struct wmi_channel_arg chan_arg = {};
+
+	lockdep_assert_held(&ar->conf_mutex);
+
+	arg.vdev_id = vdev_id;
+	arg.peer_state = state;
+	ether_addr_copy(arg.addr, sta->addr);
+
+	cap.peer_max_sp = sta->max_sp;
+	cap.peer_uapsd_queues = sta->uapsd_queues;
+
+	if (state == WMI_TDLS_PEER_STATE_CONNECTED &&
+	    !sta->tdls_initiator)
+		cap.is_peer_responder = 1;
+
+	ret = ath10k_wmi_tdls_peer_update(ar, &arg, &cap, &chan_arg);
+	if (ret) {
+		ath10k_warn(ar, "failed to update tdls peer %pM on vdev %i: %i\n",
+			    arg.addr, vdev_id, ret);
+		return ret;
+	}
+
+	return 0;
+}
+
 /************************/
 /* Interface management */
 /************************/
@@ -2523,7 +2555,7 @@ static u8 ath10k_tx_h_get_vdev_id(struct ath10k *ar, struct ieee80211_vif *vif)
 
 static enum ath10k_hw_txrx_mode
 ath10k_tx_h_get_txmode(struct ath10k *ar, struct ieee80211_vif *vif,
-		       struct sk_buff *skb)
+		       struct ieee80211_sta *sta, struct sk_buff *skb)
 {
 	const struct ieee80211_hdr *hdr = (void *)skb->data;
 	__le16 fc = hdr->frame_control;
@@ -2555,6 +2587,15 @@ ath10k_tx_h_get_txmode(struct ath10k *ar, struct ieee80211_vif *vif,
 	    !test_bit(ATH10K_FW_FEATURE_HAS_WMI_MGMT_TX, ar->fw_features))
 		return ATH10K_HW_TXRX_MGMT;
 
+	/* Workaround:
+	 *
+	 * Some wmi-tlv firmwares for qca6174 have broken Tx key selection for
+	 * NativeWifi txmode - it selects AP key instead of peer key. It seems
+	 * to work with Ethernet txmode so use it.
+	 */
+	if (ieee80211_is_data_present(fc) && sta && sta->tdls)
+		return ATH10K_HW_TXRX_ETHERNET;
+
 	return ATH10K_HW_TXRX_NATIVE_WIFI;
 }
 
@@ -2991,6 +3032,7 @@ static void ath10k_tx(struct ieee80211_hw *hw,
 	struct ath10k *ar = hw->priv;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_vif *vif = info->control.vif;
+	struct ieee80211_sta *sta = control->sta;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	__le16 fc = hdr->frame_control;
 
@@ -3001,7 +3043,7 @@ static void ath10k_tx(struct ieee80211_hw *hw,
 	ATH10K_SKB_CB(skb)->htt.is_offchan = false;
 	ATH10K_SKB_CB(skb)->htt.tid = ath10k_tx_h_get_tid(hdr);
 	ATH10K_SKB_CB(skb)->vdev_id = ath10k_tx_h_get_vdev_id(ar, vif);
-	ATH10K_SKB_CB(skb)->txmode = ath10k_tx_h_get_txmode(ar, vif, skb);
+	ATH10K_SKB_CB(skb)->txmode = ath10k_tx_h_get_txmode(ar, vif, sta, skb);
 	ATH10K_SKB_CB(skb)->is_protected = ieee80211_has_protected(fc);
 
 	switch (ATH10K_SKB_CB(skb)->txmode) {
@@ -4417,6 +4459,59 @@ static void ath10k_mac_dec_num_stations(struct ath10k_vif *arvif,
 	ar->num_stations--;
 }
 
+struct ath10k_mac_tdls_iter_data {
+	u32 num_tdls_stations;
+	struct ieee80211_vif *curr_vif;
+};
+
+static void ath10k_mac_tdls_vif_stations_count_iter(void *data,
+						    struct ieee80211_sta *sta)
+{
+	struct ath10k_mac_tdls_iter_data *iter_data = data;
+	struct ath10k_sta *arsta = (struct ath10k_sta *)sta->drv_priv;
+	struct ieee80211_vif *sta_vif = arsta->arvif->vif;
+
+	if (sta->tdls && sta_vif == iter_data->curr_vif)
+		iter_data->num_tdls_stations++;
+}
+
+static int ath10k_mac_tdls_vif_stations_count(struct ieee80211_hw *hw,
+					      struct ieee80211_vif *vif)
+{
+	struct ath10k_mac_tdls_iter_data data = {};
+
+	data.curr_vif = vif;
+
+	ieee80211_iterate_stations_atomic(hw,
+					  ath10k_mac_tdls_vif_stations_count_iter,
+					  &data);
+	return data.num_tdls_stations;
+}
+
+static void ath10k_mac_tdls_vifs_count_iter(void *data, u8 *mac,
+					    struct ieee80211_vif *vif)
+{
+	struct ath10k_vif *arvif = ath10k_vif_to_arvif(vif);
+	int *num_tdls_vifs = data;
+
+	if (vif->type != NL80211_IFTYPE_STATION)
+		return;
+
+	if (ath10k_mac_tdls_vif_stations_count(arvif->ar->hw, vif) > 0)
+		(*num_tdls_vifs)++;
+}
+
+static int ath10_mac_tdls_vifs_count(struct ieee80211_hw *hw)
+{
+	int num_tdls_vifs = 0;
+
+	ieee80211_iterate_active_interfaces_atomic(hw,
+						   IEEE80211_IFACE_ITER_NORMAL,
+						   ath10k_mac_tdls_vifs_count_iter,
+						   &num_tdls_vifs);
+	return num_tdls_vifs;
+}
+
 static int ath10k_sta_state(struct ieee80211_hw *hw,
 			    struct ieee80211_vif *vif,
 			    struct ieee80211_sta *sta,
@@ -4447,6 +4542,10 @@ static int ath10k_sta_state(struct ieee80211_hw *hw,
 		/*
 		 * New station addition.
 		 */
+		enum wmi_peer_type peer_type = WMI_PEER_TYPE_DEFAULT;
+		u32 num_tdls_stations;
+		u32 num_tdls_vifs;
+
 		ath10k_dbg(ar, ATH10K_DBG_MAC,
 			   "mac vdev %d peer create %pM (new sta) sta %d / %d peer %d / %d\n",
 			   arvif->vdev_id, sta->addr,
@@ -4460,8 +4559,11 @@ static int ath10k_sta_state(struct ieee80211_hw *hw,
 			goto exit;
 		}
 
+		if (sta->tdls)
+			peer_type = WMI_PEER_TYPE_TDLS;
+
 		ret = ath10k_peer_create(ar, arvif->vdev_id, sta->addr,
-					 WMI_PEER_TYPE_DEFAULT);
+					 peer_type);
 		if (ret) {
 			ath10k_warn(ar, "failed to add peer %pM for vdev %d when adding a new sta: %i\n",
 				    sta->addr, arvif->vdev_id, ret);
@@ -4469,7 +4571,8 @@ static int ath10k_sta_state(struct ieee80211_hw *hw,
 			goto exit;
 		}
 
-		if (vif->type == NL80211_IFTYPE_STATION) {
+		if (vif->type == NL80211_IFTYPE_STATION &&
+		    !sta->tdls) {
 			WARN_ON(arvif->is_started);
 
 			ret = ath10k_vdev_start(arvif);
@@ -4484,6 +4587,53 @@ static int ath10k_sta_state(struct ieee80211_hw *hw,
 
 			arvif->is_started = true;
 		}
+
+		if (!sta->tdls)
+			goto exit;
+
+		num_tdls_stations = ath10k_mac_tdls_vif_stations_count(hw, vif);
+		num_tdls_vifs = ath10_mac_tdls_vifs_count(hw);
+
+		if (num_tdls_vifs >= ar->max_num_tdls_vdevs &&
+		    num_tdls_stations == 0) {
+			ath10k_warn(ar, "vdev %i exceeded maximum number of tdls vdevs %i\n",
+				    arvif->vdev_id, ar->max_num_tdls_vdevs);
+			ath10k_peer_delete(ar, arvif->vdev_id, sta->addr);
+			ath10k_mac_dec_num_stations(arvif, sta);
+			ret = -ENOBUFS;
+			goto exit;
+		}
+
+		if (num_tdls_stations == 0) {
+			/* This is the first tdls peer in current vif */
+			enum wmi_tdls_state state = WMI_TDLS_ENABLE_ACTIVE;
+
+			ret = ath10k_wmi_update_fw_tdls_state(ar, arvif->vdev_id,
+							      state);
+			if (ret) {
+				ath10k_warn(ar, "failed to update fw tdls state on vdev %i: %i\n",
+					    arvif->vdev_id, ret);
+				ath10k_peer_delete(ar, arvif->vdev_id,
+						   sta->addr);
+				ath10k_mac_dec_num_stations(arvif, sta);
+				goto exit;
+			}
+		}
+
+		ret = ath10k_mac_tdls_peer_update(ar, arvif->vdev_id, sta,
+						  WMI_TDLS_PEER_STATE_PEERING);
+		if (ret) {
+			ath10k_warn(ar,
+				    "failed to update tdls peer %pM for vdev %d when adding a new sta: %i\n",
+				    sta->addr, arvif->vdev_id, ret);
+			ath10k_peer_delete(ar, arvif->vdev_id, sta->addr);
+			ath10k_mac_dec_num_stations(arvif, sta);
+
+			if (num_tdls_stations != 0)
+				goto exit;
+			ath10k_wmi_update_fw_tdls_state(ar, arvif->vdev_id,
+							WMI_TDLS_DISABLE);
+		}
 	} else if ((old_state == IEEE80211_STA_NONE &&
 		    new_state == IEEE80211_STA_NOTEXIST)) {
 		/*
@@ -4493,7 +4643,8 @@ static int ath10k_sta_state(struct ieee80211_hw *hw,
 			   "mac vdev %d peer delete %pM (sta gone)\n",
 			   arvif->vdev_id, sta->addr);
 
-		if (vif->type == NL80211_IFTYPE_STATION) {
+		if (vif->type == NL80211_IFTYPE_STATION &&
+		    !sta->tdls) {
 			WARN_ON(!arvif->is_started);
 
 			ret = ath10k_vdev_stop(arvif);
@@ -4510,6 +4661,20 @@ static int ath10k_sta_state(struct ieee80211_hw *hw,
 				    sta->addr, arvif->vdev_id, ret);
 
 		ath10k_mac_dec_num_stations(arvif, sta);
+
+		if (!sta->tdls)
+			goto exit;
+
+		if (ath10k_mac_tdls_vif_stations_count(hw, vif))
+			goto exit;
+
+		/* This was the last tdls peer in current vif */
+		ret = ath10k_wmi_update_fw_tdls_state(ar, arvif->vdev_id,
+						      WMI_TDLS_DISABLE);
+		if (ret) {
+			ath10k_warn(ar, "failed to update fw tdls state on vdev %i: %i\n",
+				    arvif->vdev_id, ret);
+		}
 	} else if (old_state == IEEE80211_STA_AUTH &&
 		   new_state == IEEE80211_STA_ASSOC &&
 		   (vif->type == NL80211_IFTYPE_AP ||
@@ -4525,9 +4690,30 @@ static int ath10k_sta_state(struct ieee80211_hw *hw,
 			ath10k_warn(ar, "failed to associate station %pM for vdev %i: %i\n",
 				    sta->addr, arvif->vdev_id, ret);
 	} else if (old_state == IEEE80211_STA_ASSOC &&
-		   new_state == IEEE80211_STA_AUTH &&
-		   (vif->type == NL80211_IFTYPE_AP ||
-		    vif->type == NL80211_IFTYPE_ADHOC)) {
+		   new_state == IEEE80211_STA_AUTHORIZED &&
+		   sta->tdls) {
+		/*
+		 * Tdls station authorized.
+		 */
+		ath10k_dbg(ar, ATH10K_DBG_MAC, "mac tdls sta %pM authorized\n",
+			   sta->addr);
+
+		ret = ath10k_station_assoc(ar, vif, sta, false);
+		if (ret) {
+			ath10k_warn(ar, "failed to associate tdls station %pM for vdev %i: %i\n",
+				    sta->addr, arvif->vdev_id, ret);
+			goto exit;
+		}
+
+		ret = ath10k_mac_tdls_peer_update(ar, arvif->vdev_id, sta,
+						  WMI_TDLS_PEER_STATE_CONNECTED);
+		if (ret)
+			ath10k_warn(ar, "failed to update tdls peer %pM for vdev %i: %i\n",
+				    sta->addr, arvif->vdev_id, ret);
+	} else if (old_state == IEEE80211_STA_ASSOC &&
+		    new_state == IEEE80211_STA_AUTH &&
+		    (vif->type == NL80211_IFTYPE_AP ||
+		     vif->type == NL80211_IFTYPE_ADHOC)) {
 		/*
 		 * Disassociation.
 		 */
@@ -5929,6 +6115,9 @@ int ath10k_mac_register(struct ath10k *ar)
 			NL80211_PROBE_RESP_OFFLOAD_SUPPORT_P2P;
 	}
 
+	if (test_bit(WMI_SERVICE_TDLS, ar->wmi.svc_map))
+		ar->hw->wiphy->flags |= WIPHY_FLAG_SUPPORTS_TDLS;
+
 	ar->hw->wiphy->flags |= WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL;
 	ar->hw->wiphy->flags |= WIPHY_FLAG_HAS_CHANNEL_SWITCH;
 	ar->hw->wiphy->max_remain_on_channel_duration = 5000;
-- 
2.1.4

