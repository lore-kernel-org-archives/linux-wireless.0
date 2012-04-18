Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:14459 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753627Ab2DROpx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Apr 2012 10:45:53 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 15/15] iwlwifi: move iwl_rxon_context_id to user
Date: Wed, 18 Apr 2012 07:41:17 -0700
Message-Id: <1334760077-5714-16-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120418_164602_723768_9CB6F062)
In-Reply-To: <1334760077-5714-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1334760077-5714-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

It can be moved to iwl-dev.h since it is op_mode specific.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-dev.h    |    7 +++++++
 drivers/net/wireless/iwlwifi/iwl-shared.h |    7 -------
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 3816429..9d58b23 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -604,6 +604,13 @@ struct iwl_rf_reset {
 	unsigned long last_reset_jiffies;
 };
 
+enum iwl_rxon_context_id {
+	IWL_RXON_CTX_BSS,
+	IWL_RXON_CTX_PAN,
+
+	NUM_IWL_RXON_CTX
+};
+
 /* extend beacon time format bit shifting  */
 /*
  * for _agn devices
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index 8bb56f2..2abf4bb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -126,11 +126,4 @@ static inline bool iwl_have_debug_level(u32 level)
 	return iwlagn_mod_params.debug_level & level;
 }
 
-enum iwl_rxon_context_id {
-	IWL_RXON_CTX_BSS,
-	IWL_RXON_CTX_PAN,
-
-	NUM_IWL_RXON_CTX
-};
-
 #endif /* #__iwl_shared_h__ */
-- 
1.7.0.4

