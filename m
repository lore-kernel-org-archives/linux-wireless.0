Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:59676 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892AbaJYTj0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Oct 2014 15:39:26 -0400
Received: by mail-wg0-f51.google.com with SMTP id b13so3063391wgh.34
        for <linux-wireless@vger.kernel.org>; Sat, 25 Oct 2014 12:39:25 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, forest@alittletooquiet.net,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 17/31] staging: vt6655: mac80211 conversion: card.c use basic_rates
Date: Sat, 25 Oct 2014 09:20:27 +0100
Message-Id: <1414225241-5480-18-git-send-email-tvboxspy@gmail.com> (sfid-20141025_213929_154954_8E810272)
In-Reply-To: <1414225241-5480-1-git-send-email-tvboxspy@gmail.com>
References: <1414225241-5480-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use basic_rates to find cck and ofdm rates.

wBasicRate will be removed later.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/card.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/vt6655/card.c b/drivers/staging/vt6655/card.c
index 5eddabc..cf87b49 100644
--- a/drivers/staging/vt6655/card.c
+++ b/drivers/staging/vt6655/card.c
@@ -1488,7 +1488,7 @@ static unsigned short CARDwGetCCKControlRate(struct vnt_private *pDevice,
 	unsigned int ui = (unsigned int) wRateIdx;
 
 	while (ui > RATE_1M) {
-		if (pDevice->wBasicRate & ((unsigned short)1 << ui))
+		if (pDevice->basic_rates & ((u32)0x1 << ui))
 			return (unsigned short)ui;
 
 		ui--;
@@ -1514,7 +1514,7 @@ static unsigned short CARDwGetOFDMControlRate(struct vnt_private *pDevice,
 {
 	unsigned int ui = (unsigned int) wRateIdx;
 
-	pr_debug("BASIC RATE: %X\n", pDevice->wBasicRate);
+	pr_debug("BASIC RATE: %X\n", pDevice->basic_rates);
 
 	if (!CARDbIsOFDMinBasicRate((void *)pDevice)) {
 		pr_debug("CARDwGetOFDMControlRate:(NO OFDM) %d\n", wRateIdx);
@@ -1523,7 +1523,7 @@ static unsigned short CARDwGetOFDMControlRate(struct vnt_private *pDevice,
 		return wRateIdx;
 	}
 	while (ui > RATE_11M) {
-		if (pDevice->wBasicRate & ((unsigned short)1 << ui)) {
+		if (pDevice->basic_rates & ((u32)0x1 << ui)) {
 			pr_debug("CARDwGetOFDMControlRate : %d\n", ui);
 			return (unsigned short)ui;
 		}
-- 
1.9.1

