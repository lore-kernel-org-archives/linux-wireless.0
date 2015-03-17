Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f53.google.com ([209.85.215.53]:33934 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073AbbCQMdZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Mar 2015 08:33:25 -0400
Received: by lagg8 with SMTP id g8so7135357lag.1
        for <linux-wireless@vger.kernel.org>; Tue, 17 Mar 2015 05:33:23 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v4 2/7] ath10k: implement chanctx API
Date: Tue, 17 Mar 2015 12:30:43 +0000
Message-Id: <1426595448-1630-3-git-send-email-michal.kazior@tieto.com> (sfid-20150317_133331_670663_D1947776)
In-Reply-To: <1426595448-1630-1-git-send-email-michal.kazior@tieto.com>
References: <1426595448-1630-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The chanctx API will allow ath10k to support
multi-channel operation.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---

Notes:
    v2:
     * prevent null deref in ath10k_peer_assoc_h_vht()
       after rebasing to latest master branch
    
    v3:
     * remove chanctx internal ath10k list [Johannes]
       (I still keep local chandef copy)
     * remove arvif->arctx and use vif->chanctx_conf directly
     * remove ar->chandef
     * fix typo sanity check (arvif->arctx was checked twice in rx_h_peer_channel;
       arvif itself should be checked too)
     * skip presp template setup for IBSS
    
    v4;
     * fix CSA
     * refactor monitor recalc code a bit

 drivers/net/wireless/ath/ath10k/core.h   |  10 +
 drivers/net/wireless/ath/ath10k/htt_rx.c | 102 ++++-
 drivers/net/wireless/ath/ath10k/mac.c    | 683 +++++++++++++++++++++++++------
 drivers/net/wireless/ath/ath10k/mac.h    |  11 +
 drivers/net/wireless/ath/ath10k/wmi.c    |  13 +-
 5 files changed, 697 insertions(+), 122 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index c1f43b0..d54e12d 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -281,6 +281,15 @@ struct ath10k_sta {
 #endif
 };
 
