Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54689 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975AbYIHJIN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Sep 2008 05:08:13 -0400
Message-Id: <20080908090635.149921000@sipsolutions.net> (sfid-20080908_110816_332644_D0E18CDC)
References: <20080908090507.641740000@sipsolutions.net>
Date: Mon, 08 Sep 2008 11:05:10 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 3/3] mac80211: BSS info: check channel first
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When we receive information about a BSS we check at some point
whether or not we think we're allowed to use the channel it is
on, but we do that fairly late. I don't think we should do it
that late, so do it earlier to avoid doing IBSS/mesh stuff on
that channel and then getting confused because it's disabled.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/mlme.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

--- everything.orig/net/mac80211/mlme.c	2008-09-08 10:21:17.000000000 +0200
+++ everything/net/mac80211/mlme.c	2008-09-08 10:21:25.000000000 +0200
@@ -2603,7 +2603,15 @@ static void ieee80211_rx_bss_info(struct
 	DECLARE_MAC_BUF(mac);
 	DECLARE_MAC_BUF(mac2);
 
-	beacon_timestamp = le64_to_cpu(mgmt->u.beacon.timestamp);
+	if (elems->ds_params && elems->ds_params_len == 1)
+		freq = ieee80211_channel_to_frequency(elems->ds_params[0]);
+	else
+		freq = rx_status->freq;
+
+	channel = ieee80211_get_channel(local->hw.wiphy, freq);
+
+	if (!channel || channel->flags & IEEE80211_CHAN_DISABLED)
+		return;
 
 	if (ieee80211_vif_is_mesh(&sdata->vif) && elems->mesh_id &&
 	    elems->mesh_config && mesh_matches_local(elems, sdata)) {
@@ -2646,16 +2654,6 @@ static void ieee80211_rx_bss_info(struct
 		rcu_read_unlock();
 	}
 
-	if (elems->ds_params && elems->ds_params_len == 1)
-		freq = ieee80211_channel_to_frequency(elems->ds_params[0]);
-	else
-		freq = rx_status->freq;
-
-	channel = ieee80211_get_channel(local->hw.wiphy, freq);
-
-	if (!channel || channel->flags & IEEE80211_CHAN_DISABLED)
-		return;
-
 #ifdef CONFIG_MAC80211_MESH
 	if (elems->mesh_config)
 		bss = ieee80211_rx_mesh_bss_get(local, elems->mesh_id,
@@ -2724,6 +2722,8 @@ static void ieee80211_rx_bss_info(struct
 
 	bss->band = band;
 
+	beacon_timestamp = le64_to_cpu(mgmt->u.beacon.timestamp);
+
 	bss->timestamp = beacon_timestamp;
 	bss->last_update = jiffies;
 	bss->signal = rx_status->signal;

-- 

