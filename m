Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:58269 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754562Ab0G2Pgv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Jul 2010 11:36:51 -0400
Message-ID: <4C51A00B.3020200@openwrt.org>
Date: Thu, 29 Jul 2010 17:36:43 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH] mac80211: fix driver offchannel notification when the channel
 does not change
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When running in client mode and associating to an AP, the channel
change is usually performed with the offchannel flag still set.
However after the assoc is complete, the following channel change event
is suppressed because the run time channel is already set to the operating channel.
Fix this by sending channel change notifications to the driver even if
only the offchannel flag changes.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -103,11 +103,13 @@ int ieee80211_hw_config(struct ieee80211
 	int ret = 0;
 	int power;
 	enum nl80211_channel_type channel_type;
+	u32 offchannel_flag;
 
 	might_sleep();
 
 	scan_chan = local->scan_channel;
 
+	offchannel_flag = local->hw.conf.flags & IEEE80211_CONF_OFFCHANNEL;
 	if (scan_chan) {
 		chan = scan_chan;
 		channel_type = NL80211_CHAN_NO_HT;
@@ -121,8 +123,9 @@ int ieee80211_hw_config(struct ieee80211
 		channel_type = local->_oper_channel_type;
 		local->hw.conf.flags &= ~IEEE80211_CONF_OFFCHANNEL;
 	}
+	offchannel_flag ^= local->hw.conf.flags & IEEE80211_CONF_OFFCHANNEL;
 
-	if (chan != local->hw.conf.channel ||
+	if (offchannel_flag || chan != local->hw.conf.channel ||
 	    channel_type != local->hw.conf.channel_type) {
 		local->hw.conf.channel = chan;
 		local->hw.conf.channel_type = channel_type;
