Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:42563 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934197Ab3JPNqH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Oct 2013 09:46:07 -0400
Subject: [PATCH v2 5/8] ath10k: fix NULL deref upon early FW crash
To: ath10k@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 16 Oct 2013 16:46:05 +0300
Message-ID: <20131016134605.25095.65863.stgit@localhost6.localdomain6> (sfid-20131016_154610_861782_189B0587)
In-Reply-To: <20131016134503.25095.8044.stgit@localhost6.localdomain6>
References: <20131016134503.25095.8044.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michal Kazior <michal.kazior@tieto.com>

If firmware crashes during FW probing it would try
to perform FW recovery which uses mac80211
workqueue before registering to mac80211.

Using internal workqueue solves the problem.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.c |    3 ++-
 drivers/net/wireless/ath/ath10k/pci.c  |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 1129994..2a360ca 100644
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

