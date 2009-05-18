Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54644 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752461AbZERIxY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 May 2009 04:53:24 -0400
Subject: [PATCH] b43/legacy: fix beacon change processing
From: Johannes Berg <johannes@sipsolutions.net>
To: Matthieu CASTET <castet.matthieu@free.fr>
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Michael Buesch <mb@bu3sch.de>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <loom.20090511T202208-851@post.gmane.org>
References: <loom.20090511T202208-851@post.gmane.org>
Content-Type: text/plain
Date: Mon, 18 May 2009 10:53:18 +0200
Message-Id: <1242636798.8425.2.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Process beacon change even if the BSSID doesn't
change at the same time. Also fix what I think
is a small locking error in b43legacy, there's
a spin_unlock_irqrestore that looks out of place.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/net/wireless/b43/main.c       |   24 +++++++++++-------------
 drivers/net/wireless/b43legacy/main.c |   21 +++++++++------------
 2 files changed, 20 insertions(+), 25 deletions(-)

--- wireless-testing.orig/drivers/net/wireless/b43/main.c	2009-05-18 10:44:35.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/main.c	2009-05-18 10:48:00.000000000 +0200
@@ -3553,27 +3553,25 @@ static void b43_op_bss_info_changed(stru
 
 	B43_WARN_ON(wl->vif != vif);
 
+	spin_lock_irqsave(&wl->irq_lock, flags);
 	if (changed & BSS_CHANGED_BSSID) {
-		spin_lock_irqsave(&wl->irq_lock, flags);
 		if (conf->bssid)
 			memcpy(wl->bssid, conf->bssid, ETH_ALEN);
 		else
 			memset(wl->bssid, 0, ETH_ALEN);
+	}
 
-		if (b43_status(dev) >= B43_STAT_INITIALIZED) {
-			if (b43_is_mode(wl, NL80211_IFTYPE_AP) ||
-			    b43_is_mode(wl, NL80211_IFTYPE_MESH_POINT)) {
-				B43_WARN_ON(vif->type != wl->if_type);
-				if (changed & BSS_CHANGED_BEACON)
-					b43_update_templates(wl);
-			} else if (b43_is_mode(wl, NL80211_IFTYPE_ADHOC)) {
-				if (changed & BSS_CHANGED_BEACON)
-					b43_update_templates(wl);
-			}
+	if (b43_status(dev) >= B43_STAT_INITIALIZED) {
+		if (changed & BSS_CHANGED_BEACON &&
+		    (b43_is_mode(wl, NL80211_IFTYPE_AP) ||
+		     b43_is_mode(wl, NL80211_IFTYPE_MESH_POINT) ||
+		     b43_is_mode(wl, NL80211_IFTYPE_ADHOC)))
+			b43_update_templates(wl);
+
+		if (changed & BSS_CHANGED_BSSID)
 			b43_write_mac_bssid_templates(dev);
-		}
-		spin_unlock_irqrestore(&wl->irq_lock, flags);
 	}
+	spin_unlock_irqrestore(&wl->irq_lock, flags);
 
 	b43_mac_suspend(dev);
 
--- wireless-testing.orig/drivers/net/wireless/b43legacy/main.c	2009-05-18 10:48:25.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43legacy/main.c	2009-05-18 10:50:04.000000000 +0200
@@ -2820,27 +2820,24 @@ static void b43legacy_op_bss_info_change
 	savedirqs = b43legacy_interrupt_disable(dev, B43legacy_IRQ_ALL);
 
 	if (changed & BSS_CHANGED_BSSID) {
-		spin_unlock_irqrestore(&wl->irq_lock, flags);
 		b43legacy_synchronize_irq(dev);
 
 		if (conf->bssid)
 			memcpy(wl->bssid, conf->bssid, ETH_ALEN);
 		else
 			memset(wl->bssid, 0, ETH_ALEN);
+	}
+
+	if (b43legacy_status(dev) >= B43legacy_STAT_INITIALIZED) {
+		if (changed & BSS_CHANGED_BEACON &&
+		    (b43legacy_is_mode(wl, NL80211_IFTYPE_AP) ||
+		     b43legacy_is_mode(wl, NL80211_IFTYPE_ADHOC)))
+			b43legacy_update_templates(wl);
 
-		if (b43legacy_status(dev) >= B43legacy_STAT_INITIALIZED) {
-			if (b43legacy_is_mode(wl, NL80211_IFTYPE_AP)) {
-				B43legacy_WARN_ON(vif->type != NL80211_IFTYPE_AP);
-				if (changed & BSS_CHANGED_BEACON)
-					b43legacy_update_templates(wl);
-			} else if (b43legacy_is_mode(wl, NL80211_IFTYPE_ADHOC)) {
-				if (changed & BSS_CHANGED_BEACON)
-					b43legacy_update_templates(wl);
-			}
+		if (changed & BSS_CHANGED_BSSID)
 			b43legacy_write_mac_bssid_templates(dev);
-		}
-		spin_unlock_irqrestore(&wl->irq_lock, flags);
 	}
+	spin_unlock_irqrestore(&wl->irq_lock, flags);
 
 	b43legacy_mac_suspend(dev);
 


