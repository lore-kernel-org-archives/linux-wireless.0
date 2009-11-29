Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f215.google.com ([209.85.219.215]:42243 "EHLO
	mail-ew0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752734AbZK2EQ3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Nov 2009 23:16:29 -0500
Received: by ewy7 with SMTP id 7so3191653ewy.28
        for <linux-wireless@vger.kernel.org>; Sat, 28 Nov 2009 20:16:34 -0800 (PST)
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: linux-wireless@vger.kernel.org, lrodriguez@atheros.com
Cc: Hin-Tak Leung <HinTak.Leung@gmail.com>,
	Hin-Tak Leung <htl10@users.sourceforge.net>
Subject: [PATCH] compat-2.6: split netdev patch to libertas/main.c into two parts
Date: Sun, 29 Nov 2009 04:16:22 +0000
Message-Id: <1259468182-25499-1-git-send-email-HinTak.Leung@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Split netdev patch to libertas/main.c into two parts, one for
libertas/main.c and one for libertas/mesh.c, because of the file itself
was split in commit in wireless-testing:

commit a4c65e7720b22d0fa76da3b6d00a00bcffd036ab
Author: Holger Schurig <holgerschurig@gmail.com>
Date:   Wed Nov 25 13:10:15 2009 +0100

    libertas: moveing mesh-related functions into mesh.c

Signed-off-by: Hin-Tak Leung <htl10@users.sourceforge.net>

---
 compat/patches/01-netdev.patch |   64 ++++++++++++++++++++-------------------
 1 files changed, 33 insertions(+), 31 deletions(-)

diff --git a/compat/patches/01-netdev.patch b/compat/patches/01-netdev.patch
index d66a2f4..8286bb8 100644
--- a/compat/patches/01-netdev.patch
+++ b/compat/patches/01-netdev.patch
@@ -432,7 +432,37 @@ without creating a headache on maintenance of the pathes.
  	dev->watchdog_timeo = 5 * HZ;
  	dev->ethtool_ops = &lbs_ethtool_ops;
  #ifdef	WIRELESS_EXT
-@@ -1405,6 +1416,7 @@
+@@ -1589,11 +1610,13 @@
+ 	lbs_deb_leave(LBS_DEB_MAIN);
+ }
+ 
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,29))
+ static const struct net_device_ops rtap_netdev_ops = {
+ 	.ndo_open = lbs_rtap_open,
+ 	.ndo_stop = lbs_rtap_stop,
+ 	.ndo_start_xmit = lbs_rtap_hard_start_xmit,
+ };
++#endif
+ 
+ static int lbs_add_rtap(struct lbs_private *priv)
+ {
+@@ -1614,7 +1637,13 @@
+ 
+ 	memcpy(rtap_dev->dev_addr, priv->current_addr, ETH_ALEN);
+ 	rtap_dev->type = ARPHRD_IEEE80211_RADIOTAP;
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,29))
+ 	rtap_dev->netdev_ops = &rtap_netdev_ops;
++#else
++	rtap_dev->open = lbs_rtap_open;
++	rtap_dev->stop = lbs_rtap_stop;
++	rtap_dev->hard_start_xmit = lbs_rtap_hard_start_xmit;
++#endif
+ 	rtap_dev->ml_priv = priv;
+ 	SET_NETDEV_DEV(rtap_dev, priv->dev->dev.parent);
+ 
+--- a/drivers/net/wireless/libertas/mesh.c	2009-11-02 08:04:43.000000000 -0800
++++ b/drivers/net/wireless/libertas/mesh.c	2009-11-02 08:04:44.000000000 -0800
+@@ -305,6 +316,7 @@
  EXPORT_SYMBOL_GPL(lbs_stop_card);
  
  
@@ -440,7 +470,7 @@ without creating a headache on maintenance of the pathes.
  static const struct net_device_ops mesh_netdev_ops = {
  	.ndo_open		= lbs_dev_open,
  	.ndo_stop 		= lbs_mesh_stop,
-@@ -1412,6 +1424,7 @@
+@@ -312,6 +324,7 @@
  	.ndo_set_mac_address	= lbs_set_mac_address,
  	.ndo_set_multicast_list = lbs_set_multicast_list,
  };
@@ -448,7 +478,7 @@ without creating a headache on maintenance of the pathes.
  
  /**
   * @brief This function adds mshX interface
-@@ -1435,7 +1448,15 @@
+@@ -335,7 +348,15 @@
  	mesh_dev->ml_priv = priv;
  	priv->mesh_dev = mesh_dev;
  
@@ -464,34 +494,6 @@ without creating a headache on maintenance of the pathes.
  	mesh_dev->ethtool_ops = &lbs_ethtool_ops;
  	memcpy(mesh_dev->dev_addr, priv->dev->dev_addr,
  			sizeof(priv->dev->dev_addr));
-@@ -1589,11 +1610,13 @@
- 	lbs_deb_leave(LBS_DEB_MAIN);
- }
- 
-+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,29))
- static const struct net_device_ops rtap_netdev_ops = {
- 	.ndo_open = lbs_rtap_open,
- 	.ndo_stop = lbs_rtap_stop,
- 	.ndo_start_xmit = lbs_rtap_hard_start_xmit,
- };
-+#endif
- 
- static int lbs_add_rtap(struct lbs_private *priv)
- {
-@@ -1614,7 +1637,13 @@
- 
- 	memcpy(rtap_dev->dev_addr, priv->current_addr, ETH_ALEN);
- 	rtap_dev->type = ARPHRD_IEEE80211_RADIOTAP;
-+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,29))
- 	rtap_dev->netdev_ops = &rtap_netdev_ops;
-+#else
-+	rtap_dev->open = lbs_rtap_open;
-+	rtap_dev->stop = lbs_rtap_stop;
-+	rtap_dev->hard_start_xmit = lbs_rtap_hard_start_xmit;
-+#endif
- 	rtap_dev->ml_priv = priv;
- 	SET_NETDEV_DEV(rtap_dev, priv->dev->dev.parent);
- 
 --- a/drivers/net/wireless/libertas/defs.h	2009-07-08 14:04:29.692256519 -0700
 +++ b/drivers/net/wireless/libertas/defs.h	2009-07-08 14:03:26.712279246 -0700
 @@ -16,6 +16,14 @@
-- 
1.6.5.2

