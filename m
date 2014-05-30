Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:41513 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932289AbaE3WYQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 May 2014 18:24:16 -0400
Received: by mail-wg0-f50.google.com with SMTP id x12so2607007wgg.33
        for <linux-wireless@vger.kernel.org>; Fri, 30 May 2014 15:24:15 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 7/8] staging: vt6656: rename CARDbRadioPowerOn to vnt_radio_power_on
Date: Fri, 30 May 2014 23:22:53 +0100
Message-Id: <1401488574-16508-7-git-send-email-tvboxspy@gmail.com> (sfid-20140531_002424_888860_EAF24678)
In-Reply-To: <1401488574-16508-1-git-send-email-tvboxspy@gmail.com>
References: <1401488574-16508-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Drop card and rename to vnt_radio_power_on

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/card.c     | 4 ++--
 drivers/staging/vt6656/card.h     | 2 +-
 drivers/staging/vt6656/main_usb.c | 2 +-
 drivers/staging/vt6656/wcmd.c     | 2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/vt6656/card.c b/drivers/staging/vt6656/card.c
index e2ed0f4..366d7d5 100644
--- a/drivers/staging/vt6656/card.c
+++ b/drivers/staging/vt6656/card.c
@@ -34,7 +34,7 @@
  *      vnt_reset_next_tbtt - Set NIC Beacon time
  *      vnt_update_next_tbtt - Sync. NIC Beacon time
  *      vnt_radio_power_off - Turn Off NIC Radio Power
- *      CARDbRadioPowerOn - Turn On NIC Radio Power
+ *      vnt_radio_power_on - Turn On NIC Radio Power
  *      CARDbSetWEPMode - Set NIC Wep mode
  *      CARDbSetTxPower - Set NIC tx power
  *
@@ -801,7 +801,7 @@ int vnt_radio_power_off(struct vnt_private *priv)
  * Return Value: true if success; otherwise false
  *
  */
-int CARDbRadioPowerOn(struct vnt_private *priv)
+int vnt_radio_power_on(struct vnt_private *priv)
 {
 	int ret = true;
 
diff --git a/drivers/staging/vt6656/card.h b/drivers/staging/vt6656/card.h
index 614e6d6..150f870 100644
--- a/drivers/staging/vt6656/card.h
+++ b/drivers/staging/vt6656/card.h
@@ -59,7 +59,7 @@ void vnt_update_next_tbtt(struct vnt_private *, u64, u16);
 u64 vnt_get_next_tbtt(u64, u16);
 u64 vnt_get_tsf_offset(u8 byRxRate, u64 qwTSF1, u64 qwTSF2);
 int vnt_radio_power_off(struct vnt_private *);
-int CARDbRadioPowerOn(struct vnt_private *pDevice);
+int vnt_radio_power_on(struct vnt_private *);
 u8 vnt_get_pkt_type(struct vnt_private *);
 void CARDvSetBSSMode(struct vnt_private *pDevice);
 
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 2378068..09da861 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -562,7 +562,7 @@ static int device_init_registers(struct vnt_private *pDevice)
 				(pDevice->bRadioControlOff == true)) {
 		vnt_radio_power_off(pDevice);
 	} else {
-		CARDbRadioPowerOn(pDevice);
+		vnt_radio_power_on(pDevice);
 	}
 
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"<----INIbInitAdapter Exit\n");
diff --git a/drivers/staging/vt6656/wcmd.c b/drivers/staging/vt6656/wcmd.c
index d1d6cf2..191e788 100644
--- a/drivers/staging/vt6656/wcmd.c
+++ b/drivers/staging/vt6656/wcmd.c
@@ -807,7 +807,7 @@ void vRunCommand(struct work_struct *work)
 			} else {
 				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO" WLAN_CMD_RADIO_START_ON........................\n");
 				pDevice->bHWRadioOff = false;
-				CARDbRadioPowerOn(pDevice);
+				vnt_radio_power_on(pDevice);
 				MACvRegBitsOff(pDevice, MAC_REG_GPIOCTL1, GPIO3_INTMD);
 
 				vnt_mac_set_led(pDevice, LEDSTS_STS, LEDSTS_ON);
-- 
1.9.1

