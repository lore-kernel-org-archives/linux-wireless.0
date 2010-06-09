Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:39015 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752626Ab0FIGwT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jun 2010 02:52:19 -0400
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: Fix ps-qos network latency handling
Date: Wed,  9 Jun 2010 09:51:52 +0300
Message-Id: <1276066312-31662-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The ps-qos latency handling is broken. It uses predetermined latency values
to select specific dynamic PS timeouts. With common AP configurations, these
values overlap with beacon interval and are therefore essentially useless
(for network latencies less than the beacon interval, PSM is disabled.)

This patch remedies the problem by replacing the predetermined network latency
values with one high value (1900ms) which is used to go trigger full psm. For
backwards compatibility, the value 2000ms is still mapped to a dynamic ps
timeout of 100ms.

Currently also the mac80211 internal value for storing user space configured
dynamic PSM values is incorrectly in the driver visible ieee80211_conf struct.
Move it to the ieee80211_local struct.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
---
 include/net/mac80211.h     |    5 +----
 net/mac80211/cfg.c         |    5 ++---
 net/mac80211/ieee80211_i.h |    6 ++++++
 net/mac80211/main.c        |    2 +-
 net/mac80211/mlme.c        |   16 ++++++----------
 5 files changed, 16 insertions(+), 18 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index e3c1d47..d195992 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -674,9 +674,6 @@ enum ieee80211_smps_mode {
  * @dynamic_ps_timeout: The dynamic powersave timeout (in ms), see the
  *	powersave documentation below. This variable is valid only when
  *	the CONF_PS flag is set.
- * @dynamic_ps_forced_timeout: The dynamic powersave timeout (in ms) configured
- *	by cfg80211 (essentially, wext) If set, this value overrules the value
- *	chosen by mac80211 based on ps qos network latency.
  *
  * @power_level: requested transmit power (in dBm)
  *
@@ -696,7 +693,7 @@ enum ieee80211_smps_mode {
  */
 struct ieee80211_conf {
 	u32 flags;
-	int power_level, dynamic_ps_timeout, dynamic_ps_forced_timeout;
+	int power_level, dynamic_ps_timeout;
 	int max_sleep_period;
 
 	u16 listen_interval;
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 952845e..2b1531f 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1446,7 +1446,6 @@ static int ieee80211_set_power_mgmt(struct wiphy *wiphy, struct net_device *dev,
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-	struct ieee80211_conf *conf = &local->hw.conf;
 
 	if (sdata->vif.type != NL80211_IFTYPE_STATION)
 		return -EOPNOTSUPP;
@@ -1455,11 +1454,11 @@ static int ieee80211_set_power_mgmt(struct wiphy *wiphy, struct net_device *dev,
 		return -EOPNOTSUPP;
 
 	if (enabled == sdata->u.mgd.powersave &&
-	    timeout == conf->dynamic_ps_forced_timeout)
+	    timeout == local->dynamic_ps_forced_timeout)
 		return 0;
 
 	sdata->u.mgd.powersave = enabled;
-	conf->dynamic_ps_forced_timeout = timeout;
+	local->dynamic_ps_forced_timeout = timeout;
 
 	/* no change, but if automatic follow powersave */
 	mutex_lock(&sdata->u.mgd.mtx);
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 4d3883e..a401da3 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -853,6 +853,12 @@ struct ieee80211_local {
 	struct notifier_block network_latency_notifier;
 	struct notifier_block ifa_notifier;
 
+	/*
+	 * The dynamic ps timeout configured from user space via WEXT -
+	 * this will override whatever chosen by mac80211 internally.
+	 */
+	int dynamic_ps_forced_timeout;
+
 	int user_power_level; /* in dBm */
 	int power_constr_level; /* in dBm */
 
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 5706156..f7b269b 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -626,7 +626,7 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 
 	local->hw.conf.listen_interval = local->hw.max_listen_interval;
 
-	local->hw.conf.dynamic_ps_forced_timeout = -1;
+	local->dynamic_ps_forced_timeout = -1;
 
 	result = sta_info_start(local);
 	if (result < 0)
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index ac68c41..cb12932 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -561,23 +561,19 @@ void ieee80211_recalc_ps(struct ieee80211_local *local, s32 latency)
 		beaconint_us = ieee80211_tu_to_usec(
 					found->vif.bss_conf.beacon_int);
 
-		timeout = local->hw.conf.dynamic_ps_forced_timeout;
+		timeout = local->dynamic_ps_forced_timeout;
 		if (timeout < 0) {
 			/*
+			 * Go to full PSM if the user configures a very low
+			 * latency requirement.
 			 * The 2 second value is there for compatibility until
 			 * the PM_QOS_NETWORK_LATENCY is configured with real
 			 * values.
 			 */
-			if (latency == 2000000000)
-				timeout = 100;
-			else if (latency <= 50000)
-				timeout = 300;
-			else if (latency <= 100000)
-				timeout = 100;
-			else if (latency <= 500000)
-				timeout = 50;
-			else
+			if (latency > 1900000000 && latency != 2000000000)
 				timeout = 0;
+			else
+				timeout = 100;
 		}
 		local->hw.conf.dynamic_ps_timeout = timeout;
 
-- 
1.6.3.3

