Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:33952 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754028AbaJJK5d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Oct 2014 06:57:33 -0400
Received: by mail-wg0-f49.google.com with SMTP id x12so3579696wgg.20
        for <linux-wireless@vger.kernel.org>; Fri, 10 Oct 2014 03:57:32 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 3/3] ath10k: clean up sta auth/assoc code
Date: Fri, 10 Oct 2014 12:46:17 +0200
Message-Id: <1412937977-5859-4-git-send-email-michal.kazior@tieto.com> (sfid-20141010_125739_533007_348B58B7)
In-Reply-To: <1412937977-5859-1-git-send-email-michal.kazior@tieto.com>
References: <1412937977-5859-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The code can be symmetrical so make it so. This
makes it easier to understand and work with.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 121 ++++++++++++----------------------
 1 file changed, 42 insertions(+), 79 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 266b740..07900c4 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -1492,6 +1492,9 @@ static void ath10k_bss_assoc(struct ieee80211_hw *hw,
 
 	lockdep_assert_held(&ar->conf_mutex);
 
+	ath10k_dbg(ar, ATH10K_DBG_MAC, "mac vdev %i assoc bssid %pM aid %d\n",
+		   arvif->vdev_id, arvif->bssid, arvif->aid);
+
 	rcu_read_lock();
 
 	ap_sta = ieee80211_find_sta(vif, bss_conf->bssid);
@@ -1534,6 +1537,8 @@ static void ath10k_bss_assoc(struct ieee80211_hw *hw,
 		   "mac vdev %d up (associated) bssid %pM aid %d\n",
 		   arvif->vdev_id, bss_conf->bssid, bss_conf->aid);
 
+	WARN_ON(arvif->is_up);
+
 	arvif->aid = bss_conf->aid;
 	ether_addr_copy(arvif->bssid, bss_conf->bssid);
 
@@ -1547,9 +1552,6 @@ static void ath10k_bss_assoc(struct ieee80211_hw *hw,
 	arvif->is_up = true;
 }
 
-/*
- * FIXME: flush TIDs
- */
 static void ath10k_bss_disassoc(struct ieee80211_hw *hw,
 				struct ieee80211_vif *vif)
 {
@@ -1559,33 +1561,15 @@ static void ath10k_bss_disassoc(struct ieee80211_hw *hw,
 
 	lockdep_assert_held(&ar->conf_mutex);
 
-	/*
-	 * For some reason, calling VDEV-DOWN before VDEV-STOP
-	 * makes the FW to send frames via HTT after disassociation.
-	 * No idea why this happens, even though VDEV-DOWN is supposed
-	 * to be analogous to link down, so just stop the VDEV.
-	 */
-	ath10k_dbg(ar, ATH10K_DBG_MAC, "mac vdev %d stop (disassociated\n",
-		   arvif->vdev_id);
-
-	/* FIXME: check return value */
-	ret = ath10k_vdev_stop(arvif);
-
-	/*
-	 * If we don't call VDEV-DOWN after VDEV-STOP FW will remain active and
-	 * report beacons from previously associated network through HTT.
-	 * This in turn would spam mac80211 WARN_ON if we bring down all
-	 * interfaces as it expects there is no rx when no interface is
-	 * running.
-	 */
-	ath10k_dbg(ar, ATH10K_DBG_MAC, "mac vdev %d down\n", arvif->vdev_id);
+	ath10k_dbg(ar, ATH10K_DBG_MAC, "mac vdev %i disassoc bssid %pM\n",
+		   arvif->vdev_id, arvif->bssid);
 
-	/* FIXME: why don't we print error if wmi call fails? */
 	ret = ath10k_wmi_vdev_down(ar, arvif->vdev_id);
+	if (ret)
+		ath10k_warn(ar, "faield to down vdev %i: %d\n",
+			    arvif->vdev_id, ret);
 
 	arvif->def_wep_key_idx = 0;
-
-	arvif->is_started = false;
 	arvif->is_up = false;
 }
 
@@ -3116,54 +3100,8 @@ static void ath10k_bss_info_changed(struct ieee80211_hw *hw,
 		arvif->u.ap.hidden_ssid = info->hidden_ssid;
 	}
 
-	/*
-	 * Firmware manages AP self-peer internally so make sure to not create
-	 * it in driver. Otherwise AP self-peer deletion may timeout later.
-	 */
-	if (changed & BSS_CHANGED_BSSID &&
-	    vif->type != NL80211_IFTYPE_AP) {
-		if (!is_zero_ether_addr(info->bssid)) {
-			if (vif->type == NL80211_IFTYPE_STATION) {
-				ath10k_dbg(ar, ATH10K_DBG_MAC,
-					   "mac vdev %d create peer %pM\n",
-					   arvif->vdev_id, info->bssid);
-
-				ret = ath10k_peer_create(ar, arvif->vdev_id,
-							 info->bssid);
-				if (ret)
-					ath10k_warn(ar, "failed to add peer %pM for vdev %d when changing bssid: %i\n",
-						    info->bssid, arvif->vdev_id,
-						    ret);
-				/*
-				 * this is never erased as we it for crypto key
-				 * clearing; this is FW requirement
-				 */
-				ether_addr_copy(arvif->bssid, info->bssid);
-
-				ath10k_dbg(ar, ATH10K_DBG_MAC,
-					   "mac vdev %d start %pM\n",
-					   arvif->vdev_id, info->bssid);
-
-				ret = ath10k_vdev_start(arvif);
-				if (ret) {
-					ath10k_warn(ar, "failed to start vdev %i: %d\n",
-						    arvif->vdev_id, ret);
-					goto exit;
-				}
-
-				arvif->is_started = true;
-			}
-
-			/*
-			 * Mac80211 does not keep IBSS bssid when leaving IBSS,
-			 * so driver need to store it. It is needed when leaving
-			 * IBSS in order to remove BSSID peer.
-			 */
-			if (vif->type == NL80211_IFTYPE_ADHOC)
-				memcpy(arvif->bssid, info->bssid,
-				       ETH_ALEN);
-		}
-	}
+	if (changed & BSS_CHANGED_BSSID && !is_zero_ether_addr(info->bssid))
+		ether_addr_copy(arvif->bssid, info->bssid);
 
 	if (changed & BSS_CHANGED_BEACON_ENABLED)
 		ath10k_control_beaconing(arvif, info);
@@ -3225,10 +3163,11 @@ static void ath10k_bss_info_changed(struct ieee80211_hw *hw,
 				ath10k_monitor_stop(ar);
 			ath10k_bss_assoc(hw, vif, info);
 			ath10k_monitor_recalc(ar);
+		} else {
+			ath10k_bss_disassoc(hw, vif);
 		}
 	}
 
-exit:
 	mutex_unlock(&ar->conf_mutex);
 }
 
