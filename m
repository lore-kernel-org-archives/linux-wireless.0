Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:35074 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752382AbaEZNAP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 May 2014 09:00:15 -0400
Received: by mail-wi0-f172.google.com with SMTP id hi2so4236665wib.17
        for <linux-wireless@vger.kernel.org>; Mon, 26 May 2014 06:00:11 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 07/11] staging: vt6656: Create new function to set led state.
Date: Mon, 26 May 2014 13:59:04 +0100
Message-Id: <1401109148-3593-7-git-send-email-tvboxspy@gmail.com> (sfid-20140526_150037_296257_34EFAB2F)
In-Reply-To: <1401109148-3593-1-git-send-email-tvboxspy@gmail.com>
References: <1401109148-3593-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Create vnt_mac_set_led to set state and led.

state has two modes LEDSTS_TMLEN which sets the blink rate
on TX activity and LEDSTS_STS which sets the led.

As result of this patch ControlvMaskByte becomes dead code.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/bssdb.c    | 14 ++++++--------
 drivers/staging/vt6656/iwctl.c    |  4 +---
 drivers/staging/vt6656/mac.c      | 13 +++++++++++++
 drivers/staging/vt6656/mac.h      |  1 +
 drivers/staging/vt6656/main_usb.c |  6 ++----
 drivers/staging/vt6656/wcmd.c     | 30 +++++++++++++++++++++---------
 drivers/staging/vt6656/wmgr.c     | 14 ++++++++++----
 7 files changed, 54 insertions(+), 28 deletions(-)

diff --git a/drivers/staging/vt6656/bssdb.c b/drivers/staging/vt6656/bssdb.c
index 5f631c8..12b6436 100644
--- a/drivers/staging/vt6656/bssdb.c
+++ b/drivers/staging/vt6656/bssdb.c
@@ -1015,10 +1015,10 @@ void BSSvSecondCallBack(struct work_struct *work)
 				pMgmt->eCurrState = WMAC_STATE_IDLE;
 				netif_stop_queue(pDevice->dev);
 				pDevice->bLinkPass = false;
-				ControlvMaskByte(pDevice,
-						 MESSAGE_REQUEST_MACREG,
-						 MAC_REG_PAPEDELAY, LEDSTS_STS,
-						 LEDSTS_SLOW);
+
+				vnt_mac_set_led(pDevice, LEDSTS_STS,
+								LEDSTS_SLOW);
+
 				pDevice->bRoaming = true;
 				pDevice->bIsRoaming = false;
 
@@ -1126,10 +1126,8 @@ void BSSvSecondCallBack(struct work_struct *work)
 				pMgmt->eCurrState = WMAC_STATE_STARTED;
 				netif_stop_queue(pDevice->dev);
 				pDevice->bLinkPass = false;
-				ControlvMaskByte(pDevice,
-						 MESSAGE_REQUEST_MACREG,
-						 MAC_REG_PAPEDELAY, LEDSTS_STS,
-						 LEDSTS_SLOW);
+				vnt_mac_set_led(pDevice, LEDSTS_STS,
+								LEDSTS_SLOW);
 			}
 		}
 	}
diff --git a/drivers/staging/vt6656/iwctl.c b/drivers/staging/vt6656/iwctl.c
index e7b7ca5..0a8e438 100644
--- a/drivers/staging/vt6656/iwctl.c
+++ b/drivers/staging/vt6656/iwctl.c
@@ -442,9 +442,7 @@ int iwctl_siwmode(struct net_device *dev, struct iw_request_info *info,
 				memset(pMgmt->abyCurrBSSID, 0, 6);
 			}
 
-			ControlvMaskByte(pDevice,
-				MESSAGE_REQUEST_MACREG,	MAC_REG_PAPEDELAY,
-					LEDSTS_STS, LEDSTS_SLOW);
+			vnt_mac_set_led(pDevice, LEDSTS_STS, LEDSTS_SLOW);
 
 			netif_stop_queue(pDevice->dev);
 
