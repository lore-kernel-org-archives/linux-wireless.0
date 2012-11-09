Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54749 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755369Ab2KIUHj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Nov 2012 15:07:39 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 05/13] iwlwifi: fix queue flush confusion
Date: Fri,  9 Nov 2012 21:08:04 +0100
Message-Id: <1352491692-28994-6-git-send-email-johannes@sipsolutions.net> (sfid-20121109_210747_457089_48E4992C)
In-Reply-To: <1352491692-28994-1-git-send-email-johannes@sipsolutions.net>
References: <1352491692-28994-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The flush_control parameter to iwlagn_txfifo_flush
is passed as an internal value (context flags) and
then sent to the device, that can't be right.

Fix the confusion by removing the parameter, always
use IWL_DROP_ALL that is redefined according to the
firmware API in the flush control.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/agn.h      |  4 ++--
 drivers/net/wireless/iwlwifi/dvm/commands.h |  3 +--
 drivers/net/wireless/iwlwifi/dvm/debugfs.c  |  2 +-
 drivers/net/wireless/iwlwifi/dvm/lib.c      | 29 ++++++++++++++---------------
 drivers/net/wireless/iwlwifi/dvm/mac80211.c |  2 +-
 drivers/net/wireless/iwlwifi/dvm/main.c     |  2 +-
 6 files changed, 20 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/agn.h b/drivers/net/wireless/iwlwifi/dvm/agn.h
index 75e12f2..33b3ad2 100644
--- a/drivers/net/wireless/iwlwifi/dvm/agn.h
+++ b/drivers/net/wireless/iwlwifi/dvm/agn.h
@@ -176,8 +176,8 @@ int iwlagn_hw_valid_rtc_data_addr(u32 addr);
 /* lib */
 int iwlagn_send_tx_power(struct iwl_priv *priv);
 void iwlagn_temperature(struct iwl_priv *priv);
-int iwlagn_txfifo_flush(struct iwl_priv *priv, u16 flush_control);
-void iwlagn_dev_txfifo_flush(struct iwl_priv *priv, u16 flush_control);
+int iwlagn_txfifo_flush(struct iwl_priv *priv);
+void iwlagn_dev_txfifo_flush(struct iwl_priv *priv);
 int iwlagn_send_beacon_cmd(struct iwl_priv *priv);
 int iwl_send_statistics_request(struct iwl_priv *priv,
 				u8 flags, bool clear);
