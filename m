Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:58074 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757029Ab3GZITf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Jul 2013 04:19:35 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 7/7] iwlwifi: pcie: clear RFKILL interrupt in AMPG
Date: Fri, 26 Jul 2013 10:19:28 +0200
Message-Id: <1374826768-2440-7-git-send-email-johannes@sipsolutions.net> (sfid-20130726_101950_206396_94C3F4B2)
In-Reply-To: <1374826768-2440-1-git-send-email-johannes@sipsolutions.net>
References: <1374826675.8248.11.camel@jlt4.sipsolutions.net>
 <1374826768-2440-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

If we forget to do so, we can't send HCMD to firmware while
the NIC is in RFKILL state.

Cc: stable@vger.kernel.org
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-prph.h | 2 ++
 drivers/net/wireless/iwlwifi/pcie/rx.c  | 8 ++++++++
 2 files changed, 10 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/iwl-prph.h b/drivers/net/wireless/iwlwifi/iwl-prph.h
index ff8cc75..a70c7b9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-prph.h
+++ b/drivers/net/wireless/iwlwifi/iwl-prph.h
@@ -97,6 +97,8 @@
 
 #define APMG_PCIDEV_STT_VAL_L1_ACT_DIS		(0x00000800)
 
+#define APMG_RTC_INT_STT_RFKILL		(0x10000000)
+
 /* Device system time */
 #define DEVICE_SYSTEM_TIME_REG 0xA0206C
 
diff --git a/drivers/net/wireless/iwlwifi/pcie/rx.c b/drivers/net/wireless/iwlwifi/pcie/rx.c
index fd848cd..f600e68 100644
--- a/drivers/net/wireless/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/rx.c
@@ -888,6 +888,14 @@ irqreturn_t iwl_pcie_irq_handler(int irq, void *dev_id)
 
 		iwl_op_mode_hw_rf_kill(trans->op_mode, hw_rfkill);
 		if (hw_rfkill) {
+			/*
+			 * Clear the interrupt in APMG if the NIC is going down.
+			 * Note that when the NIC exits RFkill (else branch), we
+			 * can't access prph and the NIC will be reset in
+			 * start_hw anyway.
+			 */
+			iwl_write_prph(trans, APMG_RTC_INT_STT_REG,
+				       APMG_RTC_INT_STT_RFKILL);
 			set_bit(STATUS_RFKILL, &trans_pcie->status);
 			if (test_and_clear_bit(STATUS_HCMD_ACTIVE,
 					       &trans_pcie->status))
-- 
1.8.0