+struct ath10k_chanctx {
+	/* Used to story copy of chanctx_conf to avoid inconsistencies. Ideally
+	 * mac80211 should allow some sort of explicit locking to guarantee
+	 * that the publicly available chanctx_conf can be accessed safely at
+	 * all times.
+	 */
+	struct ieee80211_chanctx_conf conf;
+};
+
 #define ATH10K_VDEV_SETUP_TIMEOUT_HZ (5*HZ)
 
 enum ath10k_beacon_state {
@@ -596,6 +605,7 @@ struct ath10k {
 	struct cfg80211_chan_def chandef;
 
 	unsigned long long free_vdev_map;
+	struct ath10k_vif *monitor_arvif;
 	bool monitor;
 	int monitor_vdev_id;
 	bool monitor_started;
diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 01a2b38..daf9d2f 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -773,8 +773,89 @@ static void ath10k_htt_rx_h_rates(struct ath10k *ar,
 	}
 }
 
+static struct ieee80211_channel *
+ath10k_htt_rx_h_peer_channel(struct ath10k *ar, struct htt_rx_desc *rxd)
+{
+	struct ath10k_peer *peer;
+	struct ath10k_vif *arvif;
+	struct ath10k_chanctx *arctx;
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
+	if (WARN_ON_ONCE(!arvif))
+		return NULL;
+
+	arctx = ath10k_mac_vif_ctx(arvif);
+	if (WARN_ON_ONCE(!arctx))
+		return NULL;
+
+	return arctx->conf.def.chan;
+}
+
+static struct ieee80211_channel *
+ath10k_htt_rx_h_vdev_channel(struct ath10k *ar, u32 vdev_id)
+{
+	struct ath10k_vif *arvif;
+	struct ath10k_chanctx *arctx;
+
+	lockdep_assert_held(&ar->data_lock);
+
+	list_for_each_entry(arvif, &ar->arvifs, list) {
+		arctx = ath10k_mac_vif_ctx(arvif);
+
+		if (arvif->vdev_id == vdev_id && arctx)
+			return arctx->conf.def.chan;
+	}
+
+	return NULL;
+}
+
+static void
+ath10k_htt_rx_h_any_chan_iter(struct ieee80211_hw *hw,
+			      struct ieee80211_chanctx_conf *conf,
+			      void *data)
+{
+	struct cfg80211_chan_def *def = data;
+
+	*def = conf->def;
+}
+
+static struct ieee80211_channel *
+ath10k_htt_rx_h_any_channel(struct ath10k *ar)
+{
+	struct cfg80211_chan_def def = {};
+
+	ieee80211_iter_chan_contexts_atomic(ar->hw,
+					    ath10k_htt_rx_h_any_chan_iter,
+					    &def);
+
+	return def.chan;
+}
+
 static bool ath10k_htt_rx_h_channel(struct ath10k *ar,
-				    struct ieee80211_rx_status *status)
+				    struct ieee80211_rx_status *status,
+				    struct htt_rx_desc *rxd,
+				    u32 vdev_id)
 {
 	struct ieee80211_channel *ch;
 
@@ -782,6 +863,12 @@ static bool ath10k_htt_rx_h_channel(struct ath10k *ar,
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
@@ -819,7 +906,8 @@ static void ath10k_htt_rx_h_mactime(struct ath10k *ar,
 
 static void ath10k_htt_rx_h_ppdu(struct ath10k *ar,
 				 struct sk_buff_head *amsdu,
-				 struct ieee80211_rx_status *status)
+				 struct ieee80211_rx_status *status,
+				 u32 vdev_id)
 {
 	struct sk_buff *first;
 	struct htt_rx_desc *rxd;
@@ -851,7 +939,7 @@ static void ath10k_htt_rx_h_ppdu(struct ath10k *ar,
 		status->flag |= RX_FLAG_NO_SIGNAL_VAL;
 
 		ath10k_htt_rx_h_signal(ar, status, rxd);
-		ath10k_htt_rx_h_channel(ar, status);
+		ath10k_htt_rx_h_channel(ar, status, rxd, vdev_id);
 		ath10k_htt_rx_h_rates(ar, status, rxd);
 	}
 
@@ -1522,7 +1610,7 @@ static void ath10k_htt_rx_handler(struct ath10k_htt *htt,
 			break;
 		}
 
-		ath10k_htt_rx_h_ppdu(ar, &amsdu, rx_status);
+		ath10k_htt_rx_h_ppdu(ar, &amsdu, rx_status, 0xffff);
 		ath10k_htt_rx_h_unchain(ar, &amsdu, ret > 0);
 		ath10k_htt_rx_h_filter(ar, &amsdu, rx_status);
 		ath10k_htt_rx_h_mpdu(ar, &amsdu, rx_status);
@@ -1569,7 +1657,7 @@ static void ath10k_htt_rx_frag_handler(struct ath10k_htt *htt,
 		return;
 	}
 
-	ath10k_htt_rx_h_ppdu(ar, &amsdu, rx_status);
+	ath10k_htt_rx_h_ppdu(ar, &amsdu, rx_status, 0xffff);
 	ath10k_htt_rx_h_filter(ar, &amsdu, rx_status);
 	ath10k_htt_rx_h_mpdu(ar, &amsdu, rx_status);
 	ath10k_htt_rx_h_deliver(ar, &amsdu, rx_status);
@@ -1796,7 +1884,7 @@ static void ath10k_htt_rx_h_rx_offload(struct ath10k *ar,
 		status->flag |= RX_FLAG_NO_SIGNAL_VAL;
 
 		ath10k_htt_rx_h_rx_offload_prot(status, msdu);
-		ath10k_htt_rx_h_channel(ar, status);
+		ath10k_htt_rx_h_channel(ar, status, NULL, rx->vdev_id);
 		ath10k_process_rx(ar, status, msdu);
 	}
 }
@@ -1869,7 +1957,7 @@ static void ath10k_htt_rx_in_ord_ind(struct ath10k *ar, struct sk_buff *skb)
 			 * better to report something than nothing though. This
 			 * should still give an idea about rx rate to the user.
 			 */
-			ath10k_htt_rx_h_ppdu(ar, &amsdu, status);
+			ath10k_htt_rx_h_ppdu(ar, &amsdu, status, vdev_id);
 			ath10k_htt_rx_h_filter(ar, &amsdu, status);
 			ath10k_htt_rx_h_mpdu(ar, &amsdu, status);
 			ath10k_htt_rx_h_deliver(ar, &amsdu, status);
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 1214a3b..8b64313 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -428,6 +428,36 @@ static u8 ath10k_parse_mpdudensity(u8 mpdudensity)
 	}
 }
 
