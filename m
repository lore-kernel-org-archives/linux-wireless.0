Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:36470 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752579AbaKGTGi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Nov 2014 14:06:38 -0500
Received: by mail-wg0-f48.google.com with SMTP id m15so4419457wgh.35
        for <linux-wireless@vger.kernel.org>; Fri, 07 Nov 2014 11:06:36 -0800 (PST)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 01/10] staging: vt6655: CARDvUpdateBasicTopRate use basic_rates to find top rate
Date: Fri,  7 Nov 2014 19:06:00 +0000
Message-Id: <1415387169-3843-1-git-send-email-tvboxspy@gmail.com> (sfid-20141107_200640_740490_3B62E8AE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

basic_rates should now be used to find it.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/card.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/vt6655/card.c b/drivers/staging/vt6655/card.c
index aaa7289..d7b023b 100644
--- a/drivers/staging/vt6655/card.c
+++ b/drivers/staging/vt6655/card.c
@@ -843,7 +843,7 @@ void CARDvUpdateBasicTopRate(struct vnt_private *pDevice)
 
 	/* Determines the highest basic rate. */
 	for (ii = RATE_54M; ii >= RATE_6M; ii--) {
-		if ((pDevice->wBasicRate) & ((unsigned short)(1<<ii))) {
+		if ((pDevice->basic_rates) & ((u32)(1 << ii))) {
 			byTopOFDM = ii;
 			break;
 		}
@@ -851,7 +851,7 @@ void CARDvUpdateBasicTopRate(struct vnt_private *pDevice)
 	pDevice->byTopOFDMBasicRate = byTopOFDM;
 
 	for (ii = RATE_11M;; ii--) {
-		if ((pDevice->wBasicRate) & ((unsigned short)(1<<ii))) {
+		if ((pDevice->basic_rates) & ((u32)(1 << ii))) {
 			byTopCCK = ii;
 			break;
 		}
-- 
2.1.0

