Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:53277 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752486AbaIOFNX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2014 01:13:23 -0400
Received: by mail-wi0-f180.google.com with SMTP id ex7so3431474wid.1
        for <linux-wireless@vger.kernel.org>; Sun, 14 Sep 2014 22:13:22 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Liad Kaufman <liad.kaufman@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 12/28] iwlwifi: make hw rev checking more readable
Date: Mon, 15 Sep 2014 08:12:44 +0300
Message-Id: <1410757980-2138-12-git-send-email-egrumbach@gmail.com> (sfid-20140915_073114_095596_5A7F5B7D)
In-Reply-To: <5416742C.3070804@gmail.com>
References: <5416742C.3070804@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Liad Kaufman <liad.kaufman@intel.com>

Rather than ANDing with a mask - use existing macros, which
are more readable.

Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-csr.h    | 10 ++++++++++
 drivers/net/wireless/iwlwifi/iwl-io.c     |  2 +-
 drivers/net/wireless/iwlwifi/mvm/nvm.c    |  3 ++-
 drivers/net/wireless/iwlwifi/pcie/trans.c |  2 +-
 4 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-csr.h b/drivers/net/wireless/iwlwifi/iwl-csr.h
index 23d059a..3f6f015 100644
--- a/drivers/net/wireless/iwlwifi/iwl-csr.h
+++ b/drivers/net/wireless/iwlwifi/iwl-csr.h
@@ -295,6 +295,16 @@
 #define CSR_HW_REV_DASH(_val)          (((_val) & 0x0000003) >> 0)
 #define CSR_HW_REV_STEP(_val)          (((_val) & 0x000000C) >> 2)
 
+
+/**
+ *  hw_rev values
+ */
+enum {
+	SILICON_A_STEP = 0,
+	SILICON_B_STEP,
+};
+
+
 #define CSR_HW_REV_TYPE_MSK            (0x000FFF0)
 #define CSR_HW_REV_TYPE_5300           (0x0000020)
 #define CSR_HW_REV_TYPE_5350           (0x0000030)
diff --git a/drivers/net/wireless/iwlwifi/iwl-io.c b/drivers/net/wireless/iwlwifi/iwl-io.c
index 5eef4ae..7a2cbf6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-io.c
+++ b/drivers/net/wireless/iwlwifi/iwl-io.c
@@ -193,7 +193,7 @@ void iwl_force_nmi(struct iwl_trans *trans)
 	 * DEVICE_SET_NMI_8000B_REG - is used.
 	 */
 	if ((trans->cfg->device_family != IWL_DEVICE_FAMILY_8000) ||
-	    ((trans->hw_rev & 0xc) == 0x0))
+	    (CSR_HW_REV_STEP(trans->hw_rev) == SILICON_A_STEP))
 		iwl_write_prph(trans, DEVICE_SET_NMI_REG, DEVICE_SET_NMI_VAL);
 	else
 		iwl_write_prph(trans, DEVICE_SET_NMI_8000B_REG,
diff --git a/drivers/net/wireless/iwlwifi/mvm/nvm.c b/drivers/net/wireless/iwlwifi/mvm/nvm.c
index 4fafd4b..af07456 100644
--- a/drivers/net/wireless/iwlwifi/mvm/nvm.c
+++ b/drivers/net/wireless/iwlwifi/mvm/nvm.c
@@ -64,6 +64,7 @@
  *****************************************************************************/
 #include <linux/firmware.h>
 #include "iwl-trans.h"
+#include "iwl-csr.h"
 #include "mvm.h"
 #include "iwl-eeprom-parse.h"
 #include "iwl-eeprom-read.h"
@@ -349,7 +350,7 @@ static int iwl_mvm_read_external_nvm(struct iwl_mvm *mvm)
 	/* Maximal size depends on HW family and step */
 	if (mvm->trans->cfg->device_family != IWL_DEVICE_FAMILY_8000)
 		max_section_size = IWL_MAX_NVM_SECTION_SIZE;
-	else if ((mvm->trans->hw_rev & 0xc) == 0) /* Family 8000 A-step */
+	else if (CSR_HW_REV_STEP(mvm->trans->hw_rev) == SILICON_A_STEP)
 		max_section_size = IWL_MAX_NVM_8000A_SECTION_SIZE;
 	else /* Family 8000 B-step */
 		max_section_size = IWL_MAX_NVM_8000B_SECTION_SIZE;
diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index 4add964..ae99240 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -2190,7 +2190,7 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
 	 */
 	if (trans->cfg->device_family == IWL_DEVICE_FAMILY_8000)
 		trans->hw_rev = (trans->hw_rev & 0xfff0) |
-				((trans->hw_rev << 2) & 0xc);
+				(CSR_HW_REV_STEP(trans->hw_rev << 2));
 
 	trans->hw_id = (pdev->device << 16) + pdev->subsystem_device;
 	snprintf(trans->hw_id_str, sizeof(trans->hw_id_str),
-- 
1.9.1

