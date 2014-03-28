Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh01.mail.saunalahti.fi ([62.142.5.107]:56815 "EHLO
	emh01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569AbaC1HdA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Mar 2014 03:33:00 -0400
Subject: [PATCH v2 7/8] ath10k: add module parameter values to the pci info
 print
To: ath10k@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 28 Mar 2014 09:32:58 +0200
Message-ID: <20140328073258.30438.10368.stgit@potku.adurom.net> (sfid-20140328_083304_408168_FB07F8DA)
In-Reply-To: <20140328073040.30438.17966.stgit@potku.adurom.net>
References: <20140328073040.30438.17966.stgit@potku.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hopefully this makes it easier to debug problems in the future.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/pci.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index a4e2da3251dc..dd34ac9a682f 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -1955,7 +1955,9 @@ static int __ath10k_pci_hif_power_up(struct ath10k *ar, bool cold_reset)
 		irq_mode = "legacy";
 
 	if (!test_bit(ATH10K_FLAG_FIRST_BOOT_DONE, &ar->dev_flags))
-		ath10k_info("pci irq %s\n", irq_mode);
+		ath10k_info("pci irq %s irq_mode %d reset_mode %d\n",
+			    irq_mode, ath10k_pci_irq_mode,
+			    ath10k_pci_reset_mode);
 
 	return 0;
 

