Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:36031 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163AbaLRILW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2014 03:11:22 -0500
Received: by mail-wi0-f181.google.com with SMTP id r20so867647wiv.8
        for <linux-wireless@vger.kernel.org>; Thu, 18 Dec 2014 00:11:21 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 2/5] iwlwifi: pcie: re-ACK all interrupts after device reset
Date: Thu, 18 Dec 2014 10:09:58 +0200
Message-Id: <1418890201-15177-2-git-send-email-egrumbach@gmail.com> (sfid-20141218_091126_706245_2F67AE9B)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB31B5CD8C0@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB31B5CD8C0@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

When we reset the device, the CSR_INT gets cleared as well
as CSR_INT_MASK. Meaning that we shouldn't get any interrupt
but, due to a hardware bug, recent devices will keep sending
interrupts. This leads to an interrupt storm while stopping
the device.
The way to fix this is to ACK all the interrupts after the
device is reset so that the value of CSR_INT will stay
0xffffffff.

Fixes: 522713c81e4e ("iwlwifi: pcie: properly reset the device")
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/trans.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index 5d79a1f..d151af3 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -1012,16 +1012,21 @@ static void iwl_trans_pcie_stop_device(struct iwl_trans *trans)
 	/* Stop the device, and put it in low power state */
 	iwl_pcie_apm_stop(trans);
 
-	/* Upon stop, the APM issues an interrupt if HW RF kill is set.
-	 * Clean again the interrupt here
+	/* stop and reset the on-board processor */
+	iwl_write32(trans, CSR_RESET, CSR_RESET_REG_FLAG_SW_RESET);
+	udelay(20);
+
+	/*
+	 * Upon stop, the APM issues an interrupt if HW RF kill is set.
+	 * This is a bug in certain verions of the hardware.
+	 * Certain devices also keep sending HW RF kill interrupt all
+	 * the time, unless the interrupt is ACKed even if the interrupt
+	 * should be masked. Re-ACK all the interrupts here.
 	 */
 	spin_lock(&trans_pcie->irq_lock);
 	iwl_disable_interrupts(trans);
 	spin_unlock(&trans_pcie->irq_lock);
 
-	/* stop and reset the on-board processor */
-	iwl_write32(trans, CSR_RESET, CSR_RESET_REG_FLAG_SW_RESET);
-	udelay(20);
 
 	/* clear all status bits */
 	clear_bit(STATUS_SYNC_HCMD_ACTIVE, &trans->status);
-- 
1.9.1

