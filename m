Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:19787 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752064Ab1KYUIS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Nov 2011 15:08:18 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, "Hsu, Kenny" <kenny.hsu@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 1/7] iwlwifi: add tm commands for indirect register access
Date: Fri, 25 Nov 2011 11:11:42 -0800
Message-Id: <1322248308-5113-2-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111125_210827_399561_1782243E)
In-Reply-To: <1322248308-5113-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1322248308-5113-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hsu, Kenny <kenny.hsu@intel.com>

Create new testmode commands to suppot indirect access
of peripheral register.
- IWL_TM_CMD_APP2DEV_INDIRECT_REG_READ32
- IWL_TM_CMD_APP2DEV_INDIRECT_REG_WRITE32

Meanwhile, add affix "DIRECT" into original register access
commands for better discrimination with new commands.
- IWL_TM_CMD_APP2DEV_DIRECT_REG_READ32
- IWL_TM_CMD_APP2DEV_DIRECT_REG_WRITE32
- IWL_TM_CMD_APP2DEV_DIRECT_REG_WRITE8

Signed-off-by: Kenny Hsu <kenny.hsu@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-sv-open.c  |   40 +++++++++++++++++++++++----
 drivers/net/wireless/iwlwifi/iwl-testmode.h |   20 +++++++++-----
 2 files changed, 47 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-sv-open.c b/drivers/net/wireless/iwlwifi/iwl-sv-open.c
