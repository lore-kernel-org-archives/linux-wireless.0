Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:35337 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753040AbbIPQVr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Sep 2015 12:21:47 -0400
From: Aparna Karuthodi <kdasaparna@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	devel@driverdev.osuosl.org, Aparna Karuthodi <kdasaparna@gmail.com>
Subject: [PATCH] staging: wilc1000: Removed unwanted curly braces
Date: Wed, 16 Sep 2015 21:50:50 +0530
Message-Id: <1442420450-5760-1-git-send-email-kdasaparna@gmail.com> (sfid-20150916_182206_165785_27CE2081)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Removed unwanted curly braces of a single statement if-else block to
remove a coding style warning detected by checkpatch. The warning is
given below:

58: WARNING: braces {} are not necessary for any arm of this statement

Signed-off-by: Aparna Karuthodi <kdasaparna@gmail.com>
---
 drivers/staging/wilc1000/fifo_buffer.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/fifo_buffer.c b/drivers/staging/wilc1000/fifo_buffer.c
index b6c07cf..4fbac3d 100644
--- a/drivers/staging/wilc1000/fifo_buffer.c
+++ b/drivers/staging/wilc1000/fifo_buffer.c
@@ -52,11 +52,10 @@ u32 FIFO_ReadBytes(tHANDLE hFifo, u8 *pu8Buffer, u32 u32BytesToRead, u32 *pu32By
 		if (pstrFifoHandler->u32TotalBytes) {
 			down(&pstrFifoHandler->SemBuffer);
 
-			if (u32BytesToRead > pstrFifoHandler->u32TotalBytes) {
+			if (u32BytesToRead > pstrFifoHandler->u32TotalBytes)
 				*pu32BytesRead = pstrFifoHandler->u32TotalBytes;
-			} else {
+			 else
 				*pu32BytesRead = u32BytesToRead;
-			}
 			if ((pstrFifoHandler->u32ReadOffset + u32BytesToRead) <= pstrFifoHandler->u32BufferLength) {
 				WILC_memcpy(pu8Buffer, pstrFifoHandler->pu8Buffer + pstrFifoHandler->u32ReadOffset,
 					    *pu32BytesRead);
-- 
1.7.9.5

