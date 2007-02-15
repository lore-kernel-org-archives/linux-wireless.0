Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:43653 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965726AbXBOO7y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Feb 2007 09:59:54 -0500
Message-Id: <20070215144259.397393000@sipsolutions.net>
References: <20070215144241.847938000@sipsolutions.net>
Date: Thu, 15 Feb 2007 15:42:48 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: John Linville <linville@tuxdriver.com>, Jiri Benc <jbenc@suse.cz>
Subject: [PATCH 07/10] bcm43xx-d80211: update for wiphy api
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

update bcm43xx-d80211.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
Really bcm43xx should be using the new wiphy debugfs stuff as well,
but I can't figure out what the hell it is doing when multiple
devices exist in a system. Thing is the new debugfs dir is only
created for d80211 drivers when calling register_hw() and all items
must be gone from it when calling free_hw()...

---
 drivers/net/wireless/d80211/bcm43xx/bcm43xx_debugfs.c |    2 +-
 drivers/net/wireless/d80211/bcm43xx/bcm43xx_main.c    |   15 ++++++---------
 2 files changed, 7 insertions(+), 10 deletions(-)

--- wireless-dev.orig/drivers/net/wireless/d80211/bcm43xx/bcm43xx_main.c	2007-02-15 13:50:28.967940064 +0100
+++ wireless-dev/drivers/net/wireless/d80211/bcm43xx/bcm43xx_main.c	2007-02-15 14:01:33.486635438 +0100
@@ -3282,7 +3282,7 @@ static int bcm43xx_wireless_core_init(st
 	ssb_bus_powerup(bus, 1); /* Enable dynamic PCTL */
 	bcm43xx_macfilter_clear(dev, BCM43xx_MACFILTER_ASSOC);
 	bcm43xx_macfilter_set(dev, BCM43xx_MACFILTER_SELF,
-			      (u8 *)(wl->hw->perm_addr));
+			      (u8 *)(wl->hw->wiphy->perm_addr));
 	bcm43xx_security_init(dev);
 	bcm43xx_measure_channel_change_time(dev);
 
@@ -3743,14 +3743,11 @@ static int bcm43xx_wireless_init(struct 
 		    IEEE80211_HW_WEP_INCLUDE_IV;
 	hw->maxssi = BCM43xx_RX_MAX_SSI;
 	hw->queues = 1;
-	hw->dev = &dev->dev;
-	if (is_valid_ether_addr(sprom->r1.et1mac)) {
-		memcpy(hw->perm_addr, sprom->r1.et1mac,
-		       ARRAY_SIZE(hw->perm_addr));
-	} else {
-		memcpy(hw->perm_addr, sprom->r1.il0mac,
-		       ARRAY_SIZE(hw->perm_addr));
-	}
+	SET_IEEE80211_DEV(hw, &dev->dev);
+	if (is_valid_ether_addr(sprom->r1.et1mac))
+		SET_IEEE80211_PERM_ADDR(hw, sprom->r1.et1mac);
+	else
+		SET_IEEE80211_PERM_ADDR(hw, sprom->r1.il0mac);
 
 	/* Get and initialize struct bcm43xx_wl */
 	wl = hw_to_bcm43xx_wl(hw);
--- wireless-dev.orig/drivers/net/wireless/d80211/bcm43xx/bcm43xx_debugfs.c	2007-02-15 13:50:28.917940064 +0100
+++ wireless-dev/drivers/net/wireless/d80211/bcm43xx/bcm43xx_debugfs.c	2007-02-15 14:02:18.646635438 +0100
@@ -308,7 +308,7 @@ void bcm43xx_debugfs_add_device(struct b
 
 	dev->dfsentry = e;
 
-	snprintf(devdir, sizeof(devdir), "wiphy%d", dev->wl->hw->index);
+	snprintf(devdir, sizeof(devdir), "%s", wiphy_name(dev->wl->hw->wiphy));
 	e->subdir = debugfs_create_dir(devdir, fs.root);
 	e->dentry_tsf = debugfs_create_file("tsf", 0666, e->subdir,
 	                                    dev, &tsf_fops);

--

