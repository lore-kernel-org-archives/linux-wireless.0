Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:45018 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753475Ab0DULuh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Apr 2010 07:50:37 -0400
Received: from vaebh105.NOE.Nokia.com (vaebh105.europe.nokia.com [10.160.244.31])
	by mgw-mx09.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o3LBoQqJ007635
	for <linux-wireless@vger.kernel.org>; Wed, 21 Apr 2010 06:50:36 -0500
Received: from localhost.localdomain (wimaxnb.nmp.nokia.com [172.22.211.32])
	by mgw-sa01.ext.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o3LBnavo016358
	for <linux-wireless@vger.kernel.org>; Wed, 21 Apr 2010 14:49:37 +0300
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: linux-wireless@vger.kernel.org
Subject: [RFC PATCHv4 1/2] mac80211: Determine dynamic PS timeout based on ps-qos network latency
Date: Wed, 21 Apr 2010 14:47:37 +0300
Message-Id: <1271850458-32437-2-git-send-email-juuso.oikarinen@nokia.com>
In-Reply-To: <1271850458-32437-1-git-send-email-juuso.oikarinen@nokia.com>
References: <1271850458-32437-1-git-send-email-juuso.oikarinen@nokia.com>
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
index dcf3c5f..243e4ab 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -661,6 +661,9 @@ enum ieee80211_smps_mode {
  * @dynamic_ps_timeout: The dynamic powersave timeout (in ms), see the
  *	powersave documentation below. This variable is valid only when
  *	the CONF_PS flag is set.
+ * @dynamic_ps_forced_timeout: The dynamic powersave timeout (in ms) configured
+ *	by cfg80211 (essentially, wext) If set, this value overrules the value
+ *	chosen by mac80211 based on ps qos network latency.
  *
  * @power_level: requested transmit power (in dBm)
  *
@@ -680,7 +683,7 @@ enum ieee80211_smps_mode {
  */
 struct ieee80211_conf {
 	u32 flags;
-	int power_level, dynamic_ps_timeout;
+	int power_level, dynamic_ps_timeout, dynamic_ps_forced_timeout;
 	int max_sleep_period;
 
 	u16 listen_interval;
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 7dd7cda..9a1a91c 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1388,11 +1388,11 @@ static int ieee80211_set_power_mgmt(struct wiphy *wiphy, struct net_device *dev,
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
index 35d8502..7e6d0ab 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -476,6 +476,7 @@ void ieee80211_recalc_ps(struct ieee80211_local *local, s32 latency)
 {
 	struct ieee80211_sub_if_data *sdata, *found = NULL;
 	int count = 0;
+	int timeout;
 
 	if (!(local->hw.flags & IEEE80211_HW_SUPPORTS_PS)) {
 		local->ps_sdata = NULL;
@@ -509,6 +510,26 @@ void ieee80211_recalc_ps(struct ieee80211_local *local, s32 latency)
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

