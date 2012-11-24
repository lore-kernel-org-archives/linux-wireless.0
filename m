Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:47212 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027Ab2KXOcW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Nov 2012 09:32:22 -0500
Received: by mail-wi0-f178.google.com with SMTP id hm6so2258659wib.1
        for <linux-wireless@vger.kernel.org>; Sat, 24 Nov 2012 06:32:21 -0800 (PST)
Message-ID: <1353767064.2318.4.camel@user64-MCP7A> (sfid-20121124_153234_540179_59B0EE34)
Subject: [PATCH 03/10] staging: vt6656: remove wpahdr from driver.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Sat, 24 Nov 2012 14:24:24 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


wpahdr relates to redundant viawget, a proprietary version of wpa supplicant.


 Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>

---
 drivers/staging/vt6656/bssdb.c    |   29 -------------------
 drivers/staging/vt6656/dpc.c      |   25 -----------------
 drivers/staging/vt6656/main_usb.c |   37 ------------------------
 drivers/staging/vt6656/wmgr.c     |   56 -------------------------------------
 4 files changed, 147 deletions(-)

diff --git a/drivers/staging/vt6656/bssdb.c b/drivers/staging/vt6656/bssdb.c
index f1d852b2..68db037 100644
--- a/drivers/staging/vt6656/bssdb.c
+++ b/drivers/staging/vt6656/bssdb.c
@@ -882,7 +882,6 @@ void BSSvSecondCallBack(void *hDeviceContext)
     unsigned int            uSleepySTACnt = 0;
     unsigned int            uNonShortSlotSTACnt = 0;
     unsigned int            uLongPreambleSTACnt = 0;
-    viawget_wpa_header *wpahdr;
 
     spin_lock_irq(&pDevice->lock);
 
