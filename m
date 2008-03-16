Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:60552 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752010AbYCPRnA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Mar 2008 13:43:00 -0400
Subject: [PATCH] mac80211: filter scan results on unusable channels
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Jes Sorensen <jes@trained-monkey.org>
Content-Type: text/plain
Date: Sun, 16 Mar 2008 18:42:44 +0100
Message-Id: <1205689364.3878.9.camel@johannes.berg> (sfid-20080316_174323_828972_9EC216B1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When you have an AP on channel 13, it will currently often enough
be listed in scan results even when the regulatory domain restricts
to channels 1-11. This is due to channel overlap. To avoid getting
very strange failures, don't show such APs in the scan results. The
failure mode will now go from "I can see the AP but not associate"
to "I can't see the AP although I know it's there" which is easier
to debug.

This problem was first really noticed by Jes Sorensen.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Cc: Jes Sorensen <jes@trained-monkey.org>
---
Depends on the previous patch adding the ieee80211_get_channel function.

 net/mac80211/ieee80211_sta.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- everything.orig/net/mac80211/ieee80211_sta.c	2008-03-16 18:17:24.000000000 +0100
+++ everything/net/mac80211/ieee80211_sta.c	2008-03-16 18:37:27.000000000 +0100
@@ -2356,6 +2356,7 @@ static void ieee80211_rx_bss_info(struct
 	struct sta_info *sta;
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	u64 beacon_timestamp, rx_timestamp;
+	struct ieee80211_channel *channel;
 	DECLARE_MAC_BUF(mac);
 	DECLARE_MAC_BUF(mac2);
 
@@ -2420,6 +2421,11 @@ static void ieee80211_rx_bss_info(struct
 	else
 		freq = rx_status->freq;
 
+	channel = ieee80211_get_channel(local->hw.wiphy, freq);
+
+	if (!channel || channel->flags & IEEE80211_CHAN_DISABLED)
+		return;
+
 #ifdef CONFIG_MAC80211_MESH
 	if (elems.mesh_config)
 		bss = ieee80211_rx_mesh_bss_get(dev, elems.mesh_id,


