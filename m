Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.238]:1639 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987AbYKAGXg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Nov 2008 02:23:36 -0400
Received: by rv-out-0506.google.com with SMTP id k40so1628861rvb.1
        for <linux-wireless@vger.kernel.org>; Fri, 31 Oct 2008 23:23:36 -0700 (PDT)
To: linux-wireless@vger.kernel.org
From: Andrey Yurovsky <andrey@cozybit.com>
Subject: [PATCH] mac80211_hwsim: enable Mesh Point operation
Date: Fri, 31 Oct 2008 23:23:35 -0700 (PDT)
Message-ID: <490bf5e7.2a528c0a.3951.19a9@mx.google.com> (sfid-20081101_072403_704359_64603084)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Initial mesh support: add Mesh Point to supported interfaces mask and allow 
hwsim to send beacons in mesh mode.

Signed-off-by: Andrey Yurovsky <andrey@cozybit.com>
diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 430d8b1..34f643f 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -370,7 +370,8 @@ static void mac80211_hwsim_beacon_tx(void *arg, u8 *mac,
 
 	hwsim_check_magic(vif);
 
-	if (vif->type != NL80211_IFTYPE_AP)
+	if (vif->type != NL80211_IFTYPE_AP && vif->type !=
+			NL80211_IFTYPE_MESH_POINT)
 		return;
 
 	skb = ieee80211_beacon_get(hw, vif);
@@ -777,7 +778,8 @@ static int __init init_mac80211_hwsim(void)
 		hw->queues = 4;
 		hw->wiphy->interface_modes =
 			BIT(NL80211_IFTYPE_STATION) |
-			BIT(NL80211_IFTYPE_AP);
+			BIT(NL80211_IFTYPE_AP) |
+			BIT(NL80211_IFTYPE_MESH_POINT);
 		hw->ampdu_queues = 1;
 
 		/* ask mac80211 to reserve space for magic */


