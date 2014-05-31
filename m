Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:61141 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756394AbaEaKvd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 May 2014 06:51:33 -0400
Received: by mail-wi0-f175.google.com with SMTP id f8so2360934wiw.2
        for <linux-wireless@vger.kernel.org>; Sat, 31 May 2014 03:51:31 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 06/14] staging: vt6656: rename MACvRegBitsOff to vnt_mac_reg_bits_off
Date: Sat, 31 May 2014 11:50:41 +0100
Message-Id: <1401533449-2972-6-git-send-email-tvboxspy@gmail.com> (sfid-20140531_125147_757208_2C1814BC)
In-Reply-To: <1401533449-2972-1-git-send-email-tvboxspy@gmail.com>
References: <1401533449-2972-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/card.c     | 6 +++---
 drivers/staging/vt6656/mac.c      | 2 +-
 drivers/staging/vt6656/mac.h      | 2 +-
 drivers/staging/vt6656/main_usb.c | 3 ++-
 drivers/staging/vt6656/power.c    | 4 ++--
 drivers/staging/vt6656/wcmd.c     | 8 ++++----
 drivers/staging/vt6656/wmgr.c     | 5 ++---
 7 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/vt6656/card.c b/drivers/staging/vt6656/card.c
index 03b0cf3..4e3f34a 100644
--- a/drivers/staging/vt6656/card.c
+++ b/drivers/staging/vt6656/card.c
@@ -92,7 +92,7 @@ void vnt_set_channel(struct vnt_private *priv, u32 connection_channel)
 	MACvRegBitsOn(priv, MAC_REG_MACCR, MACCR_CLRNAV);
 
 	/* Set Channel[7] = 0 to tell H/W channel is changing now. */
-	MACvRegBitsOff(priv, MAC_REG_CHANNEL, 0xb0);
+	vnt_mac_reg_bits_off(priv, MAC_REG_CHANNEL, 0xb0);
 
 	vnt_control_out(priv, MESSAGE_TYPE_SELECT_CHANNLE,
 					connection_channel, 0, 0, NULL);
@@ -777,12 +777,12 @@ int vnt_radio_power_off(struct vnt_private *priv)
 	case RF_VT3226:
 	case RF_VT3226D0:
 	case RF_VT3342A0:
-		MACvRegBitsOff(priv, MAC_REG_SOFTPWRCTL,
+		vnt_mac_reg_bits_off(priv, MAC_REG_SOFTPWRCTL,
 				(SOFTPWRCTL_SWPE2 | SOFTPWRCTL_SWPE3));
 		break;
 	}
 
-	MACvRegBitsOff(priv, MAC_REG_HOSTCR, HOSTCR_RXON);
+	vnt_mac_reg_bits_off(priv, MAC_REG_HOSTCR, HOSTCR_RXON);
 
 	BBvSetDeepSleep(priv);
 
diff --git a/drivers/staging/vt6656/mac.c b/drivers/staging/vt6656/mac.c
index 2d5121a..cf62ddf 100644
--- a/drivers/staging/vt6656/mac.c
+++ b/drivers/staging/vt6656/mac.c
@@ -147,7 +147,7 @@ void vnt_mac_set_keyentry(struct vnt_private *priv, u16 key_ctl, u32 entry_idx,
 		(u16)key_idx, sizeof(struct vnt_mac_set_key), (u8 *)&set_key);
 }
 
-void MACvRegBitsOff(struct vnt_private *priv, u8 reg_ofs, u8 bits)
+void vnt_mac_reg_bits_off(struct vnt_private *priv, u8 reg_ofs, u8 bits)
 {
 	u8 data[2];
 
diff --git a/drivers/staging/vt6656/mac.h b/drivers/staging/vt6656/mac.h
index 331c75c..a12f883 100644
--- a/drivers/staging/vt6656/mac.h
+++ b/drivers/staging/vt6656/mac.h
@@ -419,7 +419,7 @@ void vnt_mac_shutdown(struct vnt_private *);
 void vnt_mac_set_bb_type(struct vnt_private *, u8);
 void vnt_mac_disable_keyentry(struct vnt_private *, u8);
 void vnt_mac_set_keyentry(struct vnt_private *, u16, u32, u32, u8 *, u8 *);
-void MACvRegBitsOff(struct vnt_private *, u8, u8);
+void vnt_mac_reg_bits_off(struct vnt_private *, u8, u8);
 void MACvRegBitsOn(struct vnt_private *, u8, u8);
 void MACvWriteWord(struct vnt_private *, u8, u16);
 void MACvWriteBSSIDAddress(struct vnt_private *, u8 *);
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index fea667f..e8c5f97 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -546,7 +546,8 @@ static int device_init_registers(struct vnt_private *pDevice)
 			pDevice->bHWRadioOff = true;
 			MACvRegBitsOn(pDevice, MAC_REG_GPIOCTL1, GPIO3_INTMD);
 		} else {
-			MACvRegBitsOff(pDevice, MAC_REG_GPIOCTL1, GPIO3_INTMD);
+			vnt_mac_reg_bits_off(pDevice, MAC_REG_GPIOCTL1,
+								GPIO3_INTMD);
 			pDevice->bHWRadioOff = false;
 		}
 
