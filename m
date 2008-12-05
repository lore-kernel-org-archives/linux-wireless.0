Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:40355 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756124AbYLEP5p (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Dec 2008 10:57:45 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net, "Zhu, Yi" <yi.zhu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 5/6] iwlwifi: iwl_poll_{direct_}bit cleanup
Date: Fri,  5 Dec 2008 07:58:40 -0800
Message-Id: <1228492721-27381-6-git-send-email-reinette.chatre@intel.com> (sfid-20081205_165754_024250_37D941E9)
In-Reply-To: <1228492721-27381-5-git-send-email-reinette.chatre@intel.com>
References: <>
 <1228492721-27381-1-git-send-email-reinette.chatre@intel.com>
 <1228492721-27381-2-git-send-email-reinette.chatre@intel.com>
 <1228492721-27381-3-git-send-email-reinette.chatre@intel.com>
 <1228492721-27381-4-git-send-email-reinette.chatre@intel.com>
 <1228492721-27381-5-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Zhu, Yi <yi.zhu@intel.com>

The patch merges implementation of iwl_poll_bit() and
iwl_poll_direct_bit() by letting the latter be a special case of
the former.

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945-hw.h  |    1 +
 drivers/net/wireless/iwlwifi/iwl-3945-io.h  |   11 +----------
 drivers/net/wireless/iwlwifi/iwl-3945.c     |   16 +++++++---------
 drivers/net/wireless/iwlwifi/iwl-4965.c     |   16 ++++++----------
 drivers/net/wireless/iwlwifi/iwl-5000.c     |   13 +++++--------
 drivers/net/wireless/iwlwifi/iwl-eeprom.c   |    7 +++----
 drivers/net/wireless/iwlwifi/iwl-io.h       |   15 +++------------
 drivers/net/wireless/iwlwifi/iwl-rx.c       |    6 ++----
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    5 ++---
 9 files changed, 30 insertions(+), 60 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-hw.h b/drivers/net/wireless/iwlwifi/iwl-3945-hw.h
