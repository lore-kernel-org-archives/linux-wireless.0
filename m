Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f54.google.com ([74.125.83.54]:34511 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754666Ab3LaRQY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Dec 2013 12:16:24 -0500
Received: by mail-ee0-f54.google.com with SMTP id e51so4777762eek.41
        for <linux-wireless@vger.kernel.org>; Tue, 31 Dec 2013 09:16:23 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 15/28] iwlwifi: pcie: don't update the op_mode if rfkill hasn't changed
Date: Tue, 31 Dec 2013 19:15:44 +0200
Message-Id: <1388510157-23345-15-git-send-email-egrumbach@gmail.com> (sfid-20131231_183435_625913_75F3784A)
In-Reply-To: <52C2FB68.2010708@gmail.com>
References: <52C2FB68.2010708@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This is useless and introduces a dependency between rfkill
and stop_device - the op_mode can't call stop_device from
the rfkill notification since it would lead to an endless
recursion.
Next patches will need to do so.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/trans.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index d9ccb4e..bc584ef 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -607,7 +607,9 @@ static void iwl_trans_pcie_fw_alive(struct iwl_trans *trans, u32 scd_addr)
 static void iwl_trans_pcie_stop_device(struct iwl_trans *trans)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-	bool hw_rfkill;
+	bool hw_rfkill, was_hw_rfkill;
+
+	was_hw_rfkill = iwl_is_rfkill_set(trans);
 
 	/* tell the device to stop sending interrupts */
 	spin_lock(&trans_pcie->irq_lock);
@@ -669,13 +671,20 @@ static void iwl_trans_pcie_stop_device(struct iwl_trans *trans)
 	 * all the interrupts were disabled, in this case we couldn't
 	 * receive the RF kill interrupt and update the state in the
 	 * op_mode.
+	 * Don't call the op_mode if the rkfill state hasn't changed.
+	 * This allows the op_mode to call stop_device from the rfkill
+	 * notification without endless recursion. Under very rare
+	 * circumstances, we might have a small recursion if the rfkill
+	 * state changed exactly now while we were called from stop_device.
+	 * This is very unlikely but can happen and is supported.
 	 */
 	hw_rfkill = iwl_is_rfkill_set(trans);
 	if (hw_rfkill)
 		set_bit(STATUS_RFKILL, &trans->status);
 	else
 		clear_bit(STATUS_RFKILL, &trans->status);
-	iwl_op_mode_hw_rf_kill(trans->op_mode, hw_rfkill);
+	if (hw_rfkill != was_hw_rfkill)
+		iwl_op_mode_hw_rf_kill(trans->op_mode, hw_rfkill);
 }
 
 static void iwl_trans_pcie_d3_suspend(struct iwl_trans *trans, bool test)
-- 
1.7.9.5