+static void ath10k_mac_num_chanctxs_iter(struct ieee80211_hw *hw,
+					 struct ieee80211_chanctx_conf *conf,
+					 void *data)
+{
+	int *num = data;
+
+	(*num)++;
+}
+
+static int ath10k_mac_num_chanctxs(struct ath10k *ar)
+{
+	int num = 0;
+
+	ieee80211_iter_chan_contexts_atomic(ar->hw,
+					    ath10k_mac_num_chanctxs_iter,
+					    &num);
+
+	return num;
+}
+
+static void
+ath10k_mac_get_any_chandef_iter(struct ieee80211_hw *hw,
+				struct ieee80211_chanctx_conf *conf,
+				void *data)
+{
+	struct cfg80211_chan_def **def = data;
+
+	*def = &conf->def;
+}
+
 static int ath10k_peer_create(struct ath10k *ar, u32 vdev_id, const u8 *addr)
 {
 	int ret;
@@ -642,13 +672,21 @@ static inline int ath10k_vdev_setup_sync(struct ath10k *ar)
 
 static int ath10k_monitor_vdev_start(struct ath10k *ar, int vdev_id)
 {
-	struct cfg80211_chan_def *chandef = &ar->chandef;
+	struct cfg80211_chan_def *chandef = NULL;
 	struct ieee80211_channel *channel = chandef->chan;
 	struct wmi_vdev_start_request_arg arg = {};
 	int ret = 0;
 
 	lockdep_assert_held(&ar->conf_mutex);
 
+	ieee80211_iter_chan_contexts_atomic(ar->hw,
+					    ath10k_mac_get_any_chandef_iter,
+					    &chandef);
+	if (WARN_ON_ONCE(!chandef))
+		return -ENOENT;
+
+	channel = chandef->chan;
+
 	arg.vdev_id = vdev_id;
 	arg.channel.freq = channel->center_freq;
 	arg.channel.band_center_freq1 = chandef->center_freq1;
@@ -849,27 +887,79 @@ static bool ath10k_mac_should_disable_promisc(struct ath10k *ar)
 	return true;
 }
 
+static bool ath10k_mac_monitor_vdev_is_needed(struct ath10k *ar)
+{
+	int num_ctx;
+
+	/* At least one chanctx is required to derive a channel to start
+	 * monitor vdev on.
+	 */
+	num_ctx = ath10k_mac_num_chanctxs(ar);
+	if (num_ctx == 0)
+		return false;
+
+	/* If there's already an existing special monitor interface then don't
+	 * bother creating another monitor vdev.
+	 */
+	if (ar->monitor_arvif)
+		return false;
+
+	return ar->monitor ||
+	       !ath10k_mac_should_disable_promisc(ar) ||
+	       test_bit(ATH10K_CAC_RUNNING, &ar->dev_flags);
+}
+
+static bool ath10k_mac_monitor_vdev_is_allowed(struct ath10k *ar)
+{
+	int num_ctx;
+
+	num_ctx = ath10k_mac_num_chanctxs(ar);
+
+	/* FIXME: Current interface combinations and cfg80211/mac80211 code
+	 * shouldn't allow this but make sure to prevent handling the following
+	 * case anyway since multi-channel DFS hasn't been tested at all.
+	 */
+	if (test_bit(ATH10K_CAC_RUNNING, &ar->dev_flags) && num_ctx > 1)
+		return false;
+
+	return true;
+}
+
 static int ath10k_monitor_recalc(struct ath10k *ar)
 {
-	bool should_start;
+	bool needed;
+	bool allowed;
+	int ret;
 
 	lockdep_assert_held(&ar->conf_mutex);
 
-	should_start = ar->monitor ||
-		       !ath10k_mac_should_disable_promisc(ar) ||
-		       test_bit(ATH10K_CAC_RUNNING, &ar->dev_flags);
+	needed = ath10k_mac_monitor_vdev_is_needed(ar);
+	allowed = ath10k_mac_monitor_vdev_is_allowed(ar);
 
 	ath10k_dbg(ar, ATH10K_DBG_MAC,
-		   "mac monitor recalc started? %d should? %d\n",
-		   ar->monitor_started, should_start);
+		   "mac monitor recalc started? %d needed? %d allowed? %d\n",
+		   ar->monitor_started, needed, allowed);
+
+	if (WARN_ON(needed && !allowed)) {
+		if (ar->monitor_started) {
+			ath10k_dbg(ar, ATH10K_DBG_MAC, "mac monitor stopping disallowed monitor\n");
+
+			ret = ath10k_monitor_stop(ar);
+			if (ret)
+				ath10k_warn(ar, "failed to stop disallowed monitor: %d\n", ret);
+				/* not serious */
+		}
 
-	if (should_start == ar->monitor_started)
+		return -EPERM;
+	}
+
+	if (needed == ar->monitor_started)
 		return 0;
 
-	if (should_start)
+	if (needed)
 		return ath10k_monitor_start(ar);
-
-	return ath10k_monitor_stop(ar);
+	else
+		return ath10k_monitor_stop(ar);
 }
 
 static int ath10k_recalc_rtscts_prot(struct ath10k_vif *arvif)
