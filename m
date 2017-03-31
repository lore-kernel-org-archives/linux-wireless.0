Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:40421 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754417AbdCaLzk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 31 Mar 2017 07:55:40 -0400
From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <mohammed@codeaurora.org>, <linux-wireless@vger.kernel.org>,
        "Mohammed Shafi Shajakhan" <mohammed@qti.qualcomm.com>
Subject: [PATCH] ath10k: cancel coverage class work during stop and restart
Date: Fri, 31 Mar 2017 17:28:41 +0530
Message-ID: <1490961521-32746-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20170331_135543_015442_53A7670D)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>

It seems set_coverage_class_work is not cancelled anywhere,
though I could not find a crash/warning  with this existing
design, its safer to cancel it during stop() and also before
restarting the hardware.

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
---
[comments updated, thanks Kalle]

 drivers/net/wireless/ath/ath10k/core.c | 7 +++++++
 drivers/net/wireless/ath/ath10k/mac.c  | 1 +
 2 files changed, 8 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index ba8768d..e653717 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -1610,6 +1610,13 @@ static void ath10k_core_restart(struct work_struct *work)
 	wake_up(&ar->wmi.tx_credits_wq);
 	wake_up(&ar->peer_mapping_wq);
 
+	/* TODO: We can have one instance of cancelling coverage_class_work by
+	 * moving it to ath10k_halt(), so that both stop() and restart() would
+	 * call that but it takes conf_mutex() and if we call cancel_work_sync()
+	 * with conf_mutex it will deadlock.
+	 */
+	cancel_work_sync(&ar->set_coverage_class_work);
+
 	mutex_lock(&ar->conf_mutex);
 
 	switch (ar->state) {
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 3029f25..6470ed3 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -4684,6 +4684,7 @@ static void ath10k_stop(struct ieee80211_hw *hw)
 	}
 	mutex_unlock(&ar->conf_mutex);
 
+	cancel_work_sync(&ar->set_coverage_class_work);
 	cancel_delayed_work_sync(&ar->scan.timeout);
 	cancel_work_sync(&ar->restart_work);
 }
-- 
1.9.1
