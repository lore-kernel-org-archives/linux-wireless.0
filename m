Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:4015 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754469Ab0A2TyK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jan 2010 14:54:10 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 08/12] iwlagn: simplify ucode loading
Date: Fri, 29 Jan 2010 11:53:58 -0800
Message-Id: <1264794842-8046-9-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1264794842-8046-1-git-send-email-reinette.chatre@intel.com>
References: <1264794842-8046-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Move the waiting into iwl5000_load_section instead
of duplicating it in the caller.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-5000.c |   63 +++++++++++--------------------
 1 files changed, 22 insertions(+), 41 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 6bb433a..6d59889 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -412,12 +412,14 @@ static void iwl5000_rx_calib_complete(struct iwl_priv *priv,
 /*
  * ucode
  */
-static int iwl5000_load_section(struct iwl_priv *priv,
-				struct fw_desc *image,
-				u32 dst_addr)
+static int iwl5000_load_section(struct iwl_priv *priv, const char *name,
+				struct fw_desc *image, u32 dst_addr)
 {
 	dma_addr_t phy_addr = image->p_addr;
 	u32 byte_cnt = image->len;
+	int ret;
+
+	priv->ucode_write_complete = 0;
 
 	iwl_write_direct32(priv,
 		FH_TCSR_CHNL_TX_CONFIG_REG(FH_SRVC_CHNL),
@@ -447,57 +449,36 @@ static int iwl5000_load_section(struct iwl_priv *priv,
 		FH_TCSR_TX_CONFIG_REG_VAL_DMA_CREDIT_DISABLE	|
 		FH_TCSR_TX_CONFIG_REG_VAL_CIRQ_HOST_ENDTFD);
 
-	return 0;
-}
-
-static int iwl5000_load_given_ucode(struct iwl_priv *priv,
-		struct fw_desc *inst_image,
-		struct fw_desc *data_image)
-{
-	int ret = 0;
-
-	ret = iwl5000_load_section(priv, inst_image,
-				   IWL50_RTC_INST_LOWER_BOUND);
-	if (ret)
-		return ret;
-
-	IWL_DEBUG_INFO(priv, "INST uCode section being loaded...\n");
+	IWL_DEBUG_INFO(priv, "%s uCode section being loaded...\n", name);
 	ret = wait_event_interruptible_timeout(priv->wait_command_queue,
 					priv->ucode_write_complete, 5 * HZ);
 	if (ret == -ERESTARTSYS) {
-		IWL_ERR(priv, "Could not load the INST uCode section due "
-			"to interrupt\n");
+		IWL_ERR(priv, "Could not load the %s uCode section due "
+			"to interrupt\n", name);
 		return ret;
 	}
 	if (!ret) {
-		IWL_ERR(priv, "Could not load the INST uCode section\n");
+		IWL_ERR(priv, "Could not load the %s uCode section\n",
+			name);
 		return -ETIMEDOUT;
 	}
 
-	priv->ucode_write_complete = 0;
-
-	ret = iwl5000_load_section(
-		priv, data_image, IWL50_RTC_DATA_LOWER_BOUND);
-	if (ret)
-		return ret;
+	return 0;
+}
 
-	IWL_DEBUG_INFO(priv, "DATA uCode section being loaded...\n");
+static int iwl5000_load_given_ucode(struct iwl_priv *priv,
+		struct fw_desc *inst_image,
+		struct fw_desc *data_image)
+{
+	int ret = 0;
 
-	ret = wait_event_interruptible_timeout(priv->wait_command_queue,
-				priv->ucode_write_complete, 5 * HZ);
-	if (ret == -ERESTARTSYS) {
-		IWL_ERR(priv, "Could not load the INST uCode section due "
-			"to interrupt\n");
+	ret = iwl5000_load_section(priv, "INST", inst_image,
+				   IWL50_RTC_INST_LOWER_BOUND);
+	if (ret)
 		return ret;
-	} else if (!ret) {
-		IWL_ERR(priv, "Could not load the DATA uCode section\n");
-		return -ETIMEDOUT;
-	} else
-		ret = 0;
-
-	priv->ucode_write_complete = 0;
 
-	return ret;
+	return iwl5000_load_section(priv, "DATA", data_image,
+				    IWL50_RTC_DATA_LOWER_BOUND);
 }
 
 int iwl5000_load_ucode(struct iwl_priv *priv)
-- 
1.6.3.3

