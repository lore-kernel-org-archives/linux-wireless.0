Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:43514 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753562AbeDJOuh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 10 Apr 2018 10:50:37 -0400
From: Eyal Ilsar <edilsar@gmail.com>
To: aditya.shankar@microchip.com, ganesh.krishna@microchip.com,
        gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: wilc1000: Remove unnecessary braces {} around single statement block
Date: Wed, 11 Apr 2018 00:49:55 +1000
Message-Id: <1523371795-5090-1-git-send-email-edilsar@gmail.com> (sfid-20180410_165132_696509_BE5FFAE3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove unnecessary braces {} around an 'if' statement block with a single 
statement. Issue found by checkpatch.
Signed-off-by: Eyal Ilsar<edilsar@gmail.com>
---
This is part of my take on the Eudyptula challenge

 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 205304c..325afe1 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -284,9 +284,8 @@ static void remove_network_from_shadow(struct timer_list *unused)
 		}
 	}
 
-	if (last_scanned_cnt != 0) {
+	if (last_scanned_cnt != 0)
 		mod_timer(&hAgingTimer, jiffies + msecs_to_jiffies(AGING_TIME));
-	}
 }
 
 static void clear_duringIP(struct timer_list *unused)
-- 
2.7.4
