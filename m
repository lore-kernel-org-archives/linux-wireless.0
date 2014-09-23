Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh01.mail.saunalahti.fi ([62.142.5.107]:56295 "EHLO
	emh01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751785AbaIWOcX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Sep 2014 10:32:23 -0400
Subject: [PATCH v2 1/3] ath10k: don't enable interrupts for the diagnostic
 window
To: ath10k@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 23 Sep 2014 17:32:19 +0300
Message-ID: <20140923143219.23585.34114.stgit@potku.adurom.net> (sfid-20140923_163230_325708_090B855A)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The diagnostic window (CE7) uses polling and is not initiliased to retrieve
interrupts so disable interrupts altogether for CE7. Otherwise ath10k crashes
when using the diagnostic window while the firmware is running due to NULL
dereference and polling reads timeout.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/ce.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/ce.c b/drivers/net/wireless/ath/ath10k/ce.c
index 101cadb6e4ba..03b3a2c441fe 100644
--- a/drivers/net/wireless/ath/ath10k/ce.c
+++ b/drivers/net/wireless/ath/ath10k/ce.c
@@ -817,7 +817,9 @@ void ath10k_ce_enable_interrupts(struct ath10k *ar)
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
 	int ce_id;
 
-	for (ce_id = 0; ce_id < CE_COUNT; ce_id++)
+	/* Skip the last copy engine, CE7 the diagnostic window, as that
+	 * uses polling and isn't initialized for interrupts. */
+	for (ce_id = 0; ce_id < CE_COUNT - 1; ce_id++)
 		ath10k_ce_per_engine_handler_adjust(&ar_pci->ce_states[ce_id]);
 }
 

