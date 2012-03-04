Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:54587 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755015Ab2CDUnC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Mar 2012 15:43:02 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 027/101] iwlwifi: move IWL_MASK into file using it
Date: Sun,  4 Mar 2012 11:28:41 -0800
Message-Id: <1330889395-533-28-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120304_214633_705265_BD50ED50)
In-Reply-To: <1330889395-533-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1330889395-533-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Only used in two places in the same file,
no need to be in iwl-shared.h.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-shared.h     |    1 -
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c |    2 ++
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index 740a058..976e6c5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -444,7 +444,6 @@ iwl_remove_notification(struct iwl_shared *shrd,
 			   struct iwl_notification_wait *wait_entry);
 
 #define IWL_CMD(x) case x: return #x
-#define IWL_MASK(lo, hi) ((1 << (hi)) | ((1 << (hi)) - (1 << (lo))))
 
 #define IWL_TRAFFIC_ENTRIES	(256)
 #define IWL_TRAFFIC_ENTRY_SIZE  (64)
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
index bb8f2fd..3ae2fd7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -78,6 +78,8 @@
 #include "iwl-core.h"
 #include "iwl-ucode.h"
 
+#define IWL_MASK(lo, hi) ((1 << (hi)) | ((1 << (hi)) - (1 << (lo))))
+
 static int iwl_trans_rx_alloc(struct iwl_trans *trans)
 {
 	struct iwl_trans_pcie *trans_pcie =
-- 
1.7.0.4

