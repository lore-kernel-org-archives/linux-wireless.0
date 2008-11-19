Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:10060 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753210AbYKSXb6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Nov 2008 18:31:58 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	"Winkler, Tomas" <tomas.winkler@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 6/7] iwlwifi: TX update chicken bits
Date: Wed, 19 Nov 2008 15:32:27 -0800
Message-Id: <1227137548-28718-7-git-send-email-reinette.chatre@intel.com> (sfid-20081120_003216_949851_48DCD663)
In-Reply-To: <1227137548-28718-6-git-send-email-reinette.chatre@intel.com>
References: <>
 <1227137548-28718-1-git-send-email-reinette.chatre@intel.com>
 <1227137548-28718-2-git-send-email-reinette.chatre@intel.com>
 <1227137548-28718-3-git-send-email-reinette.chatre@intel.com>
 <1227137548-28718-4-git-send-email-reinette.chatre@intel.com>
 <1227137548-28718-5-git-send-email-reinette.chatre@intel.com>
 <1227137548-28718-6-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Winkler, Tomas <tomas.winkler@intel.com>

This instructs FH to increment the retry count of a packet when
it is brought from the memory to TX-FIFO to save transactions
during aggregation flow.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c |    6 ++++++
 drivers/net/wireless/iwlwifi/iwl-5000.c |    6 ++++++
 drivers/net/wireless/iwlwifi/iwl-fh.h   |    5 +++++
 3 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 60769b1..ab0b405 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -695,6 +695,7 @@ static int iwl4965_alive_notify(struct iwl_priv *priv)
 	unsigned long flags;
 	int ret;
 	int i, chan;
+	u32 reg_val;
 
 	spin_lock_irqsave(&priv->lock, flags);
 
@@ -724,6 +725,11 @@ static int iwl4965_alive_notify(struct iwl_priv *priv)
 				FH_TCSR_TX_CONFIG_REG_VAL_DMA_CHNL_ENABLE |
 				FH_TCSR_TX_CONFIG_REG_VAL_DMA_CREDIT_ENABLE);
 
+	/* Update FH chicken bits */
+	reg_val = iwl_read_direct32(priv, FH_TX_CHICKEN_BITS_REG);
+	iwl_write_direct32(priv, FH_TX_CHICKEN_BITS_REG,
+			   reg_val | FH_TX_CHICKEN_BITS_SCD_AUTO_RETRY_EN);
+
 	/* Disable chain mode for all queues */
 	iwl_write_prph(priv, IWL49_SCD_QUEUECHAIN_SEL, 0);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index d73760c..a738886 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -703,6 +703,7 @@ static int iwl5000_alive_notify(struct iwl_priv *priv)
 	unsigned long flags;
 	int ret;
 	int i, chan;
+	u32 reg_val;
 
 	spin_lock_irqsave(&priv->lock, flags);
 
@@ -732,6 +733,11 @@ static int iwl5000_alive_notify(struct iwl_priv *priv)
 				FH_TCSR_TX_CONFIG_REG_VAL_DMA_CHNL_ENABLE |
 				FH_TCSR_TX_CONFIG_REG_VAL_DMA_CREDIT_ENABLE);
 
+	/* Update FH chicken bits */
+	reg_val = iwl_read_direct32(priv, FH_TX_CHICKEN_BITS_REG);
+	iwl_write_direct32(priv, FH_TX_CHICKEN_BITS_REG,
+			   reg_val | FH_TX_CHICKEN_BITS_SCD_AUTO_RETRY_EN);
+
 	iwl_write_prph(priv, IWL50_SCD_QUEUECHAIN_SEL,
 		IWL50_SCD_QUEUECHAIN_SEL_ALL(priv->hw_params.max_txq_num));
 	iwl_write_prph(priv, IWL50_SCD_AGGR_SEL, 0);
diff --git a/drivers/net/wireless/iwlwifi/iwl-fh.h b/drivers/net/wireless/iwlwifi/iwl-fh.h
index bc20acb..c3dadb0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fh.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fh.h
@@ -396,6 +396,11 @@
 #define FH_SRVC_CHNL_SRAM_ADDR_REG(_chnl) \
 		(FH_SRVC_LOWER_BOUND + ((_chnl) - 9) * 0x4)
 
+#define FH_TX_CHICKEN_BITS_REG	(FH_MEM_LOWER_BOUND + 0xE98)
+/* Instruct FH to increment the retry count of a packet when
+ * it is brought from the memory to TX-FIFO
+ */
+#define FH_TX_CHICKEN_BITS_SCD_AUTO_RETRY_EN	(0x00000002)
 
 /**
  * struct iwl_rb_status - reseve buffer status
-- 
1.5.4.3

