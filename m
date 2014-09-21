Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f176.google.com ([74.125.82.176]:54913 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885AbaIUTWp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Sep 2014 15:22:45 -0400
Received: by mail-we0-f176.google.com with SMTP id w61so1055059wes.21
        for <linux-wireless@vger.kernel.org>; Sun, 21 Sep 2014 12:22:44 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Liad Kaufman <liad.kaufman@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 13/17] iwlwifi: 8000: fix fw name to account for revision
Date: Sun, 21 Sep 2014 22:22:14 +0300
Message-Id: <1411327338-23099-13-git-send-email-egrumbach@gmail.com> (sfid-20140921_213114_264996_BF391046)
In-Reply-To: <541F23D2.90600@gmail.com>
References: <541F23D2.90600@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Liad Kaufman <liad.kaufman@intel.com>

The 8000 HW series also includes the revision in the FW
name.

Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-8000.c |  2 +-
 drivers/net/wireless/iwlwifi/iwl-drv.c  | 18 ++++++++++++++++++
 2 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-8000.c b/drivers/net/wireless/iwlwifi/iwl-8000.c
index 4ae8ba6..e435148 100644
--- a/drivers/net/wireless/iwlwifi/iwl-8000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-8000.c
@@ -81,7 +81,7 @@
 #define IWL8000_NVM_VERSION		0x0a1d
 #define IWL8000_TX_POWER_VERSION	0xffff /* meaningless */
 
-#define IWL8000_FW_PRE "iwlwifi-8000-"
+#define IWL8000_FW_PRE "iwlwifi-8000"
 #define IWL8000_MODULE_FIRMWARE(api) IWL8000_FW_PRE __stringify(api) ".ucode"
 
 #define NVM_HW_SECTION_NUM_FAMILY_8000		10
diff --git a/drivers/net/wireless/iwlwifi/iwl-drv.c b/drivers/net/wireless/iwlwifi/iwl-drv.c
index ed673ba..0f1084f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/iwlwifi/iwl-drv.c
@@ -69,6 +69,7 @@
 #include <linux/vmalloc.h>
 
 #include "iwl-drv.h"
+#include "iwl-csr.h"
 #include "iwl-debug.h"
 #include "iwl-trans.h"
 #include "iwl-op-mode.h"
@@ -244,6 +245,23 @@ static int iwl_request_firmware(struct iwl_drv *drv, bool first)
 	snprintf(drv->firmware_name, sizeof(drv->firmware_name), "%s%s.ucode",
 		 name_pre, tag);
 
+	/*
+	 * Starting 8000B - FW name format has changed. This overwrites the
+	 * previous name and uses the new format.
+	 */
+	if (drv->trans->cfg->device_family == IWL_DEVICE_FAMILY_8000) {
+		char rev_step[2] = {
+			'A' + CSR_HW_REV_STEP(drv->trans->hw_rev), 0
+		};
+
+		/* A-step doesn't have an indication */
+		if (CSR_HW_REV_STEP(drv->trans->hw_rev) == SILICON_A_STEP)
+			rev_step[0] = 0;
+
+		snprintf(drv->firmware_name, sizeof(drv->firmware_name),
+			 "%s%s-%s.ucode", name_pre, rev_step, tag);
+	}
+
 	IWL_DEBUG_INFO(drv, "attempting to load firmware %s'%s'\n",
 		       (drv->fw_index == UCODE_EXPERIMENTAL_INDEX)
 				? "EXPERIMENTAL " : "",
-- 
1.9.1

