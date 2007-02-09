Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:35374 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946582AbXBIQcv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Feb 2007 11:32:51 -0500
Received: from [84.135.215.182] (helo=johannes.berg)
	by sipsolutions.net with esmtpsa (TLS-1.0:RSA_ARCFOUR_MD5:16)
	(Exim 4.63)
	(envelope-from <johannes@sipsolutions.net>)
	id 1HFYco-0003aS-GC
	for linux-wireless@vger.kernel.org; Fri, 09 Feb 2007 16:29:26 +0000
Message-Id: <20070209162528.637446000@sipsolutions.net>
References: <20070209162414.043158000@sipsolutions.net>
Date: Fri, 09 Feb 2007 17:24:19 +0100
From: johannes@sipsolutions.net
To: linux-wireless@vger.kernel.org
Subject: [PATCH 5/5] bcm43xx-d80211: update for wiphy api
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

update bcm43xx-d80211.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 drivers/net/wireless/d80211/bcm43xx/bcm43xx_debugfs.c |    2 +-
 drivers/net/wireless/d80211/bcm43xx/bcm43xx_main.c    |   15 ++++++---------
 2 files changed, 7 insertions(+), 10 deletions(-)

--- wireless-dev.orig/drivers/net/wireless/d80211/bcm43xx/bcm43xx_debugfs.c	2007-02-09 17:08:20.133840519 +0100
+++ wireless-dev/drivers/net/wireless/d80211/bcm43xx/bcm43xx_debugfs.c	2007-02-09 17:09:00.763840519 +0100
@@ -308,7 +308,7 @@ void bcm43xx_debugfs_add_device(struct b
 
 	dev->dfsentry = e;
 
-	snprintf(devdir, sizeof(devdir), "wiphy%d", dev->wl->hw->index);
+	snprintf(devdir, sizeof(devdir), "wiphy%d", dev->wl->hw->wiphy->wiphy_index);
 	e->subdir = debugfs_create_dir(devdir, fs.root);
 	e->dentry_tsf = debugfs_create_file("tsf", 0666, e->subdir,
 	                                    dev, &tsf_fops);
--- wireless-dev.orig/drivers/net/wireless/d80211/bcm43xx/bcm43xx_main.c	2007-02-09 17:08:20.213840519 +0100
+++ wireless-dev/drivers/net/wireless/d80211/bcm43xx/bcm43xx_main.c	2007-02-09 17:09:00.773840519 +0100
@@ -3166,7 +3166,7 @@ static int bcm43xx_wireless_core_init(st
 	ssb_chipco_set_clockmode(chipco, SSB_CLKMODE_DYNAMIC);
 	bcm43xx_macfilter_clear(dev, BCM43xx_MACFILTER_ASSOC);
 	bcm43xx_macfilter_set(dev, BCM43xx_MACFILTER_SELF,
-			      (u8 *)(wl->hw->perm_addr));
+			      (u8 *)(wl->hw->wiphy->perm_addr));
 	bcm43xx_security_init(dev);
 	bcm43xx_measure_channel_change_time(dev);
 
@@ -3562,14 +3562,11 @@ static int bcm43xx_wireless_init(struct 
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

--

