Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ms-smtp-04.rdc-kc.rr.com ([24.94.166.116]:49367 "EHLO
	ms-smtp-04.rdc-kc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411AbXCDSzu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Mar 2007 13:55:50 -0500
Date: Sun, 04 Mar 2007 12:55:14 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John Linville <linville@tuxdriver.com>
Cc: Michael Buesch <mb@bu3sch.de>, Bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org
Subject: [PATCH] bcm43xx: Add firmware version to ethtool output
Message-ID: <45eb1612.l8xsd6TwZVsRseAH%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As the removal of ethtool capability from bcm43xx has been NACKed,
some useful functionality should be added. This patch changes it
so that the firmware version is output.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Index: wireless-2.6/drivers/net/wireless/bcm43xx/bcm43xx_ethtool.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/bcm43xx/bcm43xx_ethtool.c
+++ wireless-2.6/drivers/net/wireless/bcm43xx/bcm43xx_ethtool.c
@@ -27,6 +27,7 @@
 */
 
 #include "bcm43xx.h"
+#include "bcm43xx_main.h"
 #include "bcm43xx_ethtool.h"
 
 #include <linux/netdevice.h>
@@ -42,6 +43,8 @@ static void bcm43xx_get_drvinfo(struct n
 	strncpy(info->driver, KBUILD_MODNAME, sizeof(info->driver));
 	strncpy(info->version, utsname()->release, sizeof(info->version));
 	strncpy(info->bus_info, pci_name(bcm->pci_dev), ETHTOOL_BUSINFO_LEN);
+	snprintf(info->fw_version, sizeof(info->fw_version), "0x%x",
+		 bcm43xx_shm_read16(bcm, BCM43xx_SHM_SHARED, BCM43xx_UCODE_REVISION));
 }
 
 const struct ethtool_ops bcm43xx_ethtool_ops = {
