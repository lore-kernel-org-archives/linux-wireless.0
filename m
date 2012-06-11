Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48518 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319Ab2FKJxd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jun 2012 05:53:33 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Ilan Peer <ilan.peer@intel.com>
Subject: [PATCH 01/13] iwlwifi: refactor testmode
Date: Mon, 11 Jun 2012 11:53:00 +0200
Message-Id: <1339408392-19425-2-git-send-email-johannes@sipsolutions.net> (sfid-20120611_115343_836367_FFBE6E1C)
In-Reply-To: <1339408392-19425-1-git-send-email-johannes@sipsolutions.net>
References: <1339408392-19425-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ilan Peer <ilan.peer@intel.com>

Create an object that will enacpsulate the testmode functionality
that is common to all op modes.

 * Copy definitions from dvm/dev.h
 * Copy the testmode logic from dvm/testmode.c
 * Link iwl-test object into the iwlwifi module
 * Modify DVM to use iwl-test object

Reviewed-by: Amit Beka <amit.beka@intel.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/Makefile              |    1 +
 drivers/net/wireless/iwlwifi/dvm/agn.h             |   17 +-
 drivers/net/wireless/iwlwifi/dvm/dev.h             |   26 +-
 drivers/net/wireless/iwlwifi/dvm/main.c            |    2 +-
 drivers/net/wireless/iwlwifi/dvm/rx.c              |   24 +-
 drivers/net/wireless/iwlwifi/dvm/testmode.c        |  769 ++----------------
 drivers/net/wireless/iwlwifi/iwl-test.c            |  825 ++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-test.h            |  125 +++
 .../iwlwifi/{dvm/testmode.h => iwl-testmode.h}     |    0
 9 files changed, 1027 insertions(+), 762 deletions(-)
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-test.c
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-test.h
 rename drivers/net/wireless/iwlwifi/{dvm/testmode.h => iwl-testmode.h} (100%)

diff --git a/drivers/net/wireless/iwlwifi/Makefile b/drivers/net/wireless/iwlwifi/Makefile
index 98c8f64..afa9758 100644
--- a/drivers/net/wireless/iwlwifi/Makefile
+++ b/drivers/net/wireless/iwlwifi/Makefile
@@ -13,5 +13,6 @@ iwlwifi-objs		+= pcie/drv.o pcie/rx.o pcie/tx.o pcie/trans.o
 iwlwifi-objs		+= pcie/1000.o pcie/2000.o pcie/5000.o pcie/6000.o
 
 iwlwifi-$(CONFIG_IWLWIFI_DEVICE_TRACING) += iwl-devtrace.o
+iwlwifi-$(CONFIG_IWLWIFI_DEVICE_TESTMODE) += iwl-test.o
 
 ccflags-y += -D__CHECK_ENDIAN__ -I$(src)
diff --git a/drivers/net/wireless/iwlwifi/dvm/agn.h b/drivers/net/wireless/iwlwifi/dvm/agn.h
index 2ae3608..6d10241 100644
--- a/drivers/net/wireless/iwlwifi/dvm/agn.h
+++ b/drivers/net/wireless/iwlwifi/dvm/agn.h
@@ -395,8 +395,10 @@ static inline __le32 iwl_hw_set_rate_n_flags(u8 rate, u32 flags)
 }
 
 extern int iwl_alive_start(struct iwl_priv *priv);
-/* svtool */
+
+/* testmode support */
 #ifdef CONFIG_IWLWIFI_DEVICE_TESTMODE
