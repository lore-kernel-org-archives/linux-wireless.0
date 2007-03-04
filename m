Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ms-smtp-03.rdc-kc.rr.com ([24.94.166.129]:45014 "EHLO
	ms-smtp-03.rdc-kc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364AbXCDBBT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 Mar 2007 20:01:19 -0500
Date: Sat, 03 Mar 2007 19:00:36 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John Linville <linville@tuxdriver.com>
Cc: Michael Buesch <mb@bu3sch.de>, Bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org
Subject: [PATCH] bcm43xx: remove ethtool
Message-ID: <45ea1a34.Lf4EKmMy+KAmSkH0%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ethtool is useless for bcm43xx - remove it.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---


Index: wireless-2.6/drivers/net/wireless/bcm43xx/Makefile
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/bcm43xx/Makefile
+++ wireless-2.6/drivers/net/wireless/bcm43xx/Makefile
@@ -7,6 +7,6 @@ bcm43xx-obj-$(CONFIG_BCM43XX_PIO) += bcm
 bcm43xx-objs := bcm43xx_main.o bcm43xx_ilt.o \
 		bcm43xx_radio.o bcm43xx_phy.o \
 		bcm43xx_power.o bcm43xx_wx.o \
-		bcm43xx_leds.o bcm43xx_ethtool.o \
+		bcm43xx_leds.o  \
 		bcm43xx_xmit.o bcm43xx_sysfs.o \
 		$(bcm43xx-obj-y)
Index: wireless-2.6/drivers/net/wireless/bcm43xx/bcm43xx_ethtool.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/bcm43xx/bcm43xx_ethtool.c
+++ /dev/null
@@ -1,50 +0,0 @@
-/*
-
-  Broadcom BCM43xx wireless driver
-
-  ethtool support
-
-  Copyright (c) 2006 Jason Lunz <lunz@falooley.org>
-
-  Some code in this file is derived from the 8139too.c driver
-  Copyright (C) 2002 Jeff Garzik
-
-  This program is free software; you can redistribute it and/or modify
-  it under the terms of the GNU General Public License as published by
-  the Free Software Foundation; either version 2 of the License, or
-  (at your option) any later version.
-
-  This program is distributed in the hope that it will be useful,
-  but WITHOUT ANY WARRANTY; without even the implied warranty of
-  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-  GNU General Public License for more details.
-
-  You should have received a copy of the GNU General Public License
-  along with this program; see the file COPYING.  If not, write to
-  the Free Software Foundation, Inc., 51 Franklin Steet, Fifth Floor,
-  Boston, MA 02110-1301, USA.
-
-*/
-
-#include "bcm43xx.h"
-#include "bcm43xx_ethtool.h"
-
-#include <linux/netdevice.h>
-#include <linux/pci.h>
-#include <linux/string.h>
-#include <linux/utsrelease.h>
-
-
-static void bcm43xx_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *info)
-{
-	struct bcm43xx_private *bcm = bcm43xx_priv(dev);
-
-	strncpy(info->driver, KBUILD_MODNAME, sizeof(info->driver));
-	strncpy(info->version, UTS_RELEASE, sizeof(info->version));
-	strncpy(info->bus_info, pci_name(bcm->pci_dev), ETHTOOL_BUSINFO_LEN);
-}
-
-const struct ethtool_ops bcm43xx_ethtool_ops = {
-	.get_drvinfo = bcm43xx_get_drvinfo,
-	.get_link = ethtool_op_get_link,
-};
Index: wireless-2.6/drivers/net/wireless/bcm43xx/bcm43xx_ethtool.h
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/bcm43xx/bcm43xx_ethtool.h
+++ /dev/null
@@ -1,8 +0,0 @@
-#ifndef BCM43xx_ETHTOOL_H_
-#define BCM43xx_ETHTOOL_H_
-
-#include <linux/ethtool.h>
-
-extern const struct ethtool_ops bcm43xx_ethtool_ops;
-
-#endif /* BCM43xx_ETHTOOL_H_ */
Index: wireless-2.6/drivers/net/wireless/bcm43xx/bcm43xx_main.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/bcm43xx/bcm43xx_main.c
+++ wireless-2.6/drivers/net/wireless/bcm43xx/bcm43xx_main.c
@@ -50,7 +50,6 @@
 #include "bcm43xx_pio.h"
 #include "bcm43xx_power.h"
 #include "bcm43xx_wx.h"
-#include "bcm43xx_ethtool.h"
 #include "bcm43xx_xmit.h"
 #include "bcm43xx_sysfs.h"
 
@@ -4155,7 +4154,6 @@ static int __devinit bcm43xx_init_one(st
 #endif
 	net_dev->wireless_handlers = &bcm43xx_wx_handlers_def;
 	net_dev->irq = pdev->irq;
-	SET_ETHTOOL_OPS(net_dev, &bcm43xx_ethtool_ops);
 
 	/* initialize the bcm43xx_private struct */
 	bcm = bcm43xx_priv(net_dev);
