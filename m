Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:60956 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975AbaBMTKD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Feb 2014 14:10:03 -0500
From: greearb@candelatech.com
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Ben Greear <greearb@candelatech.com>
Subject: [PATCH 1/2] ath10k:  add vdev-id, return code to error codes
Date: Thu, 13 Feb 2014 11:09:21 -0800
Message-Id: <1392318562-32440-1-git-send-email-greearb@candelatech.com> (sfid-20140213_201034_439180_0F751A72)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

When using multiple vdevs (stations, aps, etc), it is
nice to be able to associate log messages with specific
interfaces.  So, add vdev-id to most logging messages.
Add return code as well, where it was missing.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 194 +++++++++++++++++++---------------
 1 file changed, 111 insertions(+), 83 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index c9c6efe..1b74477 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -323,13 +323,15 @@ static int ath10k_peer_create(struct ath10k *ar, u32 vdev_id, const u8 *addr)
 
 	ret = ath10k_wmi_peer_create(ar, vdev_id, addr);
 	if (ret) {
-		ath10k_warn("Failed to create wmi peer: %i\n", ret);
+		ath10k_warn("Failed to create wmi peer %pM on vdev %i: %i\n",
+			    addr, vdev_id, ret);
 		return ret;
 	}
 
 	ret = ath10k_wait_for_peer_created(ar, vdev_id, addr);
 	if (ret) {
-		ath10k_warn("Failed to wait for created wmi peer: %i\n", ret);
+		ath10k_warn("Failed to wait for created wmi peer %pM on vdev %i: %i\n",
+			    addr, vdev_id, ret);
 		return ret;
 	}
 	spin_lock_bh(&ar->data_lock);
@@ -349,7 +351,8 @@ static int ath10k_mac_set_kickout(struct ath10k_vif *arvif)
 	ret = ath10k_wmi_pdev_set_param(ar, param,
 					ATH10K_KICKOUT_THRESHOLD);
 	if (ret) {
-		ath10k_warn("Failed to set kickout threshold: %d\n", ret);
+		ath10k_warn("Failed to set kickout threshold on vdev %i: %d\n",
+			    arvif->vdev_id, ret);
 		return ret;
 	}
 
@@ -357,8 +360,8 @@ static int ath10k_mac_set_kickout(struct ath10k_vif *arvif)
 	ret = ath10k_wmi_vdev_set_param(ar, arvif->vdev_id, param,
 					ATH10K_KEEPALIVE_MIN_IDLE);
 	if (ret) {
-		ath10k_warn("Failed to set keepalive minimum idle time : %d\n",
-			    ret);
+		ath10k_warn("Failed to set keepalive minimum idle time on vdev %i : %d\n",
+			    arvif->vdev_id, ret);
 		return ret;
 	}
 
@@ -366,8 +369,8 @@ static int ath10k_mac_set_kickout(struct ath10k_vif *arvif)
 	ret = ath10k_wmi_vdev_set_param(ar, arvif->vdev_id, param,
 					ATH10K_KEEPALIVE_MAX_IDLE);
 	if (ret) {
-		ath10k_warn("Failed to set keepalive maximum idle time: %d\n",
-			    ret);
+		ath10k_warn("Failed to set keepalive maximum idle time on vdev %i: %d\n",
+			    arvif->vdev_id, ret);
 		return ret;
 	}
 
@@ -375,8 +378,8 @@ static int ath10k_mac_set_kickout(struct ath10k_vif *arvif)
 	ret = ath10k_wmi_vdev_set_param(ar, arvif->vdev_id, param,
 					ATH10K_KEEPALIVE_MAX_UNRESPONSIVE);
 	if (ret) {
-		ath10k_warn("Failed to set keepalive maximum unresponsive time: %d\n",
-			    ret);
+		ath10k_warn("Failed to set keepalive maximum unresponsive time on vdev %i: %d\n",
+			    arvif->vdev_id, ret);
 		return ret;
 	}
 
