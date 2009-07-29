Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56126 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330AbZG2INg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jul 2009 04:13:36 -0400
Subject: [PATCH] mac80211: disable beacons before removing the associated
 interface
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Bob Copeland <bcopeland@gmail.com>
Content-Type: text/plain
Date: Wed, 29 Jul 2009 10:13:03 +0200
Message-Id: <1248855183.13742.16.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Bob Copeland <me@bobcopeland.com>

When downing interfaces, it's a good idea to tell the driver to
stop sending beacons; that way the driver doesn't need special
code in ops->remove_interface() when it should already handle the
case in bss_info_changed().

This fixes a potential crash with at least ath5k since the vif
pointer will be nullified while beacon interrupts are still active.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/iface.c |   10 ++++++++++
 net/mac80211/main.c  |    3 ++-
 net/mac80211/pm.c    |    4 ++++
 3 files changed, 16 insertions(+), 1 deletion(-)

--- wireless-testing.orig/net/mac80211/iface.c	2009-07-29 10:06:06.000000000 +0200
+++ wireless-testing/net/mac80211/iface.c	2009-07-29 10:11:35.000000000 +0200
@@ -522,6 +522,16 @@ static int ieee80211_stop(struct net_dev
 				ieee80211_scan_completed(&local->hw, true);
 		}
 
+		/*
+		 * Disable beaconing for AP and mesh, IBSS can't
+		 * still be joined to a network at this point.
+		 */
+		if (sdata->vif.type == NL80211_IFTYPE_AP ||
+		    sdata->vif.type == NL80211_IFTYPE_MESH_POINT) {
+			ieee80211_bss_info_change_notify(sdata,
+				BSS_CHANGED_BEACON_ENABLED);
+		}
+
 		conf.vif = &sdata->vif;
 		conf.type = sdata->vif.type;
 		conf.mac_addr = dev->dev_addr;
--- wireless-testing.orig/net/mac80211/main.c	2009-07-29 10:06:06.000000000 +0200
+++ wireless-testing/net/mac80211/main.c	2009-07-29 10:11:35.000000000 +0200
@@ -198,7 +198,8 @@ void ieee80211_bss_info_change_notify(st
 	}
 
 	if (changed & BSS_CHANGED_BEACON_ENABLED) {
-		if (test_bit(SCAN_SW_SCANNING, &local->scanning)) {
+		if (local->quiescing || !netif_running(sdata->dev) ||
+		    test_bit(SCAN_SW_SCANNING, &local->scanning)) {
 			sdata->vif.bss_conf.enable_beacon = false;
 		} else {
 			/*
--- wireless-testing.orig/net/mac80211/pm.c	2009-07-29 10:06:06.000000000 +0200
+++ wireless-testing/net/mac80211/pm.c	2009-07-29 10:11:35.000000000 +0200
@@ -96,6 +96,10 @@ int __ieee80211_suspend(struct ieee80211
 		if (!netif_running(sdata->dev))
 			continue;
 
+		/* disable beaconing */
+		ieee80211_bss_info_change_notify(sdata,
+			BSS_CHANGED_BEACON_ENABLED);
+
 		conf.vif = &sdata->vif;
 		conf.type = sdata->vif.type;
 		conf.mac_addr = sdata->dev->dev_addr;


