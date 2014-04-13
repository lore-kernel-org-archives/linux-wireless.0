Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f173.google.com ([74.125.82.173]:50191 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755052AbaDMTUP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Apr 2014 15:20:15 -0400
Received: by mail-we0-f173.google.com with SMTP id w61so7262114wes.18
        for <linux-wireless@vger.kernel.org>; Sun, 13 Apr 2014 12:20:14 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 03/47] iwlwifi: pcie: don't leave the new NICs awake for commands
Date: Sun, 13 Apr 2014 22:19:18 +0300
Message-Id: <1397416802-32403-3-git-send-email-egrumbach@gmail.com> (sfid-20140413_212024_867915_2FA73CDD)
In-Reply-To: <534AE330.2020805@gmail.com>
References: <534AE330.2020805@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

A hardware bug had been discovered on 7260 / 3160 and 7265
and the workaround for this bug is to force the NIC to stay
awake as long as we have host commands in flight. This
workaround has been introduced for all NICs in a previous
patch:

b9439491055a ("iwlwifi: pcie: keep the NIC awake when commands are in flight")

In newer NICs, this bug is solved, so we can let the NIC go
to sleep even when we send commands. The hardware will wake
up when we increment the scheduler write pointer.
Make the workaround conditional to only use it on affected
hardware.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-7000.c   | 1 +
 drivers/net/wireless/iwlwifi/iwl-config.h | 3 +++
 drivers/net/wireless/iwlwifi/pcie/tx.c    | 9 ++++++---
 3 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-7000.c b/drivers/net/wireless/iwlwifi/iwl-7000.c
index 003a546..c42d80c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-7000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-7000.c
@@ -107,6 +107,7 @@ static const struct iwl_base_params iwl7000_base_params = {
 	.max_event_log_size = 512,
 	.shadow_reg_enable = true,
 	.pcie_l1_allowed = true,
+	.apmg_wake_up_wa = true,
 };
 
 static const struct iwl_ht_params iwl7000_ht_params = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-config.h b/drivers/net/wireless/iwlwifi/iwl-config.h
index 3f17dc3..8c16730 100644
--- a/drivers/net/wireless/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/iwlwifi/iwl-config.h
@@ -146,6 +146,8 @@ static inline u8 num_of_ant(u8 mask)
  * @wd_timeout: TX queues watchdog timeout
  * @max_event_log_size: size of event log buffer size for ucode event logging
  * @shadow_reg_enable: HW shadow register support
+ * @apmg_wake_up_wa: should the MAC access REQ be asserted when a command
+ *	is in flight. This is due to a HW bug in 7260, 3160 and 7265.
  */
 struct iwl_base_params {
 	int eeprom_size;
@@ -160,6 +162,7 @@ struct iwl_base_params {
 	u32 max_event_log_size;
 	const bool shadow_reg_enable;
 	const bool pcie_l1_allowed;
+	const bool apmg_wake_up_wa;
 };
 
 /*
diff --git a/drivers/net/wireless/iwlwifi/pcie/tx.c b/drivers/net/wireless/iwlwifi/pcie/tx.c
index 3b0c72c..0368609 100644
--- a/drivers/net/wireless/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/tx.c
@@ -1028,7 +1028,8 @@ static void iwl_pcie_cmdq_reclaim(struct iwl_trans *trans, int txq_id, int idx)
 		}
 	}
 
-	if (q->read_ptr == q->write_ptr) {
+	if (trans->cfg->base_params->apmg_wake_up_wa &&
+	    q->read_ptr == q->write_ptr) {
 		spin_lock_irqsave(&trans_pcie->reg_lock, flags);
 		WARN_ON(!trans_pcie->cmd_in_flight);
 		trans_pcie->cmd_in_flight = false;
@@ -1405,9 +1406,11 @@ static int iwl_pcie_enqueue_hcmd(struct iwl_trans *trans,
 	/*
 	 * wake up the NIC to make sure that the firmware will see the host
 	 * command - we will let the NIC sleep once all the host commands
-	 * returned.
+	 * returned. This needs to be done only on NICs that have
+	 * apmg_wake_up_wa set.
 	 */
-	if (!trans_pcie->cmd_in_flight) {
+	if (trans->cfg->base_params->apmg_wake_up_wa &&
+	    !trans_pcie->cmd_in_flight) {
 		trans_pcie->cmd_in_flight = true;
 		__iwl_trans_pcie_set_bit(trans, CSR_GP_CNTRL,
 					 CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
-- 
1.8.3.2

