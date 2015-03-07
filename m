Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:35434 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276AbbCGRFa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Mar 2015 12:05:30 -0500
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>,
	<stable@vger.kernel.org>
Subject: [PATCH resend 1/3] vt6655: RFbSetPower fix missing rate RATE_12M
Date: Sat,  7 Mar 2015 17:04:54 +0000
Message-Id: <1425747896-8353-1-git-send-email-tvboxspy@gmail.com> (sfid-20150307_180539_181848_045A526B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When the driver sets this rate a power of zero value is set causing
data flow stoppage until another rate is tried.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
Cc: <stable@vger.kernel.org>
---
 drivers/staging/vt6655/rf.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/vt6655/rf.c b/drivers/staging/vt6655/rf.c
index 941b2ad..7626f63 100644
--- a/drivers/staging/vt6655/rf.c
+++ b/drivers/staging/vt6655/rf.c
@@ -794,6 +794,7 @@ bool RFbSetPower(
 		break;
 	case RATE_6M:
 	case RATE_9M:
+	case RATE_12M:
 	case RATE_18M:
 		byPwr = priv->abyOFDMPwrTbl[uCH];
 		if (priv->byRFType == RF_UW2452)
-- 
2.1.4

