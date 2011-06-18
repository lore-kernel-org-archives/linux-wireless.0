Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:41798 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750783Ab1FRQFZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Jun 2011 12:05:25 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 02/25] iwlagn: add PAN to tx flush
Date: Sat, 18 Jun 2011 08:34:08 -0700
Message-Id: <1308411271-26093-3-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110618_180615_843637_1ADC8D2F)
In-Reply-To: <1308411271-26093-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1308411271-26093-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When issue tx flush, also consider PAN

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c  |   11 +++++++++--
 drivers/net/wireless/iwlwifi/iwl-commands.h |   20 ++++++++++++++++----
 2 files changed, 25 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 3d9e1e8..8bed3ae 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -1530,8 +1530,15 @@ int iwlagn_txfifo_flush(struct iwl_priv *priv, u16 flush_control)
 	might_sleep();
 
 	memset(&flush_cmd, 0, sizeof(flush_cmd));
-	flush_cmd.fifo_control = IWL_TX_FIFO_VO_MSK | IWL_TX_FIFO_VI_MSK |
-				 IWL_TX_FIFO_BE_MSK | IWL_TX_FIFO_BK_MSK;
+	flush_cmd.fifo_control = IWL_SCD_VO_MSK | IWL_SCD_VI_MSK |
+				 IWL_SCD_BE_MSK | IWL_SCD_BK_MSK |
+				 IWL_SCD_MGMT_MSK;
+	if (priv->valid_contexts != BIT(IWL_RXON_CTX_BSS))
+		flush_cmd.fifo_control |= IWL_PAN_SCD_VO_MSK |
+				IWL_PAN_SCD_VI_MSK | IWL_PAN_SCD_BE_MSK |
+				IWL_PAN_SCD_BK_MSK | IWL_PAN_SCD_MGMT_MSK |
+				IWL_PAN_SCD_MULTICAST_MSK;
+
 	if (priv->cfg->sku & EEPROM_SKU_CAP_11N_ENABLE)
 		flush_cmd.fifo_control |= IWL_AGG_TX_QUEUE_MSK;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 8dcb210..189bc18 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -972,10 +972,22 @@ struct iwl_rem_sta_cmd {
 	u8 reserved2[2];
 } __packed;
 
-#define IWL_TX_FIFO_BK_MSK		cpu_to_le32(BIT(0))
-#define IWL_TX_FIFO_BE_MSK		cpu_to_le32(BIT(1))
-#define IWL_TX_FIFO_VI_MSK		cpu_to_le32(BIT(2))
-#define IWL_TX_FIFO_VO_MSK		cpu_to_le32(BIT(3))
+
+/* WiFi queues mask */
+#define IWL_SCD_BK_MSK			cpu_to_le32(BIT(0))
+#define IWL_SCD_BE_MSK			cpu_to_le32(BIT(1))
+#define IWL_SCD_VI_MSK			cpu_to_le32(BIT(2))
+#define IWL_SCD_VO_MSK			cpu_to_le32(BIT(3))
+#define IWL_SCD_MGMT_MSK		cpu_to_le32(BIT(3))
+
+/* PAN queues mask */
+#define IWL_PAN_SCD_BK_MSK		cpu_to_le32(BIT(4))
+#define IWL_PAN_SCD_BE_MSK		cpu_to_le32(BIT(5))
+#define IWL_PAN_SCD_VI_MSK		cpu_to_le32(BIT(6))
+#define IWL_PAN_SCD_VO_MSK		cpu_to_le32(BIT(7))
+#define IWL_PAN_SCD_MGMT_MSK		cpu_to_le32(BIT(7))
+#define IWL_PAN_SCD_MULTICAST_MSK	cpu_to_le32(BIT(8))
+
 #define IWL_AGG_TX_QUEUE_MSK		cpu_to_le32(0xffc00)
 
 #define IWL_DROP_SINGLE		0
-- 
1.7.0.4

