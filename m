Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:59144 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850Ab1H1MVd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Aug 2011 08:21:33 -0400
Received: by wwe5 with SMTP id 5so1682747wwe.1
        for <linux-wireless@vger.kernel.org>; Sun, 28 Aug 2011 05:21:32 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] wl12xx: support p2p interfaces
Date: Sun, 28 Aug 2011 15:23:01 +0300
Message-Id: <1314534181-27200-1-git-send-email-eliad@wizery.com> (sfid-20110828_142142_021743_D5B25F8C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Declare support for p2p interfaces, and create p2p_cli/p2p_go
roles when being asked for.

Indicate we are using a p2p interface by setting the wl->p2p flag.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c   |   24 +++++++++++++++++++-----
 drivers/net/wireless/wl12xx/wl12xx.h |    1 +
 2 files changed, 20 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index aeb4cc5..32103b4 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -1820,10 +1820,16 @@ static u8 wl12xx_get_role_type(struct wl1271 *wl)
 {
 	switch (wl->bss_type) {
 	case BSS_TYPE_AP_BSS:
-		return WL1271_ROLE_AP;
+		if (wl->p2p)
+			return WL1271_ROLE_P2P_GO;
+		else
+			return WL1271_ROLE_AP;
 
 	case BSS_TYPE_STA_BSS:
-		return WL1271_ROLE_STA;
+		if (wl->p2p)
+			return WL1271_ROLE_P2P_CL;
+		else
+			return WL1271_ROLE_STA;
 
 	case BSS_TYPE_IBSS:
 		return WL1271_ROLE_IBSS;
@@ -1845,7 +1851,7 @@ static int wl1271_op_add_interface(struct ieee80211_hw *hw,
 	bool booted = false;
 
 	wl1271_debug(DEBUG_MAC80211, "mac80211 add interface type %d mac %pM",
-		     vif->type, vif->addr);
+		     ieee80211_vif_type_p2p(vif), vif->addr);
 
 	mutex_lock(&wl->mutex);
 	if (wl->vif) {
@@ -1865,7 +1871,10 @@ static int wl1271_op_add_interface(struct ieee80211_hw *hw,
 		goto out;
 	}
 
-	switch (vif->type) {
+	switch (ieee80211_vif_type_p2p(vif)) {
+	case NL80211_IFTYPE_P2P_CLIENT:
+		wl->p2p = 1;
+		/* fall-through */
 	case NL80211_IFTYPE_STATION:
 		wl->bss_type = BSS_TYPE_STA_BSS;
 		wl->set_bss_type = BSS_TYPE_STA_BSS;
@@ -1874,6 +1883,9 @@ static int wl1271_op_add_interface(struct ieee80211_hw *hw,
 		wl->bss_type = BSS_TYPE_IBSS;
 		wl->set_bss_type = BSS_TYPE_STA_BSS;
 		break;
+	case NL80211_IFTYPE_P2P_GO:
+		wl->p2p = 1;
+		/* fall-through */
 	case NL80211_IFTYPE_AP:
 		wl->bss_type = BSS_TYPE_AP_BSS;
 		break;
@@ -2069,6 +2081,7 @@ deinit:
 	wl->ssid_len = 0;
 	wl->bss_type = MAX_BSS_TYPE;
 	wl->set_bss_type = MAX_BSS_TYPE;
+	wl->p2p = 0;
 	wl->band = IEEE80211_BAND_2GHZ;
 
 	wl->rx_counter = 0;
@@ -4507,7 +4520,8 @@ int wl1271_init_ieee80211(struct wl1271 *wl)
 	wl->hw->wiphy->n_cipher_suites = ARRAY_SIZE(cipher_suites);
 
 	wl->hw->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION) |
-		BIT(NL80211_IFTYPE_ADHOC) | BIT(NL80211_IFTYPE_AP);
+		BIT(NL80211_IFTYPE_ADHOC) | BIT(NL80211_IFTYPE_AP) |
+		BIT(NL80211_IFTYPE_P2P_CLIENT) | BIT(NL80211_IFTYPE_P2P_GO);
 	wl->hw->wiphy->max_scan_ssids = 1;
 	wl->hw->wiphy->max_sched_scan_ssids = 8;
 	/*
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index fb2753c..64ffb61 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -402,6 +402,7 @@ struct wl1271 {
 	u8 mac_addr[ETH_ALEN];
 	u8 bss_type;
 	u8 set_bss_type;
+	u8 p2p; /* we are using p2p role */
 	u8 ssid[IEEE80211_MAX_SSID_LEN + 1];
 	u8 ssid_len;
 	int channel;
-- 
1.7.6.401.g6a319

