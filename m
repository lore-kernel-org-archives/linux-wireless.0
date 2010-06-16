Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:27164 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754759Ab0FPGBx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jun 2010 02:01:53 -0400
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCHv2] mac80211: Add interface for driver to temporarily disable dynamic ps
Date: Wed, 16 Jun 2010 09:01:32 +0300
Message-Id: <1276668092-28872-1-git-send-email-juuso.oikarinen@nokia.com>
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
v2: moved dynamic_ps_user_timeout and disable_dynamic_ps to local

 include/net/mac80211.h     |   27 +++++++++++++++++++++++++++
 net/mac80211/ieee80211_i.h |    3 +++
 net/mac80211/mlme.c        |   29 ++++++++++++++++++++++++++++-
 3 files changed, 58 insertions(+), 1 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index fe1a3a6..2628550 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1271,6 +1271,15 @@ ieee80211_get_alt_retry_rate(const struct ieee80211_hw *hw,
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
@@ -2447,6 +2456,24 @@ void ieee80211_beacon_loss(struct ieee80211_vif *vif);
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
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index fb54301..f90c48c 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -856,6 +856,9 @@ struct ieee80211_local {
 	 */
 	int dynamic_ps_forced_timeout;
 
+	int dynamic_ps_user_timeout;
+	bool disable_dynamic_ps;
+
 	int user_power_level; /* in dBm */
 	int power_constr_level; /* in dBm */
 
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 85c3ca3..dd16dad 100644
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
+	local->disable_dynamic_ps = disable;
+
+	if (disable) {
+		conf->dynamic_ps_timeout = 0;
+		del_timer_sync(&local->dynamic_ps_timer);
+		ieee80211_queue_work(&local->hw,
+				     &local->dynamic_ps_enable_work);
+	} else {
+		conf->dynamic_ps_timeout = local->dynamic_ps_user_timeout;
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
@@ -575,7 +599,10 @@ void ieee80211_recalc_ps(struct ieee80211_local *local, s32 latency)
 			else
 				timeout = 100;
 		}
-		local->hw.conf.dynamic_ps_timeout = timeout;
+		local->dynamic_ps_user_timeout = timeout;
+		if (!local->disable_dynamic_ps)
+			conf->dynamic_ps_timeout =
+				local->dynamic_ps_user_timeout;
 
 		if (beaconint_us > latency) {
 			local->ps_sdata = NULL;
-- 
1.6.3.3

