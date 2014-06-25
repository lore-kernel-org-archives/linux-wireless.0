Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:47943 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932306AbaFYUVs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jun 2014 16:21:48 -0400
Received: by mail-wg0-f46.google.com with SMTP id y10so2575429wgg.5
        for <linux-wireless@vger.kernel.org>; Wed, 25 Jun 2014 13:21:47 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 26/34] staging: vt6656: Remove vnt_set_channel from device_init_registers
Date: Wed, 25 Jun 2014 21:20:03 +0100
Message-Id: <1403727611-6825-27-git-send-email-tvboxspy@gmail.com> (sfid-20140625_222952_021154_C4EBEDFD)
In-Reply-To: <1403727611-6825-1-git-send-email-tvboxspy@gmail.com>
References: <1403727611-6825-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/main_usb.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index feecd51..56bdf9d 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -242,7 +242,6 @@ device_set_options(struct vnt_private *pDevice) {
  */
 static int device_init_registers(struct vnt_private *pDevice)
 {
-	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
 	struct vnt_cmd_card_init *init_cmd = &pDevice->init_command;
 	struct vnt_rsp_card_init *init_rsp = &pDevice->init_response;
 	u8 abyBroadcastAddr[ETH_ALEN] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
@@ -468,12 +467,6 @@ static int device_init_registers(struct vnt_private *pDevice)
 		}
 	}
 
-	pMgmt->eScanType = WMAC_SCAN_PASSIVE;
-	pMgmt->uCurrChannel = pDevice->uChannel;
-	pMgmt->uIBSSChannel = pDevice->uChannel;
-
-	vnt_set_channel(pDevice, pMgmt->uCurrChannel);
-
 	/* get permanent network address */
 	memcpy(pDevice->abyPermanentNetAddr, init_rsp->net_addr, 6);
 	memcpy(pDevice->abyCurrentNetAddr,
-- 
1.9.1