diff --git a/drivers/staging/vt6656/power.c b/drivers/staging/vt6656/power.c
index ddbd046..fc7a29b 100644
--- a/drivers/staging/vt6656/power.c
+++ b/drivers/staging/vt6656/power.c
@@ -88,7 +88,7 @@ void PSvEnablePowerSaving(struct vnt_private *pDevice, u16 wListenInterval)
 	if (wListenInterval >= 2) {
 
 		/* clear always listen beacon */
-		MACvRegBitsOff(pDevice, MAC_REG_PSCTL, PSCTL_ALBCN);
+		vnt_mac_reg_bits_off(pDevice, MAC_REG_PSCTL, PSCTL_ALBCN);
 
 		/* first time set listen next beacon */
 		MACvRegBitsOn(pDevice, MAC_REG_PSCTL, PSCTL_LNBCN);
@@ -133,7 +133,7 @@ void PSvDisablePowerSaving(struct vnt_private *pDevice)
 						0, 0, NULL);
 
 	/* clear AutoSleep */
-	MACvRegBitsOff(pDevice, MAC_REG_PSCFG, PSCFG_AUTOSLEEP);
+	vnt_mac_reg_bits_off(pDevice, MAC_REG_PSCFG, PSCFG_AUTOSLEEP);
 
 	/* set always listen beacon */
 	MACvRegBitsOn(pDevice, MAC_REG_PSCTL, PSCTL_ALBCN);
diff --git a/drivers/staging/vt6656/wcmd.c b/drivers/staging/vt6656/wcmd.c
index acd5be7..35cf0cf 100644
--- a/drivers/staging/vt6656/wcmd.c
+++ b/drivers/staging/vt6656/wcmd.c
@@ -111,7 +111,7 @@ static void vAdHocBeaconStop(struct vnt_private *pDevice)
 	if (bStop) {
 		//PMESG(("STOP_BEACON: IBSSChannel = %u, ScanChannel = %u\n",
 		//        pMgmt->uIBSSChannel, pMgmt->uScanChannel));
-		MACvRegBitsOff(pDevice, MAC_REG_TCR, TCR_AUTOBCNTX);
+		vnt_mac_reg_bits_off(pDevice, MAC_REG_TCR, TCR_AUTOBCNTX);
 	}
 
 } /* vAdHocBeaconStop */
@@ -325,7 +325,7 @@ void vRunCommand(struct work_struct *work)
 				pDevice->byScanBBType = pDevice->byBBType;  //lucas
 				pDevice->bStopDataPkt = true;
 				// Turn off RCR_BSSID filter every time
-				MACvRegBitsOff(pDevice, MAC_REG_RCR, RCR_BSSID);
+				vnt_mac_reg_bits_off(pDevice, MAC_REG_RCR, RCR_BSSID);
 				pDevice->byRxMode &= ~RCR_BSSID;
 			}
 			//lucas
@@ -647,7 +647,7 @@ void vRunCommand(struct work_struct *work)
 					KERN_INFO "vMgrCreateOwnIBSS fail!\n");
 			}
 			// always turn off unicast bit
-			MACvRegBitsOff(pDevice, MAC_REG_RCR, RCR_UNICAST);
+			vnt_mac_reg_bits_off(pDevice, MAC_REG_RCR, RCR_UNICAST);
 			pDevice->byRxMode &= ~RCR_UNICAST;
 			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "wcmd: rx_mode = %x\n", pDevice->byRxMode);
 			BSSvAddMulticastNode(pDevice);
@@ -808,7 +808,7 @@ void vRunCommand(struct work_struct *work)
 				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO" WLAN_CMD_RADIO_START_ON........................\n");
 				pDevice->bHWRadioOff = false;
 				vnt_radio_power_on(pDevice);
-				MACvRegBitsOff(pDevice, MAC_REG_GPIOCTL1, GPIO3_INTMD);
+				vnt_mac_reg_bits_off(pDevice, MAC_REG_GPIOCTL1, GPIO3_INTMD);
 
 				vnt_mac_set_led(pDevice, LEDSTS_STS, LEDSTS_ON);
 			}
diff --git a/drivers/staging/vt6656/wmgr.c b/drivers/staging/vt6656/wmgr.c
index 0ba292c..7827d79 100644
--- a/drivers/staging/vt6656/wmgr.c
+++ b/drivers/staging/vt6656/wmgr.c
@@ -1932,7 +1932,6 @@ if(ChannelExceedZoneType(pDevice,byCurrChannel)==true)
                     if (pDevice->byPreambleType != byOldPreambleType)
 			vnt_set_rspinf(pDevice, (u8)pDevice->byBBType);
 
-                     // MACvRegBitsOff(pDevice->PortOffset, MAC_REG_RCR, RCR_BSSID);
                      // set highest basic rate
                      // s_vSetHighestBasicRate(pDevice, (PWLAN_IE_SUPP_RATES)pMgmt->abyCurrSuppRates);
                      // Prepare beacon frame
@@ -2561,7 +2560,7 @@ static void s_vMgrSynchBSS(struct vnt_private *pDevice, u32 uBSSMode,
 
     // if previous mode is IBSS.
     if(pMgmt->eCurrMode == WMAC_MODE_IBSS_STA) {
-        MACvRegBitsOff(pDevice, MAC_REG_TCR, TCR_AUTOBCNTX);
+	vnt_mac_reg_bits_off(pDevice, MAC_REG_TCR, TCR_AUTOBCNTX);
     }
 
     // Init the BSS informations
@@ -2636,7 +2635,7 @@ static void s_vMgrSynchBSS(struct vnt_private *pDevice, u32 uBSSMode,
     }
 
     if (uBSSMode == WMAC_MODE_ESS_STA) {
-        MACvRegBitsOff(pDevice, MAC_REG_HOSTCR, HOSTCR_ADHOC);
+	vnt_mac_reg_bits_off(pDevice, MAC_REG_HOSTCR, HOSTCR_ADHOC);
         MACvRegBitsOn(pDevice, MAC_REG_RCR, RCR_BSSID);
         pDevice->byRxMode |= RCR_BSSID;
         pMgmt->bCurrBSSIDFilterOn = true;
-- 
1.9.1

