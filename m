Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:35975 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933071Ab1JEJ4P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Oct 2011 05:56:15 -0400
Received: by mail-ey0-f174.google.com with SMTP id 28so1405752eya.19
        for <linux-wireless@vger.kernel.org>; Wed, 05 Oct 2011 02:56:15 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 19/29] wl12xx: move some logic into wl12xx_init_vif_data
Date: Wed,  5 Oct 2011 11:55:56 +0200
Message-Id: <1317808566-18857-20-git-send-email-eliad@wizery.com> (sfid-20111005_115621_735644_D57C5CDB)
In-Reply-To: <1317808566-18857-1-git-send-email-eliad@wizery.com>
References: <1317808566-18857-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Initialize the vif data according to the vif type

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c |   66 ++++++++++++++++++++++--------------
 1 files changed, 40 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 8743885..0f13dd5 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -1854,20 +1854,52 @@ static u8 wl12xx_get_role_type(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 	return WL12XX_INVALID_ROLE_TYPE;
 }
 
-static void wl12xx_init_vif_data(struct wl12xx_vif *wlvif)
+static int wl12xx_init_vif_data(struct ieee80211_vif *vif)
 {
-	wlvif->bss_type = MAX_BSS_TYPE;
+	struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
+
+	/* make sure wlvif is zeroed */
+	memset(wlvif, 0, sizeof(*wlvif));
+
+	switch (ieee80211_vif_type_p2p(vif)) {
+	case NL80211_IFTYPE_P2P_CLIENT:
+		wlvif->p2p = 1;
+		/* fall-through */
+	case NL80211_IFTYPE_STATION:
+		wlvif->bss_type = BSS_TYPE_STA_BSS;
+		break;
+	case NL80211_IFTYPE_ADHOC:
+		wlvif->bss_type = BSS_TYPE_IBSS;
+		break;
+	case NL80211_IFTYPE_P2P_GO:
+		wlvif->p2p = 1;
+		/* fall-through */
+	case NL80211_IFTYPE_AP:
+		wlvif->bss_type = BSS_TYPE_AP_BSS;
+		break;
+	default:
+		wlvif->bss_type = MAX_BSS_TYPE;
+		return -EOPNOTSUPP;
+	}
+
 	wlvif->role_id = WL12XX_INVALID_ROLE_ID;
 	wlvif->dev_role_id = WL12XX_INVALID_ROLE_ID;
 
-	/* TODO: init union by type */
-	wlvif->sta.hlid = WL12XX_INVALID_LINK_ID;
-	wlvif->ap.bcast_hlid = WL12XX_INVALID_LINK_ID;
-	wlvif->ap.global_hlid = WL12XX_INVALID_LINK_ID;
+	if (wlvif->bss_type == BSS_TYPE_STA_BSS ||
+	    wlvif->bss_type == BSS_TYPE_IBSS) {
+		/* init sta/ibss data */
+		wlvif->sta.hlid = WL12XX_INVALID_LINK_ID;
+
+	} else {
+		/* init ap data */
+		wlvif->ap.bcast_hlid = WL12XX_INVALID_LINK_ID;
+		wlvif->ap.global_hlid = WL12XX_INVALID_LINK_ID;
+	}
 
 	wlvif->basic_rate_set = CONF_TX_RATE_MASK_BASIC;
 	wlvif->basic_rate = CONF_TX_RATE_MASK_BASIC;
 	wlvif->rate_set = CONF_TX_RATE_MASK_BASIC;
+	return 0;
 }
 
 static int wl1271_op_add_interface(struct ieee80211_hw *hw,
@@ -1891,7 +1923,6 @@ static int wl1271_op_add_interface(struct ieee80211_hw *hw,
 		ret = -EBUSY;
 		goto out;
 	}
-	wl12xx_init_vif_data(wlvif);
 
 	/*
 	 * in some very corner case HW recovery scenarios its possible to
@@ -1903,26 +1934,9 @@ static int wl1271_op_add_interface(struct ieee80211_hw *hw,
 		goto out;
 	}
 
-	switch (ieee80211_vif_type_p2p(vif)) {
-	case NL80211_IFTYPE_P2P_CLIENT:
-		wlvif->p2p = 1;
-		/* fall-through */
-	case NL80211_IFTYPE_STATION:
-		wlvif->bss_type = BSS_TYPE_STA_BSS;
-		break;
-	case NL80211_IFTYPE_ADHOC:
-		wlvif->bss_type = BSS_TYPE_IBSS;
-		break;
-	case NL80211_IFTYPE_P2P_GO:
-		wlvif->p2p = 1;
-		/* fall-through */
-	case NL80211_IFTYPE_AP:
-		wlvif->bss_type = BSS_TYPE_AP_BSS;
-		break;
-	default:
-		ret = -EOPNOTSUPP;
+	ret = wl12xx_init_vif_data(vif);
+	if (ret < 0)
 		goto out;
-	}
 
 	role_type = wl12xx_get_role_type(wl, wlvif);
 	if (role_type == WL12XX_INVALID_ROLE_TYPE) {
-- 
1.7.6.401.g6a319