diff --git a/drivers/staging/vt6656/mac.c b/drivers/staging/vt6656/mac.c
index 51e4a355..fdb244f 100644
--- a/drivers/staging/vt6656/mac.c
+++ b/drivers/staging/vt6656/mac.c
@@ -240,3 +240,16 @@ void MACvWriteBeaconInterval(struct vnt_private *priv, u16 interval)
 	vnt_control_out(priv, MESSAGE_TYPE_WRITE,
 		MAC_REG_BI, MESSAGE_REQUEST_MACREG, ARRAY_SIZE(data), data);
 }
+
+void vnt_mac_set_led(struct vnt_private *priv, u8 state, u8 led)
+{
+	u8 data[2];
+
+	data[0] = led;
+	data[1] = state;
+
+	vnt_control_out(priv, MESSAGE_TYPE_WRITE_MASK, MAC_REG_PAPEDELAY,
+			MESSAGE_REQUEST_MACREG, ARRAY_SIZE(data), data);
+
+	return;
+}
diff --git a/drivers/staging/vt6656/mac.h b/drivers/staging/vt6656/mac.h
index 6e45d47..986ca95 100644
--- a/drivers/staging/vt6656/mac.h
+++ b/drivers/staging/vt6656/mac.h
@@ -428,5 +428,6 @@ void MACvDisableProtectMD(struct vnt_private *);
 void MACvEnableBarkerPreambleMd(struct vnt_private *);
 void MACvDisableBarkerPreambleMd(struct vnt_private *);
 void MACvWriteBeaconInterval(struct vnt_private *, u16);
+void vnt_mac_set_led(struct vnt_private *priv, u8, u8);
 
 #endif /* __MAC_H__ */
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 6cc056d..df206e6 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -551,11 +551,9 @@ static int device_init_registers(struct vnt_private *pDevice)
 
 	}
 
-	ControlvMaskByte(pDevice, MESSAGE_REQUEST_MACREG,
-				MAC_REG_PAPEDELAY, LEDSTS_TMLEN, 0x38);
+	vnt_mac_set_led(pDevice, LEDSTS_TMLEN, 0x38);
 
-	ControlvMaskByte(pDevice, MESSAGE_REQUEST_MACREG,
-				MAC_REG_PAPEDELAY, LEDSTS_STS, LEDSTS_SLOW);
+	vnt_mac_set_led(pDevice, LEDSTS_STS, LEDSTS_SLOW);
 
 	MACvRegBitsOn(pDevice, MAC_REG_GPIOCTL0, 0x01);
 
diff --git a/drivers/staging/vt6656/wcmd.c b/drivers/staging/vt6656/wcmd.c
index aae573b..79f7463 100644
--- a/drivers/staging/vt6656/wcmd.c
+++ b/drivers/staging/vt6656/wcmd.c
@@ -426,7 +426,9 @@ void vRunCommand(struct work_struct *work)
 					     (8),
 					     &Status);
 			pDevice->bLinkPass = false;
-			ControlvMaskByte(pDevice, MESSAGE_REQUEST_MACREG, MAC_REG_PAPEDELAY, LEDSTS_STS, LEDSTS_SLOW);
+
+			vnt_mac_set_led(pDevice, LEDSTS_STS, LEDSTS_SLOW);
+
 			// unlock command busy
 			pItemSSID = (PWLAN_IE_SSID)pMgmt->abyCurrSSID;
 			pItemSSID->len = 0;
@@ -472,7 +474,8 @@ void vRunCommand(struct work_struct *work)
 			}
 			netif_stop_queue(pDevice->dev);
 			pDevice->bLinkPass = false;
