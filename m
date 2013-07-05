Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:52917 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756495Ab3GENPU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Jul 2013 09:15:20 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@lists.ath9k.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 01/16] ath10k: fix teardown ordering
Date: Fri,  5 Jul 2013 16:15:02 +0300
Message-Id: <1373030117-18077-2-git-send-email-kvalo@qca.qualcomm.com> (sfid-20130705_151525_860640_F109B4B0)
In-Reply-To: <1373030117-18077-1-git-send-email-kvalo@qca.qualcomm.com>
References: <1373030117-18077-1-git-send-email-kvalo@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michal Kazior <michal.kazior@tieto.com>

This should fix memory corruption if HIF is tried
to be restarted.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/pci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 8e4e832..1bd381f 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -1263,7 +1263,6 @@ static void ath10k_pci_hif_stop(struct ath10k *ar)
 	ath10k_pci_process_ce(ar);
 	ath10k_pci_cleanup_ce(ar);
 	ath10k_pci_buffer_cleanup(ar);
-	ath10k_pci_ce_deinit(ar);
 }
 
 static int ath10k_pci_hif_exchange_bmi_msg(struct ath10k *ar,
@@ -2332,6 +2331,7 @@ static void ath10k_pci_remove(struct pci_dev *pdev)
 	tasklet_kill(&ar_pci->msi_fw_err);
 
 	ath10k_core_unregister(ar);
+	ath10k_pci_ce_deinit(ar);
 	ath10k_pci_stop_intr(ar);
 
 	pci_set_drvdata(pdev, NULL);
-- 
1.7.9.5

