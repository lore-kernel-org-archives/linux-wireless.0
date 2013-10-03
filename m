Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:42345 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753940Ab3JCNMl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Oct 2013 09:12:41 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH/RFT 3/3] ath10k: fix scheduling while atomic config bug
Date: Thu, 3 Oct 2013 15:09:25 +0200
Message-ID: <1380805765-31521-4-git-send-email-michal.kazior@tieto.com> (sfid-20131003_151245_254324_44A92BA4)
In-Reply-To: <1380805765-31521-1-git-send-email-michal.kazior@tieto.com>
References: <1380805765-31521-1-git-send-email-michal.kazior@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Recent HTC/WMI changes introduced the bug. ath10k
was using _atomic iteration function with
sleepable functions.

mac80211 provides another iteration function but
it cannot be safely called in hw_config() callback
due to local->iflist_mtx being possibly acquired
already.

The patch uses internal vif list for iteration
purposes and removes/refactors no longer necessary
_iter functions.

Reported-By: Kalle Valo <kvalo@qca.qualcomm.com>
Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c |  146 ++++++++++++++-------------------
 1 file changed, 62 insertions(+), 84 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 292e5cd..df6f973 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -723,35 +723,30 @@ static void ath10k_control_ibss(struct ath10k_vif *arvif,
 /*
  * Review this when mac80211 gains per-interface powersave support.
  */
-static void ath10k_ps_iter(void *data, u8 *mac, struct ieee80211_vif *vif)
+static int ath10k_mac_vif_setup_ps(struct ath10k_vif *arvif)
 {
-	struct ath10k_generic_iter *ar_iter = data;
-	struct ieee80211_conf *conf = &ar_iter->ar->hw->conf;
-	struct ath10k_vif *arvif = ath10k_vif_to_arvif(vif);
+	struct ath10k *ar = arvif->ar;
+	struct ieee80211_conf *conf = &ar->hw->conf;
 	enum wmi_sta_powersave_param param;
 	enum wmi_sta_ps_mode psmode;
 	int ret;
 
 	lockdep_assert_held(&arvif->ar->conf_mutex);
 
-	if (vif->type != NL80211_IFTYPE_STATION)
-		return;
+	if (arvif->vif->type != NL80211_IFTYPE_STATION)
+		return 0;
 
 	if (conf->flags & IEEE80211_CONF_PS) {
 		psmode = WMI_STA_PS_MODE_ENABLED;
 		param = WMI_STA_PS_PARAM_INACTIVITY_TIME;
 
-		ret = ath10k_wmi_set_sta_ps_param(ar_iter->ar,
-						  arvif->vdev_id,
-						  param,
+		ret = ath10k_wmi_set_sta_ps_param(ar, arvif->vdev_id, param,
 						  conf->dynamic_ps_timeout);
 		if (ret) {
 			ath10k_warn("Failed to set inactivity time for VDEV: %d\n",
 				    arvif->vdev_id);
-			return;
+			return ret;
 		}
-
-		ar_iter->ret = ret;
 	} else {
 		psmode = WMI_STA_PS_MODE_DISABLED;
 	}
@@ -759,11 +754,14 @@ static void ath10k_ps_iter(void *data, u8 *mac, struct ieee80211_vif *vif)
 	ath10k_dbg(ATH10K_DBG_MAC, "mac vdev %d psmode %s\n",
 		   arvif->vdev_id, psmode ? "enable" : "disable");
 
-	ar_iter->ret = ath10k_wmi_set_psmode(ar_iter->ar, arvif->vdev_id,
-					     psmode);
-	if (ar_iter->ret)
+	ret = ath10k_wmi_set_psmode(ar, arvif->vdev_id, psmode);
+	if (ret) {
 		ath10k_warn("Failed to set PS Mode: %d for VDEV: %d\n",
 			    psmode, arvif->vdev_id);
+		return ret;
+	}
+
+	return 0;
 }
 
 /**********************/
@@ -1919,9 +1917,10 @@ static void ath10k_stop(struct ieee80211_hw *hw)
 	cancel_work_sync(&ar->restart_work);
 }
 
-static void ath10k_config_ps(struct ath10k *ar)
+static int ath10k_config_ps(struct ath10k *ar)
 {
-	struct ath10k_generic_iter ar_iter;
+	struct ath10k_vif *arvif;
+	int ret;
 
 	lockdep_assert_held(&ar->conf_mutex);
 
@@ -1930,17 +1929,17 @@ static void ath10k_config_ps(struct ath10k *ar)
 	 * vdevs at this point we must not iterate over this interface list.
 	 * This setting will be updated upon add_interface(). */
 	if (ar->state == ATH10K_STATE_RESTARTED)
-		return;
-
-	memset(&ar_iter, 0, sizeof(struct ath10k_generic_iter));
-	ar_iter.ar = ar;
+		return 0;
 
-	ieee80211_iterate_active_interfaces_atomic(
-		ar->hw, IEEE80211_IFACE_ITER_NORMAL,
-		ath10k_ps_iter, &ar_iter);
+	list_for_each_entry(arvif, &ar->arvifs, list) {
+		ret = ath10k_mac_vif_setup_ps(arvif);
+		if (ret) {
+			ath10k_warn("could not setup powersave (%d)\n", ret);
+			break;
+		}
+	}
 
-	if (ar_iter.ret)
-		ath10k_warn("failed to set ps config (%d)\n", ar_iter.ret);
+	return ret;
 }
 
 static int ath10k_config(struct ieee80211_hw *hw, u32 changed)
@@ -2834,86 +2833,65 @@ static int ath10k_cancel_remain_on_channel(struct ieee80211_hw *hw)
  * Both RTS and Fragmentation threshold are interface-specific
  * in ath10k, but device-specific in mac80211.
  */
-static void ath10k_set_rts_iter(void *data, u8 *mac, struct ieee80211_vif *vif)
-{
-	struct ath10k_generic_iter *ar_iter = data;
-	struct ath10k_vif *arvif = ath10k_vif_to_arvif(vif);
-	u32 rts = ar_iter->ar->hw->wiphy->rts_threshold;
 
-	lockdep_assert_held(&arvif->ar->conf_mutex);
+static int ath10k_set_rts_threshold(struct ieee80211_hw *hw, u32 value)
+{
+	struct ath10k *ar = hw->priv;
+	struct ath10k_vif *arvif;
+	int ret;
 
 	/* During HW reconfiguration mac80211 reports all interfaces that were
 	 * running until reconfiguration was started. Since FW doesn't have any
 	 * vdevs at this point we must not iterate over this interface list.
 	 * This setting will be updated upon add_interface(). */
-	if (ar_iter->ar->state == ATH10K_STATE_RESTARTED)
-		return;
-
-	ath10k_dbg(ATH10K_DBG_MAC, "mac vdev %d rts_threshold %d\n",
-		   arvif->vdev_id, rts);
-
-	ar_iter->ret = ath10k_mac_set_rts(arvif, rts);
-	if (ar_iter->ret)
-		ath10k_warn("Failed to set RTS threshold for VDEV: %d\n",
-			    arvif->vdev_id);
-}
-
-static int ath10k_set_rts_threshold(struct ieee80211_hw *hw, u32 value)
-{
-	struct ath10k_generic_iter ar_iter;
-	struct ath10k *ar = hw->priv;
-
-	memset(&ar_iter, 0, sizeof(struct ath10k_generic_iter));
-	ar_iter.ar = ar;
+	if (ar->state == ATH10K_STATE_RESTARTED)
+		return 0;
 
 	mutex_lock(&ar->conf_mutex);
-	ieee80211_iterate_active_interfaces_atomic(
-		hw, IEEE80211_IFACE_ITER_NORMAL,
-		ath10k_set_rts_iter, &ar_iter);
+	list_for_each_entry(arvif, &ar->arvifs, list) {
+		ath10k_dbg(ATH10K_DBG_MAC, "mac vdev %d rts threshold %d\n",
+			   arvif->vdev_id, value);
+
+		ret = ath10k_mac_set_rts(arvif, value);
+		if (ret) {
+			ath10k_warn("could not set rts threshold for vdev %d (%d)\n",
+				    arvif->vdev_id, ret);
+			break;
+		}
+	}
 	mutex_unlock(&ar->conf_mutex);
 
-	return ar_iter.ret;
+	return ret;
 }
 
-static void ath10k_set_frag_iter(void *data, u8 *mac, struct ieee80211_vif *vif)
+static int ath10k_set_frag_threshold(struct ieee80211_hw *hw, u32 value)
 {
-	struct ath10k_generic_iter *ar_iter = data;
-	struct ath10k_vif *arvif = ath10k_vif_to_arvif(vif);
-	u32 frag = ar_iter->ar->hw->wiphy->frag_threshold;
-
-	lockdep_assert_held(&arvif->ar->conf_mutex);
+	struct ath10k *ar = hw->priv;
+	struct ath10k_vif *arvif;
+	int ret;
 
 	/* During HW reconfiguration mac80211 reports all interfaces that were
 	 * running until reconfiguration was started. Since FW doesn't have any
 	 * vdevs at this point we must not iterate over this interface list.
 	 * This setting will be updated upon add_interface(). */
-	if (ar_iter->ar->state == ATH10K_STATE_RESTARTED)
-		return;
-
-	ath10k_dbg(ATH10K_DBG_MAC, "mac vdev %d fragmentation_threshold %d\n",
-		   arvif->vdev_id, frag);
-
-	ar_iter->ret = ath10k_mac_set_frag(arvif, frag);
-	if (ar_iter->ret)
-		ath10k_warn("Failed to set frag threshold for VDEV: %d\n",
-			    arvif->vdev_id);
-}
-
-static int ath10k_set_frag_threshold(struct ieee80211_hw *hw, u32 value)
-{
-	struct ath10k_generic_iter ar_iter;
-	struct ath10k *ar = hw->priv;
-
-	memset(&ar_iter, 0, sizeof(struct ath10k_generic_iter));
-	ar_iter.ar = ar;
+	if (ar->state == ATH10K_STATE_RESTARTED)
+		return 0;
 
 	mutex_lock(&ar->conf_mutex);
-	ieee80211_iterate_active_interfaces_atomic(
-		hw, IEEE80211_IFACE_ITER_NORMAL,
-		ath10k_set_frag_iter, &ar_iter);
+	list_for_each_entry(arvif, &ar->arvifs, list) {
+		ath10k_dbg(ATH10K_DBG_MAC, "mac vdev %d fragmentation threshold %d\n",
+			   arvif->vdev_id, value);
+
+		ret = ath10k_mac_set_rts(arvif, value);
+		if (ret) {
+			ath10k_warn("could not set fragmentation threshold for vdev %d (%d)\n",
+				    arvif->vdev_id, ret);
+			break;
+		}
+	}
 	mutex_unlock(&ar->conf_mutex);
 
-	return ar_iter.ret;
+	return ret;
 }
 
 static void ath10k_flush(struct ieee80211_hw *hw, u32 queues, bool drop)
-- 
1.7.9.5

