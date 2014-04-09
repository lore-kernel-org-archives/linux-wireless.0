Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f48.google.com ([74.125.83.48]:44847 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758243AbaDIKNY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Apr 2014 06:13:24 -0400
Received: by mail-ee0-f48.google.com with SMTP id b57so1664999eek.35
        for <linux-wireless@vger.kernel.org>; Wed, 09 Apr 2014 03:13:23 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 3/3] ath10k: skip suspending when recovering
Date: Wed,  9 Apr 2014 12:07:08 +0200
Message-Id: <1397038028-7665-4-git-send-email-michal.kazior@tieto.com> (sfid-20140409_121329_528982_D8C65A05)
In-Reply-To: <1397038028-7665-1-git-send-email-michal.kazior@tieto.com>
References: <1397038028-7665-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It doesn't make much sense to even try suspending
the device when recovering. Recovering means the
device is unresponsive and waiting for suspend
procedure means taking a 3 second timeout waiting
for tx credits.

This speeds up firmware recovery significantly.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 6abde37..75b3dfb 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -680,8 +680,8 @@ static void ath10k_core_restart(struct work_struct *work)
 
 	switch (ar->state) {
 	case ATH10K_STATE_ON:
-		ath10k_halt(ar);
 		ar->state = ATH10K_STATE_RESTARTING;
+		ath10k_halt(ar);
 		ieee80211_restart_hw(ar->hw);
 		break;
 	case ATH10K_STATE_OFF:
@@ -908,7 +908,9 @@ void ath10k_core_stop(struct ath10k *ar)
 	lockdep_assert_held(&ar->conf_mutex);
 
 	/* try to suspend target */
-	ath10k_wait_for_suspend(ar, WMI_PDEV_SUSPEND_AND_DISABLE_INTR);
+	if (ar->state != ATH10K_STATE_RESTARTING)
+		ath10k_wait_for_suspend(ar, WMI_PDEV_SUSPEND_AND_DISABLE_INTR);
+
 	ath10k_debug_stop(ar);
 	ath10k_htc_stop(&ar->htc);
 	ath10k_htt_detach(&ar->htt);
-- 
1.8.5.3

