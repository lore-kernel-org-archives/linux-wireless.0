Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh04.mail.saunalahti.fi ([62.142.5.110]:41610 "EHLO
	emh04.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757377Ab3GENPX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Jul 2013 09:15:23 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@lists.ath9k.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 14/16] ath10k: improve locking
Date: Fri,  5 Jul 2013 16:15:15 +0300
Message-Id: <1373030117-18077-15-git-send-email-kvalo@qca.qualcomm.com> (sfid-20130705_152039_663933_EB2A1281)
In-Reply-To: <1373030117-18077-1-git-send-email-kvalo@qca.qualcomm.com>
References: <1373030117-18077-1-git-send-email-kvalo@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michal Kazior <michal.kazior@tieto.com>

Add more lockdep asserts and a few conf_mutex
locks. It's better to be on the safe side.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/mac.c |   57 +++++++++++++++++++++++++++++++--
 1 file changed, 55 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 7bc746f..def1e68 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -43,6 +43,8 @@ static int ath10k_send_key(struct ath10k_vif *arvif,
 		.macaddr = macaddr,
 	};
 
+	lockdep_assert_held(&arvif->ar->conf_mutex);
+
 	if (key->flags & IEEE80211_KEY_FLAG_PAIRWISE)
 		arg.key_flags = WMI_KEY_PAIRWISE;
 	else
