Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:37362 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752976AbbHDU6z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Aug 2015 16:58:55 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Sara Sharon <sara.sharon@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 03/37] iwlwifi: deprecate -10.ucode for 3160 / 7260 / 7265
Date: Tue,  4 Aug 2015 23:42:53 +0300
Message-Id: <1438721007-23283-3-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150804_225901_678765_CAE35C8A)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E7E11FA@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E7E11FA@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

This firmware is not supported anymore - stop loading this firmware.
Remove code handling older versions.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-7000.c | 2 +-
 drivers/net/wireless/iwlwifi/iwl-8000.c | 2 +-
 drivers/net/wireless/iwlwifi/mvm/fw.c   | 3 +--
 3 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-7000.c b/drivers/net/wireless/iwlwifi/iwl-7000.c
index cc35f79..fa35da4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-7000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-7000.c
@@ -76,7 +76,7 @@
 #define IWL3165_UCODE_API_OK	13
 
 /* Lowest firmware API version supported */
-#define IWL7260_UCODE_API_MIN	10
+#define IWL7260_UCODE_API_MIN	12
 #define IWL3165_UCODE_API_MIN	13
 
 /* NVM versions */
diff --git a/drivers/net/wireless/iwlwifi/iwl-8000.c b/drivers/net/wireless/iwlwifi/iwl-8000.c
index 72040cd..0de5751 100644
--- a/drivers/net/wireless/iwlwifi/iwl-8000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-8000.c
@@ -75,7 +75,7 @@
 #define IWL8000_UCODE_API_OK	12
 
 /* Lowest firmware API version supported */
-#define IWL8000_UCODE_API_MIN	10
+#define IWL8000_UCODE_API_MIN	12
 
 /* NVM versions */
 #define IWL8000_NVM_VERSION		0x0a1d
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw.c b/drivers/net/wireless/iwlwifi/mvm/fw.c
index eb10c5e..a482ce6 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/iwlwifi/mvm/fw.c
@@ -676,8 +676,7 @@ int iwl_mvm_up(struct iwl_mvm *mvm)
 		goto error;
 	}
 
-	if (IWL_UCODE_API(mvm->fw->ucode_ver) >= 10)
-		iwl_mvm_get_shared_mem_conf(mvm);
+	iwl_mvm_get_shared_mem_conf(mvm);
 
 	ret = iwl_mvm_sf_update(mvm, NULL, false);
 	if (ret)
-- 
2.1.4

