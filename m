Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:48921 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759789AbbA3Ims (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jan 2015 03:42:48 -0500
Received: by mail-wg0-f51.google.com with SMTP id k14so25495521wgh.10
        for <linux-wireless@vger.kernel.org>; Fri, 30 Jan 2015 00:42:46 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 2/7] ath10k: implement chanctx API
Date: Fri, 30 Jan 2015 09:41:22 +0100
Message-Id: <1422607287-12289-3-git-send-email-michal.kazior@tieto.com> (sfid-20150130_094255_557143_3588D2BA)
In-Reply-To: <1422607287-12289-1-git-send-email-michal.kazior@tieto.com>
References: <1422607287-12289-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The chanctx API will allow ath10k to support
multi-channel operation.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.c   |   1 +
 drivers/net/wireless/ath/ath10k/core.h   |   8 +
 drivers/net/wireless/ath/ath10k/htt_rx.c |  87 ++++-
 drivers/net/wireless/ath/ath10k/mac.c    | 551 +++++++++++++++++++++++++++----
 drivers/net/wireless/ath/ath10k/wmi.c    |  13 +-
 5 files changed, 584 insertions(+), 76 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 5e9e1a6..57f70327 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -1116,6 +1116,7 @@ int ath10k_core_start(struct ath10k *ar, enum ath10k_firmware_mode mode)
 
 	ar->free_vdev_map = (1LL << ar->max_num_vdevs) - 1;
 
+	INIT_LIST_HEAD(&ar->arctxs);
 	INIT_LIST_HEAD(&ar->arvifs);
 
 	return 0;
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index abb3203..cf7963d 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -260,6 +260,11 @@ struct ath10k_sta {
 #endif
 };
 
