Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:35769 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759269Ab2AFWTs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jan 2012 17:19:48 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Kenny Hsu <kenny.hsu@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 6/7] iwlwifi: add testmode cmd IWL_TM_CMD_APP2DEV_GET_FW_INFO
Date: Fri,  6 Jan 2012 13:16:32 -0800
Message-Id: <1325884593-31298-7-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120106_232005_917803_8BD853B8)
In-Reply-To: <1325884593-31298-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1325884593-31298-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kenny Hsu <kenny.hsu@intel.com>

Add new testmode command IWL_TM_CMD_APP2DEV_GET_FW_INFO for
reporting the following information of existing loaded uCode image.
+ uCode type
+ Instruction section size
+ Data section size

Signed-off-by: Kenny Hsu <kenny.hsu@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-testmode.c |   41 ++++++++++++++++++++++++++-
 drivers/net/wireless/iwlwifi/iwl-testmode.h |   19 +++++++++++-
 2 files changed, 57 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-testmode.c b/drivers/net/wireless/iwlwifi/iwl-testmode.c
index b56cd90..7684c0e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-testmode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-testmode.c
@@ -115,6 +115,9 @@ struct nla_policy iwl_testmode_gnl_msg_policy[IWL_TM_ATTR_MAX] = {
 
 	[IWL_TM_ATTR_FW_VERSION] = { .type = NLA_U32, },
 	[IWL_TM_ATTR_DEVICE_ID] = { .type = NLA_U32, },
+	[IWL_TM_ATTR_FW_TYPE] = { .type = NLA_U32, },
+	[IWL_TM_ATTR_FW_INST_SIZE] = { .type = NLA_U32, },
+	[IWL_TM_ATTR_FW_DATA_SIZE] = { .type = NLA_U32, },
 };
 
 /*
@@ -422,7 +425,7 @@ static int iwl_testmode_driver(struct ieee80211_hw *hw, struct nlattr **tb)
 	struct sk_buff *skb;
 	unsigned char *rsp_data_ptr = NULL;
 	int status = 0, rsp_data_len = 0;
-	u32 devid;
+	u32 devid, inst_size = 0, data_size = 0;
 
 	switch (nla_get_u32(tb[IWL_TM_ATTR_COMMAND])) {
 	case IWL_TM_CMD_APP2DEV_GET_DEVICENAME:
@@ -548,6 +551,41 @@ static int iwl_testmode_driver(struct ieee80211_hw *hw, struct nlattr **tb)
 					"Error sending msg : %d\n", status);
 		break;
 
+	case IWL_TM_CMD_APP2DEV_GET_FW_INFO:
+		skb = cfg80211_testmode_alloc_reply_skb(hw->wiphy, 20 + 8);
+		if (!skb) {
+			IWL_DEBUG_INFO(priv, "Error allocating memory\n");
+			return -ENOMEM;
+		}
+		switch (priv->shrd->ucode_type) {
+		case IWL_UCODE_REGULAR:
+			inst_size = trans(priv)->ucode_rt.code.len;
+			data_size = trans(priv)->ucode_rt.data.len;
+			break;
+		case IWL_UCODE_INIT:
+			inst_size = trans(priv)->ucode_init.code.len;
+			data_size = trans(priv)->ucode_init.data.len;
+			break;
+		case IWL_UCODE_WOWLAN:
+			inst_size = trans(priv)->ucode_wowlan.code.len;
+			data_size = trans(priv)->ucode_wowlan.data.len;
+			break;
+		case IWL_UCODE_NONE:
+			IWL_DEBUG_INFO(priv, "The uCode has not been loaded\n");
+			break;
+		default:
+			IWL_DEBUG_INFO(priv, "Unsupported uCode type\n");
+			break;
+		}
+		NLA_PUT_U32(skb, IWL_TM_ATTR_FW_TYPE, priv->shrd->ucode_type);
+		NLA_PUT_U32(skb, IWL_TM_ATTR_FW_INST_SIZE, inst_size);
+		NLA_PUT_U32(skb, IWL_TM_ATTR_FW_DATA_SIZE, data_size);
+		status = cfg80211_testmode_reply(skb);
+		if (status < 0)
+			IWL_DEBUG_INFO(priv,
+					"Error sending msg : %d\n", status);
+		break;
+
 	default:
 		IWL_DEBUG_INFO(priv, "Unknown testmode driver command ID\n");
 		return -ENOSYS;
@@ -881,6 +919,7 @@ int iwlagn_mac_testmode_cmd(struct ieee80211_hw *hw, void *data, int len)
 	case IWL_TM_CMD_APP2DEV_LOAD_WOWLAN_FW:
 	case IWL_TM_CMD_APP2DEV_GET_FW_VERSION:
 	case IWL_TM_CMD_APP2DEV_GET_DEVICE_ID:
+	case IWL_TM_CMD_APP2DEV_GET_FW_INFO:
 		IWL_DEBUG_INFO(priv, "testmode cmd to driver\n");
 		result = iwl_testmode_driver(hw, tb);
 		break;
diff --git a/drivers/net/wireless/iwlwifi/iwl-testmode.h b/drivers/net/wireless/iwlwifi/iwl-testmode.h
index 9c6a67a..cb0cf35 100644
--- a/drivers/net/wireless/iwlwifi/iwl-testmode.h
+++ b/drivers/net/wireless/iwlwifi/iwl-testmode.h
@@ -120,6 +120,8 @@
  * @IWL_TM_CMD_APP2DEV_LOAD_WOWLAN_FW: load Weak On Wireless LAN uCode image
  * @IWL_TM_CMD_APP2DEV_GET_FW_VERSION: retrieve uCode version
  * @IWL_TM_CMD_APP2DEV_GET_DEVICE_ID: retrieve ID information in device
+ * @IWL_TM_CMD_APP2DEV_GET_FW_INFO:
+ *	retrieve informration of existing loaded uCode image
  *
  */
 enum iwl_tm_cmd_t {
@@ -147,7 +149,8 @@ enum iwl_tm_cmd_t {
 	IWL_TM_CMD_APP2DEV_LOAD_WOWLAN_FW	= 22,
 	IWL_TM_CMD_APP2DEV_GET_FW_VERSION	= 23,
 	IWL_TM_CMD_APP2DEV_GET_DEVICE_ID	= 24,
-	IWL_TM_CMD_MAX				= 25,
+	IWL_TM_CMD_APP2DEV_GET_FW_INFO		= 25,
+	IWL_TM_CMD_MAX				= 26,
 };
 
 /*
@@ -237,6 +240,15 @@ enum iwl_tm_cmd_t {
  *	When IWL_TM_ATTR_COMMAND is IWL_TM_CMD_APP2DEV_GET_DEVICE_ID,
  *	IWL_TM_ATTR_DEVICE_ID for the device ID information
  *
+ * @IWL_TM_ATTR_FW_TYPE:
+ * @IWL_TM_ATTR_FW_INST_SIZE:
+ * @IWL_TM_ATTR_FW_DATA_SIZE:
+ *	When IWL_TM_ATTR_COMMAND is IWL_TM_CMD_APP2DEV_GET_FW_INFO,
+ *	The mandatory fields are:
+ *	IWL_TM_ATTR_FW_TYPE for the uCode type (INIT/RUNTIME/...)
+ *	IWL_TM_ATTR_FW_INST_SIZE for the size of instruction section
+ *	IWL_TM_ATTR_FW_DATA_SIZE for the size of data section
+ *
  */
 enum iwl_tm_attr_t {
 	IWL_TM_ATTR_NOT_APPLICABLE		= 0,
@@ -259,7 +271,10 @@ enum iwl_tm_attr_t {
 	IWL_TM_ATTR_SRAM_DUMP			= 17,
 	IWL_TM_ATTR_FW_VERSION			= 18,
 	IWL_TM_ATTR_DEVICE_ID			= 19,
-	IWL_TM_ATTR_MAX				= 20,
+	IWL_TM_ATTR_FW_TYPE			= 20,
+	IWL_TM_ATTR_FW_INST_SIZE		= 21,
+	IWL_TM_ATTR_FW_DATA_SIZE		= 22,
+	IWL_TM_ATTR_MAX				= 23,
 };
 
 /* uCode trace buffer */
-- 
1.7.0.4

