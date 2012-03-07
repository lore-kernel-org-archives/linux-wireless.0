Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:48759 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759715Ab2CGTGf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Mar 2012 14:06:35 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Amit Beka <amit.beka@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH RESEND 20/35] iwlwifi: add testmode command for rx forwarding
Date: Wed,  7 Mar 2012 09:52:29 -0800
Message-Id: <1331142764-5750-21-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120307_200647_967947_C81CD194)
In-Reply-To: <1331142764-5750-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1331142764-5750-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amit Beka <amit.beka@intel.com>

Added a testmode command which tells iwl_rx_dispatch
to send the RX both as a notification to nl80211 and
with the registered RX handlers.

This is used for monitoring RX from userspace while preserving
the regular flows in the driver.

Signed-off-by: Amit Beka <amit.beka@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rx.c   |   20 +++++++++++++---
 drivers/net/wireless/iwlwifi/iwl-testmode.c |   32 ++++++++++++++++++++++++--
 drivers/net/wireless/iwlwifi/iwl-testmode.h |   13 +++++++++-
 3 files changed, 56 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rx.c b/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
index e504675..8e7cdfa 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
@@ -1152,6 +1152,8 @@ int iwl_rx_dispatch(struct iwl_op_mode *op_mode, struct iwl_rx_cmd_buffer *rxb,
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	struct iwl_priv *priv = IWL_OP_MODE_GET_DVM(op_mode);
+	void (*pre_rx_handler)(struct iwl_priv *,
+			       struct iwl_rx_cmd_buffer *);
 	int err = 0;
 
 	/*
@@ -1161,10 +1163,20 @@ int iwl_rx_dispatch(struct iwl_op_mode *op_mode, struct iwl_rx_cmd_buffer *rxb,
 	 */
 	iwl_notification_wait_notify(&priv->notif_wait, pkt);
 
-	if (priv->pre_rx_handler &&
-	    priv->ucode_owner == IWL_OWNERSHIP_TM)
-		priv->pre_rx_handler(priv, rxb);
-	else {
+	/* RX data may be forwarded to userspace (using pre_rx_handler) in one
+	 * of two cases: the first, that the user owns the uCode through
+	 * testmode - in such case the pre_rx_handler is set and no further
+	 * processing takes place. The other case is when the user want to
+	 * monitor the rx w/o affecting the regular flow - the pre_rx_handler
+	 * will be set but the ownership flag != IWL_OWNERSHIP_TM and the flow
+	 * continues.
+	 * We need to use ACCESS_ONCE to prevent a case where the handler
+	 * changes between the check and the call.
+	 */
+	pre_rx_handler = ACCESS_ONCE(priv->pre_rx_handler);
+	if (pre_rx_handler)
+		pre_rx_handler(priv, rxb);
+	if (priv->ucode_owner != IWL_OWNERSHIP_TM) {
 		/* Based on type of command response or notification,
 		 *   handle those that need handling via function in
 		 *   rx_handlers table.  See iwl_setup_rx_handlers() */
diff --git a/drivers/net/wireless/iwlwifi/iwl-testmode.c b/drivers/net/wireless/iwlwifi/iwl-testmode.c
index 1d73209..b8044bc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-testmode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-testmode.c
@@ -125,6 +125,8 @@ struct nla_policy iwl_testmode_gnl_msg_policy[IWL_TM_ATTR_MAX] = {
 	[IWL_TM_ATTR_FW_TYPE] = { .type = NLA_U32, },
 	[IWL_TM_ATTR_FW_INST_SIZE] = { .type = NLA_U32, },
 	[IWL_TM_ATTR_FW_DATA_SIZE] = { .type = NLA_U32, },
+
+	[IWL_TM_ATTR_ENABLE_NOTIFICATION] = {.type = NLA_FLAG, },
 };
 
 /*
@@ -194,7 +196,7 @@ nla_put_failure:
 
 void iwl_testmode_init(struct iwl_priv *priv)
 {
-	priv->pre_rx_handler = iwl_testmode_ucode_rx_pkt;
+	priv->pre_rx_handler = NULL;
 	priv->testmode_trace.trace_enabled = false;
 	priv->testmode_mem.read_in_progress = false;
 }
@@ -770,9 +772,13 @@ static int iwl_testmode_ownership(struct ieee80211_hw *hw, struct nlattr **tb)
 	}
 
 	owner = nla_get_u8(tb[IWL_TM_ATTR_UCODE_OWNER]);
-	if ((owner == IWL_OWNERSHIP_DRIVER) || (owner == IWL_OWNERSHIP_TM))
+	if (owner == IWL_OWNERSHIP_DRIVER) {
 		priv->ucode_owner = owner;
-	else {
+		priv->pre_rx_handler = NULL;
+	} else if (owner == IWL_OWNERSHIP_TM) {
+		priv->pre_rx_handler = iwl_testmode_ucode_rx_pkt;
+		priv->ucode_owner = owner;
+	} else {
 		IWL_ERR(priv, "Invalid owner\n");
 		return -EINVAL;
 	}
@@ -937,6 +943,20 @@ static int iwl_testmode_buffer_dump(struct ieee80211_hw *hw,
 	return -ENOBUFS;
 }
 
+static int iwl_testmode_notifications(struct ieee80211_hw *hw,
+	struct nlattr **tb)
+{
+	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
+	bool enable;
+
+	enable = nla_get_flag(tb[IWL_TM_ATTR_ENABLE_NOTIFICATION]);
+	if (enable)
+		priv->pre_rx_handler = iwl_testmode_ucode_rx_pkt;
+	else
+		priv->pre_rx_handler = NULL;
+	return 0;
+}
+
 
 /* The testmode gnl message handler that takes the gnl message from the
  * user space and parses it per the policy iwl_testmode_gnl_msg_policy, then
@@ -1022,6 +1042,12 @@ int iwlagn_mac_testmode_cmd(struct ieee80211_hw *hw, void *data, int len)
 		result = iwl_testmode_indirect_mem(hw, tb);
 		break;
 
+	case IWL_TM_CMD_APP2DEV_NOTIFICATIONS:
+		IWL_DEBUG_INFO(priv, "testmode notifications cmd "
+			"to driver\n");
+		result = iwl_testmode_notifications(hw, tb);
+		break;
+
 	default:
 		IWL_ERR(priv, "Unknown testmode command\n");
 		result = -ENOSYS;
diff --git a/drivers/net/wireless/iwlwifi/iwl-testmode.h b/drivers/net/wireless/iwlwifi/iwl-testmode.h
index 69b2e80..6ba211b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-testmode.h
+++ b/drivers/net/wireless/iwlwifi/iwl-testmode.h
@@ -122,6 +122,9 @@
  *	Fore reading, a READ command is sent from the userspace and the data
  *	is returned when the user calls a DUMP command.
  *	For writing, only a WRITE command is used.
+ * @IWL_TM_CMD_APP2DEV_NOTIFICATIONS:
+ *	Command to enable/disable notifications (currently RX packets) from the
+ *	driver to userspace.
  */
 enum iwl_tm_cmd_t {
 	IWL_TM_CMD_APP2DEV_UCODE		= 1,
@@ -152,7 +155,8 @@ enum iwl_tm_cmd_t {
 	IWL_TM_CMD_APP2DEV_INDIRECT_BUFFER_READ = 26,
 	IWL_TM_CMD_APP2DEV_INDIRECT_BUFFER_DUMP = 27,
 	IWL_TM_CMD_APP2DEV_INDIRECT_BUFFER_WRITE = 28,
-	IWL_TM_CMD_MAX				= 29,
+	IWL_TM_CMD_APP2DEV_NOTIFICATIONS	= 29,
+	IWL_TM_CMD_MAX				= 30,
 };
 
 /*
@@ -256,6 +260,10 @@ enum iwl_tm_cmd_t {
  *	When IWL_TM_ATTR_COMMAND is IWL_TM_CMD_APP2DEV_UCODE this flag
  *	indicates that the user wants to receive the response of the command
  *	in a reply SKB. If it's not present, the response is not returned.
+ * @IWL_TM_ATTR_ENABLE_NOTIFICATIONS:
+ *	When IWL_TM_ATTR_COMMAND is IWL_TM_CMD_APP2DEV_NOTIFICATIONS, this
+ *	flag enables (if present) or disables (if not) the forwarding
+ *	to userspace.
  */
 enum iwl_tm_attr_t {
 	IWL_TM_ATTR_NOT_APPLICABLE		= 0,
@@ -282,7 +290,8 @@ enum iwl_tm_attr_t {
 	IWL_TM_ATTR_FW_INST_SIZE		= 21,
 	IWL_TM_ATTR_FW_DATA_SIZE		= 22,
 	IWL_TM_ATTR_UCODE_CMD_SKB		= 23,
-	IWL_TM_ATTR_MAX				= 24,
+	IWL_TM_ATTR_ENABLE_NOTIFICATION		= 24,
+	IWL_TM_ATTR_MAX				= 25,
 };
 
 /* uCode trace buffer */
-- 
1.7.0.4

