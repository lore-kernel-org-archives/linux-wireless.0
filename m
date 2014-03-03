Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh01.mail.saunalahti.fi ([62.142.5.107]:34816 "EHLO
	emh01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754018AbaCCPnc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Mar 2014 10:43:32 -0500
Subject: [PATCH] ath10k: unify warning messages in mac.c
To: ath10k@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 03 Mar 2014 17:43:27 +0200
Message-ID: <20140303154327.1290.67278.stgit@potku.adurom.net> (sfid-20140303_164336_652559_8742575A)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently there are different styles used for warning messages, unify them to
look similar.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/mac.c |  189 ++++++++++++++++-----------------
 1 file changed, 94 insertions(+), 95 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 511a2f81e7af..cfe0e461c841 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -165,7 +165,7 @@ static int ath10k_clear_peer_keys(struct ath10k_vif *arvif,
 			first_errno = ret;
 
 		if (ret)
-			ath10k_warn("could not remove peer wep key %d (%d)\n",
+			ath10k_warn("Failed to remove peer wep key %d: %d\n",
 				    i, ret);
 
 		peer->keys[i] = NULL;
@@ -213,7 +213,8 @@ static int ath10k_clear_vdev_key(struct ath10k_vif *arvif,
 			first_errno = ret;
 
 		if (ret)
-			ath10k_warn("could not remove key for %pM\n", addr);
+			ath10k_warn("Failed to remove key for %pM: %d\n",
+				    addr, ret);
 	}
 
 	return first_errno;
@@ -360,7 +361,7 @@ static int ath10k_mac_set_kickout(struct ath10k_vif *arvif)
 	ret = ath10k_wmi_vdev_set_param(ar, arvif->vdev_id, param,
 					ATH10K_KEEPALIVE_MIN_IDLE);
 	if (ret) {
-		ath10k_warn("Failed to set keepalive minimum idle time on vdev %i : %d\n",
+		ath10k_warn("Failed to set keepalive minimum idle time on vdev %i: %d\n",
 			    arvif->vdev_id, ret);
 		return ret;
 	}
@@ -532,14 +533,14 @@ static int ath10k_vdev_start(struct ath10k_vif *arvif)
 
 	ret = ath10k_wmi_vdev_start(ar, &arg);
 	if (ret) {
-		ath10k_warn("WMI vdev %i start failed: ret %d\n",
+		ath10k_warn("WMI vdev %i start failed: %d\n",
 			    arg.vdev_id, ret);
 		return ret;
 	}
 
 	ret = ath10k_vdev_setup_sync(ar);
 	if (ret) {
-		ath10k_warn("vdev %i setup failed %d\n",
+		ath10k_warn("vdev %i setup failed: %d\n",
 			    arg.vdev_id, ret);
 		return ret;
 	}
@@ -558,14 +559,14 @@ static int ath10k_vdev_stop(struct ath10k_vif *arvif)
 
 	ret = ath10k_wmi_vdev_stop(ar, arvif->vdev_id);
 	if (ret) {
-		ath10k_warn("WMI vdev %i stop failed: ret %d\n",
+		ath10k_warn("WMI vdev %i stop failed: %d\n",
 			    arvif->vdev_id, ret);
 		return ret;
 	}
 
 	ret = ath10k_vdev_setup_sync(ar);
 	if (ret) {
-		ath10k_warn("vdev %i setup sync failed %d\n",
+		ath10k_warn("vdev %i setup sync failed: %d\n",
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
 
@@ -604,14 +605,14 @@ static int ath10k_monitor_start(struct ath10k *ar, int vdev_id)
 
 	ret = ath10k_wmi_vdev_start(ar, &arg);
 	if (ret) {
-		ath10k_warn("Monitor vdev %i start failed: ret %d\n",
+		ath10k_warn("Monitor vdev %i start failed: %d\n",
 			    vdev_id, ret);
 		return ret;
 	}
 
 	ret = ath10k_vdev_setup_sync(ar);
 	if (ret) {
-		ath10k_warn("Monitor vdev %i setup failed %d\n",
+		ath10k_warn("Monitor vdev %i setup failed: %d\n",
 			    vdev_id, ret);
 		return ret;
 	}
@@ -644,12 +645,12 @@ static int ath10k_monitor_stop(struct ath10k *ar)
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
 
@@ -696,7 +697,7 @@ static int ath10k_monitor_create(struct ath10k *ar)
 				     WMI_VDEV_TYPE_MONITOR,
 				     0, ar->mac_addr);
 	if (ret) {
-		ath10k_warn("WMI vdev %i monitor create failed: ret %d\n",
+		ath10k_warn("WMI vdev %i monitor create failed: %d\n",
 			    ar->monitor_vdev_id, ret);
 		goto vdev_fail;
 	}
@@ -835,7 +836,7 @@ static void ath10k_config_radar_detection(struct ath10k *ar)
 		 * radiation is not allowed, make this channel DFS_UNAVAILABLE
 		 * by indicating that radar was detected.
 		 */
-		ath10k_warn("failed to start CAC (%d)\n", ret);
+		ath10k_warn("Failed to start CAC: %d\n", ret);
 		ieee80211_radar_detected(ar->hw);
 	}
 }
@@ -904,7 +905,7 @@ static void ath10k_control_ibss(struct ath10k_vif *arvif,
 	if (!info->ibss_joined) {
 		ret = ath10k_peer_delete(arvif->ar, arvif->vdev_id, self_peer);
 		if (ret)
-			ath10k_warn("Failed to delete IBSS self peer:%pM for VDEV:%d ret:%d\n",
+			ath10k_warn("Failed to delete IBSS self peer %pM for vdev %d: %d\n",
 				    self_peer, arvif->vdev_id, ret);
 
 		if (is_zero_ether_addr(arvif->bssid))
@@ -913,7 +914,7 @@ static void ath10k_control_ibss(struct ath10k_vif *arvif,
 		ret = ath10k_peer_delete(arvif->ar, arvif->vdev_id,
 					 arvif->bssid);
 		if (ret) {
-			ath10k_warn("Failed to delete IBSS BSSID peer:%pM for VDEV:%d ret:%d\n",
+			ath10k_warn("Failed to delete IBSS BSSID peer %pM for vdev %d: %d\n",
 				    arvif->bssid, arvif->vdev_id, ret);
 			return;
 		}
@@ -925,7 +926,7 @@ static void ath10k_control_ibss(struct ath10k_vif *arvif,
 
 	ret = ath10k_peer_create(arvif->ar, arvif->vdev_id, self_peer);
 	if (ret) {
-		ath10k_warn("Failed to create IBSS self peer:%pM for VDEV:%d ret:%d\n",
+		ath10k_warn("Failed to create IBSS self peer %pM for vdev %d: %d\n",
 			    self_peer, arvif->vdev_id, ret);
 		return;
 	}
@@ -934,7 +935,7 @@ static void ath10k_control_ibss(struct ath10k_vif *arvif,
 	ret = ath10k_wmi_vdev_set_param(arvif->ar, arvif->vdev_id, vdev_param,
 					ATH10K_DEFAULT_ATIM);
 	if (ret)
-		ath10k_warn("Failed to set IBSS ATIM for VDEV:%d ret:%d\n",
+		ath10k_warn("Failed to set IBSS ATIM for vdev %d: %d\n",
 			    arvif->vdev_id, ret);
 }
 
@@ -974,8 +975,8 @@ static int ath10k_mac_vif_setup_ps(struct ath10k_vif *arvif)
 
 	ret = ath10k_wmi_set_psmode(ar, arvif->vdev_id, psmode);
 	if (ret) {
-		ath10k_warn("Failed to set PS Mode: %d for VDEV: %d\n",
-			    psmode, arvif->vdev_id);
+		ath10k_warn("Failed to set PS Mode %d for vdev %d: %d\n",
+			    psmode, arvif->vdev_id, ret);
 		return ret;
 	}
 
@@ -1214,7 +1215,7 @@ static int ath10k_peer_assoc_qos_ap(struct ath10k *ar,
 						 WMI_AP_PS_PEER_PARAM_UAPSD,
 						 uapsd);
 		if (ret) {
-			ath10k_warn("failed to set ap ps peer param uapsd for vdev %i: %d\n",
+			ath10k_warn("Failed to set ap ps peer param uapsd for vdev %i: %d\n",
 				    arvif->vdev_id, ret);
 			return ret;
 		}
@@ -1224,7 +1225,7 @@ static int ath10k_peer_assoc_qos_ap(struct ath10k *ar,
 						 WMI_AP_PS_PEER_PARAM_MAX_SP,
 						 max_sp);
 		if (ret) {
-			ath10k_warn("failed to set ap ps peer param max sp for vdev %i: %d\n",
+			ath10k_warn("Failed to set ap ps peer param max sp for vdev %i: %d\n",
 				    arvif->vdev_id, ret);
 			return ret;
 		}
@@ -1236,7 +1237,7 @@ static int ath10k_peer_assoc_qos_ap(struct ath10k *ar,
 		ret = ath10k_wmi_set_ap_ps_param(ar, arvif->vdev_id, sta->addr,
 					WMI_AP_PS_PEER_PARAM_AGEOUT_TIME, 10);
 		if (ret) {
-			ath10k_warn("failed to set ap ps peer param ageout time for vdev %i: %d\n",
+			ath10k_warn("Failed to set ap ps peer param ageout time for vdev %i: %d\n",
 				    arvif->vdev_id, ret);
 			return ret;
 		}
@@ -1429,7 +1430,7 @@ static void ath10k_bss_assoc(struct ieee80211_hw *hw,
 
 	ap_sta = ieee80211_find_sta(vif, bss_conf->bssid);
 	if (!ap_sta) {
-		ath10k_warn("Failed to find station entry for %pM, vdev %i\n",
+		ath10k_warn("Failed to find station entry for bss %pM vdev %i\n",
 			    bss_conf->bssid, arvif->vdev_id);
 		rcu_read_unlock();
 		return;
@@ -1442,7 +1443,7 @@ static void ath10k_bss_assoc(struct ieee80211_hw *hw,
 	ret = ath10k_peer_assoc_prepare(ar, arvif, ap_sta,
 					bss_conf, &peer_arg);
 	if (ret) {
-		ath10k_warn("Peer assoc prepare failed for %pM vdev %i\n: %d",
+		ath10k_warn("Peer assoc prepare failed for %pM vdev %i: %d\n",
 			    bss_conf->bssid, arvif->vdev_id, ret);
 		rcu_read_unlock();
 		return;
@@ -1452,14 +1453,14 @@ static void ath10k_bss_assoc(struct ieee80211_hw *hw,
 
 	ret = ath10k_wmi_peer_assoc(ar, &peer_arg);
 	if (ret) {
-		ath10k_warn("Peer assoc failed for %pM vdev %i\n: %d",
+		ath10k_warn("Peer assoc failed for %pM vdev %i: %d\n",
 			    bss_conf->bssid, arvif->vdev_id, ret);
 		return;
 	}
 
 	ret = ath10k_setup_peer_smps(ar, arvif, bss_conf->bssid, &ht_cap);
 	if (ret) {
-		ath10k_warn("failed to setup peer SMPS for vdev %i: %d\n",
+		ath10k_warn("Failed to setup peer SMPS for vdev %i: %d\n",
 			    arvif->vdev_id, ret);
 		return;
 	}
@@ -1473,7 +1474,7 @@ static void ath10k_bss_assoc(struct ieee80211_hw *hw,
 
 	ret = ath10k_wmi_vdev_up(ar, arvif->vdev_id, arvif->aid, arvif->bssid);
 	if (ret) {
-		ath10k_warn("VDEV: %d up failed: ret %d\n",
+		ath10k_warn("Failed to set vdev %d up: %d\n",
 			    arvif->vdev_id, ret);
 		return;
 	}
@@ -1547,20 +1548,21 @@ static int ath10k_station_assoc(struct ath10k *ar, struct ath10k_vif *arvif,
 
 	ret = ath10k_setup_peer_smps(ar, arvif, sta->addr, &sta->ht_cap);
 	if (ret) {
-		ath10k_warn("failed to setup peer SMPS for vdev: %d\n", ret);
+		ath10k_warn("Failed to setup peer SMPS for vdev %d: %d\n",
+			    arvif->vdev_id, ret);
 		return ret;
 	}
 
 	ret = ath10k_install_peer_wep_keys(arvif, sta->addr);
 	if (ret) {
-		ath10k_warn("could not install peer wep keys for vdev %i: %d\n",
+		ath10k_warn("Could not install peer wep keys for vdev %i: %d\n",
 			    arvif->vdev_id, ret);
 		return ret;
 	}
 
 	ret = ath10k_peer_assoc_qos_ap(ar, arvif, sta);
 	if (ret) {
-		ath10k_warn("could not set qos params for STA %pM for vdev %i: %d\n",
+		ath10k_warn("Could not set qos params for STA %pM for vdev %i: %d\n",
 			    sta->addr, arvif->vdev_id, ret);
 		return ret;
 	}
@@ -1577,7 +1579,7 @@ static int ath10k_station_disassoc(struct ath10k *ar, struct ath10k_vif *arvif,
 
 	ret = ath10k_clear_peer_keys(arvif, sta->addr);
 	if (ret) {
-		ath10k_warn("could not clear all peer wep keys for vdev %i: %d\n",
+		ath10k_warn("Could not clear all peer wep keys for vdev %i: %d\n",
 			    arvif->vdev_id, ret);
 		return ret;
 	}
@@ -1694,7 +1696,7 @@ static void ath10k_regd_update(struct ath10k *ar)
 
 	ret = ath10k_update_channel_list(ar);
 	if (ret)
-		ath10k_warn("could not update channel list (%d)\n", ret);
+		ath10k_warn("Could not update channel list: %d\n", ret);
 
 	regpair = ar->ath_common.regulatory.regpair;
 
@@ -1707,7 +1709,7 @@ static void ath10k_regd_update(struct ath10k *ar)
 					    regpair->reg_2ghz_ctl,
 					    regpair->reg_5ghz_ctl);
 	if (ret)
-		ath10k_warn("could not set pdev regdomain (%d)\n", ret);
+		ath10k_warn("Could not set pdev regdomain: %d\n", ret);
 }
 
 static void ath10k_reg_notifier(struct wiphy *wiphy,
@@ -1725,7 +1727,7 @@ static void ath10k_reg_notifier(struct wiphy *wiphy,
 		result = ar->dfs_detector->set_dfs_domain(ar->dfs_detector,
 							  request->dfs_region);
 		if (!result)
-			ath10k_warn("dfs region 0x%X not supported, will trigger radar for every pulse\n",
+			ath10k_warn("DFS region 0x%X not supported, will trigger radar for every pulse\n",
 				    request->dfs_region);
 	}
 
@@ -1762,7 +1764,7 @@ static u8 ath10k_tx_h_get_vdev_id(struct ath10k *ar,
 	if (ar->monitor_enabled)
 		return ar->monitor_vdev_id;
 
-	ath10k_warn("could not resolve vdev id\n");
+	ath10k_warn("Could not resolve vdev id\n");
 	return 0;
 }
 
@@ -1803,7 +1805,7 @@ static void ath10k_tx_wep_key_work(struct work_struct *work)
 					arvif->ar->wmi.vdev_param->def_keyid,
 					keyidx);
 	if (ret) {
-		ath10k_warn("could not update wep keyidx (%d)\n", ret);
+		ath10k_warn("Could not update wep keyidx: %d\n", ret);
 		return;
 	}
 
@@ -1879,7 +1881,7 @@ static void ath10k_tx_htt(struct ath10k *ar, struct sk_buff *skb)
 			     ar->fw_features)) {
 			if (skb_queue_len(&ar->wmi_mgmt_tx_queue) >=
 			    ATH10K_MAX_NUM_MGMT_PENDING) {
-				ath10k_warn("wmi mgmt_tx queue limit reached\n");
+				ath10k_warn("WMI mgmt_tx queue limit reached\n");
 				ret = -EBUSY;
 				goto exit;
 			}
@@ -1903,7 +1905,7 @@ static void ath10k_tx_htt(struct ath10k *ar, struct sk_buff *skb)
 
 exit:
 	if (ret) {
-		ath10k_warn("tx failed (%d). dropping packet.\n", ret);
+		ath10k_warn("tx failed, dropping packet: %d\n", ret);
 		ieee80211_free_txskb(ar->hw, skb);
 	}
 }
@@ -1964,7 +1966,7 @@ void ath10k_offchan_tx_work(struct work_struct *work)
 		if (!peer) {
 			ret = ath10k_peer_create(ar, vdev_id, peer_addr);
 			if (ret)
-				ath10k_warn("peer %pM on vdev %d not created (%d)\n",
+				ath10k_warn("Peer %pM on vdev %d not created: %d\n",
 					    peer_addr, vdev_id, ret);
 		}
 
@@ -1978,13 +1980,13 @@ void ath10k_offchan_tx_work(struct work_struct *work)
 		ret = wait_for_completion_timeout(&ar->offchan_tx_completed,
 						  3 * HZ);
 		if (ret <= 0)
-			ath10k_warn("timed out waiting for offchannel skb %p\n",
+			ath10k_warn("Timed out waiting for offchannel skb %p\n",
 				    skb);
 
 		if (!peer) {
 			ret = ath10k_peer_delete(ar, vdev_id, peer_addr);
 			if (ret)
-				ath10k_warn("peer %pM on vdev %d not deleted (%d)\n",
+				ath10k_warn("Peer %pM on vdev %d not deleted: %d\n",
 					    peer_addr, vdev_id, ret);
 		}
 
@@ -2018,7 +2020,7 @@ void ath10k_mgmt_over_wmi_tx_work(struct work_struct *work)
 
 		ret = ath10k_wmi_mgmt_tx(ar, skb);
 		if (ret) {
-			ath10k_warn("wmi mgmt_tx failed (%d)\n", ret);
+			ath10k_warn("WMI mgmt_tx failed: %d\n", ret);
 			ieee80211_free_txskb(ar->hw, skb);
 		}
 	}
@@ -2043,7 +2045,7 @@ void ath10k_reset_scan(unsigned long ptr)
 		return;
 	}
 
-	ath10k_warn("scan timeout. resetting. fw issue?\n");
+	ath10k_warn("Scan timeout,resetting. Firmware problem?\n");
 
 	if (ar->scan.is_roc)
 		ieee80211_remain_on_channel_expired(ar->hw);
@@ -2079,7 +2081,7 @@ static int ath10k_abort_scan(struct ath10k *ar)
 
 	ret = ath10k_wmi_stop_scan(ar, &arg);
 	if (ret) {
-		ath10k_warn("could not submit wmi stop scan (%d)\n", ret);
+		ath10k_warn("Could not submit wmi stop scan: %d\n", ret);
 		spin_lock_bh(&ar->data_lock);
 		ar->scan.in_progress = false;
 		ath10k_offchan_tx_purge(ar);
@@ -2089,7 +2091,7 @@ static int ath10k_abort_scan(struct ath10k *ar)
 
 	ret = wait_for_completion_timeout(&ar->scan.completed, 3*HZ);
 	if (ret == 0)
-		ath10k_warn("timed out while waiting for scan to stop\n");
+		ath10k_warn("Timed out while waiting for scan to stop\n");
 
 	/* scan completion may be done right after we timeout here, so let's
 	 * check the in_progress and tell mac80211 scan is completed. if we
@@ -2099,7 +2101,7 @@ static int ath10k_abort_scan(struct ath10k *ar)
 
 	spin_lock_bh(&ar->data_lock);
 	if (ar->scan.in_progress) {
-		ath10k_warn("could not stop scan. its still in progress\n");
+		ath10k_warn("Could not stop scan, it's still in progress\n");
 		ar->scan.in_progress = false;
 		ath10k_offchan_tx_purge(ar);
 		ret = -ETIMEDOUT;
@@ -2226,14 +2228,14 @@ static int ath10k_start(struct ieee80211_hw *hw)
 
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
@@ -2246,13 +2248,11 @@ static int ath10k_start(struct ieee80211_hw *hw)
 
 	ret = ath10k_wmi_pdev_set_param(ar, ar->wmi.pdev_param->pmf_qos, 1);
 	if (ret)
-		ath10k_warn("could not enable WMI_PDEV_PARAM_PMF_QOS (%d)\n",
-			    ret);
+		ath10k_warn("Could not enable PMF QOS: %d\n", ret);
 
 	ret = ath10k_wmi_pdev_set_param(ar, ar->wmi.pdev_param->dynamic_bw, 1);
 	if (ret)
-		ath10k_warn("could not init WMI_PDEV_PARAM_DYNAMIC_BW (%d)\n",
-			    ret);
+		ath10k_warn("Could not enable dynamic BW: %d\n", ret);
 
 	/*
 	 * By default FW set ARP frames ac to voice (6). In that case ARP
@@ -2266,7 +2266,7 @@ static int ath10k_start(struct ieee80211_hw *hw)
 	ret = ath10k_wmi_pdev_set_param(ar,
 					ar->wmi.pdev_param->arp_ac_override, 0);
 	if (ret) {
-		ath10k_warn("could not set arp ac override parameter: %d\n",
+		ath10k_warn("Could not set arp ac override parameter: %d\n",
 			    ret);
 		goto exit;
 	}
@@ -2309,7 +2309,7 @@ static int ath10k_config_ps(struct ath10k *ar)
 	list_for_each_entry(arvif, &ar->arvifs, list) {
 		ret = ath10k_mac_vif_setup_ps(arvif);
 		if (ret) {
-			ath10k_warn("could not setup powersave (%d)\n", ret);
+			ath10k_warn("Could not setup powersave: %d\n", ret);
 			break;
 		}
 	}
@@ -2371,7 +2371,7 @@ static void ath10k_config_chan(struct ath10k *ar)
 
 		ret = ath10k_vdev_stop(arvif);
 		if (ret) {
-			ath10k_warn("could not stop vdev %d (%d)\n",
+			ath10k_warn("Could not stop vdev %d: %d\n",
 				    arvif->vdev_id, ret);
 			continue;
 		}
@@ -2388,7 +2388,7 @@ static void ath10k_config_chan(struct ath10k *ar)
 
 		ret = ath10k_vdev_start(arvif);
 		if (ret) {
-			ath10k_warn("could not start vdev %d (%d)\n",
+			ath10k_warn("Could not start vdev %d: %d\n",
 				    arvif->vdev_id, ret);
 			continue;
 		}
@@ -2399,7 +2399,7 @@ static void ath10k_config_chan(struct ath10k *ar)
 		ret = ath10k_wmi_vdev_up(arvif->ar, arvif->vdev_id, arvif->aid,
 					 arvif->bssid);
 		if (ret) {
-			ath10k_warn("could not bring vdev up %d (%d)\n",
+			ath10k_warn("Could not bring vdev up %d: %d\n",
 				    arvif->vdev_id, ret);
 			continue;
 		}
@@ -2444,14 +2444,14 @@ static int ath10k_config(struct ieee80211_hw *hw, u32 changed)
 		ret = ath10k_wmi_pdev_set_param(ar, param,
 						hw->conf.power_level * 2);
 		if (ret)
-			ath10k_warn("mac failed to set 2g txpower %d (%d)\n",
+			ath10k_warn("Failed to set 2g txpower %d: %d\n",
 				    hw->conf.power_level, ret);
 
 		param = ar->wmi.pdev_param->txpower_limit5g;
 		ret = ath10k_wmi_pdev_set_param(ar, param,
 						hw->conf.power_level * 2);
 		if (ret)
-			ath10k_warn("mac failed to set 5g txpower %d (%d)\n",
+			ath10k_warn("Failed to set 5g txpower %d: %d\n",
 				    hw->conf.power_level, ret);
 	}
 
@@ -2545,7 +2545,7 @@ static int ath10k_add_interface(struct ieee80211_hw *hw,
 	ret = ath10k_wmi_vdev_create(ar, arvif->vdev_id, arvif->vdev_type,
 				     arvif->vdev_subtype, vif->addr);
 	if (ret) {
-		ath10k_warn("WMI vdev %i create failed: ret %d\n",
+		ath10k_warn("WMI vdev %i create failed: %d\n",
 			    arvif->vdev_id, ret);
 		goto err;
 	}
@@ -2622,14 +2622,14 @@ static int ath10k_add_interface(struct ieee80211_hw *hw,
 
 	ret = ath10k_mac_set_rts(arvif, ar->hw->wiphy->rts_threshold);
 	if (ret) {
-		ath10k_warn("failed to set rts threshold for vdev %d (%d)\n",
+		ath10k_warn("Failed to set rts threshold for vdev %d: %d\n",
 			    arvif->vdev_id, ret);
 		goto err_peer_delete;
 	}
 
 	ret = ath10k_mac_set_frag(arvif, ar->hw->wiphy->frag_threshold);
 	if (ret) {
-		ath10k_warn("failed to set frag threshold for vdev %d (%d)\n",
+		ath10k_warn("Failed to set frag threshold for vdev %d: %d\n",
 			    arvif->vdev_id, ret);
 		goto err_peer_delete;
 	}
@@ -2741,7 +2741,7 @@ static void ath10k_configure_filter(struct ieee80211_hw *hw,
 
 		ret = ath10k_monitor_start(ar, ar->monitor_vdev_id);
 		if (ret)
-			ath10k_warn("Unable to start monitor mode\n");
+			ath10k_warn("Unable to start monitor mode: %d\n", ret);
 	} else if (!(ar->filter_flags & FIF_PROMISC_IN_BSS) &&
 		   ar->monitor_enabled && ar->monitor_present) {
 		ath10k_dbg(ATH10K_DBG_MAC, "mac monitor %d stop\n",
@@ -2749,7 +2749,7 @@ static void ath10k_configure_filter(struct ieee80211_hw *hw,
 
 		ret = ath10k_monitor_stop(ar);
 		if (ret)
-			ath10k_warn("Unable to stop monitor mode\n");
+			ath10k_warn("Unable to stop monitor mode: %d\n", ret);
 	}
 
 	mutex_unlock(&ar->conf_mutex);
@@ -2845,7 +2845,7 @@ static void ath10k_bss_info_changed(struct ieee80211_hw *hw,
 
 				ret = ath10k_vdev_start(arvif);
 				if (ret) {
-					ath10k_warn("failed to start vdev %i: %d\n",
+					ath10k_warn("Failed to start vdev %i: %d\n",
 						    arvif->vdev_id, ret);
 					goto exit;
 				}
@@ -2990,7 +2990,7 @@ static int ath10k_hw_scan(struct ieee80211_hw *hw,
 
 	ret = ath10k_start_scan(ar, &arg);
 	if (ret) {
-		ath10k_warn("could not start hw scan (%d)\n", ret);
+		ath10k_warn("Could not start hw scan: %d\n", ret);
 		spin_lock_bh(&ar->data_lock);
 		ar->scan.in_progress = false;
 		spin_unlock_bh(&ar->data_lock);
@@ -3010,8 +3010,7 @@ static void ath10k_cancel_hw_scan(struct ieee80211_hw *hw,
 	mutex_lock(&ar->conf_mutex);
 	ret = ath10k_abort_scan(ar);
 	if (ret) {
-		ath10k_warn("couldn't abort scan (%d). forcefully sending scan completion to mac80211\n",
-			    ret);
+		ath10k_warn("Failed to abort scan: %d\n", ret);
 		ieee80211_scan_completed(hw, 1 /* aborted */);
 	}
 	mutex_unlock(&ar->conf_mutex);
@@ -3051,7 +3050,7 @@ static void ath10k_set_key_h_def_keyidx(struct ath10k *ar,
 	ret = ath10k_wmi_vdev_set_param(ar, arvif->vdev_id, vdev_param,
 					key->keyidx);
 	if (ret)
-		ath10k_warn("failed to set vdev %i group key as default key: %d\n",
+		ath10k_warn("Failed to set vdev %i group key as default key: %d\n",
 			    arvif->vdev_id, ret);
 }
 
@@ -3089,7 +3088,7 @@ static int ath10k_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 
 	if (!peer) {
 		if (cmd == SET_KEY) {
-			ath10k_warn("cannot install key for non-existent peer %pM\n",
+			ath10k_warn("Cannot install key for non-existent peer %pM\n",
 				    peer_addr);
 			ret = -EOPNOTSUPP;
 			goto exit;
@@ -3112,7 +3111,7 @@ static int ath10k_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 
 	ret = ath10k_install_key(arvif, key, cmd, peer_addr);
 	if (ret) {
-		ath10k_warn("key installation failed for vdev %i peer %pM: %d\n",
+		ath10k_warn("Key installation failed for vdev %i peer %pM: %d\n",
 			    arvif->vdev_id, peer_addr, ret);
 		goto exit;
 	}
@@ -3127,7 +3126,7 @@ static int ath10k_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		peer->keys[key->keyidx] = NULL;
 	else if (peer == NULL)
 		/* impossible unless FW goes crazy */
-		ath10k_warn("peer %pM disappeared!\n", peer_addr);
+		ath10k_warn("Peer %pM disappeared!\n", peer_addr);
 	spin_unlock_bh(&ar->data_lock);
 
 exit:
@@ -3169,7 +3168,7 @@ static void ath10k_sta_rc_update_wk(struct work_struct *wk)
 		err = ath10k_wmi_peer_set_param(ar, arvif->vdev_id, sta->addr,
 						WMI_PEER_CHAN_WIDTH, bw);
 		if (err)
-			ath10k_warn("failed to update STA %pM peer bw %d: %d\n",
+			ath10k_warn("Failed to update STA %pM peer bw %d: %d\n",
 				    sta->addr, bw, err);
 	}
 
@@ -3180,7 +3179,7 @@ static void ath10k_sta_rc_update_wk(struct work_struct *wk)
 		err = ath10k_wmi_peer_set_param(ar, arvif->vdev_id, sta->addr,
 						WMI_PEER_NSS, nss);
 		if (err)
-			ath10k_warn("failed to update STA %pM nss %d: %d\n",
+			ath10k_warn("Failed to update STA %pM nss %d: %d\n",
 				    sta->addr, nss, err);
 	}
 
@@ -3191,7 +3190,7 @@ static void ath10k_sta_rc_update_wk(struct work_struct *wk)
 		err = ath10k_wmi_peer_set_param(ar, arvif->vdev_id, sta->addr,
 						WMI_PEER_SMPS_STATE, smps);
 		if (err)
-			ath10k_warn("failed to update STA %pM smps %d: %d\n",
+			ath10k_warn("Failed to update STA %pM smps %d: %d\n",
 				    sta->addr, smps, err);
 	}
 
@@ -3291,7 +3290,7 @@ static int ath10k_sta_state(struct ieee80211_hw *hw,
 
 		ret = ath10k_station_disassoc(ar, arvif, sta);
 		if (ret)
-			ath10k_warn("Failed to disassociate station: %pM vdev %i ret %i\n",
+			ath10k_warn("Failed to disassociate station: %pM vdev %i: %i\n",
 				    sta->addr, arvif->vdev_id, ret);
 	}
 exit:
@@ -3339,7 +3338,7 @@ static int ath10k_conf_tx_uapsd(struct ath10k *ar, struct ieee80211_vif *vif,
 					  WMI_STA_PS_PARAM_UAPSD,
 					  arvif->u.sta.uapsd);
 	if (ret) {
-		ath10k_warn("could not set uapsd params %d\n", ret);
+		ath10k_warn("Could not set uapsd params: %d\n", ret);
 		goto exit;
 	}
 
@@ -3352,7 +3351,7 @@ static int ath10k_conf_tx_uapsd(struct ath10k *ar, struct ieee80211_vif *vif,
 					  WMI_STA_PS_PARAM_RX_WAKE_POLICY,
 					  value);
 	if (ret)
-		ath10k_warn("could not set rx wake param %d\n", ret);
+		ath10k_warn("Could not set rx wake param: %d\n", ret);
 
 exit:
 	return ret;
@@ -3402,13 +3401,13 @@ static int ath10k_conf_tx(struct ieee80211_hw *hw,
 	/* FIXME: FW accepts wmm params per hw, not per vif */
 	ret = ath10k_wmi_pdev_set_wmm_params(ar, &ar->wmm_params);
 	if (ret) {
-		ath10k_warn("could not set wmm params %d\n", ret);
+		ath10k_warn("Could not set wmm params: %d\n", ret);
 		goto exit;
 	}
 
 	ret = ath10k_conf_tx_uapsd(ar, vif, ac, params->uapsd);
 	if (ret)
-		ath10k_warn("could not set sta uapsd %d\n", ret);
+		ath10k_warn("Could not set sta uapsd: %d\n", ret);
 
 exit:
 	mutex_unlock(&ar->conf_mutex);
@@ -3461,7 +3460,7 @@ static int ath10k_remain_on_channel(struct ieee80211_hw *hw,
 
 	ret = ath10k_start_scan(ar, &arg);
 	if (ret) {
-		ath10k_warn("could not start roc scan (%d)\n", ret);
+		ath10k_warn("Could not start roc scan: %d\n", ret);
 		spin_lock_bh(&ar->data_lock);
 		ar->scan.in_progress = false;
 		spin_unlock_bh(&ar->data_lock);
@@ -3470,7 +3469,7 @@ static int ath10k_remain_on_channel(struct ieee80211_hw *hw,
 
 	ret = wait_for_completion_timeout(&ar->scan.on_channel, 3*HZ);
 	if (ret == 0) {
-		ath10k_warn("could not switch to channel for roc scan\n");
+		ath10k_warn("Could not switch to channel for roc scan\n");
 		ath10k_abort_scan(ar);
 		ret = -ETIMEDOUT;
 		goto exit;
@@ -3511,7 +3510,7 @@ static int ath10k_set_rts_threshold(struct ieee80211_hw *hw, u32 value)
 
 		ret = ath10k_mac_set_rts(arvif, value);
 		if (ret) {
-			ath10k_warn("could not set rts threshold for vdev %d (%d)\n",
+			ath10k_warn("Could not set rts threshold for vdev %d: %d\n",
 				    arvif->vdev_id, ret);
 			break;
 		}
@@ -3534,7 +3533,7 @@ static int ath10k_set_frag_threshold(struct ieee80211_hw *hw, u32 value)
 
 		ret = ath10k_mac_set_rts(arvif, value);
 		if (ret) {
-			ath10k_warn("could not set fragmentation threshold for vdev %d (%d)\n",
+			ath10k_warn("Could not set fragmentation threshold for vdev %d: %d\n",
 				    arvif->vdev_id, ret);
 			break;
 		}
@@ -3573,7 +3572,7 @@ static void ath10k_flush(struct ieee80211_hw *hw, u32 queues, bool drop)
 		}), ATH10K_FLUSH_TIMEOUT_HZ);
 
 	if (ret <= 0 || skip)
-		ath10k_warn("tx not flushed (skip %i ar-state %i): %i\n",
+		ath10k_warn("Tx not flushed (skip %i ar-state %i): %i\n",
 			    skip, ar->state, ret);
 
 skip:
@@ -3608,7 +3607,7 @@ static int ath10k_suspend(struct ieee80211_hw *hw,
 
 	ret = ath10k_hif_suspend(ar);
 	if (ret) {
-		ath10k_warn("could not suspend hif (%d)\n", ret);
+		ath10k_warn("Could not suspend hif: %d\n", ret);
 		goto resume;
 	}
 
@@ -3617,7 +3616,7 @@ static int ath10k_suspend(struct ieee80211_hw *hw,
 resume:
 	ret = ath10k_wmi_pdev_resume_target(ar);
 	if (ret)
-		ath10k_warn("could not resume target (%d)\n", ret);
+		ath10k_warn("Could not resume target: %d\n", ret);
 
 	ret = 1;
 exit:
@@ -3634,14 +3633,14 @@ static int ath10k_resume(struct ieee80211_hw *hw)
 
 	ret = ath10k_hif_resume(ar);
 	if (ret) {
-		ath10k_warn("could not resume hif (%d)\n", ret);
+		ath10k_warn("Could not resume hif: %d\n", ret);
 		ret = 1;
 		goto exit;
 	}
 
 	ret = ath10k_wmi_pdev_resume_target(ar);
 	if (ret) {
-		ath10k_warn("could not resume target (%d)\n", ret);
+		ath10k_warn("Could not resume target: %d\n", ret);
 		ret = 1;
 		goto exit;
 	}
@@ -4072,8 +4071,8 @@ static void ath10k_sta_rc_update(struct ieee80211_hw *hw,
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
@@ -4099,8 +4098,8 @@ static void ath10k_sta_rc_update(struct ieee80211_hw *hw,
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
@@ -4570,7 +4569,7 @@ int ath10k_mac_register(struct ath10k *ar)
 							     NL80211_DFS_UNSET);
 
 		if (!ar->dfs_detector)
-			ath10k_warn("dfs pattern detector init failed\n");
+			ath10k_warn("DFS pattern detector init failed\n");
 	}
 
 	ret = ath_regd_init(&ar->ath_common.regulatory, ar->hw->wiphy,

