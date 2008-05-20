Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40030 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753620AbYETKL4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 May 2008 06:11:56 -0400
Subject: [PATCH] b43: enable mesh
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Michael Buesch <mb@bu3sch.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 20 May 2008 12:10:49 +0200
Message-Id: <1211278249.6252.78.camel@johannes.berg> (sfid-20080520_121205_205712_1F57F13D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch enables b43 to do mesh networking, tested against my zd1211rw
dongle.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
Requires Michael's patch that fixes the beacon template upload to upload
to both templates with the first upload.

 drivers/net/wireless/b43/main.c |   33 ++++++++++++++++++++++-----------
 1 file changed, 22 insertions(+), 11 deletions(-)

--- everything.orig/drivers/net/wireless/b43/main.c	2008-05-20 12:07:59.000000000 +0200
+++ everything/drivers/net/wireless/b43/main.c	2008-05-20 12:09:12.000000000 +0200
@@ -1430,11 +1430,17 @@ static void b43_write_beacon_template(st
 		i += ie_len + 2;
 	}
 	if (!tim_found) {
-		b43warn(dev->wl, "Did not find a valid TIM IE in "
-			"the beacon template packet. AP or IBSS operation "
-			"may be broken.\n");
-	} else
-		b43dbg(dev->wl, "Updated beacon template\n");
+		/*
+		 * If ucode wants to modify TIM do it behind the beacon, this
+		 * will happen, for example, when doing mesh networking.
+		 */
+		b43_shm_write16(dev, B43_SHM_SHARED,
+				B43_SHM_SH_TIMBPOS,
+				len + sizeof(struct b43_plcp_hdr6));
+		b43_shm_write16(dev, B43_SHM_SHARED,
+				B43_SHM_SH_DTIMPER, 0);
+	}
+	b43dbg(dev->wl, "Updated beacon template at 0x%x\n", ram_offset);
 }
 
 static void b43_write_probe_resp_plcp(struct b43_wldev *dev,
@@ -1549,7 +1555,8 @@ static void handle_irq_beacon(struct b43
 	struct b43_wl *wl = dev->wl;
 	u32 cmd, beacon0_valid, beacon1_valid;
 
-	if (!b43_is_mode(wl, IEEE80211_IF_TYPE_AP))
+	if (!b43_is_mode(wl, IEEE80211_IF_TYPE_AP) &&
+	    !b43_is_mode(wl, IEEE80211_IF_TYPE_MESH_POINT))
 		return;
 
 	/* This is the bottom half of the asynchronous beacon update. */
@@ -2374,7 +2381,8 @@ static void b43_adjust_opmode(struct b43
 	ctl &= ~B43_MACCTL_BEACPROMISC;
 	ctl |= B43_MACCTL_INFRA;
 
-	if (b43_is_mode(wl, IEEE80211_IF_TYPE_AP))
+	if (b43_is_mode(wl, IEEE80211_IF_TYPE_AP) ||
+	    b43_is_mode(wl, IEEE80211_IF_TYPE_MESH_POINT))
 		ctl |= B43_MACCTL_AP;
 	else if (b43_is_mode(wl, IEEE80211_IF_TYPE_IBSS))
 		ctl &= ~B43_MACCTL_INFRA;
@@ -3241,8 +3249,9 @@ static int b43_op_config(struct ieee8021
 	antenna = b43_antenna_from_ieee80211(dev, conf->antenna_sel_rx);
 	b43_set_rx_antenna(dev, antenna);
 
-	/* Update templates for AP mode. */
-	if (b43_is_mode(wl, IEEE80211_IF_TYPE_AP))
+	/* Update templates for AP/mesh mode. */
+	if (b43_is_mode(wl, IEEE80211_IF_TYPE_AP) ||
+	    b43_is_mode(wl, IEEE80211_IF_TYPE_MESH_POINT))
 		b43_set_beacon_int(dev, conf->beacon_int);
 
 	if (!!conf->radio_enabled != phy->radio_on) {
@@ -3423,8 +3432,9 @@ static int b43_op_config_interface(struc
 	else
 		memset(wl->bssid, 0, ETH_ALEN);
 	if (b43_status(dev) >= B43_STAT_INITIALIZED) {
-		if (b43_is_mode(wl, IEEE80211_IF_TYPE_AP)) {
-			B43_WARN_ON(conf->type != IEEE80211_IF_TYPE_AP);
+		if (b43_is_mode(wl, IEEE80211_IF_TYPE_AP) ||
+		    b43_is_mode(wl, IEEE80211_IF_TYPE_MESH_POINT)) {
+			B43_WARN_ON(conf->type != wl->if_type);
 			b43_set_ssid(dev, conf->ssid, conf->ssid_len);
 			if (conf->beacon)
 				b43_update_templates(wl, conf->beacon);
@@ -3964,6 +3974,7 @@ static int b43_op_add_interface(struct i
 	/* TODO: allow WDS/AP devices to coexist */
 
 	if (conf->type != IEEE80211_IF_TYPE_AP &&
+	    conf->type != IEEE80211_IF_TYPE_MESH_POINT &&
 	    conf->type != IEEE80211_IF_TYPE_STA &&
 	    conf->type != IEEE80211_IF_TYPE_WDS &&
 	    conf->type != IEEE80211_IF_TYPE_IBSS)


