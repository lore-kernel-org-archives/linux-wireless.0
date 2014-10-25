Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:56916 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233AbaJYS6E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Oct 2014 14:58:04 -0400
Received: by mail-wi0-f178.google.com with SMTP id q5so3546868wiv.5
        for <linux-wireless@vger.kernel.org>; Sat, 25 Oct 2014 11:58:03 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, forest@alittletooquiet.net,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 19/31] staging: vt6655: mac80211 conversion: device_init_registers remove legacy code
Date: Sat, 25 Oct 2014 09:20:29 +0100
Message-Id: <1414225241-5480-20-git-send-email-tvboxspy@gmail.com> (sfid-20141025_205809_237257_C3ED42CD)
In-Reply-To: <1414225241-5480-1-git-send-email-tvboxspy@gmail.com>
References: <1414225241-5480-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove pMgmt, byCurrentCh, VNTWIFIbConfigPhyMode, eEncryptionStatus and netif_stop_queue.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/device_main.c | 15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index a888c26..77d81b3 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -412,7 +412,6 @@ static void device_init_registers(struct vnt_private *pDevice)
 	unsigned char byCCKPwrdBm = 0;
 	unsigned char byOFDMPwrdBm = 0;
 	int zonetype = 0;
-	PSMgmtObject    pMgmt = &(pDevice->sMgmtObj);
 
 	MACbShutdown(pDevice->PortOffset);
 	BBvSoftwareReset(pDevice->PortOffset);
@@ -616,8 +615,6 @@ static void device_init_registers(struct vnt_private *pDevice)
 					   (unsigned char)(ii + EEP_OFS_OFDMA_PWR_dBm));
 	}
 
-	init_channel_table((void *)pDevice);
-
 	if (pDevice->byLocalID > REV_ID_VT3253_B1) {
 		MACvSelectPage1(pDevice->PortOffset);
 
@@ -652,8 +649,6 @@ static void device_init_registers(struct vnt_private *pDevice)
 	BBvSetRxAntennaMode(pDevice->PortOffset, pDevice->byRxAntennaMode);
 	BBvSetTxAntennaMode(pDevice->PortOffset, pDevice->byTxAntennaMode);
 
-	pDevice->byCurrentCh = 0;
-
 	/* Set BB and packet type at the same time. */
 	/* Set Short Slot Time, xIFS, and RSPINF. */
 	if (pDevice->uConnectionRate == RATE_AUTO)
@@ -661,10 +656,6 @@ static void device_init_registers(struct vnt_private *pDevice)
 	else
 		pDevice->wCurrentRate = (unsigned short)pDevice->uConnectionRate;
 
-	/* default G Mode */
-	VNTWIFIbConfigPhyMode(pDevice->pMgmt, PHY_TYPE_11G);
-	VNTWIFIbConfigPhyMode(pDevice->pMgmt, PHY_TYPE_AUTO);
-
 	pDevice->bRadioOff = false;
 
 	pDevice->byRadioCtl = SROMbyReadEmbedded(pDevice->PortOffset,
@@ -685,8 +676,6 @@ static void device_init_registers(struct vnt_private *pDevice)
 	if (pDevice->bHWRadioOff || pDevice->bRadioControlOff)
 		CARDbRadioPowerOff(pDevice);
 
-	pMgmt->eScanType = WMAC_SCAN_PASSIVE;
-
 	/* get Permanent network address */
 	SROMvReadEtherAddress(pDevice->PortOffset, pDevice->abyCurrentNetAddr);
 	pr_debug("Network address = %pM\n", pDevice->abyCurrentNetAddr);
@@ -699,16 +688,12 @@ static void device_init_registers(struct vnt_private *pDevice)
 	if (pDevice->byLocalID <= REV_ID_VT3253_A1)
 		MACvRegBitsOn(pDevice->PortOffset, MAC_REG_RCR, RCR_WPAERR);
 
-	pDevice->eEncryptionStatus = Ndis802_11EncryptionDisabled;
-
 	/* Turn On Rx DMA */
 	MACvReceive0(pDevice->PortOffset);
 	MACvReceive1(pDevice->PortOffset);
 
 	/* start the adapter */
 	MACvStart(pDevice->PortOffset);
-
-	netif_stop_queue(pDevice->dev);
 }
 
 static void device_init_diversity_timer(struct vnt_private *pDevice)
-- 
1.9.1

