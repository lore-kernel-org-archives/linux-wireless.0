Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:47130 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754615AbaBSTf2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Feb 2014 14:35:28 -0500
Received: by mail-wi0-f180.google.com with SMTP id hm4so998120wib.1
        for <linux-wireless@vger.kernel.org>; Wed, 19 Feb 2014 11:35:27 -0800 (PST)
Message-ID: <1392838516.9073.15.camel@canaries64-MCP7A> (sfid-20140219_203532_063788_60B2C9A5)
Subject: [PATCH 2/2] staging: vt6656: vRunCommand remove multi calls to
 s_bCommandComplete.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Wed, 19 Feb 2014 19:35:16 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove calls with break
s_bCommandComplete(pDevice);
spin_unlock_irq(&pDevice->lock);
return;

Add single call to s_bCommandComplete;

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/wcmd.c | 70 +++++++++++--------------------------------
 1 file changed, 17 insertions(+), 53 deletions(-)

diff --git a/drivers/staging/vt6656/wcmd.c b/drivers/staging/vt6656/wcmd.c
index 8c702c3..3cf3f24 100644
--- a/drivers/staging/vt6656/wcmd.c
+++ b/drivers/staging/vt6656/wcmd.c
@@ -293,17 +293,11 @@ void vRunCommand(struct work_struct *work)
 	case WLAN_CMD_SCAN_START:
 
 		pDevice->byReAssocCount = 0;
-		if (pDevice->bRadioOff == true) {
-			s_bCommandComplete(pDevice);
-			spin_unlock_irq(&pDevice->lock);
-			return;
-		}
+		if (pDevice->bRadioOff == true)
+			break;
 
-		if (pMgmt->eCurrMode == WMAC_MODE_ESS_AP) {
-			s_bCommandComplete(pDevice);
-			spin_unlock_irq(&pDevice->lock);
-			return;
-		}
+		if (pMgmt->eCurrMode == WMAC_MODE_ESS_AP)
+			break;
 
 		pItemSSID = (PWLAN_IE_SSID)pMgmt->abyScanSSID;
 
@@ -311,16 +305,12 @@ void vRunCommand(struct work_struct *work)
 			pMgmt->uScanChannel = pDevice->byMinChannel;
 		if (pMgmt->uScanChannel > pDevice->byMaxChannel) {
 			pDevice->eCommandState = WLAN_CMD_SCAN_END;
-			s_bCommandComplete(pDevice);
-			spin_unlock_irq(&pDevice->lock);
-			return;
+			break;
 		} else {
 			if (!ChannelValid(pDevice->byZoneType, pMgmt->uScanChannel)) {
 				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Invalid channel pMgmt->uScanChannel = %d\n", pMgmt->uScanChannel);
 				pMgmt->uScanChannel++;
-				s_bCommandComplete(pDevice);
-				spin_unlock_irq(&pDevice->lock);
-				return;
+				break;
 			}
 			if (pMgmt->uScanChannel == pDevice->byMinChannel) {
 				// pMgmt->eScanType = WMAC_SCAN_ACTIVE;          //mike mark
@@ -420,16 +410,13 @@ void vRunCommand(struct work_struct *work)
 		memset(&wrqu, 0, sizeof(wrqu));
 		wireless_send_event(pDevice->dev, SIOCGIWSCAN, &wrqu, NULL);
 
-		s_bCommandComplete(pDevice);
 		break;
 
 	case WLAN_CMD_DISASSOCIATE_START:
 		pDevice->byReAssocCount = 0;
 		if ((pMgmt->eCurrMode == WMAC_MODE_ESS_STA) &&
 		    (pMgmt->eCurrState != WMAC_STATE_ASSOC)) {
-			s_bCommandComplete(pDevice);
-			spin_unlock_irq(&pDevice->lock);
-			return;
+			break;
 		} else {
 			pDevice->bwextstep0 = false;
 			pDevice->bwextstep1 = false;
@@ -458,17 +445,14 @@ void vRunCommand(struct work_struct *work)
 		netif_stop_queue(pDevice->dev);
 		if (pDevice->bNeedRadioOFF == true)
 			CARDbRadioPowerOff(pDevice);
-		s_bCommandComplete(pDevice);
+
 		break;
 
 	case WLAN_CMD_SSID_START:
 
 		pDevice->byReAssocCount = 0;
-		if (pDevice->bRadioOff == true) {
-			s_bCommandComplete(pDevice);
-			spin_unlock_irq(&pDevice->lock);
-			return;
-		}
+		if (pDevice->bRadioOff == true)
+			break;
 
 		memcpy(pMgmt->abyAdHocSSID, pMgmt->abyDesireSSID,
 		       ((PWLAN_IE_SSID)pMgmt->abyDesireSSID)->len + WLAN_IEHDR_LEN);
@@ -489,11 +473,9 @@ void vRunCommand(struct work_struct *work)
 		if ((pMgmt->eCurrState == WMAC_STATE_ASSOC) ||
 		    ((pMgmt->eCurrMode == WMAC_MODE_IBSS_STA) && (pMgmt->eCurrState == WMAC_STATE_JOINTED))) {
 			if (pItemSSID->len == pItemSSIDCurr->len) {
-				if (memcmp(pItemSSID->abySSID, pItemSSIDCurr->abySSID, pItemSSID->len) == 0) {
-					s_bCommandComplete(pDevice);
-					spin_unlock_irq(&pDevice->lock);
-					return;
-				}
+				if (!memcmp(pItemSSID->abySSID,
+					pItemSSIDCurr->abySSID, pItemSSID->len))
+					break;
 			}
 			netif_stop_queue(pDevice->dev);
 			pDevice->bLinkPass = false;
@@ -582,7 +564,6 @@ void vRunCommand(struct work_struct *work)
 				}
 			}
 		}
-		s_bCommandComplete(pDevice);
 		break;
 
 	case WLAN_AUTHENTICATE_WAIT:
@@ -612,7 +593,6 @@ void vRunCommand(struct work_struct *work)
 		}
 		pDevice->byLinkWaitCount = 0;
 
