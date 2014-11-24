Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:43567 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932149AbaKXOfn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2014 09:35:43 -0500
Received: by mail-wg0-f45.google.com with SMTP id b13so12389339wgh.32
        for <linux-wireless@vger.kernel.org>; Mon, 24 Nov 2014 06:35:42 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 28/75] iwlwifi: pcie: properly reset the device
Date: Mon, 24 Nov 2014 16:34:04 +0200
Message-Id: <1416839691-28533-28-git-send-email-egrumbach@gmail.com> (sfid-20141124_154347_136499_605DA36D)
In-Reply-To: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
References: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

We were toggling the wrong bit when we reset the device,
fix that. Moreover, since the reset can take time, we need
to wait before we set the rfkill interrupt. Not doing so
can be racy since the driver is enabling the rfkill
interrupt while the device is resetting which will clear
all the registers including the CSR_INT_MASK.
This can basically lead to a situation where we don't
enable the rfkill interrupt. If that happens, the user will
not be able to re-enable the device when de-asserting
rfkill.

This scenario happened to the submitter of:
https://bugzilla.kernel.org/show_bug.cgi?id=87191

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/trans.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index ee2ec51..b81d141 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -942,7 +942,8 @@ static void iwl_trans_pcie_stop_device(struct iwl_trans *trans)
 	spin_unlock(&trans_pcie->irq_lock);
 
 	/* stop and reset the on-board processor */
-	iwl_write32(trans, CSR_RESET, CSR_RESET_REG_FLAG_NEVO_RESET);
+	iwl_write32(trans, CSR_RESET, CSR_RESET_REG_FLAG_SW_RESET);
+	udelay(20);
 
 	/* clear all status bits */
 	clear_bit(STATUS_SYNC_HCMD_ACTIVE, &trans->status);
-- 
1.9.1

