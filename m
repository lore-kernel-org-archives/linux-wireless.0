Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:43086 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752364Ab3A2Xr5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jan 2013 18:47:57 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Cc: Seth Forshee <seth.forshee@canonical.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 6/7] mac80211: Add off-channel powersave state
Date: Tue, 29 Jan 2013 17:47:34 -0600
Message-Id: <1359503255-18270-7-git-send-email-seth.forshee@canonical.com> (sfid-20130130_004800_454242_50FEA440)
In-Reply-To: <1359503255-18270-1-git-send-email-seth.forshee@canonical.com>
References: <1359503255-18270-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some driviers need to perform hardware configuration or other activities
in order to properly support off-channel powersave. Add an off-channel
powersave state to inform drivers that MAC-level support for powersave
is required while keeping the hardware powered on for off-channel
operation, and update the documentation with informtion about this
state.

Also modify the conditions for sending nullfunc frames from mac80211 for
off-channel operation. Hardware which supports sending the frames will
now have accurate information about the powersave state and should no
longer require that mac80211 generate the frames. Continue sending them
for all drivers which do not support powersave, however.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 include/net/mac80211.h    |   29 ++++++++++++++++++++++++
 net/mac80211/offchannel.c |   55 +++++++++++++++++++++------------------------
 2 files changed, 55 insertions(+), 29 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index d6c24d9..eb5d5e9 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -871,6 +871,11 @@ struct ieee80211_rx_status {
  *	up for beacons, is able to transmit frames and receive the possible
  *	acknowledgement frames. Not to be confused with hardware specific
  *	wakeup/sleep states; the driver is responsible for that.
+ * @IEEE80211_CONF_PS_OFFCHANNEL: Power save is enabled at the AP, but the
+ *	hardware remains powered on for transmitting and receiving frames. This
+ *	is used to request that the AP buffer frames while the STA leaves the
+ *	operating channel. The hardware must be configured to set PM in
+ *	frame control, if applicable.
  * @IEEE80211_CONF_IDLE: The device is running, but idle; if the flag is set
  *	the driver should be prepared to handle configuration requests but
  *	may turn the device off as much as possible. Typically, this flag will
@@ -884,6 +889,7 @@ enum ieee80211_conf_flags {
 	IEEE80211_CONF_PS_MASK		= (3<<1),
 	IEEE80211_CONF_PS_DISABLED	= (0<<1),
 	IEEE80211_CONF_PS_ENABLED	= (1<<1),
+	IEEE80211_CONF_PS_OFFCHANNEL	= (2<<1),
 	IEEE80211_CONF_IDLE		= (1<<3),
 	IEEE80211_CONF_OFFCHANNEL	= (1<<4),
 };
@@ -1013,6 +1019,20 @@ static inline bool ieee80211_is_ps_enabled(struct ieee80211_conf *conf)
 }
 
 /**
+ * ieee80211_is_ps_offchannel - check if off-channel powersave is enabled
+ *
+ * Returns true if off-channel powersave is enabled in the supplied
+ * configuration.
+ *
+ * @conf: device configuration
+ */
+static inline bool ieee80211_is_ps_offchannel(struct ieee80211_conf *conf)
+{
+	return (conf->flags & IEEE80211_CONF_PS_MASK) ==
+	       IEEE80211_CONF_PS_OFFCHANNEL;
+}
+
+/**
  * ieee80211_set_ps_state - set device powersave state
  *
  * Sets the powersave state in the supplied device configuration to the
@@ -1712,6 +1732,15 @@ void ieee80211_free_txskb(struct ieee80211_hw *hw, struct sk_buff *skb);
  * waking up for multicast traffic; if it cannot the driver must handle that
  * as best as it can, mac80211 is too slow to do that.
  *
+ * If ieee80211_is_ps_offchannel() returns true, off-channel powersave is
+ * enabled. During off-channel powersave the AP is instructed to buffer frames
+ * as if the hardware is in powersave, but the hardware must remain fully
+ * operational to support off-channel operation. If necessary the hardware
+ * must be configured to set PM in frame control for frames destined for the
+ * AP. Drivers will be told about entering and leaving off-channel powersave
+ * even if %IEEE80211_HW_SUPPORTS_PS is cleared; drivers which do not need to
+ * do any configuration can safely ignore it.
+ *
  * Dynamic powersave is an extension to normal powersave in which the
  * hardware stays awake for a user-specified period of time after sending a
  * frame so that reply frames need not be buffered and therefore delayed to
diff --git a/net/mac80211/offchannel.c b/net/mac80211/offchannel.c
index d524794..5ee2ea8 100644
--- a/net/mac80211/offchannel.c
+++ b/net/mac80211/offchannel.c
@@ -40,25 +40,20 @@ static bool ieee80211_offchannel_ps_enable(struct ieee80211_sub_if_data *sdata)
 
 	cancel_work_sync(&local->dynamic_ps_enable_work);
 
-	if (ieee80211_is_ps_enabled(&local->hw.conf)) {
+	if (ieee80211_is_ps_enabled(&local->hw.conf))
 		local->offchannel_ps_enabled = true;
-		ieee80211_set_ps_state(&local->hw.conf,
-				       IEEE80211_CONF_PS_DISABLED);
-		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
-	}
 
-	if (!local->offchannel_ps_enabled ||
-	    !(local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK))
-		/*
-		 * If power save was enabled, no need to send a nullfunc
-		 * frame because AP knows that we are sleeping. But if the
-		 * hardware is creating the nullfunc frame for power save
-		 * status (ie. IEEE80211_HW_PS_NULLFUNC_STACK is not
-		 * enabled) and power save was enabled, the firmware just
-		 * sent a null frame with power save disabled. So we need
-		 * to send a new nullfunc frame to inform the AP that we
-		 * are again sleeping.
-		 */
+	/*
+	 * Change powersave state even if the driver doesn't declare
+	 * powersave support, as drivers still may require some
+	 * configuration for off-channel powersave
+	 */
+	ieee80211_set_ps_state(&local->hw.conf, IEEE80211_CONF_PS_OFFCHANNEL);
+	ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
+
+	if (!(local->hw.flags & IEEE80211_HW_SUPPORTS_PS) ||
+	    (!local->offchannel_ps_enabled &&
+	     local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK))
 		ret = ieee80211_send_nullfunc(local, sdata, 1);
 
 	return ret;
