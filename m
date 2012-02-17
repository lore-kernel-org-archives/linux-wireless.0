Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:10956 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752146Ab2BQUXs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Feb 2012 15:23:48 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 01/26] iwlwifi: log as error when error detected
Date: Fri, 17 Feb 2012 11:13:29 -0800
Message-Id: <1329506034-1394-2-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120217_212352_552798_5BAAF45B)
In-Reply-To: <1329506034-1394-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1329506034-1394-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A lot of error conditions in testmode log as IWL_DEBUG_INFO which is not
logged by default. Change it

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-testmode.c |  122 +++++++++++----------------
 1 files changed, 51 insertions(+), 71 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-testmode.c b/drivers/net/wireless/iwlwifi/iwl-testmode.c
index df7ab33..e42e076 100644
--- a/drivers/net/wireless/iwlwifi/iwl-testmode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-testmode.c
@@ -172,7 +172,7 @@ static void iwl_testmode_ucode_rx_pkt(struct iwl_priv *priv,
 	skb = cfg80211_testmode_alloc_event_skb(hw->wiphy, 20 + length,
 								GFP_ATOMIC);
 	if (skb == NULL) {
-		IWL_DEBUG_INFO(priv,
+		IWL_ERR(priv,
 			 "Run out of memory for messages to user space ?\n");
 		return;
 	}
@@ -183,7 +183,7 @@ static void iwl_testmode_ucode_rx_pkt(struct iwl_priv *priv,
 
 nla_put_failure:
 	kfree_skb(skb);
-	IWL_DEBUG_INFO(priv, "Ouch, overran buffer, check allocation!\n");
+	IWL_ERR(priv, "Ouch, overran buffer, check allocation!\n");
 }
 
 void iwl_testmode_init(struct iwl_priv *priv)
@@ -252,8 +252,7 @@ static int iwl_testmode_ucode(struct ieee80211_hw *hw, struct nlattr **tb)
 
 	if (!tb[IWL_TM_ATTR_UCODE_CMD_ID] ||
 	    !tb[IWL_TM_ATTR_UCODE_CMD_DATA]) {
-		IWL_DEBUG_INFO(priv,
-			"Error finding ucode command mandatory fields\n");
+		IWL_ERR(priv, "Missing ucode command mandatory fields\n");
 		return -ENOMSG;
 	}
 
@@ -295,7 +294,7 @@ static int iwl_testmode_reg(struct ieee80211_hw *hw, struct nlattr **tb)
 	int status = 0;
 
 	if (!tb[IWL_TM_ATTR_REG_OFFSET]) {
-		IWL_DEBUG_INFO(priv, "Error finding register offset\n");
+		IWL_ERR(priv, "Missing register offset\n");
 		return -ENOMSG;
 	}
 	ofs = nla_get_u32(tb[IWL_TM_ATTR_REG_OFFSET]);
@@ -309,7 +308,7 @@ static int iwl_testmode_reg(struct ieee80211_hw *hw, struct nlattr **tb)
 		cmd == IWL_TM_CMD_APP2DEV_DIRECT_REG_WRITE32 ||
 		cmd == IWL_TM_CMD_APP2DEV_DIRECT_REG_WRITE8) &&
 		(ofs >= FH_MEM_UPPER_BOUND)) {
-		IWL_DEBUG_INFO(priv, "offset out of segment (0x0 - 0x%x)\n",
+		IWL_ERR(priv, "offset out of segment (0x0 - 0x%x)\n",
 			FH_MEM_UPPER_BOUND);
 		return -EINVAL;
 	}
@@ -321,19 +320,17 @@ static int iwl_testmode_reg(struct ieee80211_hw *hw, struct nlattr **tb)
 
 		skb = cfg80211_testmode_alloc_reply_skb(hw->wiphy, 20);
 		if (!skb) {
-			IWL_DEBUG_INFO(priv, "Error allocating memory\n");
+			IWL_ERR(priv, "Memory allocation fail\n");
 			return -ENOMEM;
 		}
 		NLA_PUT_U32(skb, IWL_TM_ATTR_REG_VALUE32, val32);
 		status = cfg80211_testmode_reply(skb);
 		if (status < 0)
-			IWL_DEBUG_INFO(priv,
-				       "Error sending msg : %d\n", status);
+			IWL_ERR(priv, "Error sending msg : %d\n", status);
 		break;
 	case IWL_TM_CMD_APP2DEV_DIRECT_REG_WRITE32:
 		if (!tb[IWL_TM_ATTR_REG_VALUE32]) {
-			IWL_DEBUG_INFO(priv,
-				       "Error finding value to write\n");
+			IWL_ERR(priv, "Missing value to write\n");
 			return -ENOMSG;
 		} else {
 			val32 = nla_get_u32(tb[IWL_TM_ATTR_REG_VALUE32]);
@@ -343,7 +340,7 @@ static int iwl_testmode_reg(struct ieee80211_hw *hw, struct nlattr **tb)
 		break;
 	case IWL_TM_CMD_APP2DEV_DIRECT_REG_WRITE8:
 		if (!tb[IWL_TM_ATTR_REG_VALUE8]) {
-			IWL_DEBUG_INFO(priv, "Error finding value to write\n");
+			IWL_ERR(priv, "Missing value to write\n");
 			return -ENOMSG;
 		} else {
 			val8 = nla_get_u8(tb[IWL_TM_ATTR_REG_VALUE8]);
@@ -357,19 +354,17 @@ static int iwl_testmode_reg(struct ieee80211_hw *hw, struct nlattr **tb)
 
 		skb = cfg80211_testmode_alloc_reply_skb(hw->wiphy, 20);
 		if (!skb) {
-			IWL_DEBUG_INFO(priv, "Error allocating memory\n");
+			IWL_ERR(priv, "Memory allocation fail\n");
 			return -ENOMEM;
 		}
 		NLA_PUT_U32(skb, IWL_TM_ATTR_REG_VALUE32, val32);
 		status = cfg80211_testmode_reply(skb);
 		if (status < 0)
-			IWL_DEBUG_INFO(priv,
-					"Error sending msg : %d\n", status);
+			IWL_ERR(priv, "Error sending msg : %d\n", status);
 		break;
 	case IWL_TM_CMD_APP2DEV_INDIRECT_REG_WRITE32:
 		if (!tb[IWL_TM_ATTR_REG_VALUE32]) {
-			IWL_DEBUG_INFO(priv,
-					"Error finding value to write\n");
+			IWL_ERR(priv, "Missing value to write\n");
 			return -ENOMSG;
 		} else {
 			val32 = nla_get_u32(tb[IWL_TM_ATTR_REG_VALUE32]);
@@ -378,7 +373,7 @@ static int iwl_testmode_reg(struct ieee80211_hw *hw, struct nlattr **tb)
 		}
 		break;
 	default:
-		IWL_DEBUG_INFO(priv, "Unknown testmode register command ID\n");
+		IWL_ERR(priv, "Unknown testmode register command ID\n");
 		return -ENOSYS;
 	}
 
@@ -400,14 +395,13 @@ static int iwl_testmode_cfg_init_calib(struct iwl_priv *priv)
 				      NULL, NULL);
 	ret = iwl_init_alive_start(trans(priv));
 	if (ret) {
-		IWL_DEBUG_INFO(priv,
-			"Error configuring init calibration: %d\n", ret);
+		IWL_ERR(priv, "Fail init calibration: %d\n", ret);
 		goto cfg_init_calib_error;
 	}
 
 	ret = iwl_wait_notification(priv->shrd, &calib_wait, 2 * HZ);
 	if (ret)
-		IWL_DEBUG_INFO(priv, "Error detecting"
+		IWL_ERR(priv, "Error detecting"
 			" CALIBRATION_COMPLETE_NOTIFICATION: %d\n", ret);
 	return ret;
 
@@ -448,8 +442,7 @@ static int iwl_testmode_driver(struct ieee80211_hw *hw, struct nlattr **tb)
 		skb = cfg80211_testmode_alloc_reply_skb(hw->wiphy,
 							rsp_data_len + 20);
 		if (!skb) {
-			IWL_DEBUG_INFO(priv,
-				       "Error allocating memory\n");
+			IWL_ERR(priv, "Memory allocation fail\n");
 			return -ENOMEM;
 		}
 		NLA_PUT_U32(skb, IWL_TM_ATTR_COMMAND,
@@ -458,15 +451,13 @@ static int iwl_testmode_driver(struct ieee80211_hw *hw, struct nlattr **tb)
 			rsp_data_len, rsp_data_ptr);
 		status = cfg80211_testmode_reply(skb);
 		if (status < 0)
-			IWL_DEBUG_INFO(priv, "Error sending msg : %d\n",
-				       status);
+			IWL_ERR(priv, "Error sending msg : %d\n", status);
 		break;
 
 	case IWL_TM_CMD_APP2DEV_LOAD_INIT_FW:
 		status = iwl_load_ucode_wait_alive(trans, IWL_UCODE_INIT);
 		if (status)
-			IWL_DEBUG_INFO(priv,
-				"Error loading init ucode: %d\n", status);
+			IWL_ERR(priv, "Error loading init ucode: %d\n", status);
 		break;
 
 	case IWL_TM_CMD_APP2DEV_CFG_INIT_CALIB:
@@ -477,13 +468,13 @@ static int iwl_testmode_driver(struct ieee80211_hw *hw, struct nlattr **tb)
 	case IWL_TM_CMD_APP2DEV_LOAD_RUNTIME_FW:
 		status = iwl_load_ucode_wait_alive(trans, IWL_UCODE_REGULAR);
 		if (status) {
-			IWL_DEBUG_INFO(priv,
+			IWL_ERR(priv,
 				"Error loading runtime ucode: %d\n", status);
 			break;
 		}
 		status = iwl_alive_start(priv);
 		if (status)
-			IWL_DEBUG_INFO(priv,
+			IWL_ERR(priv,
 				"Error starting the device: %d\n", status);
 		break;
 
@@ -492,13 +483,13 @@ static int iwl_testmode_driver(struct ieee80211_hw *hw, struct nlattr **tb)
 		iwl_trans_stop_device(trans);
 		status = iwl_load_ucode_wait_alive(trans, IWL_UCODE_WOWLAN);
 		if (status) {
-			IWL_DEBUG_INFO(priv,
+			IWL_ERR(priv,
 				"Error loading WOWLAN ucode: %d\n", status);
 			break;
 		}
 		status = iwl_alive_start(priv);
 		if (status)
-			IWL_DEBUG_INFO(priv,
+			IWL_ERR(priv,
 				"Error starting the device: %d\n", status);
 		break;
 
@@ -507,8 +498,7 @@ static int iwl_testmode_driver(struct ieee80211_hw *hw, struct nlattr **tb)
 			skb = cfg80211_testmode_alloc_reply_skb(hw->wiphy,
 				cfg(priv)->base_params->eeprom_size + 20);
 			if (!skb) {
-				IWL_DEBUG_INFO(priv,
-				       "Error allocating memory\n");
+				IWL_ERR(priv, "Memory allocation fail\n");
 				return -ENOMEM;
 			}
 			NLA_PUT_U32(skb, IWL_TM_ATTR_COMMAND,
@@ -518,17 +508,15 @@ static int iwl_testmode_driver(struct ieee80211_hw *hw, struct nlattr **tb)
 				priv->shrd->eeprom);
 			status = cfg80211_testmode_reply(skb);
 			if (status < 0)
-				IWL_DEBUG_INFO(priv,
-					       "Error sending msg : %d\n",
-					       status);
+				IWL_ERR(priv, "Error sending msg : %d\n",
+					status);
 		} else
 			return -EFAULT;
 		break;
 
 	case IWL_TM_CMD_APP2DEV_FIXRATE_REQ:
 		if (!tb[IWL_TM_ATTR_FIXRATE]) {
-			IWL_DEBUG_INFO(priv,
-				       "Error finding fixrate setting\n");
+			IWL_ERR(priv, "Missing fixrate setting\n");
 			return -ENOMSG;
 		}
 		priv->tm_fixed_rate = nla_get_u32(tb[IWL_TM_ATTR_FIXRATE]);
@@ -539,14 +527,13 @@ static int iwl_testmode_driver(struct ieee80211_hw *hw, struct nlattr **tb)
 
 		skb = cfg80211_testmode_alloc_reply_skb(hw->wiphy, 20);
 		if (!skb) {
-			IWL_DEBUG_INFO(priv, "Error allocating memory\n");
+			IWL_ERR(priv, "Memory allocation fail\n");
 			return -ENOMEM;
 		}
 		NLA_PUT_U32(skb, IWL_TM_ATTR_FW_VERSION, priv->ucode_ver);
 		status = cfg80211_testmode_reply(skb);
 		if (status < 0)
-			IWL_DEBUG_INFO(priv,
-					"Error sending msg : %d\n", status);
+			IWL_ERR(priv, "Error sending msg : %d\n", status);
 		break;
 
 	case IWL_TM_CMD_APP2DEV_GET_DEVICE_ID:
@@ -555,20 +542,19 @@ static int iwl_testmode_driver(struct ieee80211_hw *hw, struct nlattr **tb)
 
 		skb = cfg80211_testmode_alloc_reply_skb(hw->wiphy, 20);
 		if (!skb) {
-			IWL_DEBUG_INFO(priv, "Error allocating memory\n");
+			IWL_ERR(priv, "Memory allocation fail\n");
 			return -ENOMEM;
 		}
 		NLA_PUT_U32(skb, IWL_TM_ATTR_DEVICE_ID, devid);
 		status = cfg80211_testmode_reply(skb);
 		if (status < 0)
-			IWL_DEBUG_INFO(priv,
-					"Error sending msg : %d\n", status);
+			IWL_ERR(priv, "Error sending msg : %d\n", status);
 		break;
 
 	case IWL_TM_CMD_APP2DEV_GET_FW_INFO:
 		skb = cfg80211_testmode_alloc_reply_skb(hw->wiphy, 20 + 8);
 		if (!skb) {
-			IWL_DEBUG_INFO(priv, "Error allocating memory\n");
+			IWL_ERR(priv, "Memory allocation fail\n");
 			return -ENOMEM;
 		}
 		switch (priv->shrd->ucode_type) {
@@ -585,10 +571,10 @@ static int iwl_testmode_driver(struct ieee80211_hw *hw, struct nlattr **tb)
 			data_size = trans(priv)->ucode_wowlan.data.len;
 			break;
 		case IWL_UCODE_NONE:
-			IWL_DEBUG_INFO(priv, "The uCode has not been loaded\n");
+			IWL_ERR(priv, "No uCode has not been loaded\n");
 			break;
 		default:
-			IWL_DEBUG_INFO(priv, "Unsupported uCode type\n");
+			IWL_ERR(priv, "Unsupported uCode type\n");
 			break;
 		}
 		NLA_PUT_U32(skb, IWL_TM_ATTR_FW_TYPE, priv->shrd->ucode_type);
@@ -596,12 +582,11 @@ static int iwl_testmode_driver(struct ieee80211_hw *hw, struct nlattr **tb)
 		NLA_PUT_U32(skb, IWL_TM_ATTR_FW_DATA_SIZE, data_size);
 		status = cfg80211_testmode_reply(skb);
 		if (status < 0)
-			IWL_DEBUG_INFO(priv,
-					"Error sending msg : %d\n", status);
+			IWL_ERR(priv, "Error sending msg : %d\n", status);
 		break;
 
 	default:
-		IWL_DEBUG_INFO(priv, "Unknown testmode driver command ID\n");
+		IWL_ERR(priv, "Unknown testmode driver command ID\n");
 		return -ENOSYS;
 	}
 	return status;
@@ -664,8 +649,7 @@ static int iwl_testmode_trace(struct ieee80211_hw *hw, struct nlattr **tb)
 		skb = cfg80211_testmode_alloc_reply_skb(hw->wiphy,
 			sizeof(priv->testmode_trace.dma_addr) + 20);
 		if (!skb) {
-			IWL_DEBUG_INFO(priv,
-				"Error allocating memory\n");
+			IWL_ERR(priv, "Memory allocation fail\n");
 			iwl_trace_cleanup(priv);
 			return -ENOMEM;
 		}
@@ -674,9 +658,7 @@ static int iwl_testmode_trace(struct ieee80211_hw *hw, struct nlattr **tb)
 			(u64 *)&priv->testmode_trace.dma_addr);
 		status = cfg80211_testmode_reply(skb);
 		if (status < 0) {
-			IWL_DEBUG_INFO(priv,
-				       "Error sending msg : %d\n",
-				       status);
+			IWL_ERR(priv, "Error sending msg : %d\n", status);
 		}
 		priv->testmode_trace.num_chunks =
 			DIV_ROUND_UP(priv->testmode_trace.buff_size,
@@ -687,7 +669,7 @@ static int iwl_testmode_trace(struct ieee80211_hw *hw, struct nlattr **tb)
 		iwl_trace_cleanup(priv);
 		break;
 	default:
-		IWL_DEBUG_INFO(priv, "Unknown testmode mem command ID\n");
+		IWL_ERR(priv, "Unknown testmode mem command ID\n");
 		return -ENOSYS;
 	}
 	return status;
@@ -752,7 +734,7 @@ static int iwl_testmode_ownership(struct ieee80211_hw *hw, struct nlattr **tb)
 	u8 owner;
 
 	if (!tb[IWL_TM_ATTR_UCODE_OWNER]) {
-		IWL_DEBUG_INFO(priv, "Error finding ucode owner\n");
+		IWL_ERR(priv, "Missing ucode owner\n");
 		return -ENOMSG;
 	}
 
@@ -760,7 +742,7 @@ static int iwl_testmode_ownership(struct ieee80211_hw *hw, struct nlattr **tb)
 	if ((owner == IWL_OWNERSHIP_DRIVER) || (owner == IWL_OWNERSHIP_TM))
 		priv->shrd->ucode_owner = owner;
 	else {
-		IWL_DEBUG_INFO(priv, "Invalid owner\n");
+		IWL_ERR(priv, "Invalid owner\n");
 		return -EINVAL;
 	}
 	return 0;
@@ -791,12 +773,12 @@ static int iwl_testmode_sram(struct ieee80211_hw *hw, struct nlattr **tb)
 		return -EBUSY;
 
 	if (!tb[IWL_TM_ATTR_SRAM_ADDR]) {
-		IWL_DEBUG_INFO(priv, "Error finding SRAM offset address\n");
+		IWL_ERR(priv, "Missing SRAM offset address\n");
 		return -ENOMSG;
 	}
 	ofs = nla_get_u32(tb[IWL_TM_ATTR_SRAM_ADDR]);
 	if (!tb[IWL_TM_ATTR_SRAM_SIZE]) {
-		IWL_DEBUG_INFO(priv, "Error finding size for SRAM reading\n");
+		IWL_ERR(priv, "Missing size for SRAM reading\n");
 		return -ENOMSG;
 	}
 	size = nla_get_u32(tb[IWL_TM_ATTR_SRAM_SIZE]);
@@ -811,10 +793,10 @@ static int iwl_testmode_sram(struct ieee80211_hw *hw, struct nlattr **tb)
 		maxsize = trans(priv)->ucode_wowlan.data.len;
 		break;
 	case IWL_UCODE_NONE:
-		IWL_ERR(priv, "Error, uCode does not been loaded\n");
+		IWL_ERR(priv, "uCode does not been loaded\n");
 		return -ENOSYS;
 	default:
-		IWL_ERR(priv, "Error, unsupported uCode type\n");
+		IWL_ERR(priv, "unsupported uCode type\n");
 		return -ENOSYS;
 	}
 	if ((ofs + size) > (maxsize + SRAM_DATA_SEG_OFFSET)) {
@@ -825,7 +807,7 @@ static int iwl_testmode_sram(struct ieee80211_hw *hw, struct nlattr **tb)
 	priv->testmode_sram.buff_addr =
 		kmalloc(priv->testmode_sram.buff_size, GFP_KERNEL);
 	if (priv->testmode_sram.buff_addr == NULL) {
-		IWL_ERR(priv, "Error allocating memory\n");
+		IWL_ERR(priv, "Memory allocation fail\n");
 		return -ENOMEM;
 	}
 	_iwl_read_targ_mem_words(trans(priv), ofs,
@@ -898,14 +880,13 @@ int iwlagn_mac_testmode_cmd(struct ieee80211_hw *hw, void *data, int len)
 	result = nla_parse(tb, IWL_TM_ATTR_MAX - 1, data, len,
 			iwl_testmode_gnl_msg_policy);
 	if (result != 0) {
-		IWL_DEBUG_INFO(priv,
-			       "Error parsing the gnl message : %d\n", result);
+		IWL_ERR(priv, "Error parsing the gnl message : %d\n", result);
 		return result;
 	}
 
 	/* IWL_TM_ATTR_COMMAND is absolutely mandatory */
 	if (!tb[IWL_TM_ATTR_COMMAND]) {
-		IWL_DEBUG_INFO(priv, "Error finding testmode command type\n");
+		IWL_ERR(priv, "Missing testmode command type\n");
 		return -ENOMSG;
 	}
 	/* in case multiple accesses to the device happens */
@@ -956,7 +937,7 @@ int iwlagn_mac_testmode_cmd(struct ieee80211_hw *hw, void *data, int len)
 		break;
 
 	default:
-		IWL_DEBUG_INFO(priv, "Unknown testmode command\n");
+		IWL_ERR(priv, "Unknown testmode command\n");
 		result = -ENOSYS;
 		break;
 	}
@@ -981,15 +962,14 @@ int iwlagn_mac_testmode_dump(struct ieee80211_hw *hw, struct sk_buff *skb,
 		result = nla_parse(tb, IWL_TM_ATTR_MAX - 1, data, len,
 				iwl_testmode_gnl_msg_policy);
 		if (result) {
-			IWL_DEBUG_INFO(priv,
-			       "Error parsing the gnl message : %d\n", result);
+			IWL_ERR(priv,
+				"Error parsing the gnl message : %d\n", result);
 			return result;
 		}
 
 		/* IWL_TM_ATTR_COMMAND is absolutely mandatory */
 		if (!tb[IWL_TM_ATTR_COMMAND]) {
-			IWL_DEBUG_INFO(priv,
-				"Error finding testmode command type\n");
+			IWL_ERR(priv, "Missing testmode command type\n");
 			return -ENOMSG;
 		}
 		cmd = nla_get_u32(tb[IWL_TM_ATTR_COMMAND]);
-- 
1.7.0.4

