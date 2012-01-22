Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50645 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751174Ab2AVDJi convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Jan 2012 22:09:38 -0500
Message-ID: <1327201775.8004.83.camel@deadeye> (sfid-20120122_040941_628525_67F10F1D)
Subject: [PATCH 1/2] ipw2200: Fix order of device registration
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: 656813@bugs.debian.org
Date: Sun, 22 Jan 2012 03:09:35 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently cfg80211 fails to create a "phy80211" symlink in sysfs from
the net device to the wiphy device.  The latter needs to be registered
first.

Compile-tested only.

Reported-by: Cesare Leonardi <celeonar@gmail.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/ipw2x00/ipw2200.c |   23 ++++++++++++-----------
 1 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ipw2x00/ipw2200.c b/drivers/net/wireless/ipw2x00/ipw2200.c
index 018a8de..737dfaf 100644
--- a/drivers/net/wireless/ipw2x00/ipw2200.c
+++ b/drivers/net/wireless/ipw2x00/ipw2200.c
@@ -11839,16 +11839,17 @@ static int __devinit ipw_pci_probe(struct pci_dev *pdev,
 	}
 
 	mutex_unlock(&priv->mutex);
-	err = register_netdev(net_dev);
+
+	err = ipw_wdev_init(net_dev);
 	if (err) {
-		IPW_ERROR("failed to register network device\n");
+		IPW_ERROR("failed to register wireless device\n");
 		goto out_remove_sysfs;
 	}
 
-	err = ipw_wdev_init(net_dev);
+	err = register_netdev(net_dev);
 	if (err) {
-		IPW_ERROR("failed to register wireless device\n");
-		goto out_unregister_netdev;
+		IPW_ERROR("failed to register network device\n");
+		goto out_unregister_wiphy;
 	}
 
 #ifdef CONFIG_IPW2200_PROMISCUOUS
@@ -11857,10 +11858,8 @@ static int __devinit ipw_pci_probe(struct pci_dev *pdev,
 		if (err) {
 			IPW_ERROR("Failed to register promiscuous network "
 				  "device (error %d).\n", err);
-			wiphy_unregister(priv->ieee->wdev.wiphy);
-			kfree(priv->ieee->a_band.channels);
-			kfree(priv->ieee->bg_band.channels);
-			goto out_unregister_netdev;
+			unregister_netdev(priv->net_dev);
+			goto out_unregister_wiphy;
 		}
 	}
 #endif
@@ -11872,8 +11871,10 @@ static int __devinit ipw_pci_probe(struct pci_dev *pdev,
 
 	return 0;
 
-      out_unregister_netdev:
-	unregister_netdev(priv->net_dev);
+      out_unregister_wiphy:
+	wiphy_unregister(priv->ieee->wdev.wiphy);
+	kfree(priv->ieee->a_band.channels);
+	kfree(priv->ieee->bg_band.channels);
       out_remove_sysfs:
 	sysfs_remove_group(&pdev->dev.kobj, &ipw_attribute_group);
       out_release_irq:
-- 
1.7.8.2



