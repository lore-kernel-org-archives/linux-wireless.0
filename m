Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:19951 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753005Ab0FCKpG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Jun 2010 06:45:06 -0400
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: Add interface for driver to temporarily disable dynamic ps
Date: Thu,  3 Jun 2010 13:44:33 +0300
Message-Id: <1275561873-21500-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This mechanism introduced in this patch applies (at least) for hardware
designs using a single shared antenna for both WLAN and BT. In these designs,
the antenna must be toggled between WLAN and BT.

In those hardware, managing WLAN co-existence with Bluetooth requires WLAN
full power save whenever there is Bluetooth activity in order for WLAN to be
able to periodically relinquish the antenna to be used for BT. This is because
BT can only access the shared antenna when WLAN is idle or asleep.

Some hardware, for instance the wl1271, are able to indicate to the host
whenever there is BT traffic. In essence, the hardware will send an indication
to the host whenever there is, for example, SCO traffic or A2DP traffic, and
will send another indication when the traffic is over.

The hardware gets information of Bluetooth traffic via hardware co-existence
control lines - these lines are used to negotiate the shared antenna
ownership. The hardware will give the antenna to BT whenever WLAN is sleeping.

This patch adds the interface to mac80211 to facilitate temporarily disabling
of dynamic power save as per request of the WLAN driver. This interface will
immediately force WLAN to full powersave, hence allowing BT coexistence as
described above.