-			ControlvMaskByte(pDevice, MESSAGE_REQUEST_MACREG, MAC_REG_PAPEDELAY, LEDSTS_STS, LEDSTS_SLOW);
+
+			vnt_mac_set_led(pDevice, LEDSTS_STS, LEDSTS_SLOW);
 		}
 		// set initial state
 		pMgmt->eCurrState = WMAC_STATE_IDLE;
@@ -507,7 +510,9 @@ void vRunCommand(struct work_struct *work)
 				if (netif_queue_stopped(pDevice->dev))
 					netif_wake_queue(pDevice->dev);
 				pDevice->bLinkPass = true;
-				ControlvMaskByte(pDevice, MESSAGE_REQUEST_MACREG, MAC_REG_PAPEDELAY, LEDSTS_STS, LEDSTS_INTER);
+
+				vnt_mac_set_led(pDevice, LEDSTS_STS, LEDSTS_INTER);
+
 				pMgmt->sNodeDBTable[0].bActive = true;
 				pMgmt->sNodeDBTable[0].uInActiveCount = 0;
 			} else {
@@ -538,7 +543,6 @@ void vRunCommand(struct work_struct *work)
 				s_bClearBSSID_SCAN(pDevice);
 /*
 				pDevice->bLinkPass = true;
-				ControlvMaskByte(pDevice,MESSAGE_REQUEST_MACREG,MAC_REG_PAPEDELAY,LEDSTS_STS,LEDSTS_INTER);
 				if (netif_queue_stopped(pDevice->dev)){
 					netif_wake_queue(pDevice->dev);
 				}
@@ -600,7 +604,9 @@ void vRunCommand(struct work_struct *work)
 			pDevice->byLinkWaitCount = 0;
 			pDevice->byReAssocCount = 0;
 			pDevice->bLinkPass = true;
-			ControlvMaskByte(pDevice, MESSAGE_REQUEST_MACREG, MAC_REG_PAPEDELAY, LEDSTS_STS, LEDSTS_INTER);
+
+			vnt_mac_set_led(pDevice, LEDSTS_STS, LEDSTS_INTER);
+
 			s_bClearBSSID_SCAN(pDevice);
 
 			if (netif_queue_stopped(pDevice->dev))
@@ -626,7 +632,8 @@ void vRunCommand(struct work_struct *work)
 			pMgmt->eCurrState = WMAC_STATE_IDLE;
 			pMgmt->eCurrMode = WMAC_MODE_STANDBY;
 			pDevice->bLinkPass = false;
-			ControlvMaskByte(pDevice, MESSAGE_REQUEST_MACREG, MAC_REG_PAPEDELAY, LEDSTS_STS, LEDSTS_SLOW);
+
+			vnt_mac_set_led(pDevice, LEDSTS_STS, LEDSTS_SLOW);
 
 			BSSvClearNodeDBTable(pDevice, 0);
 
@@ -647,7 +654,9 @@ void vRunCommand(struct work_struct *work)
 			if (netif_queue_stopped(pDevice->dev))
 				netif_wake_queue(pDevice->dev);
 			pDevice->bLinkPass = true;
-			ControlvMaskByte(pDevice, MESSAGE_REQUEST_MACREG, MAC_REG_PAPEDELAY, LEDSTS_STS, LEDSTS_INTER);
+
+			vnt_mac_set_led(pDevice, LEDSTS_STS, LEDSTS_INTER);
+
 			schedule_delayed_work(&pDevice->second_callback_work, HZ);
 		}
 		break;
@@ -791,14 +800,17 @@ void vRunCommand(struct work_struct *work)
 				netif_stop_queue(pDevice->dev);
 				CARDbRadioPowerOff(pDevice);
 				MACvRegBitsOn(pDevice, MAC_REG_GPIOCTL1, GPIO3_INTMD);
-				ControlvMaskByte(pDevice, MESSAGE_REQUEST_MACREG, MAC_REG_PAPEDELAY, LEDSTS_STS, LEDSTS_OFF);
+
+				vnt_mac_set_led(pDevice, LEDSTS_STS, LEDSTS_OFF);
+
 				pDevice->bHWRadioOff = true;
 			} else {
 				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO" WLAN_CMD_RADIO_START_ON........................\n");
 				pDevice->bHWRadioOff = false;
 				CARDbRadioPowerOn(pDevice);
 				MACvRegBitsOff(pDevice, MAC_REG_GPIOCTL1, GPIO3_INTMD);
-				ControlvMaskByte(pDevice, MESSAGE_REQUEST_MACREG, MAC_REG_PAPEDELAY, LEDSTS_STS, LEDSTS_ON);
+
+				vnt_mac_set_led(pDevice, LEDSTS_STS, LEDSTS_ON);
 			}
 		}
 
diff --git a/drivers/staging/vt6656/wmgr.c b/drivers/staging/vt6656/wmgr.c
index 4f46aa6..8cb80a6 100644
--- a/drivers/staging/vt6656/wmgr.c
+++ b/drivers/staging/vt6656/wmgr.c
@@ -756,7 +756,8 @@ static void s_vMgrRxAssocResponse(struct vnt_private *pDevice,
             pItemSSID = (PWLAN_IE_SSID)pMgmt->abyCurrSSID;
             DBG_PRT(MSG_LEVEL_INFO, KERN_INFO "Link with AP(SSID): %s\n", pItemSSID->abySSID);
             pDevice->bLinkPass = true;
-            ControlvMaskByte(pDevice,MESSAGE_REQUEST_MACREG,MAC_REG_PAPEDELAY,LEDSTS_STS,LEDSTS_INTER);
+
+	    vnt_mac_set_led(pDevice, LEDSTS_STS, LEDSTS_INTER);
 
 	//if(pDevice->bWPASuppWextEnabled == true)
 	   {
@@ -1398,7 +1399,8 @@ static void s_vMgrRxDeauthentication(struct vnt_private *pDevice,
                     pMgmt->eCurrState = WMAC_STATE_IDLE;
                     netif_stop_queue(pDevice->dev);
                     pDevice->bLinkPass = false;
-                    ControlvMaskByte(pDevice,MESSAGE_REQUEST_MACREG,MAC_REG_PAPEDELAY,LEDSTS_STS,LEDSTS_SLOW);
+
+		    vnt_mac_set_led(pDevice, LEDSTS_STS, LEDSTS_SLOW);
                 }
             }
 
@@ -1883,7 +1885,9 @@ if(ChannelExceedZoneType(pDevice,byCurrChannel)==true)
                 DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Current IBSS State: [Started]........to: [Jointed] \n");
                 pMgmt->eCurrState = WMAC_STATE_JOINTED;
                 pDevice->bLinkPass = true;
-                ControlvMaskByte(pDevice,MESSAGE_REQUEST_MACREG,MAC_REG_PAPEDELAY,LEDSTS_STS,LEDSTS_INTER);
+
+		vnt_mac_set_led(pDevice, LEDSTS_STS, LEDSTS_INTER);
+
                 if (netif_queue_stopped(pDevice->dev)){
                     netif_wake_queue(pDevice->dev);
                 }
@@ -2488,7 +2492,9 @@ void vMgrJoinBSSBegin(struct vnt_private *pDevice, PCMD_STATUS pStatus)
             // Adopt BSS state in Adapter Device Object
 	    pDevice->op_mode = NL80211_IFTYPE_ADHOC;
             pDevice->bLinkPass = true;
-            ControlvMaskByte(pDevice,MESSAGE_REQUEST_MACREG,MAC_REG_PAPEDELAY,LEDSTS_STS,LEDSTS_INTER);
+
+	    vnt_mac_set_led(pDevice, LEDSTS_STS, LEDSTS_INTER);
+
             memcpy(pDevice->abyBSSID, pCurr->abyBSSID, WLAN_BSSID_LEN);
 
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Join IBSS ok:%pM\n",
-- 
1.9.1