diff --git a/drivers/net/wireless/iwlwifi/dvm/commands.h b/drivers/net/wireless/iwlwifi/dvm/commands.h
index ac24861..71ab76b 100644
--- a/drivers/net/wireless/iwlwifi/dvm/commands.h
+++ b/drivers/net/wireless/iwlwifi/dvm/commands.h
@@ -986,8 +986,7 @@ struct iwl_rem_sta_cmd {
 
 #define IWL_AGG_TX_QUEUE_MSK		cpu_to_le32(0xffc00)
 
-#define IWL_DROP_SINGLE		0
-#define IWL_DROP_ALL		(BIT(IWL_RXON_CTX_BSS) | BIT(IWL_RXON_CTX_PAN))
+#define IWL_DROP_ALL			BIT(1)
 
 /*
  * REPLY_TXFIFO_FLUSH = 0x1e(command and response)
diff --git a/drivers/net/wireless/iwlwifi/dvm/debugfs.c b/drivers/net/wireless/iwlwifi/dvm/debugfs.c
index 1a98fa3..769a08b 100644
--- a/drivers/net/wireless/iwlwifi/dvm/debugfs.c
+++ b/drivers/net/wireless/iwlwifi/dvm/debugfs.c
@@ -2101,7 +2101,7 @@ static ssize_t iwl_dbgfs_txfifo_flush_write(struct file *file,
 	if (iwl_is_rfkill(priv))
 		return -EFAULT;
 
-	iwlagn_dev_txfifo_flush(priv, IWL_DROP_ALL);
+	iwlagn_dev_txfifo_flush(priv);
 
 	return count;
 }
diff --git a/drivers/net/wireless/iwlwifi/dvm/lib.c b/drivers/net/wireless/iwlwifi/dvm/lib.c
index 01ff55f..7e59be4 100644
--- a/drivers/net/wireless/iwlwifi/dvm/lib.c
+++ b/drivers/net/wireless/iwlwifi/dvm/lib.c
@@ -136,7 +136,7 @@ int iwlagn_manage_ibss_station(struct iwl_priv *priv,
  *  1. acquire mutex before calling
  *  2. make sure rf is on and not in exit state
  */
-int iwlagn_txfifo_flush(struct iwl_priv *priv, u16 flush_control)
+int iwlagn_txfifo_flush(struct iwl_priv *priv)
 {
 	struct iwl_txfifo_flush_cmd flush_cmd;
 	struct iwl_host_cmd cmd = {
@@ -146,35 +146,34 @@ int iwlagn_txfifo_flush(struct iwl_priv *priv, u16 flush_control)
 		.data = { &flush_cmd, },
 	};
 
-	might_sleep();
-
 	memset(&flush_cmd, 0, sizeof(flush_cmd));
-	if (flush_control & BIT(IWL_RXON_CTX_BSS))
-		flush_cmd.queue_control = IWL_SCD_VO_MSK | IWL_SCD_VI_MSK |
-				 IWL_SCD_BE_MSK | IWL_SCD_BK_MSK |
-				 IWL_SCD_MGMT_MSK;
-	if ((flush_control & BIT(IWL_RXON_CTX_PAN)) &&
-	    (priv->valid_contexts != BIT(IWL_RXON_CTX_BSS)))
+
+	flush_cmd.queue_control = IWL_SCD_VO_MSK | IWL_SCD_VI_MSK |
+				  IWL_SCD_BE_MSK | IWL_SCD_BK_MSK |
+				  IWL_SCD_MGMT_MSK;
+	if ((priv->valid_contexts != BIT(IWL_RXON_CTX_BSS)))
 		flush_cmd.queue_control |= IWL_PAN_SCD_VO_MSK |
-				IWL_PAN_SCD_VI_MSK | IWL_PAN_SCD_BE_MSK |
-				IWL_PAN_SCD_BK_MSK | IWL_PAN_SCD_MGMT_MSK |
-				IWL_PAN_SCD_MULTICAST_MSK;
+					   IWL_PAN_SCD_VI_MSK |
+					   IWL_PAN_SCD_BE_MSK |
+					   IWL_PAN_SCD_BK_MSK |
+					   IWL_PAN_SCD_MGMT_MSK |
+					   IWL_PAN_SCD_MULTICAST_MSK;
 
 	if (priv->eeprom_data->sku & EEPROM_SKU_CAP_11N_ENABLE)
 		flush_cmd.queue_control |= IWL_AGG_TX_QUEUE_MSK;
 
 	IWL_DEBUG_INFO(priv, "queue control: 0x%x\n",
 		       flush_cmd.queue_control);
-	flush_cmd.flush_control = cpu_to_le16(flush_control);
+	flush_cmd.flush_control = cpu_to_le16(IWL_DROP_ALL);
 
 	return iwl_dvm_send_cmd(priv, &cmd);
 }
 
-void iwlagn_dev_txfifo_flush(struct iwl_priv *priv, u16 flush_control)
+void iwlagn_dev_txfifo_flush(struct iwl_priv *priv)
 {
 	mutex_lock(&priv->mutex);
 	ieee80211_stop_queues(priv->hw);
-	if (iwlagn_txfifo_flush(priv, IWL_DROP_ALL)) {
+	if (iwlagn_txfifo_flush(priv)) {
 		IWL_ERR(priv, "flush request fail\n");
 		goto done;
 	}
diff --git a/drivers/net/wireless/iwlwifi/dvm/mac80211.c b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
index 46b0d1c..cb443d5 100644
--- a/drivers/net/wireless/iwlwifi/dvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
@@ -1017,7 +1017,7 @@ static void iwlagn_mac_flush(struct ieee80211_hw *hw, bool drop)
 	 */
 	if (drop) {
 		IWL_DEBUG_MAC80211(priv, "send flush command\n");
-		if (iwlagn_txfifo_flush(priv, IWL_DROP_ALL)) {
+		if (iwlagn_txfifo_flush(priv)) {
 			IWL_ERR(priv, "flush request fail\n");
 			goto done;
 		}
diff --git a/drivers/net/wireless/iwlwifi/dvm/main.c b/drivers/net/wireless/iwlwifi/dvm/main.c
index 4547f36..95d348b 100644
--- a/drivers/net/wireless/iwlwifi/dvm/main.c
+++ b/drivers/net/wireless/iwlwifi/dvm/main.c
@@ -511,7 +511,7 @@ static void iwl_bg_tx_flush(struct work_struct *work)
 		return;
 
 	IWL_DEBUG_INFO(priv, "device request: flush all tx frames\n");
-	iwlagn_dev_txfifo_flush(priv, IWL_DROP_ALL);
+	iwlagn_dev_txfifo_flush(priv);
 }
 
 /*
-- 
1.8.0

