Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:37507 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757925AbbEaJf7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 May 2015 05:35:59 -0400
Received: by wifw1 with SMTP id w1so70931257wif.0
        for <linux-wireless@vger.kernel.org>; Sun, 31 May 2015 02:35:58 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 3/9] staging: vt6655: Remove call to STAvUpdateIsrStatCounter.
Date: Sun, 31 May 2015 10:35:22 +0100
Message-Id: <1433064928-2139-3-git-send-email-tvboxspy@gmail.com> (sfid-20150531_113608_316752_A2659A94)
In-Reply-To: <1433064928-2139-1-git-send-email-tvboxspy@gmail.com>
References: <1433064928-2139-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This function does not provide any data to users.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/device.h      | 2 --
 drivers/staging/vt6655/device_main.c | 1 -
 2 files changed, 3 deletions(-)

diff --git a/drivers/staging/vt6655/device.h b/drivers/staging/vt6655/device.h
index a49c6c6..62e07f5 100644
--- a/drivers/staging/vt6655/device.h
+++ b/drivers/staging/vt6655/device.h
@@ -286,8 +286,6 @@ struct vnt_private {
 	unsigned char abyCurrentNetAddr[ETH_ALEN]; __aligned(2)
 	bool bLinkPass;          /* link status: OK or fail */
 
-	/* Adapter statistics */
-	SStatCounter                scStatistic;
 	/* 802.11 counter */
 	SDot11Counters              s802_11Counter;
 
diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index c27f5ef..31f4ec7 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -1100,7 +1100,6 @@ static  irqreturn_t  device_intr(int irq,  void *dev_instance)
 	 * update ISR counter
 	 */
 	while (pDevice->dwIsr && pDevice->vif) {
-		STAvUpdateIsrStatCounter(&pDevice->scStatistic, pDevice->dwIsr);
 		MACvWriteISR(pDevice->PortOffset, pDevice->dwIsr);
 
 		if (pDevice->dwIsr & ISR_FETALERR) {
-- 
2.1.4

