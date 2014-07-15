Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f182.google.com ([74.125.82.182]:40284 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932826AbaGOSzi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Jul 2014 14:55:38 -0400
Received: by mail-we0-f182.google.com with SMTP id q59so5997204wes.41
        for <linux-wireless@vger.kernel.org>; Tue, 15 Jul 2014 11:55:37 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, peter.senna@gmail.com,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 01/12] staging: vt6656: INTvWorkItem remove camel case
Date: Tue, 15 Jul 2014 19:54:32 +0100
Message-Id: <1405450483-2875-1-git-send-email-tvboxspy@gmail.com> (sfid-20140715_205542_335260_DD7CBB19)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Camel case changes
pDevice -> priv
ntStatus -> status

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/int.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/vt6656/int.c b/drivers/staging/vt6656/int.c
index dad1543..54016f9 100644
--- a/drivers/staging/vt6656/int.c
+++ b/drivers/staging/vt6656/int.c
@@ -77,18 +77,18 @@ static const u8 fallback_rate1[5][5] = {
  *  if we've gotten no data
  *
 -*/
-void INTvWorkItem(struct vnt_private *pDevice)
+void INTvWorkItem(struct vnt_private *priv)
 {
 	unsigned long flags;
-	int ntStatus;
+	int status;
 
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"---->Interrupt Polling Thread\n");
 
-	spin_lock_irqsave(&pDevice->lock, flags);
+	spin_lock_irqsave(&priv->lock, flags);
 
-	ntStatus = PIPEnsInterruptRead(pDevice);
+	status = PIPEnsInterruptRead(priv);
 
-	spin_unlock_irqrestore(&pDevice->lock, flags);
+	spin_unlock_irqrestore(&priv->lock, flags);
 }
 
 static int vnt_int_report_rate(struct vnt_private *priv, u8 pkt_no, u8 tsr)
-- 
2.0.1

