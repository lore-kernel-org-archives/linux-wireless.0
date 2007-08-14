Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:57215 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759014AbXHNLtU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Aug 2007 07:49:20 -0400
Message-Id: <20070814092446.472482000@sipsolutions.net>
References: <20070814092008.627058000@sipsolutions.net>
Date: Tue, 14 Aug 2007 11:20:20 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Jiri Benc <jbenc@suse.cz>, Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 12/13] mac80211: remove PRISM2_PARAM_NEXT_MODE
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is now unused in hostapd/wpa_supplicant.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/hostapd_ioctl.h   |    1 -
 net/mac80211/ieee80211_i.h     |    5 -----
 net/mac80211/ieee80211_ioctl.c |   13 -------------
 3 files changed, 19 deletions(-)

--- wireless-dev.orig/net/mac80211/hostapd_ioctl.h	2007-08-14 00:27:33.885589257 +0200
+++ wireless-dev/net/mac80211/hostapd_ioctl.h	2007-08-14 00:27:34.505589257 +0200
@@ -34,7 +34,6 @@ enum {
 	PRISM2_PARAM_CTS_PROTECT_ERP_FRAMES = 1001,
 	PRISM2_PARAM_PREAMBLE = 1003,
 	PRISM2_PARAM_SHORT_SLOT_TIME = 1006,
-	PRISM2_PARAM_NEXT_MODE = 1008,
 	PRISM2_PARAM_PRIVACY_INVOKED = 1014,
 	PRISM2_PARAM_BROADCAST_SSID = 1015,
 	PRISM2_PARAM_EAPOL = 1023,
--- wireless-dev.orig/net/mac80211/ieee80211_i.h	2007-08-14 00:27:33.255589257 +0200
+++ wireless-dev/net/mac80211/ieee80211_i.h	2007-08-14 00:27:34.505589257 +0200
@@ -501,11 +501,6 @@ struct ieee80211_local {
 
 	struct rate_control_ref *rate_ctrl;
 
-	int next_mode; /* MODE_IEEE80211*
-			* The mode preference for next channel change. This is
-			* used to select .11g vs. .11b channels (or 4.9 GHz vs.
-			* .11a) when the channel number is not unique. */
-
 	/* Supported and basic rate filters for different modes. These are
 	 * pointers to -1 terminated lists and rates in 100 kbps units. */
 	int *supp_rates[NUM_IEEE80211_MODES];
--- wireless-dev.orig/net/mac80211/ieee80211_ioctl.c	2007-08-14 00:27:33.885589257 +0200
+++ wireless-dev/net/mac80211/ieee80211_ioctl.c	2007-08-14 00:27:34.515589257 +0200
@@ -1270,11 +1270,6 @@ int ieee80211_set_channel(struct ieee802
 			struct ieee80211_channel *chan = &mode->channels[c];
 			if (chan->flag & IEEE80211_CHAN_W_SCAN &&
 			    ((chan->chan == channel) || (chan->freq == freq))) {
-				/* Use next_mode as the mode preference to
-				 * resolve non-unique channel numbers. */
-				if (set && mode->mode != local->next_mode)
-					continue;
-
 				local->oper_channel = chan;
 				local->oper_hw_mode = mode;
 				set++;
@@ -1885,10 +1880,6 @@ static int ieee80211_ioctl_prism2_param(
 					local_to_hw(local), value);
 		break;
 
-	case PRISM2_PARAM_NEXT_MODE:
-		local->next_mode = value;
-		break;
-
 	case PRISM2_PARAM_BROADCAST_SSID:
 		if ((value < 0) || (value > 1))
 			ret = -EINVAL;
@@ -1961,10 +1952,6 @@ static int ieee80211_ioctl_get_prism2_pa
 		*param = !!(local->hw.conf.flags & IEEE80211_CONF_SHORT_SLOT_TIME);
 		break;
 
-	case PRISM2_PARAM_NEXT_MODE:
-		*param = local->next_mode;
-		break;
-
 	case PRISM2_PARAM_BROADCAST_SSID:
 		*param = !!(local->hw.conf.flags & IEEE80211_CONF_SSID_HIDDEN);
 		break;

-- 

