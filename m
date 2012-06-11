Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48522 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572Ab2FKJxd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jun 2012 05:53:33 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Ilan Peer <ilan.peer@intel.com>
Subject: [PATCH 02/13] iwlwifi: decouple testmode and iwl-test
Date: Mon, 11 Jun 2012 11:53:01 +0200
Message-Id: <1339408392-19425-3-git-send-email-johannes@sipsolutions.net> (sfid-20120611_115342_077163_32324A6D)
In-Reply-To: <1339408392-19425-1-git-send-email-johannes@sipsolutions.net>
References: <1339408392-19425-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ilan Peer <ilan.peer@intel.com>

The iwl-test flows were based on the cfg80211 testmode APIs.

To remove this coupling, the op mode (during the initialization
of the iwl_test object) is responsible to set the callbacks that
should be used by iwl-test to allocate skbs for events and replies
and to send events and replies.

The current op modes implement these callbacks based on the cfg80211
testmode APIs.

Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/rx.c       |    2 +-
 drivers/net/wireless/iwlwifi/dvm/testmode.c |   31 +++++++-
 drivers/net/wireless/iwlwifi/iwl-test.c     |  109 +++++++++++++++++----------
 drivers/net/wireless/iwlwifi/iwl-test.h     |   44 ++++++++++-
 4 files changed, 141 insertions(+), 45 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/rx.c b/drivers/net/wireless/iwlwifi/dvm/rx.c
index afdacb2..c1f7a18 100644
--- a/drivers/net/wireless/iwlwifi/dvm/rx.c
+++ b/drivers/net/wireless/iwlwifi/dvm/rx.c
@@ -1143,7 +1143,7 @@ int iwl_rx_dispatch(struct iwl_op_mode *op_mode, struct iwl_rx_cmd_buffer *rxb,
 	 * Note that if the ownership flag != IWL_OWNERSHIP_TM the flow
 	 * continues.
 	 */
-	iwl_test_rx(&priv->tst, priv->hw, rxb);
+	iwl_test_rx(&priv->tst, rxb);
 #endif
 
 	if (priv->ucode_owner != IWL_OWNERSHIP_TM) {
diff --git a/drivers/net/wireless/iwlwifi/dvm/testmode.c b/drivers/net/wireless/iwlwifi/dvm/testmode.c
index aa9518f..57b918c 100644
--- a/drivers/net/wireless/iwlwifi/dvm/testmode.c
+++ b/drivers/net/wireless/iwlwifi/dvm/testmode.c
@@ -103,10 +103,39 @@ static u32 iwl_testmode_get_fw_ver(struct iwl_op_mode *op_mode)
 	return priv->fw->ucode_ver;
 }
 
+static struct sk_buff*
+iwl_testmode_alloc_reply(struct iwl_op_mode *op_mode, int len)
+{
+	struct iwl_priv *priv = IWL_OP_MODE_GET_DVM(op_mode);
+	return cfg80211_testmode_alloc_reply_skb(priv->hw->wiphy, len);
+}
+
+static int iwl_testmode_reply(struct iwl_op_mode *op_mode, struct sk_buff *skb)
+{
+	return cfg80211_testmode_reply(skb);
+}
+
+static struct sk_buff *iwl_testmode_alloc_event(struct iwl_op_mode *op_mode,
+						int len)
+{
+	struct iwl_priv *priv = IWL_OP_MODE_GET_DVM(op_mode);
+	return cfg80211_testmode_alloc_event_skb(priv->hw->wiphy, len,
+						 GFP_ATOMIC);
+}
+
+static void iwl_testmode_event(struct iwl_op_mode *op_mode, struct sk_buff *skb)
+{
+	return cfg80211_testmode_event(skb, GFP_ATOMIC);
+}
+
 static struct iwl_test_ops tst_ops = {
 	.send_cmd = iwl_testmode_send_cmd,
 	.valid_hw_addr = iwl_testmode_valid_hw_addr,
 	.get_fw_ver = iwl_testmode_get_fw_ver,
+	.alloc_reply = iwl_testmode_alloc_reply,
+	.reply = iwl_testmode_reply,
+	.alloc_event = iwl_testmode_alloc_event,
+	.event = iwl_testmode_event,
 };
 
 void iwl_testmode_init(struct iwl_priv *priv)
@@ -380,7 +409,7 @@ int iwlagn_mac_testmode_cmd(struct ieee80211_hw *hw, void *data, int len)
 	case IWL_TM_CMD_APP2DEV_GET_FW_VERSION:
 	case IWL_TM_CMD_APP2DEV_GET_DEVICE_ID:
 	case IWL_TM_CMD_APP2DEV_INDIRECT_BUFFER_WRITE:
-		result = iwl_test_handle_cmd(&priv->tst, hw, tb);
+		result = iwl_test_handle_cmd(&priv->tst, tb);
 		break;
 
 	case IWL_TM_CMD_APP2DEV_GET_DEVICENAME:
diff --git a/drivers/net/wireless/iwlwifi/iwl-test.c b/drivers/net/wireless/iwlwifi/iwl-test.c
index 76e1863..7a264ae 100644
--- a/drivers/net/wireless/iwlwifi/iwl-test.c
+++ b/drivers/net/wireless/iwlwifi/iwl-test.c
@@ -61,7 +61,9 @@
  *
  *****************************************************************************/
 
+#include <linux/export.h>
 #include <net/netlink.h>
+
 #include "iwl-io.h"
 #include "iwl-fh.h"
 #include "iwl-prph.h"
@@ -178,13 +180,51 @@ void iwl_test_free(struct iwl_test *tst)
 }
 EXPORT_SYMBOL_GPL(iwl_test_free);
 
