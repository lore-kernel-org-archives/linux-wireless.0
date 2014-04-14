Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f50.google.com ([74.125.83.50]:33776 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605AbaDNH2t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Apr 2014 03:28:49 -0400
Received: by mail-ee0-f50.google.com with SMTP id c13so6174531eek.37
        for <linux-wireless@vger.kernel.org>; Mon, 14 Apr 2014 00:28:48 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCHv2 3/3] ath10k: skip suspending when recovering
Date: Mon, 14 Apr 2014 09:22:26 +0200
Message-Id: <1397460146-19450-4-git-send-email-michal.kazior@tieto.com> (sfid-20140414_092856_463989_CC77EBCF)
In-Reply-To: <1397460146-19450-1-git-send-email-michal.kazior@tieto.com>
References: <1397038028-7665-1-git-send-email-michal.kazior@tieto.com>
 <1397460146-19450-1-git-send-email-michal.kazior@tieto.com>
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

