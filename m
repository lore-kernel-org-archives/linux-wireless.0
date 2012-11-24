Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:63045 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227Ab2KXOrS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Nov 2012 09:47:18 -0500
Received: by mail-wg0-f42.google.com with SMTP id dr1so1342206wgb.1
        for <linux-wireless@vger.kernel.org>; Sat, 24 Nov 2012 06:47:17 -0800 (PST)
Message-ID: <1353768431.2318.11.camel@user64-MCP7A> (sfid-20121124_154722_037427_F910F442)
Subject: [PATCH 07/10] staging: vt6656: remove redundant IWEVCUSTOM events.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Sat, 24 Nov 2012 14:47:11 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/bssdb.c    |    8 --------
 drivers/staging/vt6656/iwctl.c    |    7 -------
 drivers/staging/vt6656/main_usb.c |   36 ++----------------------------------
 3 files changed, 2 insertions(+), 49 deletions(-)

diff --git a/drivers/staging/vt6656/bssdb.c b/drivers/staging/vt6656/bssdb.c
index 68db037..6a13941 100644
--- a/drivers/staging/vt6656/bssdb.c
+++ b/drivers/staging/vt6656/bssdb.c
@@ -925,14 +925,6 @@ if(pDevice->byReAssocCount > 0) {
    	pDevice->byReAssocCount = 0;
 }
 
-if((pMgmt->eCurrState!=WMAC_STATE_ASSOC) &&
-     (pMgmt->eLastState==WMAC_STATE_ASSOC))
-{
-  union iwreq_data      wrqu;
-  memset(&wrqu, 0, sizeof(wrqu));
-  wrqu.data.flags = RT_DISCONNECTED_EVENT_FLAG;
-  wireless_send_event(pDevice->dev, IWEVCUSTOM, &wrqu, NULL);
-}
  pMgmt->eLastState = pMgmt->eCurrState ;
 
    s_uCalculateLinkQual((void *)pDevice);
diff --git a/drivers/staging/vt6656/iwctl.c b/drivers/staging/vt6656/iwctl.c
index f344b55..db5bc62 100644
--- a/drivers/staging/vt6656/iwctl.c
+++ b/drivers/staging/vt6656/iwctl.c
@@ -181,7 +181,6 @@ int iwctl_giwscan(struct net_device *dev, struct iw_request_info *info,
 	char *current_val = NULL;
 	struct iw_event iwe;
 	long ldBm;
-	char buf[MAX_WPA_IE_LEN * 2 + 30];
 
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWSCAN\n");
 
@@ -286,12 +285,6 @@ int iwctl_giwscan(struct net_device *dev, struct iw_request_info *info,
 			if ((current_val - current_ev) > IW_EV_LCP_LEN)
 				current_ev = current_val;
 
-			memset(&iwe, 0, sizeof(iwe));
-			iwe.cmd = IWEVCUSTOM;
-			sprintf(buf, "bcn_int=%d", pBSS->wBeaconInterval);
-			iwe.u.data.length = strlen(buf);
-			current_ev = iwe_stream_add_point(info, current_ev, end_buf, &iwe, buf);
-
 			if ((pBSS->wWPALen > 0) && (pBSS->wWPALen <= MAX_WPA_IE_LEN)) {
 				memset(&iwe, 0, sizeof(iwe));
 				iwe.cmd = IWEVGENIE;
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 4a0f9dc..f33086d 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -722,17 +722,6 @@ vt6656_probe(struct usb_interface *intf, const struct usb_device_id *id)
 
 	usb_device_reset(pDevice);
 
-	{
-		union iwreq_data wrqu;
-		memset(&wrqu, 0, sizeof(wrqu));
-		wrqu.data.flags = RT_INSMOD_EVENT_FLAG;
-		wrqu.data.length = IFNAMSIZ;
-		wireless_send_event(pDevice->dev,
-				    IWEVCUSTOM,
-				    &wrqu,
-				    pDevice->dev->name);
-	}
-
 	return 0;
 
 err_netdev:
@@ -1052,15 +1041,8 @@ static int  device_open(struct net_device *dev) {
     netif_stop_queue(pDevice->dev);
     pDevice->flags |= DEVICE_FLAGS_OPENED;
 
-{
-  union iwreq_data      wrqu;
-  memset(&wrqu, 0, sizeof(wrqu));
-  wrqu.data.flags = RT_UPDEV_EVENT_FLAG;
-  wireless_send_event(pDevice->dev, IWEVCUSTOM, &wrqu, NULL);
-}
-
-    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "device_open success.. \n");
-    return 0;
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "device_open success..\n");
+	return 0;
 
 free_all:
     device_free_frag_bufs(pDevice);
@@ -1089,13 +1071,6 @@ static int  device_close(struct net_device *dev) {
     if (pDevice == NULL)
         return -ENODEV;
 
-{
-  union iwreq_data      wrqu;
-  memset(&wrqu, 0, sizeof(wrqu));
-  wrqu.data.flags = RT_DOWNDEV_EVENT_FLAG;
-  wireless_send_event(pDevice->dev, IWEVCUSTOM, &wrqu, NULL);
-}
-
     if (pDevice->bLinkPass) {
 	bScheduleCommand((void *) pDevice, WLAN_CMD_DISASSOCIATE, NULL);
         mdelay(30);
@@ -1166,13 +1141,6 @@ static void vt6656_disconnect(struct usb_interface *intf)
 	if (!device)
 		return;
 
-	{
-		union iwreq_data req;
-		memset(&req, 0, sizeof(req));
-		req.data.flags = RT_RMMOD_EVENT_FLAG;
-		wireless_send_event(device->dev, IWEVCUSTOM, &req, NULL);
-	}
-
 
 	usb_set_intfdata(intf, NULL);
 	usb_put_dev(interface_to_usbdev(intf));
-- 
1.7.10.4



