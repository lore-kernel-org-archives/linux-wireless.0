Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:44298 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996AbbASSZB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Jan 2015 13:25:01 -0500
Received: by mail-wi0-f178.google.com with SMTP id em10so7629080wid.5
        for <linux-wireless@vger.kernel.org>; Mon, 19 Jan 2015 10:25:00 -0800 (PST)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>,
	Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH 5/6] staging: vt6655: Fix RFbSetPower() error: buffer overflow 'priv->abyCCKPwrTbl' 15 <= 56
Date: Mon, 19 Jan 2015 18:24:14 +0000
Message-Id: <1421691855-2927-5-git-send-email-tvboxspy@gmail.com> (sfid-20150119_192515_172041_8B304E74)
In-Reply-To: <1421691855-2927-1-git-send-email-tvboxspy@gmail.com>
References: <1421691855-2927-1-git-send-email-tvboxspy@gmail.com>
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

