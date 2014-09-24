Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh01.mail.saunalahti.fi ([62.142.5.107]:44695 "EHLO
	emh01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035AbaIXLQt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Sep 2014 07:16:49 -0400
Subject: [PATCH v3 1/3] ath10k: don't enable interrupts for the diagnostic
 window
To: ath10k@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 24 Sep 2014 14:16:46 +0300
Message-ID: <20140924111646.6539.44330.stgit@potku.adurom.net> (sfid-20140924_131654_970167_AB0AA76F)
In-Reply-To: <20140924111416.6539.95299.stgit@potku.adurom.net>
References: <20140924111416.6539.95299.stgit@potku.adurom.net>
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
 drivers/net/wireless/ath/ath10k/ce.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/ce.c b/drivers/net/wireless/ath/ath10k/ce.c
index 101cadb6e4ba..09ef03e7af89 100644
--- a/drivers/net/wireless/ath/ath10k/ce.c
+++ b/drivers/net/wireless/ath/ath10k/ce.c
@@ -817,7 +817,10 @@ void ath10k_ce_enable_interrupts(struct ath10k *ar)
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
 	int ce_id;
 
-	for (ce_id = 0; ce_id < CE_COUNT; ce_id++)
+	/* Skip the last copy engine, CE7 the diagnostic window, as that
+	 * uses polling and isn't initialized for interrupts.
+	 */
+	for (ce_id = 0; ce_id < CE_COUNT - 1; ce_id++)
 		ath10k_ce_per_engine_handler_adjust(&ar_pci->ce_states[ce_id]);
 }
 

