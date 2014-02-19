Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:47232 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754615AbaBSTeh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Feb 2014 14:34:37 -0500
Received: by mail-wg0-f50.google.com with SMTP id z12so711535wgg.5
        for <linux-wireless@vger.kernel.org>; Wed, 19 Feb 2014 11:34:35 -0800 (PST)
Message-ID: <1392838458.9073.14.camel@canaries64-MCP7A> (sfid-20140219_203441_238349_D1C530B8)
Subject: [PATCH 1/2] staging: vt6656: Move device_set_multi  code call to
 vRunCommand
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Wed, 19 Feb 2014 19:34:18 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

device_set_multi is an atomic call, in order to reduce atomic area of driver
move code to be called from vRunCommand.

Later the atomic area of vRunCommand can be reduced.

Change existing code in device_set_multi to new function
vnt_configure_filter minus its locks.

Change device_set_multi to call bScheduleCommand

device_set_multi is nolonger called from device open.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/device.h   |  1 +
 drivers/staging/vt6656/main_usb.c | 20 ++++++++++++++------
 drivers/staging/vt6656/wcmd.c     |  9 +++++++++
 drivers/staging/vt6656/wcmd.h     |  4 +++-
 4 files changed, 27 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index 33e5e34..7e774b2 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -789,5 +789,6 @@ struct vnt_private {
                                  (fMP_DISCONNECTED | fMP_RESET_IN_PROGRESS | fMP_HALT_IN_PROGRESS | fMP_INIT_IN_PROGRESS | fMP_SURPRISE_REMOVED)) == 0)
 
 int device_alloc_frag_buf(struct vnt_private *, PSDeFragControlBlock pDeF);
+void vnt_configure_filter(struct vnt_private *);
 
 #endif
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 713844f..7783050 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -974,8 +974,6 @@ static int  device_open(struct net_device *dev)
 		goto free_all;
 	}
 
-    device_set_multi(pDevice->dev);
-
     /* init for key management */
     KeyvInitTable(pDevice,&pDevice->sKey);
 	memcpy(pDevice->vnt_mgmt.abyMACAddr,
@@ -1349,14 +1347,26 @@ static int Read_config_file(struct vnt_private *pDevice)
 static void device_set_multi(struct net_device *dev)
 {
 	struct vnt_private *priv = netdev_priv(dev);
+	unsigned long flags;
+
+	if (priv->flags & DEVICE_FLAGS_OPENED) {
+		spin_lock_irqsave(&priv->lock, flags);
+
+		bScheduleCommand(priv, WLAN_CMD_CONFIGURE_FILTER, NULL);
+
+		spin_unlock_irqrestore(&priv->lock, flags);
+	}
+}
+
+void vnt_configure_filter(struct vnt_private *priv)
+{
+	struct net_device *dev = priv->dev;
 	struct vnt_manager *mgmt = &priv->vnt_mgmt;
 	struct netdev_hw_addr *ha;
 	u64 mc_filter = 0;
 	u8 tmp = 0;
 	int rc;
 
-	spin_lock_irq(&priv->lock);
-
 	rc = CONTROLnsRequestIn(priv, MESSAGE_TYPE_READ,
 		MAC_REG_RCR, MESSAGE_REQUEST_MACREG, 1, &tmp);
 	if (rc == 0)
@@ -1403,8 +1413,6 @@ static void device_set_multi(struct net_device *dev)
 
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
 				"priv->byRxMode out= %x\n", priv->byRxMode);
-
-	spin_unlock_irq(&priv->lock);
 }
 
 static struct net_device_stats *device_get_stats(struct net_device *dev)
diff --git a/drivers/staging/vt6656/wcmd.c b/drivers/staging/vt6656/wcmd.c
index 6b95229..8c702c3 100644
--- a/drivers/staging/vt6656/wcmd.c
+++ b/drivers/staging/vt6656/wcmd.c
@@ -909,6 +909,10 @@ void vRunCommand(struct work_struct *work)
 		s_bCommandComplete(pDevice);
 		break;
 
+	case WLAN_CMD_CONFIGURE_FILTER_START:
+		vnt_configure_filter(pDevice);
+		s_bCommandComplete(pDevice);
+		break;
 	default:
 		s_bCommandComplete(pDevice);
 		break;
@@ -1009,6 +1013,11 @@ static int s_bCommandComplete(struct vnt_private *pDevice)
 			pDevice->eCommandState = WLAN_CMD_11H_CHSW_START;
 			break;
 
+		case WLAN_CMD_CONFIGURE_FILTER:
+			pDevice->eCommandState =
+						WLAN_CMD_CONFIGURE_FILTER_START;
+			break;
+
 		default:
 			break;
 		}
diff --git a/drivers/staging/vt6656/wcmd.h b/drivers/staging/vt6656/wcmd.h
index caf2684..7365721 100644
--- a/drivers/staging/vt6656/wcmd.h
+++ b/drivers/staging/vt6656/wcmd.h
@@ -51,7 +51,8 @@ typedef enum tagCMD_CODE {
     WLAN_CMD_REMOVE_ALLKEY,
     WLAN_CMD_MAC_DISPOWERSAVING,
     WLAN_CMD_11H_CHSW,
-    WLAN_CMD_RUN_AP
+    WLAN_CMD_RUN_AP,
+    WLAN_CMD_CONFIGURE_FILTER
 } CMD_CODE, *PCMD_CODE;
 
 #define CMD_Q_SIZE              32
@@ -96,6 +97,7 @@ typedef enum tagCMD_STATE {
     WLAN_CMD_REMOVE_ALLKEY_START,
     WLAN_CMD_MAC_DISPOWERSAVING_START,
     WLAN_CMD_11H_CHSW_START,
+    WLAN_CMD_CONFIGURE_FILTER_START,
     WLAN_CMD_IDLE
 } CMD_STATE, *PCMD_STATE;
 
-- 
1.9.rc1




