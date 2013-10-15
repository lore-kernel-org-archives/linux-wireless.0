Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:54408 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933496Ab3JORcg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Oct 2013 13:32:36 -0400
Received: by mail-pa0-f50.google.com with SMTP id fb1so9278031pad.23
        for <linux-wireless@vger.kernel.org>; Tue, 15 Oct 2013 10:32:35 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 5/7] ath10k: fix NULL deref upon early FW crash
Date: Tue, 15 Oct 2013 10:29:54 -0700
Message-Id: <1381858196-17000-6-git-send-email-michal.kazior@tieto.com> (sfid-20131015_193240_125432_DFC95677)
In-Reply-To: <1381858196-17000-1-git-send-email-michal.kazior@tieto.com>
References: <1381858196-17000-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If firmware crashes during FW probing it would try
to perform FW recovery which uses mac80211
workqueue before registering to mac80211.

Using internal workqueue solves the problem.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.c | 3 ++-
 drivers/net/wireless/ath/ath10k/pci.c  | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index c5561a9..3f6cbe7 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -664,7 +664,8 @@ static void ath10k_core_restart(struct work_struct *work)
 		ieee80211_restart_hw(ar->hw);
 		break;
 	case ATH10K_STATE_OFF:
-		/* this can happen if driver is being unloaded */
+		/* this can happen if driver is being unloaded
+		 * or if the crash happens during FW probing */
 		ath10k_warn("cannot restart a device that hasn't been started\n");
 		break;
 	case ATH10K_STATE_RESTARTING:
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index f8d59c7..d09f8a2 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -777,7 +777,7 @@ static void ath10k_pci_hif_dump_area(struct ath10k *ar)
 			   reg_dump_values[i + 2],
 			   reg_dump_values[i + 3]);
 
-	ieee80211_queue_work(ar->hw, &ar->restart_work);
+	queue_work(ar->workqueue, &ar->restart_work);
 }
 
 static void ath10k_pci_hif_send_complete_check(struct ath10k *ar, u8 pipe,
-- 
1.8.4.rc3

