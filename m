Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:37716 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337Ab0D0Js2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Apr 2010 05:48:28 -0400
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 1/2] mac80211: Determine dynamic PS timeout based on ps-qos network latency
Date: Tue, 27 Apr 2010 12:47:40 +0300
Message-Id: <1272361661-16811-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Determine the dynamic PS timeout based on the configured ps-qos network
latency. For backwards wext compatibility, allow the dynamic PS timeout
configured by the cfg80211 to overrule the automatically determined value.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
---
 include/net/mac80211.h |    5 ++++-
 net/mac80211/cfg.c     |    4 ++--
 net/mac80211/main.c    |    2 ++
 net/mac80211/mlme.c    |   21 +++++++++++++++++++++
 4 files changed, 29 insertions(+), 3 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 7dc5a67..c26de6c 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -668,6 +668,9 @@ enum ieee80211_smps_mode {
  * @dynamic_ps_timeout: The dynamic powersave timeout (in ms), see the
  *	powersave documentation below. This variable is valid only when
  *	the CONF_PS flag is set.
+ * @dynamic_ps_forced_timeout: The dynamic powersave timeout (in ms) configured
+ *	by cfg80211 (essentially, wext) If set, this value overrules the value
+ *	chosen by mac80211 based on ps qos network latency.
  *
  * @power_level: requested transmit power (in dBm)
  *
@@ -687,7 +690,7 @@ enum ieee80211_smps_mode {
  */
 struct ieee80211_conf {
 	u32 flags;
-	int power_level, dynamic_ps_timeout;
+	int power_level, dynamic_ps_timeout, dynamic_ps_forced_timeout;
 	int max_sleep_period;
 
 	u16 listen_interval;
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 845a6e6..30e9b31 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1399,11 +1399,11 @@ static int ieee80211_set_power_mgmt(struct wiphy *wiphy, struct net_device *dev,
 		return -EOPNOTSUPP;
 
 	if (enabled == sdata->u.mgd.powersave &&
-	    timeout == conf->dynamic_ps_timeout)
+	    timeout == conf->dynamic_ps_forced_timeout)
 		return 0;
 
 	sdata->u.mgd.powersave = enabled;
-	conf->dynamic_ps_timeout = timeout;
+	conf->dynamic_ps_forced_timeout = timeout;
 
 	/* no change, but if automatic follow powersave */
 	mutex_lock(&sdata->u.mgd.mtx);
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 4afe851..ebcca0e 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -569,6 +569,8 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 
 	local->hw.conf.listen_interval = local->hw.max_listen_interval;
 
+	local->hw.conf.dynamic_ps_forced_timeout = -1;
+
 	result = sta_info_start(local);
 	if (result < 0)
 		goto fail_sta_info;
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 425f66c..358226f 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -478,6 +478,7 @@ void ieee80211_recalc_ps(struct ieee80211_local *local, s32 latency)
 {
 	struct ieee80211_sub_if_data *sdata, *found = NULL;
 	int count = 0;
+	int timeout;
 
 	if (!(local->hw.flags & IEEE80211_HW_SUPPORTS_PS)) {
 		local->ps_sdata = NULL;
@@ -511,6 +512,26 @@ void ieee80211_recalc_ps(struct ieee80211_local *local, s32 latency)
 		beaconint_us = ieee80211_tu_to_usec(
 					found->vif.bss_conf.beacon_int);
 
+		timeout = local->hw.conf.dynamic_ps_forced_timeout;
+		if (timeout < 0) {
+			/*
+			 * The 2 second value is there for compatibility until
+			 * the PM_QOS_NETWORK_LATENCY is configured with real
+			 * values.
+			 */
+			if (latency == 2000000000)
+				timeout = 100;
+			else if (latency <= 50000)
+				timeout = 300;
+			else if (latency <= 100000)
+				timeout = 100;
+			else if (latency <= 500000)
+				timeout = 50;
+			else
+				timeout = 0;
+		}
+		local->hw.conf.dynamic_ps_timeout = timeout;
+
 		if (beaconint_us > latency) {
 			local->ps_sdata = NULL;
 		} else {
-- 
1.6.3.3

