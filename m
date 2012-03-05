Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:7349 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030190Ab2CEUiK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Mar 2012 15:38:10 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH RESEND 24/33] iwlwifi: move queue functions to PCI-E
Date: Mon,  5 Mar 2012 11:24:42 -0800
Message-Id: <1330975491-19680-25-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120305_213849_691580_32A8AC5E)
In-Reply-To: <1330975491-19680-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1330975491-19680-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

iwl_queue_inc_wrap/iwl_queue_dec_wrap aren't
shared functions, they are PCI-E specific,
so move them into the appropriate header.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-shared.h         |   20 --------------------
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h |   20 ++++++++++++++++++++
 2 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index ed1811d..787d726 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -413,26 +413,6 @@ static inline bool iwl_have_debug_level(u32 level)
 	return iwlagn_mod_params.debug_level & level;
 }
 
-/**
- * iwl_queue_inc_wrap - increment queue index, wrap back to beginning
- * @index -- current index
- * @n_bd -- total number of entries in queue (must be power of 2)
- */
-static inline int iwl_queue_inc_wrap(int index, int n_bd)
-{
-	return ++index & (n_bd - 1);
-}
-
-/**
- * iwl_queue_dec_wrap - decrement queue index, wrap back to end
- * @index -- current index
- * @n_bd -- total number of entries in queue (must be power of 2)
- */
-static inline int iwl_queue_dec_wrap(int index, int n_bd)
-{
-	return --index & (n_bd - 1);
-}
-
 struct iwl_rx_cmd_buffer {
 	struct page *_page;
 };
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
index 632d409..44952c3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
@@ -115,6 +115,26 @@ struct iwl_dma_ptr {
 	size_t size;
 };
 
+/**
+ * iwl_queue_inc_wrap - increment queue index, wrap back to beginning
+ * @index -- current index
+ * @n_bd -- total number of entries in queue (must be power of 2)
+ */
+static inline int iwl_queue_inc_wrap(int index, int n_bd)
+{
+	return ++index & (n_bd - 1);
+}
+
+/**
+ * iwl_queue_dec_wrap - decrement queue index, wrap back to end
+ * @index -- current index
+ * @n_bd -- total number of entries in queue (must be power of 2)
+ */
+static inline int iwl_queue_dec_wrap(int index, int n_bd)
+{
+	return --index & (n_bd - 1);
+}
+
 /*
  * This queue number is required for proper operation
  * because the ucode will stop/start the scheduler as
-- 
1.7.0.4

