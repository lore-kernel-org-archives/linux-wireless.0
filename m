Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:63468 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753977Ab1LIBZB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Dec 2011 20:25:01 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, "Hsu, Kenny" <kenny.hsu@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 07/15] iwlwifi: add device ID information support by testmode
Date: Thu,  8 Dec 2011 16:26:14 -0800
Message-Id: <1323390382-1678-8-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111209_022535_454507_1587E816)
In-Reply-To: <1323390382-1678-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1323390382-1678-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hsu, Kenny <kenny.hsu@intel.com>

Create new tm command to report devce ID information to userspace
- IWL_TM_CMD_APP2DEV_GET_DEVICE_ID

Signed-off-by: Kenny Hsu <kenny.hsu@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-testmode.c |   27 +++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-testmode.h |   11 +++++++++--
 2 files changed, 36 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-testmode.c b/drivers/net/wireless/iwlwifi/iwl-testmode.c
index 131a73d..0b0ff11 100644
--- a/drivers/net/wireless/iwlwifi/iwl-testmode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-testmode.c
@@ -77,6 +77,7 @@
 #include "iwl-agn.h"
 #include "iwl-testmode.h"
 #include "iwl-trans.h"
+#include "iwl-bus.h"
 
 /* The TLVs used in the gnl message policy between the kernel module and
  * user space application. iwl_testmode_gnl_msg_policy is to be carried
@@ -112,6 +113,7 @@ struct nla_policy iwl_testmode_gnl_msg_policy[IWL_TM_ATTR_MAX] = {
 	[IWL_TM_ATTR_SRAM_DUMP] = { .type = NLA_UNSPEC, },
 
 	[IWL_TM_ATTR_FW_VERSION] = { .type = NLA_U32, },
+	[IWL_TM_ATTR_DEVICE_ID] = { .type = NLA_U32, },
 };
 
 /*
@@ -418,6 +420,8 @@ static int iwl_testmode_driver(struct ieee80211_hw *hw, struct nlattr **tb)
 	struct sk_buff *skb;
 	unsigned char *rsp_data_ptr = NULL;
 	int status = 0, rsp_data_len = 0;
+	char buf[32], *ptr = NULL;
+	unsigned int num, devid;
 
 	switch (nla_get_u32(tb[IWL_TM_ATTR_COMMAND])) {
 	case IWL_TM_CMD_APP2DEV_GET_DEVICENAME:
@@ -527,6 +531,28 @@ static int iwl_testmode_driver(struct ieee80211_hw *hw, struct nlattr **tb)
 					"Error sending msg : %d\n", status);
 		break;
 
+	case IWL_TM_CMD_APP2DEV_GET_DEVICE_ID:
+		bus_get_hw_id(bus(priv), buf, sizeof(buf));
+		ptr = buf;
+		strsep(&ptr, ":");
+		sscanf(strsep(&ptr, ":"), "%x", &num);
+		sscanf(strsep(&ptr, ":"), "%x", &devid);
+		IWL_INFO(priv, "Device ID = 0x%04x, SubDevice ID= 0x%04x\n",
+				num, devid);
+		devid |= (num << 16);
+
+		skb = cfg80211_testmode_alloc_reply_skb(hw->wiphy, 20);
+		if (!skb) {
+			IWL_DEBUG_INFO(priv, "Error allocating memory\n");
+			return -ENOMEM;
+		}
+		NLA_PUT_U32(skb, IWL_TM_ATTR_DEVICE_ID, devid);
+		status = cfg80211_testmode_reply(skb);
+		if (status < 0)
+			IWL_DEBUG_INFO(priv,
+					"Error sending msg : %d\n", status);
+		break;
+
 	default:
 		IWL_DEBUG_INFO(priv, "Unknown testmode driver command ID\n");
 		return -ENOSYS;
@@ -860,6 +886,7 @@ int iwlagn_mac_testmode_cmd(struct ieee80211_hw *hw, void *data, int len)
 	case IWL_TM_CMD_APP2DEV_FIXRATE_REQ:
 	case IWL_TM_CMD_APP2DEV_LOAD_WOWLAN_FW:
 	case IWL_TM_CMD_APP2DEV_GET_FW_VERSION:
+	case IWL_TM_CMD_APP2DEV_GET_DEVICE_ID:
 		IWL_DEBUG_INFO(priv, "testmode cmd to driver\n");
 		result = iwl_testmode_driver(hw, tb);
 		break;
diff --git a/drivers/net/wireless/iwlwifi/iwl-testmode.h b/drivers/net/wireless/iwlwifi/iwl-testmode.h
index 60c6db1..26138f1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-testmode.h
+++ b/drivers/net/wireless/iwlwifi/iwl-testmode.h
@@ -119,6 +119,7 @@
  *
  * @IWL_TM_CMD_APP2DEV_LOAD_WOWLAN_FW: load Weak On Wireless LAN uCode image
  * @IWL_TM_CMD_APP2DEV_GET_FW_VERSION: retrieve uCode version
+ * @IWL_TM_CMD_APP2DEV_GET_DEVICE_ID: retrieve ID information in device
  *
  */
 enum iwl_tm_cmd_t {
@@ -145,7 +146,8 @@ enum iwl_tm_cmd_t {
 	IWL_TM_CMD_APP2DEV_DUMP_SRAM		= 21,
 	IWL_TM_CMD_APP2DEV_LOAD_WOWLAN_FW	= 22,
 	IWL_TM_CMD_APP2DEV_GET_FW_VERSION	= 23,
-	IWL_TM_CMD_MAX				= 24,
+	IWL_TM_CMD_APP2DEV_GET_DEVICE_ID	= 24,
+	IWL_TM_CMD_MAX				= 25,
 };
 
 /*
@@ -231,6 +233,10 @@ enum iwl_tm_cmd_t {
  *	When IWL_TM_ATTR_COMMAND is IWL_TM_CMD_APP2DEV_GET_FW_VERSION,
  *	IWL_TM_ATTR_FW_VERSION for the uCode version
  *
+ * @IWL_TM_ATTR_DEVICE_ID:
+ *	When IWL_TM_ATTR_COMMAND is IWL_TM_CMD_APP2DEV_GET_DEVICE_ID,
+ *	IWL_TM_ATTR_DEVICE_ID for the device ID information
+ *
  */
 enum iwl_tm_attr_t {
 	IWL_TM_ATTR_NOT_APPLICABLE		= 0,
@@ -252,7 +258,8 @@ enum iwl_tm_attr_t {
 	IWL_TM_ATTR_SRAM_SIZE			= 16,
 	IWL_TM_ATTR_SRAM_DUMP			= 17,
 	IWL_TM_ATTR_FW_VERSION			= 18,
-	IWL_TM_ATTR_MAX				= 19,
+	IWL_TM_ATTR_DEVICE_ID			= 19,
+	IWL_TM_ATTR_MAX				= 20,
 };
 
 /* uCode trace buffer */
-- 
1.7.0.4

