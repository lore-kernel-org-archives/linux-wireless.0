Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:40380 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755215AbaDMTUa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Apr 2014 15:20:30 -0400
Received: by mail-wg0-f45.google.com with SMTP id l18so7501769wgh.16
        for <linux-wireless@vger.kernel.org>; Sun, 13 Apr 2014 12:20:29 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eran Harary <eran.harary@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 13/47] iwlwifi: move CPU1_CPU2_SEPARATOR_SECTION to iwl-fw.h
Date: Sun, 13 Apr 2014 22:19:28 +0300
Message-Id: <1397416802-32403-13-git-send-email-egrumbach@gmail.com> (sfid-20140413_212037_637887_5B0BC4F2)
In-Reply-To: <534AE330.2020805@gmail.com>
References: <534AE330.2020805@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eran Harary <eran.harary@intel.com>

This define is related to the firmware packaging and is
needed by more than one transport.

Signed-off-by: Eran Harary <eran.harary@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-fw.h     | 1 +
 drivers/net/wireless/iwlwifi/pcie/trans.c | 1 -
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-fw.h b/drivers/net/wireless/iwlwifi/iwl-fw.h
index de70919..f7ea9c0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw.h
@@ -188,6 +188,7 @@ enum iwl_ucode_sec {
 #define IWL_UCODE_SECTION_MAX 12
 #define IWL_API_ARRAY_SIZE	1
 #define IWL_CAPABILITIES_ARRAY_SIZE	1
+#define CPU1_CPU2_SEPARATOR_SECTION	0xFFFFCCCC
 
 struct iwl_ucode_capabilities {
 	u32 max_probe_length;
diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index 97e6bd8..2548f49 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -103,7 +103,6 @@ static void iwl_pcie_set_pwr(struct iwl_trans *trans, bool vaux)
 
 /* PCI registers */
 #define PCI_CFG_RETRY_TIMEOUT	0x041
-#define CPU1_CPU2_SEPARATOR_SECTION	0xFFFFCCCC
 
 static void iwl_pcie_apm_config(struct iwl_trans *trans)
 {
-- 
1.8.3.2

