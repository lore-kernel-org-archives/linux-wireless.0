Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:53933 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758547Ab3BFVBe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Feb 2013 16:01:34 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Cc: Seth Forshee <seth.forshee@canonical.com>,
	Arend van Spriel <arend@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	brcm80211-dev-list@broadcom.com
Subject: [PATCH 3/4] mac80211: Add off-channel PS state
Date: Wed,  6 Feb 2013 15:01:17 -0600
Message-Id: <1360184478-31481-4-git-send-email-seth.forshee@canonical.com> (sfid-20130206_220139_683027_30BF2D19)
In-Reply-To: <1360184478-31481-1-git-send-email-seth.forshee@canonical.com>
References: <1360184478-31481-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add a new powersave state for off-channel operation and transition to
the off-channel code to using this state.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 include/net/mac80211.h    |    9 ++++++++-
 net/mac80211/offchannel.c |   36 +++++++++++++++++++++---------------
 2 files changed, 29 insertions(+), 16 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index c5ca5ab..014dcec 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -868,6 +868,10 @@ struct ieee80211_rx_status {
  *	up for beacons and is able to transmit and receive the possible
  *	acknowledgement frames. Not to be confused with hardware specific
  *	wakeup/sleep states; the driver is responsible for that.
+ * @IEEE80211_PS_OFFCHANNEL: The hardware is fully awake and is able to
+ *	transmit and receive frames, but the AP is asked to buffer frames
+ *	as during powersave. This is used for temporarily leaving the
+ *	operating channel.
  * @IEEE80211_CONF_IDLE: The device is running, but idle; if the flag is set
  *	the driver should be prepared to handle configuration requests but
  *	may turn the device off as much as possible. Typically, this flag will
@@ -881,6 +885,7 @@ enum ieee80211_conf_flags {
 	IEEE80211_CONF_PS_MASK		= (3<<1),
 	IEEE80211_PS_AWAKE		= (0<<1),
 	IEEE80211_PS_DOZE		= (1<<1),
+	IEEE80211_PS_OFFCHANNEL		= (2<<1),
 	IEEE80211_CONF_IDLE		= (1<<3),
 	IEEE80211_CONF_OFFCHANNEL	= (1<<4),
 };
@@ -1662,7 +1667,9 @@ void ieee80211_free_txskb(struct ieee80211_hw *hw, struct sk_buff *skb);
  * %IEEE80211_HW_SUPPORTS_PS_DOZE clear to avoid being placed into a low-
  * power state. %IEEE80211_HW_PS_NULLFUNC_STACK should be set if the
  * hardware requires that mac80211 generate nullfunc frames when
- * transitioning between powersave modes.
+ * transitioning between powersave modes. The %IEEE80211_PS_DOZE and
+ * %IEEE80211_PS_OFFCHANNEL modes must be supported by all drivers, but for
+ * most hardware these states are equivalent.
  *
  * Hardware which supports a low-power "doze" state should set the
  * %IEEE80211_HW_SUPPORTS_PS_DOZE hardware flag. This will make it possible
diff --git a/net/mac80211/offchannel.c b/net/mac80211/offchannel.c
index 22bba7a..6912339 100644
--- a/net/mac80211/offchannel.c
+++ b/net/mac80211/offchannel.c
@@ -40,11 +40,11 @@ static bool ieee80211_offchannel_ps_enable(struct ieee80211_sub_if_data *sdata)
 
 	cancel_work_sync(&local->dynamic_ps_enable_work);
 
-	if (ieee80211_conf_ps_mode(&local->hw.conf) == IEEE80211_PS_DOZE) {
+	if (ieee80211_conf_ps_mode(&local->hw.conf) == IEEE80211_PS_DOZE)
 		local->offchannel_ps_enabled = true;
-		ieee80211_conf_set_ps_mode(&local->hw.conf, IEEE80211_PS_AWAKE);
-		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
-	}
+
+	ieee80211_conf_set_ps_mode(&local->hw.conf, IEEE80211_PS_OFFCHANNEL);
+	ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
 
 	if (!local->offchannel_ps_enabled ||
 	    !(local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK))
@@ -57,6 +57,12 @@ static bool ieee80211_offchannel_ps_enable(struct ieee80211_sub_if_data *sdata)
 		 * sent a null frame with power save disabled. So we need
 		 * to send a new nullfunc frame to inform the AP that we
 		 * are again sleeping.
+		 *
+		 * XXX: This should no longer be necessary with the off-
+		 * channel PS state when the hw is creating the nullfunc
+		 * frame, as hardware should have enough information to
+		 * send the correct nullfunc frames. It remains to be seen
+		 * whether or not this holds in practice.
 		 */
 		ret = ieee80211_send_nullfunc(local, sdata, 1);
 
@@ -68,9 +74,7 @@ static void ieee80211_offchannel_ps_disable(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_local *local = sdata->local;
 
-	if (!local->ps_sdata)
-		ieee80211_send_nullfunc(local, sdata, 0);
-	else if (local->offchannel_ps_enabled) {
+	if (local->offchannel_ps_enabled) {
 		/*
 		 * In !IEEE80211_HW_PS_NULLFUNC_STACK case the hardware
 		 * will send a nullfunc frame with the powersave bit set
@@ -84,21 +88,23 @@ static void ieee80211_offchannel_ps_disable(struct ieee80211_sub_if_data *sdata)
 		 * we are sleeping, let's just enable power save mode in
 		 * hardware.
 		 */
-		/* TODO:  Only set hardware if CONF_PS changed?
-		 * TODO:  Should we set offchannel_ps_enabled to false?
+		/* TODO:  Should we set offchannel_ps_enabled to false?
 		 */
 		ieee80211_conf_set_ps_mode(&local->hw.conf, IEEE80211_PS_DOZE);
 		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
-	} else if (local->hw.conf.dynamic_ps_timeout > 0) {
+	} else {
+		ieee80211_conf_set_ps_mode(&local->hw.conf, IEEE80211_PS_AWAKE);
+		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
+		ieee80211_send_nullfunc(local, sdata, 0);
+
 		/*
 		 * If the powersave mode was awake and the dynamic_ps_timer
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

