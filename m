Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40759 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758862AbZAFWXg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jan 2009 17:23:36 -0500
Subject: [PATCH] mac80211: remove user_power_level from driver API
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>
Content-Type: text/plain
Date: Tue, 06 Jan 2009 23:23:56 +0100
Message-Id: <1231280636.3767.13.camel@johannes> (sfid-20090106_232357_777600_5D48D334)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I missed this during review of "mac80211: Fix tx power setting",
the user_power_level shouldn't be available to the driver but
rather be an internal value used to calculate the value for the
driver.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Cc: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
John, my PS patches from earlier today won't apply cleanly without this,
so please put this one in first to and don't try to fix them up.

 include/net/mac80211.h     |    2 --
 net/mac80211/ieee80211_i.h |    2 ++
 net/mac80211/main.c        |    4 ++--
 net/mac80211/wext.c        |    2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

--- wireless-testing.orig/include/net/mac80211.h	2009-01-06 23:19:19.000000000 +0100
+++ wireless-testing/include/net/mac80211.h	2009-01-06 23:19:42.000000000 +0100
@@ -547,7 +547,6 @@ enum ieee80211_conf_changed {
  * @listen_interval: listen interval in units of beacon interval
  * @flags: configuration flags defined above
  * @power_level: requested transmit power (in dBm)
- * @user_power_level: User configured transmit power (in dBm)
  * @channel: the channel to tune to
  * @ht: the HT configuration for the device
  * @long_frame_max_tx_count: Maximum number of transmissions for a "long" frame
@@ -561,7 +560,6 @@ struct ieee80211_conf {
 	int beacon_int;
 	u32 flags;
 	int power_level;
-	int user_power_level;
 
 	u16 listen_interval;
 	bool radio_enabled;
--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2009-01-06 23:19:48.000000000 +0100
+++ wireless-testing/net/mac80211/ieee80211_i.h	2009-01-06 23:20:25.000000000 +0100
@@ -702,6 +702,8 @@ struct ieee80211_local {
 	struct work_struct dynamic_ps_disable_work;
 	struct timer_list dynamic_ps_timer;
 
+	int user_power_level; /* in dBm */
+
 #ifdef CONFIG_MAC80211_DEBUGFS
 	struct local_debugfsdentries {
 		struct dentry *rcdir;
--- wireless-testing.orig/net/mac80211/main.c	2009-01-06 23:20:30.000000000 +0100
+++ wireless-testing/net/mac80211/main.c	2009-01-06 23:20:45.000000000 +0100
@@ -214,10 +214,10 @@ int ieee80211_hw_config(struct ieee80211
 		changed |= IEEE80211_CONF_CHANGE_CHANNEL;
 	}
 
-	if (!local->hw.conf.user_power_level)
+	if (!local->user_power_level)
 		power = chan->max_power;
 	else
-		power = min(chan->max_power, local->hw.conf.user_power_level);
+		power = min(chan->max_power, local->user_power_level);
 	if (local->hw.conf.power_level != power) {
 		changed |= IEEE80211_CONF_CHANGE_POWER;
 		local->hw.conf.power_level = power;
--- wireless-testing.orig/net/mac80211/wext.c	2009-01-06 23:20:51.000000000 +0100
+++ wireless-testing/net/mac80211/wext.c	2009-01-06 23:20:55.000000000 +0100
@@ -549,7 +549,7 @@ static int ieee80211_ioctl_siwtxpower(st
 	else /* Automatic power level setting */
 		new_power_level = chan->max_power;
 
-	local->hw.conf.user_power_level = new_power_level;
+	local->user_power_level = new_power_level;
 	if (local->hw.conf.power_level != new_power_level)
 		reconf_flags |= IEEE80211_CONF_CHANGE_POWER;
 


