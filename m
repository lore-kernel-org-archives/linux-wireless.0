Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:33956 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752285Ab2KLUnl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Nov 2012 15:43:41 -0500
Received: by mail-bk0-f46.google.com with SMTP id q16so269429bkw.19
        for <linux-wireless@vger.kernel.org>; Mon, 12 Nov 2012 12:43:40 -0800 (PST)
Message-ID: <1352753014.8858.2.camel@user64-MCP7A> (sfid-20121112_214346_696331_2F0652DF)
Subject: [PATCH] staging: vt6656: Remove WPA_SUPPLICANT_DRIVER_WEXT_SUPPORT
 macro
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Mon, 12 Nov 2012 20:43:34 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Already removed in parts of driver.

Removed in remainder.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/bssdb.c    |    6 ------
 drivers/staging/vt6656/device.h   |    6 ------
 drivers/staging/vt6656/dpc.c      |    2 --
 drivers/staging/vt6656/iwctl.c    |   18 +-----------------
 drivers/staging/vt6656/iwctl.h    |    2 --
 drivers/staging/vt6656/main_usb.c |    6 ------
 drivers/staging/vt6656/wcmd.c     |   10 ----------
 drivers/staging/vt6656/wmgr.c     |   10 ----------
 drivers/staging/vt6656/wpactl.h   |    2 --
 9 files changed, 1 insertion(+), 61 deletions(-)

