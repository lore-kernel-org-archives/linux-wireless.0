Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:18110 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757267Ab1LBRqS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Dec 2011 12:46:18 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, "Hsu, Kenny" <kenny.hsu@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 11/16] iwlwifi: add WOWLAN uCode loading support by testmode
Date: Fri,  2 Dec 2011 08:48:35 -0800
Message-Id: <1322844520-21149-12-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111202_184644_011617_7C199096)
In-Reply-To: <1322844520-21149-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1322844520-21149-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hsu, Kenny <kenny.hsu@intel.com>

Create new tm command for WOWLAN uCode loading to support
further debugging function in userspace.

- IWL_TM_CMD_APP2DEV_LOAD_WOWLAN_FW

Signed-off-by: Kenny Hsu <kenny.hsu@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-sv-open.c  |   16 ++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-testmode.h |    5 ++++-
 2 files changed, 20 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-sv-open.c b/drivers/net/wireless/iwlwifi/iwl-sv-open.c
index 21b2fbb..3c97626 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sv-open.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sv-open.c
@@ -463,6 +463,21 @@ static int iwl_testmode_driver(struct ieee80211_hw *hw, struct nlattr **tb)
 				"Error starting the device: %d\n", status);
 		break;
 
+	case IWL_TM_CMD_APP2DEV_LOAD_WOWLAN_FW:
+		iwl_scan_cancel_timeout(priv, 200);
+		iwl_trans_stop_device(trans(priv));
+		status = iwlagn_load_ucode_wait_alive(priv, IWL_UCODE_WOWLAN);
+		if (status) {
+			IWL_DEBUG_INFO(priv,
+				"Error loading WOWLAN ucode: %d\n", status);
+			break;
+		}
+		status = iwl_alive_start(priv);
+		if (status)
+			IWL_DEBUG_INFO(priv,
+				"Error starting the device: %d\n", status);
+		break;
+
 	case IWL_TM_CMD_APP2DEV_GET_EEPROM:
 		if (priv->eeprom) {
 			skb = cfg80211_testmode_alloc_reply_skb(hw->wiphy,
@@ -826,6 +841,7 @@ int iwlagn_mac_testmode_cmd(struct ieee80211_hw *hw, void *data, int len)
 	case IWL_TM_CMD_APP2DEV_LOAD_RUNTIME_FW:
 	case IWL_TM_CMD_APP2DEV_GET_EEPROM:
 	case IWL_TM_CMD_APP2DEV_FIXRATE_REQ:
+	case IWL_TM_CMD_APP2DEV_LOAD_WOWLAN_FW:
 		IWL_DEBUG_INFO(priv, "testmode cmd to driver\n");
 		result = iwl_testmode_driver(hw, tb);
 		break;
diff --git a/drivers/net/wireless/iwlwifi/iwl-testmode.h b/drivers/net/wireless/iwlwifi/iwl-testmode.h
index e20f3d3..deedd27 100644
--- a/drivers/net/wireless/iwlwifi/iwl-testmode.h
+++ b/drivers/net/wireless/iwlwifi/iwl-testmode.h
@@ -117,6 +117,8 @@
  * @IWL_TM_CMD_APP2DEV_DUMP_SRAM:
  *	commands from user applicaiton to read data in sram
  *
+ * @IWL_TM_CMD_APP2DEV_LOAD_WOWLAN_FW: load Weak On Wireless LAN uCode image
+ *
  */
 enum iwl_tm_cmd_t {
 	IWL_TM_CMD_APP2DEV_UCODE		= 1,
@@ -140,7 +142,8 @@ enum iwl_tm_cmd_t {
 	IWL_TM_CMD_APP2DEV_INDIRECT_REG_WRITE32	= 19,
 	IWL_TM_CMD_APP2DEV_READ_SRAM		= 20,
 	IWL_TM_CMD_APP2DEV_DUMP_SRAM		= 21,
-	IWL_TM_CMD_MAX				= 22,
+	IWL_TM_CMD_APP2DEV_LOAD_WOWLAN_FW	= 22,
+	IWL_TM_CMD_MAX				= 23,
 };
 
 /*
-- 
1.7.0.4

