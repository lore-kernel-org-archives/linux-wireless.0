Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp26.msg.oleane.net ([62.161.4.26]:45618 "EHLO
	smtp26.msg.oleane.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933298AbbFIQ0k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jun 2015 12:26:40 -0400
Received: from acksys.fr ([195.6.104.67]) (authenticated)
	by smtp26.msg.oleane.net (MTA) with ESMTP id t59GQb2U006351
	for <linux-wireless@vger.kernel.org>; Tue, 9 Jun 2015 18:26:37 +0200
Subject: [RFC v2] [resend] ath9k: allow up to 8 access point vifs on DFS channels
Date: Tue, 9 Jun 2015 18:26:37 +0200
MIME-Version: 1.0
Message-ID: <773DB8A82AB6A046AE0195C68612A31901A720F6@sbs2003.acksys.local> (sfid-20150609_182651_487732_CD0F89DD)
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

Any feedback?

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