In these kind of shared antenna desings, when WLAN powersave is fully disabled,
Bluetooth will not work simultaneously with WLAN at all. This patch does not
address that problem. This interface will not change PSM state, so if PSM is
disabled it will remain so. Solving this problem requires knowledge about BT
state, and is best done in user-space.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
---
 include/net/mac80211.h |   36 +++++++++++++++++++++++++++++++++++-
 net/mac80211/mlme.c    |   31 +++++++++++++++++++++++++++++--
 2 files changed, 64 insertions(+), 3 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index de22cbf..81e0b5f 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -675,7 +675,12 @@ enum ieee80211_smps_mode {
  *	has been received and the DTIM period is known.
  * @dynamic_ps_timeout: The dynamic powersave timeout (in ms), see the
  *	powersave documentation below. This variable is valid only when
- *	the CONF_PS flag is set.
+ *	the CONF_PS flag is set. This value may change dynamically to zero if
+ *	the driver temporarily requires no dynamic ps to allow Bluetooth
+ *	co-existence management.
+ * @dynamic_ps_user_timeout: The dynamic powersave timeout (in ms) configured
+ *	for the device. This value is used for dynamic_ps_timeout whenever
+ *	not set to zero due to driver request.
  * @dynamic_ps_forced_timeout: The dynamic powersave timeout (in ms) configured
  *	by cfg80211 (essentially, wext) If set, this value overrules the value
  *	chosen by mac80211 based on ps qos network latency.
@@ -699,6 +704,8 @@ enum ieee80211_smps_mode {
 struct ieee80211_conf {
 	u32 flags;
 	int power_level, dynamic_ps_timeout, dynamic_ps_forced_timeout;
+	int dynamic_ps_user_timeout;
+	bool disable_dynamic_ps;
 	int max_sleep_period;
 
 	u16 listen_interval;
@@ -1260,6 +1267,15 @@ ieee80211_get_alt_retry_rate(const struct ieee80211_hw *hw,
  * dynamic PS feature in stack and will just keep %IEEE80211_CONF_PS
  * enabled whenever user has enabled powersave.
  *
+ * Some hardware need to toggle a single shared antenna between WLAN and
+ * Bluetooth to facilitate co-existence. These types of hardware set
+ * limitations on the use of host controlled dynamic powersave whenever there
+ * is simultaneous WLAN and Bluetooth traffic. For these types of hardware, the
+ * driver may request temporarily going into full power save, in order to
+ * enable toggling the antenna between BT and WLAN. If the driver requests
+ * disabling dynamic powersave, the @dynamic_ps_timeout value will be
+ * temporarily set to zero until the driver re-enables dynamic powersave.
+ *
  * Driver informs U-APSD client support by enabling
  * %IEEE80211_HW_SUPPORTS_UAPSD flag. The mode is configured through the
  * uapsd paramater in conf_tx() operation. Hardware needs to send the QoS
@@ -2460,6 +2476,24 @@ void ieee80211_beacon_loss(struct ieee80211_vif *vif);
 void ieee80211_connection_loss(struct ieee80211_vif *vif);
 
 /**
+ * ieee80211_disable_dyn_ps - force mac80211 to temporarily disable dynamic psm
+ *
+ * @vif: &struct ieee80211_vif pointer from the add_interface callback.
+ *
+ * Some hardware require full power save to manage simultaneous BT traffic
+ * on the WLAN frequency. Full PSM is required periodically, whenever there are
+ * burst of BT traffic. The hardware gets information of BT traffic via
+ * hardware co-existence lines, and consequentially requests mac80211 to
+ * (temporarily) enter full psm.
+ * This function will only temporarily disable dynamic PS, not enable PSM if
+ * it was not already enabled.
+ * The driver must make sure to re-enable dynamic PS if the driver has disabled
+ * it.
+ *
+ */
+void ieee80211_disable_dyn_ps(struct ieee80211_vif *vif, bool disable);
+
+/**
  * ieee80211_cqm_rssi_notify - inform a configured connection quality monitoring
  *	rssi threshold triggered
  *
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 0839c4e..9ad0d90 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -478,6 +478,29 @@ static void ieee80211_handle_pwr_constr(struct ieee80211_sub_if_data *sdata,
 	}
 }
 
+void ieee80211_disable_dyn_ps(struct ieee80211_vif *vif, bool disable)
+{
+	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_conf *conf = &local->hw.conf;
+
+	WARN_ON(sdata->vif.type != NL80211_IFTYPE_STATION ||
+		!(local->hw.flags & IEEE80211_HW_SUPPORTS_PS) ||
+		(local->hw.flags & IEEE80211_HW_SUPPORTS_DYNAMIC_PS));
+
+	conf->disable_dynamic_ps = disable;
+
+	if (disable) {
+		conf->dynamic_ps_timeout = 0;
+		del_timer_sync(&local->dynamic_ps_timer);
+		ieee80211_queue_work(&local->hw,
+				     &local->dynamic_ps_enable_work);
+	} else {
+		conf->dynamic_ps_timeout = conf->dynamic_ps_user_timeout;
+	}
+}
+EXPORT_SYMBOL(ieee80211_disable_dyn_ps);
+
 /* powersave */
 static void ieee80211_enable_ps(struct ieee80211_local *local,
 				struct ieee80211_sub_if_data *sdata)
@@ -553,6 +576,7 @@ void ieee80211_recalc_ps(struct ieee80211_local *local, s32 latency)
 	    found->u.mgd.associated->beacon_ies &&
 	    !(found->u.mgd.flags & (IEEE80211_STA_BEACON_POLL |
 				    IEEE80211_STA_CONNECTION_POLL))) {
+		struct ieee80211_conf *conf = &local->hw.conf;
 		s32 beaconint_us;
 
 		if (latency < 0)
@@ -561,7 +585,7 @@ void ieee80211_recalc_ps(struct ieee80211_local *local, s32 latency)
 		beaconint_us = ieee80211_tu_to_usec(
 					found->vif.bss_conf.beacon_int);
 
-		timeout = local->hw.conf.dynamic_ps_forced_timeout;
+		timeout = conf->dynamic_ps_forced_timeout;
 		if (timeout < 0) {
 			/*
 			 * The 2 second value is there for compatibility until
@@ -579,7 +603,10 @@ void ieee80211_recalc_ps(struct ieee80211_local *local, s32 latency)
 			else
 				timeout = 0;
 		}
-		local->hw.conf.dynamic_ps_timeout = timeout;
+		conf->dynamic_ps_user_timeout = timeout;
+		if (!conf->disable_dynamic_ps)
+			conf->dynamic_ps_timeout =
+				conf->dynamic_ps_user_timeout;
 
 		if (beaconint_us > latency) {
 			local->ps_sdata = NULL;
-- 
1.6.3.3

