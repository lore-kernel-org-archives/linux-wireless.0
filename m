Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50664 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751477Ab2AVDLN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Jan 2012 22:11:13 -0500
Message-ID: <1327201872.8004.85.camel@deadeye> (sfid-20120122_041115_264014_0ABED782)
Subject: [PATCH 2/2] ipw2100: Fix order of device registration
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: 656813@bugs.debian.org
Date: Sun, 22 Jan 2012 03:11:12 +0000
In-Reply-To: <1327201775.8004.83.camel@deadeye>
References: <1327201775.8004.83.camel@deadeye>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently cfg80211 fails to create a "phy80211" symlink in sysfs from
the net device to the wiphy device.  The latter needs to be registered
first.

Compile-tested only.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
This appears to have the same bug as ipw2200.

Ben.

 drivers/net/wireless/ipw2x00/ipw2100.c |   24 +++++++++++++-----------
 1 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ipw2x00/ipw2100.c b/drivers/net/wireless/ipw2x00/ipw2100.c
index a0e5c21..a5437e7 100644
--- a/drivers/net/wireless/ipw2x00/ipw2100.c
+++ b/drivers/net/wireless/ipw2x00/ipw2100.c
@@ -1956,10 +1956,8 @@ static int ipw2100_wdev_init(struct net_device *dev)
 	}
 
 	set_wiphy_dev(wdev->wiphy, &priv->pci_dev->dev);
-	if (wiphy_register(wdev->wiphy)) {
-		ipw2100_down(priv);
+	if (wiphy_register(wdev->wiphy))
 		return -EIO;
-	}
 	return 0;
 }
 
@@ -6337,6 +6335,11 @@ static int ipw2100_pci_init_one(struct pci_dev *pci_dev,
 	printk(KERN_INFO DRV_NAME
 	       ": Detected Intel PRO/Wireless 2100 Network Connection\n");
 
+	err = ipw2100_wdev_init(dev);
+	if (err)
+		goto fail;
+	registered = 1;
+
 	/* Bring up the interface.  Pre 0.46, after we registered the
 	 * network device we would call ipw2100_up.  This introduced a race
 	 * condition with newer hotplug configurations (network was coming
@@ -6353,11 +6356,7 @@ static int ipw2100_pci_init_one(struct pci_dev *pci_dev,
 		       "Error calling register_netdev.\n");
 		goto fail;
 	}
-	registered = 1;
-
-	err = ipw2100_wdev_init(dev);
-	if (err)
-		goto fail;
+	registered = 2;
 
 	mutex_lock(&priv->action_mutex);
 
@@ -6396,13 +6395,16 @@ static int ipw2100_pci_init_one(struct pci_dev *pci_dev,
 
       fail_unlock:
 	mutex_unlock(&priv->action_mutex);
-	wiphy_unregister(priv->ieee->wdev.wiphy);
-	kfree(priv->ieee->bg_band.channels);
       fail:
 	if (dev) {
-		if (registered)
+		if (registered >= 2)
 			unregister_netdev(dev);
 
+		if (registered) {
+			wiphy_unregister(priv->ieee->wdev.wiphy);
+			kfree(priv->ieee->bg_band.channels);
+		}
+
 		ipw2100_hw_stop_adapter(priv);
 
 		ipw2100_disable_interrupts(priv);
-- 
1.7.8.2


