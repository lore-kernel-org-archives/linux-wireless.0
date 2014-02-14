Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:4293 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059AbaBNGGS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Feb 2014 01:06:18 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <greearb@candelatech.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/2] ath10k:  add vdev-id, return code to error codes
References: <1392318562-32440-1-git-send-email-greearb@candelatech.com>
Date: Fri, 14 Feb 2014 08:06:13 +0200
In-Reply-To: <1392318562-32440-1-git-send-email-greearb@candelatech.com>
	(greearb@candelatech.com's message of "Thu, 13 Feb 2014 11:09:21
	-0800")
Message-ID: <87bnya6xey.fsf@kamboji.qca.qualcomm.com> (sfid-20140214_070622_549343_5B7F4EE3)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

greearb@candelatech.com writes:

> From: Ben Greear <greearb@candelatech.com>
>
> When using multiple vdevs (stations, aps, etc), it is
> nice to be able to associate log messages with specific
> interfaces.  So, add vdev-id to most logging messages.
> Add return code as well, where it was missing.
>
> Signed-off-by: Ben Greear <greearb@candelatech.com>

I did some changes just to have consistent style for warning messages,
see my incremental diff patch below. Let me know if you agree with my
changes, the full patch is in ath-next-test branch.

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 7a593e0..ead6f4d 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -878,7 +878,7 @@ static void ath10k_control_beaconing(struct ath10k_vif *arvif,
 	ret = ath10k_wmi_vdev_up(arvif->ar, arvif->vdev_id, arvif->aid,
 				 arvif->bssid);
 	if (ret) {
-		ath10k_warn("Failed to bring up VDEV: %d ret %i\n",
+		ath10k_warn("Failed to bring up vdev %d: %i\n",
 			    arvif->vdev_id, ret);
 		ath10k_vdev_stop(arvif);
 		return;
@@ -959,7 +959,7 @@ static int ath10k_mac_vif_setup_ps(struct ath10k_vif *arvif)
 		ret = ath10k_wmi_set_sta_ps_param(ar, arvif->vdev_id, param,
 						  conf->dynamic_ps_timeout);
 		if (ret) {
-			ath10k_warn("Failed to set inactivity time for VDEV: %d ret %i\n",
+			ath10k_warn("Failed to set inactivity time for vdev %d: %i\n",
 				    arvif->vdev_id, ret);
 			return ret;
 		}
@@ -1212,7 +1212,7 @@ static int ath10k_peer_assoc_qos_ap(struct ath10k *ar,
 						 WMI_AP_PS_PEER_PARAM_UAPSD,
 						 uapsd);
 		if (ret) {
-			ath10k_warn("failed to set ap ps peer param uapsd, vdev %i: %d\n",
+			ath10k_warn("failed to set ap ps peer param uapsd for vdev %i: %d\n",
 				    arvif->vdev_id, ret);
 			return ret;
 		}
@@ -1222,7 +1222,7 @@ static int ath10k_peer_assoc_qos_ap(struct ath10k *ar,
 						 WMI_AP_PS_PEER_PARAM_MAX_SP,
 						 max_sp);
 		if (ret) {
-			ath10k_warn("failed to set ap ps peer param max sp, vdev %i: %d\n",
+			ath10k_warn("failed to set ap ps peer param max sp for vdev %i: %d\n",
 				    arvif->vdev_id, ret);
 			return ret;
 		}
@@ -1234,7 +1234,7 @@ static int ath10k_peer_assoc_qos_ap(struct ath10k *ar,
 		ret = ath10k_wmi_set_ap_ps_param(ar, arvif->vdev_id, sta->addr,
 					WMI_AP_PS_PEER_PARAM_AGEOUT_TIME, 10);
 		if (ret) {
-			ath10k_warn("failed to set ap ps peer param ageout time, vdev %i: %d\n",
+			ath10k_warn("failed to set ap ps peer param ageout time for vdev %i: %d\n",
 				    arvif->vdev_id, ret);
 			return ret;
 		}
@@ -1542,20 +1542,20 @@ static int ath10k_station_assoc(struct ath10k *ar, struct ath10k_vif *arvif,
 
 	ret = ath10k_setup_peer_smps(ar, arvif, sta->addr, &sta->ht_cap);
 	if (ret) {
-		ath10k_warn("failed to setup peer SMPS: %d\n", ret);
+		ath10k_warn("failed to setup peer SMPS for vdev: %d\n", ret);
 		return ret;
 	}
 
 	ret = ath10k_install_peer_wep_keys(arvif, sta->addr);
 	if (ret) {
-		ath10k_warn("could not install peer wep keys, vdev %i (%d)\n",
+		ath10k_warn("could not install peer wep keys for vdev %i: %d\n",
 			    arvif->vdev_id, ret);
 		return ret;
 	}
 
 	ret = ath10k_peer_assoc_qos_ap(ar, arvif, sta);
 	if (ret) {
-		ath10k_warn("could not set qos params for STA %pM, vdev %i %d\n",
+		ath10k_warn("could not set qos params for STA %pM for vdev %i: %d\n",
 			    sta->addr, arvif->vdev_id, ret);
 		return ret;
 	}
@@ -1572,7 +1572,7 @@ static int ath10k_station_disassoc(struct ath10k *ar, struct ath10k_vif *arvif,
 
 	ret = ath10k_clear_peer_keys(arvif, sta->addr);
 	if (ret) {
-		ath10k_warn("could not clear all peer wep keys, vdev %i (%d)\n",
+		ath10k_warn("could not clear all peer wep keys for vdev %i: %d\n",
 			    arvif->vdev_id, ret);
 		return ret;
 	}
@@ -2775,7 +2775,7 @@ static void ath10k_bss_info_changed(struct ieee80211_hw *hw,
 			   arvif->vdev_id, arvif->beacon_interval);
 
 		if (ret)
-			ath10k_warn("Failed to set beacon interval for VDEV %d: %i\n",
+			ath10k_warn("Failed to set beacon interval for vdev %d: %i\n",
 				    arvif->vdev_id, ret);
 	}
 
@@ -2788,7 +2788,7 @@ static void ath10k_bss_info_changed(struct ieee80211_hw *hw,
 		ret = ath10k_wmi_pdev_set_param(ar, pdev_param,
 						WMI_BEACON_STAGGERED_MODE);
 		if (ret)
-			ath10k_warn("Failed to set beacon mode for VDEV %d: %i\n",
+			ath10k_warn("Failed to set beacon mode for vdev %d: %i\n",
 				    arvif->vdev_id, ret);
 	}
 
@@ -2803,7 +2803,7 @@ static void ath10k_bss_info_changed(struct ieee80211_hw *hw,
 		ret = ath10k_wmi_vdev_set_param(ar, arvif->vdev_id, vdev_param,
 						arvif->dtim_period);
 		if (ret)
-			ath10k_warn("Failed to set dtim period for VDEV %d: %i\n",
+			ath10k_warn("Failed to set dtim period for vdev %d: %i\n",
 				    arvif->vdev_id, ret);
 	}
 
@@ -2876,7 +2876,7 @@ static void ath10k_bss_info_changed(struct ieee80211_hw *hw,
 		ret = ath10k_wmi_vdev_set_param(ar, arvif->vdev_id, vdev_param,
 						cts_prot);
 		if (ret)
-			ath10k_warn("Failed to set CTS prot for VDEV: %d ret %i\n",
+			ath10k_warn("Failed to set CTS prot for vdev %d: %i\n",
 				    arvif->vdev_id, ret);
 	}
 
@@ -2895,7 +2895,7 @@ static void ath10k_bss_info_changed(struct ieee80211_hw *hw,
 		ret = ath10k_wmi_vdev_set_param(ar, arvif->vdev_id, vdev_param,
 						slottime);
 		if (ret)
-			ath10k_warn("Failed to set erp slot for VDEV: %d ret %i\n",
+			ath10k_warn("Failed to set erp slot for vdev %d: %i\n",
 				    arvif->vdev_id, ret);
 	}
 
@@ -2914,7 +2914,7 @@ static void ath10k_bss_info_changed(struct ieee80211_hw *hw,
 		ret = ath10k_wmi_vdev_set_param(ar, arvif->vdev_id, vdev_param,
 						preamble);
 		if (ret)
-			ath10k_warn("Failed to set preamble for VDEV: %d ret %i\n",
+			ath10k_warn("Failed to set preamble for vdev %d: %i\n",
 				    arvif->vdev_id, ret);
 	}
 
@@ -3107,7 +3107,7 @@ static int ath10k_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 
 	ret = ath10k_install_key(arvif, key, cmd, peer_addr);
 	if (ret) {
-		ath10k_warn("ath10k_install_key failed for vdev %i peer %pM (%d)\n",
+		ath10k_warn("key installation failed for vdev %i peer %pM: %d\n",
 			    arvif->vdev_id, peer_addr, ret);
 		goto exit;
 	}
@@ -3252,7 +3252,7 @@ static int ath10k_sta_state(struct ieee80211_hw *hw,
 			   arvif->vdev_id, sta->addr);
 		ret = ath10k_peer_delete(ar, arvif->vdev_id, sta->addr);
 		if (ret)
-			ath10k_warn("Failed to delete peer: %pM for VDEV: %d ret %i\n",
+			ath10k_warn("Failed to delete peer %pM for vdev %d: %i\n",
 				    sta->addr, arvif->vdev_id, ret);
 
 		if (vif->type == NL80211_IFTYPE_STATION)
@@ -3269,7 +3269,7 @@ static int ath10k_sta_state(struct ieee80211_hw *hw,
 
 		ret = ath10k_station_assoc(ar, arvif, sta);
 		if (ret)
-			ath10k_warn("Failed to associate station: %pM vdev %i ret %i\n",
+			ath10k_warn("Failed to associate station %pM for vdev %i: %i\n",
 				    sta->addr, arvif->vdev_id, ret);
 	} else if (old_state == IEEE80211_STA_ASSOC &&
 		   new_state == IEEE80211_STA_AUTH &&
@@ -4390,7 +4390,7 @@ struct ath10k_vif *ath10k_get_arvif(struct ath10k *ar, u32 vdev_id)
 						   ath10k_get_arvif_iter,
 						   &arvif_iter);
 	if (!arvif_iter.arvif) {
-		ath10k_warn("No VIF found for VDEV: %d\n", vdev_id);
+		ath10k_warn("No VIF found for vdev %d\n", vdev_id);
 		return NULL;
 	}
 
@@ -4529,7 +4529,7 @@ int ath10k_mac_register(struct ath10k *ar)
 	ret = ath_regd_init(&ar->ath_common.regulatory, ar->hw->wiphy,
 			    ath10k_reg_notifier);
 	if (ret) {
-		ath10k_err("Regulatory initialization failed, ret %i\n", ret);
+		ath10k_err("Regulatory initialization failed: %i\n", ret);
 		goto err_free;
 	}
 


-- 
Kalle Valo
