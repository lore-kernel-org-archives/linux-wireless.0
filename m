Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58783 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885AbZDGNXB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Apr 2009 09:23:01 -0400
Subject: [PATCH] mac80211: correct wext transmit power handler
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 07 Apr 2009 15:22:28 +0200
Message-Id: <1239110548.22453.45.camel@johannes.local> (sfid-20090407_152307_761527_9806214A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wext makes no assumptions about the contents of
data->txpower.fixed and data->txpower.value when
data->txpower.disabled is set, so do not update
the user-requested power level while disabling.

Also, when wext configures a really _fixed_ power
output [1], we should reject it instead of limiting it
to the regulatory constraint. If the user wants to set
a _limit_ [2] then we should honour that.

[1] iwconfig wlan0 txpower 20dBm fixed
[2] iwconfig wlan0 txpower 10dBm

This fixes
http://www.intellinuxwireless.org/bugzilla/show_bug.cgi?id=1942

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
For stable? I think we probably don't care enough.

 net/mac80211/main.c |    2 +-
 net/mac80211/wext.c |   43 ++++++++++++++++++++++++++++++++++---------
 2 files changed, 35 insertions(+), 10 deletions(-)

--- wireless-testing.orig/net/mac80211/wext.c	2009-04-02 18:02:11.000000000 +0200
+++ wireless-testing/net/mac80211/wext.c	2009-04-07 10:58:11.000000000 +0200
@@ -417,6 +417,7 @@ static int ieee80211_ioctl_siwtxpower(st
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_channel* chan = local->hw.conf.channel;
+	bool reconf = false;
 	u32 reconf_flags = 0;
 	int new_power_level;
 
@@ -427,14 +428,38 @@ static int ieee80211_ioctl_siwtxpower(st
 	if (!chan)
 		return -EINVAL;
 
-	if (data->txpower.fixed)
-		new_power_level = min(data->txpower.value, chan->max_power);
-	else /* Automatic power level setting */
-		new_power_level = chan->max_power;
-
-	local->user_power_level = new_power_level;
-	if (local->hw.conf.power_level != new_power_level)
-		reconf_flags |= IEEE80211_CONF_CHANGE_POWER;
+	/* only change when not disabling */
+	if (!data->txpower.disabled) {
+		if (data->txpower.fixed) {
+			if (data->txpower.value < 0)
+				return -EINVAL;
+			new_power_level = data->txpower.value;
+			/*
+			 * Debatable, but we cannot do a fixed power
+			 * level above the regulatory constraint.
+			 * Use "iwconfig wlan0 txpower 15dBm" instead.
+			 */
+			if (new_power_level > chan->max_power)
+				return -EINVAL;
+		} else {
+			/*
+			 * Automatic power level setting, max being the value
+			 * passed in from userland.
+			 */
+			if (data->txpower.value < 0)
+				new_power_level = -1;
+			else
+				new_power_level = data->txpower.value;
+		}
+
+		reconf = true;
+
+		/*
+		 * ieee80211_hw_config() will limit to the channel's
+		 * max power and possibly power constraint from AP.
+		 */
+		local->user_power_level = new_power_level;
+	}
 
 	if (local->hw.conf.radio_enabled != !(data->txpower.disabled)) {
 		local->hw.conf.radio_enabled = !(data->txpower.disabled);
@@ -442,7 +467,7 @@ static int ieee80211_ioctl_siwtxpower(st
 		ieee80211_led_radio(local, local->hw.conf.radio_enabled);
 	}
 
-	if (reconf_flags)
+	if (reconf || reconf_flags)
 		ieee80211_hw_config(local, reconf_flags);
 
 	return 0;
--- wireless-testing.orig/net/mac80211/main.c	2009-04-07 10:44:24.000000000 +0200
+++ wireless-testing/net/mac80211/main.c	2009-04-07 10:44:33.000000000 +0200
@@ -258,7 +258,7 @@ int ieee80211_hw_config(struct ieee80211
 			(chan->max_power - local->power_constr_level) :
 			chan->max_power;
 
-	if (local->user_power_level)
+	if (local->user_power_level >= 0)
 		power = min(power, local->user_power_level);
 
 	if (local->hw.conf.power_level != power) {


