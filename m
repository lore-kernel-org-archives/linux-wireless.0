Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:11393 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752075Ab1HMSS5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Aug 2011 14:18:57 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 41/60] iwlagn: add missing includes
Date: Sat, 13 Aug 2011 10:38:17 -0700
Message-Id: <1313257116-2697-42-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110813_201907_330941_623170AC)
In-Reply-To: <1313257116-2697-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1313257116-2697-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

a few h files weren't self contained. Fix that.
Move iwl_dma_ptr to transport layer since it is not used by the upper layer
any more.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-bus.h            |    2 ++
 drivers/net/wireless/iwlwifi/iwl-debug.h          |    1 +
 drivers/net/wireless/iwlwifi/iwl-dev.h            |    7 -------
 drivers/net/wireless/iwlwifi/iwl-fh.h             |    2 ++
 drivers/net/wireless/iwlwifi/iwl-shared.h         |    5 +++++
 drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h |   19 +++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-trans.c          |    1 -
 drivers/net/wireless/iwlwifi/iwl-trans.h          |    4 ++++
 8 files changed, 33 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-bus.h b/drivers/net/wireless/iwlwifi/iwl-bus.h
index edec2f2..e1cb65c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-bus.h
+++ b/drivers/net/wireless/iwlwifi/iwl-bus.h
@@ -65,6 +65,8 @@
 
 /*This file includes the declaration that are exported from the bus layer */
 
+#include <linux/types.h>
+
 struct iwl_shared;
 struct iwl_bus;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-debug.h b/drivers/net/wireless/iwlwifi/iwl-debug.h
index 4b042e9..7014f41 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debug.h
+++ b/drivers/net/wireless/iwlwifi/iwl-debug.h
@@ -29,6 +29,7 @@
 #ifndef __iwl_debug_h__
 #define __iwl_debug_h__
 
+#include "iwl-bus.h"
 #include "iwl-shared.h"
 
 struct iwl_priv;
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index c6e8255..bb8a161 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -640,13 +640,6 @@ static inline u8 get_cmd_index(struct iwl_queue *q, u32 index)
 	return index & (q->n_window - 1);
 }
 
-
-struct iwl_dma_ptr {
-	dma_addr_t dma;
-	void *addr;
-	size_t size;
-};
-
 #define IWL_OPERATION_MODE_AUTO     0
 #define IWL_OPERATION_MODE_HT_ONLY  1
 #define IWL_OPERATION_MODE_MIXED    2
diff --git a/drivers/net/wireless/iwlwifi/iwl-fh.h b/drivers/net/wireless/iwlwifi/iwl-fh.h
index c1b8837..5bede9d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fh.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fh.h
@@ -63,6 +63,8 @@
 #ifndef __iwl_fh_h__
 #define __iwl_fh_h__
 
+#include <linux/types.h>
+
 /****************************/
 /* Flow Handler Definitions */
 /****************************/
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index 7145e48..45f8a33 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -63,6 +63,11 @@
 #ifndef __iwl_shared_h__
 #define __iwl_shared_h__
 
+#include <linux/types.h>
+#include <linux/spinlock.h>
+#include <linux/mutex.h>
+#include <linux/gfp.h>
+
 /*This files includes all the types / functions that are exported by the
  * upper layer to the bus and transport layer */
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h b/drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h
index c258b3f..b77b0f7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h
@@ -29,7 +29,20 @@
 #ifndef __iwl_trans_int_pcie_h__
 #define __iwl_trans_int_pcie_h__
 
+#include <linux/spinlock.h>
+#include <linux/interrupt.h>
+#include <linux/skbuff.h>
+
 #include "iwl-fh.h"
+#include "iwl-csr.h"
+#include "iwl-shared.h"
+#include "iwl-trans.h"
+#include "iwl-debug.h"
+#include "iwl-io.h"
+
+struct iwl_tx_queue;
+struct iwl_queue;
+struct iwl_host_cmd;
 
 /*This file includes the declaration that are internal to the
  * trans_pcie layer */
@@ -88,6 +101,12 @@ struct iwl_rx_queue {
 	spinlock_t lock;
 };
 
+struct iwl_dma_ptr {
+	dma_addr_t dma;
+	void *addr;
+	size_t size;
+};
+
 /**
  * struct iwl_trans_pcie - PCIe transport specific data
  * @rxq: all the RX queue data
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.c b/drivers/net/wireless/iwlwifi/iwl-trans.c
index 14c22b7..95c9e87 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.c
@@ -72,7 +72,6 @@
 #include "iwl-trans-int-pcie.h"
 /*TODO remove uneeded includes when the transport layer tx_free will be here */
 #include "iwl-agn.h"
-#include "iwl-core.h"
 #include "iwl-shared.h"
 
 static int iwl_trans_rx_alloc(struct iwl_trans *trans)
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 78bd2f6..0da6ad5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -64,6 +64,10 @@
 #define __iwl_trans_h__
 
 #include <linux/debugfs.h>
+#include <linux/skbuff.h>
+
+#include "iwl-shared.h"
+#include "iwl-commands.h"
 
  /*This file includes the declaration that are exported from the transport
  * layer */
-- 
1.7.0.4