@@ -88,6 +90,8 @@ static int ath10k_install_key(struct ath10k_vif *arvif,
 	struct ath10k *ar = arvif->ar;
 	int ret;
 
+	lockdep_assert_held(&ar->conf_mutex);
+
 	INIT_COMPLETION(ar->install_key_done);
 
 	ret = ath10k_send_key(arvif, key, cmd, macaddr);
@@ -369,6 +373,8 @@ static inline int ath10k_vdev_setup_sync(struct ath10k *ar)
 {
 	int ret;
 
+	lockdep_assert_held(&ar->conf_mutex);
+
 	ret = wait_for_completion_timeout(&ar->vdev_setup_done,
 					  ATH10K_VDEV_SETUP_TIMEOUT_HZ);
 	if (ret == 0)
@@ -602,6 +608,8 @@ static void ath10k_control_beaconing(struct ath10k_vif *arvif,
 {
 	int ret = 0;
 
+	lockdep_assert_held(&arvif->ar->conf_mutex);
+
 	if (!info->enable_beacon) {
 		ath10k_vdev_stop(arvif);
 		return;
@@ -628,6 +636,8 @@ static void ath10k_control_ibss(struct ath10k_vif *arvif,
 {
 	int ret = 0;
 
+	lockdep_assert_held(&arvif->ar->conf_mutex);
+
 	if (!info->ibss_joined) {
 		ret = ath10k_peer_delete(arvif->ar, arvif->vdev_id, self_peer);
 		if (ret)
@@ -677,6 +687,8 @@ static void ath10k_ps_iter(void *data, u8 *mac, struct ieee80211_vif *vif)
 	enum wmi_sta_ps_mode psmode;
 	int ret;
 
+	lockdep_assert_held(&arvif->ar->conf_mutex);
+
 	if (vif->type != NL80211_IFTYPE_STATION)
 		return;
 
@@ -719,6 +731,8 @@ static void ath10k_peer_assoc_h_basic(struct ath10k *ar,
 				      struct ieee80211_bss_conf *bss_conf,
 				      struct wmi_peer_assoc_complete_arg *arg)
 {
+	lockdep_assert_held(&ar->conf_mutex);
+
 	memcpy(arg->addr, sta->addr, ETH_ALEN);
 	arg->vdev_id = arvif->vdev_id;
 	arg->peer_aid = sta->aid;
@@ -761,6 +775,8 @@ static void ath10k_peer_assoc_h_crypto(struct ath10k *ar,
 	const u8 *rsnie = NULL;
 	const u8 *wpaie = NULL;
 
+	lockdep_assert_held(&ar->conf_mutex);
+
 	bss = cfg80211_get_bss(ar->hw->wiphy, ar->hw->conf.chandef.chan,
 			       info->bssid, NULL, 0, 0, 0);
 	if (bss) {
@@ -801,6 +817,8 @@ static void ath10k_peer_assoc_h_rates(struct ath10k *ar,
 	u32 ratemask;
 	int i;
 
+	lockdep_assert_held(&ar->conf_mutex);
+
 	sband = ar->hw->wiphy->bands[ar->hw->conf.chandef.chan->band];
 	ratemask = sta->supp_rates[ar->hw->conf.chandef.chan->band];
 	rates = sband->bitrates;
@@ -824,6 +842,8 @@ static void ath10k_peer_assoc_h_ht(struct ath10k *ar,
 	int smps;
 	int i, n;
 
+	lockdep_assert_held(&ar->conf_mutex);
+
 	if (!ht_cap->ht_supported)
 		return;
 
@@ -902,6 +922,8 @@ static void ath10k_peer_assoc_h_qos_ap(struct ath10k *ar,
 	u32 uapsd = 0;
 	u32 max_sp = 0;
 
+	lockdep_assert_held(&ar->conf_mutex);
+
 	if (sta->wme)
 		arg->peer_flags |= WMI_PEER_QOS;
 
@@ -1053,6 +1075,8 @@ static int ath10k_peer_assoc(struct ath10k *ar,
 {
 	struct wmi_peer_assoc_complete_arg arg;
 
+	lockdep_assert_held(&ar->conf_mutex);
+
 	memset(&arg, 0, sizeof(struct wmi_peer_assoc_complete_arg));
 
 	ath10k_peer_assoc_h_basic(ar, arvif, sta, bss_conf, &arg);
@@ -1076,6 +1100,8 @@ static void ath10k_bss_assoc(struct ieee80211_hw *hw,
 	struct ieee80211_sta *ap_sta;
 	int ret;
 
+	lockdep_assert_held(&ar->conf_mutex);
+
 	rcu_read_lock();
 
 	ap_sta = ieee80211_find_sta(vif, bss_conf->bssid);
@@ -1116,6 +1142,8 @@ static void ath10k_bss_disassoc(struct ieee80211_hw *hw,
 	struct ath10k_vif *arvif = ath10k_vif_to_arvif(vif);
 	int ret;
 
+	lockdep_assert_held(&ar->conf_mutex);
+
 	/*
 	 * For some reason, calling VDEV-DOWN before VDEV-STOP
 	 * makes the FW to send frames via HTT after disassociation.
@@ -1149,6 +1177,8 @@ static int ath10k_station_assoc(struct ath10k *ar, struct ath10k_vif *arvif,
 {
 	int ret = 0;
 
+	lockdep_assert_held(&ar->conf_mutex);
+
 	ret = ath10k_peer_assoc(ar, arvif, sta, NULL);
 	if (ret) {
 		ath10k_warn("WMI peer assoc failed for %pM\n", sta->addr);
@@ -1169,6 +1199,8 @@ static int ath10k_station_disassoc(struct ath10k *ar, struct ath10k_vif *arvif,
 {
 	int ret = 0;
 
+	lockdep_assert_held(&ar->conf_mutex);
+
 	ret = ath10k_clear_peer_keys(arvif, sta->addr);
 	if (ret) {
 		ath10k_warn("could not clear all peer wep keys (%d)\n", ret);
@@ -1195,6 +1227,8 @@ static int ath10k_update_channel_list(struct ath10k *ar)
 	int ret;
 	int i;
 
+	lockdep_assert_held(&ar->conf_mutex);
+
 	bands = hw->wiphy->bands;
 	for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
 		if (!bands[band])
@@ -1281,6 +1315,8 @@ static void ath10k_reg_notifier(struct wiphy *wiphy,
 	struct ath10k *ar = hw->priv;
 	int ret;
 
+	mutex_lock(&ar->conf_mutex);
+
 	ath_reg_notifier_apply(wiphy, request, &ar->ath_common.regulatory);
 
 	ret = ath10k_update_channel_list(ar);
@@ -1298,6 +1334,8 @@ static void ath10k_reg_notifier(struct wiphy *wiphy,
 					    regpair->reg_5ghz_ctl);
 	if (ret)
 		ath10k_warn("could not set pdev regdomain (%d)\n", ret);
+
+	mutex_unlock(&ar->conf_mutex);
 }
 
 /***************/
@@ -1675,6 +1713,8 @@ static int ath10k_start(struct ieee80211_hw *hw)
 	struct ath10k *ar = hw->priv;
 	int ret;
 
+	mutex_lock(&ar->conf_mutex);
+
 	ret = ath10k_wmi_pdev_set_param(ar, WMI_PDEV_PARAM_PMF_QOS, 1);
 	if (ret)
 		ath10k_warn("could not enable WMI_PDEV_PARAM_PMF_QOS (%d)\n",
@@ -1685,6 +1725,7 @@ static int ath10k_start(struct ieee80211_hw *hw)
 		ath10k_warn("could not init WMI_PDEV_PARAM_DYNAMIC_BW (%d)\n",
 			    ret);
 
+	mutex_unlock(&ar->conf_mutex);
 	return 0;
 }
 
@@ -1692,9 +1733,11 @@ static void ath10k_stop(struct ieee80211_hw *hw)
 {
 	struct ath10k *ar = hw->priv;
 
-	/* avoid leaks in case FW never confirms scan for offchannel */
-	cancel_work_sync(&ar->offchan_tx_work);
+	mutex_lock(&ar->conf_mutex);
 	ath10k_offchan_tx_purge(ar);
+	mutex_unlock(&ar->conf_mutex);
+
+	cancel_work_sync(&ar->offchan_tx_work);
 }
 
 static int ath10k_config(struct ieee80211_hw *hw, u32 changed)
@@ -2378,6 +2421,8 @@ static int ath10k_conf_tx_uapsd(struct ath10k *ar, struct ieee80211_vif *vif,
 	u32 value = 0;
 	int ret = 0;
 
+	lockdep_assert_held(&ar->conf_mutex);
+
 	if (arvif->vdev_type != WMI_VDEV_TYPE_STA)
 		return 0;
 
@@ -2573,6 +2618,8 @@ static void ath10k_set_rts_iter(void *data, u8 *mac, struct ieee80211_vif *vif)
 	struct ath10k_vif *arvif = ath10k_vif_to_arvif(vif);
 	u32 rts = ar_iter->ar->hw->wiphy->rts_threshold;
 
+	lockdep_assert_held(&arvif->ar->conf_mutex);
+
 	rts = min_t(u32, rts, ATH10K_RTS_MAX);
 
 	ar_iter->ret = ath10k_wmi_vdev_set_param(ar_iter->ar, arvif->vdev_id,
@@ -2611,6 +2658,8 @@ static void ath10k_set_frag_iter(void *data, u8 *mac, struct ieee80211_vif *vif)
 	u32 frag = ar_iter->ar->hw->wiphy->frag_threshold;
 	int ret;
 
+	lockdep_assert_held(&arvif->ar->conf_mutex);
+
 	frag = clamp_t(u32, frag,
 		       ATH10K_FRAGMT_THRESHOLD_MIN,
 		       ATH10K_FRAGMT_THRESHOLD_MAX);
@@ -2656,6 +2705,8 @@ static void ath10k_flush(struct ieee80211_hw *hw, u32 queues, bool drop)
 	if (drop)
 		return;
 
+	mutex_lock(&ar->conf_mutex);
+
 	ret = wait_event_timeout(ar->htt.empty_tx_wq, ({
 			bool empty;
 			spin_lock_bh(&ar->htt.tx_lock);
@@ -2666,6 +2717,8 @@ static void ath10k_flush(struct ieee80211_hw *hw, u32 queues, bool drop)
 		}), ATH10K_FLUSH_TIMEOUT_HZ);
 	if (ret <= 0)
 		ath10k_warn("tx not flushed\n");
+
+	mutex_unlock(&ar->conf_mutex);
 }
 
 /* TODO: Implement this function properly
-- 
1.7.9.5

