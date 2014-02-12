Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f180.google.com ([74.125.82.180]:41058 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752641AbaBLTYp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Feb 2014 14:24:45 -0500
Received: by mail-we0-f180.google.com with SMTP id u57so6512190wes.11
        for <linux-wireless@vger.kernel.org>; Wed, 12 Feb 2014 11:24:44 -0800 (PST)
Message-ID: <1392232848.4053.6.camel@canaries32-MCP7A> (sfid-20140212_202448_048785_424F7F18)
Subject: [PATCH 2/3] staging: vt6656: device_set_multi: set filter off with
 MACvWriteMultiAddr
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 Feb 2014 19:20:48 +0000
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

set u64 mc_filter to ~0x0 multi cast filter off and write MAC_REG_MAR0 using
MACvWriteMultiAddr to replace pbyData.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/main_usb.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index c5e9dee2..e682c9d 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -1354,7 +1354,6 @@ static void device_set_multi(struct net_device *dev)
 	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
 	struct netdev_hw_addr *ha;
 	u64 mc_filter = 0;
-	u8 pbyData[8] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
 	u8 byTmpMode = 0;
 	int rc;
 
@@ -1377,13 +1376,9 @@ static void device_set_multi(struct net_device *dev)
     }
     else if ((netdev_mc_count(dev) > pDevice->multicast_limit) ||
 	     (dev->flags & IFF_ALLMULTI)) {
-        CONTROLnsRequestOut(pDevice,
-                            MESSAGE_TYPE_WRITE,
-                            MAC_REG_MAR0,
-                            MESSAGE_REQUEST_MACREG,
-                            8,
-                            pbyData
-                            );
+	mc_filter = ~0x0;
+	MACvWriteMultiAddr(pDevice, mc_filter);
+
         pDevice->byRxMode |= (RCR_MULTICAST|RCR_BROADCAST);
     }
     else {
-- 
1.8.5.3