index e3882d0..be16caf 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sv-open.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sv-open.c
@@ -276,7 +276,7 @@ static int iwl_testmode_reg(struct ieee80211_hw *hw, struct nlattr **tb)
 	IWL_INFO(priv, "testmode register access command offset 0x%x\n", ofs);
 
 	switch (nla_get_u32(tb[IWL_TM_ATTR_COMMAND])) {
-	case IWL_TM_CMD_APP2DEV_REG_READ32:
+	case IWL_TM_CMD_APP2DEV_DIRECT_REG_READ32:
 		val32 = iwl_read32(bus(priv), ofs);
 		IWL_INFO(priv, "32bit value to read 0x%x\n", val32);
 
@@ -291,7 +291,7 @@ static int iwl_testmode_reg(struct ieee80211_hw *hw, struct nlattr **tb)
 			IWL_DEBUG_INFO(priv,
 				       "Error sending msg : %d\n", status);
 		break;
-	case IWL_TM_CMD_APP2DEV_REG_WRITE32:
+	case IWL_TM_CMD_APP2DEV_DIRECT_REG_WRITE32:
 		if (!tb[IWL_TM_ATTR_REG_VALUE32]) {
 			IWL_DEBUG_INFO(priv,
 				       "Error finding value to write\n");
@@ -302,7 +302,7 @@ static int iwl_testmode_reg(struct ieee80211_hw *hw, struct nlattr **tb)
 			iwl_write32(bus(priv), ofs, val32);
 		}
 		break;
-	case IWL_TM_CMD_APP2DEV_REG_WRITE8:
+	case IWL_TM_CMD_APP2DEV_DIRECT_REG_WRITE8:
 		if (!tb[IWL_TM_ATTR_REG_VALUE8]) {
 			IWL_DEBUG_INFO(priv, "Error finding value to write\n");
 			return -ENOMSG;
@@ -312,6 +312,32 @@ static int iwl_testmode_reg(struct ieee80211_hw *hw, struct nlattr **tb)
 			iwl_write8(bus(priv), ofs, val8);
 		}
 		break;
+	case IWL_TM_CMD_APP2DEV_INDIRECT_REG_READ32:
+		val32 = iwl_read_prph(bus(priv), ofs);
+		IWL_INFO(priv, "32bit value to read 0x%x\n", val32);
+
+		skb = cfg80211_testmode_alloc_reply_skb(hw->wiphy, 20);
+		if (!skb) {
+			IWL_DEBUG_INFO(priv, "Error allocating memory\n");
+			return -ENOMEM;
+		}
+		NLA_PUT_U32(skb, IWL_TM_ATTR_REG_VALUE32, val32);
+		status = cfg80211_testmode_reply(skb);
+		if (status < 0)
+			IWL_DEBUG_INFO(priv,
+					"Error sending msg : %d\n", status);
+		break;
+	case IWL_TM_CMD_APP2DEV_INDIRECT_REG_WRITE32:
+		if (!tb[IWL_TM_ATTR_REG_VALUE32]) {
+			IWL_DEBUG_INFO(priv,
+					"Error finding value to write\n");
+			return -ENOMSG;
+		} else {
+			val32 = nla_get_u32(tb[IWL_TM_ATTR_REG_VALUE32]);
+			IWL_INFO(priv, "32bit value to write 0x%x\n", val32);
+			iwl_write_prph(bus(priv), ofs, val32);
+		}
+		break;
 	default:
 		IWL_DEBUG_INFO(priv, "Unknown testmode register command ID\n");
 		return -ENOSYS;
@@ -665,9 +691,11 @@ int iwlagn_mac_testmode_cmd(struct ieee80211_hw *hw, void *data, int len)
 		IWL_DEBUG_INFO(priv, "testmode cmd to uCode\n");
 		result = iwl_testmode_ucode(hw, tb);
 		break;
-	case IWL_TM_CMD_APP2DEV_REG_READ32:
-	case IWL_TM_CMD_APP2DEV_REG_WRITE32:
-	case IWL_TM_CMD_APP2DEV_REG_WRITE8:
+	case IWL_TM_CMD_APP2DEV_DIRECT_REG_READ32:
+	case IWL_TM_CMD_APP2DEV_DIRECT_REG_WRITE32:
+	case IWL_TM_CMD_APP2DEV_DIRECT_REG_WRITE8:
+	case IWL_TM_CMD_APP2DEV_INDIRECT_REG_READ32:
+	case IWL_TM_CMD_APP2DEV_INDIRECT_REG_WRITE32:
 		IWL_DEBUG_INFO(priv, "testmode cmd to register\n");
 		result = iwl_testmode_reg(hw, tb);
 		break;
diff --git a/drivers/net/wireless/iwlwifi/iwl-testmode.h b/drivers/net/wireless/iwlwifi/iwl-testmode.h
index b980bda..1779648 100644
--- a/drivers/net/wireless/iwlwifi/iwl-testmode.h
+++ b/drivers/net/wireless/iwlwifi/iwl-testmode.h
@@ -76,9 +76,9 @@
  *	the actual uCode host command ID is carried with
  *	IWL_TM_ATTR_UCODE_CMD_ID
  *
- * @IWL_TM_CMD_APP2DEV_REG_READ32:
- * @IWL_TM_CMD_APP2DEV_REG_WRITE32:
- * @IWL_TM_CMD_APP2DEV_REG_WRITE8:
+ * @IWL_TM_CMD_APP2DEV_DIRECT_REG_READ32:
+ * @IWL_TM_CMD_APP2DEV_DIRECT_REG_WRITE32:
+ * @IWL_TM_CMD_APP2DEV_DIRECT_REG_WRITE8:
  *	commands from user applicaiton to access register
  *
  * @IWL_TM_CMD_APP2DEV_GET_DEVICENAME: retrieve device name
@@ -107,12 +107,16 @@
  *	commands from user application to own change the ownership of the uCode
  *	if application has the ownership, the only host command from
  *	testmode will deliver to uCode. Default owner is driver
+ * @IWL_TM_CMD_APP2DEV_INDIRECT_REG_READ32:
+ * @IWL_TM_CMD_APP2DEV_INDIRECT_REG_WRITE32:
+ *	commands from user applicaiton to indirectly access peripheral register
+ *
  */
 enum iwl_tm_cmd_t {
 	IWL_TM_CMD_APP2DEV_UCODE		= 1,
-	IWL_TM_CMD_APP2DEV_REG_READ32		= 2,
-	IWL_TM_CMD_APP2DEV_REG_WRITE32		= 3,
-	IWL_TM_CMD_APP2DEV_REG_WRITE8		= 4,
+	IWL_TM_CMD_APP2DEV_DIRECT_REG_READ32	= 2,
+	IWL_TM_CMD_APP2DEV_DIRECT_REG_WRITE32	= 3,
+	IWL_TM_CMD_APP2DEV_DIRECT_REG_WRITE8	= 4,
 	IWL_TM_CMD_APP2DEV_GET_DEVICENAME	= 5,
 	IWL_TM_CMD_APP2DEV_LOAD_INIT_FW		= 6,
 	IWL_TM_CMD_APP2DEV_CFG_INIT_CALIB	= 7,
@@ -126,7 +130,9 @@ enum iwl_tm_cmd_t {
 	IWL_TM_CMD_DEV2APP_UCODE_RX_PKT		= 15,
 	IWL_TM_CMD_DEV2APP_EEPROM_RSP		= 16,
 	IWL_TM_CMD_APP2DEV_OWNERSHIP		= 17,
-	IWL_TM_CMD_MAX				= 18,
+	IWL_TM_CMD_APP2DEV_INDIRECT_REG_READ32	= 18,
+	IWL_TM_CMD_APP2DEV_INDIRECT_REG_WRITE32	= 19,
+	IWL_TM_CMD_MAX				= 20,
 };
 
 /*
-- 
1.7.0.4

