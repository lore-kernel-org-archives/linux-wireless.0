Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-db3on0139.outbound.protection.outlook.com ([157.55.234.139]:11968
	"EHLO emea01-db3-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752889AbbF2NQs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Jun 2015 09:16:48 -0400
From: "Mutharaju, Prasanna (P.)" <mkarthi3@visteon.com>
To: Johnny Kim <johnny.kim@atmel.com>,
	Rachel Kim <rachel.kim@atmel.com>,
	Dean Lee <dean.lee@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: [PATCH] staging:wilc1000: code cleanup Fix reported by coccinelle
Date: Mon, 29 Jun 2015 12:43:32 +0000
Message-ID: <20150629124227.GA16645@ubuntu> (sfid-20150629_151652_152053_00C4A607)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Prasanna Karthik <mkarthi3@visteon.com>

Removed {} for single statement if block

Signed-off-by: Prasanna Karthik <mkarthi3@visteon.com>
---
 drivers/staging/wilc1000/fifo_buffer.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wilc1000/fifo_buffer.c b/drivers/staging/wilc1000/fifo_buffer.c
index b6c07cf..be38493 100644
--- a/drivers/staging/wilc1000/fifo_buffer.c
+++ b/drivers/staging/wilc1000/fifo_buffer.c
@@ -31,11 +31,10 @@ u32 FIFO_DeInit(tHANDLE hFifo)
 	u32 u32Error = 0;
 	tstrFifoHandler *pstrFifoHandler = (tstrFifoHandler *) hFifo;
 	if (pstrFifoHandler) {
-		if (pstrFifoHandler->pu8Buffer)	{
+		if (pstrFifoHandler->pu8Buffer)
 			WILC_FREE (pstrFifoHandler->pu8Buffer);
-		} else {
+		else
 			u32Error = 1;
-		}
 
 		WILC_FREE (pstrFifoHandler);
 	} else {
@@ -52,11 +51,11 @@ u32 FIFO_ReadBytes(tHANDLE hFifo, u8 *pu8Buffer, u32 u32BytesToRead, u32 *pu32By
 		if (pstrFifoHandler->u32TotalBytes) {
 			down(&pstrFifoHandler->SemBuffer);
 
-			if (u32BytesToRead > pstrFifoHandler->u32TotalBytes) {
+			if (u32BytesToRead > pstrFifoHandler->u32TotalBytes)
 				*pu32BytesRead = pstrFifoHandler->u32TotalBytes;
-			} else {
+			else
 				*pu32BytesRead = u32BytesToRead;
-			}
+
 			if ((pstrFifoHandler->u32ReadOffset + u32BytesToRead) <= pstrFifoHandler->u32BufferLength) {
 				WILC_memcpy(pu8Buffer, pstrFifoHandler->pu8Buffer + pstrFifoHandler->u32ReadOffset,
 					    *pu32BytesRead);
-- 
1.7.0.4
