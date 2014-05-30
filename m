Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:48841 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934730AbaE3WYP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 May 2014 18:24:15 -0400
Received: by mail-we0-f177.google.com with SMTP id x48so2666857wes.36
        for <linux-wireless@vger.kernel.org>; Fri, 30 May 2014 15:24:14 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 6/8] staging: vt6656: rename CARDbRadioPowerOff to vnt_radio_power_off
Date: Fri, 30 May 2014 23:22:52 +0100
Message-Id: <1401488574-16508-6-git-send-email-tvboxspy@gmail.com> (sfid-20140531_002422_640801_64938C6B)
In-Reply-To: <1401488574-16508-1-git-send-email-tvboxspy@gmail.com>
References: <1401488574-16508-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Drop card and rename to vnt_radio_power_off

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/card.c     | 4 ++--
 drivers/staging/vt6656/card.h     | 2 +-
 drivers/staging/vt6656/main_usb.c | 2 +-
 drivers/staging/vt6656/wcmd.c     | 4 ++--
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/vt6656/card.c b/drivers/staging/vt6656/card.c
index 9ecf189..e2ed0f4 100644
--- a/drivers/staging/vt6656/card.c
+++ b/drivers/staging/vt6656/card.c
@@ -33,7 +33,7 @@
  *      vnt_get_next_tbtt - Calculate Next Beacon TSF counter
  *      vnt_reset_next_tbtt - Set NIC Beacon time
  *      vnt_update_next_tbtt - Sync. NIC Beacon time
- *      CARDbRadioPowerOff - Turn Off NIC Radio Power
+ *      vnt_radio_power_off - Turn Off NIC Radio Power
  *      CARDbRadioPowerOn - Turn On NIC Radio Power
  *      CARDbSetWEPMode - Set NIC Wep mode
  *      CARDbSetTxPower - Set NIC tx power
@@ -764,7 +764,7 @@ void vnt_update_next_tbtt(struct vnt_private *priv, u64 tsf,
  * Return Value: true if success; otherwise false
  *
  */
-int CARDbRadioPowerOff(struct vnt_private *priv)
+int vnt_radio_power_off(struct vnt_private *priv)
 {
 	int ret = true;
 
diff --git a/drivers/staging/vt6656/card.h b/drivers/staging/vt6656/card.h
index d5f7c68..614e6d6 100644
--- a/drivers/staging/vt6656/card.h
+++ b/drivers/staging/vt6656/card.h
@@ -58,7 +58,7 @@ void vnt_reset_next_tbtt(struct vnt_private *, u16);
 void vnt_update_next_tbtt(struct vnt_private *, u64, u16);
 u64 vnt_get_next_tbtt(u64, u16);
 u64 vnt_get_tsf_offset(u8 byRxRate, u64 qwTSF1, u64 qwTSF2);
-int CARDbRadioPowerOff(struct vnt_private *pDevice);
+int vnt_radio_power_off(struct vnt_private *);
 int CARDbRadioPowerOn(struct vnt_private *pDevice);
 u8 vnt_get_pkt_type(struct vnt_private *);
 void CARDvSetBSSMode(struct vnt_private *pDevice);
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 636afc2..2378068 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -560,7 +560,7 @@ static int device_init_registers(struct vnt_private *pDevice)
 
 	if ((pDevice->bHWRadioOff == true) ||
 				(pDevice->bRadioControlOff == true)) {
-		CARDbRadioPowerOff(pDevice);
+		vnt_radio_power_off(pDevice);
 	} else {
 		CARDbRadioPowerOn(pDevice);
 	}
diff --git a/drivers/staging/vt6656/wcmd.c b/drivers/staging/vt6656/wcmd.c
index cec6fc6..d1d6cf2 100644
--- a/drivers/staging/vt6656/wcmd.c
+++ b/drivers/staging/vt6656/wcmd.c
@@ -439,7 +439,7 @@ void vRunCommand(struct work_struct *work)
 		}
 		netif_stop_queue(pDevice->dev);
 		if (pDevice->bNeedRadioOFF == true)
-			CARDbRadioPowerOff(pDevice);
+			vnt_radio_power_off(pDevice);
 
 		break;
 
@@ -798,7 +798,7 @@ void vRunCommand(struct work_struct *work)
 				memset(pItemSSID->abySSID, 0, WLAN_SSID_MAXLEN);
 
 				netif_stop_queue(pDevice->dev);
-				CARDbRadioPowerOff(pDevice);
+				vnt_radio_power_off(pDevice);
 				MACvRegBitsOn(pDevice, MAC_REG_GPIOCTL1, GPIO3_INTMD);
 
 				vnt_mac_set_led(pDevice, LEDSTS_STS, LEDSTS_OFF);
-- 
1.9.1

