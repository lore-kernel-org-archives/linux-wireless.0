Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60992 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047AbZAFRNB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jan 2009 12:13:01 -0500
Subject: [PATCH] mac80211: move dynamic PS timeout to hardware config
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Kalle Valo <kalle.valo@nokia.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 06 Jan 2009 18:13:18 +0100
Message-Id: <1231261998.3654.2.camel@johannes> (sfid-20090106_181306_890633_91E3F986)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This will be needed for drivers that set the
IEEE80211_HW_NO_STACK_DYNAMIC_PS flag and still
want to handle dynamic PS.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/net/mac80211.h     |   13 ++++++++-----
 net/mac80211/ieee80211_i.h |    1 -
 net/mac80211/mlme.c        |    5 +++--
 net/mac80211/tx.c          |    4 ++--
 net/mac80211/wext.c        |   14 ++++++++------
 5 files changed, 21 insertions(+), 16 deletions(-)

--- wireless-testing.orig/include/net/mac80211.h	2009-01-06 18:10:07.000000000 +0100
+++ wireless-testing/include/net/mac80211.h	2009-01-06 18:11:02.000000000 +0100
@@ -521,6 +521,7 @@ struct ieee80211_ht_conf {
  * @IEEE80211_CONF_CHANGE_LISTEN_INTERVAL: the listen interval changed
  * @IEEE80211_CONF_CHANGE_RADIOTAP: the radiotap flag changed
  * @IEEE80211_CONF_CHANGE_PS: the PS flag changed
+ * @IEEE80211_CONF_CHANGE_DYNPS_TIMEOUT: the dynamic PS timeout changed
  * @IEEE80211_CONF_CHANGE_POWER: the TX power changed
  * @IEEE80211_CONF_CHANGE_CHANNEL: the channel changed
  * @IEEE80211_CONF_CHANGE_RETRY_LIMITS: retry limits changed
@@ -532,10 +533,11 @@ enum ieee80211_conf_changed {
 	IEEE80211_CONF_CHANGE_LISTEN_INTERVAL	= BIT(2),
 	IEEE80211_CONF_CHANGE_RADIOTAP		= BIT(3),
 	IEEE80211_CONF_CHANGE_PS		= BIT(4),
-	IEEE80211_CONF_CHANGE_POWER		= BIT(5),
-	IEEE80211_CONF_CHANGE_CHANNEL		= BIT(6),
-	IEEE80211_CONF_CHANGE_RETRY_LIMITS	= BIT(7),
-	IEEE80211_CONF_CHANGE_HT		= BIT(8),
+	IEEE80211_CONF_CHANGE_DYNPS_TIMEOUT	= BIT(5),
+	IEEE80211_CONF_CHANGE_POWER		= BIT(6),
+	IEEE80211_CONF_CHANGE_CHANNEL		= BIT(7),
+	IEEE80211_CONF_CHANGE_RETRY_LIMITS	= BIT(8),
+	IEEE80211_CONF_CHANGE_HT		= BIT(9),
 };
 
 /**
@@ -548,6 +550,7 @@ enum ieee80211_conf_changed {
  * @listen_interval: listen interval in units of beacon interval
  * @flags: configuration flags defined above
  * @power_level: requested transmit power (in dBm)
+ * @dynamic_ps_timeout: dynamic powersave timeout (in ms)
  * @channel: the channel to tune to
  * @ht: the HT configuration for the device
  * @long_frame_max_tx_count: Maximum number of transmissions for a "long" frame
@@ -560,7 +563,7 @@ enum ieee80211_conf_changed {
 struct ieee80211_conf {
 	int beacon_int;
 	u32 flags;
-	int power_level;
+	int power_level, dynamic_ps_timeout;
 
 	u16 listen_interval;
 	bool radio_enabled;
--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2009-01-06 18:10:07.000000000 +0100
+++ wireless-testing/net/mac80211/ieee80211_i.h	2009-01-06 18:11:02.000000000 +0100
@@ -697,7 +697,6 @@ struct ieee80211_local {
 	unsigned int wmm_acm; /* bit field of ACM bits (BIT(802.1D tag)) */
 
 	bool powersave;
-	int dynamic_ps_timeout;
 	struct work_struct dynamic_ps_enable_work;
 	struct work_struct dynamic_ps_disable_work;
 	struct timer_list dynamic_ps_timer;
--- wireless-testing.orig/net/mac80211/mlme.c	2009-01-06 18:10:07.000000000 +0100
+++ wireless-testing/net/mac80211/mlme.c	2009-01-06 18:11:02.000000000 +0100
@@ -779,9 +779,10 @@ static void ieee80211_set_associated(str
 
 	if (local->powersave &&
 			!(local->hw.flags & IEEE80211_HW_NO_STACK_DYNAMIC_PS)) {
-		if (local->dynamic_ps_timeout > 0)
+		if (local->hw.conf.dynamic_ps_timeout > 0)
 			mod_timer(&local->dynamic_ps_timer, jiffies +
-				  msecs_to_jiffies(local->dynamic_ps_timeout));
+				  msecs_to_jiffies(
+					local->hw.conf.dynamic_ps_timeout));
 		else {
 			ieee80211_send_nullfunc(local, sdata, 1);
 			conf->flags |= IEEE80211_CONF_PS;
--- wireless-testing.orig/net/mac80211/tx.c	2009-01-06 18:10:07.000000000 +0100
+++ wireless-testing/net/mac80211/tx.c	2009-01-06 18:11:02.000000000 +0100
@@ -1299,7 +1299,7 @@ int ieee80211_master_start_xmit(struct s
 	}
 
 	if (!(local->hw.flags & IEEE80211_HW_NO_STACK_DYNAMIC_PS) &&
-	    local->dynamic_ps_timeout > 0) {
+	    local->hw.conf.dynamic_ps_timeout > 0) {
 		if (local->hw.conf.flags & IEEE80211_CONF_PS) {
 			ieee80211_stop_queues_by_reason(&local->hw,
 					IEEE80211_QUEUE_STOP_REASON_PS);
@@ -1308,7 +1308,7 @@ int ieee80211_master_start_xmit(struct s
 		}
 
 		mod_timer(&local->dynamic_ps_timer, jiffies +
-				msecs_to_jiffies(local->dynamic_ps_timeout));
+		        msecs_to_jiffies(local->hw.conf.dynamic_ps_timeout));
 	}
 
 	memset(info, 0, sizeof(*info));
--- wireless-testing.orig/net/mac80211/wext.c	2009-01-06 18:10:23.000000000 +0100
+++ wireless-testing/net/mac80211/wext.c	2009-01-06 18:11:02.000000000 +0100
@@ -862,17 +862,19 @@ static int ieee80211_ioctl_siwpower(stru
 		timeout = wrq->value / 1000;
 
 set:
-	if (ps == local->powersave && timeout == local->dynamic_ps_timeout)
+	if (ps == local->powersave && timeout == conf->dynamic_ps_timeout)
 		return ret;
 
 	local->powersave = ps;
-	local->dynamic_ps_timeout = timeout;
+	conf->dynamic_ps_timeout = timeout;
 
-	if (!(local->hw.flags & IEEE80211_HW_NO_STACK_DYNAMIC_PS) &&
-			(sdata->u.sta.flags & IEEE80211_STA_ASSOCIATED)) {
-		if (local->dynamic_ps_timeout > 0)
+	if (local->hw.flags & IEEE80211_HW_NO_STACK_DYNAMIC_PS) {
+		ret = ieee80211_hw_config(local,
+					  IEEE80211_CONF_CHANGE_DYNPS_TIMEOUT);
+	} else if (sdata->u.sta.flags & IEEE80211_STA_ASSOCIATED) {
+		if (conf->dynamic_ps_timeout > 0)
 			mod_timer(&local->dynamic_ps_timer, jiffies +
-				  msecs_to_jiffies(local->dynamic_ps_timeout));
+				  msecs_to_jiffies(conf->dynamic_ps_timeout));
 		else {
 			if (local->powersave) {
 				ieee80211_send_nullfunc(local, sdata, 1);


