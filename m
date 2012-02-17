Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:10956 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752146Ab2BQUXu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Feb 2012 15:23:50 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Amit Beka <amit.beka@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 03/26] iwlwifi: added reply data to testmode HCMD send
Date: Fri, 17 Feb 2012 11:13:31 -0800
Message-Id: <1329506034-1394-4-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120217_212355_286795_A38C33BB)
In-Reply-To: <1329506034-1394-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1329506034-1394-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amit Beka <amit.beka@intel.com>

The testmode command for host command send now replies
with a nl80211 message and the response it recieved from
the device.

This does not change the API directly, but adds a reply
to the testmode call.

Signed-off-by: Amit Beka <amit.beka@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-testmode.c |   59 ++++++++++++++++++++++++---
 drivers/net/wireless/iwlwifi/iwl-testmode.h |   11 +++--
 2 files changed, 60 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-testmode.c b/drivers/net/wireless/iwlwifi/iwl-testmode.c
index debc9ab..e54a1dd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-testmode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-testmode.c
@@ -236,6 +236,7 @@ void iwl_testmode_cleanup(struct iwl_priv *priv)
 	iwl_mem_cleanup(priv);
 }
 
+
 /*
  * This function handles the user application commands to the ucode.
  *
@@ -244,8 +245,10 @@ void iwl_testmode_cleanup(struct iwl_priv *priv)
  * host command to the ucode.
  *
  * If any mandatory field is missing, -ENOMSG is replied to the user space
- * application; otherwise, the actual execution result of the host command to
- * ucode is replied.
+ * application; otherwise, waits for the host command to be sent and checks
+ * the return code. In case or error, it is returned, otherwise a reply is
+ * allocated and the reply RX packet
+ * is returned.
  *
  * @hw: ieee80211_hw object that represents the device
  * @tb: gnl message fields from the user space
@@ -254,6 +257,12 @@ static int iwl_testmode_ucode(struct ieee80211_hw *hw, struct nlattr **tb)
 {
 	struct iwl_priv *priv = hw->priv;
 	struct iwl_host_cmd cmd;
+	struct iwl_rx_packet *pkt;
+	struct sk_buff *skb;
+	void *reply_buf;
+	u32 reply_len;
+	int ret;
+	bool cmd_want_skb;
 
 	memset(&cmd, 0, sizeof(struct iwl_host_cmd));
 
@@ -263,15 +272,53 @@ static int iwl_testmode_ucode(struct ieee80211_hw *hw, struct nlattr **tb)
 		return -ENOMSG;
 	}
 
-	cmd.flags = CMD_ON_DEMAND;
+	cmd.flags = CMD_ON_DEMAND | CMD_SYNC;
+	cmd_want_skb = nla_get_flag(tb[IWL_TM_ATTR_UCODE_CMD_SKB]);
+	if (cmd_want_skb)
+		cmd.flags |= CMD_WANT_SKB;
+
 	cmd.id = nla_get_u8(tb[IWL_TM_ATTR_UCODE_CMD_ID]);
 	cmd.data[0] = nla_data(tb[IWL_TM_ATTR_UCODE_CMD_DATA]);
 	cmd.len[0] = nla_len(tb[IWL_TM_ATTR_UCODE_CMD_DATA]);
 	cmd.dataflags[0] = IWL_HCMD_DFL_NOCOPY;
-	IWL_INFO(priv, "testmode ucode command ID 0x%x, flags 0x%x,"
+	IWL_DEBUG_INFO(priv, "testmode ucode command ID 0x%x, flags 0x%x,"
 				" len %d\n", cmd.id, cmd.flags, cmd.len[0]);
-	/* ok, let's submit the command to ucode */
-	return iwl_trans_send_cmd(trans(priv), &cmd);
+
+	ret = iwl_trans_send_cmd(trans(priv), &cmd);
+	if (ret) {
+		IWL_ERR(priv, "Failed to send hcmd\n");
+		return ret;
+	}
+	if (!cmd_want_skb)
+		return ret;
+
+	/* Handling return of SKB to the user */
+	pkt = (struct iwl_rx_packet *)cmd.reply_page;
+	if (!pkt) {
+		IWL_ERR(priv, "HCMD received a null response packet\n");
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
+	memcpy(reply_buf, &(pkt->u), reply_len);
+	iwl_free_pages(priv->shrd, cmd.reply_page);
+
+	NLA_PUT_U32(skb, IWL_TM_ATTR_COMMAND, IWL_TM_CMD_DEV2APP_UCODE_RX_PKT);
+	NLA_PUT(skb, IWL_TM_ATTR_UCODE_RX_PKT, reply_len, reply_buf);
+	return cfg80211_testmode_reply(skb);
+
+nla_put_failure:
+	IWL_DEBUG_INFO(priv, "Failed creating NL attributes\n");
+	return -ENOMSG;
 }
 
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-testmode.h b/drivers/net/wireless/iwlwifi/iwl-testmode.h
index 3815cf3..69b2e80 100644
--- a/drivers/net/wireless/iwlwifi/iwl-testmode.h
+++ b/drivers/net/wireless/iwlwifi/iwl-testmode.h
@@ -99,7 +99,7 @@
  *	to user application
  * @IWL_TM_CMD_DEV2APP_UCODE_RX_PKT:
  *	commands from kernel space to multicast the spontaneous messages
- *	to user application
+ *	to user application, or reply of host commands
  * @IWL_TM_CMD_DEV2APP_EEPROM_RSP:
  *	commands from kernel space to carry the eeprom response
  *	to user application
@@ -173,8 +173,6 @@ enum iwl_tm_cmd_t {
  *	When IWL_TM_ATTR_COMMAND is IWL_TM_CMD_APP2DEV_UCODE,
  *	The mandatory fields are :
  *	IWL_TM_ATTR_UCODE_CMD_ID for recognizable command ID;
- *	IWL_TM_ATTR_COMMAND_FLAG for the flags of the commands;
- *	The optional fields are:
  *	IWL_TM_ATTR_UCODE_CMD_DATA for the actual command payload
  *	to the ucode
  *
@@ -254,6 +252,10 @@ enum iwl_tm_cmd_t {
  *	IWL_TM_ATTR_FW_INST_SIZE for the size of instruction section
  *	IWL_TM_ATTR_FW_DATA_SIZE for the size of data section
  *
+ * @IWL_TM_ATTR_UCODE_CMD_SKB:
+ *	When IWL_TM_ATTR_COMMAND is IWL_TM_CMD_APP2DEV_UCODE this flag
+ *	indicates that the user wants to receive the response of the command
+ *	in a reply SKB. If it's not present, the response is not returned.
  */
 enum iwl_tm_attr_t {
 	IWL_TM_ATTR_NOT_APPLICABLE		= 0,
@@ -279,7 +281,8 @@ enum iwl_tm_attr_t {
 	IWL_TM_ATTR_FW_TYPE			= 20,
 	IWL_TM_ATTR_FW_INST_SIZE		= 21,
 	IWL_TM_ATTR_FW_DATA_SIZE		= 22,
-	IWL_TM_ATTR_MAX				= 23,
+	IWL_TM_ATTR_UCODE_CMD_SKB		= 23,
+	IWL_TM_ATTR_MAX				= 24,
 };
 
 /* uCode trace buffer */
-- 
1.7.0.4