@@ -69,9 +64,7 @@ static void ieee80211_offchannel_ps_disable(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_local *local = sdata->local;
 
-	if (!local->ps_sdata)
-		ieee80211_send_nullfunc(local, sdata, 0);
-	else if (local->offchannel_ps_enabled) {
+	if (local->offchannel_ps_enabled) {
 		/*
 		 * In !IEEE80211_HW_PS_NULLFUNC_STACK case the hardware
 		 * will send a nullfunc frame with the powersave bit set
@@ -85,22 +78,26 @@ static void ieee80211_offchannel_ps_disable(struct ieee80211_sub_if_data *sdata)
 		 * we are sleeping, let's just enable power save mode in
 		 * hardware.
 		 */
-		/* TODO:  Only set hardware if CONF_PS changed?
-		 * TODO:  Should we set offchannel_ps_enabled to false?
-		 */
+		/* TODO:  Should we set offchannel_ps_enabled to false? */
 		ieee80211_set_ps_state(&local->hw.conf,
 				       IEEE80211_CONF_PS_ENABLED);
 		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
-	} else if (local->hw.conf.dynamic_ps_timeout > 0) {
+	} else {
+		ieee80211_set_ps_state(&local->hw.conf,
+				       IEEE80211_CONF_PS_DISABLED);
+		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
+		if (!(local->hw.flags & IEEE80211_HW_SUPPORTS_PS) ||
+		    local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK)
+			ieee80211_send_nullfunc(local, sdata, 0);
+
 		/*
 		 * If power save was not enabled and the dynamic_ps_timer
 		 * had been running before leaving the operating channel,
-		 * restart the timer now and send a nullfunc frame to inform
-		 * the AP that we are awake.
+		 * restart the timer now.
 		 */
-		ieee80211_send_nullfunc(local, sdata, 0);
-		mod_timer(&local->dynamic_ps_timer, jiffies +
-			  msecs_to_jiffies(local->hw.conf.dynamic_ps_timeout));
+		if (local->hw.conf.dynamic_ps_timeout > 0)
+			mod_timer(&local->dynamic_ps_timer, jiffies +
+				  msecs_to_jiffies(local->hw.conf.dynamic_ps_timeout));
 	}
 
 	ieee80211_sta_reset_beacon_monitor(sdata);
-- 
1.7.9.5