+struct ath10k_chanctx {
+	struct list_head list;
+	struct ieee80211_chanctx_conf conf;
+};
+
 #define ATH10K_VDEV_SETUP_TIMEOUT_HZ (5*HZ)
 
 struct ath10k_vif {
@@ -277,6 +282,7 @@ struct ath10k_vif {
 	dma_addr_t beacon_paddr;
 
 	struct ath10k *ar;
+	struct ath10k_chanctx *arctx;
 	struct ieee80211_vif *vif;
 
 	bool is_started;
@@ -561,6 +567,7 @@ struct ath10k {
 	struct cfg80211_chan_def chandef;
 
 	unsigned long long free_vdev_map;
+	struct ath10k_vif *monitor_arvif;
 	bool monitor;
 	int monitor_vdev_id;
 	bool monitor_started;
@@ -590,6 +597,7 @@ struct ath10k {
 	/* protects shared structure data */
 	spinlock_t data_lock;
 
+	struct list_head arctxs;
 	struct list_head arvifs;
 	struct list_head peers;
 	wait_queue_head_t peer_mapping_wq;
diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index c1da44f..b18aa8e 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -773,8 +773,74 @@ static void ath10k_htt_rx_h_rates(struct ath10k *ar,
 	}
 }
 
+static struct ieee80211_channel *
+ath10k_htt_rx_h_peer_channel(struct ath10k *ar, struct htt_rx_desc *rxd)
+{
+	struct ath10k_peer *peer;
+	struct ath10k_vif *arvif;
+	u16 peer_id;
+
+	lockdep_assert_held(&ar->data_lock);
+
+	if (!rxd)
+		return NULL;
+
+	if (rxd->attention.flags &
+	    __cpu_to_le32(RX_ATTENTION_FLAGS_PEER_IDX_INVALID))
+		return NULL;
+
+	if (!(rxd->msdu_end.info0 &
+	      __cpu_to_le32(RX_MSDU_END_INFO0_FIRST_MSDU)))
+		return NULL;
+
+	peer_id = MS(__le32_to_cpu(rxd->mpdu_start.info0),
+		     RX_MPDU_START_INFO0_PEER_IDX);
+
+	peer = ath10k_peer_find_by_id(ar, peer_id);
+	if (!peer)
+		return NULL;
+
+	arvif = ath10k_get_arvif(ar, peer->vdev_id);
+	if (WARN_ON_ONCE(!arvif->arctx))
+		return NULL;
+
+	if (WARN_ON_ONCE(!arvif->arctx))
+		return NULL;
+
+	return arvif->arctx->conf.def.chan;
+}
+
+static struct ieee80211_channel *
+ath10k_htt_rx_h_vdev_channel(struct ath10k *ar, u32 vdev_id)
+{
+	struct ath10k_vif *arvif;
+
+	lockdep_assert_held(&ar->data_lock);
+
+	list_for_each_entry(arvif, &ar->arvifs, list)
+		if (arvif->vdev_id == vdev_id && arvif->arctx)
+			return arvif->arctx->conf.def.chan;
+
+	return NULL;
+}
+
+static struct ieee80211_channel *
+ath10k_htt_rx_h_any_channel(struct ath10k *ar)
+{
+	struct ath10k_chanctx *arctx;
+
+	lockdep_assert_held(&ar->data_lock);
+
+	list_for_each_entry(arctx, &ar->arctxs, list)
+		return arctx->conf.def.chan;
+
+	return NULL;
+}
+
 static bool ath10k_htt_rx_h_channel(struct ath10k *ar,
-				    struct ieee80211_rx_status *status)
+				    struct ieee80211_rx_status *status,
+				    struct htt_rx_desc *rxd,
+				    u32 vdev_id)
 {
 	struct ieee80211_channel *ch;
 
@@ -782,6 +848,12 @@ static bool ath10k_htt_rx_h_channel(struct ath10k *ar,
 	ch = ar->scan_channel;
 	if (!ch)
 		ch = ar->rx_channel;
+	if (!ch)
+		ch = ath10k_htt_rx_h_peer_channel(ar, rxd);
+	if (!ch)
+		ch = ath10k_htt_rx_h_vdev_channel(ar, vdev_id);
+	if (!ch)
+		ch = ath10k_htt_rx_h_any_channel(ar);
 	spin_unlock_bh(&ar->data_lock);
 
 	if (!ch)
@@ -819,7 +891,8 @@ static void ath10k_htt_rx_h_mactime(struct ath10k *ar,
 
 static void ath10k_htt_rx_h_ppdu(struct ath10k *ar,
 				 struct sk_buff_head *amsdu,
-				 struct ieee80211_rx_status *status)
+				 struct ieee80211_rx_status *status,
+				 u32 vdev_id)
 {
 	struct sk_buff *first;
 	struct htt_rx_desc *rxd;
@@ -851,7 +924,7 @@ static void ath10k_htt_rx_h_ppdu(struct ath10k *ar,
 		status->flag |= RX_FLAG_NO_SIGNAL_VAL;
 
 		ath10k_htt_rx_h_signal(ar, status, rxd);
-		ath10k_htt_rx_h_channel(ar, status);
+		ath10k_htt_rx_h_channel(ar, status, rxd, vdev_id);
 		ath10k_htt_rx_h_rates(ar, status, rxd);
 	}
 
@@ -1522,7 +1595,7 @@ static void ath10k_htt_rx_handler(struct ath10k_htt *htt,
 			break;
 		}
 
-		ath10k_htt_rx_h_ppdu(ar, &amsdu, rx_status);
+		ath10k_htt_rx_h_ppdu(ar, &amsdu, rx_status, 0xffff);
 		ath10k_htt_rx_h_unchain(ar, &amsdu, ret > 0);
 		ath10k_htt_rx_h_filter(ar, &amsdu, rx_status);
 		ath10k_htt_rx_h_mpdu(ar, &amsdu, rx_status);
@@ -1569,7 +1642,7 @@ static void ath10k_htt_rx_frag_handler(struct ath10k_htt *htt,
 		return;
 	}
 
-	ath10k_htt_rx_h_ppdu(ar, &amsdu, rx_status);
+	ath10k_htt_rx_h_ppdu(ar, &amsdu, rx_status, 0xffff);
 	ath10k_htt_rx_h_filter(ar, &amsdu, rx_status);
 	ath10k_htt_rx_h_mpdu(ar, &amsdu, rx_status);
 	ath10k_htt_rx_h_deliver(ar, &amsdu, rx_status);
@@ -1796,7 +1869,7 @@ static void ath10k_htt_rx_h_rx_offload(struct ath10k *ar,
 		status->flag |= RX_FLAG_NO_SIGNAL_VAL;
 
 		ath10k_htt_rx_h_rx_offload_prot(status, msdu);
-		ath10k_htt_rx_h_channel(ar, status);
+		ath10k_htt_rx_h_channel(ar, status, NULL, rx->vdev_id);
 		ath10k_process_rx(ar, status, msdu);
 	}
 }
@@ -1869,7 +1942,7 @@ static void ath10k_htt_rx_in_ord_ind(struct ath10k *ar, struct sk_buff *skb)
 			 * better to report something than nothing though. This
 			 * should still give an idea about rx rate to the user.
 			 */
-			ath10k_htt_rx_h_ppdu(ar, &amsdu, status);
+			ath10k_htt_rx_h_ppdu(ar, &amsdu, status, vdev_id);
 			ath10k_htt_rx_h_filter(ar, &amsdu, status);
 			ath10k_htt_rx_h_mpdu(ar, &amsdu, status);
 			ath10k_htt_rx_h_deliver(ar, &amsdu, status);
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 15e47f4..16fddc7 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -751,13 +751,32 @@ static int ath10k_monitor_stop(struct ath10k *ar)
 
 static int ath10k_monitor_recalc(struct ath10k *ar)
 {
+	struct ath10k_chanctx *arctx;
 	bool should_start;
+	int num_ctx;
 
 	lockdep_assert_held(&ar->conf_mutex);
 
-	should_start = ar->monitor ||
-		       ar->filter_flags & FIF_PROMISC_IN_BSS ||
-		       test_bit(ATH10K_CAC_RUNNING, &ar->dev_flags);
+	should_start = (ar->monitor ||
+			ar->filter_flags & FIF_PROMISC_IN_BSS ||
+			test_bit(ATH10K_CAC_RUNNING, &ar->dev_flags)) &&
+			!list_empty(&ar->arctxs) &&
+			!ar->monitor_arvif;
+
+	num_ctx = 0;
+	list_for_each_entry(arctx, &ar->arctxs, list)
+		num_ctx++;
+
+	/* FIXME: It remains unclear if CAC on multi-channel will work this
+	 * way. Multi-channel DFS must be revised.
+	 *
+	 * FIXME: Hopefully 2x STA on different channels + monitor interface
+	 * will simply setup something like a promiscuous mode.
+	 */
+	if (WARN_ON(should_start &&
+		    test_bit(ATH10K_CAC_RUNNING, &ar->dev_flags) &&
+		    num_ctx > 1))
+		return -EPERM;
 
 	ath10k_dbg(ar, ATH10K_DBG_MAC,
 		   "mac monitor recalc started? %d should? %d\n",
@@ -829,6 +848,19 @@ static int ath10k_stop_cac(struct ath10k *ar)
 	return 0;
 }
 
+static bool ath10k_mac_has_radar_enabled(struct ath10k *ar)
+{
+	struct ath10k_chanctx *arctx;
+
+	lockdep_assert_held(&ar->conf_mutex);
+
+	list_for_each_entry(arctx, &ar->arctxs, list)
+		if (arctx->conf.radar_enabled)
+			return true;
+
+	return false;
+}
+
 static void ath10k_recalc_radar_detection(struct ath10k *ar)
 {
 	int ret;
@@ -837,7 +869,7 @@ static void ath10k_recalc_radar_detection(struct ath10k *ar)
 
 	ath10k_stop_cac(ar);
 
-	if (!ar->radar_enabled)
+	if (!ath10k_mac_has_radar_enabled(ar))
 		return;
 
 	if (ar->num_started_vdevs > 0)
@@ -858,12 +890,17 @@ static void ath10k_recalc_radar_detection(struct ath10k *ar)
 static int ath10k_vdev_start_restart(struct ath10k_vif *arvif, bool restart)
 {
 	struct ath10k *ar = arvif->ar;
-	struct cfg80211_chan_def *chandef = &ar->chandef;
+	struct cfg80211_chan_def *chandef;
 	struct wmi_vdev_start_request_arg arg = {};
 	int ret = 0;
 
 	lockdep_assert_held(&ar->conf_mutex);
 
+	if (WARN_ON(!arvif->arctx))
+		return -EINVAL;
+
+	chandef = &arvif->arctx->conf.def;
+
 	reinit_completion(&ar->vdev_setup_done);
 
 	arg.vdev_id = arvif->vdev_id;
@@ -1101,6 +1138,76 @@ static int ath10k_mac_setup_prb_tmpl(struct ath10k_vif *arvif)
 	return 0;
 }
 
+static int ath10k_mac_vif_fix_hidden_ssid(struct ath10k_vif *arvif)
+{
+	struct ath10k *ar = arvif->ar;
+	int ret;
+
+	/* When originally vdev is started during assign_vif_chanctx() some
+	 * information is missing, notably SSID. Firmware revisions with beacon
+	 * offloading require the SSID to be provided during vdev (re)start to
+	 * handle hidden SSID properly.
+	 *
+	 * Vdev restart must be done after vdev has been both started and
+	 * upped. Otherwise some firmware revisions (at least 10.2) fail to
+	 * deliver vdev restart response event causing timeouts during vdev
+	 * syncing in ath10k.
+	 *
+	 * Note: The vdev down/up and template reinstallation could be skipped
+	 * since only wmi-tlv firmware are known to have beacon offload and
+	 * wmi-tlv doesn't seem to misbehave like 10.2 wrt vdev restart
+	 * response delivery. It's probably more robust to keep it as is.
+	 */
+	if (!test_bit(WMI_SERVICE_BEACON_OFFLOAD, ar->wmi.svc_map))
+		return 0;
+
+	if (WARN_ON(!arvif->is_started))
+		return -EINVAL;
+
+	if (WARN_ON(!arvif->is_up))
+		return -EINVAL;
+
+	ret = ath10k_wmi_vdev_down(ar, arvif->vdev_id);
+	if (ret) {
+		ath10k_warn(ar, "failed to bring down ap vdev %i: %d\n",
+			    arvif->vdev_id, ret);
+		return ret;
+	}
+
+	/* Vdev down reset beacon & presp templates. Reinstall them. Otherwise
+	 * firmware will crash upon vdev up.
+	 */
+
+	ret = ath10k_mac_setup_bcn_tmpl(arvif);
+	if (ret) {
+		ath10k_warn(ar, "failed to update beacon template: %d\n", ret);
+		return ret;
+	}
+
+	ret = ath10k_mac_setup_prb_tmpl(arvif);
+	if (ret) {
+		ath10k_warn(ar, "failed to update presp template: %d\n", ret);
+		return ret;
+	}
+
+	ret = ath10k_vdev_restart(arvif);
+	if (ret) {
+		ath10k_warn(ar, "failed to restart ap vdev %i: %d\n",
+			    arvif->vdev_id, ret);
+		return ret;
+	}
+
+	ret = ath10k_wmi_vdev_up(arvif->ar, arvif->vdev_id, arvif->aid,
+				 arvif->bssid);
+	if (ret) {
+		ath10k_warn(ar, "failed to bring up ap vdev %i: %d\n",
+			    arvif->vdev_id, ret);
+		return ret;
+	}
+
+	return 0;
+}
+
 static void ath10k_control_beaconing(struct ath10k_vif *arvif,
 				     struct ieee80211_bss_conf *info)
 {
@@ -1110,9 +1217,11 @@ static void ath10k_control_beaconing(struct ath10k_vif *arvif,
 	lockdep_assert_held(&arvif->ar->conf_mutex);
 
 	if (!info->enable_beacon) {
-		ath10k_vdev_stop(arvif);
+		ret = ath10k_wmi_vdev_down(ar, arvif->vdev_id);
+		if (ret)
+			ath10k_warn(ar, "failed to down vdev_id %i: %d\n",
+				    arvif->vdev_id, ret);
 
-		arvif->is_started = false;
 		arvif->is_up = false;
 
 		spin_lock_bh(&arvif->ar->data_lock);
@@ -1124,10 +1233,6 @@ static void ath10k_control_beaconing(struct ath10k_vif *arvif,
 
 	arvif->tx_seq_no = 0x1000;
 
-	ret = ath10k_vdev_start(arvif);
-	if (ret)
-		return;
-
 	arvif->aid = 0;
 	ether_addr_copy(arvif->bssid, info->bssid);
 
@@ -1136,13 +1241,18 @@ static void ath10k_control_beaconing(struct ath10k_vif *arvif,
 	if (ret) {
 		ath10k_warn(ar, "failed to bring up vdev %d: %i\n",
 			    arvif->vdev_id, ret);
-		ath10k_vdev_stop(arvif);
 		return;
 	}
 
-	arvif->is_started = true;
 	arvif->is_up = true;
 
+	ret = ath10k_mac_vif_fix_hidden_ssid(arvif);
+	if (ret) {
+		ath10k_warn(ar, "failed to fix hidden ssid for vdev %i, expect trouble: %d\n",
+			    arvif->vdev_id, ret);
+		return;
+	}
+
 	ath10k_dbg(ar, ATH10K_DBG_MAC, "mac vdev %d up\n", arvif->vdev_id);
 }
 
@@ -1362,13 +1472,17 @@ static void ath10k_peer_assoc_h_crypto(struct ath10k *ar,
 				       struct wmi_peer_assoc_complete_arg *arg)
 {
 	struct ieee80211_bss_conf *info = &vif->bss_conf;
+	struct ath10k_vif *arvif = ath10k_vif_to_arvif(vif);
 	struct cfg80211_bss *bss;
 	const u8 *rsnie = NULL;
 	const u8 *wpaie = NULL;
 
 	lockdep_assert_held(&ar->conf_mutex);
 
-	bss = cfg80211_get_bss(ar->hw->wiphy, ar->hw->conf.chandef.chan,
+	if (WARN_ON(!arvif->arctx))
+		return;
+
+	bss = cfg80211_get_bss(ar->hw->wiphy, arvif->arctx->conf.def.chan,
 			       info->bssid, NULL, 0, 0, 0);
 	if (bss) {
 		const struct cfg80211_bss_ies *ies;
@@ -1399,10 +1513,12 @@ static void ath10k_peer_assoc_h_crypto(struct ath10k *ar,
 }
 
 static void ath10k_peer_assoc_h_rates(struct ath10k *ar,
+				      struct ieee80211_vif *vif,
 				      struct ieee80211_sta *sta,
 				      struct wmi_peer_assoc_complete_arg *arg)
 {
 	struct wmi_rate_set_arg *rateset = &arg->peer_legacy_rates;
+	struct ath10k_vif *arvif = ath10k_vif_to_arvif(vif);
 	const struct ieee80211_supported_band *sband;
 	const struct ieee80211_rate *rates;
 	u32 ratemask;
@@ -1410,8 +1526,11 @@ static void ath10k_peer_assoc_h_rates(struct ath10k *ar,
 
 	lockdep_assert_held(&ar->conf_mutex);
 
-	sband = ar->hw->wiphy->bands[ar->hw->conf.chandef.chan->band];
-	ratemask = sta->supp_rates[ar->hw->conf.chandef.chan->band];
+	if (WARN_ON(!arvif->arctx))
+		return;
+
+	sband = ar->hw->wiphy->bands[arvif->arctx->conf.def.chan->band];
+	ratemask = sta->supp_rates[arvif->arctx->conf.def.chan->band];
 	rates = sband->bitrates;
 
 	rateset->num_rates = 0;
@@ -1664,9 +1783,13 @@ static void ath10k_peer_assoc_h_phymode(struct ath10k *ar,
 					struct ieee80211_sta *sta,
 					struct wmi_peer_assoc_complete_arg *arg)
 {
+	struct ath10k_vif *arvif = ath10k_vif_to_arvif(vif);
 	enum wmi_phy_mode phymode = MODE_UNKNOWN;
 
-	switch (ar->hw->conf.chandef.chan->band) {
+	if (WARN_ON(!arvif->arctx))
+		return;
+
+	switch (arvif->arctx->conf.def.chan->band) {
 	case IEEE80211_BAND_2GHZ:
 		if (sta->vht_cap.vht_supported) {
 			if (sta->bandwidth == IEEE80211_STA_RX_BW_40)
@@ -1728,7 +1851,7 @@ static int ath10k_peer_assoc_prepare(struct ath10k *ar,
 
 	ath10k_peer_assoc_h_basic(ar, vif, sta, arg);
 	ath10k_peer_assoc_h_crypto(ar, vif, arg);
-	ath10k_peer_assoc_h_rates(ar, sta, arg);
+	ath10k_peer_assoc_h_rates(ar, vif, sta, arg);
 	ath10k_peer_assoc_h_ht(ar, sta, arg);
 	ath10k_peer_assoc_h_vht(ar, sta, arg);
 	ath10k_peer_assoc_h_qos(ar, vif, sta, arg);
@@ -2676,6 +2799,7 @@ void ath10k_halt(struct ath10k *ar)
 	clear_bit(ATH10K_CAC_RUNNING, &ar->dev_flags);
 	ar->filter_flags = 0;
 	ar->monitor = false;
+	ar->monitor_arvif = NULL;
 
 	if (ar->monitor_started)
 		ath10k_monitor_stop(ar);
@@ -2929,7 +3053,7 @@ static const char *chandef_get_width(enum nl80211_chan_width width)
 	return "?";
 }
 
-static void ath10k_config_chan(struct ath10k *ar)
+static void ath10k_mac_chan_reconfigure(struct ath10k *ar)
 {
 	struct ath10k_vif *arvif;
 	int ret;
@@ -3062,26 +3186,6 @@ static int ath10k_config(struct ieee80211_hw *hw, u32 changed)
 
 	mutex_lock(&ar->conf_mutex);
 
-	if (changed & IEEE80211_CONF_CHANGE_CHANNEL) {
-		ath10k_dbg(ar, ATH10K_DBG_MAC,
-			   "mac config channel %dMHz flags 0x%x radar %d\n",
-			   conf->chandef.chan->center_freq,
-			   conf->chandef.chan->flags,
-			   conf->radar_enabled);
-
-		spin_lock_bh(&ar->data_lock);
-		ar->rx_channel = conf->chandef.chan;
-		spin_unlock_bh(&ar->data_lock);
-
-		ar->radar_enabled = conf->radar_enabled;
-		ath10k_recalc_radar_detection(ar);
-
-		if (!cfg80211_chandef_identical(&ar->chandef, &conf->chandef)) {
-			ar->chandef = conf->chandef;
-			ath10k_config_chan(ar);
-		}
-	}
-
 	if (changed & IEEE80211_CONF_CHANGE_PS)
 		ath10k_config_ps(ar);
 
@@ -3329,6 +3433,15 @@ static int ath10k_add_interface(struct ieee80211_hw *hw,
 		goto err_peer_delete;
 	}
 
+	if (vif->type == NL80211_IFTYPE_MONITOR) {
+		ar->monitor_arvif = arvif;
+		ret = ath10k_monitor_recalc(ar);
+		if (ret) {
+			ath10k_warn(ar, "failed to recalc monitor: %d\n", ret);
+			goto err_peer_delete;
+		}
+	}
+
 	mutex_unlock(&ar->conf_mutex);
 	return 0;
 
@@ -3395,6 +3508,13 @@ static void ath10k_remove_interface(struct ieee80211_hw *hw,
 
 	ath10k_peer_cleanup(ar, arvif->vdev_id);
 
+	if (vif->type == NL80211_IFTYPE_MONITOR) {
+		ar->monitor_arvif = NULL;
+		ret = ath10k_monitor_recalc(ar);
+		if (ret)
+			ath10k_warn(ar, "failed to recalc monitor: %d\n", ret);
+	}
+
 	mutex_unlock(&ar->conf_mutex);
 }
 
@@ -3958,22 +4078,6 @@ static int ath10k_sta_state(struct ieee80211_hw *hw,
 			ath10k_mac_dec_num_stations(arvif);
 			goto exit;
 		}
-
-		if (vif->type == NL80211_IFTYPE_STATION) {
-			WARN_ON(arvif->is_started);
-
-			ret = ath10k_vdev_start(arvif);
-			if (ret) {
-				ath10k_warn(ar, "failed to start vdev %i: %d\n",
-					    arvif->vdev_id, ret);
-				WARN_ON(ath10k_peer_delete(ar, arvif->vdev_id,
-							   sta->addr));
-				ath10k_mac_dec_num_stations(arvif);
-				goto exit;
-			}
-
-			arvif->is_started = true;
-		}
 	} else if ((old_state == IEEE80211_STA_NONE &&
 		    new_state == IEEE80211_STA_NOTEXIST)) {
 		/*
@@ -3982,18 +4086,6 @@ static int ath10k_sta_state(struct ieee80211_hw *hw,
 		ath10k_dbg(ar, ATH10K_DBG_MAC,
 			   "mac vdev %d peer delete %pM (sta gone)\n",
 			   arvif->vdev_id, sta->addr);
-
-		if (vif->type == NL80211_IFTYPE_STATION) {
-			WARN_ON(!arvif->is_started);
-
-			ret = ath10k_vdev_stop(arvif);
-			if (ret)
-				ath10k_warn(ar, "failed to stop vdev %i: %d\n",
-					    arvif->vdev_id, ret);
-
-			arvif->is_started = false;
-		}
-
 		ret = ath10k_peer_delete(ar, arvif->vdev_id, sta->addr);
 		if (ret)
 			ath10k_warn(ar, "failed to delete peer %pM for vdev %d: %i\n",
@@ -4812,14 +4904,19 @@ static int ath10k_set_bitrate_mask(struct ieee80211_hw *hw,
 {
 	struct ath10k_vif *arvif = ath10k_vif_to_arvif(vif);
 	struct ath10k *ar = arvif->ar;
-	enum ieee80211_band band = ar->hw->conf.chandef.chan->band;
+	enum ieee80211_band band;
 	u8 fixed_rate = WMI_FIXED_RATE_NONE;
 	u8 fixed_nss = ar->num_rf_chains;
 	u8 force_sgi;
 
+	if (!arvif->arctx)
+		return -EPERM;
+
 	if (ar->cfg_tx_chainmask)
 		fixed_nss = get_nss_from_chainmask(ar->cfg_tx_chainmask);
 
+	band = arvif->arctx->conf.def.chan->band;
+
 	force_sgi = mask->control[band].gi;
 	if (force_sgi == NL80211_TXRATE_FORCE_LGI)
 		return -EINVAL;
@@ -4956,6 +5053,316 @@ static int ath10k_ampdu_action(struct ieee80211_hw *hw,
 	return -EINVAL;
 }
 
+static void
+ath10k_mac_update_rx_channel(struct ath10k *ar)
+{
+	struct ath10k_chanctx *arctx;
+	struct cfg80211_chan_def *def = NULL;
+	int num = 0;
+
+	/* Both locks are required because ar->rx_channel is modified. This
+	 * allows readers to hold either lock.
+	 */
+	lockdep_assert_held(&ar->conf_mutex);
+	lockdep_assert_held(&ar->data_lock);
+
+	/* FIXME: Sort of an optimization and a workaround. Peers and vifs are
+	 * on a linked list now. Doing a lookup peer -> vif -> chanctx for each
+	 * ppdu on Rx may reduce performance on low-end systems. It should be
+	 * possible to make tables/hashmaps to speed the lookup up (be vary of
+	 * cpu data cache lines though regarding sizes) but to keep the initial
+	 * implementation simple and less intrusive fallback to the slow lookup
+	 * only for multi-channel cases. Single-channel cases will remain to
+	 * use the old channel derival and thus performance should not be
+	 * affected much.
+	 */
+	list_for_each_entry(arctx, &ar->arctxs, list) {
+		def = &arctx->conf.def;
+		++num;
+	}
+
+	if (num == 1) {
+		ar->rx_channel = def->chan;
+		ar->chandef = *def;
+	} else {
+		ar->rx_channel = NULL;
+	}
+}
+
+static void
+ath10k_mac_chan_ctx_init(struct ath10k *ar,
+			 struct ath10k_chanctx *arctx,
+			 struct ieee80211_chanctx_conf *conf)
+{
+	lockdep_assert_held(&ar->conf_mutex);
+	lockdep_assert_held(&ar->data_lock);
+
+	memset(arctx, 0, sizeof(*arctx));
+
+	INIT_LIST_HEAD(&arctx->list);
+	list_add(&arctx->list, &ar->arctxs);
+
+	arctx->conf = *conf;
+}
+
+static int
+ath10k_mac_op_add_chanctx(struct ieee80211_hw *hw,
+			  struct ieee80211_chanctx_conf *ctx)
+{
+	struct ath10k *ar = hw->priv;
+	struct ath10k_chanctx *arctx = (void *)ctx->drv_priv;
+
+	ath10k_dbg(ar, ATH10K_DBG_MAC,
+		   "mac chanctx add freq %hu width %d ptr %p\n",
+		   ctx->def.chan->center_freq, ctx->def.width, ctx);
+
+	mutex_lock(&ar->conf_mutex);
+
+	spin_lock_bh(&ar->data_lock);
+	ath10k_mac_chan_ctx_init(ar, arctx, ctx);
+	ath10k_mac_update_rx_channel(ar);
+	spin_unlock_bh(&ar->data_lock);
+
+	ath10k_recalc_radar_detection(ar);
+	ath10k_monitor_recalc(ar);
+
+	mutex_unlock(&ar->conf_mutex);
+
+	return 0;
+}
+
+static void
+ath10k_mac_op_remove_chanctx(struct ieee80211_hw *hw,
+			     struct ieee80211_chanctx_conf *ctx)
+{
+	struct ath10k *ar = hw->priv;
+	struct ath10k_chanctx *arctx = (void *)ctx->drv_priv;
+	struct ath10k_vif *arvif;
+
+	ath10k_dbg(ar, ATH10K_DBG_MAC,
+		   "mac chanctx remove freq %hu width %d ptr %p\n",
+		   ctx->def.chan->center_freq, ctx->def.width, ctx);
+
+	mutex_lock(&ar->conf_mutex);
+
+	spin_lock_bh(&ar->data_lock);
+	list_del(&arctx->list);
+	list_for_each_entry(arvif, &ar->arvifs, list)
+		WARN(arvif->arctx == arctx,
+		     "trying to remove chanctx which is bound to vdev_id %i\n",
+		     arvif->vdev_id);
+	ath10k_mac_update_rx_channel(ar);
+	spin_unlock_bh(&ar->data_lock);
+
+	ath10k_recalc_radar_detection(ar);
+	ath10k_monitor_recalc(ar);
+
+	mutex_unlock(&ar->conf_mutex);
+}
+
+static void
+ath10k_mac_op_change_chanctx(struct ieee80211_hw *hw,
+			     struct ieee80211_chanctx_conf *ctx,
+			     u32 changed)
+{
+	struct ath10k *ar = hw->priv;
+	struct ath10k_chanctx *arctx = (void *)ctx->drv_priv;
+
+	mutex_lock(&ar->conf_mutex);
+
+	ath10k_dbg(ar, ATH10K_DBG_MAC,
+		   "mac chanctx change freq %hu->%hu width %d->%d ptr %p changed %x\n",
+		   arctx->conf.def.chan->center_freq,
+		   ctx->def.chan->center_freq,
+		   arctx->conf.def.width, ctx->def.width,
+		   ctx, changed);
+
+	/* This shouldn't really happen because channel switching should use
+	 * switch_vif_chanctx().
+	 */
+	if (WARN_ON(changed & IEEE80211_CHANCTX_CHANGE_CHANNEL))
+		goto unlock;
+
+	spin_lock_bh(&ar->data_lock);
+	arctx->conf = *ctx;
+	spin_unlock_bh(&ar->data_lock);
+
+	ath10k_recalc_radar_detection(ar);
+
+	/* FIXME: How to configure Rx chains properly? */
+
+	/* No other actions are actually necessary. Firmware maintains channel
+	 * definitions per vdev internally and there's no host-side channel
+	 * context abstraction to configure, e.g. channel width.
+	 */
+
+unlock:
+	mutex_unlock(&ar->conf_mutex);
+}
+
+static int
+ath10k_mac_op_assign_vif_chanctx(struct ieee80211_hw *hw,
+				 struct ieee80211_vif *vif,
+				 struct ieee80211_chanctx_conf *ctx)
+{
+	struct ath10k *ar = hw->priv;
+	struct ath10k_chanctx *arctx = (void *)ctx->drv_priv;
+	struct ath10k_vif *arvif = (void *)vif->drv_priv;
+	int ret;
+
+	mutex_lock(&ar->conf_mutex);
+
+	ath10k_dbg(ar, ATH10K_DBG_MAC,
+		   "mac chanctx assign ptr %p vdev_id %i\n",
+		   ctx, arvif->vdev_id);
+
+	if (WARN_ON(arvif->is_started)) {
+		mutex_unlock(&ar->conf_mutex);
+		return -EBUSY;
+	}
+
+	spin_lock_bh(&ar->data_lock);
+	if (WARN_ON(arvif->arctx)) {
+		spin_unlock_bh(&ar->data_lock);
+		mutex_unlock(&ar->conf_mutex);
+		return -EALREADY;
+	}
+	arvif->arctx = arctx;
+	spin_unlock_bh(&ar->data_lock);
+
+	ret = ath10k_vdev_start(arvif);
+	if (ret) {
+		ath10k_warn(ar, "failed to start vdev %i addr %pM on freq %d: %d\n",
+			    arvif->vdev_id, vif->addr,
+			    arctx->conf.def.chan->center_freq, ret);
+		goto err;
+	}
+
+	arvif->is_started = true;
+
+	if (vif->type == NL80211_IFTYPE_MONITOR) {
+		ret = ath10k_wmi_vdev_up(ar, arvif->vdev_id, 0, vif->addr);
+		if (ret) {
+			ath10k_warn(ar, "failed to up monitor vdev %i: %d\n",
+				    arvif->vdev_id, ret);
+			goto err_stop;
+		}
+
+		arvif->is_up = true;
+	}
+
+	mutex_unlock(&ar->conf_mutex);
+	return 0;
+
+err_stop:
+	ath10k_vdev_stop(arvif);
+	arvif->is_started = false;
+
+err:
+	spin_lock_bh(&ar->data_lock);
+	arvif->arctx = NULL;
+	spin_unlock_bh(&ar->data_lock);
+
+	mutex_unlock(&ar->conf_mutex);
+	return ret;
+}
+
+static void
+ath10k_mac_op_unassign_vif_chanctx(struct ieee80211_hw *hw,
+				   struct ieee80211_vif *vif,
+				   struct ieee80211_chanctx_conf *ctx)
+{
+	struct ath10k *ar = hw->priv;
+	struct ath10k_chanctx *arctx = (void *)ctx->drv_priv;
+	struct ath10k_vif *arvif = (void *)vif->drv_priv;
+	int ret;
+
+	mutex_lock(&ar->conf_mutex);
+
+	ath10k_dbg(ar, ATH10K_DBG_MAC,
+		   "mac chanctx unassign ptr %p vdev_id %i\n",
+		   ctx, arvif->vdev_id);
+
+	spin_lock_bh(&ar->data_lock);
+	WARN_ON(!arvif->arctx);
+	WARN_ON(arvif->arctx != arctx);
+	arvif->arctx = NULL;
+	spin_unlock_bh(&ar->data_lock);
+
+	WARN_ON(!arvif->is_started);
+
+	if (vif->type == NL80211_IFTYPE_MONITOR) {
+		WARN_ON(!arvif->is_up);
+
+		ret = ath10k_wmi_vdev_down(ar, arvif->vdev_id);
+		if (ret)
+			ath10k_warn(ar, "failed to down monitor vdev %i: %d\n",
+				    arvif->vdev_id, ret);
+
+		arvif->is_up = false;
+	}
+
+	ret = ath10k_vdev_stop(arvif);
+	if (ret)
+		ath10k_warn(ar, "failed to stop vdev %i: %d\n",
+			    arvif->vdev_id, ret);
+
+	arvif->is_started = false;
+
+	mutex_unlock(&ar->conf_mutex);
+}
+
+static int
+ath10k_mac_op_switch_vif_chanctx(struct ieee80211_hw *hw,
+				 struct ieee80211_vif_chanctx_switch *vifs,
+				 int n_vifs,
+				 enum ieee80211_chanctx_switch_mode mode)
+{
+	struct ath10k *ar = hw->priv;
+	struct ath10k_vif *arvif;
+	struct ath10k_chanctx *arctx_new, *arctx_old;
+	int i;
+
+	mutex_lock(&ar->conf_mutex);
+
+	ath10k_dbg(ar, ATH10K_DBG_MAC,
+		   "mac chanctx switch n_vifs %d mode %d\n",
+		   n_vifs, mode);
+
+	spin_lock_bh(&ar->data_lock);
+	for (i = 0; i < n_vifs; i++) {
+		arvif = ath10k_vif_to_arvif(vifs[i].vif);
+		arctx_new = (void *)vifs[i].new_ctx->drv_priv;
+		arctx_old = (void *)vifs[i].old_ctx->drv_priv;
+
+		ath10k_dbg(ar, ATH10K_DBG_MAC,
+			   "mac chanctx switch vdev_id %i freq %hu->%hu width %d->%d ptr %p->%p\n",
+			   arvif->vdev_id,
+			   vifs[i].old_ctx->def.chan->center_freq,
+			   vifs[i].new_ctx->def.chan->center_freq,
+			   vifs[i].old_ctx->def.width,
+			   vifs[i].new_ctx->def.width,
+			   arctx_old, arctx_new);
+
+		if (mode == CHANCTX_SWMODE_SWAP_CONTEXTS) {
+			list_del(&arctx_old->list);
+			ath10k_mac_chan_ctx_init(ar, arctx_new,
+						 vifs[i].new_ctx);
+		}
+
+		arvif->arctx = arctx_new;
+		arvif->arctx->conf = *vifs[i].new_ctx;
+	}
+	ath10k_mac_update_rx_channel(ar);
+	spin_unlock_bh(&ar->data_lock);
+
+	/* FIXME: Reconfigure only affected vifs */
+	ath10k_mac_chan_reconfigure(ar);
+
+	mutex_unlock(&ar->conf_mutex);
+	return 0;
+}
+
 static const struct ieee80211_ops ath10k_ops = {
 	.tx				= ath10k_tx,
 	.start				= ath10k_start,
@@ -4986,6 +5393,12 @@ static const struct ieee80211_ops ath10k_ops = {
 	.get_et_sset_count		= ath10k_debug_get_et_sset_count,
 	.get_et_stats			= ath10k_debug_get_et_stats,
 	.get_et_strings			= ath10k_debug_get_et_strings,
+	.add_chanctx			= ath10k_mac_op_add_chanctx,
+	.remove_chanctx			= ath10k_mac_op_remove_chanctx,
+	.change_chanctx			= ath10k_mac_op_change_chanctx,
+	.assign_vif_chanctx		= ath10k_mac_op_assign_vif_chanctx,
+	.unassign_vif_chanctx		= ath10k_mac_op_unassign_vif_chanctx,
+	.switch_vif_chanctx		= ath10k_mac_op_switch_vif_chanctx,
 
 	CFG80211_TESTMODE_CMD(ath10k_tm_cmd)
 
@@ -5357,6 +5770,7 @@ int ath10k_mac_register(struct ath10k *ar)
 			IEEE80211_HW_REPORTS_TX_ACK_STATUS |
 			IEEE80211_HW_HAS_RATE_CONTROL |
 			IEEE80211_HW_AP_LINK_PS |
+			IEEE80211_HW_WANT_MONITOR_VIF |
 			IEEE80211_HW_SPECTRUM_MGMT;
 
 	ar->hw->wiphy->features |= NL80211_FEATURE_STATIC_SMPS;
@@ -5374,6 +5788,7 @@ int ath10k_mac_register(struct ath10k *ar)
 
 	ar->hw->vif_data_size = sizeof(struct ath10k_vif);
 	ar->hw->sta_data_size = sizeof(struct ath10k_sta);
+	ar->hw->chanctx_data_size = sizeof(struct ath10k_chanctx);
 
 	ar->hw->max_listen_interval = ATH10K_MAX_HW_LISTEN_INTERVAL;
 
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 97ee2e9..0b49ec4 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -2504,6 +2504,7 @@ static void ath10k_dfs_radar_report(struct ath10k *ar,
 				    u64 tsf)
 {
 	u32 reg0, reg1, tsf32l;
+	struct ieee80211_channel *ch;
 	struct pulse_event pe;
 	u64 tsf64;
 	u8 rssi, width;
@@ -2532,6 +2533,15 @@ static void ath10k_dfs_radar_report(struct ath10k *ar,
 	if (!ar->dfs_detector)
 		return;
 
+	spin_lock_bh(&ar->data_lock);
+	ch = ar->rx_channel;
+	spin_unlock_bh(&ar->data_lock);
+
+	if (!ch) {
+		ath10k_warn(ar, "failed to derive channel for radar pulse, treating as radar\n");
+		goto radar_detected;
+	}
+
 	/* report event to DFS pattern detector */
 	tsf32l = __le32_to_cpu(phyerr->tsf_timestamp);
 	tsf64 = tsf & (~0xFFFFFFFFULL);
@@ -2547,7 +2557,7 @@ static void ath10k_dfs_radar_report(struct ath10k *ar,
 		rssi = 0;
 
 	pe.ts = tsf64;
-	pe.freq = ar->hw->conf.chandef.chan->center_freq;
+	pe.freq = ch->center_freq;
 	pe.width = width;
 	pe.rssi = rssi;
 
@@ -2563,6 +2573,7 @@ static void ath10k_dfs_radar_report(struct ath10k *ar,
 		return;
 	}
 
+radar_detected:
 	ath10k_dbg(ar, ATH10K_DBG_REGULATORY, "dfs radar detected\n");
 	ATH10K_DFS_STAT_INC(ar, radar_detected);
 
-- 
1.8.5.3

