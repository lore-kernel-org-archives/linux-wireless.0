Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:36305 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758090AbbEaJgK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 May 2015 05:36:10 -0400
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>,
	<stable@vger.kernel.org>
Subject: [PATCH 9/9] staging: vt6655: device_rx_srv check sk_buff is NULL
Date: Sun, 31 May 2015 10:35:28 +0100
Message-Id: <1433064928-2139-9-git-send-email-tvboxspy@gmail.com> (sfid-20150531_113620_560020_43169FC3)
In-Reply-To: <1433064928-2139-1-git-send-email-tvboxspy@gmail.com>
References: <1433064928-2139-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is a small chance that pRD->pRDInfo->skb could go NULL
while the interrupt is processing.

Put NULL check on loop to break out.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
Cc: <stable@vger.kernel.org>
---
 drivers/staging/vt6655/device_main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index aec3cce..8dbde24 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -805,6 +805,10 @@ static int device_rx_srv(struct vnt_private *pDevice, unsigned int uIdx)
 	     pRD = pRD->next) {
 		if (works++ > 15)
 			break;
+
+		if (!pRD->pRDInfo->skb)
+			break;
+
 		if (vnt_receive_frame(pDevice, pRD)) {
 			if (!device_alloc_rx_buf(pDevice, pRD)) {
 				dev_err(&pDevice->pcid->dev,
-- 
2.1.4

