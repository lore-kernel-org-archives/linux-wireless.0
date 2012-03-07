Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:51937 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932729Ab2CGTGl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Mar 2012 14:06:41 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	stable@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH RESEND 35/35] iwlwifi: always monitor for stuck queues
Date: Wed,  7 Mar 2012 09:52:44 -0800
Message-Id: <1331142764-5750-36-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120307_200701_850610_B47FA4B8)
In-Reply-To: <1331142764-5750-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1331142764-5750-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

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

It happens more with P2P because there we can
go between associated/unassociated frequently.

Cc: stable@vger.kernel.org
Reported-by: Ben Cahill <ben.m.cahill@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c |   19 ++++---------------
 1 files changed, 4 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index b94e23c..8b85940 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1343,21 +1343,10 @@ void iwl_bg_watchdog(unsigned long data)
 	if (timeout == 0)
 		return;
 
-	/* monitor and check for stuck cmd queue */
-	if (iwl_check_stuck_queue(priv, priv->shrd->cmd_queue))
-		return;
-
-	/* monitor and check for other stuck queues */
-	if (iwl_is_any_associated(priv)) {
-		for (cnt = 0; cnt < cfg(priv)->base_params->num_of_queues;
-		     cnt++) {
-			/* skip as we already checked the command queue */
-			if (cnt == priv->shrd->cmd_queue)
-				continue;
-			if (iwl_check_stuck_queue(priv, cnt))
-				return;
-		}
-	}
+	/* monitor and check for stuck queues */
+	for (cnt = 0; cnt < cfg(priv)->base_params->num_of_queues; cnt++)
+		if (iwl_check_stuck_queue(priv, cnt))
+			return;
 
 	mod_timer(&priv->watchdog, jiffies +
 		  msecs_to_jiffies(IWL_WD_TICK(timeout)));
-- 
1.7.0.4

