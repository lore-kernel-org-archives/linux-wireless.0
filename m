Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:38078 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755007Ab2CDUnB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Mar 2012 15:43:01 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 025/101] iwlwifi: iwl_rx_cmd_buffer belongs to transport API
Date: Sun,  4 Mar 2012 11:28:39 -0800
Message-Id: <1330889395-533-26-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120304_214600_980636_8D2C43C9)
In-Reply-To: <1330889395-533-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1330889395-533-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This is how the transport passes things
up into higher layers, so it belongs to
the transport API.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-shared.h |   17 -----------------
 drivers/net/wireless/iwlwifi/iwl-trans.h  |   17 +++++++++++++++++
 2 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index 787d726..2b9d21a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -67,7 +67,6 @@
 #include <linux/spinlock.h>
 #include <linux/mutex.h>
 #include <linux/gfp.h>
-#include <linux/mm.h> /* for page_address */
 #include <net/mac80211.h>
 
 #include "iwl-commands.h"
@@ -413,22 +412,6 @@ static inline bool iwl_have_debug_level(u32 level)
 	return iwlagn_mod_params.debug_level & level;
 }
 
-struct iwl_rx_cmd_buffer {
-	struct page *_page;
-};
-
-static inline void *rxb_addr(struct iwl_rx_cmd_buffer *r)
-{
-	return page_address(r->_page);
-}
-
-static inline struct page *rxb_steal_page(struct iwl_rx_cmd_buffer *r)
-{
-	struct page *p = r->_page;
-	r->_page = NULL;
-	return p;
-}
-
 /*
  * mac80211 queues, ACs, hardware queues, FIFOs.
  *
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 0197f31..b09192a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -64,6 +64,7 @@
 #define __iwl_trans_h__
 
 #include <linux/ieee80211.h>
+#include <linux/mm.h> /* for page_address */
 
 #include "iwl-shared.h"
 #include "iwl-debug.h"
@@ -201,6 +202,22 @@ static inline void iwl_free_resp(struct iwl_host_cmd *cmd)
 	free_pages(cmd->_rx_page_addr, cmd->_rx_page_order);
 }
 
+struct iwl_rx_cmd_buffer {
+	struct page *_page;
+};
+
+static inline void *rxb_addr(struct iwl_rx_cmd_buffer *r)
+{
+	return page_address(r->_page);
+}
+
+static inline struct page *rxb_steal_page(struct iwl_rx_cmd_buffer *r)
+{
+	struct page *p = r->_page;
+	r->_page = NULL;
+	return p;
+}
+
 /**
  * struct iwl_trans_ops - transport specific operations
  *
-- 
1.7.0.4

