Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:64165 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577AbaGLGya (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Jul 2014 02:54:30 -0400
Received: by mail-wg0-f46.google.com with SMTP id m15so1971824wgh.29
        for <linux-wireless@vger.kernel.org>; Fri, 11 Jul 2014 23:54:29 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 01/10] staging: vt6656: vCommandTimerWait remove camel case.
Date: Sat, 12 Jul 2014 07:53:39 +0100
Message-Id: <1405148028-4053-1-git-send-email-tvboxspy@gmail.com> (sfid-20140712_085434_173574_40CF343E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

camel case changes
pDevice -> priv
MSecond -> msecs

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/wcmd.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/vt6656/wcmd.c b/drivers/staging/vt6656/wcmd.c
index b62726f..2553cde 100644
--- a/drivers/staging/vt6656/wcmd.c
+++ b/drivers/staging/vt6656/wcmd.c
@@ -54,11 +54,9 @@ static int msglevel = MSG_LEVEL_INFO;
 
 static int s_bCommandComplete(struct vnt_private *);
 
-static void
-vCommandTimerWait(struct vnt_private *pDevice, unsigned long MSecond)
+static void vCommandTimerWait(struct vnt_private *priv, unsigned long msecs)
 {
-	schedule_delayed_work(&pDevice->run_command_work,
-						msecs_to_jiffies(MSecond));
+	schedule_delayed_work(&priv->run_command_work, msecs_to_jiffies(msecs));
 }
 
 void vRunCommand(struct work_struct *work)
-- 
1.9.1

