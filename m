Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:61401 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932963Ab1JEJ7Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Oct 2011 05:59:25 -0400
Received: by wwf22 with SMTP id 22so2268431wwf.1
        for <linux-wireless@vger.kernel.org>; Wed, 05 Oct 2011 02:59:24 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 10/29] wl12xx: move p2p into wlvif
Date: Wed,  5 Oct 2011 11:55:47 +0200
Message-Id: <1317808566-18857-11-git-send-email-eliad@wizery.com> (sfid-20111005_121655_597205_B77E74C6)
In-Reply-To: <1317808566-18857-1-git-send-email-eliad@wizery.com>
References: <1317808566-18857-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

move p2p field into the per-interface data, rather than
being global.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c   |    9 ++++-----
 drivers/net/wireless/wl12xx/wl12xx.h |    2 +-
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index f57a133..28e53a9 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -1827,13 +1827,13 @@ static u8 wl12xx_get_role_type(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 {
 	switch (wlvif->bss_type) {
 	case BSS_TYPE_AP_BSS:
-		if (wl->p2p)
+		if (wlvif->p2p)
 			return WL1271_ROLE_P2P_GO;
 		else
 			return WL1271_ROLE_AP;
 
 	case BSS_TYPE_STA_BSS:
-		if (wl->p2p)
+		if (wlvif->p2p)
 			return WL1271_ROLE_P2P_CL;
 		else
 			return WL1271_ROLE_STA;
@@ -1890,7 +1890,7 @@ static int wl1271_op_add_interface(struct ieee80211_hw *hw,
 
 	switch (ieee80211_vif_type_p2p(vif)) {
 	case NL80211_IFTYPE_P2P_CLIENT:
-		wl->p2p = 1;
+		wlvif->p2p = 1;
 		/* fall-through */
 	case NL80211_IFTYPE_STATION:
 		wlvif->bss_type = BSS_TYPE_STA_BSS;
@@ -1899,7 +1899,7 @@ static int wl1271_op_add_interface(struct ieee80211_hw *hw,
 		wlvif->bss_type = BSS_TYPE_IBSS;
 		break;
 	case NL80211_IFTYPE_P2P_GO:
-		wl->p2p = 1;
+		wlvif->p2p = 1;
 		/* fall-through */
 	case NL80211_IFTYPE_AP:
 		wlvif->bss_type = BSS_TYPE_AP_BSS;
@@ -2105,7 +2105,6 @@ deinit:
 
 	memset(wl->ssid, 0, IEEE80211_MAX_SSID_LEN + 1);
 	wl->ssid_len = 0;
-	wl->p2p = 0;
 	wl->band = IEEE80211_BAND_2GHZ;
 
 	wl->rx_counter = 0;
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index 6269c08..61f3658 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -399,7 +399,6 @@ struct wl1271 {
 	s8 hw_pg_ver;
 
 	u8 mac_addr[ETH_ALEN];
-	u8 p2p; /* we are using p2p role */
 	u8 ssid[IEEE80211_MAX_SSID_LEN + 1];
 	u8 ssid_len;
 	int channel;
@@ -628,6 +627,7 @@ struct wl1271_station {
 
 struct wl12xx_vif {
 	u8 bss_type;
+	u8 p2p; /* we are using p2p role */
 
 	u32 basic_rate_set;
 
-- 
1.7.6.401.g6a319

