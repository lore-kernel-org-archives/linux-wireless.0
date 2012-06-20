Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39604 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754916Ab2FTHiV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2012 03:38:21 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 03/12] iwlwifi: comment context requirements of the op_mode
Date: Wed, 20 Jun 2012 09:38:05 +0200
Message-Id: <1340177894-12992-4-git-send-email-johannes@sipsolutions.net> (sfid-20120620_093828_084235_4D26956B)
In-Reply-To: <1340177894-12992-1-git-send-email-johannes@sipsolutions.net>
References: <1340177894-12992-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

A few op_mode of the op_mode API functions have requirements
on the running context of the caller. Document that.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-op-mode.h |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-op-mode.h b/drivers/net/wireless/iwlwifi/iwl-op-mode.h
index cd9ef11..64886f9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-op-mode.h
+++ b/drivers/net/wireless/iwlwifi/iwl-op-mode.h
@@ -111,22 +111,25 @@ struct iwl_cfg;
  *	May sleep
  * @rx: Rx notification to the op_mode. rxb is the Rx buffer itself. Cmd is the
  *	HCMD the this Rx responds to.
- *	Must be atomic.
+ *	Must be atomic and called with BH disabled.
  * @queue_full: notifies that a HW queue is full.
- *	Must be atomic
+ *	Must be atomic and called with BH disabled.
  * @queue_not_full: notifies that a HW queue is not full any more.
- *	Must be atomic
+ *	Must be atomic and called with BH disabled.
  * @hw_rf_kill:notifies of a change in the HW rf kill switch. True means that
  *	the radio is killed. Must be atomic.
  * @free_skb: allows the transport layer to free skbs that haven't been
  *	reclaimed by the op_mode. This can happen when the driver is freed and
  *	there are Tx packets pending in the transport layer.
  *	Must be atomic
- * @nic_error: error notification. Must be atomic
- * @cmd_queue_full: Called when the command queue gets full. Must be atomic.
+ * @nic_error: error notification. Must be atomic and must be called with BH
+ *	disabled.
+ * @cmd_queue_full: Called when the command queue gets full. Must be atomic and
+ *	called with BH disabled.
  * @nic_config: configure NIC, called before firmware is started.
  *	May sleep
- * @wimax_active: invoked when WiMax becomes active.  Must be atomic.
+ * @wimax_active: invoked when WiMax becomes active.  Must be atomic and called
+ *	with BH disabled.
  */
 struct iwl_op_mode_ops {
 	struct iwl_op_mode *(*start)(struct iwl_trans *trans,
@@ -165,7 +168,6 @@ struct iwl_op_mode {
 static inline void iwl_op_mode_stop(struct iwl_op_mode *op_mode)
 {
 	might_sleep();
-
 	op_mode->ops->stop(op_mode);
 }
 
-- 
1.7.10

