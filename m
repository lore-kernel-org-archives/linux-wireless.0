Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:40432 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227Ab2KXOoh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Nov 2012 09:44:37 -0500
Received: by mail-wg0-f44.google.com with SMTP id dr13so1157093wgb.1
        for <linux-wireless@vger.kernel.org>; Sat, 24 Nov 2012 06:44:36 -0800 (PST)
Message-ID: <1353768269.2318.9.camel@user64-MCP7A> (sfid-20121124_154441_580371_B35704BF)
Subject: [PATCH 06/10] staging: vt6656: cleanup of
 device_ioctl/net_device_stats
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Sat, 24 Nov 2012 14:44:29 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Also remove IOCTL_CMD_TEST.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/main_usb.c |   55 ++++++++-----------------------------
 1 file changed, 12 insertions(+), 43 deletions(-)

diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index a667e39..4a0f9dc 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -1502,66 +1502,35 @@ static void device_set_multi(struct net_device *dev) {
 
 }
 
-
-static struct net_device_stats *device_get_stats(struct net_device *dev) {
+static struct net_device_stats *device_get_stats(struct net_device *dev)
+{
     PSDevice pDevice=(PSDevice) netdev_priv(dev);
 
     return &pDevice->stats;
 }
 
-
-static int  device_ioctl(struct net_device *dev, struct ifreq *rq, int cmd) {
+static int device_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
+{
 	PSDevice pDevice = (PSDevice)netdev_priv(dev);
-	PSMgmtObject pMgmt = &pDevice->sMgmtObj;
-	PSCmdRequest pReq;
 	struct iwreq *wrq = (struct iwreq *) rq;
 	int rc = 0;
 
-    if (pMgmt == NULL) {
-        rc = -EFAULT;
-        return rc;
-    }
-
-    switch(cmd) {
-
+	switch (cmd) {
 
-    case IOCTL_CMD_TEST:
+	case IOCTL_CMD_HOSTAPD:
 
-		if (!(pDevice->flags & DEVICE_FLAGS_OPENED)) {
-		    rc = -EFAULT;
-		    break;
-		} else {
-		    rc = 0;
-		}
-        pReq = (PSCmdRequest)rq;
-
-   //20080130-01,<Remark> by Mike Liu
-      // if(pDevice->bLinkPass==TRUE)
-          pReq->wResult = MAGIC_CODE;         //Linking status:0x3142
-   //20080130-02,<Remark> by Mike Liu
-      //  else
-      //	 pReq->wResult = MAGIC_CODE+1;    //disconnect status:0x3143
-        break;
-
-    case IOCTL_CMD_HOSTAPD:
-
-		if (!(pDevice->flags & DEVICE_FLAGS_OPENED)) {
-		    rc = -EFAULT;
-		    break;
-		} else {
-		    rc = 0;
-		}
+		if (!(pDevice->flags & DEVICE_FLAGS_OPENED))
+			rc = -EFAULT;
 
 		rc = vt6656_hostap_ioctl(pDevice, &wrq->u.data);
-        break;
+		break;
 
 	case SIOCETHTOOL:
-        return ethtool_ioctl(dev, (void *) rq->ifr_data);
-
-    }
+		return ethtool_ioctl(dev, (void *) rq->ifr_data);
 
+	}
 
-    return rc;
+	return rc;
 }
 

-- 
1.7.10.4



