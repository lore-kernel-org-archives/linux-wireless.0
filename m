Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41414 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934218Ab1JEJz5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Oct 2011 05:55:57 -0400
Received: by mail-bw0-f46.google.com with SMTP id zt4so1903568bkb.19
        for <linux-wireless@vger.kernel.org>; Wed, 05 Oct 2011 02:55:56 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 09/29] wl12xx: remove set_bss_type field
Date: Wed,  5 Oct 2011 11:55:46 +0200
Message-Id: <1317808566-18857-10-git-send-email-eliad@wizery.com> (sfid-20111005_115601_124687_F26E688D)
In-Reply-To: <1317808566-18857-1-git-send-email-eliad@wizery.com>
References: <1317808566-18857-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

set_bss_type is no longer evaluated, so delete it.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c   |    8 --------
 drivers/net/wireless/wl12xx/wl12xx.h |    1 -
 2 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index fd14cdd..f57a133 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -1894,11 +1894,9 @@ static int wl1271_op_add_interface(struct ieee80211_hw *hw,
 		/* fall-through */
 	case NL80211_IFTYPE_STATION:
 		wlvif->bss_type = BSS_TYPE_STA_BSS;
-		wl->set_bss_type = BSS_TYPE_STA_BSS;
 		break;
 	case NL80211_IFTYPE_ADHOC:
 		wlvif->bss_type = BSS_TYPE_IBSS;
-		wl->set_bss_type = BSS_TYPE_STA_BSS;
 		break;
 	case NL80211_IFTYPE_P2P_GO:
 		wl->p2p = 1;
@@ -2107,7 +2105,6 @@ deinit:
 
 	memset(wl->ssid, 0, IEEE80211_MAX_SSID_LEN + 1);
 	wl->ssid_len = 0;
-	wl->set_bss_type = MAX_BSS_TYPE;
 	wl->p2p = 0;
 	wl->band = IEEE80211_BAND_2GHZ;
 
@@ -3434,10 +3431,6 @@ static void wl1271_bss_info_changed_sta(struct wl1271 *wl,
 		wl1271_debug(DEBUG_ADHOC, "ad-hoc beaconing: %s",
 			     bss_conf->enable_beacon ? "enabled" : "disabled");
 
-		if (bss_conf->enable_beacon)
-			wl->set_bss_type = BSS_TYPE_IBSS;
-		else
-			wl->set_bss_type = BSS_TYPE_STA_BSS;
 		do_join = true;
 	}
 
@@ -4817,7 +4810,6 @@ struct ieee80211_hw *wl1271_alloc_hw(void)
 	wl->flags = 0;
 	wl->sg_enabled = true;
 	wl->hw_pg_ver = -1;
-	wl->set_bss_type = MAX_BSS_TYPE;
 	wl->last_tx_hlid = 0;
 	wl->ap_ps_map = 0;
 	wl->ap_fw_ps_map = 0;
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index e38fba1..6269c08 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -399,7 +399,6 @@ struct wl1271 {
 	s8 hw_pg_ver;
 
 	u8 mac_addr[ETH_ALEN];
-	u8 set_bss_type;
 	u8 p2p; /* we are using p2p role */
 	u8 ssid[IEEE80211_MAX_SSID_LEN + 1];
 	u8 ssid_len;
-- 
1.7.6.401.g6a319

