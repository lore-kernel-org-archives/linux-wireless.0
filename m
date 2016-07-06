Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:33488 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753777AbcGFKo5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jul 2016 06:44:57 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	"[4.5+]" <stable@vger.kernel.org>,
	Luca Coelho <luciano.coelho@intel.com>
Date: Wed,  6 Jul 2016 13:40:23 +0300
Message-Id: <1467801651-1816-28-git-send-email-luca@coelho.fi> (sfid-20160706_124500_726625_C96D67C0)
In-Reply-To: <1467801452.25088.20.camel@coelho.fi>
References: <1467801452.25088.20.camel@coelho.fi>
Subject: [PATCH 28/56] iwlwifi: pcie: enable interrupts before releasing the NIC's CPU
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

The NIC's CPU gets started after the firmware has been
written to its memory. The first thing it does is to
send an interrupt to let the driver know that it is
running. In order to get that interrupt, the driver needs
to make sure it is not masked. Of course, the interrupt
needs to be enabled in the driver before the CPU starts to
run.
I mistakenly inversed those two steps leading to races
which prevented the driver from getting the alive interrupt
from the firmware.
Fix that.

Cc: <stable@vger.kernel.org> [4.5+]
Fixes: a6bd005fe92 ("iwlwifi: pcie: fix RF-Kill vs. firmware load race")
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index 3badebb..ac623c3 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -801,6 +801,8 @@ static int iwl_pcie_load_cpu_sections_8000(struct iwl_trans *trans,
 
 	*first_ucode_section = last_read_idx;
 
+	iwl_enable_interrupts(trans);
+
 	if (cpu == 1)
 		iwl_write_direct32(trans, FH_UCODE_LOAD_STATUS, 0xFFFF);
 	else
@@ -980,6 +982,8 @@ static int iwl_pcie_load_given_ucode(struct iwl_trans *trans,
 		iwl_pcie_apply_destination(trans);
 	}
 
+	iwl_enable_interrupts(trans);
+
 	/* release CPU reset */
 	iwl_write32(trans, CSR_RESET, 0);
 
@@ -1215,7 +1219,6 @@ static int iwl_trans_pcie_start_fw(struct iwl_trans *trans,
 		ret = iwl_pcie_load_given_ucode_8000(trans, fw);
 	else
 		ret = iwl_pcie_load_given_ucode(trans, fw);
-	iwl_enable_interrupts(trans);
 
 	/* re-check RF-Kill state since we may have missed the interrupt */
 	hw_rfkill = iwl_is_rfkill_set(trans);
-- 
2.8.1

