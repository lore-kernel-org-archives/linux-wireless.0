Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:43752 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754417Ab0AQTzx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Jan 2010 14:55:53 -0500
Message-ID: <4B536B45.7000903@openwrt.org>
Date: Sun, 17 Jan 2010 20:55:49 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
CC: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 2/2] mac80211: implement the callback for querying the operating
 frequency
References: <4B536B05.6070301@openwrt.org>
In-Reply-To: <4B536B05.6070301@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1154,6 +1154,18 @@ static int ieee80211_set_txq_params(stru
 	return 0;
 }
 
+static int ieee80211_get_oper_channel(struct wiphy *wiphy,
+				 struct ieee80211_channel **chan,
+				 enum nl80211_channel_type *channel_type)
+{
+	struct ieee80211_local *local = wiphy_priv(wiphy);
+
+	*chan = local->oper_channel;
+	*channel_type = local->oper_channel_type;
+
+	return 0;
+}
+
 static int ieee80211_set_channel(struct wiphy *wiphy,
 				 struct ieee80211_channel *chan,
 				 enum nl80211_channel_type channel_type)
@@ -1494,6 +1506,7 @@ struct cfg80211_ops mac80211_config_ops 
 #endif
 	.change_bss = ieee80211_change_bss,
 	.set_txq_params = ieee80211_set_txq_params,
+	.get_channel = ieee80211_get_oper_channel,
 	.set_channel = ieee80211_set_channel,
 	.suspend = ieee80211_suspend,
 	.resume = ieee80211_resume,
