Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f170.google.com ([74.125.82.170]:63756 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453AbaHQTnN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Aug 2014 15:43:13 -0400
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 4/5] staging: vt6655: vntwifi.c remove unused directive PLICE_DEBUG
Date: Sun, 17 Aug 2014 20:42:28 +0100
Message-Id: <1408304549-22363-4-git-send-email-tvboxspy@gmail.com> (sfid-20140817_214318_980240_B81914BB)
In-Reply-To: <1408304549-22363-1-git-send-email-tvboxspy@gmail.com>
References: <1408304549-22363-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

PLICE_DEBUG is not defined remove dead code.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/vntwifi.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/staging/vt6655/vntwifi.c b/drivers/staging/vt6655/vntwifi.c
index 4d425e0..59f66fe 100644
--- a/drivers/staging/vt6655/vntwifi.c
+++ b/drivers/staging/vt6655/vntwifi.c
@@ -543,10 +543,6 @@ VNTWIFIvGetTxRate(
 	} else { /* Infrastructure: rate decided from AP Node, index = 0 */
 
 		wTxDataRate = (pMgmt->sNodeDBTable[0].wTxDataRate);
-#ifdef	PLICE_DEBUG
-		pr_debug("GetTxRate:AP MAC is %pM,TxRate is %d\n",
-		       pMgmt->sNodeDBTable[0].abyMACAddr, wTxDataRate);
-#endif
 
 		pSupportRateIEs = (PWLAN_IE_SUPP_RATES) pMgmt->abyCurrSuppRates;
 		pExtSupportRateIEs = (PWLAN_IE_SUPP_RATES) pMgmt->abyCurrExtSuppRates;
-- 
1.9.1