+
 extern int iwlagn_mac_testmode_cmd(struct ieee80211_hw *hw, void *data,
 				   int len);
 extern int iwlagn_mac_testmode_dump(struct ieee80211_hw *hw,
@@ -404,13 +406,16 @@ extern int iwlagn_mac_testmode_dump(struct ieee80211_hw *hw,
 				    struct netlink_callback *cb,
 				    void *data, int len);
 extern void iwl_testmode_init(struct iwl_priv *priv);
-extern void iwl_testmode_cleanup(struct iwl_priv *priv);
+extern void iwl_testmode_free(struct iwl_priv *priv);
+
 #else
+
 static inline
 int iwlagn_mac_testmode_cmd(struct ieee80211_hw *hw, void *data, int len)
 {
 	return -ENOSYS;
 }
+
 static inline
 int iwlagn_mac_testmode_dump(struct ieee80211_hw *hw, struct sk_buff *skb,
 		      struct netlink_callback *cb,
@@ -418,12 +423,12 @@ int iwlagn_mac_testmode_dump(struct ieee80211_hw *hw, struct sk_buff *skb,
 {
 	return -ENOSYS;
 }
-static inline
-void iwl_testmode_init(struct iwl_priv *priv)
+
+static inline void iwl_testmode_init(struct iwl_priv *priv)
 {
 }
-static inline
-void iwl_testmode_cleanup(struct iwl_priv *priv)
+
+static inline void iwl_testmode_free(struct iwl_priv *priv)
 {
 }
 #endif
diff --git a/drivers/net/wireless/iwlwifi/dvm/dev.h b/drivers/net/wireless/iwlwifi/dvm/dev.h
index 89f2e10..4620b65 100644
--- a/drivers/net/wireless/iwlwifi/dvm/dev.h
+++ b/drivers/net/wireless/iwlwifi/dvm/dev.h
@@ -52,6 +52,8 @@
 #include "rs.h"
 #include "tt.h"
 
+#include "iwl-test.h"
+
 /* CT-KILL constants */
 #define CT_KILL_THRESHOLD_LEGACY   110 /* in Celsius */
 #define CT_KILL_THRESHOLD	   114 /* in Celsius */
@@ -596,24 +598,6 @@ struct iwl_lib_ops {
 	void (*temperature)(struct iwl_priv *priv);
 };
 
-#ifdef CONFIG_IWLWIFI_DEVICE_TESTMODE
-struct iwl_testmode_trace {
-	u32 buff_size;
-	u32 total_size;
-	u32 num_chunks;
-	u8 *cpu_addr;
-	u8 *trace_addr;
-	dma_addr_t dma_addr;
-	bool trace_enabled;
-};
-struct iwl_testmode_mem {
-	u32 buff_size;
-	u32 num_chunks;
-	u8 *buff_addr;
-	bool read_in_progress;
-};
-#endif
-
 struct iwl_wipan_noa_data {
 	struct rcu_head rcu_head;
 	u32 length;
@@ -670,8 +654,6 @@ struct iwl_priv {
 	enum ieee80211_band band;
 	u8 valid_contexts;
 
-	void (*pre_rx_handler)(struct iwl_priv *priv,
-			       struct iwl_rx_cmd_buffer *rxb);
 	int (*rx_handlers[REPLY_MAX])(struct iwl_priv *priv,
 				       struct iwl_rx_cmd_buffer *rxb,
 				       struct iwl_device_cmd *cmd);
@@ -895,9 +877,9 @@ struct iwl_priv {
 	struct led_classdev led;
 	unsigned long blink_on, blink_off;
 	bool led_registered;
+
 #ifdef CONFIG_IWLWIFI_DEVICE_TESTMODE
-	struct iwl_testmode_trace testmode_trace;
-	struct iwl_testmode_mem testmode_mem;
+	struct iwl_test tst;
 	u32 tm_fixed_rate;
 #endif
 
diff --git a/drivers/net/wireless/iwlwifi/dvm/main.c b/drivers/net/wireless/iwlwifi/dvm/main.c
index 1c2d023..656ed31 100644
--- a/drivers/net/wireless/iwlwifi/dvm/main.c
+++ b/drivers/net/wireless/iwlwifi/dvm/main.c
@@ -1548,7 +1548,7 @@ static void iwl_op_mode_dvm_stop(struct iwl_op_mode *op_mode)
 
 	iwl_dbgfs_unregister(priv);
 
-	iwl_testmode_cleanup(priv);
+	iwl_testmode_free(priv);
 	iwlagn_mac_unregister(priv);
 
 	iwl_tt_exit(priv);
diff --git a/drivers/net/wireless/iwlwifi/dvm/rx.c b/drivers/net/wireless/iwlwifi/dvm/rx.c
index 0ed90bb8..afdacb2 100644
--- a/drivers/net/wireless/iwlwifi/dvm/rx.c
+++ b/drivers/net/wireless/iwlwifi/dvm/rx.c
@@ -1124,8 +1124,6 @@ int iwl_rx_dispatch(struct iwl_op_mode *op_mode, struct iwl_rx_cmd_buffer *rxb,
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	struct iwl_priv *priv = IWL_OP_MODE_GET_DVM(op_mode);
-	void (*pre_rx_handler)(struct iwl_priv *,
-			       struct iwl_rx_cmd_buffer *);
 	int err = 0;
 
 	/*
@@ -1135,19 +1133,19 @@ int iwl_rx_dispatch(struct iwl_op_mode *op_mode, struct iwl_rx_cmd_buffer *rxb,
 	 */
 	iwl_notification_wait_notify(&priv->notif_wait, pkt);
 
-	/* RX data may be forwarded to userspace (using pre_rx_handler) in one
-	 * of two cases: the first, that the user owns the uCode through
-	 * testmode - in such case the pre_rx_handler is set and no further
-	 * processing takes place. The other case is when the user want to
-	 * monitor the rx w/o affecting the regular flow - the pre_rx_handler
-	 * will be set but the ownership flag != IWL_OWNERSHIP_TM and the flow
+#ifdef CONFIG_IWLWIFI_DEVICE_TESTMODE
+	/*
+	 * RX data may be forwarded to userspace in one
+	 * of two cases: the user owns the fw through testmode or when
+	 * the user requested to monitor the rx w/o affecting the regular flow.
+	 * In these cases the iwl_test object will handle forwarding the rx
+	 * data to user space.
+	 * Note that if the ownership flag != IWL_OWNERSHIP_TM the flow
 	 * continues.
-	 * We need to use ACCESS_ONCE to prevent a case where the handler
-	 * changes between the check and the call.
 	 */
-	pre_rx_handler = ACCESS_ONCE(priv->pre_rx_handler);
-	if (pre_rx_handler)
-		pre_rx_handler(priv, rxb);
+	iwl_test_rx(&priv->tst, priv->hw, rxb);
+#endif
+
 	if (priv->ucode_owner != IWL_OWNERSHIP_TM) {
 		/* Based on type of command response or notification,
 		 *   handle those that need handling via function in
diff --git a/drivers/net/wireless/iwlwifi/dvm/testmode.c b/drivers/net/wireless/iwlwifi/dvm/testmode.c
index a7b5959..aa9518f 100644
--- a/drivers/net/wireless/iwlwifi/dvm/testmode.c
+++ b/drivers/net/wireless/iwlwifi/dvm/testmode.c
@@ -60,6 +60,7 @@
  * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
  *
  *****************************************************************************/
+
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
@@ -69,355 +70,55 @@
 #include <net/cfg80211.h>
 #include <net/mac80211.h>
 #include <net/netlink.h>
+
 #include "iwl-debug.h"
-#include "iwl-io.h"
 #include "iwl-trans.h"
-#include "iwl-fh.h"
-#include "iwl-prph.h"
 #include "dev.h"
 #include "agn.h"
-#include "testmode.h"
-
-
-/* Periphery registers absolute lower bound. This is used in order to
- * differentiate registery access through HBUS_TARG_PRPH_* and
- * HBUS_TARG_MEM_* accesses.
- */
-#define IWL_TM_ABS_PRPH_START (0xA00000)
-
-/* The TLVs used in the gnl message policy between the kernel module and
- * user space application. iwl_testmode_gnl_msg_policy is to be carried
- * through the NL80211_CMD_TESTMODE channel regulated by nl80211.
- * See testmode.h
- */
-static
-struct nla_policy iwl_testmode_gnl_msg_policy[IWL_TM_ATTR_MAX] = {
-	[IWL_TM_ATTR_COMMAND] = { .type = NLA_U32, },
-
-	[IWL_TM_ATTR_UCODE_CMD_ID] = { .type = NLA_U8, },
-	[IWL_TM_ATTR_UCODE_CMD_DATA] = { .type = NLA_UNSPEC, },
-
-	[IWL_TM_ATTR_REG_OFFSET] = { .type = NLA_U32, },
-	[IWL_TM_ATTR_REG_VALUE8] = { .type = NLA_U8, },
-	[IWL_TM_ATTR_REG_VALUE32] = { .type = NLA_U32, },
-
-	[IWL_TM_ATTR_SYNC_RSP] = { .type = NLA_UNSPEC, },
-	[IWL_TM_ATTR_UCODE_RX_PKT] = { .type = NLA_UNSPEC, },
+#include "iwl-test.h"
+#include "iwl-testmode.h"
 
-	[IWL_TM_ATTR_EEPROM] = { .type = NLA_UNSPEC, },
-
-	[IWL_TM_ATTR_TRACE_ADDR] = { .type = NLA_UNSPEC, },
-	[IWL_TM_ATTR_TRACE_DUMP] = { .type = NLA_UNSPEC, },
-	[IWL_TM_ATTR_TRACE_SIZE] = { .type = NLA_U32, },
-
-	[IWL_TM_ATTR_FIXRATE] = { .type = NLA_U32, },
-
-	[IWL_TM_ATTR_UCODE_OWNER] = { .type = NLA_U8, },
-
-	[IWL_TM_ATTR_MEM_ADDR] = { .type = NLA_U32, },
-	[IWL_TM_ATTR_BUFFER_SIZE] = { .type = NLA_U32, },
-	[IWL_TM_ATTR_BUFFER_DUMP] = { .type = NLA_UNSPEC, },
-
-	[IWL_TM_ATTR_FW_VERSION] = { .type = NLA_U32, },
-	[IWL_TM_ATTR_DEVICE_ID] = { .type = NLA_U32, },
-	[IWL_TM_ATTR_FW_TYPE] = { .type = NLA_U32, },
-	[IWL_TM_ATTR_FW_INST_SIZE] = { .type = NLA_U32, },
-	[IWL_TM_ATTR_FW_DATA_SIZE] = { .type = NLA_U32, },
-
-	[IWL_TM_ATTR_ENABLE_NOTIFICATION] = {.type = NLA_FLAG, },
-};
-
-/*
- * See the struct iwl_rx_packet in commands.h for the format of the
- * received events from the device
- */
-static inline int get_event_length(struct iwl_rx_cmd_buffer *rxb)
+static int iwl_testmode_send_cmd(struct iwl_op_mode *op_mode,
+				 struct iwl_host_cmd *cmd)
 {
-	struct iwl_rx_packet *pkt = rxb_addr(rxb);
-	if (pkt)
-		return le32_to_cpu(pkt->len_n_flags) & FH_RSCSR_FRAME_SIZE_MSK;
-	else
-		return 0;
+	struct iwl_priv *priv = IWL_OP_MODE_GET_DVM(op_mode);
+	return iwl_dvm_send_cmd(priv, cmd);
 }
 
-
-/*
- * This function multicasts the spontaneous messages from the device to the
- * user space. It is invoked whenever there is a received messages
- * from the device. This function is called within the ISR of the rx handlers
- * in iwlagn driver.
- *
- * The parsing of the message content is left to the user space application,
- * The message content is treated as unattacked raw data and is encapsulated
- * with IWL_TM_ATTR_UCODE_RX_PKT multicasting to the user space.
- *
- * @priv: the instance of iwlwifi device
- * @rxb: pointer to rx data content received by the ISR
- *
- * See the message policies and TLVs in iwl_testmode_gnl_msg_policy[].
- * For the messages multicasting to the user application, the mandatory
- * TLV fields are :
- *	IWL_TM_ATTR_COMMAND must be IWL_TM_CMD_DEV2APP_UCODE_RX_PKT
- *	IWL_TM_ATTR_UCODE_RX_PKT for carrying the message content
- */
-
-static void iwl_testmode_ucode_rx_pkt(struct iwl_priv *priv,
-				      struct iwl_rx_cmd_buffer *rxb)
+static bool iwl_testmode_valid_hw_addr(u32 addr)
 {
-	struct ieee80211_hw *hw = priv->hw;
-	struct sk_buff *skb;
-	void *data;
-	int length;
-
-	data = (void *)rxb_addr(rxb);
-	length = get_event_length(rxb);
+	if (iwlagn_hw_valid_rtc_data_addr(addr))
+		return true;
 
-	if (!data || length == 0)
-		return;
+	if (IWLAGN_RTC_INST_LOWER_BOUND <= addr &&
+	    addr < IWLAGN_RTC_INST_UPPER_BOUND)
+		return true;
 
-	skb = cfg80211_testmode_alloc_event_skb(hw->wiphy, 20 + length,
-								GFP_ATOMIC);
-	if (skb == NULL) {
-		IWL_ERR(priv,
-			 "Run out of memory for messages to user space ?\n");
-		return;
-	}
-	if (nla_put_u32(skb, IWL_TM_ATTR_COMMAND, IWL_TM_CMD_DEV2APP_UCODE_RX_PKT) ||
-	    /* the length doesn't include len_n_flags field, so add it manually */
-	    nla_put(skb, IWL_TM_ATTR_UCODE_RX_PKT, length + sizeof(__le32), data))
-		goto nla_put_failure;
-	cfg80211_testmode_event(skb, GFP_ATOMIC);
-	return;
-
-nla_put_failure:
-	kfree_skb(skb);
-	IWL_ERR(priv, "Ouch, overran buffer, check allocation!\n");
+	return false;
 }
 
-void iwl_testmode_init(struct iwl_priv *priv)
+static u32 iwl_testmode_get_fw_ver(struct iwl_op_mode *op_mode)
 {
-	priv->pre_rx_handler = NULL;
-	priv->testmode_trace.trace_enabled = false;
-	priv->testmode_mem.read_in_progress = false;
-}
-
-static void iwl_mem_cleanup(struct iwl_priv *priv)
-{
-	if (priv->testmode_mem.read_in_progress) {
-		kfree(priv->testmode_mem.buff_addr);
-		priv->testmode_mem.buff_addr = NULL;
-		priv->testmode_mem.buff_size = 0;
-		priv->testmode_mem.num_chunks = 0;
-		priv->testmode_mem.read_in_progress = false;
-	}
-}
-
-static void iwl_trace_cleanup(struct iwl_priv *priv)
-{
-	if (priv->testmode_trace.trace_enabled) {
-		if (priv->testmode_trace.cpu_addr &&
-		    priv->testmode_trace.dma_addr)
-			dma_free_coherent(priv->trans->dev,
-					priv->testmode_trace.total_size,
-					priv->testmode_trace.cpu_addr,
-					priv->testmode_trace.dma_addr);
-		priv->testmode_trace.trace_enabled = false;
-		priv->testmode_trace.cpu_addr = NULL;
-		priv->testmode_trace.trace_addr = NULL;
-		priv->testmode_trace.dma_addr = 0;
-		priv->testmode_trace.buff_size = 0;
-		priv->testmode_trace.total_size = 0;
-	}
-}
-
-
-void iwl_testmode_cleanup(struct iwl_priv *priv)
-{
-	iwl_trace_cleanup(priv);
-	iwl_mem_cleanup(priv);
+	struct iwl_priv *priv = IWL_OP_MODE_GET_DVM(op_mode);
+	return priv->fw->ucode_ver;
 }
 
+static struct iwl_test_ops tst_ops = {
+	.send_cmd = iwl_testmode_send_cmd,
+	.valid_hw_addr = iwl_testmode_valid_hw_addr,
+	.get_fw_ver = iwl_testmode_get_fw_ver,
+};
 
-/*
- * This function handles the user application commands to the ucode.
- *
- * It retrieves the mandatory fields IWL_TM_ATTR_UCODE_CMD_ID and
- * IWL_TM_ATTR_UCODE_CMD_DATA and calls to the handler to send the
- * host command to the ucode.
- *
- * If any mandatory field is missing, -ENOMSG is replied to the user space
- * application; otherwise, waits for the host command to be sent and checks
- * the return code. In case or error, it is returned, otherwise a reply is
- * allocated and the reply RX packet
- * is returned.
- *
- * @hw: ieee80211_hw object that represents the device
- * @tb: gnl message fields from the user space
- */
-static int iwl_testmode_ucode(struct ieee80211_hw *hw, struct nlattr **tb)
+void iwl_testmode_init(struct iwl_priv *priv)
 {
-	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
-	struct iwl_host_cmd cmd;
-	struct iwl_rx_packet *pkt;
-	struct sk_buff *skb;
-	void *reply_buf;
-	u32 reply_len;
-	int ret;
-	bool cmd_want_skb;
-
-	memset(&cmd, 0, sizeof(struct iwl_host_cmd));
-
-	if (!tb[IWL_TM_ATTR_UCODE_CMD_ID] ||
-	    !tb[IWL_TM_ATTR_UCODE_CMD_DATA]) {
-		IWL_ERR(priv, "Missing ucode command mandatory fields\n");
-		return -ENOMSG;
-	}
-
-	cmd.flags = CMD_ON_DEMAND | CMD_SYNC;
-	cmd_want_skb = nla_get_flag(tb[IWL_TM_ATTR_UCODE_CMD_SKB]);
-	if (cmd_want_skb)
-		cmd.flags |= CMD_WANT_SKB;
-
-	cmd.id = nla_get_u8(tb[IWL_TM_ATTR_UCODE_CMD_ID]);
-	cmd.data[0] = nla_data(tb[IWL_TM_ATTR_UCODE_CMD_DATA]);
-	cmd.len[0] = nla_len(tb[IWL_TM_ATTR_UCODE_CMD_DATA]);
-	cmd.dataflags[0] = IWL_HCMD_DFL_NOCOPY;
-	IWL_DEBUG_INFO(priv, "testmode ucode command ID 0x%x, flags 0x%x,"
-				" len %d\n", cmd.id, cmd.flags, cmd.len[0]);
-
-	ret = iwl_dvm_send_cmd(priv, &cmd);
-	if (ret) {
-		IWL_ERR(priv, "Failed to send hcmd\n");
-		return ret;
-	}
-	if (!cmd_want_skb)
-		return ret;
-
-	/* Handling return of SKB to the user */
-	pkt = cmd.resp_pkt;
-	if (!pkt) {
-		IWL_ERR(priv, "HCMD received a null response packet\n");
-		return ret;
-	}
-
-	reply_len = le32_to_cpu(pkt->len_n_flags) & FH_RSCSR_FRAME_SIZE_MSK;
-	skb = cfg80211_testmode_alloc_reply_skb(hw->wiphy, reply_len + 20);
-	reply_buf = kmalloc(reply_len, GFP_KERNEL);
-	if (!skb || !reply_buf) {
-		kfree_skb(skb);
-		kfree(reply_buf);
-		return -ENOMEM;
-	}
-
-	/* The reply is in a page, that we cannot send to user space. */
-	memcpy(reply_buf, &(pkt->hdr), reply_len);
-	iwl_free_resp(&cmd);
-
-	if (nla_put_u32(skb, IWL_TM_ATTR_COMMAND, IWL_TM_CMD_DEV2APP_UCODE_RX_PKT) ||
-	    nla_put(skb, IWL_TM_ATTR_UCODE_RX_PKT, reply_len, reply_buf))
-		goto nla_put_failure;
-	return cfg80211_testmode_reply(skb);
-
-nla_put_failure:
-	IWL_DEBUG_INFO(priv, "Failed creating NL attributes\n");
-	return -ENOMSG;
+	iwl_test_init(&priv->tst, priv->trans, &tst_ops);
 }
 
-
-/*
- * This function handles the user application commands for register access.
- *
- * It retrieves command ID carried with IWL_TM_ATTR_COMMAND and calls to the
- * handlers respectively.
- *
- * If it's an unknown commdn ID, -ENOSYS is returned; or -ENOMSG if the
- * mandatory fields(IWL_TM_ATTR_REG_OFFSET,IWL_TM_ATTR_REG_VALUE32,
- * IWL_TM_ATTR_REG_VALUE8) are missing; Otherwise 0 is replied indicating
- * the success of the command execution.
- *
- * If IWL_TM_ATTR_COMMAND is IWL_TM_CMD_APP2DEV_REG_READ32, the register read
- * value is returned with IWL_TM_ATTR_REG_VALUE32.
- *
- * @hw: ieee80211_hw object that represents the device
- * @tb: gnl message fields from the user space
- */
-static int iwl_testmode_reg(struct ieee80211_hw *hw, struct nlattr **tb)
+void iwl_testmode_free(struct iwl_priv *priv)
 {
-	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
-	u32 ofs, val32, cmd;
-	u8 val8;
-	struct sk_buff *skb;
-	int status = 0;
-
-	if (!tb[IWL_TM_ATTR_REG_OFFSET]) {
-		IWL_ERR(priv, "Missing register offset\n");
-		return -ENOMSG;
-	}
-	ofs = nla_get_u32(tb[IWL_TM_ATTR_REG_OFFSET]);
-	IWL_INFO(priv, "testmode register access command offset 0x%x\n", ofs);
-
-	/* Allow access only to FH/CSR/HBUS in direct mode.
-	Since we don't have the upper bounds for the CSR and HBUS segments,
-	we will use only the upper bound of FH for sanity check. */
-	cmd = nla_get_u32(tb[IWL_TM_ATTR_COMMAND]);
-	if ((cmd == IWL_TM_CMD_APP2DEV_DIRECT_REG_READ32 ||
-		cmd == IWL_TM_CMD_APP2DEV_DIRECT_REG_WRITE32 ||
-		cmd == IWL_TM_CMD_APP2DEV_DIRECT_REG_WRITE8) &&
-		(ofs >= FH_MEM_UPPER_BOUND)) {
-		IWL_ERR(priv, "offset out of segment (0x0 - 0x%x)\n",
-			FH_MEM_UPPER_BOUND);
-		return -EINVAL;
-	}
-
-	switch (cmd) {
-	case IWL_TM_CMD_APP2DEV_DIRECT_REG_READ32:
-		val32 = iwl_read_direct32(priv->trans, ofs);
-		IWL_INFO(priv, "32bit value to read 0x%x\n", val32);
-
-		skb = cfg80211_testmode_alloc_reply_skb(hw->wiphy, 20);
-		if (!skb) {
-			IWL_ERR(priv, "Memory allocation fail\n");
-			return -ENOMEM;
-		}
-		if (nla_put_u32(skb, IWL_TM_ATTR_REG_VALUE32, val32))
-			goto nla_put_failure;
-		status = cfg80211_testmode_reply(skb);
-		if (status < 0)
-			IWL_ERR(priv, "Error sending msg : %d\n", status);
-		break;
-	case IWL_TM_CMD_APP2DEV_DIRECT_REG_WRITE32:
-		if (!tb[IWL_TM_ATTR_REG_VALUE32]) {
-			IWL_ERR(priv, "Missing value to write\n");
-			return -ENOMSG;
-		} else {
-			val32 = nla_get_u32(tb[IWL_TM_ATTR_REG_VALUE32]);
-			IWL_INFO(priv, "32bit value to write 0x%x\n", val32);
-			iwl_write_direct32(priv->trans, ofs, val32);
-		}
-		break;
-	case IWL_TM_CMD_APP2DEV_DIRECT_REG_WRITE8:
-		if (!tb[IWL_TM_ATTR_REG_VALUE8]) {
-			IWL_ERR(priv, "Missing value to write\n");
-			return -ENOMSG;
-		} else {
-			val8 = nla_get_u8(tb[IWL_TM_ATTR_REG_VALUE8]);
-			IWL_INFO(priv, "8bit value to write 0x%x\n", val8);
-			iwl_write8(priv->trans, ofs, val8);
-		}
-		break;
-	default:
-		IWL_ERR(priv, "Unknown testmode register command ID\n");
-		return -ENOSYS;
-	}
-
-	return status;
-
-nla_put_failure:
-	kfree_skb(skb);
-	return -EMSGSIZE;
+	iwl_test_free(&priv->tst);
 }
 
-
 static int iwl_testmode_cfg_init_calib(struct iwl_priv *priv)
 {
 	struct iwl_notification_wait calib_wait;
@@ -469,7 +170,7 @@ static int iwl_testmode_driver(struct ieee80211_hw *hw, struct nlattr **tb)
 	struct sk_buff *skb;
 	unsigned char *rsp_data_ptr = NULL;
 	int status = 0, rsp_data_len = 0;
-	u32 devid, inst_size = 0, data_size = 0;
+	u32 inst_size = 0, data_size = 0;
 	const struct fw_img *img;
 
 	switch (nla_get_u32(tb[IWL_TM_ATTR_COMMAND])) {
@@ -563,39 +264,6 @@ static int iwl_testmode_driver(struct ieee80211_hw *hw, struct nlattr **tb)
 		priv->tm_fixed_rate = nla_get_u32(tb[IWL_TM_ATTR_FIXRATE]);
 		break;
 
-	case IWL_TM_CMD_APP2DEV_GET_FW_VERSION:
-		IWL_INFO(priv, "uCode version raw: 0x%x\n",
-			 priv->fw->ucode_ver);
-
-		skb = cfg80211_testmode_alloc_reply_skb(hw->wiphy, 20);
-		if (!skb) {
-			IWL_ERR(priv, "Memory allocation fail\n");
-			return -ENOMEM;
-		}
-		if (nla_put_u32(skb, IWL_TM_ATTR_FW_VERSION,
-				priv->fw->ucode_ver))
-			goto nla_put_failure;
-		status = cfg80211_testmode_reply(skb);
-		if (status < 0)
-			IWL_ERR(priv, "Error sending msg : %d\n", status);
-		break;
-
-	case IWL_TM_CMD_APP2DEV_GET_DEVICE_ID:
-		devid = priv->trans->hw_id;
-		IWL_INFO(priv, "hw version: 0x%x\n", devid);
-
-		skb = cfg80211_testmode_alloc_reply_skb(hw->wiphy, 20);
-		if (!skb) {
-			IWL_ERR(priv, "Memory allocation fail\n");
-			return -ENOMEM;
-		}
-		if (nla_put_u32(skb, IWL_TM_ATTR_DEVICE_ID, devid))
-			goto nla_put_failure;
-		status = cfg80211_testmode_reply(skb);
-		if (status < 0)
-			IWL_ERR(priv, "Error sending msg : %d\n", status);
-		break;
-
 	case IWL_TM_CMD_APP2DEV_GET_FW_INFO:
 		skb = cfg80211_testmode_alloc_reply_skb(hw->wiphy, 20 + 8);
 		if (!skb) {
@@ -630,125 +298,6 @@ nla_put_failure:
 	return -EMSGSIZE;
 }
 
-
-/*
- * This function handles the user application commands for uCode trace
- *
- * It retrieves command ID carried with IWL_TM_ATTR_COMMAND and calls to the
- * handlers respectively.
- *
- * If it's an unknown commdn ID, -ENOSYS is replied; otherwise, the returned
- * value of the actual command execution is replied to the user application.
- *
- * @hw: ieee80211_hw object that represents the device
- * @tb: gnl message fields from the user space
- */
-static int iwl_testmode_trace(struct ieee80211_hw *hw, struct nlattr **tb)
-{
-	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
-	struct sk_buff *skb;
-	int status = 0;
-	struct device *dev = priv->trans->dev;
-
-	switch (nla_get_u32(tb[IWL_TM_ATTR_COMMAND])) {
-	case IWL_TM_CMD_APP2DEV_BEGIN_TRACE:
-		if (priv->testmode_trace.trace_enabled)
-			return -EBUSY;
-
-		if (!tb[IWL_TM_ATTR_TRACE_SIZE])
-			priv->testmode_trace.buff_size = TRACE_BUFF_SIZE_DEF;
-		else
-			priv->testmode_trace.buff_size =
-				nla_get_u32(tb[IWL_TM_ATTR_TRACE_SIZE]);
-		if (!priv->testmode_trace.buff_size)
-			return -EINVAL;
-		if (priv->testmode_trace.buff_size < TRACE_BUFF_SIZE_MIN ||
-		    priv->testmode_trace.buff_size > TRACE_BUFF_SIZE_MAX)
-			return -EINVAL;
-
-		priv->testmode_trace.total_size =
-			priv->testmode_trace.buff_size + TRACE_BUFF_PADD;
-		priv->testmode_trace.cpu_addr =
-			dma_alloc_coherent(dev,
-					   priv->testmode_trace.total_size,
-					   &priv->testmode_trace.dma_addr,
-					   GFP_KERNEL);
-		if (!priv->testmode_trace.cpu_addr)
-			return -ENOMEM;
-		priv->testmode_trace.trace_enabled = true;
-		priv->testmode_trace.trace_addr = (u8 *)PTR_ALIGN(
-			priv->testmode_trace.cpu_addr, 0x100);
-		memset(priv->testmode_trace.trace_addr, 0x03B,
-			priv->testmode_trace.buff_size);
-		skb = cfg80211_testmode_alloc_reply_skb(hw->wiphy,
-			sizeof(priv->testmode_trace.dma_addr) + 20);
-		if (!skb) {
-			IWL_ERR(priv, "Memory allocation fail\n");
-			iwl_trace_cleanup(priv);
-			return -ENOMEM;
-		}
-		if (nla_put(skb, IWL_TM_ATTR_TRACE_ADDR,
-			    sizeof(priv->testmode_trace.dma_addr),
-			    (u64 *)&priv->testmode_trace.dma_addr))
-			goto nla_put_failure;
-		status = cfg80211_testmode_reply(skb);
-		if (status < 0) {
-			IWL_ERR(priv, "Error sending msg : %d\n", status);
-		}
-		priv->testmode_trace.num_chunks =
-			DIV_ROUND_UP(priv->testmode_trace.buff_size,
-				     DUMP_CHUNK_SIZE);
-		break;
-
-	case IWL_TM_CMD_APP2DEV_END_TRACE:
-		iwl_trace_cleanup(priv);
-		break;
-	default:
-		IWL_ERR(priv, "Unknown testmode mem command ID\n");
-		return -ENOSYS;
-	}
-	return status;
-
-nla_put_failure:
-	kfree_skb(skb);
-	if (nla_get_u32(tb[IWL_TM_ATTR_COMMAND]) ==
-	    IWL_TM_CMD_APP2DEV_BEGIN_TRACE)
-		iwl_trace_cleanup(priv);
-	return -EMSGSIZE;
-}
-
-static int iwl_testmode_trace_dump(struct ieee80211_hw *hw,
-				   struct sk_buff *skb,
-				   struct netlink_callback *cb)
-{
-	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
-	int idx, length;
-
-	if (priv->testmode_trace.trace_enabled &&
-	    priv->testmode_trace.trace_addr) {
-		idx = cb->args[4];
-		if (idx >= priv->testmode_trace.num_chunks)
-			return -ENOENT;
-		length = DUMP_CHUNK_SIZE;
-		if (((idx + 1) == priv->testmode_trace.num_chunks) &&
-		    (priv->testmode_trace.buff_size % DUMP_CHUNK_SIZE))
-			length = priv->testmode_trace.buff_size %
-				DUMP_CHUNK_SIZE;
-
-		if (nla_put(skb, IWL_TM_ATTR_TRACE_DUMP, length,
-			    priv->testmode_trace.trace_addr +
-			    (DUMP_CHUNK_SIZE * idx)))
-			goto nla_put_failure;
-		idx++;
-		cb->args[4] = idx;
-		return 0;
-	} else
-		return -EFAULT;
-
- nla_put_failure:
-	return -ENOBUFS;
-}
-
 /*
  * This function handles the user application switch ucode ownership.
  *
@@ -777,10 +326,10 @@ static int iwl_testmode_ownership(struct ieee80211_hw *hw, struct nlattr **tb)
 	owner = nla_get_u8(tb[IWL_TM_ATTR_UCODE_OWNER]);
 	if (owner == IWL_OWNERSHIP_DRIVER) {
 		priv->ucode_owner = owner;
-		priv->pre_rx_handler = NULL;
+		iwl_test_enable_notifications(&priv->tst, false);
 	} else if (owner == IWL_OWNERSHIP_TM) {
-		priv->pre_rx_handler = iwl_testmode_ucode_rx_pkt;
 		priv->ucode_owner = owner;
+		iwl_test_enable_notifications(&priv->tst, true);
 	} else {
 		IWL_ERR(priv, "Invalid owner\n");
 		return -EINVAL;
@@ -788,180 +337,6 @@ static int iwl_testmode_ownership(struct ieee80211_hw *hw, struct nlattr **tb)
 	return 0;
 }
 
-static int iwl_testmode_indirect_read(struct iwl_priv *priv, u32 addr, u32 size)
-{
-	struct iwl_trans *trans = priv->trans;
-	unsigned long flags;
-	int i;
-
-	if (size & 0x3)
-		return -EINVAL;
-	priv->testmode_mem.buff_size = size;
-	priv->testmode_mem.buff_addr =
-		kmalloc(priv->testmode_mem.buff_size, GFP_KERNEL);
-	if (priv->testmode_mem.buff_addr == NULL)
-		return -ENOMEM;
-
-	/* Hard-coded periphery absolute address */
-	if (IWL_TM_ABS_PRPH_START <= addr &&
-		addr < IWL_TM_ABS_PRPH_START + PRPH_END) {
-			spin_lock_irqsave(&trans->reg_lock, flags);
-			iwl_grab_nic_access(trans);
-			iwl_write32(trans, HBUS_TARG_PRPH_RADDR,
-				addr | (3 << 24));
-			for (i = 0; i < size; i += 4)
-				*(u32 *)(priv->testmode_mem.buff_addr + i) =
-					iwl_read32(trans, HBUS_TARG_PRPH_RDAT);
-			iwl_release_nic_access(trans);
-			spin_unlock_irqrestore(&trans->reg_lock, flags);
-	} else { /* target memory (SRAM) */
-		_iwl_read_targ_mem_words(trans, addr,
-			priv->testmode_mem.buff_addr,
-			priv->testmode_mem.buff_size / 4);
-	}
-
-	priv->testmode_mem.num_chunks =
-		DIV_ROUND_UP(priv->testmode_mem.buff_size, DUMP_CHUNK_SIZE);
-	priv->testmode_mem.read_in_progress = true;
-	return 0;
-
-}
-
-static int iwl_testmode_indirect_write(struct iwl_priv *priv, u32 addr,
-	u32 size, unsigned char *buf)
-{
-	struct iwl_trans *trans = priv->trans;
-	u32 val, i;
-	unsigned long flags;
-
-	if (IWL_TM_ABS_PRPH_START <= addr &&
-		addr < IWL_TM_ABS_PRPH_START + PRPH_END) {
-			/* Periphery writes can be 1-3 bytes long, or DWORDs */
-			if (size < 4) {
-				memcpy(&val, buf, size);
-				spin_lock_irqsave(&trans->reg_lock, flags);
-				iwl_grab_nic_access(trans);
-				iwl_write32(trans, HBUS_TARG_PRPH_WADDR,
-					    (addr & 0x0000FFFF) |
-					    ((size - 1) << 24));
-				iwl_write32(trans, HBUS_TARG_PRPH_WDAT, val);
-				iwl_release_nic_access(trans);
-				/* needed after consecutive writes w/o read */
-				mmiowb();
-				spin_unlock_irqrestore(&trans->reg_lock, flags);
-			} else {
-				if (size % 4)
-					return -EINVAL;
-				for (i = 0; i < size; i += 4)
-					iwl_write_prph(trans, addr+i,
-						*(u32 *)(buf+i));
-			}
-	} else if (iwlagn_hw_valid_rtc_data_addr(addr) ||
-		(IWLAGN_RTC_INST_LOWER_BOUND <= addr &&
-		addr < IWLAGN_RTC_INST_UPPER_BOUND)) {
-			_iwl_write_targ_mem_words(trans, addr, buf, size/4);
-	} else
-		return -EINVAL;
-	return 0;
-}
-
-/*
- * This function handles the user application commands for SRAM data dump
- *
- * It retrieves the mandatory fields IWL_TM_ATTR_SRAM_ADDR and
- * IWL_TM_ATTR_SRAM_SIZE to decide the memory area for SRAM data reading
- *
- * Several error will be retured, -EBUSY if the SRAM data retrieved by
- * previous command has not been delivered to userspace, or -ENOMSG if
- * the mandatory fields (IWL_TM_ATTR_SRAM_ADDR,IWL_TM_ATTR_SRAM_SIZE)
- * are missing, or -ENOMEM if the buffer allocation fails.
- *
- * Otherwise 0 is replied indicating the success of the SRAM reading.
- *
- * @hw: ieee80211_hw object that represents the device
- * @tb: gnl message fields from the user space
- */
-static int iwl_testmode_indirect_mem(struct ieee80211_hw *hw,
-	struct nlattr **tb)
-{
-	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
-	u32 addr, size, cmd;
-	unsigned char *buf;
-
-	/* Both read and write should be blocked, for atomicity */
-	if (priv->testmode_mem.read_in_progress)
-		return -EBUSY;
-
-	cmd = nla_get_u32(tb[IWL_TM_ATTR_COMMAND]);
-	if (!tb[IWL_TM_ATTR_MEM_ADDR]) {
-		IWL_ERR(priv, "Error finding memory offset address\n");
-		return -ENOMSG;
-	}
-	addr = nla_get_u32(tb[IWL_TM_ATTR_MEM_ADDR]);
-	if (!tb[IWL_TM_ATTR_BUFFER_SIZE]) {
-		IWL_ERR(priv, "Error finding size for memory reading\n");
-		return -ENOMSG;
-	}
-	size = nla_get_u32(tb[IWL_TM_ATTR_BUFFER_SIZE]);
-
-	if (cmd == IWL_TM_CMD_APP2DEV_INDIRECT_BUFFER_READ)
-		return iwl_testmode_indirect_read(priv, addr,  size);
-	else {
-		if (!tb[IWL_TM_ATTR_BUFFER_DUMP])
-			return -EINVAL;
-		buf = (unsigned char *) nla_data(tb[IWL_TM_ATTR_BUFFER_DUMP]);
-		return iwl_testmode_indirect_write(priv, addr, size, buf);
-	}
-}
-
-static int iwl_testmode_buffer_dump(struct ieee80211_hw *hw,
-				    struct sk_buff *skb,
-				    struct netlink_callback *cb)
-{
-	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
-	int idx, length;
-
-	if (priv->testmode_mem.read_in_progress) {
-		idx = cb->args[4];
-		if (idx >= priv->testmode_mem.num_chunks) {
-			iwl_mem_cleanup(priv);
-			return -ENOENT;
-		}
-		length = DUMP_CHUNK_SIZE;
-		if (((idx + 1) == priv->testmode_mem.num_chunks) &&
-		    (priv->testmode_mem.buff_size % DUMP_CHUNK_SIZE))
-			length = priv->testmode_mem.buff_size %
-				DUMP_CHUNK_SIZE;
-
-		if (nla_put(skb, IWL_TM_ATTR_BUFFER_DUMP, length,
-			    priv->testmode_mem.buff_addr +
-			    (DUMP_CHUNK_SIZE * idx)))
-			goto nla_put_failure;
-		idx++;
-		cb->args[4] = idx;
-		return 0;
-	} else
-		return -EFAULT;
-
- nla_put_failure:
-	return -ENOBUFS;
-}
-
-static int iwl_testmode_notifications(struct ieee80211_hw *hw,
-	struct nlattr **tb)
-{
-	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
-	bool enable;
-
-	enable = nla_get_flag(tb[IWL_TM_ATTR_ENABLE_NOTIFICATION]);
-	if (enable)
-		priv->pre_rx_handler = iwl_testmode_ucode_rx_pkt;
-	else
-		priv->pre_rx_handler = NULL;
-	return 0;
-}
-
-
 /* The testmode gnl message handler that takes the gnl message from the
  * user space and parses it per the policy iwl_testmode_gnl_msg_policy, then
  * invoke the corresponding handlers.
@@ -987,32 +362,27 @@ int iwlagn_mac_testmode_cmd(struct ieee80211_hw *hw, void *data, int len)
 	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
 	int result;
 
-	result = nla_parse(tb, IWL_TM_ATTR_MAX - 1, data, len,
-			iwl_testmode_gnl_msg_policy);
-	if (result != 0) {
-		IWL_ERR(priv, "Error parsing the gnl message : %d\n", result);
+	result = iwl_test_parse(&priv->tst, tb, data, len);
+	if (result)
 		return result;
-	}
 
-	/* IWL_TM_ATTR_COMMAND is absolutely mandatory */
-	if (!tb[IWL_TM_ATTR_COMMAND]) {
-		IWL_ERR(priv, "Missing testmode command type\n");
-		return -ENOMSG;
-	}
 	/* in case multiple accesses to the device happens */
 	mutex_lock(&priv->mutex);
-
 	switch (nla_get_u32(tb[IWL_TM_ATTR_COMMAND])) {
 	case IWL_TM_CMD_APP2DEV_UCODE:
-		IWL_DEBUG_INFO(priv, "testmode cmd to uCode\n");
-		result = iwl_testmode_ucode(hw, tb);
-		break;
 	case IWL_TM_CMD_APP2DEV_DIRECT_REG_READ32:
 	case IWL_TM_CMD_APP2DEV_DIRECT_REG_WRITE32:
 	case IWL_TM_CMD_APP2DEV_DIRECT_REG_WRITE8:
-		IWL_DEBUG_INFO(priv, "testmode cmd to register\n");
-		result = iwl_testmode_reg(hw, tb);
+	case IWL_TM_CMD_APP2DEV_BEGIN_TRACE:
+	case IWL_TM_CMD_APP2DEV_END_TRACE:
+	case IWL_TM_CMD_APP2DEV_INDIRECT_BUFFER_READ:
+	case IWL_TM_CMD_APP2DEV_NOTIFICATIONS:
+	case IWL_TM_CMD_APP2DEV_GET_FW_VERSION:
+	case IWL_TM_CMD_APP2DEV_GET_DEVICE_ID:
+	case IWL_TM_CMD_APP2DEV_INDIRECT_BUFFER_WRITE:
+		result = iwl_test_handle_cmd(&priv->tst, hw, tb);
 		break;
+
 	case IWL_TM_CMD_APP2DEV_GET_DEVICENAME:
 	case IWL_TM_CMD_APP2DEV_LOAD_INIT_FW:
 	case IWL_TM_CMD_APP2DEV_CFG_INIT_CALIB:
@@ -1020,45 +390,25 @@ int iwlagn_mac_testmode_cmd(struct ieee80211_hw *hw, void *data, int len)
 	case IWL_TM_CMD_APP2DEV_GET_EEPROM:
 	case IWL_TM_CMD_APP2DEV_FIXRATE_REQ:
 	case IWL_TM_CMD_APP2DEV_LOAD_WOWLAN_FW:
-	case IWL_TM_CMD_APP2DEV_GET_FW_VERSION:
-	case IWL_TM_CMD_APP2DEV_GET_DEVICE_ID:
 	case IWL_TM_CMD_APP2DEV_GET_FW_INFO:
 		IWL_DEBUG_INFO(priv, "testmode cmd to driver\n");
 		result = iwl_testmode_driver(hw, tb);
 		break;
 
-	case IWL_TM_CMD_APP2DEV_BEGIN_TRACE:
-	case IWL_TM_CMD_APP2DEV_END_TRACE:
-	case IWL_TM_CMD_APP2DEV_READ_TRACE:
-		IWL_DEBUG_INFO(priv, "testmode uCode trace cmd to driver\n");
-		result = iwl_testmode_trace(hw, tb);
-		break;
-
 	case IWL_TM_CMD_APP2DEV_OWNERSHIP:
 		IWL_DEBUG_INFO(priv, "testmode change uCode ownership\n");
 		result = iwl_testmode_ownership(hw, tb);
 		break;
 
-	case IWL_TM_CMD_APP2DEV_INDIRECT_BUFFER_READ:
-	case IWL_TM_CMD_APP2DEV_INDIRECT_BUFFER_WRITE:
-		IWL_DEBUG_INFO(priv, "testmode indirect memory cmd "
-			"to driver\n");
-		result = iwl_testmode_indirect_mem(hw, tb);
-		break;
-
-	case IWL_TM_CMD_APP2DEV_NOTIFICATIONS:
-		IWL_DEBUG_INFO(priv, "testmode notifications cmd "
-			"to driver\n");
-		result = iwl_testmode_notifications(hw, tb);
-		break;
-
 	default:
 		IWL_ERR(priv, "Unknown testmode command\n");
 		result = -ENOSYS;
 		break;
 	}
-
 	mutex_unlock(&priv->mutex);
+
+	if (result)
+		IWL_ERR(priv, "Test cmd failed result=%d\n", result);
 	return result;
 }
 
@@ -1066,7 +416,6 @@ int iwlagn_mac_testmode_dump(struct ieee80211_hw *hw, struct sk_buff *skb,
 		      struct netlink_callback *cb,
 		      void *data, int len)
 {
-	struct nlattr *tb[IWL_TM_ATTR_MAX];
 	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
 	int result;
 	u32 cmd;
@@ -1075,39 +424,19 @@ int iwlagn_mac_testmode_dump(struct ieee80211_hw *hw, struct sk_buff *skb,
 		/* offset by 1 since commands start at 0 */
 		cmd = cb->args[3] - 1;
 	} else {
-		result = nla_parse(tb, IWL_TM_ATTR_MAX - 1, data, len,
-				iwl_testmode_gnl_msg_policy);
-		if (result) {
-			IWL_ERR(priv,
-				"Error parsing the gnl message : %d\n", result);
+		struct nlattr *tb[IWL_TM_ATTR_MAX];
+
+		result = iwl_test_parse(&priv->tst, tb, data, len);
+		if (result)
 			return result;
-		}
 
-		/* IWL_TM_ATTR_COMMAND is absolutely mandatory */
-		if (!tb[IWL_TM_ATTR_COMMAND]) {
-			IWL_ERR(priv, "Missing testmode command type\n");
-			return -ENOMSG;
-		}
 		cmd = nla_get_u32(tb[IWL_TM_ATTR_COMMAND]);
 		cb->args[3] = cmd + 1;
 	}
 
 	/* in case multiple accesses to the device happens */
 	mutex_lock(&priv->mutex);
-	switch (cmd) {
-	case IWL_TM_CMD_APP2DEV_READ_TRACE:
-		IWL_DEBUG_INFO(priv, "uCode trace cmd to driver\n");
-		result = iwl_testmode_trace_dump(hw, skb, cb);
-		break;
-	case IWL_TM_CMD_APP2DEV_INDIRECT_BUFFER_DUMP:
-		IWL_DEBUG_INFO(priv, "testmode sram dump cmd to driver\n");
-		result = iwl_testmode_buffer_dump(hw, skb, cb);
-		break;
-	default:
-		result = -EINVAL;
-		break;
-	}
-
+	result = iwl_test_dump(&priv->tst, cmd, skb, cb);
 	mutex_unlock(&priv->mutex);
 	return result;
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-test.c b/drivers/net/wireless/iwlwifi/iwl-test.c
new file mode 100644
index 0000000..76e1863
--- /dev/null
+++ b/drivers/net/wireless/iwlwifi/iwl-test.c
@@ -0,0 +1,825 @@
+/******************************************************************************
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2010 - 2012 Intel Corporation. All rights reserved.
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
+ * Copyright(c) 2010 - 2012 Intel Corporation. All rights reserved.
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
+#include <net/netlink.h>
+#include "iwl-io.h"
+#include "iwl-fh.h"
+#include "iwl-prph.h"
+#include "iwl-trans.h"
+#include "iwl-test.h"
+#include "iwl-csr.h"
+#include "iwl-testmode.h"
+
+/*
+ * Periphery registers absolute lower bound. This is used in order to
+ * differentiate registery access through HBUS_TARG_PRPH_* and
+ * HBUS_TARG_MEM_* accesses.
+ */
+#define IWL_ABS_PRPH_START (0xA00000)
+
+/*
+ * The TLVs used in the gnl message policy between the kernel module and
+ * user space application. iwl_testmode_gnl_msg_policy is to be carried
+ * through the NL80211_CMD_TESTMODE channel regulated by nl80211.
+ * See iwl-testmode.h
+ */
+static
+struct nla_policy iwl_testmode_gnl_msg_policy[IWL_TM_ATTR_MAX] = {
+	[IWL_TM_ATTR_COMMAND] = { .type = NLA_U32, },
+
+	[IWL_TM_ATTR_UCODE_CMD_ID] = { .type = NLA_U8, },
+	[IWL_TM_ATTR_UCODE_CMD_DATA] = { .type = NLA_UNSPEC, },
+
+	[IWL_TM_ATTR_REG_OFFSET] = { .type = NLA_U32, },
+	[IWL_TM_ATTR_REG_VALUE8] = { .type = NLA_U8, },
+	[IWL_TM_ATTR_REG_VALUE32] = { .type = NLA_U32, },
+
+	[IWL_TM_ATTR_SYNC_RSP] = { .type = NLA_UNSPEC, },
+	[IWL_TM_ATTR_UCODE_RX_PKT] = { .type = NLA_UNSPEC, },
+
+	[IWL_TM_ATTR_EEPROM] = { .type = NLA_UNSPEC, },
+
+	[IWL_TM_ATTR_TRACE_ADDR] = { .type = NLA_UNSPEC, },
+	[IWL_TM_ATTR_TRACE_DUMP] = { .type = NLA_UNSPEC, },
+	[IWL_TM_ATTR_TRACE_SIZE] = { .type = NLA_U32, },
+
+	[IWL_TM_ATTR_FIXRATE] = { .type = NLA_U32, },
+
+	[IWL_TM_ATTR_UCODE_OWNER] = { .type = NLA_U8, },
+
+	[IWL_TM_ATTR_MEM_ADDR] = { .type = NLA_U32, },
+	[IWL_TM_ATTR_BUFFER_SIZE] = { .type = NLA_U32, },
+	[IWL_TM_ATTR_BUFFER_DUMP] = { .type = NLA_UNSPEC, },
+
+	[IWL_TM_ATTR_FW_VERSION] = { .type = NLA_U32, },
+	[IWL_TM_ATTR_DEVICE_ID] = { .type = NLA_U32, },
+	[IWL_TM_ATTR_FW_TYPE] = { .type = NLA_U32, },
+	[IWL_TM_ATTR_FW_INST_SIZE] = { .type = NLA_U32, },
+	[IWL_TM_ATTR_FW_DATA_SIZE] = { .type = NLA_U32, },
+
+	[IWL_TM_ATTR_ENABLE_NOTIFICATION] = {.type = NLA_FLAG, },
+};
+
+static inline void iwl_test_trace_clear(struct iwl_test *tst)
+{
+	memset(&tst->trace, 0, sizeof(struct iwl_test_trace));
+}
+
+static void iwl_test_trace_stop(struct iwl_test *tst)
+{
+	if (!tst->trace.enabled)
+		return;
+
+	if (tst->trace.cpu_addr && tst->trace.dma_addr)
+		dma_free_coherent(tst->trans->dev,
+				  tst->trace.tsize,
+				  tst->trace.cpu_addr,
+				  tst->trace.dma_addr);
+
+	iwl_test_trace_clear(tst);
+}
+
+static inline void iwl_test_mem_clear(struct iwl_test *tst)
+{
+	memset(&tst->mem, 0, sizeof(struct iwl_test_mem));
+}
+
+static inline void iwl_test_mem_stop(struct iwl_test *tst)
+{
+	if (!tst->mem.in_read)
+		return;
+
+	iwl_test_mem_clear(tst);
+}
+
+/*
+ * Initializes the test object
+ * During the lifetime of the test object it is assumed that the transport is
+ * started. The test object should be stopped before the transport is stopped.
+ */
+void iwl_test_init(struct iwl_test *tst, struct iwl_trans *trans,
+		   struct iwl_test_ops *ops)
+{
+	tst->trans = trans;
+	tst->ops = ops;
+
+	iwl_test_trace_clear(tst);
+	iwl_test_mem_clear(tst);
+}
+EXPORT_SYMBOL_GPL(iwl_test_init);
+
+/*
+ * Stop the test object
+ */
+void iwl_test_free(struct iwl_test *tst)
+{
+	iwl_test_mem_stop(tst);
+	iwl_test_trace_stop(tst);
+}
+EXPORT_SYMBOL_GPL(iwl_test_free);
+
+/*
+ * This function handles the user application commands to the fw. The fw
+ * commands are sent in a synchronuous manner. In case that the user requested
+ * to get commands response, it is send to the user.
+ */
+static int iwl_test_fw_cmd(struct iwl_test *tst, struct ieee80211_hw *hw,
+			   struct nlattr **tb)
+{
+	struct iwl_host_cmd cmd;
+	struct iwl_rx_packet *pkt;
+	struct sk_buff *skb;
+	void *reply_buf;
+	u32 reply_len;
+	int ret;
+	bool cmd_want_skb;
+
+	memset(&cmd, 0, sizeof(struct iwl_host_cmd));
+
+	if (!tb[IWL_TM_ATTR_UCODE_CMD_ID] ||
+	    !tb[IWL_TM_ATTR_UCODE_CMD_DATA]) {
+		IWL_ERR(tst->trans, "Missing fw command mandatory fields\n");
+		return -ENOMSG;
+	}
+
+	cmd.flags = CMD_ON_DEMAND | CMD_SYNC;
+	cmd_want_skb = nla_get_flag(tb[IWL_TM_ATTR_UCODE_CMD_SKB]);
+	if (cmd_want_skb)
+		cmd.flags |= CMD_WANT_SKB;
+
+	cmd.id = nla_get_u8(tb[IWL_TM_ATTR_UCODE_CMD_ID]);
+	cmd.data[0] = nla_data(tb[IWL_TM_ATTR_UCODE_CMD_DATA]);
+	cmd.len[0] = nla_len(tb[IWL_TM_ATTR_UCODE_CMD_DATA]);
+	cmd.dataflags[0] = IWL_HCMD_DFL_NOCOPY;
+	IWL_DEBUG_INFO(tst->trans, "test fw cmd=0x%x, flags 0x%x, len %d\n",
+		       cmd.id, cmd.flags, cmd.len[0]);
+
+	ret = tst->ops->send_cmd(tst->trans->op_mode, &cmd);
+	if (ret) {
+		IWL_ERR(tst->trans, "Failed to send hcmd\n");
+		return ret;
+	}
+	if (!cmd_want_skb)
+		return ret;
+
+	/* Handling return of SKB to the user */
+	pkt = cmd.resp_pkt;
+	if (!pkt) {
+		IWL_ERR(tst->trans, "HCMD received a null response packet\n");
+		return ret;
+	}
+
+	reply_len = le32_to_cpu(pkt->len_n_flags) & FH_RSCSR_FRAME_SIZE_MSK;
+	skb = cfg80211_testmode_alloc_reply_skb(hw->wiphy, reply_len + 20);
+	reply_buf = kmalloc(reply_len, GFP_KERNEL);
+	if (!skb || !reply_buf) {
+		kfree_skb(skb);
+		kfree(reply_buf);
+		return -ENOMEM;
+	}
+
+	/* The reply is in a page, that we cannot send to user space. */
+	memcpy(reply_buf, &(pkt->hdr), reply_len);
+	iwl_free_resp(&cmd);
+
+	if (nla_put_u32(skb, IWL_TM_ATTR_COMMAND,
+			IWL_TM_CMD_DEV2APP_UCODE_RX_PKT) ||
+	    nla_put(skb, IWL_TM_ATTR_UCODE_RX_PKT, reply_len, reply_buf))
+		goto nla_put_failure;
+	return cfg80211_testmode_reply(skb);
+
+nla_put_failure:
+	IWL_DEBUG_INFO(tst->trans, "Failed creating NL attributes\n");
+	kfree(reply_buf);
+	kfree_skb(skb);
+	return -ENOMSG;
+}
+
+/*
+ * Handles the user application commands for register access.
+ */
+static int iwl_test_reg(struct iwl_test *tst, struct ieee80211_hw *hw,
+			struct nlattr **tb)
+{
+	u32 ofs, val32, cmd;
+	u8 val8;
+	struct sk_buff *skb;
+	int status = 0;
+	struct iwl_trans *trans = tst->trans;
+
+	if (!tb[IWL_TM_ATTR_REG_OFFSET]) {
+		IWL_ERR(trans, "Missing reg offset\n");
+		return -ENOMSG;
+	}
+
+	ofs = nla_get_u32(tb[IWL_TM_ATTR_REG_OFFSET]);
+	IWL_DEBUG_INFO(trans, "test reg access cmd offset=0x%x\n", ofs);
+
+	cmd = nla_get_u32(tb[IWL_TM_ATTR_COMMAND]);
+
+	/*
+	 * Allow access only to FH/CSR/HBUS in direct mode.
+	 * Since we don't have the upper bounds for the CSR and HBUS segments,
+	 * we will use only the upper bound of FH for sanity check.
+	 */
+	if (ofs >= FH_MEM_UPPER_BOUND) {
+		IWL_ERR(trans, "offset out of segment (0x0 - 0x%x)\n",
+			FH_MEM_UPPER_BOUND);
+		return -EINVAL;
+	}
+
+	switch (cmd) {
+	case IWL_TM_CMD_APP2DEV_DIRECT_REG_READ32:
+		val32 = iwl_read_direct32(tst->trans, ofs);
+		IWL_DEBUG_INFO(trans, "32 value to read 0x%x\n", val32);
+
+		skb = cfg80211_testmode_alloc_reply_skb(hw->wiphy, 20);
+		if (!skb) {
+			IWL_ERR(trans, "Memory allocation fail\n");
+			return -ENOMEM;
+		}
+		if (nla_put_u32(skb, IWL_TM_ATTR_REG_VALUE32, val32))
+			goto nla_put_failure;
+		status = cfg80211_testmode_reply(skb);
+		if (status < 0)
+			IWL_ERR(trans, "Error sending msg : %d\n", status);
+		break;
+
+	case IWL_TM_CMD_APP2DEV_DIRECT_REG_WRITE32:
+		if (!tb[IWL_TM_ATTR_REG_VALUE32]) {
+			IWL_ERR(trans, "Missing value to write\n");
+			return -ENOMSG;
+		} else {
+			val32 = nla_get_u32(tb[IWL_TM_ATTR_REG_VALUE32]);
+			IWL_DEBUG_INFO(trans, "32b write val=0x%x\n", val32);
+			iwl_write_direct32(tst->trans, ofs, val32);
+		}
+		break;
+
+	case IWL_TM_CMD_APP2DEV_DIRECT_REG_WRITE8:
+		if (!tb[IWL_TM_ATTR_REG_VALUE8]) {
+			IWL_ERR(trans, "Missing value to write\n");
+			return -ENOMSG;
+		} else {
+			val8 = nla_get_u8(tb[IWL_TM_ATTR_REG_VALUE8]);
+			IWL_DEBUG_INFO(trans, "8b write val=0x%x\n", val8);
+			iwl_write8(tst->trans, ofs, val8);
+		}
+		break;
+
+	default:
+		IWL_ERR(trans, "Unknown test register cmd ID\n");
+		return -ENOMSG;
+	}
+
+	return status;
+
+nla_put_failure:
+	kfree_skb(skb);
+	return -EMSGSIZE;
+}
+
+/*
+ * Handles the request to start FW tracing. Allocates of the trace buffer
+ * and sends a reply to user space with the address of the allocated buffer.
+ */
+static int iwl_test_trace_begin(struct iwl_test *tst, struct ieee80211_hw *hw,
+				struct nlattr **tb)
+{
+	struct sk_buff *skb;
+	int status = 0;
+
+	if (tst->trace.enabled)
+		return -EBUSY;
+
+	if (!tb[IWL_TM_ATTR_TRACE_SIZE])
+		tst->trace.size = TRACE_BUFF_SIZE_DEF;
+	else
+		tst->trace.size =
+			nla_get_u32(tb[IWL_TM_ATTR_TRACE_SIZE]);
+
+	if (!tst->trace.size)
+		return -EINVAL;
+
+	if (tst->trace.size < TRACE_BUFF_SIZE_MIN ||
+	    tst->trace.size > TRACE_BUFF_SIZE_MAX)
+		return -EINVAL;
+
+	tst->trace.tsize = tst->trace.size + TRACE_BUFF_PADD;
+	tst->trace.cpu_addr = dma_alloc_coherent(tst->trans->dev,
+						 tst->trace.tsize,
+						 &tst->trace.dma_addr,
+						 GFP_KERNEL);
+	if (!tst->trace.cpu_addr)
+		return -ENOMEM;
+
+	tst->trace.enabled = true;
+	tst->trace.trace_addr = (u8 *)PTR_ALIGN(tst->trace.cpu_addr, 0x100);
+
+	memset(tst->trace.trace_addr, 0x03B, tst->trace.size);
+
+	skb = cfg80211_testmode_alloc_reply_skb(hw->wiphy,
+			sizeof(tst->trace.dma_addr) + 20);
+
+	if (!skb) {
+		IWL_ERR(tst->trans, "Memory allocation fail\n");
+		iwl_test_trace_stop(tst);
+		return -ENOMEM;
+	}
+
+	if (nla_put(skb, IWL_TM_ATTR_TRACE_ADDR,
+		    sizeof(tst->trace.dma_addr),
+		    (u64 *)&tst->trace.dma_addr))
+		goto nla_put_failure;
+
+	status = cfg80211_testmode_reply(skb);
+	if (status < 0)
+		IWL_ERR(tst->trans, "Error sending msg : %d\n", status);
+
+	tst->trace.nchunks = DIV_ROUND_UP(tst->trace.size,
+					  DUMP_CHUNK_SIZE);
+
+	return status;
+
+nla_put_failure:
+	kfree_skb(skb);
+	if (nla_get_u32(tb[IWL_TM_ATTR_COMMAND]) ==
+	    IWL_TM_CMD_APP2DEV_BEGIN_TRACE)
+		iwl_test_trace_stop(tst);
+	return -EMSGSIZE;
+}
+
+/*
+ * Handles indirect read from the periphery or the SRAM. The read is performed
+ * to a temporary buffer. The user space application should later issue a dump
+ */
+static int iwl_test_indirect_read(struct iwl_test *tst, u32 addr, u32 size)
+{
+	struct iwl_trans *trans = tst->trans;
+	unsigned long flags;
+	int i;
+
+	if (size & 0x3)
+		return -EINVAL;
+
+	tst->mem.size = size;
+	tst->mem.addr = kmalloc(tst->mem.size, GFP_KERNEL);
+	if (tst->mem.addr == NULL)
+		return -ENOMEM;
+
+	/* Hard-coded periphery absolute address */
+	if (IWL_ABS_PRPH_START <= addr &&
+	    addr < IWL_ABS_PRPH_START + PRPH_END) {
+			spin_lock_irqsave(&trans->reg_lock, flags);
+			iwl_grab_nic_access(trans);
+			iwl_write32(trans, HBUS_TARG_PRPH_RADDR,
+				    addr | (3 << 24));
+			for (i = 0; i < size; i += 4)
+				*(u32 *)(tst->mem.addr + i) =
+					iwl_read32(trans, HBUS_TARG_PRPH_RDAT);
+			iwl_release_nic_access(trans);
+			spin_unlock_irqrestore(&trans->reg_lock, flags);
+	} else { /* target memory (SRAM) */
+		_iwl_read_targ_mem_words(trans, addr,
+					 tst->mem.addr,
+					 tst->mem.size / 4);
+	}
+
+	tst->mem.nchunks =
+		DIV_ROUND_UP(tst->mem.size, DUMP_CHUNK_SIZE);
+	tst->mem.in_read = true;
+	return 0;
+
+}
+
+/*
+ * Handles indirect write to the periphery or SRAM. The  is performed to a
+ * temporary buffer.
+ */
+static int iwl_test_indirect_write(struct iwl_test *tst, u32 addr,
+	u32 size, unsigned char *buf)
+{
+	struct iwl_trans *trans = tst->trans;
+	u32 val, i;
+	unsigned long flags;
+
+	if (IWL_ABS_PRPH_START <= addr &&
+	    addr < IWL_ABS_PRPH_START + PRPH_END) {
+			/* Periphery writes can be 1-3 bytes long, or DWORDs */
+			if (size < 4) {
+				memcpy(&val, buf, size);
+				spin_lock_irqsave(&trans->reg_lock, flags);
+				iwl_grab_nic_access(trans);
+				iwl_write32(trans, HBUS_TARG_PRPH_WADDR,
+					    (addr & 0x0000FFFF) |
+					    ((size - 1) << 24));
+				iwl_write32(trans, HBUS_TARG_PRPH_WDAT, val);
+				iwl_release_nic_access(trans);
+				/* needed after consecutive writes w/o read */
+				mmiowb();
+				spin_unlock_irqrestore(&trans->reg_lock, flags);
+			} else {
+				if (size % 4)
+					return -EINVAL;
+				for (i = 0; i < size; i += 4)
+					iwl_write_prph(trans, addr+i,
+						       *(u32 *)(buf+i));
+			}
+	} else if (tst->ops->valid_hw_addr(addr)) {
+		_iwl_write_targ_mem_words(trans, addr, buf, size/4);
+	} else {
+		return -EINVAL;
+	}
+	return 0;
+}
+
+/*
+ * Handles the user application commands for indirect read/write
+ * to/from the periphery or the SRAM.
+ */
+static int iwl_test_indirect_mem(struct iwl_test *tst, struct nlattr **tb)
+{
+	u32 addr, size, cmd;
+	unsigned char *buf;
+
+	/* Both read and write should be blocked, for atomicity */
+	if (tst->mem.in_read)
+		return -EBUSY;
+
+	cmd = nla_get_u32(tb[IWL_TM_ATTR_COMMAND]);
+	if (!tb[IWL_TM_ATTR_MEM_ADDR]) {
+		IWL_ERR(tst->trans, "Error finding memory offset address\n");
+		return -ENOMSG;
+	}
+	addr = nla_get_u32(tb[IWL_TM_ATTR_MEM_ADDR]);
+	if (!tb[IWL_TM_ATTR_BUFFER_SIZE]) {
+		IWL_ERR(tst->trans, "Error finding size for memory reading\n");
+		return -ENOMSG;
+	}
+	size = nla_get_u32(tb[IWL_TM_ATTR_BUFFER_SIZE]);
+
+	if (cmd == IWL_TM_CMD_APP2DEV_INDIRECT_BUFFER_READ) {
+		return iwl_test_indirect_read(tst, addr,  size);
+	} else {
+		if (!tb[IWL_TM_ATTR_BUFFER_DUMP])
+			return -EINVAL;
+		buf = (unsigned char *)nla_data(tb[IWL_TM_ATTR_BUFFER_DUMP]);
+		return iwl_test_indirect_write(tst, addr, size, buf);
+	}
+}
+
+/*
+ * Enable notifications to user space
+ */
+static int iwl_test_notifications(struct iwl_test *tst,
+				  struct nlattr **tb)
+{
+	tst->notify = nla_get_flag(tb[IWL_TM_ATTR_ENABLE_NOTIFICATION]);
+	return 0;
+}
+
+/*
+ * Handles the request to get the device id
+ */
+static int iwl_test_get_dev_id(struct iwl_test *tst, struct ieee80211_hw *hw,
+			       struct nlattr **tb)
+{
+	u32 devid = tst->trans->hw_id;
+	struct sk_buff *skb;
+	int status;
+
+	IWL_DEBUG_INFO(tst->trans, "hw version: 0x%x\n", devid);
+
+	skb = cfg80211_testmode_alloc_reply_skb(hw->wiphy, 20);
+	if (!skb) {
+		IWL_ERR(tst->trans, "Memory allocation fail\n");
+		return -ENOMEM;
+	}
+
+	if (nla_put_u32(skb, IWL_TM_ATTR_DEVICE_ID, devid))
+		goto nla_put_failure;
+	status = cfg80211_testmode_reply(skb);
+	if (status < 0)
+		IWL_ERR(tst->trans, "Error sending msg : %d\n", status);
+
+	return 0;
+
+nla_put_failure:
+	kfree_skb(skb);
+	return -EMSGSIZE;
+}
+
+/*
+ * Handles the request to get the FW version
+ */
+static int iwl_test_get_fw_ver(struct iwl_test *tst, struct ieee80211_hw *hw,
+			       struct nlattr **tb)
+{
+	struct sk_buff *skb;
+	int status;
+	u32 ver = tst->ops->get_fw_ver(tst->trans->op_mode);
+
+	IWL_DEBUG_INFO(tst->trans, "uCode version raw: 0x%x\n", ver);
+
+	skb = cfg80211_testmode_alloc_reply_skb(hw->wiphy, 20);
+	if (!skb) {
+		IWL_ERR(tst->trans, "Memory allocation fail\n");
+		return -ENOMEM;
+	}
+
+	if (nla_put_u32(skb, IWL_TM_ATTR_FW_VERSION, ver))
+		goto nla_put_failure;
+
+	status = cfg80211_testmode_reply(skb);
+	if (status < 0)
+		IWL_ERR(tst->trans, "Error sending msg : %d\n", status);
+
+	return 0;
+
+nla_put_failure:
+	kfree_skb(skb);
+	return -EMSGSIZE;
+}
+
+/*
+ * Parse the netlink message and validate that the IWL_TM_ATTR_CMD exists
+ */
+int iwl_test_parse(struct iwl_test *tst, struct nlattr **tb,
+		   void *data, int len)
+{
+	int result;
+
+	result = nla_parse(tb, IWL_TM_ATTR_MAX - 1, data, len,
+			iwl_testmode_gnl_msg_policy);
+	if (result) {
+		IWL_ERR(tst->trans, "Fail parse gnl msg: %d\n", result);
+		return result;
+	}
+
+	/* IWL_TM_ATTR_COMMAND is absolutely mandatory */
+	if (!tb[IWL_TM_ATTR_COMMAND]) {
+		IWL_ERR(tst->trans, "Missing testmode command type\n");
+		return -ENOMSG;
+	}
+	return 0;
+}
+EXPORT_SYMBOL_GPL(iwl_test_parse);
+
+/*
+ * Handle test commands.
+ * Returns 1 for unknown commands (not handled by the test object); negative
+ * value in case of error.
+ */
+int iwl_test_handle_cmd(struct iwl_test *tst, struct ieee80211_hw *hw,
+			struct nlattr **tb)
+{
+	int result;
+
+	switch (nla_get_u32(tb[IWL_TM_ATTR_COMMAND])) {
+	case IWL_TM_CMD_APP2DEV_UCODE:
+		IWL_DEBUG_INFO(tst->trans, "test cmd to uCode\n");
+		result = iwl_test_fw_cmd(tst, hw, tb);
+		break;
+
+	case IWL_TM_CMD_APP2DEV_DIRECT_REG_READ32:
+	case IWL_TM_CMD_APP2DEV_DIRECT_REG_WRITE32:
+	case IWL_TM_CMD_APP2DEV_DIRECT_REG_WRITE8:
+		IWL_DEBUG_INFO(tst->trans, "test cmd to register\n");
+		result = iwl_test_reg(tst, hw, tb);
+		break;
+
+	case IWL_TM_CMD_APP2DEV_BEGIN_TRACE:
+		IWL_DEBUG_INFO(tst->trans, "test uCode trace cmd to driver\n");
+		result = iwl_test_trace_begin(tst, hw, tb);
+		break;
+
+	case IWL_TM_CMD_APP2DEV_END_TRACE:
+		iwl_test_trace_stop(tst);
+		result = 0;
+		break;
+
+	case IWL_TM_CMD_APP2DEV_INDIRECT_BUFFER_READ:
+	case IWL_TM_CMD_APP2DEV_INDIRECT_BUFFER_WRITE:
+		IWL_DEBUG_INFO(tst->trans, "test indirect memory cmd\n");
+		result = iwl_test_indirect_mem(tst, tb);
+		break;
+
+	case IWL_TM_CMD_APP2DEV_NOTIFICATIONS:
+		IWL_DEBUG_INFO(tst->trans, "test notifications cmd\n");
+		result = iwl_test_notifications(tst, tb);
+		break;
+
+	case IWL_TM_CMD_APP2DEV_GET_FW_VERSION:
+		IWL_DEBUG_INFO(tst->trans, "test get FW ver cmd\n");
+		result = iwl_test_get_fw_ver(tst, hw, tb);
+		break;
+
+	case IWL_TM_CMD_APP2DEV_GET_DEVICE_ID:
+		IWL_DEBUG_INFO(tst->trans, "test Get device ID cmd\n");
+		result = iwl_test_get_dev_id(tst, hw, tb);
+		break;
+
+	default:
+		IWL_DEBUG_INFO(tst->trans, "Unknown test command\n");
+		result = 1;
+		break;
+	}
+	return result;
+}
+EXPORT_SYMBOL_GPL(iwl_test_handle_cmd);
+
+static int iwl_test_trace_dump(struct iwl_test *tst, struct sk_buff *skb,
+			       struct netlink_callback *cb)
+{
+	int idx, length;
+
+	if (!tst->trace.enabled || !tst->trace.trace_addr)
+		return -EFAULT;
+
+	idx = cb->args[4];
+	if (idx >= tst->trace.nchunks)
+		return -ENOENT;
+
+	length = DUMP_CHUNK_SIZE;
+	if (((idx + 1) == tst->trace.nchunks) &&
+	    (tst->trace.size % DUMP_CHUNK_SIZE))
+		length = tst->trace.size %
+			DUMP_CHUNK_SIZE;
+
+	if (nla_put(skb, IWL_TM_ATTR_TRACE_DUMP, length,
+		    tst->trace.trace_addr + (DUMP_CHUNK_SIZE * idx)))
+		goto nla_put_failure;
+
+	cb->args[4] = ++idx;
+	return 0;
+
+ nla_put_failure:
+	return -ENOBUFS;
+}
+
+static int iwl_test_buffer_dump(struct iwl_test *tst, struct sk_buff *skb,
+				struct netlink_callback *cb)
+{
+	int idx, length;
+
+	if (!tst->mem.in_read)
+		return -EFAULT;
+
+	idx = cb->args[4];
+	if (idx >= tst->mem.nchunks) {
+		iwl_test_mem_stop(tst);
+		return -ENOENT;
+	}
+
+	length = DUMP_CHUNK_SIZE;
+	if (((idx + 1) == tst->mem.nchunks) &&
+	    (tst->mem.size % DUMP_CHUNK_SIZE))
+		length = tst->mem.size % DUMP_CHUNK_SIZE;
+
+	if (nla_put(skb, IWL_TM_ATTR_BUFFER_DUMP, length,
+		    tst->mem.addr + (DUMP_CHUNK_SIZE * idx)))
+		goto nla_put_failure;
+
+	cb->args[4] = ++idx;
+	return 0;
+
+ nla_put_failure:
+	return -ENOBUFS;
+}
+
+/*
+ * Handle dump commands.
+ * Returns 1 for unknown commands (not handled by the test object); negative
+ * value in case of error.
+ */
+int iwl_test_dump(struct iwl_test *tst, u32 cmd, struct sk_buff *skb,
+		  struct netlink_callback *cb)
+{
+	int result;
+
+	switch (cmd) {
+	case IWL_TM_CMD_APP2DEV_READ_TRACE:
+		IWL_DEBUG_INFO(tst->trans, "uCode trace cmd\n");
+		result = iwl_test_trace_dump(tst, skb, cb);
+		break;
+
+	case IWL_TM_CMD_APP2DEV_INDIRECT_BUFFER_DUMP:
+		IWL_DEBUG_INFO(tst->trans, "testmode sram dump cmd\n");
+		result = iwl_test_buffer_dump(tst, skb, cb);
+		break;
+
+	default:
+		result = 1;
+		break;
+	}
+	return result;
+}
+EXPORT_SYMBOL_GPL(iwl_test_dump);
+
+/*
+ * Multicast a spontaneous messages from the device to the user space.
+ */
+static void iwl_test_send_rx(struct iwl_test *tst, struct ieee80211_hw *hw,
+			     struct iwl_rx_cmd_buffer *rxb)
+{
+	struct sk_buff *skb;
+	struct iwl_rx_packet *data;
+	int length;
+
+	data = rxb_addr(rxb);
+	length = le32_to_cpu(data->len_n_flags) & FH_RSCSR_FRAME_SIZE_MSK;
+
+	/* the length doesn't include len_n_flags field, so add it manually */
+	length += sizeof(__le32);
+
+	skb = cfg80211_testmode_alloc_event_skb(hw->wiphy, 20 + length,
+								GFP_ATOMIC);
+	if (skb == NULL) {
+		IWL_ERR(tst->trans, "Out of memory for message to user\n");
+		return;
+	}
+
+	if (nla_put_u32(skb, IWL_TM_ATTR_COMMAND,
+			IWL_TM_CMD_DEV2APP_UCODE_RX_PKT) ||
+	    nla_put(skb, IWL_TM_ATTR_UCODE_RX_PKT, length, data))
+		goto nla_put_failure;
+
+	cfg80211_testmode_event(skb, GFP_ATOMIC);
+	return;
+
+nla_put_failure:
+	kfree_skb(skb);
+	IWL_ERR(tst->trans, "Ouch, overran buffer, check allocation!\n");
+}
+
+/*
+ * Called whenever a Rx frames is recevied from the device. If notifications to
+ * the user space are requested, sends the frames to the user.
+ */
+void iwl_test_rx(struct iwl_test *tst, struct ieee80211_hw *hw,
+		 struct iwl_rx_cmd_buffer *rxb)
+{
+	if (tst->notify)
+		iwl_test_send_rx(tst, hw, rxb);
+}
+EXPORT_SYMBOL_GPL(iwl_test_rx);
diff --git a/drivers/net/wireless/iwlwifi/iwl-test.h b/drivers/net/wireless/iwlwifi/iwl-test.h
new file mode 100644
index 0000000..9946153
--- /dev/null
+++ b/drivers/net/wireless/iwlwifi/iwl-test.h
@@ -0,0 +1,125 @@
+/******************************************************************************
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2010 - 2012 Intel Corporation. All rights reserved.
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
+ * Copyright(c) 2010 - 2012 Intel Corporation. All rights reserved.
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
+#ifndef __IWL_TEST_H__
+#define __IWL_TEST_H__
+
+#include <linux/types.h>
+#include "iwl-trans.h"
+
+struct iwl_test_trace {
+	u32 size;
+	u32 tsize;
+	u32 nchunks;
+	u8 *cpu_addr;
+	u8 *trace_addr;
+	dma_addr_t dma_addr;
+	bool enabled;
+};
+
+struct iwl_test_mem {
+	u32 size;
+	u32 nchunks;
+	u8 *addr;
+	bool in_read;
+};
+
+struct iwl_test_ops {
+	int (*send_cmd)(struct iwl_op_mode *op_modes,
+			struct iwl_host_cmd *cmd);
+	bool (*valid_hw_addr)(u32 addr);
+	u32 (*get_fw_ver)(struct iwl_op_mode *op_mode);
+};
+
+struct iwl_test {
+	struct iwl_trans *trans;
+	struct iwl_test_ops *ops;
+	struct iwl_test_trace trace;
+	struct iwl_test_mem mem;
+	bool notify;
+};
+
+void iwl_test_init(struct iwl_test *tst, struct iwl_trans *trans,
+		   struct iwl_test_ops *ops);
+
+void iwl_test_free(struct iwl_test *tst);
+
+int iwl_test_parse(struct iwl_test *tst, struct nlattr **tb,
+		   void *data, int len);
+
+int iwl_test_handle_cmd(struct iwl_test *tst, struct ieee80211_hw *hw,
+			struct nlattr **tb);
+
+int iwl_test_dump(struct iwl_test *tst, u32 cmd, struct sk_buff *skb,
+		  struct netlink_callback *cb);
+
+void iwl_test_rx(struct iwl_test *tst, struct ieee80211_hw *hw,
+		 struct iwl_rx_cmd_buffer *rxb);
+
+static inline void iwl_test_enable_notifications(struct iwl_test *tst,
+						 bool enable)
+{
+	tst->notify = enable;
+}
+
+#endif
diff --git a/drivers/net/wireless/iwlwifi/dvm/testmode.h b/drivers/net/wireless/iwlwifi/iwl-testmode.h
similarity index 100%
rename from drivers/net/wireless/iwlwifi/dvm/testmode.h
rename to drivers/net/wireless/iwlwifi/iwl-testmode.h
-- 
1.7.10

