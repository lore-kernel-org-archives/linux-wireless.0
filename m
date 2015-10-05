Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:57183 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752472AbbJEPBg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Oct 2015 11:01:36 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>
Date: Mon,  5 Oct 2015 17:36:44 +0300
Message-Id: <1444055820-27506-13-git-send-email-luca@coelho.fi> (sfid-20151005_170141_776122_4DD8FBDF)
In-Reply-To: <1444050759.27220.15.camel@coelho.fi>
References: <1444050759.27220.15.camel@coelho.fi>
Subject: [PATCH 13/29] iwlwifi: op-mode API: add rx_rss method
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Upcoming hardware will have the ability to do L3 hashing for RSS,
directing data packets (and perhaps some associated metadata and
management notifications) to different MSI-X vectors.

In this case, it makes no sense to go through the full RX dispatch
since it's already known that only a subset of the possibilities
can come in, requiring a new receive method. In addition this must
know which queue the packet was received on.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-op-mode.h | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-op-mode.h b/drivers/net/wireless/iwlwifi/iwl-op-mode.h
index b47fe9d..2a58d68 100644
--- a/drivers/net/wireless/iwlwifi/iwl-op-mode.h
+++ b/drivers/net/wireless/iwlwifi/iwl-op-mode.h
@@ -7,6 +7,7 @@
  *
  * Copyright(c) 2007 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
+ * Copyright(c) 2015        Intel Deutschland GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -33,6 +34,7 @@
  *
  * Copyright(c) 2005 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
+ * Copyright(c) 2015        Intel Deutschland GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -108,7 +110,8 @@ struct iwl_cfg;
  * interact with it. The driver layer typically calls the start and stop
  * handlers, the transport layer calls the others.
  *
- * All the handlers MUST be implemented
+ * All the handlers MUST be implemented, except @rx_rss which can be left
+ * out *iff* the opmode will never run on hardware with multi-queue capability.
  *
  * @start: start the op_mode. The transport layer is already allocated.
  *	May sleep
@@ -116,6 +119,10 @@ struct iwl_cfg;
  *	May sleep
  * @rx: Rx notification to the op_mode. rxb is the Rx buffer itself. Cmd is the
  *	HCMD this Rx responds to. Can't sleep.
+ * @rx_rss: data queue RX notification to the op_mode, for (data) notifications
+ *	received on the RSS queue(s). The queue parameter indicates which of the
+ *	RSS queues received this frame; it will always be non-zero.
+ *	This method must not sleep.
  * @queue_full: notifies that a HW queue is full.
  *	Must be atomic and called with BH disabled.
  * @queue_not_full: notifies that a HW queue is not full any more.
@@ -146,6 +153,8 @@ struct iwl_op_mode_ops {
 	void (*stop)(struct iwl_op_mode *op_mode);
 	void (*rx)(struct iwl_op_mode *op_mode, struct napi_struct *napi,
 		   struct iwl_rx_cmd_buffer *rxb);
+	void (*rx_rss)(struct iwl_op_mode *op_mode, struct napi_struct *napi,
+		       struct iwl_rx_cmd_buffer *rxb, unsigned int queue);
 	void (*queue_full)(struct iwl_op_mode *op_mode, int queue);
 	void (*queue_not_full)(struct iwl_op_mode *op_mode, int queue);
 	bool (*hw_rf_kill)(struct iwl_op_mode *op_mode, bool state);
@@ -186,6 +195,14 @@ static inline void iwl_op_mode_rx(struct iwl_op_mode *op_mode,
 	return op_mode->ops->rx(op_mode, napi, rxb);
 }
 
+static inline void iwl_op_mode_rx_rss(struct iwl_op_mode *op_mode,
+				      struct napi_struct *napi,
+				      struct iwl_rx_cmd_buffer *rxb,
+				      unsigned int queue)
+{
+	op_mode->ops->rx_rss(op_mode, napi, rxb, queue);
+}
+
 static inline void iwl_op_mode_queue_full(struct iwl_op_mode *op_mode,
 					  int queue)
 {
-- 
2.5.3

