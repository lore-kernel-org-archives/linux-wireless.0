Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:43831 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757365Ab3GENPV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Jul 2013 09:15:21 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@lists.ath9k.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 10/16] ath10k: change function to take struct ath10k as arg
Date: Fri,  5 Jul 2013 16:15:11 +0300
Message-Id: <1373030117-18077-11-git-send-email-kvalo@qca.qualcomm.com> (sfid-20130705_151527_156231_26139080)
In-Reply-To: <1373030117-18077-1-git-send-email-kvalo@qca.qualcomm.com>
References: <1373030117-18077-1-git-send-email-kvalo@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michal Kazior <michal.kazior@tieto.com>

This aligns it to the argument list of other
similar functions.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/pci.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 21ef88a..0076a63 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -2057,9 +2057,9 @@ static int ath10k_pci_reset_target(struct ath10k *ar)
 	return 0;
 }
 
-static void ath10k_pci_device_reset(struct ath10k_pci *ar_pci)
+static void ath10k_pci_device_reset(struct ath10k *ar)
 {
-	struct ath10k *ar = ar_pci->ar;
+	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
 	void __iomem *mem = ar_pci->mem;
 	int i;
 	u32 val;
@@ -2254,7 +2254,7 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
 	 * is in an unexpected state. We try to catch that here in order to
 	 * reset the Target and retry the probe.
 	 */
-	ath10k_pci_device_reset(ar_pci);
+	ath10k_pci_device_reset(ar);
 
 	ret = ath10k_pci_reset_target(ar);
 	if (ret)
-- 
1.7.9.5

