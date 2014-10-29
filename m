Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:62747 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755603AbaJ2RpQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2014 13:45:16 -0400
Received: by mail-wg0-f46.google.com with SMTP id x13so2470487wgg.19
        for <linux-wireless@vger.kernel.org>; Wed, 29 Oct 2014 10:45:15 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, forest@alittletooquiet.net,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH v2 17/34] staging: vt6655: mac80211 conversion: card.c use basic_rates
Date: Wed, 29 Oct 2014 17:43:52 +0000
Message-Id: <1414604649-9105-18-git-send-email-tvboxspy@gmail.com> (sfid-20141029_185344_821155_77465DE4)
In-Reply-To: <1414604649-9105-1-git-send-email-tvboxspy@gmail.com>
References: <1414604649-9105-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use basic_rates to find cck and ofdm rates.

wBasicRate will be removed later.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/card.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/vt6655/card.c b/drivers/staging/vt6655/card.c
index 090c286..a1330bc 100644
--- a/drivers/staging/vt6655/card.c
+++ b/drivers/staging/vt6655/card.c
@@ -1457,7 +1457,7 @@ static unsigned short CARDwGetCCKControlRate(struct vnt_private *pDevice,
 	unsigned int ui = (unsigned int) wRateIdx;
 
 	while (ui > RATE_1M) {
-		if (pDevice->wBasicRate & ((unsigned short)1 << ui))
+		if (pDevice->basic_rates & ((u32)0x1 << ui))
 			return (unsigned short)ui;
 
 		ui--;
@@ -1482,7 +1482,7 @@ static unsigned short CARDwGetOFDMControlRate(struct vnt_private *pDevice,
 {
 	unsigned int ui = (unsigned int) wRateIdx;
 
-	pr_debug("BASIC RATE: %X\n", pDevice->wBasicRate);
+	pr_debug("BASIC RATE: %X\n", pDevice->basic_rates);
 
 	if (!CARDbIsOFDMinBasicRate((void *)pDevice)) {
 		pr_debug("CARDwGetOFDMControlRate:(NO OFDM) %d\n", wRateIdx);
@@ -1491,7 +1491,7 @@ static unsigned short CARDwGetOFDMControlRate(struct vnt_private *pDevice,
 		return wRateIdx;
 	}
 	while (ui > RATE_11M) {
-		if (pDevice->wBasicRate & ((unsigned short)1 << ui)) {
+		if (pDevice->basic_rates & ((u32)0x1 << ui)) {
 			pr_debug("CARDwGetOFDMControlRate : %d\n", ui);
 			return (unsigned short)ui;
 		}
-- 
2.1.0

