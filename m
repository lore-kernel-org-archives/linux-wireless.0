Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:63195 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966065Ab2DLV6G (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Apr 2012 17:58:06 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>
Subject: [PATCH 01/24] iwlwifi: move iwlagn_hw_valid_rtc_data_addr prototype
Date: Thu, 12 Apr 2012 14:53:58 -0700
Message-Id: <1334267661-14654-2-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120412_235813_823516_B0A2C514)
In-Reply-To: <1334267661-14654-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1334267661-14654-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>

Since this function is now used only by
op_mode, remove it from iwl-shared.h and move
it to iwl-agn.h.

Signed-off-by: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>
Signed-off-by-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.h    |    1 +
 drivers/net/wireless/iwlwifi/iwl-shared.h |    1 -
 2 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index 6ebb3f7..ae5cf54 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -144,6 +144,7 @@ void iwl_calib_free_results(struct iwl_priv *priv);
 void iwlagn_fw_error(struct iwl_priv *priv, bool ondemand);
 int iwl_dump_nic_event_log(struct iwl_priv *priv, bool full_log,
 			    char **buf, bool display);
+int iwlagn_hw_valid_rtc_data_addr(u32 addr);
 
 /* lib */
 int iwlagn_send_tx_power(struct iwl_priv *priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index 68f452d..4b764d7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -190,7 +190,6 @@ enum iwl_rxon_context_id {
 	NUM_IWL_RXON_CTX
 };
 
-int iwlagn_hw_valid_rtc_data_addr(u32 addr);
 const char *get_cmd_string(u8 cmd);
 
 #define IWL_CMD(x) case x: return #x
-- 
1.7.0.4

