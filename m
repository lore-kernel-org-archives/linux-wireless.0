Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:38525 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758138AbbEaJgF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 May 2015 05:36:05 -0400
Received: by wizo1 with SMTP id o1so70812118wiz.1
        for <linux-wireless@vger.kernel.org>; Sun, 31 May 2015 02:36:04 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 6/9] staging: vt6655: vnt_interrupt_process remove page 0 select
Date: Sun, 31 May 2015 10:35:25 +0100
Message-Id: <1433064928-2139-6-git-send-email-tvboxspy@gmail.com> (sfid-20150531_113613_165497_7F818744)
In-Reply-To: <1433064928-2139-1-git-send-email-tvboxspy@gmail.com>
References: <1433064928-2139-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Page 1 is fully proctected by lock there is no need
to check for it. Page 0 is selected at other times.

Remove byOrgPageSel and its calls from function.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/device_main.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index d5f090f..2262a61 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -1056,7 +1056,6 @@ static void vnt_interrupt_process(struct vnt_private *pDevice)
 	struct ieee80211_low_level_stats *low_stats = &pDevice->low_stats;
 	int             max_count = 0;
 	u32 mib_counter;
-	unsigned char byOrgPageSel = 0;
 	unsigned long flags;
 
 	MACvReadISR(pDevice->PortOffset, &pDevice->dwIsr);
@@ -1073,13 +1072,6 @@ static void vnt_interrupt_process(struct vnt_private *pDevice)
 
 	spin_lock_irqsave(&pDevice->lock, flags);
 
-	/* Make sure current page is 0 */
-	VNSvInPortB(pDevice->PortOffset + MAC_REG_PAGE1SEL, &byOrgPageSel);
-	if (byOrgPageSel == 1)
-		MACvSelectPage0(pDevice->PortOffset);
-	else
-		byOrgPageSel = 0;
-
 	/* Read low level stats */
 	MACvReadMIBCounter(pDevice->PortOffset, &mib_counter);
 
@@ -1164,9 +1156,6 @@ static void vnt_interrupt_process(struct vnt_private *pDevice)
 			break;
 	}
 
-	if (byOrgPageSel == 1)
-		MACvSelectPage1(pDevice->PortOffset);
-
 	spin_unlock_irqrestore(&pDevice->lock, flags);
 
 	MACvIntEnable(pDevice->PortOffset, IMR_MASK_VALUE);
-- 
2.1.4

