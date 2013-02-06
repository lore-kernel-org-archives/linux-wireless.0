Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52896 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758599Ab3BFWIJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Feb 2013 17:08:09 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: remove dynamic PS driver interface
Date: Wed,  6 Feb 2013 23:08:27 +0100
Message-Id: <1360188507-25819-1-git-send-email-johannes@sipsolutions.net> (sfid-20130206_230815_828308_0DE52B79)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The functions were added for some sort of Bluetooth
coexistence, but aren't used, so remove them again.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h     | 39 ---------------------------------------
 net/mac80211/ieee80211_i.h |  2 --
 net/mac80211/mlme.c        | 42 ++----------------------------------------
 3 files changed, 2 insertions(+), 81 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index d7dc907..dc20df9 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1700,15 +1700,6 @@ void ieee80211_free_txskb(struct ieee80211_hw *hw, struct sk_buff *skb);
  * dynamic PS feature in stack and will just keep %IEEE80211_CONF_PS
  * enabled whenever user has enabled powersave.
  *
- * Some hardware need to toggle a single shared antenna between WLAN and
- * Bluetooth to facilitate co-existence. These types of hardware set
- * limitations on the use of host controlled dynamic powersave whenever there
- * is simultaneous WLAN and Bluetooth traffic. For these types of hardware, the
- * driver may request temporarily going into full power save, in order to
- * enable toggling the antenna between BT and WLAN. If the driver requests
- * disabling dynamic powersave, the @dynamic_ps_timeout value will be
- * temporarily set to zero until the driver re-enables dynamic powersave.
- *
  * Driver informs U-APSD client support by enabling
  * %IEEE80211_HW_SUPPORTS_UAPSD flag. The mode is configured through the
  * uapsd paramater in conf_tx() operation. Hardware needs to send the QoS
@@ -3947,36 +3938,6 @@ void ieee80211_connection_loss(struct ieee80211_vif *vif);
 void ieee80211_resume_disconnect(struct ieee80211_vif *vif);
 
 /**
- * ieee80211_disable_dyn_ps - force mac80211 to temporarily disable dynamic psm
- *
- * @vif: &struct ieee80211_vif pointer from the add_interface callback.
- *
- * Some hardware require full power save to manage simultaneous BT traffic
- * on the WLAN frequency. Full PSM is required periodically, whenever there are
- * burst of BT traffic. The hardware gets information of BT traffic via
- * hardware co-existence lines, and consequentially requests mac80211 to
- * (temporarily) enter full psm.
- * This function will only temporarily disable dynamic PS, not enable PSM if
- * it was not already enabled.
- * The driver must make sure to re-enable dynamic PS using
- * ieee80211_enable_dyn_ps() if the driver has disabled it.
- *
- */
-void ieee80211_disable_dyn_ps(struct ieee80211_vif *vif);
-
-/**
- * ieee80211_enable_dyn_ps - restore dynamic psm after being disabled
- *
- * @vif: &struct ieee80211_vif pointer from the add_interface callback.
- *
- * This function restores dynamic PS after being temporarily disabled via
- * ieee80211_disable_dyn_ps(). Each ieee80211_disable_dyn_ps() call must
- * be coupled with an eventual call to this function.
- *
- */
-void ieee80211_enable_dyn_ps(struct ieee80211_vif *vif);
-
-/**
  * ieee80211_cqm_rssi_notify - inform a configured connection quality monitoring
  *	rssi threshold triggered
  *
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 0aee941..39e746f 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1106,8 +1106,6 @@ struct ieee80211_local {
 	 * this will override whatever chosen by mac80211 internally.
 	 */
 	int dynamic_ps_forced_timeout;
-	int dynamic_ps_user_timeout;
-	bool disable_dynamic_ps;
 
 	int user_power_level; /* in dBm, for all interfaces */
 
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 735859e..c0934e5 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -950,39 +950,6 @@ static u32 ieee80211_handle_pwr_constr(struct ieee80211_sub_if_data *sdata,
 	return 0;
 }
 
-void ieee80211_enable_dyn_ps(struct ieee80211_vif *vif)
-{
-	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
-	struct ieee80211_local *local = sdata->local;
-	struct ieee80211_conf *conf = &local->hw.conf;
-
-	WARN_ON(sdata->vif.type != NL80211_IFTYPE_STATION ||
-		!(local->hw.flags & IEEE80211_HW_SUPPORTS_PS) ||
-		(local->hw.flags & IEEE80211_HW_SUPPORTS_DYNAMIC_PS));
-
-	local->disable_dynamic_ps = false;
-	conf->dynamic_ps_timeout = local->dynamic_ps_user_timeout;
-}
-EXPORT_SYMBOL(ieee80211_enable_dyn_ps);
-
-void ieee80211_disable_dyn_ps(struct ieee80211_vif *vif)
-{
-	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
-	struct ieee80211_local *local = sdata->local;
-	struct ieee80211_conf *conf = &local->hw.conf;
-
-	WARN_ON(sdata->vif.type != NL80211_IFTYPE_STATION ||
-		!(local->hw.flags & IEEE80211_HW_SUPPORTS_PS) ||
-		(local->hw.flags & IEEE80211_HW_SUPPORTS_DYNAMIC_PS));
-
-	local->disable_dynamic_ps = true;
-	conf->dynamic_ps_timeout = 0;
-	del_timer_sync(&local->dynamic_ps_timer);
-	ieee80211_queue_work(&local->hw,
-			     &local->dynamic_ps_enable_work);
-}
-EXPORT_SYMBOL(ieee80211_disable_dyn_ps);
-
 /* powersave */
 static void ieee80211_enable_ps(struct ieee80211_local *local,
 				struct ieee80211_sub_if_data *sdata)
@@ -1085,7 +1052,6 @@ void ieee80211_recalc_ps(struct ieee80211_local *local, s32 latency)
 	}
 
 	if (count == 1 && ieee80211_powersave_allowed(found)) {
-		struct ieee80211_conf *conf = &local->hw.conf;
 		s32 beaconint_us;
 
 		if (latency < 0)
@@ -1109,10 +1075,7 @@ void ieee80211_recalc_ps(struct ieee80211_local *local, s32 latency)
 			else
 				timeout = 100;
 		}
-		local->dynamic_ps_user_timeout = timeout;
-		if (!local->disable_dynamic_ps)
-			conf->dynamic_ps_timeout =
-				local->dynamic_ps_user_timeout;
+		local->hw.conf.dynamic_ps_timeout = timeout;
 
 		if (beaconint_us > latency) {
 			local->ps_sdata = NULL;
@@ -1182,8 +1145,7 @@ void ieee80211_dynamic_ps_enable_work(struct work_struct *work)
 	if (local->hw.conf.flags & IEEE80211_CONF_PS)
 		return;
 
-	if (!local->disable_dynamic_ps &&
-	    local->hw.conf.dynamic_ps_timeout > 0) {
+	if (local->hw.conf.dynamic_ps_timeout > 0) {
 		/* don't enter PS if TX frames are pending */
 		if (drv_tx_frames_pending(local)) {
 			mod_timer(&local->dynamic_ps_timer, jiffies +
-- 
1.8.0

