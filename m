Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40731 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752380AbYIFUFw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Sep 2008 16:05:52 -0400
Subject: [PATCH] mac80211: BSS info: check channel first
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 06 Sep 2008 22:05:49 +0200
Message-Id: <1220731549.10102.18.camel@johannes.berg> (sfid-20080906_220555_416927_E644579A)
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

--- everything.orig/net/mac80211/mlme.c	2008-09-06 21:43:57.000000000 +0200
+++ everything/net/mac80211/mlme.c	2008-09-06 21:53:11.000000000 +0200
@@ -2430,7 +2430,15 @@ static void ieee80211_rx_bss_info(struct
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
@@ -2473,16 +2481,6 @@ static void ieee80211_rx_bss_info(struct
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
@@ -2551,6 +2549,8 @@ static void ieee80211_rx_bss_info(struct
 
 	bss->band = band;
 
+	beacon_timestamp = le64_to_cpu(mgmt->u.beacon.timestamp);
+
 	bss->timestamp = beacon_timestamp;
 	bss->last_update = jiffies;
 	bss->signal = rx_status->signal;


