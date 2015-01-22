Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:42471 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752768AbbAVUeJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2015 15:34:09 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 17/38] iwlwifi: correctly set the NMI register
Date: Thu, 22 Jan 2015 22:33:08 +0200
Message-Id: <1421958809-3371-17-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150122_214446_858615_BBA0DFEA)
In-Reply-To: <1421958313.6424.2.camel@egrumbacBox>
References: <1421958313.6424.2.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When we want to trigger an NMI in the device, we need to set
bit 7 and not bit 0. However, older firmwares don't register
to the interrupt issued by bit 7. Use bit 7 first so that
the correct interrupt will be issued hoping that the firmware
will react. To be on the safe side, set bit 0 in case the
firmware didn't register to the proper interrupt.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-io.c   | 10 +++++++---
 drivers/net/wireless/iwlwifi/iwl-prph.h |  3 ++-
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-io.c b/drivers/net/wireless/iwlwifi/iwl-io.c
index 7a2cbf6..03250a4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-io.c
+++ b/drivers/net/wireless/iwlwifi/iwl-io.c
@@ -193,11 +193,15 @@ void iwl_force_nmi(struct iwl_trans *trans)
 	 * DEVICE_SET_NMI_8000B_REG - is used.
 	 */
 	if ((trans->cfg->device_family != IWL_DEVICE_FAMILY_8000) ||
-	    (CSR_HW_REV_STEP(trans->hw_rev) == SILICON_A_STEP))
-		iwl_write_prph(trans, DEVICE_SET_NMI_REG, DEVICE_SET_NMI_VAL);
-	else
+	    (CSR_HW_REV_STEP(trans->hw_rev) == SILICON_A_STEP)) {
+		iwl_write_prph(trans, DEVICE_SET_NMI_REG,
+			       DEVICE_SET_NMI_VAL_DRV);
+		iwl_write_prph(trans, DEVICE_SET_NMI_REG,
+			       DEVICE_SET_NMI_VAL_HW);
+	} else {
 		iwl_write_prph(trans, DEVICE_SET_NMI_8000B_REG,
 			       DEVICE_SET_NMI_8000B_VAL);
+	}
 }
 IWL_EXPORT_SYMBOL(iwl_force_nmi);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-prph.h b/drivers/net/wireless/iwlwifi/iwl-prph.h
index 387a5aa..b21fcf0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-prph.h
+++ b/drivers/net/wireless/iwlwifi/iwl-prph.h
@@ -108,7 +108,8 @@
 
 /* Device NMI register */
 #define DEVICE_SET_NMI_REG 0x00a01c30
-#define DEVICE_SET_NMI_VAL 0x1
+#define DEVICE_SET_NMI_VAL_HW BIT(0)
+#define DEVICE_SET_NMI_VAL_DRV BIT(7)
 #define DEVICE_SET_NMI_8000B_REG 0x00a01c24
 #define DEVICE_SET_NMI_8000B_VAL 0x1000000
 
-- 
1.9.1

