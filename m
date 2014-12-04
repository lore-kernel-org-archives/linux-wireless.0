Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:60038 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933105AbaLDWOk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Dec 2014 17:14:40 -0500
Received: by mail-wg0-f52.google.com with SMTP id a1so23799904wgh.11
        for <linux-wireless@vger.kernel.org>; Thu, 04 Dec 2014 14:14:39 -0800 (PST)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 6/6] staging: vt6655: RFbSetPower remove unused variable byPwrdBm
Date: Thu,  4 Dec 2014 22:12:47 +0000
Message-Id: <1417731167-3231-6-git-send-email-tvboxspy@gmail.com> (sfid-20141204_231443_631763_6895BE01)
In-Reply-To: <1417731167-3231-1-git-send-email-tvboxspy@gmail.com>
References: <1417731167-3231-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

byPwrdBm is set but never used.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/rf.c | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/drivers/staging/vt6655/rf.c b/drivers/staging/vt6655/rf.c
index a6eabde..941b2ad 100644
--- a/drivers/staging/vt6655/rf.c
+++ b/drivers/staging/vt6655/rf.c
@@ -775,7 +775,6 @@ bool RFbSetPower(
 	bool bResult = true;
 	unsigned char byPwr = 0;
 	unsigned char byDec = 0;
-	unsigned char byPwrdBm = 0;
 
 	if (priv->dwDiagRefCount != 0)
 		return true;
@@ -792,7 +791,6 @@ bool RFbSetPower(
 			return false;
 
 		byPwr = priv->abyCCKPwrTbl[uCH];
-		byPwrdBm = priv->abyCCKDefaultPwr[uCH];
 		break;
 	case RATE_6M:
 	case RATE_9M:
@@ -806,15 +804,6 @@ bool RFbSetPower(
 		if (byDec >= priv->byMaxPwrLevel)
 			byDec = priv->byMaxPwrLevel-1;
 
-		if (priv->byRFType == RF_UW2452) {
-			byPwrdBm = byDec - byPwr;
-			byPwrdBm /= 3;
-		} else {
-			byPwrdBm = byDec - byPwr;
-			byPwrdBm >>= 1;
-		}
-
-		byPwrdBm += priv->abyOFDMDefaultPwr[uCH];
 		byPwr = byDec;
 		break;
 	case RATE_24M:
@@ -822,7 +811,6 @@ bool RFbSetPower(
 	case RATE_48M:
 	case RATE_54M:
 		byPwr = priv->abyOFDMPwrTbl[uCH];
-		byPwrdBm = priv->abyOFDMDefaultPwr[uCH];
 		break;
 	}
 
-- 
2.1.0