+static inline int iwl_test_send_cmd(struct iwl_test *tst,
+				    struct iwl_host_cmd *cmd)
+{
+	return tst->ops->send_cmd(tst->trans->op_mode, cmd);
+}
+
+static inline bool iwl_test_valid_hw_addr(struct iwl_test *tst, u32 addr)
+{
+	return tst->ops->valid_hw_addr(addr);
+}
+
+static inline u32 iwl_test_fw_ver(struct iwl_test *tst)
+{
+	return tst->ops->get_fw_ver(tst->trans->op_mode);
+}
+
+static inline struct sk_buff*
+iwl_test_alloc_reply(struct iwl_test *tst, int len)
+{
+	return tst->ops->alloc_reply(tst->trans->op_mode, len);
+}
+
+static inline int iwl_test_reply(struct iwl_test *tst, struct sk_buff *skb)
+{
+	return tst->ops->reply(tst->trans->op_mode, skb);
+}
+
+static inline struct sk_buff*
+iwl_test_alloc_event(struct iwl_test *tst, int len)
+{
+	return tst->ops->alloc_event(tst->trans->op_mode, len);
+}
+
+static inline void
+iwl_test_event(struct iwl_test *tst, struct sk_buff *skb)
+{
+	return tst->ops->event(tst->trans->op_mode, skb);
+}
+
 /*
  * This function handles the user application commands to the fw. The fw
  * commands are sent in a synchronuous manner. In case that the user requested
  * to get commands response, it is send to the user.
  */
