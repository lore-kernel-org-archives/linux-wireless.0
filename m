Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:33358 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751243AbcGFKoL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jul 2016 06:44:11 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Luca Coelho <luciano.coelho@intel.com>
Date: Wed,  6 Jul 2016 13:40:10 +0300
Message-Id: <1467801651-1816-15-git-send-email-luca@coelho.fi> (sfid-20160706_124418_810499_E0554FA0)
In-Reply-To: <1467801452.25088.20.camel@coelho.fi>
References: <1467801452.25088.20.camel@coelho.fi>
Subject: [PATCH 15/56] iwlwifi: mvm: remove unnecessary device conversion when reading the MCC
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

We convert the mvm device to a PCI device and then back again when
trying to find the handle for the device's ACPI data.  This is
unnecessary, so it can be removed.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/nvm.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c b/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c
index 25a9840..182ec20 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c
@@ -66,7 +66,6 @@
  *****************************************************************************/
 #include <linux/firmware.h>
 #include <linux/rtnetlink.h>
-#include <linux/pci.h>
 #include <linux/acpi.h>
 #include "iwl-trans.h"
 #include "iwl-csr.h"
@@ -802,9 +801,8 @@ static int iwl_mvm_get_bios_mcc(struct iwl_mvm *mvm, char *mcc)
 	struct acpi_buffer wrdd = {ACPI_ALLOCATE_BUFFER, NULL};
 	acpi_status status;
 	u32 mcc_val;
-	struct pci_dev *pdev = to_pci_dev(mvm->dev);
 
-	root_handle = ACPI_HANDLE(&pdev->dev);
+	root_handle = ACPI_HANDLE(mvm->dev);
 	if (!root_handle) {
 		IWL_DEBUG_LAR(mvm,
 			      "Could not retrieve root port ACPI handle\n");
-- 
2.8.1

