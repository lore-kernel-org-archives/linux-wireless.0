Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:60263 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752465AbXFVIrC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jun 2007 04:47:02 -0400
Subject: [PATCH] mac80211: kill rate control ioctls
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Jiri Benc <jbenc@suse.cz>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 22 Jun 2007 10:05:00 +0200
Message-Id: <1182499500.21939.56.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These aren't used anywhere (hostapd, wpa_supplicant) and until we
have a proper interface to the rate control algorithms they don't
make much sense either since e.g. rc80211_lowest won't honour them.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 net/mac80211/hostapd_ioctl.h   |    4 --
 net/mac80211/ieee80211.c       |    2 -
 net/mac80211/ieee80211_i.h     |    2 -
 net/mac80211/ieee80211_ioctl.c |   80 -----------------------------------------
 net/mac80211/rc80211_simple.c  |    8 +++-
 5 files changed, 6 insertions(+), 90 deletions(-)

--- wireless-dev.orig/net/mac80211/ieee80211_ioctl.c	2007-06-22 09:58:25.278635409 +0200
+++ wireless-dev/net/mac80211/ieee80211_ioctl.c	2007-06-22 09:59:52.308635409 +0200
@@ -2019,62 +2019,6 @@ static int ieee80211_ioctl_clear_keys(st
 }
 
 
