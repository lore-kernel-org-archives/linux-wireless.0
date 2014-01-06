Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:42981 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099AbaAFPD5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jan 2014 10:03:57 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: ZHAO Gang <gamerh2o@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: fix memory leak in register_hw() error path
Date: Mon,  6 Jan 2014 16:03:53 +0100
Message-Id: <1389020633-32021-1-git-send-email-johannes@sipsolutions.net> (sfid-20140106_160400_698237_83451B57)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Move the internal scan request allocation below the last
sanity check in ieee80211_register_hw() to avoid leaking
memory if the sanity check actually triggers.

Reported-by: ZHAO Gang <gamerh2o@gmail.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/main.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 2bd5b55..d767cfb 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -846,17 +846,6 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 		/* TODO: consider VHT for RX chains, hopefully it's the same */
 	}
 
-	local->int_scan_req = kzalloc(sizeof(*local->int_scan_req) +
-				      sizeof(void *) * channels, GFP_KERNEL);
-	if (!local->int_scan_req)
-		return -ENOMEM;
-
-	for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
-		if (!local->hw.wiphy->bands[band])
-			continue;
-		local->int_scan_req->rates[band] = (u32) -1;
-	}
-
 	/* if low-level driver supports AP, we also support VLAN */
 	if (local->hw.wiphy->interface_modes & BIT(NL80211_IFTYPE_AP)) {
 		hw->wiphy->interface_modes |= BIT(NL80211_IFTYPE_AP_VLAN);
@@ -880,6 +869,17 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 				return -EINVAL;
 	}
 
+	local->int_scan_req = kzalloc(sizeof(*local->int_scan_req) +
+				      sizeof(void *) * channels, GFP_KERNEL);
+	if (!local->int_scan_req)
+		return -ENOMEM;
+
+	for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
+		if (!local->hw.wiphy->bands[band])
+			continue;
+		local->int_scan_req->rates[band] = (u32) -1;
+	}
+
 #ifndef CONFIG_MAC80211_MESH
 	/* mesh depends on Kconfig, but drivers should set it if they want */
 	local->hw.wiphy->interface_modes &= ~BIT(NL80211_IFTYPE_MESH_POINT);
-- 
1.8.5.1

