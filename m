Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:37069
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932550AbXHNSN6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Aug 2007 14:13:58 -0400
Message-Id: <20070814181215.023935000@bu3sch.de>
References: <20070814181213.135874000@bu3sch.de>
Date: Tue, 14 Aug 2007 20:12:17 +0200
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
Subject: [patch 4/9] b43: Check init status in b43_config_interface.
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We must check for >=INITIALIZED

Signed-off-by: Michael Buesch <mb@bu3sch.de>

Index: wireless-dev-new/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-dev-new.orig/drivers/net/wireless/b43/main.c	2007-08-12 20:17:07.000000000 +0200
+++ wireless-dev-new/drivers/net/wireless/b43/main.c	2007-08-12 20:17:11.000000000 +0200
@@ -2940,13 +2940,15 @@ static int b43_config_interface(struct i
 	if (conf->type != IEEE80211_IF_TYPE_MNTR) {
 		B43_WARN_ON(wl->if_id != if_id);
 		wl->bssid = conf->bssid;
-		if (b43_is_mode(wl, IEEE80211_IF_TYPE_AP)) {
-			B43_WARN_ON(conf->type != IEEE80211_IF_TYPE_AP);
-			b43_set_ssid(dev, conf->ssid, conf->ssid_len);
-			if (conf->beacon)
-				b43_refresh_templates(dev, conf->beacon);
+		if (b43_status(dev) >= B43_STAT_INITIALIZED) {
+			if (b43_is_mode(wl, IEEE80211_IF_TYPE_AP)) {
+				B43_WARN_ON(conf->type != IEEE80211_IF_TYPE_AP);
+				b43_set_ssid(dev, conf->ssid, conf->ssid_len);
+				if (conf->beacon)
+					b43_refresh_templates(dev, conf->beacon);
+			}
+			b43_write_mac_bssid_templates(dev);
 		}
-		b43_write_mac_bssid_templates(dev);
 	}
 	spin_unlock_irqrestore(&wl->irq_lock, flags);
 	mutex_unlock(&wl->mutex);

-- 

