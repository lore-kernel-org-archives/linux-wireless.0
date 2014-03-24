Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:52419 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752974AbaCXPA7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Mar 2014 11:00:59 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] ath10k: unify warning messages in mac.c
Date: Mon, 24 Mar 2014 17:00:51 +0200
Message-Id: <1395673251-24285-1-git-send-email-kvalo@qca.qualcomm.com> (sfid-20140324_160106_142330_30319408)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently there are different styles used for warning messages, unify them to
look similar. The style basically is:

1) start with a verb (if possible)

2) lower case letters

3) use plain english as much as possible

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---

v2:

o use style suggested by Michal

 drivers/net/wireless/ath/ath10k/mac.c |  259 +++++++++++++++++----------------
 1 file changed, 130 insertions(+), 129 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 5d3751d75419..b7b1740a45ee 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -165,7 +165,7 @@ static int ath10k_clear_peer_keys(struct ath10k_vif *arvif,
 			first_errno = ret;
 
 		if (ret)
-			ath10k_warn("could not remove peer wep key %d (%d)\n",
+			ath10k_warn("failed to remove peer wep key %d: %d\n",
 				    i, ret);
 
 		peer->keys[i] = NULL;
@@ -213,7 +213,8 @@ static int ath10k_clear_vdev_key(struct ath10k_vif *arvif,
 			first_errno = ret;
 
 		if (ret)
-			ath10k_warn("could not remove key for %pM\n", addr);
+			ath10k_warn("failed to remove key for %pM: %d\n",
+				    addr, ret);
 	}
 
 	return first_errno;
@@ -323,14 +324,14 @@ static int ath10k_peer_create(struct ath10k *ar, u32 vdev_id, const u8 *addr)
 
 	ret = ath10k_wmi_peer_create(ar, vdev_id, addr);
 	if (ret) {
-		ath10k_warn("Failed to create wmi peer %pM on vdev %i: %i\n",
+		ath10k_warn("failed to create wmi peer %pM on vdev %i: %i\n",
 			    addr, vdev_id, ret);
 		return ret;
 	}
 
 	ret = ath10k_wait_for_peer_created(ar, vdev_id, addr);
 	if (ret) {
-		ath10k_warn("Failed to wait for created wmi peer %pM on vdev %i: %i\n",
+		ath10k_warn("failed to wait for created wmi peer %pM on vdev %i: %i\n",
 			    addr, vdev_id, ret);
 		return ret;
 	}
@@ -351,7 +352,7 @@ static int ath10k_mac_set_kickout(struct ath10k_vif *arvif)
 	ret = ath10k_wmi_pdev_set_param(ar, param,
 					ATH10K_KICKOUT_THRESHOLD);
 	if (ret) {
-		ath10k_warn("Failed to set kickout threshold on vdev %i: %d\n",
+		ath10k_warn("failed to set kickout threshold on vdev %i: %d\n",
 			    arvif->vdev_id, ret);
 		return ret;
 	}
@@ -360,7 +361,7 @@ static int ath10k_mac_set_kickout(struct ath10k_vif *arvif)
 	ret = ath10k_wmi_vdev_set_param(ar, arvif->vdev_id, param,
 					ATH10K_KEEPALIVE_MIN_IDLE);
 	if (ret) {
-		ath10k_warn("Failed to set keepalive minimum idle time on vdev %i : %d\n",
+		ath10k_warn("failed to set keepalive minimum idle time on vdev %i: %d\n",
 			    arvif->vdev_id, ret);
 		return ret;
 	}
@@ -369,7 +370,7 @@ static int ath10k_mac_set_kickout(struct ath10k_vif *arvif)
 	ret = ath10k_wmi_vdev_set_param(ar, arvif->vdev_id, param,
 					ATH10K_KEEPALIVE_MAX_IDLE);
 	if (ret) {
-		ath10k_warn("Failed to set keepalive maximum idle time on vdev %i: %d\n",
+		ath10k_warn("failed to set keepalive maximum idle time on vdev %i: %d\n",
 			    arvif->vdev_id, ret);
 		return ret;
 	}
@@ -378,7 +379,7 @@ static int ath10k_mac_set_kickout(struct ath10k_vif *arvif)
 	ret = ath10k_wmi_vdev_set_param(ar, arvif->vdev_id, param,
 					ATH10K_KEEPALIVE_MAX_UNRESPONSIVE);
 	if (ret) {
-		ath10k_warn("Failed to set keepalive maximum unresponsive time on vdev %i: %d\n",
+		ath10k_warn("failed to set keepalive maximum unresponsive time on vdev %i: %d\n",
 			    arvif->vdev_id, ret);
 		return ret;
 	}
@@ -532,14 +533,14 @@ static int ath10k_vdev_start(struct ath10k_vif *arvif)
 
 	ret = ath10k_wmi_vdev_start(ar, &arg);
 	if (ret) {
-		ath10k_warn("WMI vdev %i start failed: ret %d\n",
+		ath10k_warn("failed to start WMI vdev %i: %d\n",
 			    arg.vdev_id, ret);
 		return ret;
 	}
 
 	ret = ath10k_vdev_setup_sync(ar);
 	if (ret) {
-		ath10k_warn("vdev %i setup failed %d\n",
+		ath10k_warn("failed to synchronise setup for vdev %i: %d\n",
 			    arg.vdev_id, ret);
 		return ret;
 	}
@@ -558,14 +559,14 @@ static int ath10k_vdev_stop(struct ath10k_vif *arvif)
 
 	ret = ath10k_wmi_vdev_stop(ar, arvif->vdev_id);
 	if (ret) {
-		ath10k_warn("WMI vdev %i stop failed: ret %d\n",
+		ath10k_warn("failed to stop WMI vdev %i: %d\n",
 			    arvif->vdev_id, ret);
 		return ret;
 	}
 
 	ret = ath10k_vdev_setup_sync(ar);
 	if (ret) {
-		ath10k_warn("vdev %i setup sync failed %d\n",
+		ath10k_warn("failed to syncronise setup for vdev %i: %d\n",
 			    arvif->vdev_id, ret);
 		return ret;
 	}
@@ -583,7 +584,7 @@ static int ath10k_monitor_start(struct ath10k *ar, int vdev_id)
 	lockdep_assert_held(&ar->conf_mutex);
 
 	if (!ar->monitor_present) {
-		ath10k_warn("mac montor stop -- monitor is not present\n");
+		ath10k_warn("mac monitor stop -- monitor is not present\n");
 		return -EINVAL;
 	}
 
@@ -604,21 +605,21 @@ static int ath10k_monitor_start(struct ath10k *ar, int vdev_id)
 
 	ret = ath10k_wmi_vdev_start(ar, &arg);
 	if (ret) {
-		ath10k_warn("Monitor vdev %i start failed: ret %d\n",
+		ath10k_warn("failed to start Monitor vdev %i: %d\n",
 			    vdev_id, ret);
 		return ret;
 	}
 
 	ret = ath10k_vdev_setup_sync(ar);
 	if (ret) {
-		ath10k_warn("Monitor vdev %i setup failed %d\n",
+		ath10k_warn("failed to syncronise setup for monitor vdev %i: %d\n",
 			    vdev_id, ret);
 		return ret;
 	}
 
 	ret = ath10k_wmi_vdev_up(ar, vdev_id, 0, ar->mac_addr);
 	if (ret) {
-		ath10k_warn("Monitor vdev %i up failed: %d\n",
+		ath10k_warn("failed to put up monitor vdev %i: %d\n",
 			    vdev_id, ret);
 		goto vdev_stop;
 	}
@@ -631,7 +632,7 @@ static int ath10k_monitor_start(struct ath10k *ar, int vdev_id)
 vdev_stop:
 	ret = ath10k_wmi_vdev_stop(ar, ar->monitor_vdev_id);
 	if (ret)
-		ath10k_warn("Monitor vdev %i stop failed: %d\n",
+		ath10k_warn("failed to stop monitor vdev %i after start failure: %d\n",
 			    ar->monitor_vdev_id, ret);
 
 	return ret;
@@ -644,28 +645,28 @@ static int ath10k_monitor_stop(struct ath10k *ar)
 	lockdep_assert_held(&ar->conf_mutex);
 
 	if (!ar->monitor_present) {
-		ath10k_warn("mac montor stop -- monitor is not present\n");
+		ath10k_warn("mac monitor stop -- monitor is not present\n");
 		return -EINVAL;
 	}
 
 	if (!ar->monitor_enabled) {
-		ath10k_warn("mac montor stop -- monitor is not enabled\n");
+		ath10k_warn("mac monitor stop -- monitor is not enabled\n");
 		return -EINVAL;
 	}
 
 	ret = ath10k_wmi_vdev_down(ar, ar->monitor_vdev_id);
 	if (ret)
-		ath10k_warn("Monitor vdev %i down failed: %d\n",
+		ath10k_warn("failed to put down monitor vdev %i: %d\n",
 			    ar->monitor_vdev_id, ret);
 
 	ret = ath10k_wmi_vdev_stop(ar, ar->monitor_vdev_id);
 	if (ret)
-		ath10k_warn("Monitor vdev %i stop failed: %d\n",
+		ath10k_warn("failed to stop monitor vdev %i: %d\n",
 			    ar->monitor_vdev_id, ret);
 
 	ret = ath10k_vdev_setup_sync(ar);
 	if (ret)
-		ath10k_warn("Monitor_down sync failed, vdev %i: %d\n",
+		ath10k_warn("failed to synchronise monitor vdev %i: %d\n",
 			    ar->monitor_vdev_id, ret);
 
 	ar->monitor_enabled = false;
@@ -679,13 +680,13 @@ static int ath10k_monitor_create(struct ath10k *ar)
 	lockdep_assert_held(&ar->conf_mutex);
 
 	if (ar->monitor_present) {
-		ath10k_warn("Monitor mode already enabled\n");
+		ath10k_warn("monitor mode already enabled\n");
 		return 0;
 	}
 
 	bit = ffs(ar->free_vdev_map);
 	if (bit == 0) {
-		ath10k_warn("No free VDEV slots\n");
+		ath10k_warn("no free vdev slots\n");
 		return -ENOMEM;
 	}
 
@@ -696,7 +697,7 @@ static int ath10k_monitor_create(struct ath10k *ar)
 				     WMI_VDEV_TYPE_MONITOR,
 				     0, ar->mac_addr);
 	if (ret) {
-		ath10k_warn("WMI vdev %i monitor create failed: ret %d\n",
+		ath10k_warn("failed to create WMI monitor vdev %i: %d\n",
 			    ar->monitor_vdev_id, ret);
 		goto vdev_fail;
 	}
@@ -726,7 +727,7 @@ static int ath10k_monitor_destroy(struct ath10k *ar)
 
 	ret = ath10k_wmi_vdev_delete(ar, ar->monitor_vdev_id);
 	if (ret) {
-		ath10k_warn("WMI vdev %i monitor delete failed: %d\n",
+		ath10k_warn("failed to delete WMI vdev %i: %d\n",
 			    ar->monitor_vdev_id, ret);
 		return ret;
 	}
@@ -855,7 +856,7 @@ static void ath10k_config_radar_detection(struct ath10k *ar)
 		 * radiation is not allowed, make this channel DFS_UNAVAILABLE
 		 * by indicating that radar was detected.
 		 */
-		ath10k_warn("failed to start CAC (%d)\n", ret);
+		ath10k_warn("failed to start CAC: %d\n", ret);
 		ieee80211_radar_detected(ar->hw);
 	}
 }
@@ -900,7 +901,7 @@ static void ath10k_control_beaconing(struct ath10k_vif *arvif,
 	ret = ath10k_wmi_vdev_up(arvif->ar, arvif->vdev_id, arvif->aid,
 				 arvif->bssid);
 	if (ret) {
-		ath10k_warn("Failed to bring up vdev %d: %i\n",
+		ath10k_warn("failed to bring up vdev %d: %i\n",
 			    arvif->vdev_id, ret);
 		ath10k_vdev_stop(arvif);
 		return;
@@ -924,7 +925,7 @@ static void ath10k_control_ibss(struct ath10k_vif *arvif,
 	if (!info->ibss_joined) {
 		ret = ath10k_peer_delete(arvif->ar, arvif->vdev_id, self_peer);
 		if (ret)
-			ath10k_warn("Failed to delete IBSS self peer:%pM for VDEV:%d ret:%d\n",
+			ath10k_warn("failed to delete IBSS self peer %pM for vdev %d: %d\n",
 				    self_peer, arvif->vdev_id, ret);
 
 		if (is_zero_ether_addr(arvif->bssid))
@@ -933,7 +934,7 @@ static void ath10k_control_ibss(struct ath10k_vif *arvif,
 		ret = ath10k_peer_delete(arvif->ar, arvif->vdev_id,
 					 arvif->bssid);
 		if (ret) {
-			ath10k_warn("Failed to delete IBSS BSSID peer:%pM for VDEV:%d ret:%d\n",
+			ath10k_warn("failed to delete IBSS BSSID peer %pM for vdev %d: %d\n",
 				    arvif->bssid, arvif->vdev_id, ret);
 			return;
 		}
@@ -945,7 +946,7 @@ static void ath10k_control_ibss(struct ath10k_vif *arvif,
 
 	ret = ath10k_peer_create(arvif->ar, arvif->vdev_id, self_peer);
 	if (ret) {
-		ath10k_warn("Failed to create IBSS self peer:%pM for VDEV:%d ret:%d\n",
+		ath10k_warn("failed to create IBSS self peer %pM for vdev %d: %d\n",
 			    self_peer, arvif->vdev_id, ret);
 		return;
 	}
@@ -954,7 +955,7 @@ static void ath10k_control_ibss(struct ath10k_vif *arvif,
 	ret = ath10k_wmi_vdev_set_param(arvif->ar, arvif->vdev_id, vdev_param,
 					ATH10K_DEFAULT_ATIM);
 	if (ret)
-		ath10k_warn("Failed to set IBSS ATIM for VDEV:%d ret:%d\n",
+		ath10k_warn("failed to set IBSS ATIM for vdev %d: %d\n",
 			    arvif->vdev_id, ret);
 }
 
@@ -981,7 +982,7 @@ static int ath10k_mac_vif_setup_ps(struct ath10k_vif *arvif)
 		ret = ath10k_wmi_set_sta_ps_param(ar, arvif->vdev_id, param,
 						  conf->dynamic_ps_timeout);
 		if (ret) {
-			ath10k_warn("Failed to set inactivity time for vdev %d: %i\n",
+			ath10k_warn("failed to set inactivity time for vdev %d: %i\n",
 				    arvif->vdev_id, ret);
 			return ret;
 		}
@@ -994,8 +995,8 @@ static int ath10k_mac_vif_setup_ps(struct ath10k_vif *arvif)
 
 	ret = ath10k_wmi_set_psmode(ar, arvif->vdev_id, psmode);
 	if (ret) {
-		ath10k_warn("Failed to set PS Mode: %d for VDEV: %d\n",
-			    psmode, arvif->vdev_id);
+		ath10k_warn("failed to set PS Mode %d for vdev %d: %d\n",
+			    psmode, arvif->vdev_id, ret);
 		return ret;
 	}
 
@@ -1449,7 +1450,7 @@ static void ath10k_bss_assoc(struct ieee80211_hw *hw,
 
 	ap_sta = ieee80211_find_sta(vif, bss_conf->bssid);
 	if (!ap_sta) {
-		ath10k_warn("Failed to find station entry for %pM, vdev %i\n",
+		ath10k_warn("failed to find station entry for bss %pM vdev %i\n",
 			    bss_conf->bssid, arvif->vdev_id);
 		rcu_read_unlock();
 		return;
@@ -1462,7 +1463,7 @@ static void ath10k_bss_assoc(struct ieee80211_hw *hw,
 	ret = ath10k_peer_assoc_prepare(ar, arvif, ap_sta,
 					bss_conf, &peer_arg);
 	if (ret) {
-		ath10k_warn("Peer assoc prepare failed for %pM vdev %i\n: %d",
+		ath10k_warn("failed to prepare peer assoc for %pM vdev %i: %d\n",
 			    bss_conf->bssid, arvif->vdev_id, ret);
 		rcu_read_unlock();
 		return;
@@ -1472,7 +1473,7 @@ static void ath10k_bss_assoc(struct ieee80211_hw *hw,
 
 	ret = ath10k_wmi_peer_assoc(ar, &peer_arg);
 	if (ret) {
-		ath10k_warn("Peer assoc failed for %pM vdev %i\n: %d",
+		ath10k_warn("failed to run peer assoc for %pM vdev %i: %d\n",
 			    bss_conf->bssid, arvif->vdev_id, ret);
 		return;
 	}
@@ -1493,7 +1494,7 @@ static void ath10k_bss_assoc(struct ieee80211_hw *hw,
 
 	ret = ath10k_wmi_vdev_up(ar, arvif->vdev_id, arvif->aid, arvif->bssid);
 	if (ret) {
-		ath10k_warn("VDEV: %d up failed: ret %d\n",
+		ath10k_warn("failed to set vdev %d up: %d\n",
 			    arvif->vdev_id, ret);
 		return;
 	}
@@ -1553,7 +1554,7 @@ static int ath10k_station_assoc(struct ath10k *ar, struct ath10k_vif *arvif,
 
 	ret = ath10k_peer_assoc_prepare(ar, arvif, sta, NULL, &peer_arg);
 	if (ret) {
-		ath10k_warn("WMI peer assoc prepare failed for %pM vdev %i: %i\n",
+		ath10k_warn("failed to prepare WMI peer assoc for %pM vdev %i: %i\n",
 			    sta->addr, arvif->vdev_id, ret);
 		return ret;
 	}
@@ -1561,14 +1562,15 @@ static int ath10k_station_assoc(struct ath10k *ar, struct ath10k_vif *arvif,
 	peer_arg.peer_reassoc = reassoc;
 	ret = ath10k_wmi_peer_assoc(ar, &peer_arg);
 	if (ret) {
-		ath10k_warn("Peer assoc failed for STA %pM vdev %i: %d\n",
+		ath10k_warn("failed to run peer assoc for STA %pM vdev %i: %d\n",
 			    sta->addr, arvif->vdev_id, ret);
 		return ret;
 	}
 
 	ret = ath10k_setup_peer_smps(ar, arvif, sta->addr, &sta->ht_cap);
 	if (ret) {
-		ath10k_warn("failed to setup peer SMPS for vdev: %d\n", ret);
+		ath10k_warn("failed to setup peer SMPS for vdev %d: %d\n",
+			    arvif->vdev_id, ret);
 		return ret;
 	}
 
@@ -1584,14 +1586,14 @@ static int ath10k_station_assoc(struct ath10k *ar, struct ath10k_vif *arvif,
 
 	ret = ath10k_install_peer_wep_keys(arvif, sta->addr);
 	if (ret) {
-		ath10k_warn("could not install peer wep keys for vdev %i: %d\n",
+		ath10k_warn("failed to install peer wep keys for vdev %i: %d\n",
 			    arvif->vdev_id, ret);
 		return ret;
 	}
 
 	ret = ath10k_peer_assoc_qos_ap(ar, arvif, sta);
 	if (ret) {
-		ath10k_warn("could not set qos params for STA %pM for vdev %i: %d\n",
+		ath10k_warn("failed to set qos params for STA %pM for vdev %i: %d\n",
 			    sta->addr, arvif->vdev_id, ret);
 		return ret;
 	}
@@ -1618,7 +1620,7 @@ static int ath10k_station_disassoc(struct ath10k *ar, struct ath10k_vif *arvif,
 
 	ret = ath10k_clear_peer_keys(arvif, sta->addr);
 	if (ret) {
-		ath10k_warn("could not clear all peer wep keys for vdev %i: %d\n",
+		ath10k_warn("failed to clear all peer wep keys for vdev %i: %d\n",
 			    arvif->vdev_id, ret);
 		return ret;
 	}
@@ -1753,7 +1755,7 @@ static void ath10k_regd_update(struct ath10k *ar)
 
 	ret = ath10k_update_channel_list(ar);
 	if (ret)
-		ath10k_warn("could not update channel list (%d)\n", ret);
+		ath10k_warn("failed to update channel list: %d\n", ret);
 
 	regpair = ar->ath_common.regulatory.regpair;
 
@@ -1774,7 +1776,7 @@ static void ath10k_regd_update(struct ath10k *ar)
 					    regpair->reg_5ghz_ctl,
 					    wmi_dfs_reg);
 	if (ret)
-		ath10k_warn("could not set pdev regdomain (%d)\n", ret);
+		ath10k_warn("failed to set pdev regdomain: %d\n", ret);
 }
 
 static void ath10k_reg_notifier(struct wiphy *wiphy,
@@ -1792,7 +1794,7 @@ static void ath10k_reg_notifier(struct wiphy *wiphy,
 		result = ar->dfs_detector->set_dfs_domain(ar->dfs_detector,
 							  request->dfs_region);
 		if (!result)
-			ath10k_warn("dfs region 0x%X not supported, will trigger radar for every pulse\n",
+			ath10k_warn("DFS region 0x%X not supported, will trigger radar for every pulse\n",
 				    request->dfs_region);
 	}
 
@@ -1829,7 +1831,7 @@ static u8 ath10k_tx_h_get_vdev_id(struct ath10k *ar,
 	if (ar->monitor_enabled)
 		return ar->monitor_vdev_id;
 
-	ath10k_warn("could not resolve vdev id\n");
+	ath10k_warn("failed to resolve vdev id\n");
 	return 0;
 }
 
@@ -1870,7 +1872,9 @@ static void ath10k_tx_wep_key_work(struct work_struct *work)
 					arvif->ar->wmi.vdev_param->def_keyid,
 					keyidx);
 	if (ret) {
-		ath10k_warn("could not update wep keyidx (%d)\n", ret);
+		ath10k_warn("failed to update wep key index for vdev %d: %d\n",
+			    arvif->vdev_id,
+			    ret);
 		return;
 	}
 
@@ -1946,7 +1950,7 @@ static void ath10k_tx_htt(struct ath10k *ar, struct sk_buff *skb)
 			     ar->fw_features)) {
 			if (skb_queue_len(&ar->wmi_mgmt_tx_queue) >=
 			    ATH10K_MAX_NUM_MGMT_PENDING) {
-				ath10k_warn("wmi mgmt_tx queue limit reached\n");
+				ath10k_warn("reached WMI management tranmist queue limit\n");
 				ret = -EBUSY;
 				goto exit;
 			}
@@ -1970,7 +1974,7 @@ static void ath10k_tx_htt(struct ath10k *ar, struct sk_buff *skb)
 
 exit:
 	if (ret) {
-		ath10k_warn("tx failed (%d). dropping packet.\n", ret);
+		ath10k_warn("failed to transmit packet, dropping: %d\n", ret);
 		ieee80211_free_txskb(ar->hw, skb);
 	}
 }
@@ -2031,7 +2035,7 @@ void ath10k_offchan_tx_work(struct work_struct *work)
 		if (!peer) {
 			ret = ath10k_peer_create(ar, vdev_id, peer_addr);
 			if (ret)
-				ath10k_warn("peer %pM on vdev %d not created (%d)\n",
+				ath10k_warn("failed to create peer %pM on vdev %d: %d\n",
 					    peer_addr, vdev_id, ret);
 		}
 
@@ -2051,7 +2055,7 @@ void ath10k_offchan_tx_work(struct work_struct *work)
 		if (!peer) {
 			ret = ath10k_peer_delete(ar, vdev_id, peer_addr);
 			if (ret)
-				ath10k_warn("peer %pM on vdev %d not deleted (%d)\n",
+				ath10k_warn("failed to delete peer %pM on vdev %d: %d\n",
 					    peer_addr, vdev_id, ret);
 		}
 
@@ -2085,7 +2089,7 @@ void ath10k_mgmt_over_wmi_tx_work(struct work_struct *work)
 
 		ret = ath10k_wmi_mgmt_tx(ar, skb);
 		if (ret) {
-			ath10k_warn("wmi mgmt_tx failed (%d)\n", ret);
+			ath10k_warn("failed to transmit management frame via WMI: %d\n", ret);
 			ieee80211_free_txskb(ar->hw, skb);
 		}
 	}
@@ -2110,7 +2114,7 @@ void ath10k_reset_scan(unsigned long ptr)
 		return;
 	}
 
-	ath10k_warn("scan timeout. resetting. fw issue?\n");
+	ath10k_warn("scan timed out, firmware problem?\n");
 
 	if (ar->scan.is_roc)
 		ieee80211_remain_on_channel_expired(ar->hw);
@@ -2146,7 +2150,7 @@ static int ath10k_abort_scan(struct ath10k *ar)
 
 	ret = ath10k_wmi_stop_scan(ar, &arg);
 	if (ret) {
-		ath10k_warn("could not submit wmi stop scan (%d)\n", ret);
+		ath10k_warn("failed to stop wmi scan: %d\n", ret);
 		spin_lock_bh(&ar->data_lock);
 		ar->scan.in_progress = false;
 		ath10k_offchan_tx_purge(ar);
@@ -2166,7 +2170,7 @@ static int ath10k_abort_scan(struct ath10k *ar)
 
 	spin_lock_bh(&ar->data_lock);
 	if (ar->scan.in_progress) {
-		ath10k_warn("could not stop scan. its still in progress\n");
+		ath10k_warn("failed to stop scan, it's still in progress\n");
 		ar->scan.in_progress = false;
 		ath10k_offchan_tx_purge(ar);
 		ret = -ETIMEDOUT;
@@ -2293,14 +2297,14 @@ static int ath10k_start(struct ieee80211_hw *hw)
 
 	ret = ath10k_hif_power_up(ar);
 	if (ret) {
-		ath10k_err("could not init hif (%d)\n", ret);
+		ath10k_err("Could not init hif: %d\n", ret);
 		ar->state = ATH10K_STATE_OFF;
 		goto exit;
 	}
 
 	ret = ath10k_core_start(ar);
 	if (ret) {
-		ath10k_err("could not init core (%d)\n", ret);
+		ath10k_err("Could not init core: %d\n", ret);
 		ath10k_hif_power_down(ar);
 		ar->state = ATH10K_STATE_OFF;
 		goto exit;
@@ -2313,13 +2317,11 @@ static int ath10k_start(struct ieee80211_hw *hw)
 
 	ret = ath10k_wmi_pdev_set_param(ar, ar->wmi.pdev_param->pmf_qos, 1);
 	if (ret)
-		ath10k_warn("could not enable WMI_PDEV_PARAM_PMF_QOS (%d)\n",
-			    ret);
+		ath10k_warn("failed to enable PMF QOS: %d\n", ret);
 
 	ret = ath10k_wmi_pdev_set_param(ar, ar->wmi.pdev_param->dynamic_bw, 1);
 	if (ret)
-		ath10k_warn("could not init WMI_PDEV_PARAM_DYNAMIC_BW (%d)\n",
-			    ret);
+		ath10k_warn("failed to enable dynamic BW: %d\n", ret);
 
 	/*
 	 * By default FW set ARP frames ac to voice (6). In that case ARP
@@ -2333,7 +2335,7 @@ static int ath10k_start(struct ieee80211_hw *hw)
 	ret = ath10k_wmi_pdev_set_param(ar,
 					ar->wmi.pdev_param->arp_ac_override, 0);
 	if (ret) {
-		ath10k_warn("could not set arp ac override parameter: %d\n",
+		ath10k_warn("failed to set arp ac override parameter: %d\n",
 			    ret);
 		goto exit;
 	}
@@ -2376,7 +2378,7 @@ static int ath10k_config_ps(struct ath10k *ar)
 	list_for_each_entry(arvif, &ar->arvifs, list) {
 		ret = ath10k_mac_vif_setup_ps(arvif);
 		if (ret) {
-			ath10k_warn("could not setup powersave (%d)\n", ret);
+			ath10k_warn("failed to setup powersave: %d\n", ret);
 			break;
 		}
 	}
@@ -2438,7 +2440,7 @@ static void ath10k_config_chan(struct ath10k *ar)
 
 		ret = ath10k_vdev_stop(arvif);
 		if (ret) {
-			ath10k_warn("could not stop vdev %d (%d)\n",
+			ath10k_warn("failed to stop vdev %d: %d\n",
 				    arvif->vdev_id, ret);
 			continue;
 		}
@@ -2455,7 +2457,7 @@ static void ath10k_config_chan(struct ath10k *ar)
 
 		ret = ath10k_vdev_start(arvif);
 		if (ret) {
-			ath10k_warn("could not start vdev %d (%d)\n",
+			ath10k_warn("failed to start vdev %d: %d\n",
 				    arvif->vdev_id, ret);
 			continue;
 		}
@@ -2466,7 +2468,7 @@ static void ath10k_config_chan(struct ath10k *ar)
 		ret = ath10k_wmi_vdev_up(arvif->ar, arvif->vdev_id, arvif->aid,
 					 arvif->bssid);
 		if (ret) {
-			ath10k_warn("could not bring vdev up %d (%d)\n",
+			ath10k_warn("failed to bring vdev up %d: %d\n",
 				    arvif->vdev_id, ret);
 			continue;
 		}
@@ -2511,14 +2513,14 @@ static int ath10k_config(struct ieee80211_hw *hw, u32 changed)
 		ret = ath10k_wmi_pdev_set_param(ar, param,
 						hw->conf.power_level * 2);
 		if (ret)
-			ath10k_warn("mac failed to set 2g txpower %d (%d)\n",
+			ath10k_warn("failed to set 2g txpower %d: %d\n",
 				    hw->conf.power_level, ret);
 
 		param = ar->wmi.pdev_param->txpower_limit5g;
 		ret = ath10k_wmi_pdev_set_param(ar, param,
 						hw->conf.power_level * 2);
 		if (ret)
-			ath10k_warn("mac failed to set 5g txpower %d (%d)\n",
+			ath10k_warn("failed to set 5g txpower %d: %d\n",
 				    hw->conf.power_level, ret);
 	}
 
@@ -2565,7 +2567,7 @@ static int ath10k_add_interface(struct ieee80211_hw *hw,
 	INIT_LIST_HEAD(&arvif->list);
 
 	if ((vif->type == NL80211_IFTYPE_MONITOR) && ar->monitor_present) {
-		ath10k_warn("Only one monitor interface allowed\n");
+		ath10k_warn("only one monitor interface allowed\n");
 		ret = -EBUSY;
 		goto err;
 	}
@@ -2612,7 +2614,7 @@ static int ath10k_add_interface(struct ieee80211_hw *hw,
 	ret = ath10k_wmi_vdev_create(ar, arvif->vdev_id, arvif->vdev_type,
 				     arvif->vdev_subtype, vif->addr);
 	if (ret) {
-		ath10k_warn("WMI vdev %i create failed: ret %d\n",
+		ath10k_warn("failed to create WMI vdev %i: %d\n",
 			    arvif->vdev_id, ret);
 		goto err;
 	}
@@ -2624,7 +2626,7 @@ static int ath10k_add_interface(struct ieee80211_hw *hw,
 	ret = ath10k_wmi_vdev_set_param(ar, 0, vdev_param,
 					arvif->def_wep_key_idx);
 	if (ret) {
-		ath10k_warn("Failed to set vdev %i default keyid: %d\n",
+		ath10k_warn("failed to set vdev %i default key id: %d\n",
 			    arvif->vdev_id, ret);
 		goto err_vdev_delete;
 	}
@@ -2634,7 +2636,7 @@ static int ath10k_add_interface(struct ieee80211_hw *hw,
 					ATH10K_HW_TXRX_NATIVE_WIFI);
 	/* 10.X firmware does not support this VDEV parameter. Do not warn */
 	if (ret && ret != -EOPNOTSUPP) {
-		ath10k_warn("Failed to set vdev %i TX encap: %d\n",
+		ath10k_warn("failed to set vdev %i TX encapsulation: %d\n",
 			    arvif->vdev_id, ret);
 		goto err_vdev_delete;
 	}
@@ -2642,14 +2644,14 @@ static int ath10k_add_interface(struct ieee80211_hw *hw,
 	if (arvif->vdev_type == WMI_VDEV_TYPE_AP) {
 		ret = ath10k_peer_create(ar, arvif->vdev_id, vif->addr);
 		if (ret) {
-			ath10k_warn("Failed to create vdev %i peer for AP: %d\n",
+			ath10k_warn("failed to create vdev %i peer for AP: %d\n",
 				    arvif->vdev_id, ret);
 			goto err_vdev_delete;
 		}
 
 		ret = ath10k_mac_set_kickout(arvif);
 		if (ret) {
-			ath10k_warn("Failed to set vdev %i kickout parameters: %d\n",
+			ath10k_warn("failed to set vdev %i kickout parameters: %d\n",
 				    arvif->vdev_id, ret);
 			goto err_peer_delete;
 		}
@@ -2661,7 +2663,7 @@ static int ath10k_add_interface(struct ieee80211_hw *hw,
 		ret = ath10k_wmi_set_sta_ps_param(ar, arvif->vdev_id,
 						  param, value);
 		if (ret) {
-			ath10k_warn("Failed to set vdev %i RX wake policy: %d\n",
+			ath10k_warn("failed to set vdev %i RX wake policy: %d\n",
 				    arvif->vdev_id, ret);
 			goto err_peer_delete;
 		}
@@ -2671,7 +2673,7 @@ static int ath10k_add_interface(struct ieee80211_hw *hw,
 		ret = ath10k_wmi_set_sta_ps_param(ar, arvif->vdev_id,
 						  param, value);
 		if (ret) {
-			ath10k_warn("Failed to set vdev %i TX wake thresh: %d\n",
+			ath10k_warn("failed to set vdev %i TX wake thresh: %d\n",
 				    arvif->vdev_id, ret);
 			goto err_peer_delete;
 		}
@@ -2681,7 +2683,7 @@ static int ath10k_add_interface(struct ieee80211_hw *hw,
 		ret = ath10k_wmi_set_sta_ps_param(ar, arvif->vdev_id,
 						  param, value);
 		if (ret) {
-			ath10k_warn("Failed to set vdev %i PSPOLL count: %d\n",
+			ath10k_warn("failed to set vdev %i PSPOLL count: %d\n",
 				    arvif->vdev_id, ret);
 			goto err_peer_delete;
 		}
@@ -2689,14 +2691,14 @@ static int ath10k_add_interface(struct ieee80211_hw *hw,
 
 	ret = ath10k_mac_set_rts(arvif, ar->hw->wiphy->rts_threshold);
 	if (ret) {
-		ath10k_warn("failed to set rts threshold for vdev %d (%d)\n",
+		ath10k_warn("failed to set rts threshold for vdev %d: %d\n",
 			    arvif->vdev_id, ret);
 		goto err_peer_delete;
 	}
 
 	ret = ath10k_mac_set_frag(arvif, ar->hw->wiphy->frag_threshold);
 	if (ret) {
-		ath10k_warn("failed to set frag threshold for vdev %d (%d)\n",
+		ath10k_warn("failed to set frag threshold for vdev %d: %d\n",
 			    arvif->vdev_id, ret);
 		goto err_peer_delete;
 	}
@@ -2746,7 +2748,7 @@ static void ath10k_remove_interface(struct ieee80211_hw *hw,
 	if (arvif->vdev_type == WMI_VDEV_TYPE_AP) {
 		ret = ath10k_peer_delete(arvif->ar, arvif->vdev_id, vif->addr);
 		if (ret)
-			ath10k_warn("Failed to remove peer for AP vdev %i: %d\n",
+			ath10k_warn("failed to remove peer for AP vdev %i: %d\n",
 				    arvif->vdev_id, ret);
 
 		kfree(arvif->u.ap.noa_data);
@@ -2757,7 +2759,7 @@ static void ath10k_remove_interface(struct ieee80211_hw *hw,
 
 	ret = ath10k_wmi_vdev_delete(ar, arvif->vdev_id);
 	if (ret)
-		ath10k_warn("WMI vdev %i delete failed: %d\n",
+		ath10k_warn("failed to delete WMI vdev %i: %d\n",
 			    arvif->vdev_id, ret);
 
 	if (arvif->vdev_type == WMI_VDEV_TYPE_MONITOR)
@@ -2808,7 +2810,7 @@ static void ath10k_configure_filter(struct ieee80211_hw *hw,
 
 		ret = ath10k_monitor_start(ar, ar->monitor_vdev_id);
 		if (ret)
-			ath10k_warn("Unable to start monitor mode\n");
+			ath10k_warn("failed to start monitor mode: %d\n", ret);
 	} else if (!(ar->filter_flags & FIF_PROMISC_IN_BSS) &&
 		   ar->monitor_enabled && ar->monitor_present) {
 		ath10k_dbg(ATH10K_DBG_MAC, "mac monitor %d stop\n",
@@ -2816,7 +2818,7 @@ static void ath10k_configure_filter(struct ieee80211_hw *hw,
 
 		ret = ath10k_monitor_stop(ar);
 		if (ret)
-			ath10k_warn("Unable to stop monitor mode\n");
+			ath10k_warn("failed to stop monitor mode: %d\n", ret);
 	}
 
 	mutex_unlock(&ar->conf_mutex);
@@ -2847,7 +2849,7 @@ static void ath10k_bss_info_changed(struct ieee80211_hw *hw,
 			   arvif->vdev_id, arvif->beacon_interval);
 
 		if (ret)
-			ath10k_warn("Failed to set beacon interval for vdev %d: %i\n",
+			ath10k_warn("failed to set beacon interval for vdev %d: %i\n",
 				    arvif->vdev_id, ret);
 	}
 
@@ -2860,7 +2862,7 @@ static void ath10k_bss_info_changed(struct ieee80211_hw *hw,
 		ret = ath10k_wmi_pdev_set_param(ar, pdev_param,
 						WMI_BEACON_STAGGERED_MODE);
 		if (ret)
-			ath10k_warn("Failed to set beacon mode for vdev %d: %i\n",
+			ath10k_warn("failed to set beacon mode for vdev %d: %i\n",
 				    arvif->vdev_id, ret);
 	}
 
@@ -2875,7 +2877,7 @@ static void ath10k_bss_info_changed(struct ieee80211_hw *hw,
 		ret = ath10k_wmi_vdev_set_param(ar, arvif->vdev_id, vdev_param,
 						arvif->dtim_period);
 		if (ret)
-			ath10k_warn("Failed to set dtim period for vdev %d: %i\n",
+			ath10k_warn("failed to set dtim period for vdev %d: %i\n",
 				    arvif->vdev_id, ret);
 	}
 
@@ -2896,7 +2898,7 @@ static void ath10k_bss_info_changed(struct ieee80211_hw *hw,
 			ret = ath10k_peer_create(ar, arvif->vdev_id,
 						 info->bssid);
 			if (ret)
-				ath10k_warn("Failed to add peer %pM for vdev %d when changing bssid: %i\n",
+				ath10k_warn("failed to add peer %pM for vdev %d when changing bssid: %i\n",
 					    info->bssid, arvif->vdev_id, ret);
 
 			if (vif->type == NL80211_IFTYPE_STATION) {
@@ -2941,7 +2943,7 @@ static void ath10k_bss_info_changed(struct ieee80211_hw *hw,
 
 		ret = ath10k_recalc_rtscts_prot(arvif);
 		if (ret)
-			ath10k_warn("Failed to recalculate rts/cts prot for vdev %d: %d\n",
+			ath10k_warn("failed to recalculate rts/cts prot for vdev %d: %d\n",
 				    arvif->vdev_id, ret);
 	}
 
@@ -2960,7 +2962,7 @@ static void ath10k_bss_info_changed(struct ieee80211_hw *hw,
 		ret = ath10k_wmi_vdev_set_param(ar, arvif->vdev_id, vdev_param,
 						slottime);
 		if (ret)
-			ath10k_warn("Failed to set erp slot for vdev %d: %i\n",
+			ath10k_warn("failed to set erp slot for vdev %d: %i\n",
 				    arvif->vdev_id, ret);
 	}
 
@@ -2979,7 +2981,7 @@ static void ath10k_bss_info_changed(struct ieee80211_hw *hw,
 		ret = ath10k_wmi_vdev_set_param(ar, arvif->vdev_id, vdev_param,
 						preamble);
 		if (ret)
-			ath10k_warn("Failed to set preamble for vdev %d: %i\n",
+			ath10k_warn("failed to set preamble for vdev %d: %i\n",
 				    arvif->vdev_id, ret);
 	}
 
@@ -3050,7 +3052,7 @@ static int ath10k_hw_scan(struct ieee80211_hw *hw,
 
 	ret = ath10k_start_scan(ar, &arg);
 	if (ret) {
-		ath10k_warn("could not start hw scan (%d)\n", ret);
+		ath10k_warn("failed to start hw scan: %d\n", ret);
 		spin_lock_bh(&ar->data_lock);
 		ar->scan.in_progress = false;
 		spin_unlock_bh(&ar->data_lock);
@@ -3070,8 +3072,7 @@ static void ath10k_cancel_hw_scan(struct ieee80211_hw *hw,
 	mutex_lock(&ar->conf_mutex);
 	ret = ath10k_abort_scan(ar);
 	if (ret) {
-		ath10k_warn("couldn't abort scan (%d). forcefully sending scan completion to mac80211\n",
-			    ret);
+		ath10k_warn("failed to abort scan: %d\n", ret);
 		ieee80211_scan_completed(hw, 1 /* aborted */);
 	}
 	mutex_unlock(&ar->conf_mutex);
@@ -3149,7 +3150,7 @@ static int ath10k_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 
 	if (!peer) {
 		if (cmd == SET_KEY) {
-			ath10k_warn("cannot install key for non-existent peer %pM\n",
+			ath10k_warn("failed to install key for non-existent peer %pM\n",
 				    peer_addr);
 			ret = -EOPNOTSUPP;
 			goto exit;
@@ -3172,7 +3173,7 @@ static int ath10k_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 
 	ret = ath10k_install_key(arvif, key, cmd, peer_addr);
 	if (ret) {
-		ath10k_warn("key installation failed for vdev %i peer %pM: %d\n",
+		ath10k_warn("failed to install key for vdev %i peer %pM: %d\n",
 			    arvif->vdev_id, peer_addr, ret);
 		goto exit;
 	}
@@ -3187,7 +3188,7 @@ static int ath10k_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		peer->keys[key->keyidx] = NULL;
 	else if (peer == NULL)
 		/* impossible unless FW goes crazy */
-		ath10k_warn("peer %pM disappeared!\n", peer_addr);
+		ath10k_warn("Peer %pM disappeared!\n", peer_addr);
 	spin_unlock_bh(&ar->data_lock);
 
 exit:
@@ -3261,7 +3262,7 @@ static void ath10k_sta_rc_update_wk(struct work_struct *wk)
 
 		err = ath10k_station_assoc(ar, arvif, sta, true);
 		if (err)
-			ath10k_warn("Failed to reassociate station: %pM\n",
+			ath10k_warn("failed to reassociate station: %pM\n",
 				    sta->addr);
 	}
 
@@ -3306,7 +3307,7 @@ static int ath10k_sta_state(struct ieee80211_hw *hw,
 			max_num_peers = TARGET_NUM_PEERS;
 
 		if (ar->num_peers >= max_num_peers) {
-			ath10k_warn("Number of peers exceeded: peers number %d (max peers %d)\n",
+			ath10k_warn("number of peers exceeded: peers number %d (max peers %d)\n",
 				    ar->num_peers, max_num_peers);
 			ret = -ENOBUFS;
 			goto exit;
@@ -3318,7 +3319,7 @@ static int ath10k_sta_state(struct ieee80211_hw *hw,
 
 		ret = ath10k_peer_create(ar, arvif->vdev_id, sta->addr);
 		if (ret)
-			ath10k_warn("Failed to add peer %pM for vdev %d when adding a new sta: %i\n",
+			ath10k_warn("failed to add peer %pM for vdev %d when adding a new sta: %i\n",
 				    sta->addr, arvif->vdev_id, ret);
 	} else if ((old_state == IEEE80211_STA_NONE &&
 		    new_state == IEEE80211_STA_NOTEXIST)) {
@@ -3330,7 +3331,7 @@ static int ath10k_sta_state(struct ieee80211_hw *hw,
 			   arvif->vdev_id, sta->addr);
 		ret = ath10k_peer_delete(ar, arvif->vdev_id, sta->addr);
 		if (ret)
-			ath10k_warn("Failed to delete peer %pM for vdev %d: %i\n",
+			ath10k_warn("failed to delete peer %pM for vdev %d: %i\n",
 				    sta->addr, arvif->vdev_id, ret);
 
 		if (vif->type == NL80211_IFTYPE_STATION)
@@ -3347,7 +3348,7 @@ static int ath10k_sta_state(struct ieee80211_hw *hw,
 
 		ret = ath10k_station_assoc(ar, arvif, sta, false);
 		if (ret)
-			ath10k_warn("Failed to associate station %pM for vdev %i: %i\n",
+			ath10k_warn("failed to associate station %pM for vdev %i: %i\n",
 				    sta->addr, arvif->vdev_id, ret);
 	} else if (old_state == IEEE80211_STA_ASSOC &&
 		   new_state == IEEE80211_STA_AUTH &&
@@ -3361,7 +3362,7 @@ static int ath10k_sta_state(struct ieee80211_hw *hw,
 
 		ret = ath10k_station_disassoc(ar, arvif, sta);
 		if (ret)
-			ath10k_warn("Failed to disassociate station: %pM vdev %i ret %i\n",
+			ath10k_warn("failed to disassociate station: %pM vdev %i: %i\n",
 				    sta->addr, arvif->vdev_id, ret);
 	}
 exit:
@@ -3409,7 +3410,7 @@ static int ath10k_conf_tx_uapsd(struct ath10k *ar, struct ieee80211_vif *vif,
 					  WMI_STA_PS_PARAM_UAPSD,
 					  arvif->u.sta.uapsd);
 	if (ret) {
-		ath10k_warn("could not set uapsd params %d\n", ret);
+		ath10k_warn("failed to set uapsd params: %d\n", ret);
 		goto exit;
 	}
 
@@ -3422,7 +3423,7 @@ static int ath10k_conf_tx_uapsd(struct ath10k *ar, struct ieee80211_vif *vif,
 					  WMI_STA_PS_PARAM_RX_WAKE_POLICY,
 					  value);
 	if (ret)
-		ath10k_warn("could not set rx wake param %d\n", ret);
+		ath10k_warn("failed to set rx wake param: %d\n", ret);
 
 exit:
 	return ret;
@@ -3472,13 +3473,13 @@ static int ath10k_conf_tx(struct ieee80211_hw *hw,
 	/* FIXME: FW accepts wmm params per hw, not per vif */
 	ret = ath10k_wmi_pdev_set_wmm_params(ar, &ar->wmm_params);
 	if (ret) {
-		ath10k_warn("could not set wmm params %d\n", ret);
+		ath10k_warn("failed to set wmm params: %d\n", ret);
 		goto exit;
 	}
 
 	ret = ath10k_conf_tx_uapsd(ar, vif, ac, params->uapsd);
 	if (ret)
-		ath10k_warn("could not set sta uapsd %d\n", ret);
+		ath10k_warn("failed to set sta uapsd: %d\n", ret);
 
 exit:
 	mutex_unlock(&ar->conf_mutex);
@@ -3531,7 +3532,7 @@ static int ath10k_remain_on_channel(struct ieee80211_hw *hw,
 
 	ret = ath10k_start_scan(ar, &arg);
 	if (ret) {
-		ath10k_warn("could not start roc scan (%d)\n", ret);
+		ath10k_warn("failed to start roc scan: %d\n", ret);
 		spin_lock_bh(&ar->data_lock);
 		ar->scan.in_progress = false;
 		spin_unlock_bh(&ar->data_lock);
@@ -3540,7 +3541,7 @@ static int ath10k_remain_on_channel(struct ieee80211_hw *hw,
 
 	ret = wait_for_completion_timeout(&ar->scan.on_channel, 3*HZ);
 	if (ret == 0) {
-		ath10k_warn("could not switch to channel for roc scan\n");
+		ath10k_warn("failed to switch to channel for roc scan\n");
 		ath10k_abort_scan(ar);
 		ret = -ETIMEDOUT;
 		goto exit;
@@ -3581,7 +3582,7 @@ static int ath10k_set_rts_threshold(struct ieee80211_hw *hw, u32 value)
 
 		ret = ath10k_mac_set_rts(arvif, value);
 		if (ret) {
-			ath10k_warn("could not set rts threshold for vdev %d (%d)\n",
+			ath10k_warn("failed to set rts threshold for vdev %d: %d\n",
 				    arvif->vdev_id, ret);
 			break;
 		}
@@ -3604,7 +3605,7 @@ static int ath10k_set_frag_threshold(struct ieee80211_hw *hw, u32 value)
 
 		ret = ath10k_mac_set_rts(arvif, value);
 		if (ret) {
-			ath10k_warn("could not set fragmentation threshold for vdev %d (%d)\n",
+			ath10k_warn("failed to set fragmentation threshold for vdev %d: %d\n",
 				    arvif->vdev_id, ret);
 			break;
 		}
@@ -3643,7 +3644,7 @@ static void ath10k_flush(struct ieee80211_hw *hw, u32 queues, bool drop)
 		}), ATH10K_FLUSH_TIMEOUT_HZ);
 
 	if (ret <= 0 || skip)
-		ath10k_warn("tx not flushed (skip %i ar-state %i): %i\n",
+		ath10k_warn("failed to flush transmit queue (skip %i ar-state %i): %i\n",
 			    skip, ar->state, ret);
 
 skip:
@@ -3678,7 +3679,7 @@ static int ath10k_suspend(struct ieee80211_hw *hw,
 
 	ret = ath10k_hif_suspend(ar);
 	if (ret) {
-		ath10k_warn("could not suspend hif (%d)\n", ret);
+		ath10k_warn("failed to suspend hif: %d\n", ret);
 		goto resume;
 	}
 
@@ -3687,7 +3688,7 @@ static int ath10k_suspend(struct ieee80211_hw *hw,
 resume:
 	ret = ath10k_wmi_pdev_resume_target(ar);
 	if (ret)
-		ath10k_warn("could not resume target (%d)\n", ret);
+		ath10k_warn("failed to resume target: %d\n", ret);
 
 	ret = 1;
 exit:
@@ -3704,14 +3705,14 @@ static int ath10k_resume(struct ieee80211_hw *hw)
 
 	ret = ath10k_hif_resume(ar);
 	if (ret) {
-		ath10k_warn("could not resume hif (%d)\n", ret);
+		ath10k_warn("failed to resume hif: %d\n", ret);
 		ret = 1;
 		goto exit;
 	}
 
 	ret = ath10k_wmi_pdev_resume_target(ar);
 	if (ret) {
-		ath10k_warn("could not resume target (%d)\n", ret);
+		ath10k_warn("failed to resume target: %d\n", ret);
 		ret = 1;
 		goto exit;
 	}
@@ -4034,7 +4035,7 @@ static int ath10k_set_fixed_rate_param(struct ath10k_vif *arvif,
 	ret = ath10k_wmi_vdev_set_param(ar, arvif->vdev_id,
 					vdev_param, fixed_rate);
 	if (ret) {
-		ath10k_warn("Could not set fixed_rate param 0x%02x: %d\n",
+		ath10k_warn("failed to set fixed rate param 0x%02x: %d\n",
 			    fixed_rate, ret);
 		ret = -EINVAL;
 		goto exit;
@@ -4047,7 +4048,7 @@ static int ath10k_set_fixed_rate_param(struct ath10k_vif *arvif,
 					vdev_param, fixed_nss);
 
 	if (ret) {
-		ath10k_warn("Could not set fixed_nss param %d: %d\n",
+		ath10k_warn("failed to set fixed nss param %d: %d\n",
 			    fixed_nss, ret);
 		ret = -EINVAL;
 		goto exit;
@@ -4060,7 +4061,7 @@ static int ath10k_set_fixed_rate_param(struct ath10k_vif *arvif,
 					force_sgi);
 
 	if (ret) {
-		ath10k_warn("Could not set sgi param %d: %d\n",
+		ath10k_warn("failed to set sgi param %d: %d\n",
 			    force_sgi, ret);
 		ret = -EINVAL;
 		goto exit;
@@ -4096,7 +4097,7 @@ static int ath10k_set_bitrate_mask(struct ieee80211_hw *hw,
 	}
 
 	if (fixed_rate == WMI_FIXED_RATE_NONE && force_sgi) {
-		ath10k_warn("Could not force SGI usage for default rate settings\n");
+		ath10k_warn("failed to force SGI usage for default rate settings\n");
 		return -EINVAL;
 	}
 
@@ -4142,8 +4143,8 @@ static void ath10k_sta_rc_update(struct ieee80211_hw *hw,
 			bw = WMI_PEER_CHWIDTH_80MHZ;
 			break;
 		case IEEE80211_STA_RX_BW_160:
-			ath10k_warn("mac sta rc update for %pM: invalid bw %d\n",
-				    sta->addr, sta->bandwidth);
+			ath10k_warn("Invalid bandwith %d in rc update for %pM\n",
+				    sta->bandwidth, sta->addr);
 			bw = WMI_PEER_CHWIDTH_20MHZ;
 			break;
 		}
@@ -4169,8 +4170,8 @@ static void ath10k_sta_rc_update(struct ieee80211_hw *hw,
 			smps = WMI_PEER_SMPS_DYNAMIC;
 			break;
 		case IEEE80211_SMPS_NUM_MODES:
-			ath10k_warn("mac sta rc update for %pM: invalid smps: %d\n",
-				    sta->addr, sta->smps_mode);
+			ath10k_warn("Invalid smps %d in sta rc update for %pM\n",
+				    sta->smps_mode, sta->addr);
 			smps = WMI_PEER_SMPS_PS_NONE;
 			break;
 		}
@@ -4631,19 +4632,19 @@ int ath10k_mac_register(struct ath10k *ar)
 							     NL80211_DFS_UNSET);
 
 		if (!ar->dfs_detector)
-			ath10k_warn("dfs pattern detector init failed\n");
+			ath10k_warn("failed to initialise DFS pattern detector\n");
 	}
 
 	ret = ath_regd_init(&ar->ath_common.regulatory, ar->hw->wiphy,
 			    ath10k_reg_notifier);
 	if (ret) {
-		ath10k_err("Regulatory initialization failed: %i\n", ret);
+		ath10k_err("failed to initialise regulatory: %i\n", ret);
 		goto err_free;
 	}
 
 	ret = ieee80211_register_hw(ar->hw);
 	if (ret) {
-		ath10k_err("ieee80211 registration failed: %d\n", ret);
+		ath10k_err("failed to register ieee80211: %d\n", ret);
 		goto err_free;
 	}
 
-- 
1.7.9.5