@@ -3537,8 +3476,7 @@ static int ath10k_sta_state(struct ieee80211_hw *hw,
 	mutex_lock(&ar->conf_mutex);
 
 	if (old_state == IEEE80211_STA_NOTEXIST &&
-	    new_state == IEEE80211_STA_NONE &&
-	    vif->type != NL80211_IFTYPE_STATION) {
+	    new_state == IEEE80211_STA_NONE) {
 		/*
 		 * New station addition.
 		 */
@@ -3562,6 +3500,21 @@ static int ath10k_sta_state(struct ieee80211_hw *hw,
 		if (ret)
 			ath10k_warn(ar, "failed to add peer %pM for vdev %d when adding a new sta: %i\n",
 				    sta->addr, arvif->vdev_id, ret);
+
+		if (vif->type == NL80211_IFTYPE_STATION) {
+			WARN_ON(arvif->is_started);
+
+			ret = ath10k_vdev_start(arvif);
+			if (ret) {
+				ath10k_warn(ar, "failed to start vdev %i: %d\n",
+					    arvif->vdev_id, ret);
+				WARN_ON(ath10k_peer_delete(ar, arvif->vdev_id,
+							   sta->addr));
+				goto exit;
+			}
+
+			arvif->is_started = true;
+		}
 	} else if ((old_state == IEEE80211_STA_NONE &&
 		    new_state == IEEE80211_STA_NOTEXIST)) {
 		/*
@@ -3570,13 +3523,23 @@ static int ath10k_sta_state(struct ieee80211_hw *hw,
 		ath10k_dbg(ar, ATH10K_DBG_MAC,
 			   "mac vdev %d peer delete %pM (sta gone)\n",
 			   arvif->vdev_id, sta->addr);
+
+		if (vif->type == NL80211_IFTYPE_STATION) {
+			WARN_ON(!arvif->is_started);
+
+			ret = ath10k_vdev_stop(arvif);
+			if (ret)
+				ath10k_warn(ar, "failed to stop vdev %i: %d\n",
+					    arvif->vdev_id, ret);
+
+			arvif->is_started = false;
+		}
+
 		ret = ath10k_peer_delete(ar, arvif->vdev_id, sta->addr);
 		if (ret)
 			ath10k_warn(ar, "failed to delete peer %pM for vdev %d: %i\n",
 				    sta->addr, arvif->vdev_id, ret);
 
-		if (vif->type == NL80211_IFTYPE_STATION)
-			ath10k_bss_disassoc(hw, vif);
 	} else if (old_state == IEEE80211_STA_AUTH &&
 		   new_state == IEEE80211_STA_ASSOC &&
 		   (vif->type == NL80211_IFTYPE_AP ||
-- 
1.8.5.3

