Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:50306 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271Ab3IHO4L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Sep 2013 10:56:11 -0400
Subject: [PATCH 7/8] ath10k: clean mac.c debug messages
To: ath10k@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Sun, 08 Sep 2013 17:56:07 +0300
Message-ID: <20130908145607.3136.99173.stgit@localhost6.localdomain6> (sfid-20130908_165615_005240_82B2DC22)
In-Reply-To: <20130908145435.3136.49168.stgit@localhost6.localdomain6>
References: <20130908145435.3136.49168.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Just to unify with the rest of debug messages. Minimal functional changes,
only major ones are removal of the awkward "else" style in debug
messages.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/mac.c |  180 +++++++++++++++++----------------
 1 file changed, 92 insertions(+), 88 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 248248b..b8c81bb 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -604,7 +604,7 @@ static int ath10k_monitor_create(struct ath10k *ar)
 		goto vdev_fail;
 	}
 
-	ath10k_dbg(ATH10K_DBG_MAC, "Monitor interface created, vdev id: %d\n",
+	ath10k_dbg(ATH10K_DBG_MAC, "mac monitor vdev %d created\n",
 		   ar->monitor_vdev_id);
 
 	ar->monitor_present = true;
@@ -636,7 +636,7 @@ static int ath10k_monitor_destroy(struct ath10k *ar)
 	ar->free_vdev_map |= 1 << (ar->monitor_vdev_id);
 	ar->monitor_present = false;
 
-	ath10k_dbg(ATH10K_DBG_MAC, "Monitor interface destroyed, vdev id: %d\n",
+	ath10k_dbg(ATH10K_DBG_MAC, "mac monitor vdev %d deleted\n",
 		   ar->monitor_vdev_id);
 	return ret;
 }
@@ -665,7 +665,7 @@ static void ath10k_control_beaconing(struct ath10k_vif *arvif,
 			    arvif->vdev_id);
 		return;
 	}
-	ath10k_dbg(ATH10K_DBG_MAC, "VDEV: %d up\n", arvif->vdev_id);
+	ath10k_dbg(ATH10K_DBG_MAC, "mac vdev %d up\n", arvif->vdev_id);
 }
 
 static void ath10k_control_ibss(struct ath10k_vif *arvif,
@@ -749,14 +749,14 @@ static void ath10k_ps_iter(void *data, u8 *mac, struct ieee80211_vif *vif)
 		psmode = WMI_STA_PS_MODE_DISABLED;
 	}
 
+	ath10k_dbg(ATH10K_DBG_MAC, "mac vdev %d psmode %s\n",
+		   arvif->vdev_id, psmode ? "enable" : "disable");
+
 	ar_iter->ret = ath10k_wmi_set_psmode(ar_iter->ar, arvif->vdev_id,
 					     psmode);
 	if (ar_iter->ret)
 		ath10k_warn("Failed to set PS Mode: %d for VDEV: %d\n",
 			    psmode, arvif->vdev_id);
-	else
-		ath10k_dbg(ATH10K_DBG_MAC, "Set PS Mode: %d for VDEV: %d\n",
-			   psmode, arvif->vdev_id);
 }
 
 /**********************/