-static int iwl_test_fw_cmd(struct iwl_test *tst, struct ieee80211_hw *hw,
-			   struct nlattr **tb)
+static int iwl_test_fw_cmd(struct iwl_test *tst, struct nlattr **tb)
 {
 	struct iwl_host_cmd cmd;
 	struct iwl_rx_packet *pkt;
@@ -214,7 +254,7 @@ static int iwl_test_fw_cmd(struct iwl_test *tst, struct ieee80211_hw *hw,
 	IWL_DEBUG_INFO(tst->trans, "test fw cmd=0x%x, flags 0x%x, len %d\n",
 		       cmd.id, cmd.flags, cmd.len[0]);
 
-	ret = tst->ops->send_cmd(tst->trans->op_mode, &cmd);
+	ret = iwl_test_send_cmd(tst, &cmd);
 	if (ret) {
 		IWL_ERR(tst->trans, "Failed to send hcmd\n");
 		return ret;
@@ -230,7 +270,7 @@ static int iwl_test_fw_cmd(struct iwl_test *tst, struct ieee80211_hw *hw,
 	}
 
 	reply_len = le32_to_cpu(pkt->len_n_flags) & FH_RSCSR_FRAME_SIZE_MSK;
-	skb = cfg80211_testmode_alloc_reply_skb(hw->wiphy, reply_len + 20);
+	skb = iwl_test_alloc_reply(tst, reply_len + 20);
 	reply_buf = kmalloc(reply_len, GFP_KERNEL);
 	if (!skb || !reply_buf) {
 		kfree_skb(skb);
@@ -246,7 +286,7 @@ static int iwl_test_fw_cmd(struct iwl_test *tst, struct ieee80211_hw *hw,
 			IWL_TM_CMD_DEV2APP_UCODE_RX_PKT) ||
 	    nla_put(skb, IWL_TM_ATTR_UCODE_RX_PKT, reply_len, reply_buf))
 		goto nla_put_failure;
-	return cfg80211_testmode_reply(skb);
+	return iwl_test_reply(tst, skb);
 
 nla_put_failure:
 	IWL_DEBUG_INFO(tst->trans, "Failed creating NL attributes\n");
@@ -258,8 +298,7 @@ nla_put_failure:
 /*
  * Handles the user application commands for register access.
  */
-static int iwl_test_reg(struct iwl_test *tst, struct ieee80211_hw *hw,
-			struct nlattr **tb)
+static int iwl_test_reg(struct iwl_test *tst, struct nlattr **tb)
 {
 	u32 ofs, val32, cmd;
 	u8 val8;
@@ -293,14 +332,14 @@ static int iwl_test_reg(struct iwl_test *tst, struct ieee80211_hw *hw,
 		val32 = iwl_read_direct32(tst->trans, ofs);
 		IWL_DEBUG_INFO(trans, "32 value to read 0x%x\n", val32);
 
-		skb = cfg80211_testmode_alloc_reply_skb(hw->wiphy, 20);
+		skb = iwl_test_alloc_reply(tst, 20);
 		if (!skb) {
 			IWL_ERR(trans, "Memory allocation fail\n");
 			return -ENOMEM;
 		}
 		if (nla_put_u32(skb, IWL_TM_ATTR_REG_VALUE32, val32))
 			goto nla_put_failure;
-		status = cfg80211_testmode_reply(skb);
+		status = iwl_test_reply(tst, skb);
 		if (status < 0)
 			IWL_ERR(trans, "Error sending msg : %d\n", status);
 		break;
@@ -343,8 +382,7 @@ nla_put_failure:
  * Handles the request to start FW tracing. Allocates of the trace buffer
  * and sends a reply to user space with the address of the allocated buffer.
  */
-static int iwl_test_trace_begin(struct iwl_test *tst, struct ieee80211_hw *hw,
-				struct nlattr **tb)
+static int iwl_test_trace_begin(struct iwl_test *tst, struct nlattr **tb)
 {
 	struct sk_buff *skb;
 	int status = 0;
@@ -378,9 +416,7 @@ static int iwl_test_trace_begin(struct iwl_test *tst, struct ieee80211_hw *hw,
 
 	memset(tst->trace.trace_addr, 0x03B, tst->trace.size);
 
-	skb = cfg80211_testmode_alloc_reply_skb(hw->wiphy,
-			sizeof(tst->trace.dma_addr) + 20);
-
+	skb = iwl_test_alloc_reply(tst, sizeof(tst->trace.dma_addr) + 20);
 	if (!skb) {
 		IWL_ERR(tst->trans, "Memory allocation fail\n");
 		iwl_test_trace_stop(tst);
@@ -392,7 +428,7 @@ static int iwl_test_trace_begin(struct iwl_test *tst, struct ieee80211_hw *hw,
 		    (u64 *)&tst->trace.dma_addr))
 		goto nla_put_failure;
 
-	status = cfg80211_testmode_reply(skb);
+	status = iwl_test_reply(tst, skb);
 	if (status < 0)
 		IWL_ERR(tst->trans, "Error sending msg : %d\n", status);
 
@@ -485,7 +521,7 @@ static int iwl_test_indirect_write(struct iwl_test *tst, u32 addr,
 					iwl_write_prph(trans, addr+i,
 						       *(u32 *)(buf+i));
 			}
-	} else if (tst->ops->valid_hw_addr(addr)) {
+	} else if (iwl_test_valid_hw_addr(tst, addr)) {
 		_iwl_write_targ_mem_words(trans, addr, buf, size/4);
 	} else {
 		return -EINVAL;
@@ -541,8 +577,7 @@ static int iwl_test_notifications(struct iwl_test *tst,
 /*
  * Handles the request to get the device id
  */
-static int iwl_test_get_dev_id(struct iwl_test *tst, struct ieee80211_hw *hw,
-			       struct nlattr **tb)
+static int iwl_test_get_dev_id(struct iwl_test *tst, struct nlattr **tb)
 {
 	u32 devid = tst->trans->hw_id;
 	struct sk_buff *skb;
@@ -550,7 +585,7 @@ static int iwl_test_get_dev_id(struct iwl_test *tst, struct ieee80211_hw *hw,
 
 	IWL_DEBUG_INFO(tst->trans, "hw version: 0x%x\n", devid);
 
-	skb = cfg80211_testmode_alloc_reply_skb(hw->wiphy, 20);
+	skb = iwl_test_alloc_reply(tst, 20);
 	if (!skb) {
 		IWL_ERR(tst->trans, "Memory allocation fail\n");
 		return -ENOMEM;
@@ -558,7 +593,7 @@ static int iwl_test_get_dev_id(struct iwl_test *tst, struct ieee80211_hw *hw,
 
 	if (nla_put_u32(skb, IWL_TM_ATTR_DEVICE_ID, devid))
 		goto nla_put_failure;
-	status = cfg80211_testmode_reply(skb);
+	status = iwl_test_reply(tst, skb);
 	if (status < 0)
 		IWL_ERR(tst->trans, "Error sending msg : %d\n", status);
 
@@ -572,16 +607,15 @@ nla_put_failure:
 /*
  * Handles the request to get the FW version
  */
-static int iwl_test_get_fw_ver(struct iwl_test *tst, struct ieee80211_hw *hw,
-			       struct nlattr **tb)
+static int iwl_test_get_fw_ver(struct iwl_test *tst, struct nlattr **tb)
 {
 	struct sk_buff *skb;
 	int status;
-	u32 ver = tst->ops->get_fw_ver(tst->trans->op_mode);
+	u32 ver = iwl_test_fw_ver(tst);
 
 	IWL_DEBUG_INFO(tst->trans, "uCode version raw: 0x%x\n", ver);
 
-	skb = cfg80211_testmode_alloc_reply_skb(hw->wiphy, 20);
+	skb = iwl_test_alloc_reply(tst, 20);
 	if (!skb) {
 		IWL_ERR(tst->trans, "Memory allocation fail\n");
 		return -ENOMEM;
@@ -590,7 +624,7 @@ static int iwl_test_get_fw_ver(struct iwl_test *tst, struct ieee80211_hw *hw,
 	if (nla_put_u32(skb, IWL_TM_ATTR_FW_VERSION, ver))
 		goto nla_put_failure;
 
-	status = cfg80211_testmode_reply(skb);
+	status = iwl_test_reply(tst, skb);
 	if (status < 0)
 		IWL_ERR(tst->trans, "Error sending msg : %d\n", status);
 
@@ -630,27 +664,26 @@ EXPORT_SYMBOL_GPL(iwl_test_parse);
  * Returns 1 for unknown commands (not handled by the test object); negative
  * value in case of error.
  */
-int iwl_test_handle_cmd(struct iwl_test *tst, struct ieee80211_hw *hw,
-			struct nlattr **tb)
+int iwl_test_handle_cmd(struct iwl_test *tst, struct nlattr **tb)
 {
 	int result;
 
 	switch (nla_get_u32(tb[IWL_TM_ATTR_COMMAND])) {
 	case IWL_TM_CMD_APP2DEV_UCODE:
 		IWL_DEBUG_INFO(tst->trans, "test cmd to uCode\n");
-		result = iwl_test_fw_cmd(tst, hw, tb);
+		result = iwl_test_fw_cmd(tst, tb);
 		break;
 
 	case IWL_TM_CMD_APP2DEV_DIRECT_REG_READ32:
 	case IWL_TM_CMD_APP2DEV_DIRECT_REG_WRITE32:
 	case IWL_TM_CMD_APP2DEV_DIRECT_REG_WRITE8:
 		IWL_DEBUG_INFO(tst->trans, "test cmd to register\n");
-		result = iwl_test_reg(tst, hw, tb);
+		result = iwl_test_reg(tst, tb);
 		break;
 
 	case IWL_TM_CMD_APP2DEV_BEGIN_TRACE:
 		IWL_DEBUG_INFO(tst->trans, "test uCode trace cmd to driver\n");
-		result = iwl_test_trace_begin(tst, hw, tb);
+		result = iwl_test_trace_begin(tst, tb);
 		break;
 
 	case IWL_TM_CMD_APP2DEV_END_TRACE:
@@ -671,12 +704,12 @@ int iwl_test_handle_cmd(struct iwl_test *tst, struct ieee80211_hw *hw,
 
 	case IWL_TM_CMD_APP2DEV_GET_FW_VERSION:
 		IWL_DEBUG_INFO(tst->trans, "test get FW ver cmd\n");
-		result = iwl_test_get_fw_ver(tst, hw, tb);
+		result = iwl_test_get_fw_ver(tst, tb);
 		break;
 
 	case IWL_TM_CMD_APP2DEV_GET_DEVICE_ID:
 		IWL_DEBUG_INFO(tst->trans, "test Get device ID cmd\n");
-		result = iwl_test_get_dev_id(tst, hw, tb);
+		result = iwl_test_get_dev_id(tst, tb);
 		break;
 
 	default:
@@ -779,7 +812,7 @@ EXPORT_SYMBOL_GPL(iwl_test_dump);
 /*
  * Multicast a spontaneous messages from the device to the user space.
  */
-static void iwl_test_send_rx(struct iwl_test *tst, struct ieee80211_hw *hw,
+static void iwl_test_send_rx(struct iwl_test *tst,
 			     struct iwl_rx_cmd_buffer *rxb)
 {
 	struct sk_buff *skb;
@@ -792,8 +825,7 @@ static void iwl_test_send_rx(struct iwl_test *tst, struct ieee80211_hw *hw,
 	/* the length doesn't include len_n_flags field, so add it manually */
 	length += sizeof(__le32);
 
-	skb = cfg80211_testmode_alloc_event_skb(hw->wiphy, 20 + length,
-								GFP_ATOMIC);
+	skb = iwl_test_alloc_event(tst, length + 20);
 	if (skb == NULL) {
 		IWL_ERR(tst->trans, "Out of memory for message to user\n");
 		return;
@@ -804,7 +836,7 @@ static void iwl_test_send_rx(struct iwl_test *tst, struct ieee80211_hw *hw,
 	    nla_put(skb, IWL_TM_ATTR_UCODE_RX_PKT, length, data))
 		goto nla_put_failure;
 
-	cfg80211_testmode_event(skb, GFP_ATOMIC);
+	iwl_test_event(tst, skb);
 	return;
 
 nla_put_failure:
@@ -816,10 +848,9 @@ nla_put_failure:
  * Called whenever a Rx frames is recevied from the device. If notifications to
  * the user space are requested, sends the frames to the user.
  */
-void iwl_test_rx(struct iwl_test *tst, struct ieee80211_hw *hw,
-		 struct iwl_rx_cmd_buffer *rxb)
+void iwl_test_rx(struct iwl_test *tst, struct iwl_rx_cmd_buffer *rxb)
 {
 	if (tst->notify)
-		iwl_test_send_rx(tst, hw, rxb);
+		iwl_test_send_rx(tst, rxb);
 }
 EXPORT_SYMBOL_GPL(iwl_test_rx);
diff --git a/drivers/net/wireless/iwlwifi/iwl-test.h b/drivers/net/wireless/iwlwifi/iwl-test.h
index 9946153..e13ffa8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-test.h
+++ b/drivers/net/wireless/iwlwifi/iwl-test.h
@@ -84,11 +84,49 @@ struct iwl_test_mem {
 	bool in_read;
 };
 
+/*
+ * struct iwl_test_ops: callback to the op mode
+ *
+ * The structure defines the callbacks that the op_mode should handle,
+ * inorder to handle logic that is out of the scope of iwl_test. The
+ * op_mode must set all the callbacks.
+
+ * @send_cmd: handler that is used by the test object to request the
+ *  op_mode to send a command to the fw.
+ *
+ * @valid_hw_addr: handler that is used by the test object to request the
+ *  op_mode to check if the given address is a valid address.
+ *
+ * @get_fw_ver: handler used to get the FW version.
+ *
+ * @alloc_reply: handler used by the test object to request the op_mode
+ *  to allocate an skb for sending a reply to the user, and initialize
+ *  the skb. It is assumed that the test object only fills the required
+ *  attributes.
+ *
+ * @reply: handler used by the test object to request the op_mode to reply
+ *  to a request. The skb is an skb previously allocated by the the
+ *  alloc_reply callback.
+ I
+ * @alloc_event: handler used by the test object to request the op_mode
+ *  to allocate an skb for sending an event, and initialize
+ *  the skb. It is assumed that the test object only fills the required
+ *  attributes.
+ *
+ * @reply: handler used by the test object to request the op_mode to send
+ *  an event. The skb is an skb previously allocated by the the
+ *  alloc_event callback.
+ */
 struct iwl_test_ops {
 	int (*send_cmd)(struct iwl_op_mode *op_modes,
 			struct iwl_host_cmd *cmd);
 	bool (*valid_hw_addr)(u32 addr);
 	u32 (*get_fw_ver)(struct iwl_op_mode *op_mode);
+
+	struct sk_buff *(*alloc_reply)(struct iwl_op_mode *op_mode, int len);
+	int (*reply)(struct iwl_op_mode *op_mode, struct sk_buff *skb);
+	struct sk_buff* (*alloc_event)(struct iwl_op_mode *op_mode, int len);
+	void (*event)(struct iwl_op_mode *op_mode, struct sk_buff *skb);
 };
 
 struct iwl_test {
@@ -107,14 +145,12 @@ void iwl_test_free(struct iwl_test *tst);
 int iwl_test_parse(struct iwl_test *tst, struct nlattr **tb,
 		   void *data, int len);
 
-int iwl_test_handle_cmd(struct iwl_test *tst, struct ieee80211_hw *hw,
-			struct nlattr **tb);
+int iwl_test_handle_cmd(struct iwl_test *tst, struct nlattr **tb);
 
 int iwl_test_dump(struct iwl_test *tst, u32 cmd, struct sk_buff *skb,
 		  struct netlink_callback *cb);
 
-void iwl_test_rx(struct iwl_test *tst, struct ieee80211_hw *hw,
-		 struct iwl_rx_cmd_buffer *rxb);
+void iwl_test_rx(struct iwl_test *tst, struct iwl_rx_cmd_buffer *rxb);
 
 static inline void iwl_test_enable_notifications(struct iwl_test *tst,
 						 bool enable)
-- 
1.7.10

