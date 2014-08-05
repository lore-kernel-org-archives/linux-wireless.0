Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:36265 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640AbaHEUzC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Aug 2014 16:55:02 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: ath10k@lists.infradead.org, Ben Greear <greearb@candelatech.com>
Subject: [PATCH] ath10k: extra logging for core-restart state change logic.
Date: Tue,  5 Aug 2014 13:54:59 -0700
Message-Id: <1407272099-6271-1-git-send-email-greearb@candelatech.com> (sfid-20140805_225506_028247_438F4243)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/ath/ath10k/core.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 030bef1..d522d3a 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -700,6 +700,7 @@ static void ath10k_core_restart(struct work_struct *work)
 	switch (ar->state) {
 	case ATH10K_STATE_ON:
 		ar->state = ATH10K_STATE_RESTARTING;
+		ath10k_warn("core-restart, going to state RESTARTING from ON\n");
 		del_timer_sync(&ar->scan.timeout);
 		ath10k_reset_scan((unsigned long)ar);
 		ieee80211_restart_hw(ar->hw);
@@ -713,10 +714,11 @@ static void ath10k_core_restart(struct work_struct *work)
 		/* hw restart might be requested from multiple places */
 		break;
 	case ATH10K_STATE_RESTARTED:
-		ar->state = ATH10K_STATE_WEDGED;
 		/* fall through */
 	case ATH10K_STATE_WEDGED:
-		ath10k_warn("device is wedged, will not restart\n");
+		ath10k_warn("device is wedged, will not restart (state %d)\n",
+			ar->state);
+		ar->state = ATH10K_STATE_WEDGED;
 		break;
 	}
 
-- 
1.7.11.7