@@ -529,13 +532,15 @@ static int ath10k_vdev_start(struct ath10k_vif *arvif)
 
 	ret = ath10k_wmi_vdev_start(ar, &arg);
 	if (ret) {
-		ath10k_warn("WMI vdev start failed: ret %d\n", ret);
+		ath10k_warn("WMI vdev %i start failed: ret %d\n",
+			    arg.vdev_id, ret);
 		return ret;
 	}
 
 	ret = ath10k_vdev_setup_sync(ar);
 	if (ret) {
-		ath10k_warn("vdev setup failed %d\n", ret);
+		ath10k_warn("vdev %i setup failed %d\n",
+			    arg.vdev_id, ret);
 		return ret;
 	}
 
@@ -553,13 +558,15 @@ static int ath10k_vdev_stop(struct ath10k_vif *arvif)
 
 	ret = ath10k_wmi_vdev_stop(ar, arvif->vdev_id);
 	if (ret) {
-		ath10k_warn("WMI vdev stop failed: ret %d\n", ret);
+		ath10k_warn("WMI vdev %i stop failed: ret %d\n",
+			    arvif->vdev_id, ret);
 		return ret;
 	}
 
 	ret = ath10k_vdev_setup_sync(ar);
 	if (ret) {
-		ath10k_warn("vdev setup failed %d\n", ret);
+		ath10k_warn("vdev %i setup sync failed %d\n",
+			    arvif->vdev_id, ret);
 		return ret;
 	}
 
@@ -597,19 +604,22 @@ static int ath10k_monitor_start(struct ath10k *ar, int vdev_id)
 
 	ret = ath10k_wmi_vdev_start(ar, &arg);
 	if (ret) {
-		ath10k_warn("Monitor vdev start failed: ret %d\n", ret);
+		ath10k_warn("Monitor vdev %i start failed: ret %d\n",
+			    vdev_id, ret);
 		return ret;
 	}
 
 	ret = ath10k_vdev_setup_sync(ar);
 	if (ret) {
-		ath10k_warn("Monitor vdev setup failed %d\n", ret);
+		ath10k_warn("Monitor vdev %i setup failed %d\n",
+			    vdev_id, ret);
 		return ret;
 	}
 
 	ret = ath10k_wmi_vdev_up(ar, vdev_id, 0, ar->mac_addr);
 	if (ret) {
-		ath10k_warn("Monitor vdev up failed: %d\n", ret);
+		ath10k_warn("Monitor vdev %i up failed: %d\n",
+			    vdev_id, ret);
 		goto vdev_stop;
 	}
 
@@ -621,7 +631,8 @@ static int ath10k_monitor_start(struct ath10k *ar, int vdev_id)
 vdev_stop:
 	ret = ath10k_wmi_vdev_stop(ar, ar->monitor_vdev_id);
 	if (ret)
-		ath10k_warn("Monitor vdev stop failed: %d\n", ret);
+		ath10k_warn("Monitor vdev %i stop failed: %d\n",
+			    ar->monitor_vdev_id, ret);
 
 	return ret;
 }
@@ -644,15 +655,18 @@ static int ath10k_monitor_stop(struct ath10k *ar)
 
 	ret = ath10k_wmi_vdev_down(ar, ar->monitor_vdev_id);
 	if (ret)
-		ath10k_warn("Monitor vdev down failed: %d\n", ret);
+		ath10k_warn("Monitor vdev %i down failed: %d\n",
+			    ar->monitor_vdev_id, ret);
 
 	ret = ath10k_wmi_vdev_stop(ar, ar->monitor_vdev_id);
 	if (ret)
-		ath10k_warn("Monitor vdev stop failed: %d\n", ret);
+		ath10k_warn("Monitor vdev %i stop failed: %d\n",
+			    ar->monitor_vdev_id, ret);
 
 	ret = ath10k_vdev_setup_sync(ar);
 	if (ret)
-		ath10k_warn("Monitor_down sync failed: %d\n", ret);
+		ath10k_warn("Monitor_down sync failed, vdev %i: %d\n",
+			    ar->monitor_vdev_id, ret);
 
 	ar->monitor_enabled = false;
 	return ret;
