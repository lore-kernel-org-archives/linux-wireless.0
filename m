Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56119 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752581AbYJ1ShX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Oct 2008 14:37:23 -0400
Subject: [PATCH] b43/legacy: remove SSID code
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Michael Buesch <mb@bu3sch.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 28 Oct 2008 18:29:48 +0100
Message-Id: <1225214988.3598.30.camel@johannes.berg> (sfid-20081028_193726_284705_964B5162)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The SSID programmed into the device is used by the ucode only
to reply to probe requests, a functionality we disable anyway
because it doesn't fit with the mac80211/hostapd programming
model. Therefore, it isn't useful to program the SSID into
device.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/net/wireless/b43/main.c       |   21 ---------------------
 drivers/net/wireless/b43legacy/main.c |   24 ------------------------
 2 files changed, 45 deletions(-)

--- everything.orig/drivers/net/wireless/b43/main.c	2008-10-28 18:26:31.000000000 +0100
+++ everything/drivers/net/wireless/b43/main.c	2008-10-28 18:27:13.000000000 +0100
@@ -1674,25 +1674,6 @@ static void b43_update_templates(struct 
 	queue_work(wl->hw->workqueue, &wl->beacon_update_trigger);
 }
 
-static void b43_set_ssid(struct b43_wldev *dev, const u8 * ssid, u8 ssid_len)
-{
-	u32 tmp;
-	u16 i, len;
-
-	len = min((u16) ssid_len, (u16) 0x100);
-	for (i = 0; i < len; i += sizeof(u32)) {
-		tmp = (u32) (ssid[i + 0]);
-		if (i + 1 < len)
-			tmp |= (u32) (ssid[i + 1]) << 8;
-		if (i + 2 < len)
-			tmp |= (u32) (ssid[i + 2]) << 16;
-		if (i + 3 < len)
-			tmp |= (u32) (ssid[i + 3]) << 24;
-		b43_shm_write32(dev, B43_SHM_SHARED, 0x380 + i, tmp);
-	}
-	b43_shm_write16(dev, B43_SHM_SHARED, 0x48, len);
-}
-
 static void b43_set_beacon_int(struct b43_wldev *dev, u16 beacon_int)
 {
 	b43_time_lock(dev);
@@ -3603,8 +3584,6 @@ static int b43_op_config_interface(struc
 		if (b43_is_mode(wl, NL80211_IFTYPE_AP) ||
 		    b43_is_mode(wl, NL80211_IFTYPE_MESH_POINT)) {
 			B43_WARN_ON(vif->type != wl->if_type);
-			if (conf->changed & IEEE80211_IFCC_SSID)
-				b43_set_ssid(dev, conf->ssid, conf->ssid_len);
 			if (conf->changed & IEEE80211_IFCC_BEACON)
 				b43_update_templates(wl);
 		} else if (b43_is_mode(wl, NL80211_IFTYPE_ADHOC)) {
--- everything.orig/drivers/net/wireless/b43legacy/main.c	2008-10-28 18:26:31.000000000 +0100
+++ everything/drivers/net/wireless/b43legacy/main.c	2008-10-28 18:27:23.000000000 +0100
@@ -1160,29 +1160,6 @@ static void b43legacy_update_templates(s
 	wl->beacon1_uploaded = 0;
 }
 
-static void b43legacy_set_ssid(struct b43legacy_wldev *dev,
-			       const u8 *ssid, u8 ssid_len)
-{
-	u32 tmp;
-	u16 i;
-	u16 len;
-
-	len = min((u16)ssid_len, (u16)0x100);
-	for (i = 0; i < len; i += sizeof(u32)) {
-		tmp = (u32)(ssid[i + 0]);
-		if (i + 1 < len)
-			tmp |= (u32)(ssid[i + 1]) << 8;
-		if (i + 2 < len)
-			tmp |= (u32)(ssid[i + 2]) << 16;
-		if (i + 3 < len)
-			tmp |= (u32)(ssid[i + 3]) << 24;
-		b43legacy_shm_write32(dev, B43legacy_SHM_SHARED,
-				      0x380 + i, tmp);
-	}
-	b43legacy_shm_write16(dev, B43legacy_SHM_SHARED,
-			      0x48, len);
-}
-
 static void b43legacy_set_beacon_int(struct b43legacy_wldev *dev,
 				     u16 beacon_int)
 {
@@ -2744,7 +2721,6 @@ static int b43legacy_op_config_interface
 	if (b43legacy_status(dev) >= B43legacy_STAT_INITIALIZED) {
 		if (b43legacy_is_mode(wl, NL80211_IFTYPE_AP)) {
 			B43legacy_WARN_ON(vif->type != NL80211_IFTYPE_AP);
-			b43legacy_set_ssid(dev, conf->ssid, conf->ssid_len);
 			if (conf->changed & IEEE80211_IFCC_BEACON)
 				b43legacy_update_templates(wl);
 		} else if (b43legacy_is_mode(wl, NL80211_IFTYPE_ADHOC)) {


