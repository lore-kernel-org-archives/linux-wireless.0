Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:23204 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753966Ab1LIBY7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Dec 2011 20:24:59 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, "Hsu, Kenny" <kenny.hsu@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 01/15] iwlwifi: add uCode version information support by testmode
Date: Thu,  8 Dec 2011 16:26:08 -0800
Message-Id: <1323390382-1678-2-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111209_022510_984407_6E972F0A)
In-Reply-To: <1323390382-1678-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1323390382-1678-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hsu, Kenny <kenny.hsu@intel.com>

Create new tm command to report uCode version to userspace
- IWL_TM_CMD_APP2DEV_GET_FW_VERSION

Signed-off-by: Kenny Hsu <kenny.hsu@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-testmode.c |   18 ++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-testmode.h |   11 +++++++++--
 2 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-testmode.c b/drivers/net/wireless/iwlwifi/iwl-testmode.c
index ff72dbc..131a73d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-testmode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-testmode.c
@@ -110,6 +110,8 @@ struct nla_policy iwl_testmode_gnl_msg_policy[IWL_TM_ATTR_MAX] = {
 	[IWL_TM_ATTR_SRAM_ADDR] = { .type = NLA_U32, },
 	[IWL_TM_ATTR_SRAM_SIZE] = { .type = NLA_U32, },
 	[IWL_TM_ATTR_SRAM_DUMP] = { .type = NLA_UNSPEC, },
+
+	[IWL_TM_ATTR_FW_VERSION] = { .type = NLA_U32, },
 };
 
 /*
@@ -510,6 +512,21 @@ static int iwl_testmode_driver(struct ieee80211_hw *hw, struct nlattr **tb)
 		priv->tm_fixed_rate = nla_get_u32(tb[IWL_TM_ATTR_FIXRATE]);
 		break;
 
+	case IWL_TM_CMD_APP2DEV_GET_FW_VERSION:
+		IWL_INFO(priv, "uCode version raw: 0x%x\n", priv->ucode_ver);
+
+		skb = cfg80211_testmode_alloc_reply_skb(hw->wiphy, 20);
+		if (!skb) {
+			IWL_DEBUG_INFO(priv, "Error allocating memory\n");
+			return -ENOMEM;
+		}
+		NLA_PUT_U32(skb, IWL_TM_ATTR_FW_VERSION, priv->ucode_ver);
+		status = cfg80211_testmode_reply(skb);
+		if (status < 0)
+			IWL_DEBUG_INFO(priv,
+					"Error sending msg : %d\n", status);
+		break;
+
 	default:
 		IWL_DEBUG_INFO(priv, "Unknown testmode driver command ID\n");
 		return -ENOSYS;
@@ -842,6 +859,7 @@ int iwlagn_mac_testmode_cmd(struct ieee80211_hw *hw, void *data, int len)
 	case IWL_TM_CMD_APP2DEV_GET_EEPROM:
 	case IWL_TM_CMD_APP2DEV_FIXRATE_REQ:
 	case IWL_TM_CMD_APP2DEV_LOAD_WOWLAN_FW:
+	case IWL_TM_CMD_APP2DEV_GET_FW_VERSION:
 		IWL_DEBUG_INFO(priv, "testmode cmd to driver\n");
 		result = iwl_testmode_driver(hw, tb);
 		break;
diff --git a/drivers/net/wireless/iwlwifi/iwl-testmode.h b/drivers/net/wireless/iwlwifi/iwl-testmode.h
index deedd27..60c6db1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-testmode.h
+++ b/drivers/net/wireless/iwlwifi/iwl-testmode.h
@@ -118,6 +118,7 @@
  *	commands from user applicaiton to read data in sram
  *
  * @IWL_TM_CMD_APP2DEV_LOAD_WOWLAN_FW: load Weak On Wireless LAN uCode image
+ * @IWL_TM_CMD_APP2DEV_GET_FW_VERSION: retrieve uCode version
  *
  */
 enum iwl_tm_cmd_t {
@@ -143,7 +144,8 @@ enum iwl_tm_cmd_t {
 	IWL_TM_CMD_APP2DEV_READ_SRAM		= 20,
 	IWL_TM_CMD_APP2DEV_DUMP_SRAM		= 21,
 	IWL_TM_CMD_APP2DEV_LOAD_WOWLAN_FW	= 22,
-	IWL_TM_CMD_MAX				= 23,
+	IWL_TM_CMD_APP2DEV_GET_FW_VERSION	= 23,
+	IWL_TM_CMD_MAX				= 24,
 };
 
 /*
@@ -225,6 +227,10 @@ enum iwl_tm_cmd_t {
  *	When IWL_TM_ATTR_COMMAND is IWL_TM_CMD_APP2DEV_DUMP_SRAM,
  *	IWL_TM_ATTR_SRAM_DUMP for the data in sram
  *
+ * @IWL_TM_ATTR_FW_VERSION:
+ *	When IWL_TM_ATTR_COMMAND is IWL_TM_CMD_APP2DEV_GET_FW_VERSION,
+ *	IWL_TM_ATTR_FW_VERSION for the uCode version
+ *
  */
 enum iwl_tm_attr_t {
 	IWL_TM_ATTR_NOT_APPLICABLE		= 0,
@@ -245,7 +251,8 @@ enum iwl_tm_attr_t {
 	IWL_TM_ATTR_SRAM_ADDR			= 15,
 	IWL_TM_ATTR_SRAM_SIZE			= 16,
 	IWL_TM_ATTR_SRAM_DUMP			= 17,
-	IWL_TM_ATTR_MAX				= 18,
+	IWL_TM_ATTR_FW_VERSION			= 18,
+	IWL_TM_ATTR_MAX				= 19,
 };
 
 /* uCode trace buffer */
-- 
1.7.0.4

