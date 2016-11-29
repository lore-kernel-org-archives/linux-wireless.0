Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:18254 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757698AbcK2OqK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 Nov 2016 09:46:10 -0500
From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <mohammed@codeaurora.org>, <linux-wireless@vger.kernel.org>,
        "Mohammed Shafi Shajakhan" <mohammed@qti.qualcomm.com>
Subject: ath10k: Fix soft lockup during firmware crash/hw-restart
Date: Tue, 29 Nov 2016 20:16:02 +0530
Message-ID: <1480430762-15995-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20161129_154615_016002_679452E5)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>

During firmware crash (or) user requested manual restart
the system gets into a soft lock up state because of the
below root cause.

During user requested hardware restart / firmware crash
the system goes into a soft lockup state as 'napi_synchronize'
is called after 'napi_disable' (which sets 'NAPI_STATE_SCHED'
bit) and it sleeps into infinite loop as it waits for
'NAPI_STATE_SCHED' to be cleared. This condition is hit because
'ath10k_hif_stop' is called twice as below (resulting in calling
'napi_synchronize' after 'napi_disable')

'ath10k_core_restart' -> 'ath10k_hif_stop' (ATH10K_STATE_ON) ->
-> 'ieee80211_restart_hw' -> 'ath10k_start' -> 'ath10k_halt' ->
'ath10k_core_stop' -> 'ath10k_hif_stop' (ATH10K_STATE_RESTARTING)

Fix this by calling 'ath10k_halt' in ath10k_core_restart itself
as it makes more sense before informing mac80211 to restart h/w
Also remove 'ath10k_halt' in ath10k_start for the state of 'restarting'

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
---
[thanks to Kalle and Michal for their inputs]

 drivers/net/wireless/ath/ath10k/core.c | 2 +-
 drivers/net/wireless/ath/ath10k/mac.c  | 1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 7005e2a..5bc6847 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -1536,7 +1536,7 @@ static void ath10k_core_restart(struct work_struct *work)
 	switch (ar->state) {
 	case ATH10K_STATE_ON:
 		ar->state = ATH10K_STATE_RESTARTING;
-		ath10k_hif_stop(ar);
+		ath10k_halt(ar);
 		ath10k_scan_finish(ar);
 		ieee80211_restart_hw(ar->hw);
 		break;
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 717b2fa..481842b 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -4449,7 +4449,6 @@ static int ath10k_start(struct ieee80211_hw *hw)
 		ar->state = ATH10K_STATE_ON;
 		break;
 	case ATH10K_STATE_RESTARTING:
-		ath10k_halt(ar);
 		ar->state = ATH10K_STATE_RESTARTED;
 		break;
 	case ATH10K_STATE_ON:
-- 
1.9.1
