Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:50879 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761401AbXG0J3A (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jul 2007 05:29:00 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 06/17] iwlwifi: rename base.c to iwl-base.c
Date: Fri, 27 Jul 2007 17:26:30 +0800
Message-Id: <11855284122218-git-send-email-yi.zhu@intel.com>
In-Reply-To: <11855284103871-git-send-email-yi.zhu@intel.com>
References: <11855284012123-git-send-email-yi.zhu@intel.com>
 <11855284032407-git-send-email-yi.zhu@intel.com>
 <11855284053896-git-send-email-yi.zhu@intel.com>
 <11855284072074-git-send-email-yi.zhu@intel.com>
 <1185528408776-git-send-email-yi.zhu@intel.com>
 <11855284103871-git-send-email-yi.zhu@intel.com>
To: ipwpatch@vger.kernel.org
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwl-3945.c |    2 +-
 drivers/net/wireless/iwl-3945.h |    2 +-
 drivers/net/wireless/iwl-4965.h |    2 +-
 drivers/net/wireless/iwl-base.c |    2 +-
 drivers/net/wireless/iwlwifi.h  |    8 ++++----
 5 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/iwl-3945.c b/drivers/net/wireless/iwl-3945.c
index eb8226a..af136c8 100644
--- a/drivers/net/wireless/iwl-3945.c
+++ b/drivers/net/wireless/iwl-3945.c
@@ -223,7 +223,7 @@ int iwl3945_get_antenna_flags(const struct iwl_priv *priv)
  *
  *  RX handler implementations
  *
- *  Used by base.c
+ *  Used by iwl-base.c
  *
  *****************************************************************************/
 
diff --git a/drivers/net/wireless/iwl-3945.h b/drivers/net/wireless/iwl-3945.h
index b26b184..4f43702 100644
--- a/drivers/net/wireless/iwl-3945.h
+++ b/drivers/net/wireless/iwl-3945.h
@@ -45,7 +45,7 @@ static inline u8 iwl3945_sync_sta(struct iwl_priv *priv, int sta_id,
 		 u16 tx_rate, u8 flags) { return 0; }
 #else				/* IWL == 3945 */
 /*
- * Forward declare iwl-3945.c functions for base.c
+ * Forward declare iwl-3945.c functions for iwl-base.c
  */
 extern int iwl3945_get_antenna_flags(const struct iwl_priv *priv);
 extern int iwl3945_init_hw_rate_table(struct iwl_priv *priv);
diff --git a/drivers/net/wireless/iwl-4965.h b/drivers/net/wireless/iwl-4965.h
index 816df54..1f832e7 100644
--- a/drivers/net/wireless/iwl-4965.h
+++ b/drivers/net/wireless/iwl-4965.h
@@ -67,7 +67,7 @@ static inline int iwl4965_set_fat_chan_info(struct iwl_priv *priv, int phymode,
 static inline void iwl4965_rf_kill_ct_config(struct iwl_priv *priv) {}
 #else				/* IWL == 4965 */
 /*
- * Forward declare iwl-4965.c functions for base.c
+ * Forward declare iwl-4965.c functions for iwl-base.c
  */
 extern int iwl4965_tx_queue_update_wr_ptr(struct iwl_priv *priv,
 					  struct iwl_tx_queue *txq,
diff --git a/drivers/net/wireless/iwl-base.c b/drivers/net/wireless/iwl-base.c
index 3d19a1a..95e8ead 100644
--- a/drivers/net/wireless/iwl-base.c
+++ b/drivers/net/wireless/iwl-base.c
@@ -28,7 +28,7 @@
  *****************************************************************************/
 
 /*
- * NOTE:  This file (base.c) is used to build to multiple hardware targets
+ * NOTE:  This file (iwl-base.c) is used to build to multiple hardware targets
  * by defining IWL to either 3945 or 4965.  The Makefile used when building
  * the base targets will create base-3945.o and base-4965.o
  *
diff --git a/drivers/net/wireless/iwlwifi.h b/drivers/net/wireless/iwlwifi.h
index d0403d0..6941031 100644
--- a/drivers/net/wireless/iwlwifi.h
+++ b/drivers/net/wireless/iwlwifi.h
@@ -581,7 +581,7 @@ struct iwl_driver_hw_info {
 
 /******************************************************************************
  *
- * Functions implemented in base.c which are forward declared here
+ * Functions implemented in iwl-base.c which are forward declared here
  * for use by iwl-*.c
  *
  *****************************************************************************/
@@ -657,11 +657,11 @@ extern void iwl_down(struct iwl_priv *priv);
 
 /******************************************************************************
  *
- * Functions implemented in iwl-*.c which are forward declared here
- * for use by base.c
+ * Functions implemented in iwl-[34]*.c which are forward declared here
+ * for use by iwl-base.c
  *
  * NOTE:  The implementation of these functions are hardware specific
- * which is why they are in the hardware specific files (vs. base.c)
+ * which is why they are in the hardware specific files (vs. iwl-base.c)
  *
  * Naming convention --
  * iwl_         <-- Its part of iwlwifi (should be changed to iwl_)
-- 
1.5.2
