Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:60634 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751239AbdFBJfn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Jun 2017 05:35:43 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Luca Coelho <luciano.coelho@intel.com>
Date: Fri,  2 Jun 2017 12:35:15 +0300
Message-Id: <20170602093516.16369-10-luca@coelho.fi> (sfid-20170602_113547_468892_88FD6BB3)
In-Reply-To: <20170602093516.16369-1-luca@coelho.fi>
References: <20170602093516.16369-1-luca@coelho.fi>
Subject: [PATCH 09/10] iwlwifi: fix min API version for 7265D, 3168, 8000 and 8265
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

In a previous commit, we removed support for API versions earlier than
22 for these NICs.  By mistake, the *_UCODE_API_MIN definitions were
set to 17.  Fix that.

Fixes: 4b87e5af638b ("iwlwifi: remove support for fw older than -17 and -22")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-7000.c | 4 ++--
 drivers/net/wireless/intel/iwlwifi/iwl-8000.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-7000.c b/drivers/net/wireless/intel/iwlwifi/iwl-7000.c
index 3b3e076571d6..45e2efc70d19 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-7000.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-7000.c
@@ -79,8 +79,8 @@
 /* Lowest firmware API version supported */
 #define IWL7260_UCODE_API_MIN	17
 #define IWL7265_UCODE_API_MIN	17
-#define IWL7265D_UCODE_API_MIN	17
-#define IWL3168_UCODE_API_MIN	20
+#define IWL7265D_UCODE_API_MIN	22
+#define IWL3168_UCODE_API_MIN	22
 
 /* NVM versions */
 #define IWL7260_NVM_VERSION		0x0a1d
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-8000.c b/drivers/net/wireless/intel/iwlwifi/iwl-8000.c
index b9718c0cf174..89137717c1fc 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-8000.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-8000.c
@@ -74,8 +74,8 @@
 #define IWL8265_UCODE_API_MAX	30
 
 /* Lowest firmware API version supported */
-#define IWL8000_UCODE_API_MIN	17
-#define IWL8265_UCODE_API_MIN	20
+#define IWL8000_UCODE_API_MIN	22
+#define IWL8265_UCODE_API_MIN	22
 
 /* NVM versions */
 #define IWL8000_NVM_VERSION		0x0a1d
-- 
2.11.0
