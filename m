Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f44.google.com ([74.125.83.44]:50722 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270AbaEIMmx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 May 2014 08:42:53 -0400
Received: by mail-ee0-f44.google.com with SMTP id c41so2591063eek.31
        for <linux-wireless@vger.kernel.org>; Fri, 09 May 2014 05:42:52 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 1/7] ath10k: move restart_work call
Date: Fri,  9 May 2014 14:35:51 +0200
Message-Id: <1399638957-20449-2-git-send-email-michal.kazior@tieto.com> (sfid-20140509_144257_338453_9E20EEB8)
In-Reply-To: <1399638957-20449-1-git-send-email-michal.kazior@tieto.com>
References: <1399638957-20449-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

That call really should not be in
ath10k_pci_hif_dump_area(). It's very misleading
to have a function name which implies just
printing stuff but actually also restarts
firmware.

Suggested-By: Kalle Valo <kvalo@qca.qualcomm.com>
Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/pci.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 66b1f30..438d3cf 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -864,8 +864,6 @@ static void ath10k_pci_hif_dump_area(struct ath10k *ar)
 			   reg_dump_values[i + 1],
 			   reg_dump_values[i + 2],
 			   reg_dump_values[i + 3]);
-
-	queue_work(ar->workqueue, &ar->restart_work);
 }
 
 static void ath10k_pci_hif_send_complete_check(struct ath10k *ar, u8 pipe,
@@ -1790,6 +1788,7 @@ static void ath10k_pci_fw_interrupt_handler(struct ath10k *ar)
 
 		if (ar_pci->started) {
 			ath10k_pci_hif_dump_area(ar);
+			queue_work(ar->workqueue, &ar->restart_work);
 		} else {
 			/*
 			 * Probable Target failure before we're prepared
-- 
1.8.5.3

