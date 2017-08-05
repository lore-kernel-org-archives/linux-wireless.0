Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:42604 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752665AbdHEToq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 5 Aug 2017 15:44:46 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Golan Ben-Ami <golan.ben.ami@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sat,  5 Aug 2017 22:43:28 +0300
Message-Id: <20170805194331.17426-17-luca@coelho.fi> (sfid-20170805_214449_310694_C067478D)
In-Reply-To: <20170805194331.17426-1-luca@coelho.fi>
References: <20170805194331.17426-1-luca@coelho.fi>
Subject: [PATCH 16/19] iwlwifi: fix nmi triggering from host
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Golan Ben-Ami <golan.ben.ami@intel.com>

Although nmi was triggered fine till now, it appears
that the driver didn't write the exact correct values
to the correct addresses for each HW.
Fix the nmi triggering by setting the correct addresses
and values.

Fixes: 4c9706dc2f29 ("iwlwifi: update nmi register")
Signed-off-by: Golan Ben-Ami <golan.ben.ami@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-io.c   | 14 +++-----------
 drivers/net/wireless/intel/iwlwifi/iwl-prph.h |  7 +++----
 2 files changed, 6 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-io.c b/drivers/net/wireless/intel/iwlwifi/iwl-io.c
index c527b8c10370..efb1998dcabd 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-io.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-io.c
@@ -241,20 +241,12 @@ IWL_EXPORT_SYMBOL(iwl_clear_bits_prph);
 
 void iwl_force_nmi(struct iwl_trans *trans)
 {
-	if (trans->cfg->device_family < IWL_DEVICE_FAMILY_8000) {
+	if (trans->cfg->device_family < IWL_DEVICE_FAMILY_9000)
 		iwl_write_prph(trans, DEVICE_SET_NMI_REG,
 			       DEVICE_SET_NMI_VAL_DRV);
-		iwl_write_prph(trans, DEVICE_SET_NMI_REG,
-			       DEVICE_SET_NMI_VAL_HW);
-	} else if (trans->cfg->device_family == IWL_DEVICE_FAMILY_A000) {
+	else
 		iwl_write_prph(trans, UREG_NIC_SET_NMI_DRIVER,
-			       DEVICE_SET_NMI_8000_VAL);
-	} else {
-		iwl_write_prph(trans, DEVICE_SET_NMI_8000_REG,
-			       DEVICE_SET_NMI_8000_VAL);
-		iwl_write_prph(trans, DEVICE_SET_NMI_REG,
-			       DEVICE_SET_NMI_VAL_DRV);
-	}
+			       UREG_NIC_SET_NMI_DRIVER_NMI_FROM_DRIVER_MSK);
 }
 IWL_EXPORT_SYMBOL(iwl_force_nmi);
 
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-prph.h b/drivers/net/wireless/intel/iwlwifi/iwl-prph.h
index fbce97ed4ecd..421a869633a3 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-prph.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-prph.h
@@ -109,13 +109,12 @@
 /* Device system time */
 #define DEVICE_SYSTEM_TIME_REG 0xA0206C
 
-/* Device NMI register */
+/* Device NMI register and value for 8000 family and lower hw's */
 #define DEVICE_SET_NMI_REG 0x00a01c30
-#define DEVICE_SET_NMI_VAL_HW BIT(0)
 #define DEVICE_SET_NMI_VAL_DRV BIT(7)
-#define DEVICE_SET_NMI_8000_REG 0x00a01c24
-#define DEVICE_SET_NMI_8000_VAL 0x1000000
+/* Device NMI register and value for 9000 family and above hw's */
 #define UREG_NIC_SET_NMI_DRIVER 0x00a05c10
+#define UREG_NIC_SET_NMI_DRIVER_NMI_FROM_DRIVER_MSK 0xff000000
 
 /* Shared registers (0x0..0x3ff, via target indirect or periphery */
 #define SHR_BASE	0x00a10000
-- 
2.13.2