@@ -929,6 +1019,27 @@ static int ath10k_stop_cac(struct ath10k *ar)
 	return 0;
 }
 
+static void ath10k_mac_has_radar_iter(struct ieee80211_hw *hw,
+				      struct ieee80211_chanctx_conf *conf,
+				      void *data)
+{
+	bool *ret = data;
+
+	if (!*ret && conf->radar_enabled)
+		*ret = true;
+}
+
+static bool ath10k_mac_has_radar_enabled(struct ath10k *ar)
+{
+	bool has_radar = false;
+
+	ieee80211_iter_chan_contexts_atomic(ar->hw,
+					    ath10k_mac_has_radar_iter,
+					    &has_radar);
+
+	return has_radar;
+}
+
 static void ath10k_recalc_radar_detection(struct ath10k *ar)
 {
 	int ret;
@@ -937,7 +1048,7 @@ static void ath10k_recalc_radar_detection(struct ath10k *ar)
 
 	ath10k_stop_cac(ar);
 
-	if (!ar->radar_enabled)
+	if (!ath10k_mac_has_radar_enabled(ar))
 		return;
 
 	if (ar->num_started_vdevs > 0)
@@ -988,15 +1099,19 @@ static int ath10k_vdev_stop(struct ath10k_vif *arvif)
 	return ret;
 }
 
-static int ath10k_vdev_start_restart(struct ath10k_vif *arvif, bool restart)
+static int ath10k_vdev_start_restart(struct ath10k_vif *arvif,
+				     struct ath10k_chanctx *arctx,
+				     bool restart)
 {
 	struct ath10k *ar = arvif->ar;
-	struct cfg80211_chan_def *chandef = &ar->chandef;
+	struct cfg80211_chan_def *chandef;
 	struct wmi_vdev_start_request_arg arg = {};
 	int ret = 0, ret2;
 
 	lockdep_assert_held(&ar->conf_mutex);
 
+	chandef = &arctx->conf.def;
+
 	reinit_completion(&ar->vdev_setup_done);
 
 	arg.vdev_id = arvif->vdev_id;
@@ -1065,14 +1180,16 @@ static int ath10k_vdev_start_restart(struct ath10k_vif *arvif, bool restart)
 	return ret;
 }
 
-static int ath10k_vdev_start(struct ath10k_vif *arvif)
+static int ath10k_vdev_start(struct ath10k_vif *arvif,
+			     struct ath10k_chanctx *arctx)
 {
-	return ath10k_vdev_start_restart(arvif, false);
+	return ath10k_vdev_start_restart(arvif, arctx, false);
 }
 
