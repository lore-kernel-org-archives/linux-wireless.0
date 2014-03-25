Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:38541 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752548AbaCYJPm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Mar 2014 05:15:42 -0400
Subject: [PATCH 7/8] ath10k: add module parameter values to the pci info print
To: ath10k@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 25 Mar 2014 11:15:40 +0200
Message-ID: <20140325091540.16651.32712.stgit@potku.adurom.net> (sfid-20140325_101545_358891_1DB37D3F)
In-Reply-To: <20140325091311.16651.15747.stgit@potku.adurom.net>
References: <20140325091311.16651.15747.stgit@potku.adurom.net>
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
index 5842fa51f9c5..783cfa035b11 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -1952,7 +1952,9 @@ static int __ath10k_pci_hif_power_up(struct ath10k *ar, bool cold_reset)
 		irq_mode = "legacy";
 
 	if (!test_bit(ATH10K_FLAG_FIRST_BOOT_DONE, &ar->dev_flags))
-		ath10k_info("pci irq %s\n", irq_mode);
+		ath10k_info("pci irq %s irq_mode %d reset_mode %d\n",
+			    irq_mode, ath10k_pci_irq_mode,
+			    ath10k_pci_reset_mode);
 
 	return 0;
 

