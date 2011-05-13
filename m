Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:53515 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756179Ab1EMTio (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 15:38:44 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 07/13] iwlagn: add eeprom command to testmode
Date: Fri, 13 May 2011 12:13:24 -0700
Message-Id: <1305314010-18073-8-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110513_213909_134665_55C35D17)
In-Reply-To: <1305314010-18073-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1305314010-18073-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add the capability to dump eeprom through testmode request

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-sv-open.c  |   26 ++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-testmode.h |   12 ++++++++++++
 2 files changed, 38 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-sv-open.c b/drivers/net/wireless/iwlwifi/iwl-sv-open.c
index b778c3f..e77ccaa 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sv-open.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sv-open.c
@@ -98,6 +98,8 @@ struct nla_policy iwl_testmode_gnl_msg_policy[IWL_TM_ATTR_MAX] = {
 	[IWL_TM_ATTR_SYNC_RSP] = { .type = NLA_UNSPEC, },
 	[IWL_TM_ATTR_UCODE_RX_PKT] = { .type = NLA_UNSPEC, },
 
+	[IWL_TM_ATTR_EEPROM] = { .type = NLA_UNSPEC, },
+
 	[IWL_TM_ATTR_TRACE_ADDR] = { .type = NLA_UNSPEC, },
 	[IWL_TM_ATTR_TRACE_DATA] = { .type = NLA_UNSPEC, },
 
@@ -418,6 +420,29 @@ static int iwl_testmode_driver(struct ieee80211_hw *hw, struct nlattr **tb)
 				"Error starting the device: %d\n", status);
 		break;
 
+	case IWL_TM_CMD_APP2DEV_GET_EEPROM:
+		if (priv->eeprom) {
+			skb = cfg80211_testmode_alloc_reply_skb(hw->wiphy,
+				priv->cfg->base_params->eeprom_size + 20);
+			if (!skb) {
+				IWL_DEBUG_INFO(priv,
+				       "Error allocating memory\n");
+				return -ENOMEM;
+			}
+			NLA_PUT_U32(skb, IWL_TM_ATTR_COMMAND,
+				IWL_TM_CMD_DEV2APP_EEPROM_RSP);
+			NLA_PUT(skb, IWL_TM_ATTR_EEPROM,
+				priv->cfg->base_params->eeprom_size,
+				priv->eeprom);
+			status = cfg80211_testmode_reply(skb);
+			if (status < 0)
+				IWL_DEBUG_INFO(priv,
+					       "Error sending msg : %d\n",
+					       status);
+		} else
+			return -EFAULT;
+		break;
+
 	default:
 		IWL_DEBUG_INFO(priv, "Unknown testmode driver command ID\n");
 		return -ENOSYS;
@@ -581,6 +606,7 @@ int iwl_testmode_cmd(struct ieee80211_hw *hw, void *data, int len)
 	case IWL_TM_CMD_APP2DEV_LOAD_INIT_FW:
 	case IWL_TM_CMD_APP2DEV_CFG_INIT_CALIB:
 	case IWL_TM_CMD_APP2DEV_LOAD_RUNTIME_FW:
+	case IWL_TM_CMD_APP2DEV_GET_EEPROM:
 		IWL_DEBUG_INFO(priv, "testmode cmd to driver\n");
 		result = iwl_testmode_driver(hw, tb);
 		break;
diff --git a/drivers/net/wireless/iwlwifi/iwl-testmode.h b/drivers/net/wireless/iwlwifi/iwl-testmode.h
index 34634ec..4171d29 100644
--- a/drivers/net/wireless/iwlwifi/iwl-testmode.h
+++ b/drivers/net/wireless/iwlwifi/iwl-testmode.h
@@ -88,6 +88,7 @@ enum iwl_tm_cmd_t {
 	IWL_TM_CMD_APP2DEV_LOAD_INIT_FW,
 	IWL_TM_CMD_APP2DEV_CFG_INIT_CALIB,
 	IWL_TM_CMD_APP2DEV_LOAD_RUNTIME_FW,
+	IWL_TM_CMD_APP2DEV_GET_EEPROM,
 	/* if there is other new command for the driver layer operation,
 	 * append them here */
 
@@ -103,6 +104,11 @@ enum iwl_tm_cmd_t {
 	/* commands from kernel space to multicast the spontaneous messages
 	 * to user application */
 	IWL_TM_CMD_DEV2APP_UCODE_RX_PKT,
+
+	/* commands from kernel space to carry the eeprom response
+	 * to user application */
+	IWL_TM_CMD_DEV2APP_EEPROM_RSP,
+
 	IWL_TM_CMD_MAX,
 };
 
@@ -148,6 +154,12 @@ enum iwl_tm_attr_t {
 	 * application */
 	IWL_TM_ATTR_UCODE_RX_PKT,
 
+	/* When IWL_TM_ATTR_COMMAND is IWL_TM_CMD_DEV2APP_EEPROM,
+	 * The mandatory fields are:
+	 * IWL_TM_ATTR_EEPROM for the data content responging to the user
+	 * application */
+	IWL_TM_ATTR_EEPROM,
+
 	/* When IWL_TM_ATTR_COMMAND is IWL_TM_CMD_APP2DEV_XXX_TRACE,
 	 * The mandatory fields are:
 	 * IWL_TM_ATTR_MEM_TRACE_ADDR for the trace address
-- 
1.7.0.4