@@ -1100,20 +1099,6 @@ if((pMgmt->eCurrState!=WMAC_STATE_ASSOC) &&
 
                 DBG_PRT(MSG_LEVEL_NOTICE, KERN_INFO "Lost AP beacon [%d] sec, disconnected !\n", pMgmt->sNodeDBTable[0].uInActiveCount);
 		/* let wpa supplicant know AP may disconnect */
-        if ((pDevice->bWPADEVUp) && (pDevice->skb != NULL)) {
-             wpahdr = (viawget_wpa_header *)pDevice->skb->data;
-             wpahdr->type = VIAWGET_DISASSOC_MSG;
-             wpahdr->resp_ie_len = 0;
-             wpahdr->req_ie_len = 0;
-             skb_put(pDevice->skb, sizeof(viawget_wpa_header));
-             pDevice->skb->dev = pDevice->wpadev;
-	     skb_reset_mac_header(pDevice->skb);
-             pDevice->skb->pkt_type = PACKET_HOST;
-             pDevice->skb->protocol = htons(ETH_P_802_2);
-             memset(pDevice->skb->cb, 0, sizeof(pDevice->skb->cb));
-             netif_rx(pDevice->skb);
-             pDevice->skb = dev_alloc_skb((int)pDevice->rx_buf_sz);
-         }
       {
 	union iwreq_data  wrqu;
 	memset(&wrqu, 0, sizeof (wrqu));
@@ -1140,20 +1125,6 @@ DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "bIsRoaming %d, !\n", pDevice->bIsRoaming );
                 pDevice->uAutoReConnectTime = 0;
                 pDevice->uIsroamingTime = 0;
                 pDevice->bRoaming = FALSE;
-
-             wpahdr = (viawget_wpa_header *)pDevice->skb->data;
-             wpahdr->type = VIAWGET_CCKM_ROAM_MSG;
-             wpahdr->resp_ie_len = 0;
-             wpahdr->req_ie_len = 0;
-             skb_put(pDevice->skb, sizeof(viawget_wpa_header));
-             pDevice->skb->dev = pDevice->wpadev;
-	     skb_reset_mac_header(pDevice->skb);
-             pDevice->skb->pkt_type = PACKET_HOST;
-             pDevice->skb->protocol = htons(ETH_P_802_2);
-             memset(pDevice->skb->cb, 0, sizeof(pDevice->skb->cb));
-             netif_rx(pDevice->skb);
-            pDevice->skb = dev_alloc_skb((int)pDevice->rx_buf_sz);
-
           }
       else if ((pDevice->bRoaming == FALSE)&&(pDevice->bIsRoaming == TRUE)) {
                             pDevice->uIsroamingTime++;
diff --git a/drivers/staging/vt6656/dpc.c b/drivers/staging/vt6656/dpc.c
index c6f5395..e94f6a1 100644
--- a/drivers/staging/vt6656/dpc.c
+++ b/drivers/staging/vt6656/dpc.c
@@ -818,7 +818,6 @@ RXbBulkInProcessData (
             DWORD           dwMICKey0 = 0, dwMICKey1 = 0;
             DWORD           dwLocalMIC_L = 0;
             DWORD           dwLocalMIC_R = 0;
-            viawget_wpa_header *wpahdr;
 

             if (pMgmt->eCurrMode == WMAC_MODE_ESS_AP) {
@@ -889,30 +888,6 @@ RXbBulkInProcessData (
 
 				}
 
-
-                if ((pDevice->bWPADEVUp) && (pDevice->skb != NULL)) {
-                     wpahdr = (viawget_wpa_header *)pDevice->skb->data;
-                     if ((pMgmt->eCurrMode == WMAC_MODE_ESS_STA) &&
-                         (pMgmt->eCurrState == WMAC_STATE_ASSOC) &&
-                         (*pbyRsr & (RSR_ADDRBROAD | RSR_ADDRMULTI)) == 0) {
-                         //s802_11_Status.Flags = NDIS_802_11_AUTH_REQUEST_PAIRWISE_ERROR;
-                         wpahdr->type = VIAWGET_PTK_MIC_MSG;
-                     } else {
-                         //s802_11_Status.Flags = NDIS_802_11_AUTH_REQUEST_GROUP_ERROR;
-                         wpahdr->type = VIAWGET_GTK_MIC_MSG;
-                     }
-                     wpahdr->resp_ie_len = 0;
-                     wpahdr->req_ie_len = 0;
-                     skb_put(pDevice->skb, sizeof(viawget_wpa_header));
-                     pDevice->skb->dev = pDevice->wpadev;
-		     skb_reset_mac_header(pDevice->skb);
-                     pDevice->skb->pkt_type = PACKET_HOST;
-                     pDevice->skb->protocol = htons(ETH_P_802_2);
-                     memset(pDevice->skb->cb, 0, sizeof(pDevice->skb->cb));
-                     netif_rx(pDevice->skb);
-			return TRUE;
-                 }
-
                 return FALSE;
 
             }
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 0c1f379..c70bafb 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -244,7 +244,6 @@ static int Config_FileGetParameter(unsigned char *string,
 				   unsigned char *dest,
 				   unsigned char *source);
 
-static BOOL device_release_WPADEV(PSDevice pDevice);
 
 static void usb_device_reset(PSDevice pDevice);
 
@@ -634,40 +633,6 @@ static BOOL device_init_registers(PSDevice pDevice, DEVICE_INIT_TYPE InitType)
     return TRUE;
 }
 
-static BOOL device_release_WPADEV(PSDevice pDevice)
-{
-  viawget_wpa_header *wpahdr;
-  int ii=0;
- // wait_queue_head_t	Set_wait;
-  //send device close to wpa_supplicant layer
-    if (pDevice->bWPADEVUp==TRUE) {
-                 wpahdr = (viawget_wpa_header *)pDevice->skb->data;
-                 wpahdr->type = VIAWGET_DEVICECLOSE_MSG;
-                 wpahdr->resp_ie_len = 0;
-                 wpahdr->req_ie_len = 0;
-                 skb_put(pDevice->skb, sizeof(viawget_wpa_header));
-                 pDevice->skb->dev = pDevice->wpadev;
-		 skb_reset_mac_header(pDevice->skb);
-                 pDevice->skb->pkt_type = PACKET_HOST;
-                 pDevice->skb->protocol = htons(ETH_P_802_2);
-                 memset(pDevice->skb->cb, 0, sizeof(pDevice->skb->cb));
-                 netif_rx(pDevice->skb);
-                 pDevice->skb = dev_alloc_skb((int)pDevice->rx_buf_sz);
-
- //wait release WPADEV
-              //    init_waitqueue_head(&Set_wait);
-              //    wait_event_timeout(Set_wait, ((pDevice->wpadev==NULL)&&(pDevice->skb == NULL)),5*HZ);    //1s wait
-              while(pDevice->bWPADEVUp==TRUE) {
-	        set_current_state(TASK_UNINTERRUPTIBLE);
-                 schedule_timeout (HZ/20);          //wait 50ms
-                 ii++;
-	        if(ii>20)
-		  break;
-              }
-           }
-    return TRUE;
-}
-
 #ifdef CONFIG_PM	/* Minimal support for suspend and resume */
 
 static int vt6656_suspend(struct usb_interface *intf, pm_message_t message)
@@ -1143,7 +1108,6 @@ static int  device_close(struct net_device *dev) {
         mdelay(30);
     }
 
-device_release_WPADEV(pDevice);
 
         memset(pMgmt->abyDesireSSID, 0, WLAN_IEHDR_LEN + WLAN_SSID_MAXLEN + 1);
         pMgmt->bShareKeyAlgorithm = FALSE;
@@ -1216,7 +1180,6 @@ static void vt6656_disconnect(struct usb_interface *intf)
 		wireless_send_event(device->dev, IWEVCUSTOM, &req, NULL);
 	}
 
