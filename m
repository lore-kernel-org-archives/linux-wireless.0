Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:35217 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663AbaLDWOb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Dec 2014 17:14:31 -0500
Received: by mail-wi0-f171.google.com with SMTP id bs8so36207269wib.10
        for <linux-wireless@vger.kernel.org>; Thu, 04 Dec 2014 14:14:30 -0800 (PST)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>,
	Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH 5/6] staging: vt6655: Fix RFbSetPower() error: buffer overflow 'priv->abyCCKPwrTbl' 15 <= 56
Date: Thu,  4 Dec 2014 22:12:46 +0000
Message-Id: <1417731167-3231-5-git-send-email-tvboxspy@gmail.com> (sfid-20141204_231434_767968_9F5F1F85)
In-Reply-To: <1417731167-3231-1-git-send-email-tvboxspy@gmail.com>
References: <1417731167-3231-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Check uCH is not more than CB_MAX_CHANNEL_24G(14) on rates RATE_1M to RATE_11M

Return false as the call is invalid as these rates do not exist
above channel 14.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/rf.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/staging/vt6655/rf.c b/drivers/staging/vt6655/rf.c
index 27841aa..a6eabde 100644
--- a/drivers/staging/vt6655/rf.c
+++ b/drivers/staging/vt6655/rf.c
@@ -788,6 +788,9 @@ bool RFbSetPower(
 	case RATE_2M:
 	case RATE_5M:
 	case RATE_11M:
+		if (uCH > CB_MAX_CHANNEL_24G)
+			return false;
+
 		byPwr = priv->abyCCKPwrTbl[uCH];
 		byPwrdBm = priv->abyCCKDefaultPwr[uCH];
 		break;
-- 
2.1.0

