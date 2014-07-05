Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:46125 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964908AbaGESYx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Jul 2014 14:24:53 -0400
Received: by mail-we0-f174.google.com with SMTP id u57so2752498wes.33
        for <linux-wireless@vger.kernel.org>; Sat, 05 Jul 2014 11:24:52 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 3/8] staging: vt6656: vnt_rf_setpower rate <= RATE_11M check array bound
Date: Sat,  5 Jul 2014 19:24:22 +0100
Message-Id: <1404584667-3582-3-git-send-email-tvboxspy@gmail.com> (sfid-20140705_202459_001229_629DB9AE)
In-Reply-To: <1404584667-3582-1-git-send-email-tvboxspy@gmail.com>
References: <1404584667-3582-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

decrement channel by one and check array bound.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rf.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/vt6656/rf.c b/drivers/staging/vt6656/rf.c
index 971f844..4124131 100644
--- a/drivers/staging/vt6656/rf.c
+++ b/drivers/staging/vt6656/rf.c
@@ -744,7 +744,10 @@ int vnt_rf_setpower(struct vnt_private *priv, u32 rate, u32 channel)
 	case RATE_2M:
 	case RATE_5M:
 	case RATE_11M:
-		power = priv->abyCCKPwrTbl[channel-1];
+		channel--;
+
+		if (channel < sizeof(priv->abyCCKPwrTbl))
+			power = priv->abyCCKPwrTbl[channel];
 		break;
 	case RATE_6M:
 	case RATE_9M:
-- 
1.9.1

