Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:34715 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756767AbYJGQ6Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Oct 2008 12:58:16 -0400
Message-Id: <20081007100442.742530000@sipsolutions.net> (sfid-20081007_185822_562272_C30C595D)
References: <20081007100428.868688000@sipsolutions.net>
Date: Tue, 07 Oct 2008 12:04:35 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 7/8] mac80211: remove max_antenna_gain config
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The antenna gain isn't exactly configurable, despite the belief of
some unnamed individual who thinks that the EEPROM might influence
it.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/net/mac80211.h |    2 --
 net/mac80211/main.c    |    2 --
 2 files changed, 4 deletions(-)

--- everything.orig/include/net/mac80211.h	2008-10-07 11:27:02.000000000 +0200
+++ everything/include/net/mac80211.h	2008-10-07 11:27:04.000000000 +0200
@@ -456,7 +456,6 @@ enum ieee80211_conf_flags {
  * @listen_interval: listen interval in units of beacon interval
  * @flags: configuration flags defined above
  * @power_level: requested transmit power (in dBm)
- * @max_antenna_gain: maximum antenna gain (in dBi)
  * @antenna_sel_tx: transmit antenna selection, 0: default/diversity,
  *	1/2: antenna 0/1
  * @antenna_sel_rx: receive antenna selection, like @antenna_sel_tx
@@ -471,7 +470,6 @@ struct ieee80211_conf {
 	u16 listen_interval;
 	u32 flags;
 	int power_level;
-	int max_antenna_gain;
 	u8 antenna_sel_tx;
 	u8 antenna_sel_rx;
 
--- everything.orig/net/mac80211/main.c	2008-10-07 11:27:02.000000000 +0200
+++ everything/net/mac80211/main.c	2008-10-07 11:27:04.000000000 +0200
@@ -215,8 +215,6 @@ int ieee80211_hw_config(struct ieee80211
 		local->hw.conf.power_level = min(chan->max_power,
 					       local->hw.conf.power_level);
 
-	local->hw.conf.max_antenna_gain = chan->max_antenna_gain;
-
 #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
 	printk(KERN_DEBUG "%s: HW CONFIG: freq=%d\n",
 	       wiphy_name(local->hw.wiphy), chan->center_freq);

-- 

