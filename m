Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54741 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755388Ab2KIUHj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Nov 2012 15:07:39 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 03/13] iwlwifi: fix flush command
Date: Fri,  9 Nov 2012 21:08:02 +0100
Message-Id: <1352491692-28994-4-git-send-email-johannes@sipsolutions.net> (sfid-20121109_210752_034655_12931CA6)
In-Reply-To: <1352491692-28994-1-git-send-email-johannes@sipsolutions.net>
References: <1352491692-28994-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The flush command really flushes queues, not
FIFOs, and the first 32 bits indicate the
queues to flush, not FIFOs. Change the command
accordingly.

Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/commands.h |  4 ++--
 drivers/net/wireless/iwlwifi/dvm/lib.c      | 10 +++++-----
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/commands.h b/drivers/net/wireless/iwlwifi/dvm/commands.h
index 01128c9..ac24861 100644
--- a/drivers/net/wireless/iwlwifi/dvm/commands.h
+++ b/drivers/net/wireless/iwlwifi/dvm/commands.h
@@ -1004,14 +1004,14 @@ struct iwl_rem_sta_cmd {
  * the flush operation ends when both the scheduler DMA done and TXFIFO empty
  * are set.
  *
- * @fifo_control: bit mask for which queues to flush
+ * @queue_control: bit mask for which queues to flush
  * @flush_control: flush controls
  *	0: Dump single MSDU
  *	1: Dump multiple MSDU according to PS, INVALID STA, TTL, TID disable.
  *	2: Dump all FIFO
  */
 struct iwl_txfifo_flush_cmd {
-	__le32 fifo_control;
+	__le32 queue_control;
 	__le16 flush_control;
 	__le16 reserved;
 } __packed;
diff --git a/drivers/net/wireless/iwlwifi/dvm/lib.c b/drivers/net/wireless/iwlwifi/dvm/lib.c
index bef88c1..01ff55f 100644
--- a/drivers/net/wireless/iwlwifi/dvm/lib.c
+++ b/drivers/net/wireless/iwlwifi/dvm/lib.c
@@ -150,21 +150,21 @@ int iwlagn_txfifo_flush(struct iwl_priv *priv, u16 flush_control)
 
 	memset(&flush_cmd, 0, sizeof(flush_cmd));
 	if (flush_control & BIT(IWL_RXON_CTX_BSS))
-		flush_cmd.fifo_control = IWL_SCD_VO_MSK | IWL_SCD_VI_MSK |
+		flush_cmd.queue_control = IWL_SCD_VO_MSK | IWL_SCD_VI_MSK |
 				 IWL_SCD_BE_MSK | IWL_SCD_BK_MSK |
 				 IWL_SCD_MGMT_MSK;
 	if ((flush_control & BIT(IWL_RXON_CTX_PAN)) &&
 	    (priv->valid_contexts != BIT(IWL_RXON_CTX_BSS)))
-		flush_cmd.fifo_control |= IWL_PAN_SCD_VO_MSK |
+		flush_cmd.queue_control |= IWL_PAN_SCD_VO_MSK |
 				IWL_PAN_SCD_VI_MSK | IWL_PAN_SCD_BE_MSK |
 				IWL_PAN_SCD_BK_MSK | IWL_PAN_SCD_MGMT_MSK |
 				IWL_PAN_SCD_MULTICAST_MSK;
 
 	if (priv->eeprom_data->sku & EEPROM_SKU_CAP_11N_ENABLE)
-		flush_cmd.fifo_control |= IWL_AGG_TX_QUEUE_MSK;
+		flush_cmd.queue_control |= IWL_AGG_TX_QUEUE_MSK;
 
-	IWL_DEBUG_INFO(priv, "fifo queue control: 0X%x\n",
-		       flush_cmd.fifo_control);
+	IWL_DEBUG_INFO(priv, "queue control: 0x%x\n",
+		       flush_cmd.queue_control);
 	flush_cmd.flush_control = cpu_to_le16(flush_control);
 
 	return iwl_dvm_send_cmd(priv, &cmd);
-- 
1.8.0