diff --git a/drivers/staging/vt6656/bssdb.c b/drivers/staging/vt6656/bssdb.c
index 2ac066d..f1d852b2 100644
--- a/drivers/staging/vt6656/bssdb.c
+++ b/drivers/staging/vt6656/bssdb.c
@@ -913,7 +913,6 @@ if(pDevice->byReAssocCount > 0) {
    if((pDevice->byReAssocCount > 10) && (pDevice->bLinkPass != TRUE)) {  //10 sec timeout
                      printk("Re-association timeout!!!\n");
 		   pDevice->byReAssocCount = 0;
-                     #ifdef WPA_SUPPLICANT_DRIVER_WEXT_SUPPORT
                     // if(pDevice->bWPASuppWextEnabled == TRUE)
                         {
                   	union iwreq_data  wrqu;
@@ -922,7 +921,6 @@ if(pDevice->byReAssocCount > 0) {
                   	PRINT_K("wireless_send_event--->SIOCGIWAP(disassociated)\n");
                   	wireless_send_event(pDevice->dev, SIOCGIWAP, &wrqu, NULL);
                        }
-                    #endif
      }
    else if(pDevice->bLinkPass == TRUE)
    	pDevice->byReAssocCount = 0;
@@ -1116,7 +1114,6 @@ if((pMgmt->eCurrState!=WMAC_STATE_ASSOC) &&
              netif_rx(pDevice->skb);
              pDevice->skb = dev_alloc_skb((int)pDevice->rx_buf_sz);
          }
-   #ifdef WPA_SUPPLICANT_DRIVER_WEXT_SUPPORT
       {
 	union iwreq_data  wrqu;
 	memset(&wrqu, 0, sizeof (wrqu));
@@ -1124,7 +1121,6 @@ if((pMgmt->eCurrState!=WMAC_STATE_ASSOC) &&
 	PRINT_K("wireless_send_event--->SIOCGIWAP(disassociated)\n");
 	wireless_send_event(pDevice->dev, SIOCGIWAP, &wrqu, NULL);
      }
-  #endif
             }
         }
         else if (pItemSSID->len != 0) {
@@ -1169,11 +1165,9 @@ DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "bIsRoaming %d, !\n", pDevice->bIsRoaming );
 else {
             if (pDevice->uAutoReConnectTime < 10) {
                 pDevice->uAutoReConnectTime++;
-               #ifdef WPA_SUPPLICANT_DRIVER_WEXT_SUPPORT
                 //network manager support need not do Roaming scan???
                 if(pDevice->bWPASuppWextEnabled ==TRUE)
 		 pDevice->uAutoReConnectTime = 0;
-	     #endif
             }
             else {
 	    //mike use old encryption status for wpa reauthen
diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index f334e64..2595ac5 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -68,10 +68,6 @@
 #include <linux/wireless.h>
 #include <net/iw_handler.h>	// New driver API
 
-#ifndef WPA_SUPPLICANT_DRIVER_WEXT_SUPPORT
-#define WPA_SUPPLICANT_DRIVER_WEXT_SUPPORT
-#endif
-
 //please copy below macro to driver_event.c for API
 #define RT_INSMOD_EVENT_FLAG                             0x0101
 #define RT_UPDEV_EVENT_FLAG                               0x0102
@@ -815,13 +811,11 @@ typedef struct __device_info {
     struct sk_buff          *skb;
     //--
 
-#ifdef WPA_SUPPLICANT_DRIVER_WEXT_SUPPORT
         BOOL                 bwextstep0;
         BOOL                 bwextstep1;
         BOOL                 bwextstep2;
         BOOL                 bwextstep3;
         BOOL                 bWPASuppWextEnabled;
-#endif
 
 #ifdef HOSTAP
     // user space daemon: hostapd, is used for HOSTAP
diff --git a/drivers/staging/vt6656/dpc.c b/drivers/staging/vt6656/dpc.c
index 6f9b2b4..c6f5395 100644
--- a/drivers/staging/vt6656/dpc.c
+++ b/drivers/staging/vt6656/dpc.c
@@ -864,7 +864,6 @@ RXbBulkInProcessData (
                             pDevice->dev->name);
                     }
                 }
-       #ifdef WPA_SUPPLICANT_DRIVER_WEXT_SUPPORT
 				//send event to wpa_supplicant
 				//if(pDevice->bWPASuppWextEnabled == TRUE)
 				{
@@ -889,7 +888,6 @@ RXbBulkInProcessData (
 					wireless_send_event(pDevice->dev, IWEVMICHAELMICFAILURE, &wrqu, (char *)&ev);
 
 				}
-         #endif
 
 
                 if ((pDevice->bWPADEVUp) && (pDevice->skb != NULL)) {
diff --git a/drivers/staging/vt6656/iwctl.c b/drivers/staging/vt6656/iwctl.c
index e58049b..706e2a6 100644
--- a/drivers/staging/vt6656/iwctl.c
+++ b/drivers/staging/vt6656/iwctl.c
@@ -38,19 +38,12 @@
 #include "hostap.h"
 #include "power.h"
 #include "rf.h"
-
-#ifdef WPA_SUPPLICANT_DRIVER_WEXT_SUPPORT
 #include "iowpa.h"
 #include "wpactl.h"
-#endif
 
 #include <net/iw_handler.h>
 
-#ifdef WPA_SUPPLICANT_DRIVER_WEXT_SUPPORT
 #define SUPPORTED_WIRELESS_EXT 18
-#else
-#define SUPPORTED_WIRELESS_EXT 17
-#endif
 
 static const long frequency_list[] = {
 	2412, 2417, 2422, 2427, 2432, 2437, 2442, 2447, 2452, 2457, 2462, 2467, 2472, 2484,
@@ -704,10 +697,8 @@ int iwctl_siwessid(struct net_device *dev, struct iw_request_info *info,
 		memset(pMgmt->abyDesireSSID, 0, WLAN_IEHDR_LEN + WLAN_SSID_MAXLEN + 1);
 		memset(pMgmt->abyDesireBSSID, 0xFF,6);
 		PRINT_K("set essid to 'any' \n");
-#ifdef WPA_SUPPLICANT_DRIVER_WEXT_SUPPORT
 		// Unknown desired AP, so here need not associate??
 		return 0;
-#endif
 	} else {
 		// Set the SSID
 		memset(pMgmt->abyDesireSSID, 0, WLAN_IEHDR_LEN + WLAN_SSID_MAXLEN + 1);
@@ -729,7 +720,6 @@ int iwctl_siwessid(struct net_device *dev, struct iw_request_info *info,
 			return 0;
 		}
 
-#ifdef WPA_SUPPLICANT_DRIVER_WEXT_SUPPORT
 		// Wext wil order another command of siwap to link
 		// with desired AP, so here need not associate??
 		if (pDevice->bWPASuppWextEnabled == TRUE)  {
@@ -778,7 +768,6 @@ int iwctl_siwessid(struct net_device *dev, struct iw_request_info *info,
 			}
 			return 0;
 		}
-#endif
 
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "set essid = %s \n", pItemSSID->abySSID);
 	}
@@ -1155,9 +1144,8 @@ int iwctl_siwencode(struct net_device *dev, struct iw_request_info *info,
 		pMgmt->bShareKeyAlgorithm = FALSE;
 	}
 
-#ifdef WPA_SUPPLICANT_DRIVER_WEXT_SUPPORT
 	memset(pMgmt->abyDesireBSSID, 0xFF, 6);
-#endif
+
 	return rc;
 }
 
@@ -1311,8 +1299,6 @@ int iwctl_giwsens(struct net_device *dev, struct iw_request_info *info,
 	return 0;
 }
 
-#ifdef WPA_SUPPLICANT_DRIVER_WEXT_SUPPORT
-
 int iwctl_siwauth(struct net_device *dev, struct iw_request_info *info,
 		struct iw_param *wrq, char *extra)
 {
@@ -1627,8 +1613,6 @@ int iwctl_siwmlme(struct net_device *dev, struct iw_request_info *info,
 	return ret;
 }
 
-#endif
-
 static const iw_handler iwctl_handler[] = {
 	(iw_handler)NULL, // SIOCSIWCOMMIT
 	(iw_handler)NULL, // SIOCGIWNAME
diff --git a/drivers/staging/vt6656/iwctl.h b/drivers/staging/vt6656/iwctl.h
index d056f83..9cf48ab 100644
--- a/drivers/staging/vt6656/iwctl.h
+++ b/drivers/staging/vt6656/iwctl.h
@@ -118,7 +118,6 @@ int iwctl_giwscan(struct net_device *dev, struct iw_request_info *info,
 int iwctl_siwscan(struct net_device *dev, struct iw_request_info *info,
 		struct iw_param *wrq, char *extra);
 
-#ifdef WPA_SUPPLICANT_DRIVER_WEXT_SUPPORT
 int iwctl_siwauth(struct net_device *dev, struct iw_request_info *info,
 		struct iw_param *wrq, char *extra);
 
@@ -139,7 +138,6 @@ int iwctl_giwencodeext(struct net_device *dev, struct iw_request_info *info,
 
 int iwctl_siwmlme(struct net_device *dev, struct iw_request_info *info,
 		struct iw_point *wrq, char *extra);
-#endif // #ifdef WPA_SUPPLICANT_DRIVER_WEXT_SUPPORT
 
 extern const struct iw_handler_def iwctl_handler_def;
 extern const struct iw_priv_args iwctl_private_args;
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index d402df9..d8cb093 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -1056,13 +1056,11 @@ static int  device_open(struct net_device *dev) {
     pDevice->bEventAvailable = FALSE;
 
    pDevice->bWPADEVUp = FALSE;
-#ifdef WPA_SUPPLICANT_DRIVER_WEXT_SUPPORT
      pDevice->bwextstep0 = FALSE;
      pDevice->bwextstep1 = FALSE;
      pDevice->bwextstep2 = FALSE;
      pDevice->bwextstep3 = FALSE;
      pDevice->bWPASuppWextEnabled = FALSE;
-#endif
     pDevice->byReAssocCount = 0;
 
     RXvWorkItem(pDevice);
@@ -1848,7 +1846,6 @@ static int  device_ioctl(struct net_device *dev, struct ifreq *rq, int cmd) {
 */
 		break;
 
-#ifdef  WPA_SUPPLICANT_DRIVER_WEXT_SUPPORT
 	case SIOCSIWAUTH:
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWAUTH\n");
 		rc = iwctl_siwauth(dev, NULL, &(wrq->u.param), NULL);
@@ -1901,7 +1898,6 @@ static int  device_ioctl(struct net_device *dev, struct ifreq *rq, int cmd) {
 		rc = iwctl_siwmlme(dev, NULL, &(wrq->u.data), wrq->u.data.pointer);
 		break;
 
-#endif // #ifdef WPA_SUPPLICANT_DRIVER_WEXT_SUPPORT
 
     case IOCTL_CMD_TEST:
 
@@ -1995,10 +1991,8 @@ static int  device_ioctl(struct net_device *dev, struct ifreq *rq, int cmd) {
            ControlvMaskByte(pDevice,MESSAGE_REQUEST_MACREG,MAC_REG_PAPEDELAY,LEDSTS_STS,LEDSTS_SLOW);
 //End Modify
            netif_stop_queue(pDevice->dev);
-#ifdef  WPA_SUPPLICANT_DRIVER_WEXT_SUPPORT
            pMgmt->eScanType = WMAC_SCAN_ACTIVE;
 	   if (!pDevice->bWPASuppWextEnabled)
-#endif
 		bScheduleCommand((void *) pDevice,
 				 WLAN_CMD_BSSID_SCAN,
 				 pMgmt->abyDesireSSID);
diff --git a/drivers/staging/vt6656/wcmd.c b/drivers/staging/vt6656/wcmd.c
index b854d7e..99bced7 100644
--- a/drivers/staging/vt6656/wcmd.c
+++ b/drivers/staging/vt6656/wcmd.c
@@ -503,7 +503,6 @@ void vRunCommand(void *hDeviceContext)
             pMgmt->eScanState = WMAC_NO_SCANNING;
             pDevice->bStopDataPkt = FALSE;
 
-#ifdef WPA_SUPPLICANT_DRIVER_WEXT_SUPPORT
 	if(pMgmt->eScanType == WMAC_SCAN_PASSIVE)
 		{
 			//send scan event to wpa_Supplicant
@@ -512,7 +511,6 @@ void vRunCommand(void *hDeviceContext)
 				memset(&wrqu, 0, sizeof(wrqu));
 				wireless_send_event(pDevice->dev, SIOCGIWSCAN, &wrqu, NULL);
 			}
-#endif
             s_bCommandComplete(pDevice);
             break;
 
@@ -525,13 +523,11 @@ void vRunCommand(void *hDeviceContext)
                 return;
             } else {
 
-          #ifdef WPA_SUPPLICANT_DRIVER_WEXT_SUPPORT
 		      pDevice->bwextstep0 = FALSE;
                         pDevice->bwextstep1 = FALSE;
                         pDevice->bwextstep2 = FALSE;
                         pDevice->bwextstep3 = FALSE;
 		   pDevice->bWPASuppWextEnabled = FALSE;
-	 #endif
                    pDevice->fWPA_Authened = FALSE;
 
                 DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Send Disassociation Packet..\n");
@@ -674,7 +670,6 @@ void vRunCommand(void *hDeviceContext)
                 }
                 else {
                     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Disconnect SSID none\n");
-                     #ifdef WPA_SUPPLICANT_DRIVER_WEXT_SUPPORT
                     // if(pDevice->bWPASuppWextEnabled == TRUE)
                         {
                   	union iwreq_data  wrqu;
@@ -683,7 +678,6 @@ void vRunCommand(void *hDeviceContext)
                   	PRINT_K("wireless_send_event--->SIOCGIWAP(disassociated:vMgrJoinBSSBegin Fail !!)\n");
                   	wireless_send_event(pDevice->dev, SIOCGIWAP, &wrqu, NULL);
                        }
-                    #endif
                 }
             }
             s_bCommandComplete(pDevice);
@@ -926,7 +920,6 @@ void vRunCommand(void *hDeviceContext)
                 // unlock command busy
                         pMgmt->eCurrState = WMAC_STATE_IDLE;
                         pMgmt->sNodeDBTable[0].bActive = FALSE;
-                     #ifdef WPA_SUPPLICANT_DRIVER_WEXT_SUPPORT
                     // if(pDevice->bWPASuppWextEnabled == TRUE)
                         {
                   	union iwreq_data  wrqu;
@@ -935,15 +928,12 @@ void vRunCommand(void *hDeviceContext)
                   	PRINT_K("wireless_send_event--->SIOCGIWAP(disassociated)\n");
                   	wireless_send_event(pDevice->dev, SIOCGIWAP, &wrqu, NULL);
                        }
-                    #endif
 	  	}
-	       #ifdef WPA_SUPPLICANT_DRIVER_WEXT_SUPPORT
 	               pDevice->bwextstep0 = FALSE;
                         pDevice->bwextstep1 = FALSE;
                         pDevice->bwextstep2 = FALSE;
                         pDevice->bwextstep3 = FALSE;
 		      pDevice->bWPASuppWextEnabled = FALSE;
-		#endif
 	                  //clear current SSID
                   pItemSSID = (PWLAN_IE_SSID)pMgmt->abyCurrSSID;
                   pItemSSID->len = 0;
diff --git a/drivers/staging/vt6656/wmgr.c b/drivers/staging/vt6656/wmgr.c
index 7db6a8d..20b3618 100644
--- a/drivers/staging/vt6656/wmgr.c
+++ b/drivers/staging/vt6656/wmgr.c
@@ -998,7 +998,6 @@ s_vMgrRxAssocResponse(
                 pDevice->skb = dev_alloc_skb((int)pDevice->rx_buf_sz);
             }
 
-#ifdef WPA_SUPPLICANT_DRIVER_WEXT_SUPPORT
 	//if(pDevice->bWPASuppWextEnabled == TRUE)
 	   {
 		BYTE buf[512];
@@ -1037,7 +1036,6 @@ s_vMgrRxAssocResponse(
 	wireless_send_event(pDevice->dev, SIOCGIWAP, &wrqu, NULL);
 
 	}
-#endif //#ifdef WPA_SUPPLICANT_DRIVER_WEXT_SUPPORT
 
         }
         else {
@@ -1053,14 +1051,12 @@ s_vMgrRxAssocResponse(
 
     }
 
-#ifdef WPA_SUPPLICANT_DRIVER_WEXT_SUPPORT
 //need clear flags related to Networkmanager
               pDevice->bwextstep0 = FALSE;
               pDevice->bwextstep1 = FALSE;
               pDevice->bwextstep2 = FALSE;
               pDevice->bwextstep3 = FALSE;
               pDevice->bWPASuppWextEnabled = FALSE;
-#endif
 
 if(pMgmt->eCurrState == WMAC_STATE_ASSOC)
       timer_expire(pDevice->sTimerCommand, 0);
@@ -1638,7 +1634,6 @@ s_vMgrRxDisassociation(
               }
         }
 
-   #ifdef WPA_SUPPLICANT_DRIVER_WEXT_SUPPORT
   // if(pDevice->bWPASuppWextEnabled == TRUE)
       {
 	union iwreq_data  wrqu;
@@ -1647,7 +1642,6 @@ s_vMgrRxDisassociation(
 	PRINT_K("wireless_send_event--->SIOCGIWAP(disassociated)\n");
 	wireless_send_event(pDevice->dev, SIOCGIWAP, &wrqu, NULL);
      }
-  #endif
     }
     /* else, ignore it */
 
@@ -1727,7 +1721,6 @@ s_vMgrRxDeauthentication(
                  pDevice->skb = dev_alloc_skb((int)pDevice->rx_buf_sz);
            }
 
-   #ifdef WPA_SUPPLICANT_DRIVER_WEXT_SUPPORT
   // if(pDevice->bWPASuppWextEnabled == TRUE)
       {
 	union iwreq_data  wrqu;
@@ -1736,7 +1729,6 @@ s_vMgrRxDeauthentication(
 	PRINT_K("wireless_send_event--->SIOCGIWAP(disauthen)\n");
 	wireless_send_event(pDevice->dev, SIOCGIWAP, &wrqu, NULL);
      }
-  #endif
 
         }
         /* else, ignore it.  TODO: IBSS authentication service
@@ -2645,10 +2637,8 @@ void vMgrJoinBSSBegin(void *hDeviceContext, PCMD_STATUS pStatus)
 */
         }
 
-#ifdef WPA_SUPPLICANT_DRIVER_WEXT_SUPPORT
 	//if(pDevice->bWPASuppWextEnabled == TRUE)
             Encyption_Rebuild(pDevice, pCurr);
-#endif
 
         // Infrastructure BSS
         s_vMgrSynchBSS(pDevice,
diff --git a/drivers/staging/vt6656/wpactl.h b/drivers/staging/vt6656/wpactl.h
index 00c8451..19ab8b6 100644
--- a/drivers/staging/vt6656/wpactl.h
+++ b/drivers/staging/vt6656/wpactl.h
@@ -30,9 +30,7 @@
 #define __WPACTL_H__
 
 #include "device.h"
-#ifdef WPA_SUPPLICANT_DRIVER_WEXT_SUPPORT
 #include "iowpa.h"
-#endif
 
 /*---------------------  Export Definitions -------------------------*/
 
-- 
1.7.10.4


