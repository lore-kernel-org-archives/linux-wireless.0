Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:1142 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965181AbbBCHPC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Feb 2015 02:15:02 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	<stable@vger.kernel.org>
Subject: [PATCH 09/19] iwlwifi: pcie: disable the SCD_BASE_ADDR when we resume from WoWLAN
Date: Tue,  3 Feb 2015 09:14:28 +0200
Message-Id: <1422947678-16917-9-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150203_081507_389850_379E3438)
In-Reply-To: <1422947482.30742.8.camel@egrumbacBox>
References: <1422947482.30742.8.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The base address of the scheduler in the device's memory
(SRAM) comes from two different sources. The periphery
register and the alive notification from the firmware.
We have a check in iwl_pcie_tx_start that ensures that
they are the same.
When we resume from WoWLAN, the firmware may have crashed
for whatever reason. In that case, the whole device may be
reset which means that the periphery register will hold a
meaningless value. When we come to compare
trans_pcie->scd_base_addr (which really holds the value we
had when we loaded the WoWLAN firmware upon suspend) and
the current value of the register, we don't see a match
unsurprisingly.
Trick the check to avoid a loud yet harmless WARN.
Note that when the WoWLAN has crashed, we will see that
in iwl_trans_pcie_d3_resume which will let the op_mode
know. Once the op_mode is informed that the WowLAN firmware
has crashed, it can't do much besides resetting the whole
device.

CC: <stable@vger.kernel.org>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/tx.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/tx.c b/drivers/net/wireless/iwlwifi/pcie/tx.c
index 0a94083..59aefa4 100644
--- a/drivers/net/wireless/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/tx.c
@@ -716,7 +716,12 @@ void iwl_trans_pcie_tx_reset(struct iwl_trans *trans)
 	iwl_write_direct32(trans, FH_KW_MEM_ADDR_REG,
 			   trans_pcie->kw.dma >> 4);
 
-	iwl_pcie_tx_start(trans, trans_pcie->scd_base_addr);
+	/*
+	 * Send 0 as the scd_base_addr since the device may have be reset
+	 * while we were in WoWLAN in which case SCD_SRAM_BASE_ADDR will
+	 * contain garbage.
+	 */
+	iwl_pcie_tx_start(trans, 0);
 }
 
 /*
-- 
1.9.1