-	device_release_WPADEV(device);
 
 	usb_set_intfdata(intf, NULL);
 	usb_put_dev(interface_to_usbdev(intf));
diff --git a/drivers/staging/vt6656/wmgr.c b/drivers/staging/vt6656/wmgr.c
index 20b3618..95ddc83 100644
--- a/drivers/staging/vt6656/wmgr.c
+++ b/drivers/staging/vt6656/wmgr.c
@@ -925,7 +925,6 @@ s_vMgrRxAssocResponse(
     WLAN_FR_ASSOCRESP   sFrame;
     PWLAN_IE_SSID   pItemSSID;
     PBYTE   pbyIEs;
-    viawget_wpa_header *wpahdr;
 


@@ -973,30 +972,6 @@ s_vMgrRxAssocResponse(
             DBG_PRT(MSG_LEVEL_INFO, KERN_INFO "Link with AP(SSID): %s\n", pItemSSID->abySSID);
             pDevice->bLinkPass = TRUE;
             ControlvMaskByte(pDevice,MESSAGE_REQUEST_MACREG,MAC_REG_PAPEDELAY,LEDSTS_STS,LEDSTS_INTER);
-            if ((pDevice->bWPADEVUp) && (pDevice->skb != NULL)) {
-	       if(skb_tailroom(pDevice->skb) <(sizeof(viawget_wpa_header)+pMgmt->sAssocInfo.AssocInfo.ResponseIELength+
-		   	                                                 pMgmt->sAssocInfo.AssocInfo.RequestIELength)) {    //data room not enough
-                     dev_kfree_skb(pDevice->skb);
-		   pDevice->skb = dev_alloc_skb((int)pDevice->rx_buf_sz);
-	       	}
-                wpahdr = (viawget_wpa_header *)pDevice->skb->data;
-                wpahdr->type = VIAWGET_ASSOC_MSG;
-                wpahdr->resp_ie_len = pMgmt->sAssocInfo.AssocInfo.ResponseIELength;
-                wpahdr->req_ie_len = pMgmt->sAssocInfo.AssocInfo.RequestIELength;
-                memcpy(pDevice->skb->data + sizeof(viawget_wpa_header), pMgmt->sAssocInfo.abyIEs, wpahdr->req_ie_len);
-                memcpy(pDevice->skb->data + sizeof(viawget_wpa_header) + wpahdr->req_ie_len,
-                       pbyIEs,
-                       wpahdr->resp_ie_len
-                       );
-                skb_put(pDevice->skb, sizeof(viawget_wpa_header) + wpahdr->resp_ie_len + wpahdr->req_ie_len);
-                pDevice->skb->dev = pDevice->wpadev;
-		skb_reset_mac_header(pDevice->skb);
-                pDevice->skb->pkt_type = PACKET_HOST;
-                pDevice->skb->protocol = htons(ETH_P_802_2);
-                memset(pDevice->skb->cb, 0, sizeof(pDevice->skb->cb));
-                netif_rx(pDevice->skb);
-                pDevice->skb = dev_alloc_skb((int)pDevice->rx_buf_sz);
-            }
 
 	//if(pDevice->bWPASuppWextEnabled == TRUE)
 	   {
@@ -1583,7 +1558,6 @@ s_vMgrRxDisassociation(
     WLAN_FR_DISASSOC    sFrame;
     unsigned int        uNodeIndex = 0;
     CMD_STATUS          CmdStatus;
-    viawget_wpa_header *wpahdr;
 
     if ( pMgmt->eCurrMode == WMAC_MODE_ESS_AP ){
         // if is acting an AP..
@@ -1604,20 +1578,6 @@ s_vMgrRxDisassociation(
         DBG_PRT(MSG_LEVEL_NOTICE, KERN_INFO "AP disassociated me, reason=%d.\n", cpu_to_le16(*(sFrame.pwReason)));
 
           pDevice->fWPA_Authened = FALSE;
-	if ((pDevice->bWPADEVUp) && (pDevice->skb != NULL)) {
-             wpahdr = (viawget_wpa_header *)pDevice->skb->data;
-             wpahdr->type = VIAWGET_DISASSOC_MSG;
-             wpahdr->resp_ie_len = 0;
-             wpahdr->req_ie_len = 0;
-             skb_put(pDevice->skb, sizeof(viawget_wpa_header));
-             pDevice->skb->dev = pDevice->wpadev;
-	     skb_reset_mac_header(pDevice->skb);
-             pDevice->skb->pkt_type = PACKET_HOST;
-             pDevice->skb->protocol = htons(ETH_P_802_2);
-             memset(pDevice->skb->cb, 0, sizeof(pDevice->skb->cb));
-             netif_rx(pDevice->skb);
-             pDevice->skb = dev_alloc_skb((int)pDevice->rx_buf_sz);
-         }
 
         //TODO: do something let upper layer know or
         //try to send associate packet again because of inactivity timeout
@@ -1670,7 +1630,6 @@ s_vMgrRxDeauthentication(
 {
     WLAN_FR_DEAUTHEN    sFrame;
     unsigned int        uNodeIndex = 0;
-    viawget_wpa_header *wpahdr;
 

     if (pMgmt->eCurrMode == WMAC_MODE_ESS_AP ){
@@ -1706,21 +1665,6 @@ s_vMgrRxDeauthentication(
                 }
             }
 
-            if ((pDevice->bWPADEVUp) && (pDevice->skb != NULL)) {
-                 wpahdr = (viawget_wpa_header *)pDevice->skb->data;
-                 wpahdr->type = VIAWGET_DISASSOC_MSG;
-                 wpahdr->resp_ie_len = 0;
-                 wpahdr->req_ie_len = 0;
-                 skb_put(pDevice->skb, sizeof(viawget_wpa_header));
-                 pDevice->skb->dev = pDevice->wpadev;
-		 skb_reset_mac_header(pDevice->skb);
-                 pDevice->skb->pkt_type = PACKET_HOST;
-                 pDevice->skb->protocol = htons(ETH_P_802_2);
-                 memset(pDevice->skb->cb, 0, sizeof(pDevice->skb->cb));
-                 netif_rx(pDevice->skb);
-                 pDevice->skb = dev_alloc_skb((int)pDevice->rx_buf_sz);
-           }
-
   // if(pDevice->bWPASuppWextEnabled == TRUE)
       {
 	union iwreq_data  wrqu;
-- 
1.7.10.4



