Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f179.google.com ([74.125.82.179]:59334 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914AbaGFJgc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Jul 2014 05:36:32 -0400
Received: by mail-we0-f179.google.com with SMTP id w62so3125632wes.24
        for <linux-wireless@vger.kernel.org>; Sun, 06 Jul 2014 02:36:31 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eran Harary <eran.harary@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 07/40] iwlwifi: mvm: read the mac address in family 8000
Date: Sun,  6 Jul 2014 12:35:43 +0300
Message-Id: <1404639376-3792-7-git-send-email-egrumbach@gmail.com> (sfid-20140706_113638_362157_C0DC8E11)
In-Reply-To: <53B917DC.5050902@gmail.com>
References: <53B917DC.5050902@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eran Harary <eran.harary@intel.com>

In family 8000 products the MAC address in the OTP could be in either:
- WFPM address
- PCIE address
In sdio product we should read it from the WFPM, in pcie product we
should read it from the PCIe location.
This is relevant only from otp version 0xE08 and above.
While at it, fix the bytes order in version 0xE08.

Signed-off-by: Eran Harary <eran.harary@intel.com>
Reviewed-by: Liad Kaufman <liad.kaufman@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-nvm-parse.c | 60 ++++++++++++++++++++++------
 1 file changed, 48 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
index f0ae038..dd76ed2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
@@ -63,6 +63,7 @@
 #include <linux/slab.h>
 #include <linux/export.h>
 #include <linux/etherdevice.h>
+#include <linux/pci.h>
 #include "iwl-drv.h"
 #include "iwl-modparams.h"
 #include "iwl-nvm-parse.h"
@@ -87,8 +88,10 @@ enum wkp_nvm_offsets {
 
 enum family_8000_nvm_offsets {
 	/* NVM HW-Section offset (in words) definitions */
-	HW_ADDR0_FAMILY_8000 = 0x12,
-	HW_ADDR1_FAMILY_8000 = 0x16,
+	HW_ADDR0_WFPM_FAMILY_8000 = 0x12,
+	HW_ADDR1_WFPM_FAMILY_8000 = 0x16,
+	HW_ADDR0_PCIE_FAMILY_8000 = 0x8A,
+	HW_ADDR1_PCIE_FAMILY_8000 = 0x8E,
 	MAC_ADDRESS_OVERRIDE_FAMILY_8000 = 1,
 
 	/* NVM SW-Section offset (in words) definitions */
@@ -504,16 +507,49 @@ static void iwl_set_hw_address_family_8000(struct device *dev,
 	}
 
 	if (nvm_hw) {
-		/* take the MAC address from the OTP */
-		hw_addr = (const u8 *)(nvm_hw + HW_ADDR0_FAMILY_8000);
-		data->hw_addr[0] = hw_addr[3];
-		data->hw_addr[1] = hw_addr[2];
-		data->hw_addr[2] = hw_addr[1];
-		data->hw_addr[3] = hw_addr[0];
-
-		hw_addr = (const u8 *)(nvm_hw + HW_ADDR1_FAMILY_8000);
-		data->hw_addr[4] = hw_addr[1];
-		data->hw_addr[5] = hw_addr[0];
+		/* read the MAC address from OTP */
+		if (!dev_is_pci(dev) || (data->nvm_version < 0xE08)) {
+			/* read the mac address from the WFPM location */
+			hw_addr = (const u8 *)(nvm_hw +
+					       HW_ADDR0_WFPM_FAMILY_8000);
+			data->hw_addr[0] = hw_addr[3];
+			data->hw_addr[1] = hw_addr[2];
+			data->hw_addr[2] = hw_addr[1];
+			data->hw_addr[3] = hw_addr[0];
+
+			hw_addr = (const u8 *)(nvm_hw +
+					       HW_ADDR1_WFPM_FAMILY_8000);
+			data->hw_addr[4] = hw_addr[1];
+			data->hw_addr[5] = hw_addr[0];
+		} else if ((data->nvm_version >= 0xE08) &&
+			   (data->nvm_version < 0xE0B)) {
+			/* read "reverse order"  from the PCIe location */
+			hw_addr = (const u8 *)(nvm_hw +
+					       HW_ADDR0_PCIE_FAMILY_8000);
+			data->hw_addr[5] = hw_addr[2];
+			data->hw_addr[4] = hw_addr[1];
+			data->hw_addr[3] = hw_addr[0];
+
+			hw_addr = (const u8 *)(nvm_hw +
+					       HW_ADDR1_PCIE_FAMILY_8000);
+			data->hw_addr[2] = hw_addr[3];
+			data->hw_addr[1] = hw_addr[2];
+			data->hw_addr[0] = hw_addr[1];
+		} else {
+			/* read from the PCIe location */
+			hw_addr = (const u8 *)(nvm_hw +
+					       HW_ADDR0_PCIE_FAMILY_8000);
+			data->hw_addr[5] = hw_addr[0];
+			data->hw_addr[4] = hw_addr[1];
+			data->hw_addr[3] = hw_addr[2];
+
+			hw_addr = (const u8 *)(nvm_hw +
+					       HW_ADDR1_PCIE_FAMILY_8000);
+			data->hw_addr[2] = hw_addr[1];
+			data->hw_addr[1] = hw_addr[2];
+			data->hw_addr[0] = hw_addr[3];
+		}
+
 		return;
 	}
 
-- 
1.8.3.2

