Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ms-smtp-01.rdc-kc.rr.com ([24.94.166.115]:56021 "EHLO
	ms-smtp-01.rdc-kc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946606AbXBIQTH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Feb 2007 11:19:07 -0500
Date: Fri, 09 Feb 2007 10:18:03 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John Linville <linville@tuxdriver.com>
Cc: Michael Buesch <mb@bu3sch.de>, netdev@vger.kernel.org,
	Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: [PATCH] bcm43xx: Fix loss of association after resume
Message-ID: <45cc9ebb.+9O/IXvs/C9RyFnk%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After a suspend/resume cycle, bcm43xx-softmac has lost its association with
the AP and requires manual intervention. This situation is fixed by making
one of softmac's internal routines public and calling it.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---


Index: linux-2.6/drivers/net/wireless/bcm43xx/bcm43xx_main.c
===================================================================
--- linux-2.6.orig/drivers/net/wireless/bcm43xx/bcm43xx_main.c
+++ linux-2.6/drivers/net/wireless/bcm43xx/bcm43xx_main.c
@@ -4278,6 +4278,7 @@ static int bcm43xx_resume(struct pci_dev
 {
 	struct net_device *net_dev = pci_get_drvdata(pdev);
 	struct bcm43xx_private *bcm = bcm43xx_priv(net_dev);
+	struct ieee80211softmac_device *mac = ieee80211_priv(net_dev);
 	int err = 0;
 
 	dprintk(KERN_INFO PFX "Resuming...\n");
@@ -4299,6 +4300,9 @@ static int bcm43xx_resume(struct pci_dev
 	}
 	netif_device_attach(net_dev);
 
+	if (mac->associnfo.associated)
+		ieee80211softmac_try_reassoc(mac);
+
 	dprintk(KERN_INFO PFX "Device resumed.\n");
 
 	return 0;
Index: linux-2.6/include/net/ieee80211softmac.h
===================================================================
--- linux-2.6.orig/include/net/ieee80211softmac.h
+++ linux-2.6/include/net/ieee80211softmac.h
@@ -254,6 +254,7 @@ struct ieee80211softmac_device {
 };
 
 extern void ieee80211softmac_scan_finished(struct ieee80211softmac_device *sm);
+extern void ieee80211softmac_try_reassoc(struct ieee80211softmac_device *mac);
 
 static inline void * ieee80211softmac_priv(struct net_device *dev)
 {
Index: linux-2.6/net/ieee80211/softmac/ieee80211softmac_assoc.c
===================================================================
--- linux-2.6.orig/net/ieee80211/softmac/ieee80211softmac_assoc.c
+++ linux-2.6/net/ieee80211/softmac/ieee80211softmac_assoc.c
@@ -441,6 +441,7 @@ ieee80211softmac_try_reassoc(struct ieee
 	schedule_delayed_work(&mac->associnfo.work, 0);
 	spin_unlock_irqrestore(&mac->lock, flags);
 }
+EXPORT_SYMBOL_GPL(ieee80211softmac_try_reassoc);
 
 int
 ieee80211softmac_handle_disassoc(struct net_device * dev,
