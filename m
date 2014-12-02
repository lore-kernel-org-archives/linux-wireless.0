Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:33381 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932613AbaLBSLb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Dec 2014 13:11:31 -0500
Received: by mail-wg0-f51.google.com with SMTP id k14so17603026wgh.38
        for <linux-wireless@vger.kernel.org>; Tue, 02 Dec 2014 10:11:30 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 03/26] iwlwifi: deprecate -8.ucode for 3160 / 7260 / 7265
Date: Tue,  2 Dec 2014 20:10:54 +0200
Message-Id: <1417543877-24193-3-git-send-email-egrumbach@gmail.com> (sfid-20141202_191134_958162_1638A132)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB31B5A7D27@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB31B5A7D27@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This firmware is not supported anymore.
Stop loading this firmware - and remove the code that
handled older versions.

Reviewed-by: Luciano Coelho <luciano.coelho@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-7000.c     | 8 ++++----
 drivers/net/wireless/iwlwifi/iwl-8000.c     | 4 ++--
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 1 -
 3 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-7000.c b/drivers/net/wireless/iwlwifi/iwl-7000.c
index 84d2a42..8155988 100644
--- a/drivers/net/wireless/iwlwifi/iwl-7000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-7000.c
@@ -73,12 +73,12 @@
 #define IWL3160_UCODE_API_MAX	10
 
 /* Oldest version we won't warn about */
-#define IWL7260_UCODE_API_OK	9
-#define IWL3160_UCODE_API_OK	9
+#define IWL7260_UCODE_API_OK	10
+#define IWL3160_UCODE_API_OK	10
 
 /* Lowest firmware API version supported */
-#define IWL7260_UCODE_API_MIN	8
-#define IWL3160_UCODE_API_MIN	8
+#define IWL7260_UCODE_API_MIN	9
+#define IWL3160_UCODE_API_MIN	9
 
 /* NVM versions */
 #define IWL7260_NVM_VERSION		0x0a1d
diff --git a/drivers/net/wireless/iwlwifi/iwl-8000.c b/drivers/net/wireless/iwlwifi/iwl-8000.c
index d0357b3..1211569 100644
--- a/drivers/net/wireless/iwlwifi/iwl-8000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-8000.c
@@ -72,10 +72,10 @@
 #define IWL8000_UCODE_API_MAX	10
 
 /* Oldest version we won't warn about */
-#define IWL8000_UCODE_API_OK	8
+#define IWL8000_UCODE_API_OK	10
 
 /* Lowest firmware API version supported */
-#define IWL8000_UCODE_API_MIN	8
+#define IWL8000_UCODE_API_MIN	9
 
 /* NVM versions */
 #define IWL8000_NVM_VERSION		0x0a1d
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index f876d86..598fabf 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -337,7 +337,6 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 		hw->flags |= IEEE80211_HW_MFP_CAPABLE;
 
 	if (mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_UAPSD_SUPPORT &&
-	    IWL_UCODE_API(mvm->fw->ucode_ver) >= 9 &&
 	    !iwlwifi_mod_params.uapsd_disable) {
 		hw->flags |= IEEE80211_HW_SUPPORTS_UAPSD;
 		hw->uapsd_queues = IWL_MVM_UAPSD_QUEUES;
-- 
1.9.1