-static int
-ieee80211_ioctl_force_unicast_rate(struct net_device *dev,
-				   struct ieee80211_sub_if_data *sdata,
-				   int rate)
-{
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-	struct ieee80211_hw_mode *mode;
-	int i;
-
-	if (sdata->type != IEEE80211_IF_TYPE_AP)
-		return -ENOENT;
-
-	if (rate == 0) {
-		sdata->u.ap.force_unicast_rateidx = -1;
-		return 0;
-	}
-
-	mode = local->oper_hw_mode;
-	for (i = 0; i < mode->num_rates; i++) {
-		if (mode->rates[i].rate == rate) {
-			sdata->u.ap.force_unicast_rateidx = i;
-			return 0;
-		}
-	}
-	return -EINVAL;
-}
-
-
-static int
-ieee80211_ioctl_max_ratectrl_rate(struct net_device *dev,
-				  struct ieee80211_sub_if_data *sdata,
-				  int rate)
-{
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-	struct ieee80211_hw_mode *mode;
-	int i;
-
-	if (sdata->type != IEEE80211_IF_TYPE_AP)
-		return -ENOENT;
-
-	if (rate == 0) {
-		sdata->u.ap.max_ratectrl_rateidx = -1;
-		return 0;
-	}
-
-	mode = local->oper_hw_mode;
-	for (i = 0; i < mode->num_rates; i++) {
-		if (mode->rates[i].rate == rate) {
-			sdata->u.ap.max_ratectrl_rateidx = i;
-			return 0;
-		}
-	}
-	return -EINVAL;
-}
-
-
 static void ieee80211_key_enable_hwaccel(struct ieee80211_local *local,
 					 struct ieee80211_key *key)
 {
@@ -2310,22 +2254,6 @@ static int ieee80211_ioctl_prism2_param(
 		local->sta_antenna_sel = value;
 		break;
 
-	case PRISM2_PARAM_FORCE_UNICAST_RATE:
-		ret = ieee80211_ioctl_force_unicast_rate(dev, sdata, value);
-		break;
-
-	case PRISM2_PARAM_MAX_RATECTRL_RATE:
-		ret = ieee80211_ioctl_max_ratectrl_rate(dev, sdata, value);
-		break;
-
-	case PRISM2_PARAM_RATE_CTRL_NUM_UP:
-		local->rate_ctrl_num_up = value;
-		break;
-
-	case PRISM2_PARAM_RATE_CTRL_NUM_DOWN:
-		local->rate_ctrl_num_down = value;
-		break;
-
 	case PRISM2_PARAM_TX_POWER_REDUCTION:
 		if (value < 0)
 			ret = -EINVAL;
@@ -2508,14 +2436,6 @@ static int ieee80211_ioctl_get_prism2_pa
 		*param = local->sta_antenna_sel;
 		break;
 
-	case PRISM2_PARAM_RATE_CTRL_NUM_UP:
-		*param = local->rate_ctrl_num_up;
-		break;
-
-	case PRISM2_PARAM_RATE_CTRL_NUM_DOWN:
-		*param = local->rate_ctrl_num_down;
-		break;
-
 	case PRISM2_PARAM_TX_POWER_REDUCTION:
 		*param = local->hw.conf.tx_power_reduction;
 		break;
--- wireless-dev.orig/net/mac80211/hostapd_ioctl.h	2007-06-22 09:59:14.248635409 +0200
+++ wireless-dev/net/mac80211/hostapd_ioctl.h	2007-06-22 09:59:21.618635409 +0200
@@ -48,10 +48,6 @@ enum {
 	PRISM2_PARAM_BROADCAST_SSID = 1015,
 	PRISM2_PARAM_STAT_TIME = 1016,
 	PRISM2_PARAM_STA_ANTENNA_SEL = 1017,
-	PRISM2_PARAM_FORCE_UNICAST_RATE = 1018,
-	PRISM2_PARAM_RATE_CTRL_NUM_UP = 1019,
-	PRISM2_PARAM_RATE_CTRL_NUM_DOWN = 1020,
-	PRISM2_PARAM_MAX_RATECTRL_RATE = 1021,
 	PRISM2_PARAM_TX_POWER_REDUCTION = 1022,
 	PRISM2_PARAM_EAPOL = 1023,
 	PRISM2_PARAM_KEY_TX_RX_THRESHOLD = 1024,
--- wireless-dev.orig/net/mac80211/ieee80211.c	2007-06-22 10:00:40.278635409 +0200
+++ wireless-dev/net/mac80211/ieee80211.c	2007-06-22 10:00:43.338635409 +0200
@@ -1243,8 +1243,6 @@ struct ieee80211_hw *ieee80211_alloc_hw(
 	local->short_retry_limit = 7;
 	local->long_retry_limit = 4;
 	local->hw.conf.radio_enabled = 1;
-	local->rate_ctrl_num_up = RATE_CONTROL_NUM_UP;
-	local->rate_ctrl_num_down = RATE_CONTROL_NUM_DOWN;
 
 	local->enabled_modes = (unsigned int) -1;
 
--- wireless-dev.orig/net/mac80211/ieee80211_i.h	2007-06-22 10:00:29.858635409 +0200
+++ wireless-dev/net/mac80211/ieee80211_i.h	2007-06-22 10:00:35.698635409 +0200
@@ -596,8 +596,6 @@ struct ieee80211_local {
 		STA_ANTENNA_SEL_SW_CTRL_DEBUG = 2
 	} sta_antenna_sel;
 
-	int rate_ctrl_num_up, rate_ctrl_num_down;
-
 #ifdef CONFIG_MAC80211_DEBUG_COUNTERS
 	/* TX/RX handler statistics */
 	unsigned int tx_handlers_drop;
--- wireless-dev.orig/net/mac80211/rc80211_simple.c	2007-06-22 10:00:55.488635409 +0200
+++ wireless-dev/net/mac80211/rc80211_simple.c	2007-06-22 10:01:29.218635409 +0200
@@ -187,9 +187,13 @@ static void rate_control_simple_tx_statu
 		}
 #endif
 
-		if (per_failed > local->rate_ctrl_num_down) {
+		/*
+		 * XXX: Make these configurable once we have an
+		 * interface to the rate control algorithms
+		 */
+		if (per_failed > RATE_CONTROL_NUM_DOWN) {
 			rate_control_rate_dec(local, sta);
-		} else if (per_failed < local->rate_ctrl_num_up) {
+		} else if (per_failed < RATE_CONTROL_NUM_UP) {
 			rate_control_rate_inc(local, sta);
 		}
 		srctrl->tx_avg_rate_sum += status->control.rate->rate;