@@ -946,7 +946,8 @@ static void ath10k_peer_assoc_h_ht(struct ath10k *ar,
 	arg->peer_ht_rates.num_rates = n;
 	arg->peer_num_spatial_streams = max((n+7) / 8, 1);
 
-	ath10k_dbg(ATH10K_DBG_MAC, "mcs cnt %d nss %d\n",
+	ath10k_dbg(ATH10K_DBG_MAC, "mac ht peer %pM mcs cnt %d nss %d\n",
+		   arg->addr,
 		   arg->peer_ht_rates.num_rates,
 		   arg->peer_num_spatial_streams);
 }
@@ -966,7 +967,7 @@ static void ath10k_peer_assoc_h_qos_ap(struct ath10k *ar,
 		arg->peer_flags |= WMI_PEER_QOS;
 
 	if (sta->wme && sta->uapsd_queues) {
-		ath10k_dbg(ATH10K_DBG_MAC, "uapsd_queues: 0x%X, max_sp: %d\n",
+		ath10k_dbg(ATH10K_DBG_MAC, "mac uapsd_queues 0x%x max_sp %d\n",
 			   sta->uapsd_queues, sta->max_sp);
 
 		arg->peer_flags |= WMI_PEER_APSD;
@@ -1045,7 +1046,8 @@ static void ath10k_peer_assoc_h_vht(struct ath10k *ar,
 	arg->peer_vht_rates.tx_mcs_set =
 		__le16_to_cpu(vht_cap->vht_mcs.tx_mcs_map);
 
-	ath10k_dbg(ATH10K_DBG_MAC, "mac vht peer\n");
+	ath10k_dbg(ATH10K_DBG_MAC, "mac vht peer %pM max_mpdu %d flags 0x%x\n",
+		   sta->addr, arg->peer_max_mpdu, arg->peer_flags);
 }
 
 static void ath10k_peer_assoc_h_qos(struct ath10k *ar,
@@ -1102,6 +1104,9 @@ static void ath10k_peer_assoc_h_phymode(struct ath10k *ar,
 		break;
 	}
 
+	ath10k_dbg(ATH10K_DBG_MAC, "mac peer %pM phymode %d\n",
+		   sta->addr, phymode);
+
 	arg->peer_phymode = phymode;
 	WARN_ON(phymode == MODE_UNKNOWN);
 }
@@ -1159,15 +1164,15 @@ static void ath10k_bss_assoc(struct ieee80211_hw *hw,
 
 	rcu_read_unlock();
 
+	ath10k_dbg(ATH10K_DBG_MAC,
+		   "mac vdev %d up (associated) bssid %pM aid %d\n",
+		   arvif->vdev_id, bss_conf->bssid, bss_conf->aid);
+
 	ret = ath10k_wmi_vdev_up(ar, arvif->vdev_id, bss_conf->aid,
 				 bss_conf->bssid);
 	if (ret)
 		ath10k_warn("VDEV: %d up failed: ret %d\n",
 			    arvif->vdev_id, ret);
-	else
-		ath10k_dbg(ATH10K_DBG_MAC,
-			   "VDEV: %d associated, BSSID: %pM, AID: %d\n",
-			   arvif->vdev_id, bss_conf->bssid, bss_conf->aid);
 }
 
 /*
@@ -1188,10 +1193,11 @@ static void ath10k_bss_disassoc(struct ieee80211_hw *hw,
 	 * No idea why this happens, even though VDEV-DOWN is supposed
 	 * to be analogous to link down, so just stop the VDEV.
 	 */
+	ath10k_dbg(ATH10K_DBG_MAC, "mac vdev %d stop (disassociated\n",
+		   arvif->vdev_id);
+
+	/* FIXME: check return value */
 	ret = ath10k_vdev_stop(arvif);
-	if (!ret)
-		ath10k_dbg(ATH10K_DBG_MAC, "VDEV: %d stopped\n",
-			   arvif->vdev_id);
 
 	/*
 	 * If we don't call VDEV-DOWN after VDEV-STOP FW will remain active and
@@ -1200,10 +1206,10 @@ static void ath10k_bss_disassoc(struct ieee80211_hw *hw,
 	 * interfaces as it expects there is no rx when no interface is
 	 * running.
 	 */
+	ath10k_dbg(ATH10K_DBG_MAC, "mac vdev %d down\n", arvif->vdev_id);
+
+	/* FIXME: why don't we print error if wmi call fails? */
 	ret = ath10k_wmi_vdev_down(ar, arvif->vdev_id);
-	if (ret)
-		ath10k_dbg(ATH10K_DBG_MAC, "VDEV: %d ath10k_wmi_vdev_down failed (%d)\n",
-			   arvif->vdev_id, ret);
 
 	ath10k_wmi_flush_tx(ar);
 
@@ -1330,8 +1336,8 @@ static int ath10k_update_channel_list(struct ath10k *ar)
 				continue;
 
 			ath10k_dbg(ATH10K_DBG_WMI,
-				   "%s: [%zd/%d] freq %d maxpower %d regpower %d antenna %d mode %d\n",
-				   __func__, ch - arg.channels, arg.n_channels,
+				   "mac channel [%zd/%d] freq %d maxpower %d regpower %d antenna %d mode %d\n",
+				    ch - arg.channels, arg.n_channels,
 				   ch->freq, ch->max_power, ch->max_reg_power,
 				   ch->max_antenna_gain, ch->mode);
 
@@ -1431,7 +1437,8 @@ static void ath10k_tx_h_update_wep_key(struct sk_buff *skb)
 	if (key->keyidx == arvif->def_wep_key_index)
 		return;
 
-	ath10k_dbg(ATH10K_DBG_MAC, "new wep keyidx will be %d\n", key->keyidx);
+	ath10k_dbg(ATH10K_DBG_MAC, "mac vdev %d keyidx %d\n",
+		   arvif->vdev_id, key->keyidx);
 
 	ret = ath10k_wmi_vdev_set_param(ar, arvif->vdev_id,
 					WMI_VDEV_PARAM_DEF_KEYID,
@@ -1534,7 +1541,7 @@ void ath10k_offchan_tx_work(struct work_struct *work)
 
 		mutex_lock(&ar->conf_mutex);
 
-		ath10k_dbg(ATH10K_DBG_MAC, "processing offchannel skb %p\n",
+		ath10k_dbg(ATH10K_DBG_MAC, "mac offchannel skb %p\n",
 			   skb);
 
 		hdr = (struct ieee80211_hdr *)skb->data;
@@ -1546,6 +1553,7 @@ void ath10k_offchan_tx_work(struct work_struct *work)
 		spin_unlock_bh(&ar->data_lock);
 
 		if (peer)
+			/* FIXME: should this use ath10k_warn()? */
 			ath10k_dbg(ATH10K_DBG_MAC, "peer %pM on vdev %d already present\n",
 				   peer_addr, vdev_id);
 
@@ -1886,7 +1894,7 @@ static int ath10k_config(struct ieee80211_hw *hw, u32 changed)
 	mutex_lock(&ar->conf_mutex);
 
 	if (changed & IEEE80211_CONF_CHANGE_CHANNEL) {
-		ath10k_dbg(ATH10K_DBG_MAC, "Config channel %d mhz\n",
+		ath10k_dbg(ATH10K_DBG_MAC, "mac config channel %d mhz\n",
 			   conf->chandef.chan->center_freq);
 		spin_lock_bh(&ar->data_lock);
 		ar->rx_channel = conf->chandef.chan;
@@ -1975,7 +1983,7 @@ static int ath10k_add_interface(struct ieee80211_hw *hw,
 		break;
 	}
 
-	ath10k_dbg(ATH10K_DBG_MAC, "Add interface: id %d type %d subtype %d\n",
+	ath10k_dbg(ATH10K_DBG_MAC, "mac vdev create %d (add interface) type %d subtype %d\n",
 		   arvif->vdev_id, arvif->vdev_type, arvif->vdev_subtype);
 
 	ret = ath10k_wmi_vdev_create(ar, arvif->vdev_id, arvif->vdev_type,
@@ -2054,8 +2062,6 @@ static void ath10k_remove_interface(struct ieee80211_hw *hw,
 
 	mutex_lock(&ar->conf_mutex);
 
-	ath10k_dbg(ATH10K_DBG_MAC, "Remove interface: id %d\n", arvif->vdev_id);
-
 	ar->free_vdev_map |= 1 << (arvif->vdev_id);
 
 	if (arvif->vdev_type == WMI_VDEV_TYPE_AP) {
@@ -2066,6 +2072,9 @@ static void ath10k_remove_interface(struct ieee80211_hw *hw,
 		kfree(arvif->u.ap.noa_data);
 	}
 
+	ath10k_dbg(ATH10K_DBG_MAC, "mac vdev delete %d (remove interface)\n",
+		   arvif->vdev_id);
+
 	ret = ath10k_wmi_vdev_delete(ar, arvif->vdev_id);
 	if (ret)
 		ath10k_warn("WMI vdev delete failed: %d\n", ret);
@@ -2107,18 +2116,20 @@ static void ath10k_configure_filter(struct ieee80211_hw *hw,
 
 	if ((ar->filter_flags & FIF_PROMISC_IN_BSS) &&
 	    !ar->monitor_enabled) {
+		ath10k_dbg(ATH10K_DBG_MAC, "mac monitor %d start\n",
+			   ar->monitor_vdev_id);
+
 		ret = ath10k_monitor_start(ar, ar->monitor_vdev_id);
 		if (ret)
 			ath10k_warn("Unable to start monitor mode\n");
-		else
-			ath10k_dbg(ATH10K_DBG_MAC, "Monitor mode started\n");
 	} else if (!(ar->filter_flags & FIF_PROMISC_IN_BSS) &&
 		   ar->monitor_enabled) {
+		ath10k_dbg(ATH10K_DBG_MAC, "mac monitor %d stop\n",
+			   ar->monitor_vdev_id);
+
 		ret = ath10k_monitor_stop(ar);
 		if (ret)
 			ath10k_warn("Unable to stop monitor mode\n");
-		else
-			ath10k_dbg(ATH10K_DBG_MAC, "Monitor mode stopped\n");
 	}
 
 	mutex_unlock(&ar->conf_mutex);
@@ -2143,41 +2154,41 @@ static void ath10k_bss_info_changed(struct ieee80211_hw *hw,
 		ret = ath10k_wmi_vdev_set_param(ar, arvif->vdev_id,
 						WMI_VDEV_PARAM_BEACON_INTERVAL,
 						arvif->beacon_interval);
+		ath10k_dbg(ATH10K_DBG_MAC,
+			   "mac vdev %d beacon_interval %d\n",
+			   arvif->vdev_id, arvif->beacon_interval);
+
 		if (ret)
 			ath10k_warn("Failed to set beacon interval for VDEV: %d\n",
 				    arvif->vdev_id);
-		else
-			ath10k_dbg(ATH10K_DBG_MAC,
-				   "Beacon interval: %d set for VDEV: %d\n",
-				   arvif->beacon_interval, arvif->vdev_id);
 	}
 
 	if (changed & BSS_CHANGED_BEACON) {
+		ath10k_dbg(ATH10K_DBG_MAC,
+			   "vdev %d set beacon tx mode to staggered\n",
+			   arvif->vdev_id);
+
 		ret = ath10k_wmi_pdev_set_param(ar,
 						WMI_PDEV_PARAM_BEACON_TX_MODE,
 						WMI_BEACON_STAGGERED_MODE);
 		if (ret)
 			ath10k_warn("Failed to set beacon mode for VDEV: %d\n",
 				    arvif->vdev_id);
-		else
-			ath10k_dbg(ATH10K_DBG_MAC,
-				   "Set staggered beacon mode for VDEV: %d\n",
-				   arvif->vdev_id);
 	}
 
 	if (changed & BSS_CHANGED_BEACON_INFO) {
 		arvif->dtim_period = info->dtim_period;
 
+		ath10k_dbg(ATH10K_DBG_MAC,
+			   "mac vdev %d dtim_period %d\n",
+			   arvif->vdev_id, arvif->dtim_period);
+
 		ret = ath10k_wmi_vdev_set_param(ar, arvif->vdev_id,
 						WMI_VDEV_PARAM_DTIM_PERIOD,
 						arvif->dtim_period);
 		if (ret)
 			ath10k_warn("Failed to set dtim period for VDEV: %d\n",
 				    arvif->vdev_id);
-		else
-			ath10k_dbg(ATH10K_DBG_MAC,
-				   "Set dtim period: %d for VDEV: %d\n",
-				   arvif->dtim_period, arvif->vdev_id);
 	}
 
 	if (changed & BSS_CHANGED_SSID &&
@@ -2190,16 +2201,15 @@ static void ath10k_bss_info_changed(struct ieee80211_hw *hw,
 
 	if (changed & BSS_CHANGED_BSSID) {
 		if (!is_zero_ether_addr(info->bssid)) {
+			ath10k_dbg(ATH10K_DBG_MAC,
+				   "mac vdev %d create peer %pM\n",
+				   arvif->vdev_id, info->bssid);
+
 			ret = ath10k_peer_create(ar, arvif->vdev_id,
 						 info->bssid);
 			if (ret)
 				ath10k_warn("Failed to add peer: %pM for VDEV: %d\n",
 					    info->bssid, arvif->vdev_id);
-			else
-				ath10k_dbg(ATH10K_DBG_MAC,
-					   "Added peer: %pM for VDEV: %d\n",
-					   info->bssid, arvif->vdev_id);
-
 
 			if (vif->type == NL80211_IFTYPE_STATION) {
 				/*
@@ -2209,11 +2219,12 @@ static void ath10k_bss_info_changed(struct ieee80211_hw *hw,
 				memcpy(arvif->u.sta.bssid, info->bssid,
 				       ETH_ALEN);
 
+				ath10k_dbg(ATH10K_DBG_MAC,
+					   "mac vdev %d start %pM\n",
+					   arvif->vdev_id, info->bssid);
+
+				/* FIXME: check return value */
 				ret = ath10k_vdev_start(arvif);
-				if (!ret)
-					ath10k_dbg(ATH10K_DBG_MAC,
-						   "VDEV: %d started with BSSID: %pM\n",
-						   arvif->vdev_id, info->bssid);
 			}
 
 			/*
@@ -2237,16 +2248,15 @@ static void ath10k_bss_info_changed(struct ieee80211_hw *hw,
 		else
 			cts_prot = 0;
 
+		ath10k_dbg(ATH10K_DBG_MAC, "mac vdev %d cts_prot %d\n",
+			   arvif->vdev_id, cts_prot);
+
 		ret = ath10k_wmi_vdev_set_param(ar, arvif->vdev_id,
 						WMI_VDEV_PARAM_ENABLE_RTSCTS,
 						cts_prot);
 		if (ret)
 			ath10k_warn("Failed to set CTS prot for VDEV: %d\n",
 				    arvif->vdev_id);
-		else
-			ath10k_dbg(ATH10K_DBG_MAC,
-				   "Set CTS prot: %d for VDEV: %d\n",
-				   cts_prot, arvif->vdev_id);
 	}
 
 	if (changed & BSS_CHANGED_ERP_SLOT) {
@@ -2257,16 +2267,15 @@ static void ath10k_bss_info_changed(struct ieee80211_hw *hw,
 		else
 			slottime = WMI_VDEV_SLOT_TIME_LONG; /* 20us */
 
+		ath10k_dbg(ATH10K_DBG_MAC, "mac vdev %d slot_time %d\n",
+			   arvif->vdev_id, slottime);
+
 		ret = ath10k_wmi_vdev_set_param(ar, arvif->vdev_id,
 						WMI_VDEV_PARAM_SLOT_TIME,
 						slottime);
 		if (ret)
 			ath10k_warn("Failed to set erp slot for VDEV: %d\n",
 				    arvif->vdev_id);
-		else
-			ath10k_dbg(ATH10K_DBG_MAC,
-				   "Set slottime: %d for VDEV: %d\n",
-				   slottime, arvif->vdev_id);
 	}
 
 	if (changed & BSS_CHANGED_ERP_PREAMBLE) {
@@ -2276,16 +2285,16 @@ static void ath10k_bss_info_changed(struct ieee80211_hw *hw,
 		else
 			preamble = WMI_VDEV_PREAMBLE_LONG;
 
+		ath10k_dbg(ATH10K_DBG_MAC,
+			   "mac vdev %d preamble %dn",
+			   arvif->vdev_id, preamble);
+
 		ret = ath10k_wmi_vdev_set_param(ar, arvif->vdev_id,
 						WMI_VDEV_PARAM_PREAMBLE,
 						preamble);
 		if (ret)
 			ath10k_warn("Failed to set preamble for VDEV: %d\n",
 				    arvif->vdev_id);
-		else
-			ath10k_dbg(ATH10K_DBG_MAC,
-				   "Set preamble: %d for VDEV: %d\n",
-				   preamble, arvif->vdev_id);
 	}
 
 	if (changed & BSS_CHANGED_ASSOC) {
@@ -2476,27 +2485,26 @@ static int ath10k_sta_state(struct ieee80211_hw *hw,
 		/*
 		 * New station addition.
 		 */
+		ath10k_dbg(ATH10K_DBG_MAC,
+			   "mac vdev %d peer create %pM (new sta)\n",
+			   arvif->vdev_id, sta->addr);
+
 		ret = ath10k_peer_create(ar, arvif->vdev_id, sta->addr);
 		if (ret)
 			ath10k_warn("Failed to add peer: %pM for VDEV: %d\n",
 				    sta->addr, arvif->vdev_id);
-		else
-			ath10k_dbg(ATH10K_DBG_MAC,
-				   "Added peer: %pM for VDEV: %d\n",
-				   sta->addr, arvif->vdev_id);
 	} else if ((old_state == IEEE80211_STA_NONE &&
 		    new_state == IEEE80211_STA_NOTEXIST)) {
 		/*
 		 * Existing station deletion.
 		 */
+		ath10k_dbg(ATH10K_DBG_MAC,
+			   "mac vdev %d peer delete %pM (sta gone)\n",
+			   arvif->vdev_id, sta->addr);
 		ret = ath10k_peer_delete(ar, arvif->vdev_id, sta->addr);
 		if (ret)
 			ath10k_warn("Failed to delete peer: %pM for VDEV: %d\n",
 				    sta->addr, arvif->vdev_id);
-		else
-			ath10k_dbg(ATH10K_DBG_MAC,
-				   "Removed peer: %pM for VDEV: %d\n",
-				   sta->addr, arvif->vdev_id);
 
 		if (vif->type == NL80211_IFTYPE_STATION)
 			ath10k_bss_disassoc(hw, vif);
@@ -2507,14 +2515,13 @@ static int ath10k_sta_state(struct ieee80211_hw *hw,
 		/*
 		 * New association.
 		 */
+		ath10k_dbg(ATH10K_DBG_MAC, "mac sta %pM associated\n",
+			   sta->addr);
+
 		ret = ath10k_station_assoc(ar, arvif, sta);
 		if (ret)
 			ath10k_warn("Failed to associate station: %pM\n",
 				    sta->addr);
-		else
-			ath10k_dbg(ATH10K_DBG_MAC,
-				   "Station %pM moved to assoc state\n",
-				   sta->addr);
 	} else if (old_state == IEEE80211_STA_ASSOC &&
 		   new_state == IEEE80211_STA_AUTH &&
 		   (vif->type == NL80211_IFTYPE_AP ||
@@ -2522,14 +2529,13 @@ static int ath10k_sta_state(struct ieee80211_hw *hw,
 		/*
 		 * Disassociation.
 		 */
+		ath10k_dbg(ATH10K_DBG_MAC, "mac sta %pM disassociated\n",
+			   sta->addr);
+
 		ret = ath10k_station_disassoc(ar, arvif, sta);
 		if (ret)
 			ath10k_warn("Failed to disassociate station: %pM\n",
 				    sta->addr);
-		else
-			ath10k_dbg(ATH10K_DBG_MAC,
-				   "Station %pM moved to disassociated state\n",
-				   sta->addr);
 	}
 
 	mutex_unlock(&ar->conf_mutex);
@@ -2749,14 +2755,13 @@ static void ath10k_set_rts_iter(void *data, u8 *mac, struct ieee80211_vif *vif)
 	if (ar_iter->ar->state == ATH10K_STATE_RESTARTED)
 		return;
 
+	ath10k_dbg(ATH10K_DBG_MAC, "mac vdev %d rts_threshold %d\n",
+		   arvif->vdev_id, rts);
+
 	ar_iter->ret = ath10k_mac_set_rts(arvif, rts);
 	if (ar_iter->ret)
 		ath10k_warn("Failed to set RTS threshold for VDEV: %d\n",
 			    arvif->vdev_id);
-	else
-		ath10k_dbg(ATH10K_DBG_MAC,
-			   "Set RTS threshold: %d for VDEV: %d\n",
-			   rts, arvif->vdev_id);
 }
 
 static int ath10k_set_rts_threshold(struct ieee80211_hw *hw, u32 value)
@@ -2791,14 +2796,13 @@ static void ath10k_set_frag_iter(void *data, u8 *mac, struct ieee80211_vif *vif)
 	if (ar_iter->ar->state == ATH10K_STATE_RESTARTED)
 		return;
 
+	ath10k_dbg(ATH10K_DBG_MAC, "mac vdev %d fragmentation_threshold %d\n",
+		   arvif->vdev_id, frag);
+
 	ar_iter->ret = ath10k_mac_set_frag(arvif, frag);
 	if (ar_iter->ret)
 		ath10k_warn("Failed to set frag threshold for VDEV: %d\n",
 			    arvif->vdev_id);
-	else
-		ath10k_dbg(ATH10K_DBG_MAC,
-			   "Set frag threshold: %d for VDEV: %d\n",
-			   frag, arvif->vdev_id);
 }
 
 static int ath10k_set_frag_threshold(struct ieee80211_hw *hw, u32 value)

