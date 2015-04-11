Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:36744 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755249AbbDKT35 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Apr 2015 15:29:57 -0400
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>,
	<stable@vger.kernel.org>
Subject: [PATCH] staging: vt6655: Fix 80211 control and management status reporting.
Date: Sat, 11 Apr 2015 20:29:41 +0100
Message-Id: <1428780581-6393-1-git-send-email-tvboxspy@gmail.com> (sfid-20150411_213101_097884_5B50F62B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently only TD_FLAGS_NETIF_SKB are reported back to mac80211.

Move vnt_int_report_rate to report all frame types.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
Cc: <stable@vger.kernel.org> # v3.19+
---
 drivers/staging/vt6655/device_main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index 521d44f..c5f8233 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -941,9 +941,6 @@ static int device_tx_srv(struct vnt_private *pDevice, unsigned int uIdx)
 		/* Only the status of first TD in the chain is correct */
 		if (pTD->m_td1TD1.byTCR & TCR_STP) {
 			if ((pTD->pTDInfo->byFlags & TD_FLAGS_NETIF_SKB) != 0) {
-
-				vnt_int_report_rate(pDevice, pTD->pTDInfo, byTsr0, byTsr1);
-
 				if (!(byTsr1 & TSR1_TERR)) {
 					if (byTsr0 != 0) {
 						pr_debug(" Tx[%d] OK but has error. tsr1[%02X] tsr0[%02X]\n",
@@ -962,6 +959,9 @@ static int device_tx_srv(struct vnt_private *pDevice, unsigned int uIdx)
 						 (int)uIdx, byTsr1, byTsr0);
 				}
 			}
+
+			vnt_int_report_rate(pDevice, pTD->pTDInfo, byTsr0, byTsr1);
+
 			device_free_tx_buf(pDevice, pTD);
 			pDevice->iTDUsed[uIdx]--;
 		}
-- 
2.1.0

