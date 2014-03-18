Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:40006 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757811AbaCRT0Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Mar 2014 15:26:24 -0400
Received: by mail-wi0-f178.google.com with SMTP id bs8so3301492wib.5
        for <linux-wireless@vger.kernel.org>; Tue, 18 Mar 2014 12:26:23 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 09/14] staging: vt6656: vnt_time_stamp_off fix return to __le16
Date: Tue, 18 Mar 2014 19:25:03 +0000
Message-Id: <1395170708-2990-9-git-send-email-tvboxspy@gmail.com> (sfid-20140318_202631_449473_7E8CEDA4)
In-Reply-To: <1395170708-2990-1-git-send-email-tvboxspy@gmail.com>
References: <1395170708-2990-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index c0c3f50..4ae8c9c 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -327,7 +327,7 @@ static void s_vSWencryption(struct vnt_private *pDevice,
     }
 }
 
-static u16 vnt_time_stamp_off(struct vnt_private *priv, u16 rate)
+static __le16 vnt_time_stamp_off(struct vnt_private *priv, u16 rate)
 {
 	return cpu_to_le16(wTimeStampOff[priv->byPreambleType % 2]
 							[rate % MAX_RATE]);
-- 
1.9.0

