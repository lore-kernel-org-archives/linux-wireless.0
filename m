Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:50077 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753189AbaGMJnm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Jul 2014 05:43:42 -0400
Received: by mail-wi0-f171.google.com with SMTP id hi2so1188578wib.16
        for <linux-wireless@vger.kernel.org>; Sun, 13 Jul 2014 02:43:41 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 08/13] staging: vt6656: rename vCommandTimerWait to vnt_cmd_timer_wait
Date: Sun, 13 Jul 2014 10:42:48 +0100
Message-Id: <1405244573-10978-8-git-send-email-tvboxspy@gmail.com> (sfid-20140713_114406_884419_B70C058D)
In-Reply-To: <1405244573-10978-1-git-send-email-tvboxspy@gmail.com>
References: <1405244573-10978-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/wcmd.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/vt6656/wcmd.c b/drivers/staging/vt6656/wcmd.c
index 8c5a0e8..87e682d 100644
--- a/drivers/staging/vt6656/wcmd.c
+++ b/drivers/staging/vt6656/wcmd.c
@@ -31,7 +31,7 @@
  *	vnt_cmd_complete - Command Complete function
  *      bScheduleCommand - Push Command and wait Command Scheduler to do
  *      vCommandTimer- Command call back functions
- *      vCommandTimerWait- Call back timer
+ *	vnt_cmd_timer_wait- Call back timer
  *      s_bClearBSSID_SCAN- Clear BSSID_SCAN cmd in CMD Queue
  *
  * Revision History:
@@ -49,7 +49,7 @@
 #include "rf.h"
 #include "channel.h"
 
-static void vCommandTimerWait(struct vnt_private *priv, unsigned long msecs)
+static void vnt_cmd_timer_wait(struct vnt_private *priv, unsigned long msecs)
 {
 	schedule_delayed_work(&priv->run_command_work, msecs_to_jiffies(msecs));
 }
@@ -99,7 +99,7 @@ static int vnt_cmd_complete(struct vnt_private *priv)
 		break;
 	}
 
-	vCommandTimerWait(priv, 0);
+	vnt_cmd_timer_wait(priv, 0);
 
 	return true;
 }
-- 
1.9.1

