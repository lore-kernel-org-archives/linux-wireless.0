Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp03.msg.oleane.net ([62.161.4.3]:39591 "EHLO
	smtp03.msg.oleane.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932544AbbESJr3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 May 2015 05:47:29 -0400
Received: from acksys.fr ([195.6.104.67]) (authenticated)
	by smtp03.msg.oleane.net (MTA) with ESMTP id t4J9lRfA010493
	for <linux-wireless@vger.kernel.org>; Tue, 19 May 2015 11:47:27 +0200
Subject: [RFC v2] ath9k: allow up to 8 access point vifs on DFS channels
Date: Tue, 19 May 2015 11:47:26 +0200
Message-ID: <773DB8A82AB6A046AE0195C68612A31901A71B59@sbs2003.acksys.local> (sfid-20150519_114740_140509_AE3E30C9)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
From: "Jean-Pierre TOSONI" <jp.tosoni@acksys.fr>
To: <linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Allow the combination of 8 (AP + mesh) interfaces on radar channels

Tested with hostapd, 2 and 8 BSSIDs, 1 or 2 DFS channels, BW 20 MHz
TODO: test AP+mesh combination
TODO: test 40 MHz BW
---
This patch was done with quilt on Openwrt against compat-wireless
2014-11-04

--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -723,6 +723,14 @@ static const struct ieee80211_iface_limi
 				 BIT(NL80211_IFTYPE_ADHOC) },
 };
 
+static const struct ieee80211_iface_limit if_dfs_limits_mvap[] = {
+	{ .max = 8,	.types =
+#ifdef CONFIG_MAC80211_MESH
+				 BIT(NL80211_IFTYPE_MESH_POINT) |
+#endif
+				 BIT(NL80211_IFTYPE_AP) },
+};
+
 static const struct ieee80211_iface_combination if_comb[] = {
 	{
 		.limits = if_limits,
@@ -746,6 +754,16 @@ static const struct ieee80211_iface_comb
 		.num_different_channels = 1,
 		.beacon_int_infra_match = true,
 		.radar_detect_widths =	BIT(NL80211_CHAN_WIDTH_20_NOHT)
|
+					BIT(NL80211_CHAN_WIDTH_20) |
+					BIT(NL80211_CHAN_WIDTH_40),
+	},
+	{
+		.limits = if_dfs_limits_mvap,
+		.n_limits = ARRAY_SIZE(if_dfs_limits_mvap),
+		.max_interfaces = 8,
+		.num_different_channels = 1,
+		.beacon_int_infra_match = true,
+		.radar_detect_widths =	BIT(NL80211_CHAN_WIDTH_20_NOHT)
|
 					BIT(NL80211_CHAN_WIDTH_20) |
 					BIT(NL80211_CHAN_WIDTH_40),
 	}
-- 
quilt