@@ -682,7 +696,8 @@ static int ath10k_monitor_create(struct ath10k *ar)
 				     WMI_VDEV_TYPE_MONITOR,
 				     0, ar->mac_addr);
 	if (ret) {
-		ath10k_warn("WMI vdev monitor create failed: ret %d\n", ret);
+		ath10k_warn("WMI vdev %i monitor create failed: ret %d\n",
+			    ar->monitor_vdev_id, ret);
 		goto vdev_fail;
 	}
 
@@ -711,7 +726,8 @@ static int ath10k_monitor_destroy(struct ath10k *ar)
 
 	ret = ath10k_wmi_vdev_delete(ar, ar->monitor_vdev_id);
 	if (ret) {
-		ath10k_warn("WMI vdev monitor delete failed: %d\n", ret);
+		ath10k_warn("WMI vdev %i monitor delete failed: %d\n",
+			    ar->monitor_vdev_id, ret);
 		return ret;
 	}
 
@@ -862,8 +878,8 @@ static void ath10k_control_beaconing(struct ath10k_vif *arvif,
 	ret = ath10k_wmi_vdev_up(arvif->ar, arvif->vdev_id, arvif->aid,
 				 arvif->bssid);
 	if (ret) {
-		ath10k_warn("Failed to bring up VDEV: %d\n",
-			    arvif->vdev_id);
+		ath10k_warn("Failed to bring up VDEV: %d ret %i\n",
+			    arvif->vdev_id, ret);
 		ath10k_vdev_stop(arvif);
 		return;
 	}
@@ -943,8 +959,8 @@ static int ath10k_mac_vif_setup_ps(struct ath10k_vif *arvif)
 		ret = ath10k_wmi_set_sta_ps_param(ar, arvif->vdev_id, param,
 						  conf->dynamic_ps_timeout);
 		if (ret) {
-			ath10k_warn("Failed to set inactivity time for VDEV: %d\n",
-				    arvif->vdev_id);
+			ath10k_warn("Failed to set inactivity time for VDEV: %d ret %i\n",
+				    arvif->vdev_id, ret);
 			return ret;
 		}
 	} else {
@@ -1208,8 +1224,8 @@ static int ath10k_peer_assoc_qos_ap(struct ath10k *ar,
 						 WMI_AP_PS_PEER_PARAM_UAPSD,
 						 uapsd);
 		if (ret) {
-			ath10k_warn("failed to set ap ps peer param uapsd: %d\n",
-				    ret);
+			ath10k_warn("failed to set ap ps peer param uapsd, vdev %i: %d\n",
+				    arvif->vdev_id, ret);
 			return ret;
 		}
 
@@ -1218,8 +1234,8 @@ static int ath10k_peer_assoc_qos_ap(struct ath10k *ar,
 						 WMI_AP_PS_PEER_PARAM_MAX_SP,
 						 max_sp);
 		if (ret) {
-			ath10k_warn("failed to set ap ps peer param max sp: %d\n",
-				    ret);
+			ath10k_warn("failed to set ap ps peer param max sp, vdev %i: %d\n",
+				    arvif->vdev_id, ret);
 			return ret;
 		}
 
@@ -1230,8 +1246,8 @@ static int ath10k_peer_assoc_qos_ap(struct ath10k *ar,
 		ret = ath10k_wmi_set_ap_ps_param(ar, arvif->vdev_id, sta->addr,
 					WMI_AP_PS_PEER_PARAM_AGEOUT_TIME, 10);
 		if (ret) {
-			ath10k_warn("failed to set ap ps peer param ageout time: %d\n",
-				    ret);
+			ath10k_warn("failed to set ap ps peer param ageout time, vdev %i: %d\n",
+				    arvif->vdev_id, ret);
 			return ret;
 		}
 	}
@@ -1395,8 +1411,8 @@ static void ath10k_bss_assoc(struct ieee80211_hw *hw,
 
 	ap_sta = ieee80211_find_sta(vif, bss_conf->bssid);
 	if (!ap_sta) {
-		ath10k_warn("Failed to find station entry for %pM\n",
-			    bss_conf->bssid);
+		ath10k_warn("Failed to find station entry for %pM, vdev %i\n",
+			    bss_conf->bssid, arvif->vdev_id);
 		rcu_read_unlock();
 		return;
 	}
@@ -1404,8 +1420,8 @@ static void ath10k_bss_assoc(struct ieee80211_hw *hw,
 	ret = ath10k_peer_assoc_prepare(ar, arvif, ap_sta,
 					bss_conf, &peer_arg);
 	if (ret) {
-		ath10k_warn("Peer assoc prepare failed for %pM\n: %d",
-			    bss_conf->bssid, ret);
+		ath10k_warn("Peer assoc prepare failed for %pM vdev %i\n: %d",
+			    bss_conf->bssid, arvif->vdev_id, ret);
 		rcu_read_unlock();
 		return;
 	}
@@ -1414,8 +1430,8 @@ static void ath10k_bss_assoc(struct ieee80211_hw *hw,
 
 	ret = ath10k_wmi_peer_assoc(ar, &peer_arg);
 	if (ret) {
-		ath10k_warn("Peer assoc failed for %pM\n: %d",
-			    bss_conf->bssid, ret);
+		ath10k_warn("Peer assoc failed for %pM vdev %i\n: %d",
+			    bss_conf->bssid, arvif->vdev_id, ret);
 		return;
 	}
 
@@ -1488,28 +1504,29 @@ static int ath10k_station_assoc(struct ath10k *ar, struct ath10k_vif *arvif,
 
 	ret = ath10k_peer_assoc_prepare(ar, arvif, sta, NULL, &peer_arg);
 	if (ret) {
-		ath10k_warn("WMI peer assoc prepare failed for %pM\n",
-			    sta->addr);
+		ath10k_warn("WMI peer assoc prepare failed for %pM vdev %i: %i\n",
+			    sta->addr, arvif->vdev_id, ret);
 		return ret;
 	}
 
 	ret = ath10k_wmi_peer_assoc(ar, &peer_arg);
 	if (ret) {
-		ath10k_warn("Peer assoc failed for STA %pM\n: %d",
-			    sta->addr, ret);
+		ath10k_warn("Peer assoc failed for STA %pM vdev %i: %d\n",
+			    sta->addr, arvif->vdev_id, ret);
 		return ret;
 	}
 
 	ret = ath10k_install_peer_wep_keys(arvif, sta->addr);
 	if (ret) {
-		ath10k_warn("could not install peer wep keys (%d)\n", ret);
+		ath10k_warn("could not install peer wep keys, vdev %i (%d)\n",
+			    arvif->vdev_id, ret);
 		return ret;
 	}
 
 	ret = ath10k_peer_assoc_qos_ap(ar, arvif, sta);
 	if (ret) {
-		ath10k_warn("could not set qos params for STA %pM, %d\n",
-			    sta->addr, ret);
+		ath10k_warn("could not set qos params for STA %pM, vdev %i %d\n",
+			    sta->addr, arvif->vdev_id, ret);
 		return ret;
 	}
 
@@ -1525,7 +1542,8 @@ static int ath10k_station_disassoc(struct ath10k *ar, struct ath10k_vif *arvif,
 
 	ret = ath10k_clear_peer_keys(arvif, sta->addr);
 	if (ret) {
-		ath10k_warn("could not clear all peer wep keys (%d)\n", ret);
+		ath10k_warn("could not clear all peer wep keys, vdev %i (%d)\n",
+			    arvif->vdev_id, ret);
 		return ret;
 	}
 
@@ -2492,7 +2510,8 @@ static int ath10k_add_interface(struct ieee80211_hw *hw,
 	ret = ath10k_wmi_vdev_create(ar, arvif->vdev_id, arvif->vdev_type,
 				     arvif->vdev_subtype, vif->addr);
 	if (ret) {
-		ath10k_warn("WMI vdev create failed: ret %d\n", ret);
+		ath10k_warn("WMI vdev %i create failed: ret %d\n",
+			    arvif->vdev_id, ret);
 		goto err;
 	}
 
@@ -2503,7 +2522,8 @@ static int ath10k_add_interface(struct ieee80211_hw *hw,
 	ret = ath10k_wmi_vdev_set_param(ar, 0, vdev_param,
 					arvif->def_wep_key_idx);
 	if (ret) {
-		ath10k_warn("Failed to set default keyid: %d\n", ret);
+		ath10k_warn("Failed to set vdev %i default keyid: %d\n",
+			    arvif->vdev_id, ret);
 		goto err_vdev_delete;
 	}
 
@@ -2512,21 +2532,23 @@ static int ath10k_add_interface(struct ieee80211_hw *hw,
 					ATH10K_HW_TXRX_NATIVE_WIFI);
 	/* 10.X firmware does not support this VDEV parameter. Do not warn */
 	if (ret && ret != -EOPNOTSUPP) {
-		ath10k_warn("Failed to set TX encap: %d\n", ret);
+		ath10k_warn("Failed to set vdev %i TX encap: %d\n",
+			    arvif->vdev_id, ret);
 		goto err_vdev_delete;
 	}
 
 	if (arvif->vdev_type == WMI_VDEV_TYPE_AP) {
 		ret = ath10k_peer_create(ar, arvif->vdev_id, vif->addr);
 		if (ret) {
-			ath10k_warn("Failed to create peer for AP: %d\n", ret);
+			ath10k_warn("Failed to create vdev %i peer for AP: %d\n",
+				    arvif->vdev_id, ret);
 			goto err_vdev_delete;
 		}
 
 		ret = ath10k_mac_set_kickout(arvif);
 		if (ret) {
-			ath10k_warn("Failed to set kickout parameters: %d\n",
-				    ret);
+			ath10k_warn("Failed to set vdev %i kickout parameters: %d\n",
+				    arvif->vdev_id, ret);
 			goto err_peer_delete;
 		}
 	}
@@ -2537,7 +2559,8 @@ static int ath10k_add_interface(struct ieee80211_hw *hw,
 		ret = ath10k_wmi_set_sta_ps_param(ar, arvif->vdev_id,
 						  param, value);
 		if (ret) {
-			ath10k_warn("Failed to set RX wake policy: %d\n", ret);
+			ath10k_warn("Failed to set vdev %i RX wake policy: %d\n",
+				    arvif->vdev_id, ret);
 			goto err_peer_delete;
 		}
 
@@ -2546,7 +2569,8 @@ static int ath10k_add_interface(struct ieee80211_hw *hw,
 		ret = ath10k_wmi_set_sta_ps_param(ar, arvif->vdev_id,
 						  param, value);
 		if (ret) {
-			ath10k_warn("Failed to set TX wake thresh: %d\n", ret);
+			ath10k_warn("Failed to set vdev %i TX wake thresh: %d\n",
+				    arvif->vdev_id, ret);
 			goto err_peer_delete;
 		}
 
@@ -2555,7 +2579,8 @@ static int ath10k_add_interface(struct ieee80211_hw *hw,
 		ret = ath10k_wmi_set_sta_ps_param(ar, arvif->vdev_id,
 						  param, value);
 		if (ret) {
-			ath10k_warn("Failed to set PSPOLL count: %d\n", ret);
+			ath10k_warn("Failed to set vdev %i PSPOLL count: %d\n",
+				    arvif->vdev_id, ret);
 			goto err_peer_delete;
 		}
 	}
@@ -2619,17 +2644,19 @@ static void ath10k_remove_interface(struct ieee80211_hw *hw,
 	if (arvif->vdev_type == WMI_VDEV_TYPE_AP) {
 		ret = ath10k_peer_delete(arvif->ar, arvif->vdev_id, vif->addr);
 		if (ret)
-			ath10k_warn("Failed to remove peer for AP: %d\n", ret);
+			ath10k_warn("Failed to remove peer for AP vdev %i: %d\n",
+				    arvif->vdev_id, ret);
 
 		kfree(arvif->u.ap.noa_data);
 	}
 
-	ath10k_dbg(ATH10K_DBG_MAC, "mac vdev delete %d (remove interface)\n",
+	ath10k_dbg(ATH10K_DBG_MAC, "mac vdev %i delete (remove interface)\n",
 		   arvif->vdev_id);
 
 	ret = ath10k_wmi_vdev_delete(ar, arvif->vdev_id);
 	if (ret)
-		ath10k_warn("WMI vdev delete failed: %d\n", ret);
+		ath10k_warn("WMI vdev %i delete failed: %d\n",
+			    arvif->vdev_id, ret);
 
 	if (arvif->vdev_type == WMI_VDEV_TYPE_MONITOR)
 		ar->monitor_present = false;
@@ -2718,8 +2745,8 @@ static void ath10k_bss_info_changed(struct ieee80211_hw *hw,
 			   arvif->vdev_id, arvif->beacon_interval);
 
 		if (ret)
-			ath10k_warn("Failed to set beacon interval for VDEV: %d\n",
-				    arvif->vdev_id);
+			ath10k_warn("Failed to set beacon interval for VDEV %d: %i\n",
+				    arvif->vdev_id, ret);
 	}
 
 	if (changed & BSS_CHANGED_BEACON) {
@@ -2731,8 +2758,8 @@ static void ath10k_bss_info_changed(struct ieee80211_hw *hw,
 		ret = ath10k_wmi_pdev_set_param(ar, pdev_param,
 						WMI_BEACON_STAGGERED_MODE);
 		if (ret)
-			ath10k_warn("Failed to set beacon mode for VDEV: %d\n",
-				    arvif->vdev_id);
+			ath10k_warn("Failed to set beacon mode for VDEV %d: %i\n",
+				    arvif->vdev_id, ret);
 	}
 
 	if (changed & BSS_CHANGED_BEACON_INFO) {
@@ -2746,8 +2773,8 @@ static void ath10k_bss_info_changed(struct ieee80211_hw *hw,
 		ret = ath10k_wmi_vdev_set_param(ar, arvif->vdev_id, vdev_param,
 						arvif->dtim_period);
 		if (ret)
-			ath10k_warn("Failed to set dtim period for VDEV: %d\n",
-				    arvif->vdev_id);
+			ath10k_warn("Failed to set dtim period for VDEV %d: %i\n",
+				    arvif->vdev_id, ret);
 	}
 
 	if (changed & BSS_CHANGED_SSID &&
@@ -2767,7 +2794,7 @@ static void ath10k_bss_info_changed(struct ieee80211_hw *hw,
 			ret = ath10k_peer_create(ar, arvif->vdev_id,
 						 info->bssid);
 			if (ret)
-				ath10k_warn("Failed to add peer %pM for vdev %d when changin bssid: %i\n",
+				ath10k_warn("Failed to add peer %pM for vdev %d when changing bssid: %i\n",
 					    info->bssid, arvif->vdev_id, ret);
 
 			if (vif->type == NL80211_IFTYPE_STATION) {
@@ -2783,8 +2810,8 @@ static void ath10k_bss_info_changed(struct ieee80211_hw *hw,
 
 				ret = ath10k_vdev_start(arvif);
 				if (ret) {
-					ath10k_warn("failed to start vdev: %d\n",
-						    ret);
+					ath10k_warn("failed to start vdev %i: %d\n",
+						    arvif->vdev_id, ret);
 					return;
 				}
 
@@ -2819,8 +2846,8 @@ static void ath10k_bss_info_changed(struct ieee80211_hw *hw,
 		ret = ath10k_wmi_vdev_set_param(ar, arvif->vdev_id, vdev_param,
 						cts_prot);
 		if (ret)
-			ath10k_warn("Failed to set CTS prot for VDEV: %d\n",
-				    arvif->vdev_id);
+			ath10k_warn("Failed to set CTS prot for VDEV: %d ret %i\n",
+				    arvif->vdev_id, ret);
 	}
 
 	if (changed & BSS_CHANGED_ERP_SLOT) {
@@ -2838,8 +2865,8 @@ static void ath10k_bss_info_changed(struct ieee80211_hw *hw,
 		ret = ath10k_wmi_vdev_set_param(ar, arvif->vdev_id, vdev_param,
 						slottime);
 		if (ret)
-			ath10k_warn("Failed to set erp slot for VDEV: %d\n",
-				    arvif->vdev_id);
+			ath10k_warn("Failed to set erp slot for VDEV: %d ret %i\n",
+				    arvif->vdev_id, ret);
 	}
 
 	if (changed & BSS_CHANGED_ERP_PREAMBLE) {
@@ -2857,8 +2884,8 @@ static void ath10k_bss_info_changed(struct ieee80211_hw *hw,
 		ret = ath10k_wmi_vdev_set_param(ar, arvif->vdev_id, vdev_param,
 						preamble);
 		if (ret)
-			ath10k_warn("Failed to set preamble for VDEV: %d\n",
-				    arvif->vdev_id);
+			ath10k_warn("Failed to set preamble for VDEV: %d ret %i\n",
+				    arvif->vdev_id, ret);
 	}
 
 	if (changed & BSS_CHANGED_ASSOC) {
@@ -2988,8 +3015,8 @@ static void ath10k_set_key_h_def_keyidx(struct ath10k *ar,
 	ret = ath10k_wmi_vdev_set_param(ar, arvif->vdev_id, vdev_param,
 					key->keyidx);
 	if (ret)
-		ath10k_warn("failed to set group key as default key: %d\n",
-			    ret);
+		ath10k_warn("failed to set vdev %i group key as default key: %d\n",
+			    arvif->vdev_id, ret);
 }
 
 static int ath10k_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
@@ -3049,7 +3076,8 @@ static int ath10k_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 
 	ret = ath10k_install_key(arvif, key, cmd, peer_addr);
 	if (ret) {
-		ath10k_warn("ath10k_install_key failed (%d)\n", ret);
+		ath10k_warn("ath10k_install_key failed for vdev %i peer %pM (%d)\n",
+			    arvif->vdev_id, peer_addr, ret);
 		goto exit;
 	}
 
@@ -3120,8 +3148,8 @@ static int ath10k_sta_state(struct ieee80211_hw *hw,
 			   arvif->vdev_id, sta->addr);
 		ret = ath10k_peer_delete(ar, arvif->vdev_id, sta->addr);
 		if (ret)
-			ath10k_warn("Failed to delete peer: %pM for VDEV: %d\n",
-				    sta->addr, arvif->vdev_id);
+			ath10k_warn("Failed to delete peer: %pM for VDEV: %d ret %i\n",
+				    sta->addr, arvif->vdev_id, ret);
 
 		if (vif->type == NL80211_IFTYPE_STATION)
 			ath10k_bss_disassoc(hw, vif);
@@ -3137,8 +3165,8 @@ static int ath10k_sta_state(struct ieee80211_hw *hw,
 
 		ret = ath10k_station_assoc(ar, arvif, sta);
 		if (ret)
-			ath10k_warn("Failed to associate station: %pM\n",
-				    sta->addr);
+			ath10k_warn("Failed to associate station: %pM vdev %i ret %i\n",
+				    sta->addr, arvif->vdev_id, ret);
 	} else if (old_state == IEEE80211_STA_ASSOC &&
 		   new_state == IEEE80211_STA_AUTH &&
 		   (vif->type == NL80211_IFTYPE_AP ||
@@ -3151,8 +3179,8 @@ static int ath10k_sta_state(struct ieee80211_hw *hw,
 
 		ret = ath10k_station_disassoc(ar, arvif, sta);
 		if (ret)
-			ath10k_warn("Failed to disassociate station: %pM\n",
-				    sta->addr);
+			ath10k_warn("Failed to disassociate station: %pM vdev %i ret %i\n",
+				    sta->addr, arvif->vdev_id, ret);
 	}
 exit:
 	mutex_unlock(&ar->conf_mutex);
@@ -4311,7 +4339,7 @@ int ath10k_mac_register(struct ath10k *ar)
 	ret = ath_regd_init(&ar->ath_common.regulatory, ar->hw->wiphy,
 			    ath10k_reg_notifier);
 	if (ret) {
-		ath10k_err("Regulatory initialization failed\n");
+		ath10k_err("Regulatory initialization failed, ret %i\n", ret);
 		goto err_free;
 	}
 
-- 
1.7.11.7

