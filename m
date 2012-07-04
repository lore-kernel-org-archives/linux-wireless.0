Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26855 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752606Ab2GDLUl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jul 2012 07:20:41 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 3.5] iwlegacy: always monitor for stuck queues
Date: Wed,  4 Jul 2012 13:20:20 +0200
Message-Id: <1341400820-2957-1-git-send-email-sgruszka@redhat.com> (sfid-20120704_132044_733234_A5692E7C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is iwlegacy version of:

commit 342bbf3fee2fa9a18147e74b2e3c4229a4564912
Author: Johannes Berg <johannes.berg@intel.com>
Date:   Sun Mar 4 08:50:46 2012 -0800

    iwlwifi: always monitor for stuck queues

    If we only monitor while associated, the following
    can happen:
     - we're associated, and the queue stuck check
       runs, setting the queue "touch" time to X
     - we disassociate, stopping the monitoring,
       which leaves the time set to X
     - almost 2s later, we associate, and enqueue
       a frame
     - before the frame is transmitted, we monitor
       for stuck queues, and find the time set to
       X, although it is now later than X + 2000ms,
       so we decide that the queue is stuck and
       erroneously restart the device

Cc: stable@vger.kernel.org
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/common.c |   14 ++++++--------
 1 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/common.c b/drivers/net/wireless/iwlegacy/common.c
index cbf2dc1..5d4807c 100644
--- a/drivers/net/wireless/iwlegacy/common.c
+++ b/drivers/net/wireless/iwlegacy/common.c
@@ -4767,14 +4767,12 @@ il_bg_watchdog(unsigned long data)
 		return;
 
 	/* monitor and check for other stuck queues */
-	if (il_is_any_associated(il)) {
-		for (cnt = 0; cnt < il->hw_params.max_txq_num; cnt++) {
-			/* skip as we already checked the command queue */
-			if (cnt == il->cmd_queue)
-				continue;
-			if (il_check_stuck_queue(il, cnt))
-				return;
-		}
+	for (cnt = 0; cnt < il->hw_params.max_txq_num; cnt++) {
+		/* skip as we already checked the command queue */
+		if (cnt == il->cmd_queue)
+			continue;
+		if (il_check_stuck_queue(il, cnt))
+			return;
 	}
 
 	mod_timer(&il->watchdog,
-- 
1.7.1

