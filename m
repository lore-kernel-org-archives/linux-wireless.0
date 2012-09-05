Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45225 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753283Ab2IEO1Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Sep 2012 10:27:16 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] iwlwifi: reduce overhead if tracing disabled
Date: Wed,  5 Sep 2012 16:27:53 +0200
Message-Id: <1346855273-23941-1-git-send-email-johannes@sipsolutions.net> (sfid-20120905_162720_738856_3A1C8B3E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Tracing commands builds an array of trace data
items even when the tracepoint is disabled.
Instead, loop in the tracepoint assignment.

This reduces overhead if tracing is compiled
into the driver but not enabled and slightly
reduces overall driver size as well:

   text	   data	    bss	    dec	    hex	filename
 114514	   6509	     48	 121071	  1d8ef	before/iwlwifi.ko
 114189	   6509	     48	 120746	  1d7aa	after/iwlwifi.ko

Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Reviewed-by: Max Stepanov <Max.Stepanov@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-devtrace.h |   34 +++++++++++++++++----------
 drivers/net/wireless/iwlwifi/pcie/tx.c      |   25 ++------------------
 2 files changed, 23 insertions(+), 36 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-devtrace.h b/drivers/net/wireless/iwlwifi/iwl-devtrace.h
index 06ca505..59a5f78 100644
--- a/drivers/net/wireless/iwlwifi/iwl-devtrace.h
+++ b/drivers/net/wireless/iwlwifi/iwl-devtrace.h
@@ -29,6 +29,7 @@
 
 #include <linux/tracepoint.h>
 #include <linux/device.h>
+#include "iwl-trans.h"
 
 
 #if !defined(CONFIG_IWLWIFI_DEVICE_TRACING) || defined(__CHECKER__)
@@ -237,27 +238,34 @@ TRACE_EVENT(iwlwifi_dbg,
 #define TRACE_SYSTEM iwlwifi
 
 TRACE_EVENT(iwlwifi_dev_hcmd,
-	TP_PROTO(const struct device *dev, u32 flags,
-		 const void *hcmd0, size_t len0,
-		 const void *hcmd1, size_t len1,
-		 const void *hcmd2, size_t len2),
-	TP_ARGS(dev, flags, hcmd0, len0, hcmd1, len1, hcmd2, len2),
+	TP_PROTO(const struct device *dev,
+		 struct iwl_host_cmd *cmd, u16 total_size,
+		 const void *hdr, size_t hdr_len),
+	TP_ARGS(dev, cmd, total_size, hdr, hdr_len),
 	TP_STRUCT__entry(
 		DEV_ENTRY
-		__dynamic_array(u8, hcmd0, len0)
-		__dynamic_array(u8, hcmd1, len1)
-		__dynamic_array(u8, hcmd2, len2)
+		__dynamic_array(u8, hcmd, total_size)
 		__field(u32, flags)
 	),
 	TP_fast_assign(
+		int i, offset = hdr_len;
+
 		DEV_ASSIGN;
-		memcpy(__get_dynamic_array(hcmd0), hcmd0, len0);
-		memcpy(__get_dynamic_array(hcmd1), hcmd1, len1);
-		memcpy(__get_dynamic_array(hcmd2), hcmd2, len2);
-		__entry->flags = flags;
+		__entry->flags = cmd->flags;
+		memcpy(__get_dynamic_array(hcmd), hdr, hdr_len);
+
+		for (i = 0; i < IWL_MAX_CMD_TFDS; i++) {
+			if (!cmd->len[i])
+				continue;
+			if (!(cmd->dataflags[i] & IWL_HCMD_DFL_NOCOPY))
+				continue;
+			memcpy((u8 *)__get_dynamic_array(hcmd) + offset,
+			       cmd->data[i], cmd->len[i]);
+			offset += cmd->len[i];
+		}
 	),
 	TP_printk("[%s] hcmd %#.2x (%ssync)",
-		  __get_str(dev), ((u8 *)__get_dynamic_array(hcmd0))[0],
+		  __get_str(dev), ((u8 *)__get_dynamic_array(hcmd))[0],
 		  __entry->flags & CMD_ASYNC ? "a" : "")
 );
 
diff --git a/drivers/net/wireless/iwlwifi/pcie/tx.c b/drivers/net/wireless/iwlwifi/pcie/tx.c
index 392d2bc..105e3af 100644
--- a/drivers/net/wireless/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/tx.c
@@ -522,11 +522,6 @@ static int iwl_enqueue_hcmd(struct iwl_trans *trans, struct iwl_host_cmd *cmd)
 	bool had_nocopy = false;
 	int i;
 	u32 cmd_pos;
-#ifdef CONFIG_IWLWIFI_DEVICE_TRACING
-	const void *trace_bufs[IWL_MAX_CMD_TFDS + 1] = {};
-	int trace_lens[IWL_MAX_CMD_TFDS + 1] = {};
-	int trace_idx;
-#endif
 
 	copy_size = sizeof(out_cmd->hdr);
 	cmd_size = sizeof(out_cmd->hdr);
@@ -628,11 +623,6 @@ static int iwl_enqueue_hcmd(struct iwl_trans *trans, struct iwl_host_cmd *cmd)
 	dma_unmap_len_set(out_meta, len, copy_size);
 
 	iwlagn_txq_attach_buf_to_tfd(trans, txq, phys_addr, copy_size, 1);
-#ifdef CONFIG_IWLWIFI_DEVICE_TRACING
-	trace_bufs[0] = &out_cmd->hdr;
-	trace_lens[0] = copy_size;
-	trace_idx = 1;
-#endif
 
 	for (i = 0; i < IWL_MAX_CMD_TFDS; i++) {
 		if (!cmd->len[i])
@@ -651,25 +641,14 @@ static int iwl_enqueue_hcmd(struct iwl_trans *trans, struct iwl_host_cmd *cmd)
 
 		iwlagn_txq_attach_buf_to_tfd(trans, txq, phys_addr,
 					     cmd->len[i], 0);
-#ifdef CONFIG_IWLWIFI_DEVICE_TRACING
-		trace_bufs[trace_idx] = cmd->data[i];
-		trace_lens[trace_idx] = cmd->len[i];
-		trace_idx++;
-#endif
 	}
 
 	out_meta->flags = cmd->flags;
 
 	txq->need_update = 1;
 
-	/* check that tracing gets all possible blocks */
-	BUILD_BUG_ON(IWL_MAX_CMD_TFDS + 1 != 3);
-#ifdef CONFIG_IWLWIFI_DEVICE_TRACING
-	trace_iwlwifi_dev_hcmd(trans->dev, cmd->flags,
-			       trace_bufs[0], trace_lens[0],
-			       trace_bufs[1], trace_lens[1],
-			       trace_bufs[2], trace_lens[2]);
-#endif
+	trace_iwlwifi_dev_hcmd(trans->dev, cmd, cmd_size,
+			       &out_cmd->hdr, copy_size);
 
 	/* start timer if queue currently empty */
 	if (q->read_ptr == q->write_ptr && trans_pcie->wd_timeout)
-- 
1.7.10.4

