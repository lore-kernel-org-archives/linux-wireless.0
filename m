Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f178.google.com ([74.125.82.178]:36522 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762AbaGLGye (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Jul 2014 02:54:34 -0400
Received: by mail-we0-f178.google.com with SMTP id w61so1124982wes.9
        for <linux-wireless@vger.kernel.org>; Fri, 11 Jul 2014 23:54:32 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 03/10] staging: vt6656: wcmd remove unused commands
Date: Sat, 12 Jul 2014 07:53:41 +0100
Message-Id: <1405148028-4053-3-git-send-email-tvboxspy@gmail.com> (sfid-20140712_085437_631755_80E03162)
In-Reply-To: <1405148028-4053-1-git-send-email-tvboxspy@gmail.com>
References: <1405148028-4053-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

WLAN_CMD_CHANGE_BBSENSITIVITY and WLAN_CMD_MAC_DISPOWERSAVING
are already implemented and don't need the command timer.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/wcmd.c | 34 ----------------------------------
 drivers/staging/vt6656/wcmd.h | 24 ------------------------
 2 files changed, 58 deletions(-)

diff --git a/drivers/staging/vt6656/wcmd.c b/drivers/staging/vt6656/wcmd.c
index 0b87486..5001193 100644
--- a/drivers/staging/vt6656/wcmd.c
+++ b/drivers/staging/vt6656/wcmd.c
@@ -63,7 +63,6 @@ void vRunCommand(struct work_struct *work)
 {
 	struct vnt_private *pDevice =
 		container_of(work, struct vnt_private, run_command_work.work);
-	u8 byData;
 
 	if (pDevice->Flags & fMP_DISCONNECTED)
 		return;
@@ -87,15 +86,6 @@ void vRunCommand(struct work_struct *work)
 
 		break;
 
-	case WLAN_CMD_CHANGE_BBSENSITIVITY_START:
-
-		pDevice->bStopDataPkt = true;
-		pDevice->byBBVGACurrent = pDevice->byBBVGANew;
-		BBvSetVGAGainOffset(pDevice, pDevice->byBBVGACurrent);
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Change sensitivity pDevice->byBBVGACurrent = %x\n", pDevice->byBBVGACurrent);
-		pDevice->bStopDataPkt = false;
-		break;
-
 	case WLAN_CMD_TBTT_WAKEUP_START:
 		vnt_next_tbtt_wakeup(pDevice);
 		break;
@@ -134,26 +124,10 @@ void vRunCommand(struct work_struct *work)
 		}
 		break;
 
-	case WLAN_CMD_MAC_DISPOWERSAVING_START:
-		vnt_control_in_u8(pDevice, MESSAGE_REQUEST_MACREG, MAC_REG_PSCTL, &byData);
-		if ((byData & PSCTL_PS) != 0) {
-			// disable power saving hw function
-			vnt_control_out(pDevice,
-					MESSAGE_TYPE_DISABLE_PS,
-					0,
-					0,
-					0,
-					NULL
-					);
-		}
-		break;
-
 	case WLAN_CMD_11H_CHSW_START:
 		vnt_set_channel(pDevice, pDevice->hw->conf.chandef.chan->hw_value);
 		break;
 
-	case WLAN_CMD_CONFIGURE_FILTER_START:
-		break;
 	default:
 		break;
 	} //switch
@@ -185,10 +159,6 @@ static int s_bCommandComplete(struct vnt_private *pDevice)
 			pDevice->eCommandState = WLAN_CMD_INIT_MAC80211_START;
 			break;
 
-		case WLAN_CMD_CHANGE_BBSENSITIVITY:
-			pDevice->eCommandState = WLAN_CMD_CHANGE_BBSENSITIVITY_START;
-			break;
-
 		case WLAN_CMD_TBTT_WAKEUP:
 			pDevice->eCommandState = WLAN_CMD_TBTT_WAKEUP_START;
 			break;
@@ -205,10 +175,6 @@ static int s_bCommandComplete(struct vnt_private *pDevice)
 			pDevice->eCommandState = WLAN_CMD_CHANGE_ANTENNA_START;
 			break;
 
-		case WLAN_CMD_MAC_DISPOWERSAVING:
-			pDevice->eCommandState = WLAN_CMD_MAC_DISPOWERSAVING_START;
-			break;
-
 		case WLAN_CMD_11H_CHSW:
 			pDevice->eCommandState = WLAN_CMD_11H_CHSW_START;
 			break;
diff --git a/drivers/staging/vt6656/wcmd.h b/drivers/staging/vt6656/wcmd.h
index eb2e972..4fe34b5 100644
--- a/drivers/staging/vt6656/wcmd.h
+++ b/drivers/staging/vt6656/wcmd.h
@@ -37,21 +37,11 @@
 // Command code
 typedef enum tagCMD_CODE {
     WLAN_CMD_INIT_MAC80211,
-    WLAN_CMD_BSSID_SCAN,
-    WLAN_CMD_SSID,
-    WLAN_CMD_DISASSOCIATE,
-    WLAN_CMD_DEAUTH,
-    WLAN_CMD_RX_PSPOLL,
-    WLAN_CMD_CHANGE_BBSENSITIVITY,
     WLAN_CMD_SETPOWER,
     WLAN_CMD_TBTT_WAKEUP,
     WLAN_CMD_BECON_SEND,
     WLAN_CMD_CHANGE_ANTENNA,
-    WLAN_CMD_REMOVE_ALLKEY,
-    WLAN_CMD_MAC_DISPOWERSAVING,
     WLAN_CMD_11H_CHSW,
-    WLAN_CMD_RUN_AP,
-    WLAN_CMD_CONFIGURE_FILTER
 } CMD_CODE, *PCMD_CODE;
 
 #define CMD_Q_SIZE              32
@@ -77,25 +67,11 @@ typedef struct tagCMD_ITEM {
 // Command state
 typedef enum tagCMD_STATE {
     WLAN_CMD_INIT_MAC80211_START,
-    WLAN_CMD_SCAN_START,
-    WLAN_CMD_SCAN_END,
-    WLAN_CMD_DISASSOCIATE_START,
-    WLAN_CMD_DEAUTHEN_START,
-    WLAN_CMD_SSID_START,
-    WLAN_AUTHENTICATE_WAIT,
-    WLAN_ASSOCIATE_WAIT,
-    WLAN_DISASSOCIATE_WAIT,
-    WLAN_CMD_TX_PSPACKET_START,
-    WLAN_CMD_CHANGE_BBSENSITIVITY_START,
     WLAN_CMD_SETPOWER_START,
-    WLAN_CMD_AP_MODE_START,
     WLAN_CMD_TBTT_WAKEUP_START,
     WLAN_CMD_BECON_SEND_START,
     WLAN_CMD_CHANGE_ANTENNA_START,
-    WLAN_CMD_REMOVE_ALLKEY_START,
-    WLAN_CMD_MAC_DISPOWERSAVING_START,
     WLAN_CMD_11H_CHSW_START,
-    WLAN_CMD_CONFIGURE_FILTER_START,
     WLAN_CMD_IDLE
 } CMD_STATE, *PCMD_STATE;
 
-- 
1.9.1