-static int ath10k_vdev_restart(struct ath10k_vif *arvif)
+static int ath10k_vdev_restart(struct ath10k_vif *arvif,
+			       struct ath10k_chanctx *arctx)
 {
-	return ath10k_vdev_start_restart(arvif, true);
+	return ath10k_vdev_start_restart(arvif, arctx, true);
 }
 
 static int ath10k_mac_setup_bcn_p2p_ie(struct ath10k_vif *arvif,
@@ -1219,6 +1336,77 @@ static int ath10k_mac_setup_prb_tmpl(struct ath10k_vif *arvif)
 	return 0;
 }
 
+static int ath10k_mac_vif_fix_hidden_ssid(struct ath10k_vif *arvif)
+{
+	struct ath10k *ar = arvif->ar;
+	struct ath10k_chanctx *arctx = ath10k_mac_vif_ctx(arvif);
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
+	ret = ath10k_vdev_restart(arvif, arctx);
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
@@ -1228,9 +1416,11 @@ static void ath10k_control_beaconing(struct ath10k_vif *arvif,
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
@@ -1242,10 +1432,6 @@ static void ath10k_control_beaconing(struct ath10k_vif *arvif,
 
 	arvif->tx_seq_no = 0x1000;
 
-	ret = ath10k_vdev_start(arvif);
-	if (ret)
-		return;
-
 	arvif->aid = 0;
 	ether_addr_copy(arvif->bssid, info->bssid);
 
@@ -1254,13 +1440,18 @@ static void ath10k_control_beaconing(struct ath10k_vif *arvif,
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
 
@@ -1622,13 +1813,19 @@ static void ath10k_peer_assoc_h_crypto(struct ath10k *ar,
 				       struct wmi_peer_assoc_complete_arg *arg)
 {
 	struct ieee80211_bss_conf *info = &vif->bss_conf;
+	struct ath10k_vif *arvif = ath10k_vif_to_arvif(vif);
+	struct ath10k_chanctx *arctx;
 	struct cfg80211_bss *bss;
 	const u8 *rsnie = NULL;
 	const u8 *wpaie = NULL;
 
 	lockdep_assert_held(&ar->conf_mutex);
 
-	bss = cfg80211_get_bss(ar->hw->wiphy, ar->hw->conf.chandef.chan,
+	arctx = ath10k_mac_vif_ctx(arvif);
+	if (WARN_ON(!arctx))
+		return;
+
+	bss = cfg80211_get_bss(ar->hw->wiphy, arctx->conf.def.chan,
 			       info->bssid, NULL, 0, IEEE80211_BSS_TYPE_ANY,
 			       IEEE80211_PRIVACY_ANY);
 	if (bss) {
@@ -1660,10 +1857,13 @@ static void ath10k_peer_assoc_h_crypto(struct ath10k *ar,
 }
 
 static void ath10k_peer_assoc_h_rates(struct ath10k *ar,
+				      struct ieee80211_vif *vif,
 				      struct ieee80211_sta *sta,
 				      struct wmi_peer_assoc_complete_arg *arg)
 {
 	struct wmi_rate_set_arg *rateset = &arg->peer_legacy_rates;
+	struct ath10k_vif *arvif = ath10k_vif_to_arvif(vif);
+	struct ath10k_chanctx *arctx = ath10k_mac_vif_ctx(arvif);
 	const struct ieee80211_supported_band *sband;
 	const struct ieee80211_rate *rates;
 	u32 ratemask;
@@ -1671,8 +1871,11 @@ static void ath10k_peer_assoc_h_rates(struct ath10k *ar,
 
 	lockdep_assert_held(&ar->conf_mutex);
 
-	sband = ar->hw->wiphy->bands[ar->hw->conf.chandef.chan->band];
-	ratemask = sta->supp_rates[ar->hw->conf.chandef.chan->band];
+	if (WARN_ON(!arctx))
+		return;
+
+	sband = ar->hw->wiphy->bands[arctx->conf.def.chan->band];
+	ratemask = sta->supp_rates[arctx->conf.def.chan->band];
 	rates = sband->bitrates;
 
 	rateset->num_rates = 0;
@@ -1837,18 +2040,24 @@ static int ath10k_peer_assoc_qos_ap(struct ath10k *ar,
 }
 
 static void ath10k_peer_assoc_h_vht(struct ath10k *ar,
+				    struct ieee80211_vif *vif,
 				    struct ieee80211_sta *sta,
 				    struct wmi_peer_assoc_complete_arg *arg)
 {
 	const struct ieee80211_sta_vht_cap *vht_cap = &sta->vht_cap;
+	struct ath10k_vif *arvif = ath10k_vif_to_arvif(vif);
+	struct ath10k_chanctx *arctx = ath10k_mac_vif_ctx(arvif);
 	u8 ampdu_factor;
 
+	if (WARN_ON(!arctx))
+		return;
+
 	if (!vht_cap->vht_supported)
 		return;
 
 	arg->peer_flags |= WMI_PEER_VHT;
 
-	if (ar->hw->conf.chandef.chan->band == IEEE80211_BAND_2GHZ)
+	if (arctx->conf.def.chan->band == IEEE80211_BAND_2GHZ)
 		arg->peer_flags |= WMI_PEER_VHT_2G;
 
 	arg->peer_vht_caps = vht_cap->cap;
@@ -1925,9 +2134,14 @@ static void ath10k_peer_assoc_h_phymode(struct ath10k *ar,
 					struct ieee80211_sta *sta,
 					struct wmi_peer_assoc_complete_arg *arg)
 {
+	struct ath10k_vif *arvif = ath10k_vif_to_arvif(vif);
+	struct ath10k_chanctx *arctx = ath10k_mac_vif_ctx(arvif);
 	enum wmi_phy_mode phymode = MODE_UNKNOWN;
 
-	switch (ar->hw->conf.chandef.chan->band) {
+	if (WARN_ON(!arctx))
+		return;
+
+	switch (arctx->conf.def.chan->band) {
 	case IEEE80211_BAND_2GHZ:
 		if (sta->vht_cap.vht_supported) {
 			if (sta->bandwidth == IEEE80211_STA_RX_BW_40)
@@ -1989,9 +2203,9 @@ static int ath10k_peer_assoc_prepare(struct ath10k *ar,
 
 	ath10k_peer_assoc_h_basic(ar, vif, sta, arg);
 	ath10k_peer_assoc_h_crypto(ar, vif, arg);
-	ath10k_peer_assoc_h_rates(ar, sta, arg);
+	ath10k_peer_assoc_h_rates(ar, vif, sta, arg);
 	ath10k_peer_assoc_h_ht(ar, sta, arg);
-	ath10k_peer_assoc_h_vht(ar, sta, arg);
+	ath10k_peer_assoc_h_vht(ar, vif, sta, arg);
 	ath10k_peer_assoc_h_qos(ar, vif, sta, arg);
 	ath10k_peer_assoc_h_phymode(ar, vif, sta, arg);
 
@@ -2980,6 +3194,7 @@ void ath10k_halt(struct ath10k *ar)
 	clear_bit(ATH10K_CAC_RUNNING, &ar->dev_flags);
 	ar->filter_flags = 0;
 	ar->monitor = false;
+	ar->monitor_arvif = NULL;
 
 	if (ar->monitor_started)
 		ath10k_monitor_stop(ar);
@@ -3210,42 +3425,15 @@ static int ath10k_config_ps(struct ath10k *ar)
 	return ret;
 }
 
-static const char *chandef_get_width(enum nl80211_chan_width width)
-{
-	switch (width) {
-	case NL80211_CHAN_WIDTH_20_NOHT:
-		return "20 (noht)";
-	case NL80211_CHAN_WIDTH_20:
-		return "20";
-	case NL80211_CHAN_WIDTH_40:
-		return "40";
-	case NL80211_CHAN_WIDTH_80:
-		return "80";
-	case NL80211_CHAN_WIDTH_80P80:
-		return "80+80";
-	case NL80211_CHAN_WIDTH_160:
-		return "160";
-	case NL80211_CHAN_WIDTH_5:
-		return "5";
-	case NL80211_CHAN_WIDTH_10:
-		return "10";
-	}
-	return "?";
-}
-
-static void ath10k_config_chan(struct ath10k *ar)
+static void ath10k_mac_chan_reconfigure(struct ath10k *ar)
 {
 	struct ath10k_vif *arvif;
+	struct ath10k_chanctx *arctx;
 	int ret;
 
 	lockdep_assert_held(&ar->conf_mutex);
 
-	ath10k_dbg(ar, ATH10K_DBG_MAC,
-		   "mac config channel to %dMHz (cf1 %dMHz cf2 %dMHz width %s)\n",
-		   ar->chandef.chan->center_freq,
-		   ar->chandef.center_freq1,
-		   ar->chandef.center_freq2,
-		   chandef_get_width(ar->chandef.width));
+	ath10k_dbg(ar, ATH10K_DBG_MAC, "mac chan reconfigure\n");
 
 	/* First stop monitor interface. Some FW versions crash if there's a
 	 * lone monitor interface. */
@@ -3289,7 +3477,11 @@ static void ath10k_config_chan(struct ath10k *ar)
 			ath10k_warn(ar, "failed to update prb tmpl during csa: %d\n",
 				    ret);
 
-		ret = ath10k_vdev_restart(arvif);
+		arctx = ath10k_mac_vif_ctx(arvif);
+		if (WARN_ON(!arctx))
+			continue;
+
+		ret = ath10k_vdev_restart(arvif, arctx);
 		if (ret) {
 			ath10k_warn(ar, "failed to restart vdev %d: %d\n",
 				    arvif->vdev_id, ret);
@@ -3376,26 +3568,6 @@ static int ath10k_config(struct ieee80211_hw *hw, u32 changed)
 
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
 
@@ -3638,6 +3810,15 @@ static int ath10k_add_interface(struct ieee80211_hw *hw,
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
 
@@ -3721,6 +3902,13 @@ static void ath10k_remove_interface(struct ieee80211_hw *hw,
 
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
 
@@ -4379,22 +4567,6 @@ static int ath10k_sta_state(struct ieee80211_hw *hw,
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
@@ -4403,18 +4575,6 @@ static int ath10k_sta_state(struct ieee80211_hw *hw,
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
@@ -5232,15 +5392,21 @@ static int ath10k_set_bitrate_mask(struct ieee80211_hw *hw,
 				   const struct cfg80211_bitrate_mask *mask)
 {
 	struct ath10k_vif *arvif = ath10k_vif_to_arvif(vif);
+	struct ath10k_chanctx *arctx = ath10k_mac_vif_ctx(arvif);
 	struct ath10k *ar = arvif->ar;
-	enum ieee80211_band band = ar->hw->conf.chandef.chan->band;
+	enum ieee80211_band band;
 	u8 fixed_rate = WMI_FIXED_RATE_NONE;
 	u8 fixed_nss = ar->num_rf_chains;
 	u8 force_sgi;
 
+	if (!arctx)
+		return -EPERM;
+
 	if (ar->cfg_tx_chainmask)
 		fixed_nss = get_nss_from_chainmask(ar->cfg_tx_chainmask);
 
+	band = arctx->conf.def.chan->band;
+
 	force_sgi = mask->control[band].gi;
 	if (force_sgi == NL80211_TXRATE_FORCE_LGI)
 		return -EINVAL;
@@ -5377,6 +5543,286 @@ static int ath10k_ampdu_action(struct ieee80211_hw *hw,
 	return -EINVAL;
 }
 
+static void
+ath10k_mac_update_rx_channel(struct ath10k *ar)
+{
+	struct cfg80211_chan_def *def = NULL;
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
+	rcu_read_lock();
+	if (ath10k_mac_num_chanctxs(ar) == 1) {
+		ieee80211_iter_chan_contexts_atomic(ar->hw,
+					ath10k_mac_get_any_chandef_iter,
+					&def);
+		ar->rx_channel = def->chan;
+	} else {
+		ar->rx_channel = NULL;
+	}
+	rcu_read_unlock();
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
+
+	ath10k_dbg(ar, ATH10K_DBG_MAC,
+		   "mac chanctx remove freq %hu width %d ptr %p\n",
+		   ctx->def.chan->center_freq, ctx->def.width, ctx);
+
+	mutex_lock(&ar->conf_mutex);
+
+	spin_lock_bh(&ar->data_lock);
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
+	ret = ath10k_vdev_start(arvif, arctx);
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
+	struct ath10k_vif *arvif = (void *)vif->drv_priv;
+	int ret;
+
+	mutex_lock(&ar->conf_mutex);
+
+	ath10k_dbg(ar, ATH10K_DBG_MAC,
+		   "mac chanctx unassign ptr %p vdev_id %i\n",
+		   ctx, arvif->vdev_id);
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
+			ath10k_mac_chan_ctx_init(ar, arctx_new,
+						 vifs[i].new_ctx);
+		}
+
+		arctx_new->conf = *vifs[i].new_ctx;
+
+		/* FIXME: ath10k_mac_chan_reconfigure() uses current, i.e. not
+		 * yet updated chanctx_conf pointer.
+		 */
+		arctx_old->conf = *vifs[i].new_ctx;
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
@@ -5408,6 +5854,12 @@ static const struct ieee80211_ops ath10k_ops = {
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
 
@@ -5807,7 +6259,9 @@ int ath10k_mac_register(struct ath10k *ar)
 			IEEE80211_HW_AP_LINK_PS |
 			IEEE80211_HW_SPECTRUM_MGMT |
 			IEEE80211_HW_SW_CRYPTO_CONTROL |
-			IEEE80211_HW_CONNECTION_MONITOR;
+			IEEE80211_HW_CONNECTION_MONITOR |
+			IEEE80211_HW_WANT_MONITOR_VIF |
+			IEEE80211_HW_CHANCTX_STA_CSA;
 
 	ar->hw->wiphy->features |= NL80211_FEATURE_STATIC_SMPS;
 
@@ -5824,6 +6278,7 @@ int ath10k_mac_register(struct ath10k *ar)
 
 	ar->hw->vif_data_size = sizeof(struct ath10k_vif);
 	ar->hw->sta_data_size = sizeof(struct ath10k_sta);
+	ar->hw->chanctx_data_size = sizeof(struct ath10k_chanctx);
 
 	ar->hw->max_listen_interval = ATH10K_MAX_HW_LISTEN_INTERVAL;
 
diff --git a/drivers/net/wireless/ath/ath10k/mac.h b/drivers/net/wireless/ath/ath10k/mac.h
index 3b64d99..0f2061a 100644
--- a/drivers/net/wireless/ath/ath10k/mac.h
+++ b/drivers/net/wireless/ath/ath10k/mac.h
@@ -53,6 +53,17 @@ static inline struct ath10k_vif *ath10k_vif_to_arvif(struct ieee80211_vif *vif)
 	return (struct ath10k_vif *)vif->drv_priv;
 }
 
+static inline struct ath10k_chanctx *
+ath10k_mac_vif_ctx(struct ath10k_vif *arvif)
+{
+	struct ieee80211_chanctx_conf *conf = arvif->vif->chanctx_conf;
+
+	if (!conf)
+		return NULL;
+
+	return (struct ath10k_chanctx *)conf->drv_priv;
+}
+
 static inline void ath10k_tx_h_seq_no(struct ieee80211_vif *vif,
 				      struct sk_buff *skb)
 {
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 7b3e6ca..eb66fc4 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -2475,6 +2475,7 @@ static void ath10k_dfs_radar_report(struct ath10k *ar,
 				    u64 tsf)
 {
 	u32 reg0, reg1, tsf32l;
+	struct ieee80211_channel *ch;
 	struct pulse_event pe;
 	u64 tsf64;
 	u8 rssi, width;
@@ -2503,6 +2504,15 @@ static void ath10k_dfs_radar_report(struct ath10k *ar,
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
@@ -2518,7 +2528,7 @@ static void ath10k_dfs_radar_report(struct ath10k *ar,
 		rssi = 0;
 
 	pe.ts = tsf64;
-	pe.freq = ar->hw->conf.chandef.chan->center_freq;
+	pe.freq = ch->center_freq;
 	pe.width = width;
 	pe.rssi = rssi;
 	pe.chirp = (MS(reg0, RADAR_REPORT_REG0_PULSE_IS_CHIRP) != 0);
@@ -2534,6 +2544,7 @@ static void ath10k_dfs_radar_report(struct ath10k *ar,
 		return;
 	}
 
+radar_detected:
 	ath10k_dbg(ar, ATH10K_DBG_REGULATORY, "dfs radar detected\n");
 	ATH10K_DFS_STAT_INC(ar, radar_detected);
 
-- 
2.1.4

