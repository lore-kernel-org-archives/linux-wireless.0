Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:52711 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752776AbbLJJow (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Dec 2015 04:44:52 -0500
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH 1/2] ath10k: wake up device before accessing registers
Date: Thu, 10 Dec 2015 15:14:26 +0530
Message-ID: <1449740667-25901-1-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20151210_104503_160006_79853215)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

commit 1aaf8efba0ae ("ath10k: disable PCI PS for QCA988X
and QCA99X0") partially reverts pci soc powersave support added by
commit 77258d409ce4 ("ath10k: enable pci soc powersaving"). While
reverting the change, pci wake up function is called after accessing
pci registers instead of prior to access. The assumption is that chip
is woken up before accessing its registers.Though this change does not
fix any known issues, this might help to avoid unknown or low power
platform specific issues.

Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/pci.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 202c775..473a141 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -3071,9 +3071,6 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
 		goto err_sleep;
 	}
 
-	ath10k_pci_ce_deinit(ar);
-	ath10k_pci_irq_disable(ar);
-
 	if (ar_pci->pci_ps == 0) {
 		ret = ath10k_pci_force_wake(ar);
 		if (ret) {
@@ -3082,6 +3079,9 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
 		}
 	}
 
+	ath10k_pci_ce_deinit(ar);
+	ath10k_pci_irq_disable(ar);
+
 	ret = ath10k_pci_init_irq(ar);
 	if (ret) {
 		ath10k_err(ar, "failed to init irqs: %d\n", ret);
-- 
2.6.3

