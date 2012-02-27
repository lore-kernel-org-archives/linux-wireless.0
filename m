Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:4551 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755643Ab2B0XTJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Feb 2012 18:19:09 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 20/24] iwlwifi: document the operational mode
Date: Mon, 27 Feb 2012 14:07:44 -0800
Message-Id: <1330380468-17674-21-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120228_001937_577406_FF9B5293)
In-Reply-To: <1330380468-17674-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1330380468-17674-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Also add a might_sleep to enforce the context requirements.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-op-mode.h |   36 ++++++++++++++++++++++++++-
 drivers/net/wireless/iwlwifi/iwl-trans.h   |    6 ----
 2 files changed, 34 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-op-mode.h b/drivers/net/wireless/iwlwifi/iwl-op-mode.h
index e2a780d..d4fc9be 100644
--- a/drivers/net/wireless/iwlwifi/iwl-op-mode.h
+++ b/drivers/net/wireless/iwlwifi/iwl-op-mode.h
@@ -70,16 +70,46 @@ struct iwl_device_cmd;
 struct iwl_rx_mem_buffer;
 
 /**
+ * DOC: Operational mode - what is it ?
+ *
+ * The operational mode (a.k.a. op_mode) is the layer that implements
+ * mac80211's handlers. It knows two APIs: mac80211's and the fw's. It uses
+ * the transport API to access the HW. The op_mode doesn't need to know how the
+ * underlying HW works, since the transport layer takes care of that.
+ *
+ * There can be several op_mode: i.e. different fw APIs will require two
+ * different op_modes. This is why the op_mode is virtualized.
+ */
+
+/**
+ * DOC: Life cycle of the Operational mode
+ *
+ * The operational mode has a very simple life cycle.
+ *
+ *	1) The driver layer (iwl-drv.c) chooses the op_mode based on the
+ *	   capabilities advertized by the fw file (in TLV format).
+ *	2) The driver layer starts the op_mode (ops->start)
+ *	3) The op_mode registers registers mac80211
+ *	4) The op_mode is governed by mac80211
+ *	5) The driver layer stops the op_mode
+ */
+
+/**
  * struct iwl_op_mode_ops - op_mode specific operations
  *
+ * The op_mode exports its ops so that external components can start it and
+ * interact with it. The driver layer typically calls the start and stop
+ * handlers, the transport layer calls the others.
+ *
  * All the handlers MUST be implemented
  *
- * @start: start the op_mode
+ * @start: start the op_mode. The transport layer is already allocated.
  *	May sleep
- * @stop: stop the op_mode
+ * @stop: stop the op_mode. Must free all the memory allocated.
  *	May sleep
  * @rx: Rx notification to the op_mode. rxb is the Rx buffer itself. Cmd is the
  *	HCMD the this Rx responds to.
+ *	Must be atomic.
  * @queue_full: notifies that a HW queue is full. Ac is the ac of the queue
  *	Must be atomic
  * @queue_not_full: notifies that a HW queue is not full any more.
@@ -120,6 +150,8 @@ struct iwl_op_mode {
 
 static inline void iwl_op_mode_stop(struct iwl_op_mode *op_mode)
 {
+	might_sleep();
+
 	op_mode->ops->stop(op_mode);
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 52a1c2e..08d93b9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -106,12 +106,6 @@
  *	6) Eventually, the free function will be called.
  */
 
-/**
- * DOC: API needed by the transport layer from the op_mode
- *
- * TODO
- */
-
 struct iwl_priv;
 struct iwl_shared;
 struct iwl_op_mode;
-- 
1.7.0.4

