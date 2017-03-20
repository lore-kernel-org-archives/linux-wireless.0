Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:47691 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751586AbdCTPV0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 20 Mar 2017 11:21:26 -0400
From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <mohammed@codeaurora.org>, <linux-wireless@vger.kernel.org>,
        "Mohammed Shafi Shajakhan" <mohammed@qti.qualcomm.com>
Subject: [PATCH] ath10k: Fix NAPI enable/disable symmetry for AHB interface
Date: Mon, 20 Mar 2017 20:52:46 +0530
Message-ID: <1490023366-8176-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20170320_162349_278655_D9271AB7)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>

Move NAPI enable to 'ath10k_ahb_hif_start' from
'ath10k_ahb_hif_power_up'. This is to maintain the symmetry
of calling napi_enable() from ath10k_ahb_hif_start() so that it
matches with  napi_disable() being called from ath10k_pci_hif_stop().

This change is based on the crash fix from Kalle for PCI interface in
commit 1427228d5869 ("ath10k: fix napi crash during rmmod when probe
firmware fails").

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/ahb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/ahb.c b/drivers/net/wireless/ath/ath10k/ahb.c
index 45226db..da770af 100644
--- a/drivers/net/wireless/ath/ath10k/ahb.c
+++ b/drivers/net/wireless/ath/ath10k/ahb.c
@@ -640,6 +640,7 @@ static int ath10k_ahb_hif_start(struct ath10k *ar)
 {
 	ath10k_dbg(ar, ATH10K_DBG_BOOT, "boot ahb hif start\n");
 
+	napi_enable(&ar->napi);
 	ath10k_ce_enable_interrupts(ar);
 	ath10k_pci_enable_legacy_irq(ar);
 
@@ -692,7 +693,6 @@ static int ath10k_ahb_hif_power_up(struct ath10k *ar)
 		ath10k_err(ar, "could not wake up target CPU: %d\n", ret);
 		goto err_ce_deinit;
 	}
-	napi_enable(&ar->napi);
 
 	return 0;
 
-- 
1.9.1