-		s_bCommandComplete(pDevice);
 		break;
 
 	case WLAN_ASSOCIATE_WAIT:
@@ -647,7 +627,6 @@ void vRunCommand(struct work_struct *work)
 			return;
 		}
 
-		s_bCommandComplete(pDevice);
 		break;
 
 	case WLAN_CMD_AP_MODE_START:
@@ -683,7 +662,6 @@ void vRunCommand(struct work_struct *work)
 			ControlvMaskByte(pDevice, MESSAGE_REQUEST_MACREG, MAC_REG_PAPEDELAY, LEDSTS_STS, LEDSTS_INTER);
 			schedule_delayed_work(&pDevice->second_callback_work, HZ);
 		}
-		s_bCommandComplete(pDevice);
 		break;
 
 	case WLAN_CMD_TX_PSPACKET_START:
@@ -738,8 +716,6 @@ void vRunCommand(struct work_struct *work)
 				pMgmt->sNodeDBTable[ii].bRxPSPoll = false;
 			}
 		}
-
-		s_bCommandComplete(pDevice);
 		break;
 
 	case WLAN_CMD_RADIO_START:
@@ -760,11 +736,8 @@ void vRunCommand(struct work_struct *work)
 					1,
 					&byTmp);
 
-			if (ntStatus != STATUS_SUCCESS) {
-				s_bCommandComplete(pDevice);
-				spin_unlock_irq(&pDevice->lock);
-				return;
-			}
+			if (ntStatus != STATUS_SUCCESS)
+				break;
 			if ((byTmp & GPIO3_DATA) == 0) {
 				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO" WLAN_CMD_RADIO_START_OFF........................\n");
 				// Old commands are useless.
@@ -833,7 +806,6 @@ void vRunCommand(struct work_struct *work)
 			}
 		}
 
-		s_bCommandComplete(pDevice);
 		break;
 
 	case WLAN_CMD_CHANGE_BBSENSITIVITY_START:
@@ -843,24 +815,20 @@ void vRunCommand(struct work_struct *work)
 		BBvSetVGAGainOffset(pDevice, pDevice->byBBVGACurrent);
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Change sensitivity pDevice->byBBVGACurrent = %x\n", pDevice->byBBVGACurrent);
 		pDevice->bStopDataPkt = false;
-		s_bCommandComplete(pDevice);
 		break;
 
 	case WLAN_CMD_TBTT_WAKEUP_START:
 		PSbIsNextTBTTWakeUp(pDevice);
-		s_bCommandComplete(pDevice);
 		break;
 
 	case WLAN_CMD_BECON_SEND_START:
 		bMgrPrepareBeaconToSend(pDevice, pMgmt);
-		s_bCommandComplete(pDevice);
 		break;
 
 	case WLAN_CMD_SETPOWER_START:
 
 		RFbSetPower(pDevice, pDevice->wCurrentRate, pMgmt->uCurrChannel);
 
-		s_bCommandComplete(pDevice);
 		break;
 
 	case WLAN_CMD_CHANGE_ANTENNA_START:
@@ -878,12 +846,10 @@ void vRunCommand(struct work_struct *work)
 			else
 				BBvSetAntennaMode(pDevice, ANT_RXA);
 		}
-		s_bCommandComplete(pDevice);
 		break;
 
 	case WLAN_CMD_REMOVE_ALLKEY_START:
 		KeybRemoveAllKey(pDevice, &(pDevice->sKey), pDevice->abyBSSID);
-		s_bCommandComplete(pDevice);
 		break;
 
 	case WLAN_CMD_MAC_DISPOWERSAVING_START:
@@ -898,7 +864,6 @@ void vRunCommand(struct work_struct *work)
 					NULL
 					);
 		}
-		s_bCommandComplete(pDevice);
 		break;
 
 	case WLAN_CMD_11H_CHSW_START:
@@ -906,18 +871,17 @@ void vRunCommand(struct work_struct *work)
 		pDevice->bChannelSwitch = false;
 		pMgmt->uCurrChannel = pDevice->byNewChannel;
 		pDevice->bStopDataPkt = false;
-		s_bCommandComplete(pDevice);
 		break;
 
 	case WLAN_CMD_CONFIGURE_FILTER_START:
 		vnt_configure_filter(pDevice);
-		s_bCommandComplete(pDevice);
 		break;
 	default:
-		s_bCommandComplete(pDevice);
 		break;
 	} //switch
 
+	s_bCommandComplete(pDevice);
+
 	spin_unlock_irq(&pDevice->lock);
 	return;
 }
-- 
1.9.rc1