index 644bd9e..f0f7dc7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-hw.h
@@ -321,6 +321,7 @@ struct iwl3945_eeprom {
 /* RSSR */
 #define FH_RSSR_CTRL            (FH_RSSR_TABLE+0x000)
 #define FH_RSSR_STATUS          (FH_RSSR_TABLE+0x004)
+#define FH_RSSR_CHNL0_RX_STATUS_CHNL_IDLE	(0x01000000)
 /* TCSR */
 #define FH_TCSR(_channel)           (FH_TCSR_TABLE+(_channel)*0x20)
 #define FH_TCSR_CONFIG(_channel)    (FH_TCSR(_channel)+0x00)
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-io.h b/drivers/net/wireless/iwlwifi/iwl-3945-io.h
index 2f74943..994f8ba 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-io.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-io.h
@@ -271,16 +271,7 @@ static inline void iwl3945_write_reg_buf(struct iwl3945_priv *priv,
 static inline int _iwl3945_poll_direct_bit(struct iwl3945_priv *priv,
 					   u32 addr, u32 mask, int timeout)
 {
-	int i = 0;
-
-	do {
-		if ((_iwl3945_read_direct32(priv, addr) & mask) == mask)
-			return i;
-		udelay(10);
-		i += 10;
-	} while (i < timeout);
-
-	return -ETIMEDOUT;
+	return _iwl3945_poll_bit(priv, addr, mask, mask, timeout);
 }
 
 #ifdef CONFIG_IWL3945_DEBUG
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index dc62859..cbb8b0f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -1104,9 +1104,8 @@ int iwl3945_hw_nic_init(struct iwl3945_priv *priv)
 		    CSR_GIO_CHICKEN_BITS_REG_BIT_L1A_NO_L0S_RX);
 
 	iwl3945_set_bit(priv, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_INIT_DONE);
-	rc = iwl3945_poll_bit(priv, CSR_GP_CNTRL,
-			  CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY,
-			  CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY, 25000);
+	rc = iwl3945_poll_direct_bit(priv, CSR_GP_CNTRL,
+			CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY, 25000);
 	if (rc < 0) {
 		spin_unlock_irqrestore(&priv->lock, flags);
 		IWL_DEBUG_INFO("Failed to init the card\n");
@@ -1287,8 +1286,7 @@ int iwl3945_hw_nic_stop_master(struct iwl3945_priv *priv)
 		IWL_DEBUG_INFO("Card in power save, master is already "
 			       "stopped\n");
 	else {
-		rc = iwl3945_poll_bit(priv, CSR_RESET,
-				  CSR_RESET_REG_FLAG_MASTER_DISABLED,
+		rc = iwl3945_poll_direct_bit(priv, CSR_RESET,
 				  CSR_RESET_REG_FLAG_MASTER_DISABLED, 100);
 		if (rc < 0) {
 			spin_unlock_irqrestore(&priv->lock, flags);
@@ -1313,9 +1311,8 @@ int iwl3945_hw_nic_reset(struct iwl3945_priv *priv)
 
 	iwl3945_set_bit(priv, CSR_RESET, CSR_RESET_REG_FLAG_SW_RESET);
 
-	rc = iwl3945_poll_bit(priv, CSR_GP_CNTRL,
-			  CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY,
-			  CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY, 25000);
+	iwl3945_poll_direct_bit(priv, CSR_GP_CNTRL,
+			 CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY, 25000);
 
 	rc = iwl3945_grab_nic_access(priv);
 	if (!rc) {
@@ -2312,7 +2309,8 @@ int iwl3945_hw_rxq_stop(struct iwl3945_priv *priv)
 	}
 
 	iwl3945_write_direct32(priv, FH_RCSR_CONFIG(0), 0);
-	rc = iwl3945_poll_direct_bit(priv, FH_RSSR_STATUS, (1 << 24), 1000);
+	rc = iwl3945_poll_direct_bit(priv, FH_RSSR_STATUS,
+			FH_RSSR_CHNL0_RX_STATUS_CHNL_IDLE, 1000);
 	if (rc < 0)
 		IWL_ERROR("Can't stop Rx DMA.\n");
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index c961e2c..324825e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -352,9 +352,8 @@ static int iwl4965_apm_init(struct iwl_priv *priv)
 	iwl_set_bit(priv, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_INIT_DONE);
 
 	/* wait for clock stabilization */
-	ret = iwl_poll_bit(priv, CSR_GP_CNTRL,
-			   CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY,
-			   CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY, 25000);
+	ret = iwl_poll_direct_bit(priv, CSR_GP_CNTRL,
+			CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY, 25000);
 	if (ret < 0) {
 		IWL_DEBUG_INFO("Failed to init the card\n");
 		goto out;
@@ -436,9 +435,8 @@ static int iwl4965_apm_stop_master(struct iwl_priv *priv)
 	/* set stop master bit */
 	iwl_set_bit(priv, CSR_RESET, CSR_RESET_REG_FLAG_STOP_MASTER);
 
-	ret = iwl_poll_bit(priv, CSR_RESET,
-				  CSR_RESET_REG_FLAG_MASTER_DISABLED,
-				  CSR_RESET_REG_FLAG_MASTER_DISABLED, 100);
+	ret = iwl_poll_direct_bit(priv, CSR_RESET,
+			CSR_RESET_REG_FLAG_MASTER_DISABLED, 100);
 	if (ret < 0)
 		goto out;
 
@@ -482,10 +480,8 @@ static int iwl4965_apm_reset(struct iwl_priv *priv)
 
 	iwl_set_bit(priv, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_INIT_DONE);
 
-	ret = iwl_poll_bit(priv, CSR_GP_CNTRL,
-			  CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY,
-			  CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY, 25000);
-
+	ret = iwl_poll_direct_bit(priv, CSR_GP_CNTRL,
+			CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY, 25000);
 	if (ret < 0)
 		goto out;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 438e4bd..1b82742 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -81,8 +81,7 @@ static int iwl5000_apm_stop_master(struct iwl_priv *priv)
 	/* set stop master bit */
 	iwl_set_bit(priv, CSR_RESET, CSR_RESET_REG_FLAG_STOP_MASTER);
 
-	ret = iwl_poll_bit(priv, CSR_RESET,
-				  CSR_RESET_REG_FLAG_MASTER_DISABLED,
+	ret = iwl_poll_direct_bit(priv, CSR_RESET,
 				  CSR_RESET_REG_FLAG_MASTER_DISABLED, 100);
 	if (ret < 0)
 		goto out;
@@ -120,9 +119,8 @@ static int iwl5000_apm_init(struct iwl_priv *priv)
 	iwl_set_bit(priv, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_INIT_DONE);
 
 	/* wait for clock stabilization */
-	ret = iwl_poll_bit(priv, CSR_GP_CNTRL,
-			  CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY,
-			  CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY, 25000);
+	ret = iwl_poll_direct_bit(priv, CSR_GP_CNTRL,
+			CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY, 25000);
 	if (ret < 0) {
 		IWL_DEBUG_INFO("Failed to init the card\n");
 		return ret;
@@ -189,9 +187,8 @@ static int iwl5000_apm_reset(struct iwl_priv *priv)
 	iwl_set_bit(priv, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_INIT_DONE);
 
 	/* wait for clock stabilization */
-	ret = iwl_poll_bit(priv, CSR_GP_CNTRL,
-			  CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY,
-			  CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY, 25000);
+	ret = iwl_poll_direct_bit(priv, CSR_GP_CNTRL,
+			CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY, 25000);
 	if (ret < 0) {
 		IWL_DEBUG_INFO("Failed to init the card\n");
 		goto out;
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.c b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
index 792a3c1..ae04327 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.c
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
@@ -169,10 +169,9 @@ int iwlcore_eeprom_acquire_semaphore(struct iwl_priv *priv)
 			    CSR_HW_IF_CONFIG_REG_BIT_EEPROM_OWN_SEM);
 
 		/* See if we got it */
-		ret = iwl_poll_bit(priv, CSR_HW_IF_CONFIG_REG,
-				   CSR_HW_IF_CONFIG_REG_BIT_EEPROM_OWN_SEM,
-				   CSR_HW_IF_CONFIG_REG_BIT_EEPROM_OWN_SEM,
-				   EEPROM_SEM_TIMEOUT);
+		ret = iwl_poll_direct_bit(priv, CSR_HW_IF_CONFIG_REG,
+				CSR_HW_IF_CONFIG_REG_BIT_EEPROM_OWN_SEM,
+				EEPROM_SEM_TIMEOUT);
 		if (ret >= 0) {
 			IWL_DEBUG_IO("Acquired semaphore after %d tries.\n",
 				count+1);
diff --git a/drivers/net/wireless/iwlwifi/iwl-io.h b/drivers/net/wireless/iwlwifi/iwl-io.h
index a5c489a..c56dc21 100644
--- a/drivers/net/wireless/iwlwifi/iwl-io.h
+++ b/drivers/net/wireless/iwlwifi/iwl-io.h
@@ -269,19 +269,10 @@ static inline void iwl_write_reg_buf(struct iwl_priv *priv,
 	}
 }
 
-static inline int _iwl_poll_direct_bit(struct iwl_priv *priv,
-					   u32 addr, u32 mask, int timeout)
+static inline int _iwl_poll_direct_bit(struct iwl_priv *priv, u32 addr,
+				       u32 mask, int timeout)
 {
-	int i = 0;
-
-	do {
-		if ((_iwl_read_direct32(priv, addr) & mask) == mask)
-			return i;
-		udelay(10);
-		i += 10;
-	} while (i < timeout);
-
-	return -ETIMEDOUT;
+	return _iwl_poll_bit(priv, addr, mask, mask, timeout);
 }
 
 #ifdef CONFIG_IWLWIFI_DEBUG
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index 6dd16c7..1938e6d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -467,10 +467,8 @@ int iwl_rxq_stop(struct iwl_priv *priv)
 
 	/* stop Rx DMA */
 	iwl_write_direct32(priv, FH_MEM_RCSR_CHNL0_CONFIG_REG, 0);
-	ret = iwl_poll_direct_bit(priv, FH_MEM_RSSR_RX_STATUS_REG,
-				     (1 << 24), 1000);
-	if (ret < 0)
-		IWL_ERROR("Can't stop Rx DMA.\n");
+	iwl_poll_direct_bit(priv, FH_MEM_RSSR_RX_STATUS_REG,
+			    FH_RSSR_CHNL0_RX_STATUS_CHNL_IDLE, 1000);
 
 	iwl_release_nic_access(priv);
 	spin_unlock_irqrestore(&priv->lock, flags);
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index f5fb7de..5fdda51 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -7943,9 +7943,8 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 			CSR_GIO_CHICKEN_BITS_REG_BIT_DIS_L0S_EXIT_TIMER);
 
 	iwl3945_set_bit(priv, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_INIT_DONE);
-	err = iwl3945_poll_bit(priv, CSR_GP_CNTRL,
-			       CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY,
-			       CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY, 25000);
+	err = iwl3945_poll_direct_bit(priv, CSR_GP_CNTRL,
+				CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY, 25000);
 	if (err < 0) {
 		IWL_DEBUG_INFO("Failed to init the card\n");
 		goto out_remove_sysfs;
-- 
1.5.4.3

