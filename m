Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:19373 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934541Ab1IOTcI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Sep 2011 15:32:08 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 16/27] iwlagn: generically provide iwl_trans_send_cmd_pdu
Date: Thu, 15 Sep 2011 11:46:43 -0700
Message-Id: <1316112414-6341-17-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110915_213317_444417_6FAC21D0)
In-Reply-To: <1316112414-6341-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1316112414-6341-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's no need to have the transport layer have a
callback for iwl_trans_send_cmd_pdu() since it is
just a generic wrapper around iwl_trans_send_cmd().

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/Makefile            |    1 +
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c |   13 ----
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c    |    1 -
 drivers/net/wireless/iwlwifi/iwl-trans.c         |   77 ++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-trans.h         |   10 +--
 5 files changed, 80 insertions(+), 22 deletions(-)
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-trans.c

diff --git a/drivers/net/wireless/iwlwifi/Makefile b/drivers/net/wireless/iwlwifi/Makefile
index 6104f19..a7e954b 100644
--- a/drivers/net/wireless/iwlwifi/Makefile
+++ b/drivers/net/wireless/iwlwifi/Makefile
@@ -14,6 +14,7 @@ iwlagn-objs             += iwl-6000.o
 iwlagn-objs             += iwl-1000.o
 iwlagn-objs             += iwl-2000.o
 iwlagn-objs             += iwl-pci.o
+iwlagn-objs		+= iwl-trans.o
 iwlagn-objs             += iwl-trans-pcie.o iwl-trans-pcie-rx.o iwl-trans-pcie-tx.o
 
 iwlagn-$(CONFIG_IWLWIFI_DEBUGFS) += iwl-debugfs.o
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
index 305c072..c0def8e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
@@ -1099,19 +1099,6 @@ int iwl_trans_pcie_send_cmd(struct iwl_trans *trans, struct iwl_host_cmd *cmd)
 	return iwl_send_cmd_sync(trans, cmd);
 }
 
-int iwl_trans_pcie_send_cmd_pdu(struct iwl_trans *trans, u8 id, u32 flags,
-		u16 len, const void *data)
-{
-	struct iwl_host_cmd cmd = {
-		.id = id,
-		.len = { len, },
-		.data = { data, },
-		.flags = flags,
-	};
-
-	return iwl_trans_pcie_send_cmd(trans, &cmd);
-}
-
 /* Frees buffers until index _not_ inclusive */
 int iwl_tx_queue_reclaim(struct iwl_trans *trans, int txq_id, int index,
 			 struct sk_buff_head *skbs)
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
index 1c931b7..9a414b2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -1971,7 +1971,6 @@ const struct iwl_trans_ops trans_ops_pcie = {
 	.wake_any_queue = iwl_trans_pcie_wake_any_queue,
 
 	.send_cmd = iwl_trans_pcie_send_cmd,
-	.send_cmd_pdu = iwl_trans_pcie_send_cmd_pdu,
 
 	.tx = iwl_trans_pcie_tx,
 	.reclaim = iwl_trans_pcie_reclaim,
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.c b/drivers/net/wireless/iwlwifi/iwl-trans.c
new file mode 100644
index 0000000..1b20c4f
--- /dev/null
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.c
@@ -0,0 +1,77 @@
+/******************************************************************************
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2007 - 2011 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
+ * USA
+ *
+ * The full GNU General Public License is included in this distribution
+ * in the file called LICENSE.GPL.
+ *
+ * Contact Information:
+ *  Intel Linux Wireless <ilw@linux.intel.com>
+ * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
+ *
+ * BSD LICENSE
+ *
+ * Copyright(c) 2005 - 2011 Intel Corporation. All rights reserved.
+ * All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ *  * Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ *  * Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in
+ *    the documentation and/or other materials provided with the
+ *    distribution.
+ *  * Neither the name Intel Corporation nor the names of its
+ *    contributors may be used to endorse or promote products derived
+ *    from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ *****************************************************************************/
+
+#include "iwl-trans.h"
+
+int iwl_trans_send_cmd_pdu(struct iwl_trans *trans, u8 id,
+			   u32 flags, u16 len, const void *data)
+{
+	struct iwl_host_cmd cmd = {
+		.id = id,
+		.len = { len, },
+		.data = { data, },
+		.flags = flags,
+	};
+
+	return iwl_trans_send_cmd(trans, &cmd);
+}
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index f067408..8fba516 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -151,7 +151,6 @@ struct iwl_host_cmd {
  * @wake_any_queue: wake all the queues of a specfic context IWL_RXON_CTX_*
  * @stop_device:stops the whole device (embedded CPU put to reset)
  * @send_cmd:send a host command
- * @send_cmd_pdu:send a host command: flags can be CMD_*
  * @tx: send an skb
  * @reclaim: free packet until ssn. Returns a list of freed packets.
  * @tx_agg_alloc: allocate resources for a TX BA session
@@ -183,8 +182,6 @@ struct iwl_trans_ops {
 
 	int (*send_cmd)(struct iwl_trans *trans, struct iwl_host_cmd *cmd);
 
-	int (*send_cmd_pdu)(struct iwl_trans *trans, u8 id, u32 flags, u16 len,
-		     const void *data);
 	int (*tx)(struct iwl_trans *trans, struct sk_buff *skb,
 		struct iwl_device_cmd *dev_cmd, enum iwl_rxon_context_id ctx,
 		u8 sta_id);
@@ -270,11 +267,8 @@ static inline int iwl_trans_send_cmd(struct iwl_trans *trans,
 	return trans->ops->send_cmd(trans, cmd);
 }
 
-static inline int iwl_trans_send_cmd_pdu(struct iwl_trans *trans, u8 id,
-					u32 flags, u16 len, const void *data)
-{
-	return trans->ops->send_cmd_pdu(trans, id, flags, len, data);
-}
+int iwl_trans_send_cmd_pdu(struct iwl_trans *trans, u8 id,
+			   u32 flags, u16 len, const void *data);
 
 static inline int iwl_trans_tx(struct iwl_trans *trans, struct sk_buff *skb,
 		struct iwl_device_cmd *dev_cmd, enum iwl_rxon_context_id ctx,
-- 
1.7.0.4

