Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:10806 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754171Ab1IHGoi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Sep 2011 02:44:38 -0400
Date: Thu, 8 Sep 2011 08:44:10 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Michael Witten <mfwitten@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH] mac80211: fix suspend/resume races with unregister hw
Message-ID: <20110908064410.GA2195@redhat.com> (sfid-20110908_084442_544427_64A59B10)
References: <1313150459-13234-1-git-send-email-sgruszka@redhat.com>
 <d9f6472975e34cb294831e32c8ce2346-mfwitten@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="AhhlLboLdkugWU4S"
In-Reply-To: <d9f6472975e34cb294831e32c8ce2346-mfwitten@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--AhhlLboLdkugWU4S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Sep 07, 2011 at 09:50:29PM -0000, Michael Witten wrote:
> My boot process is stalling proximate the following messages (after a period
> of time, some other message might show up, but the boot never progresses much
> further):
> 
>   cfg80211: World regulatory domain updated:
>   cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
>   cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
>   cfg80211:     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
>   cfg80211:     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
>   cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
>   cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
> 
> I bisected to this patch, namely via the following commit:
>   
>   commit ecb4433550f0620f3d1471ae7099037ede30a91e
>   Author: Stanislaw Gruszka <sgruszka@redhat.com>
>   Date:   Fri Aug 12 14:00:59 2011 +0200

Grr, crap.

> 
> Now, it may be the case that my system startup's scripts are doing something
> funny, as the stall described above occurs after Arch Linux outputs:
> 
>   Waiting for UDev uevents to be processed
> 
> At this point, that's all I know.

What wireless driver are you using? If this is ipw2x00 please try
attached patch.

Thanks
Stanislaw


--AhhlLboLdkugWU4S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="ipw2x00_do_not_call_wiphy_register_with_rtnl_lock.patch"

diff --git a/drivers/net/wireless/ipw2x00/ipw2100.c b/drivers/net/wireless/ipw2x00/ipw2100.c
index 3774dd0..ef9ad79 100644
--- a/drivers/net/wireless/ipw2x00/ipw2100.c
+++ b/drivers/net/wireless/ipw2x00/ipw2100.c
@@ -1903,15 +1903,17 @@ static void ipw2100_down(struct ipw2100_priv *priv)
 static int ipw2100_net_init(struct net_device *dev)
 {
 	struct ipw2100_priv *priv = libipw_priv(dev);
+
+	return ipw2100_up(priv, 1);
+}
+
+static int ipw2100_wdev_init(struct net_device *dev)
+{
+	struct ipw2100_priv *priv = libipw_priv(dev);
 	const struct libipw_geo *geo = libipw_get_geo(priv->ieee);
 	struct wireless_dev *wdev = &priv->ieee->wdev;
-	int ret;
 	int i;
 
-	ret = ipw2100_up(priv, 1);
-	if (ret)
-		return ret;
-
 	memcpy(wdev->wiphy->perm_addr, priv->mac_addr, ETH_ALEN);
 
 	/* fill-out priv->ieee->bg_band */
@@ -6350,9 +6352,13 @@ static int ipw2100_pci_init_one(struct pci_dev *pci_dev,
 		       "Error calling register_netdev.\n");
 		goto fail;
 	}
+	registered = 1;
+
+	err = ipw2100_wdev_init(dev);
+	if (err)
+		goto fail;
 
 	mutex_lock(&priv->action_mutex);
-	registered = 1;
 
 	IPW_DEBUG_INFO("%s: Bound to %s\n", dev->name, pci_name(pci_dev));
 
@@ -6389,7 +6395,8 @@ static int ipw2100_pci_init_one(struct pci_dev *pci_dev,
 
       fail_unlock:
 	mutex_unlock(&priv->action_mutex);
-
+	wiphy_unregister(priv->ieee->wdev.wiphy);
+	kfree(priv->ieee->bg_band.channels);
       fail:
 	if (dev) {
 		if (registered)
diff --git a/drivers/net/wireless/ipw2x00/ipw2200.c b/drivers/net/wireless/ipw2x00/ipw2200.c
index 87813c3..6a6d48f 100644
--- a/drivers/net/wireless/ipw2x00/ipw2200.c
+++ b/drivers/net/wireless/ipw2x00/ipw2200.c
@@ -11425,16 +11425,23 @@ static void ipw_bg_down(struct work_struct *work)
 /* Called by register_netdev() */
 static int ipw_net_init(struct net_device *dev)
 {
+	int rc = 0;
+	struct ipw_priv *priv = libipw_priv(dev);
+
+	mutex_lock(&priv->mutex);
+	if (ipw_up(priv))
+		rc = -EIO;
+	mutex_unlock(&priv->mutex);
+
+	return rc;
+}
+
+static int ipw_wdev_init(struct net_device *dev)
+{
 	int i, rc = 0;
 	struct ipw_priv *priv = libipw_priv(dev);
 	const struct libipw_geo *geo = libipw_get_geo(priv->ieee);
 	struct wireless_dev *wdev = &priv->ieee->wdev;
-	mutex_lock(&priv->mutex);
-
-	if (ipw_up(priv)) {
-		rc = -EIO;
-		goto out;
-	}
 
 	memcpy(wdev->wiphy->perm_addr, priv->mac_addr, ETH_ALEN);
 
@@ -11519,13 +11526,9 @@ static int ipw_net_init(struct net_device *dev)
 	set_wiphy_dev(wdev->wiphy, &priv->pci_dev->dev);
 
 	/* With that information in place, we can now register the wiphy... */
-	if (wiphy_register(wdev->wiphy)) {
+	if (wiphy_register(wdev->wiphy))
 		rc = -EIO;
-		goto out;
-	}
-
 out:
-	mutex_unlock(&priv->mutex);
 	return rc;
 }
 
@@ -11678,7 +11681,6 @@ static int ipw_prom_alloc(struct ipw_priv *priv)
 	if (rc) {
 		free_libipw(priv->prom_net_dev, 1);
 		priv->prom_net_dev = NULL;
-		return rc;
 	}
 
 	return 0;
@@ -11832,14 +11834,23 @@ static int __devinit ipw_pci_probe(struct pci_dev *pdev,
 		goto out_remove_sysfs;
 	}
 
+	err = ipw_wdev_init(net_dev);
+	if (err) {
+		IPW_ERROR("failed to register wireless device\n");
+		goto out_unregister_netdev;
+	}
+
 #ifdef CONFIG_IPW2200_PROMISCUOUS
 	if (rtap_iface) {
 	        err = ipw_prom_alloc(priv);
 		if (err) {
 			IPW_ERROR("Failed to register promiscuous network "
 				  "device (error %d).\n", err);
-			unregister_netdev(priv->net_dev);
-			goto out_remove_sysfs;
+
+			wiphy_unregister(priv->ieee->wdev.wiphy);
+			kfree(priv->ieee->a_band.channels);
+			kfree(priv->ieee->bg_band.channels);
+			goto out_unregister_netdev;
 		}
 	}
 #endif
@@ -11851,6 +11862,8 @@ static int __devinit ipw_pci_probe(struct pci_dev *pdev,
 
 	return 0;
 
+      out_unregister_netdev:
+	unregister_netdev(priv->net_dev);
       out_remove_sysfs:
 	sysfs_remove_group(&pdev->dev.kobj, &ipw_attribute_group);
       out_release_irq:

--AhhlLboLdkugWU4S--
