Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ms5.Sony.CO.JP ([211.125.136.201]:53174 "EHLO ms5.sony.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752187AbYENFS0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 May 2008 01:18:26 -0400
Date: Wed, 14 May 2008 14:16:50 +0900
From: Masakazu Mokuno <mokuno@sm.sony.co.jp>
To: linux-wireless@vger.kernel.org, yi.zhu@intel.com, dcbw@redhat.com
Subject: [PATCH] wireless: Create 'device' symlink in sysfs
Message-Id: <20080514124516.A06B.40F06B3A@sm.sony.co.jp> (sfid-20080514_071831_987414_0AAFC039)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some network interfaces of the wireless drivers lack the 'device'
symlink in sysfs.
This patch lets the drivers create the links.

Signed-off-by: Masakazu Mokuno <mokuno@sm.sony.co.jp>
---
 drivers/net/wireless/airo.c          |    1 +
 drivers/net/wireless/ipw2200.c       |    1 +
 drivers/net/wireless/libertas/main.c |    1 +
 3 files changed, 3 insertions(+)

--- a/drivers/net/wireless/airo.c
+++ b/drivers/net/wireless/airo.c
@@ -2668,6 +2668,7 @@ static struct net_device *init_wifidev(s
 	dev->irq = ethdev->irq;
 	dev->base_addr = ethdev->base_addr;
 	dev->wireless_data = ethdev->wireless_data;
+	SET_NETDEV_DEV(dev, ethdev->dev.parent);
 	memcpy(dev->dev_addr, ethdev->dev_addr, dev->addr_len);
 	err = register_netdev(dev);
 	if (err<0) {
--- a/drivers/net/wireless/ipw2200.c
+++ b/drivers/net/wireless/ipw2200.c
@@ -11584,6 +11584,7 @@ static int ipw_prom_alloc(struct ipw_pri
 	priv->prom_net_dev->hard_start_xmit = ipw_prom_hard_start_xmit;
 
 	priv->prom_priv->ieee->iw_mode = IW_MODE_MONITOR;
+	SET_NETDEV_DEV(priv->prom_net_dev, &priv->pci_dev->dev);
 
 	rc = register_netdev(priv->prom_net_dev);
 	if (rc) {
--- a/drivers/net/wireless/libertas/main.c
+++ b/drivers/net/wireless/libertas/main.c
@@ -1566,6 +1566,7 @@ static int lbs_add_rtap(struct lbs_priva
 	rtap_dev->hard_start_xmit = lbs_rtap_hard_start_xmit;
 	rtap_dev->set_multicast_list = lbs_set_multicast_list;
 	rtap_dev->priv = priv;
+	SET_NETDEV_DEV(rtap_dev, priv->dev->dev.parent);
 
 	ret = register_netdev(rtap_dev);
 	if (ret) {

-- 
Masakazu Mokuno

