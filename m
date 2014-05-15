Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f41.google.com ([74.125.83.41]:43888 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752291AbaEOItL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 May 2014 04:49:11 -0400
Received: by mail-ee0-f41.google.com with SMTP id t10so408054eei.0
        for <linux-wireless@vger.kernel.org>; Thu, 15 May 2014 01:49:10 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2 2/5] ath10k: perform hw restart lazily
Date: Thu, 15 May 2014 10:42:01 +0200
Message-Id: <1400143324-14911-3-git-send-email-michal.kazior@tieto.com> (sfid-20140515_104930_739360_AC770F52)
In-Reply-To: <1400143324-14911-1-git-send-email-michal.kazior@tieto.com>
References: <1399637749-13489-1-git-send-email-michal.kazior@tieto.com>
 <1400143324-14911-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This reduces risk of races and prepares for more
hw restart fixes.

It also makes sense to perform teardown after
mac80211 starts its restart routine as it
guarantees it has stopped itself by then
(including tx queues).

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.c |  5 ++++-
 drivers/net/wireless/ath/ath10k/mac.c  | 34 ++++++++++++++++------------------
 2 files changed, 20 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 75b3dfb..7034c72 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -681,7 +681,8 @@ static void ath10k_core_restart(struct work_struct *work)
 	switch (ar->state) {
 	case ATH10K_STATE_ON:
 		ar->state = ATH10K_STATE_RESTARTING;
-		ath10k_halt(ar);
+		del_timer_sync(&ar->scan.timeout);
+		ath10k_reset_scan((unsigned long)ar);
 		ieee80211_restart_hw(ar->hw);
 		break;
 	case ATH10K_STATE_OFF:
@@ -690,6 +691,8 @@ static void ath10k_core_restart(struct work_struct *work)
 		ath10k_warn("cannot restart a device that hasn't been started\n");
 		break;
 	case ATH10K_STATE_RESTARTING:
+		/* hw restart might be requested from multiple places */
+		break;
 	case ATH10K_STATE_RESTARTED:
 		ar->state = ATH10K_STATE_WEDGED;
 		/* fall through */
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 854e183..b5d75b8 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -2303,6 +2303,7 @@ void ath10k_halt(struct ath10k *ar)
 	}
 
 	del_timer_sync(&ar->scan.timeout);
+	ath10k_reset_scan((unsigned long)ar);
 	ath10k_offchan_tx_purge(ar);
 	ath10k_mgmt_over_wmi_tx_purge(ar);
 	ath10k_peer_cleanup_all(ar);
@@ -2310,12 +2311,6 @@ void ath10k_halt(struct ath10k *ar)
 	ath10k_hif_power_down(ar);
 
 	spin_lock_bh(&ar->data_lock);
-	if (ar->scan.in_progress) {
-		del_timer(&ar->scan.timeout);
-		ar->scan.in_progress = false;
-		ieee80211_scan_completed(ar->hw, true);
-	}
-
 	list_for_each_entry(arvif, &ar->arvifs, list) {
 		if (!arvif->beacon)
 			continue;
@@ -2336,8 +2331,18 @@ static int ath10k_start(struct ieee80211_hw *hw)
 
 	mutex_lock(&ar->conf_mutex);
 
-	if (ar->state != ATH10K_STATE_OFF &&
-	    ar->state != ATH10K_STATE_RESTARTING) {
+	switch (ar->state) {
+	case ATH10K_STATE_OFF:
+		ar->state = ATH10K_STATE_ON;
+		break;
+	case ATH10K_STATE_RESTARTING:
+		ath10k_halt(ar);
+		ar->state = ATH10K_STATE_RESTARTED;
+		break;
+	case ATH10K_STATE_ON:
+	case ATH10K_STATE_RESTARTED:
+	case ATH10K_STATE_WEDGED:
+		WARN_ON(1);
 		ret = -EINVAL;
 		goto err;
 	}
@@ -2354,11 +2359,6 @@ static int ath10k_start(struct ieee80211_hw *hw)
 		goto err_power_down;
 	}
 
-	if (ar->state == ATH10K_STATE_OFF)
-		ar->state = ATH10K_STATE_ON;
-	else if (ar->state == ATH10K_STATE_RESTARTING)
-		ar->state = ATH10K_STATE_RESTARTED;
-
 	ret = ath10k_wmi_pdev_set_param(ar, ar->wmi.pdev_param->pmf_qos, 1);
 	if (ret) {
 		ath10k_warn("failed to enable PMF QOS: %d\n", ret);
@@ -2413,12 +2413,10 @@ static void ath10k_stop(struct ieee80211_hw *hw)
 	struct ath10k *ar = hw->priv;
 
 	mutex_lock(&ar->conf_mutex);
-	if (ar->state == ATH10K_STATE_ON ||
-	    ar->state == ATH10K_STATE_RESTARTED ||
-	    ar->state == ATH10K_STATE_WEDGED)
+	if (ar->state != ATH10K_STATE_OFF) {
 		ath10k_halt(ar);
-
-	ar->state = ATH10K_STATE_OFF;
+		ar->state = ATH10K_STATE_OFF;
+	}
 	mutex_unlock(&ar->conf_mutex);
 
 	ath10k_mgmt_over_wmi_tx_purge(ar);
-- 
1.8.5.3

