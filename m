Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:36647 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753145AbaHEVmT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Aug 2014 17:42:19 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: ath10k@lists.infradead.org, Ben Greear <greearb@candelatech.com>
Subject: [PATCH] ath10k: logging for state change transitions.
Date: Tue,  5 Aug 2014 14:42:14 -0700
Message-Id: <1407274934-5048-1-git-send-email-greearb@candelatech.com> (sfid-20140805_234222_162993_6FDFBB68)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Print error if device failed to recover.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index b2e7303..ced5eca 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -3905,8 +3905,10 @@ static void ath10k_restart_complete(struct ieee80211_hw *hw)
 	/* If device failed to restart it will be in a different state, e.g.
 	 * ATH10K_STATE_WEDGED */
 	if (ar->state == ATH10K_STATE_RESTARTED) {
-		ath10k_info("device successfully recovered\n");
+		ath10k_info("device successfully recovered (state RESTARTED to ON)\n");
 		ar->state = ATH10K_STATE_ON;
+	} else {
+		ath10k_info("device failed to recover (state %d)\n", ar->state);
 	}
 
 	mutex_unlock(&ar->conf_mutex);
-- 
1.7.11.7

