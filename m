Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:38354 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035AbaEWRBJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 May 2014 13:01:09 -0400
Received: by mail-wg0-f42.google.com with SMTP id y10so4988076wgg.25
        for <linux-wireless@vger.kernel.org>; Fri, 23 May 2014 10:01:07 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 05/20] staging: vt6656: camel case clean up MACvDisableKeyEntry
Date: Fri, 23 May 2014 18:00:04 +0100
Message-Id: <1400864419-8327-5-git-send-email-tvboxspy@gmail.com> (sfid-20140523_190115_092220_AE058152)
In-Reply-To: <1400864419-8327-1-git-send-email-tvboxspy@gmail.com>
References: <1400864419-8327-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Camel case changes
pDevice -> priv
uEntryIdx -> entry_idx

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/mac.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/vt6656/mac.c b/drivers/staging/vt6656/mac.c
index a341eab..c6bddf5 100644
--- a/drivers/staging/vt6656/mac.c
+++ b/drivers/staging/vt6656/mac.c
@@ -102,16 +102,10 @@ void MACvSetBBType(struct vnt_private *priv, u8 type)
  * Return Value: none
  *
  */
-void MACvDisableKeyEntry(struct vnt_private *pDevice, u8 uEntryIdx)
+void MACvDisableKeyEntry(struct vnt_private *priv, u8 entry_idx)
 {
-    //issue write misc fifo command to device
-    CONTROLnsRequestOut(pDevice,
-                        MESSAGE_TYPE_CLRKEYENTRY,
-                        0,
-                        0,
-			sizeof(uEntryIdx),
-			&uEntryIdx
-                        );
+	CONTROLnsRequestOut(priv, MESSAGE_TYPE_CLRKEYENTRY, 0, 0,
+		sizeof(entry_idx), &entry_idx);
 }
 
 /*
-- 
1.9.1

