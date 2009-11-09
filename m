Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:19858 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752694AbZKIJaH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Nov 2009 04:30:07 -0500
Subject: Re: BUG: oops when "rmmod ipw2200"
From: Zhu Yi <yi.zhu@intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Holger Schurig <holgerschurig@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20091105153329.GB2817@tuxdriver.com>
References: <S1754043AbZKEPJ1/20091105150927Z+225@vger.kernel.org>
	 <20091105153329.GB2817@tuxdriver.com>
Content-Type: text/plain
Date: Mon, 09 Nov 2009 17:30:07 +0800
Message-Id: <1257759007.5538.1010.camel@debian>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2009-11-05 at 23:33 +0800, John W. Linville wrote:
> On Thu, Nov 05, 2009 at 03:59:16PM +0100, Holger Schurig wrote:
> > This happened on wireless-testing v2.6.32-rc6-41575-g5e68bfb. I
> > modprobed ipw2200, put it into monitor mode, used tshark a while to
> > monitor, then I stopped tshark, "ifconfig eth2 down" and finally
> > "rmmod ipw2200", and voila:
> > 
> > [  917.189620] ------------[ cut here ]------------
> > [  917.189717] kernel BUG at net/wireless/core.c:543!
> > [  917.189805] invalid opcode: 0000 [#1] PREEMPT SMP
> > [  917.190002] last sysfs file: /sys/devices/pci0000:00/0000:00:1e.0/0000:02:0d.0/firmware/0000:02:0d.0/loading
> > [  917.190136] Modules linked in: lib80211_crypt_wep ipw2200(-) libipw lib80211 ath5k mac80211 ath cfg80211 psmouse uhci_hcd
> 
> <snip>
> 
> Crud...this has to be the following:
> 
> commit e6c5fc53d0f44a772398402ee8a1879818e42b4e
> Author: Zhu Yi <yi.zhu@intel.com>
> Date:   Thu Oct 15 14:50:28 2009 +0800
> 
>     ipw2200: fix oops on missing firmware
>     
>     For non-monitor interfaces, the syntax for alloc_ieee80211/free_80211
>     is wrong. Because alloc_ieee80211 only creates (wiphy_new) a wiphy, but
>     free_80211() does wiphy_unregister() also. This is only correct when
>     the later wiphy_register() is called successfully, which apparently
>     is not the case for your fw doesn't exist one.
>     
>     Signed-off-by: Zhu Yi <yi.zhu@intel.com>
>     Signed-off-by: John W. Linville <linville@tuxdriver.com>
> 
> Can you revert that and attempt to recreate?

I forgot to remember wiphy has to be unregistered _after_ netdev. Here
is a fix patch. Please test.

>From 4581a7ea7146040b1b9ee8a1d45e63561a900e1d Mon Sep 17 00:00:00 2001
From: Zhu Yi <chuyee@octavia.(none)>
Date: Mon, 9 Nov 2009 17:49:21 +0800
Subject: [PATCH V2] ipw2200: fix oops on missing firmware

For non-monitor interfaces, the syntax for alloc_ieee80211/free_80211
is wrong. Because alloc_ieee80211 only creates (wiphy_new) a wiphy, but
free_80211() does wiphy_unregister() also. This is only correct when
the later wiphy_register() is called successfully, which apparently
is not the case for the fw doesn't exist one.

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
V2: fix a BUG_ON reported by Holger Schurig

 drivers/net/wireless/ipw2x00/ipw2100.c       |    5 ++++-
 drivers/net/wireless/ipw2x00/ipw2200.c       |    2 ++
 drivers/net/wireless/ipw2x00/libipw.h        |    1 +
 drivers/net/wireless/ipw2x00/libipw_module.c |   14 +++++++++-----
 4 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ipw2x00/ipw2100.c b/drivers/net/wireless/ipw2x00/ipw2100.c
index 240cff1..faec9d3 100644
--- a/drivers/net/wireless/ipw2x00/ipw2100.c
+++ b/drivers/net/wireless/ipw2x00/ipw2100.c
@@ -6325,8 +6325,10 @@ static int ipw2100_pci_init_one(struct pci_dev *pci_dev,
 
       fail:
 	if (dev) {
-		if (registered)
+		if (registered) {
 			unregister_netdev(dev);
+			unregister_ieee80211(priv->ieee);
+		}
 
 		ipw2100_hw_stop_adapter(priv);
 
@@ -6384,6 +6386,7 @@ static void __devexit ipw2100_pci_remove_one(struct pci_dev *pci_dev)
 		 * being called if the device is open.  If we free storage
 		 * first, then close() will crash. */
 		unregister_netdev(dev);
+		unregister_ieee80211(priv->ieee);
 
 		/* ipw2100_down will ensure that there is no more pending work
 		 * in the workqueue's, so we can safely remove them now. */
diff --git a/drivers/net/wireless/ipw2x00/ipw2200.c b/drivers/net/wireless/ipw2x00/ipw2200.c
index 827824d..ae846a7 100644
--- a/drivers/net/wireless/ipw2x00/ipw2200.c
+++ b/drivers/net/wireless/ipw2x00/ipw2200.c
@@ -11823,6 +11823,7 @@ static int __devinit ipw_pci_probe(struct pci_dev *pdev,
 			IPW_ERROR("Failed to register promiscuous network "
 				  "device (error %d).\n", err);
 			unregister_netdev(priv->net_dev);
+			unregister_ieee80211(priv->ieee);
 			goto out_remove_sysfs;
 		}
 	}
@@ -11873,6 +11874,7 @@ static void __devexit ipw_pci_remove(struct pci_dev *pdev)
 	mutex_unlock(&priv->mutex);
 
 	unregister_netdev(priv->net_dev);
+	unregister_ieee80211(priv->ieee);
 
 	if (priv->rxq) {
 		ipw_rx_queue_free(priv, priv->rxq);
diff --git a/drivers/net/wireless/ipw2x00/libipw.h b/drivers/net/wireless/ipw2x00/libipw.h
index bf45391..f42ade6 100644
--- a/drivers/net/wireless/ipw2x00/libipw.h
+++ b/drivers/net/wireless/ipw2x00/libipw.h
@@ -1020,6 +1020,7 @@ static inline int libipw_is_cck_rate(u8 rate)
 /* ieee80211.c */
 extern void free_ieee80211(struct net_device *dev, int monitor);
 extern struct net_device *alloc_ieee80211(int sizeof_priv, int monitor);
+extern void unregister_ieee80211(struct libipw_device *ieee);
 extern int libipw_change_mtu(struct net_device *dev, int new_mtu);
 
 extern void libipw_networks_age(struct libipw_device *ieee,
diff --git a/drivers/net/wireless/ipw2x00/libipw_module.c b/drivers/net/wireless/ipw2x00/libipw_module.c
index a0e9f6a..be5b809 100644
--- a/drivers/net/wireless/ipw2x00/libipw_module.c
+++ b/drivers/net/wireless/ipw2x00/libipw_module.c
@@ -235,16 +235,19 @@ void free_ieee80211(struct net_device *dev, int monitor)
 	libipw_networks_free(ieee);
 
 	/* free cfg80211 resources */
-	if (!monitor) {
-		wiphy_unregister(ieee->wdev.wiphy);
-		kfree(ieee->a_band.channels);
-		kfree(ieee->bg_band.channels);
+	if (!monitor)
 		wiphy_free(ieee->wdev.wiphy);
-	}
 
 	free_netdev(dev);
 }
 
+void unregister_ieee80211(struct libipw_device *ieee)
+{
+	wiphy_unregister(ieee->wdev.wiphy);
+	kfree(ieee->a_band.channels);
+	kfree(ieee->bg_band.channels);
+}
+
 #ifdef CONFIG_LIBIPW_DEBUG
 
 static int debug = 0;
@@ -330,3 +333,4 @@ module_init(libipw_init);
 
 EXPORT_SYMBOL(alloc_ieee80211);
 EXPORT_SYMBOL(free_ieee80211);
+EXPORT_SYMBOL(unregister_ieee80211);
-- 
1.5.3.6



