Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:41798 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751942Ab1FRQFY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Jun 2011 12:05:24 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 03/25] iwlagn: Support flush queues for specified interface
Date: Sat, 18 Jun 2011 08:34:09 -0700
Message-Id: <1308411271-26093-4-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110618_180617_662396_9FCD51F3)
In-Reply-To: <1308411271-26093-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1308411271-26093-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Flush command can target specified interface or all interfaces

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c  |    6 ++++--
 drivers/net/wireless/iwlwifi/iwl-commands.h |    3 +--
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 8bed3ae..99d473f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -1530,10 +1530,12 @@ int iwlagn_txfifo_flush(struct iwl_priv *priv, u16 flush_control)
 	might_sleep();
 
 	memset(&flush_cmd, 0, sizeof(flush_cmd));
-	flush_cmd.fifo_control = IWL_SCD_VO_MSK | IWL_SCD_VI_MSK |
+	if (flush_control & BIT(IWL_RXON_CTX_BSS))
+		flush_cmd.fifo_control = IWL_SCD_VO_MSK | IWL_SCD_VI_MSK |
 				 IWL_SCD_BE_MSK | IWL_SCD_BK_MSK |
 				 IWL_SCD_MGMT_MSK;
-	if (priv->valid_contexts != BIT(IWL_RXON_CTX_BSS))
+	if ((flush_control & BIT(IWL_RXON_CTX_PAN)) &&
+	    (priv->valid_contexts != BIT(IWL_RXON_CTX_BSS)))
 		flush_cmd.fifo_control |= IWL_PAN_SCD_VO_MSK |
 				IWL_PAN_SCD_VI_MSK | IWL_PAN_SCD_BE_MSK |
 				IWL_PAN_SCD_BK_MSK | IWL_PAN_SCD_MGMT_MSK |
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 189bc18..8a2edf8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -991,8 +991,7 @@ struct iwl_rem_sta_cmd {
 #define IWL_AGG_TX_QUEUE_MSK		cpu_to_le32(0xffc00)
 
 #define IWL_DROP_SINGLE		0
-#define IWL_DROP_SELECTED	1
-#define IWL_DROP_ALL		2
+#define IWL_DROP_ALL		(BIT(IWL_RXON_CTX_BSS) | BIT(IWL_RXON_CTX_PAN))
 
 /*
  * REPLY_TXFIFO_FLUSH = 0x1e(command and response)
-- 
1.7.0.4

