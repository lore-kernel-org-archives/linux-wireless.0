Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:17158 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751251AbYLXIZS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Dec 2008 03:25:18 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 24 Dec 2008 00:25:18 -0800
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linux-wireless@vger.kernel.org>
Subject: [PATCH] mac80211: Fix tx power setting
Date: Wed, 24 Dec 2008 13:53:11 +0530
Message-ID: <1230106991-2972-1-git-send-email-vasanth@atheros.com> (sfid-20081224_092536_733825_D5B51B37)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

power_level in ieee80211_conf is being used for more than one
purpose. It being used as user configured power limit and the
final power limit given to the driver. By doing so, except very
first time, the tx power limit is taken from min(chan->max_power,
local->hw.conf.power_level) which is not what we want. This patch
defines a new memeber in ieee80211_conf which is meant only for
user configured power limit.

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 include/net/mac80211.h |    2 ++
 net/mac80211/main.c    |    4 ++--
 net/mac80211/wext.c    |    5 ++---
 3 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index b3bd00a..153a8d1 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -548,6 +548,7 @@ enum ieee80211_conf_changed {
  * @listen_interval: listen interval in units of beacon interval
  * @flags: configuration flags defined above
  * @power_level: requested transmit power (in dBm)
+ * @user_power_level: User configured transmit power (in dBm)
  * @channel: the channel to tune to
  * @ht: the HT configuration for the device
  * @long_frame_max_tx_count: Maximum number of transmissions for a "long" frame
@@ -561,6 +562,7 @@ struct ieee80211_conf {
 	int beacon_int;
 	u32 flags;
 	int power_level;
+	int user_power_level;
 
 	u16 listen_interval;
 	bool radio_enabled;
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 24b1436..8831e87 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -224,10 +224,10 @@ int ieee80211_hw_config(struct ieee80211_local *local, u32 changed)
 		changed |= IEEE80211_CONF_CHANGE_CHANNEL;
 	}
 
-	if (!local->hw.conf.power_level)
+	if (!local->hw.conf.user_power_level)
 		power = chan->max_power;
 	else
-		power = min(chan->max_power, local->hw.conf.power_level);
+		power = min(chan->max_power, local->hw.conf.user_power_level);
 	if (local->hw.conf.power_level != power) {
 		changed |= IEEE80211_CONF_CHANGE_POWER;
 		local->hw.conf.power_level = power;
diff --git a/net/mac80211/wext.c b/net/mac80211/wext.c
index 48fc6b9..654041b 100644
--- a/net/mac80211/wext.c
+++ b/net/mac80211/wext.c
@@ -549,10 +549,9 @@ static int ieee80211_ioctl_siwtxpower(struct net_device *dev,
 	else /* Automatic power level setting */
 		new_power_level = chan->max_power;
 
-	if (local->hw.conf.power_level != new_power_level) {
-		local->hw.conf.power_level = new_power_level;
+	local->hw.conf.user_power_level = new_power_level;
+	if (local->hw.conf.power_level != new_power_level)
 		reconf_flags |= IEEE80211_CONF_CHANGE_POWER;
-	}
 
 	if (local->hw.conf.radio_enabled != !(data->txpower.disabled)) {
 		local->hw.conf.radio_enabled = !(data->txpower.disabled);
-- 
1.5.5.1

