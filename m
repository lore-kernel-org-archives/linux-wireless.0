Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:60992 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754399AbYAOC06 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jan 2008 21:26:58 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 07/12] iwlwifi: move uCode helper functions to iwl-helpers.h
Date: Mon, 14 Jan 2008 17:46:20 -0800
Message-Id: <1200361585-31801-8-git-send-email-reinette.chatre@intel.com> (sfid-20080115_022713_798145_D8A338CC)
In-Reply-To: <1200361585-31801-7-git-send-email-reinette.chatre@intel.com>
References: <1200361585-31801-1-git-send-email-reinette.chatre@intel.com>
 <1200361585-31801-2-git-send-email-reinette.chatre@intel.com>
 <1200361585-31801-3-git-send-email-reinette.chatre@intel.com>
 <1200361585-31801-4-git-send-email-reinette.chatre@intel.com>
 <1200361585-31801-5-git-send-email-reinette.chatre@intel.com>
 <1200361585-31801-6-git-send-email-reinette.chatre@intel.com>
 <1200361585-31801-7-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch adds iwl_free_fw_desc ucode helper function.
It also moves ucode helper functions to iwl-helpers.h.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-helpers.h  |   18 +++++++
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   66 +++++----------------------
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   65 +++++---------------------
 3 files changed, 42 insertions(+), 107 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-helpers.h b/drivers/net/wireless/iwlwifi/iwl-helpers.h
index 5228834..cd2eb18 100644
--- a/drivers/net/wireless/iwlwifi/iwl-helpers.h
+++ b/drivers/net/wireless/iwlwifi/iwl-helpers.h
@@ -257,4 +257,22 @@ static inline u8 iwl_get_dma_hi_address(dma_addr_t addr)
 	return sizeof(addr) > sizeof(u32) ? (addr >> 16) >> 16 : 0;
 }
 
+/* TODO: Move fw_desc functions to iwl-pci.ko */
+static inline void iwl_free_fw_desc(struct pci_dev *pci_dev,
+				    struct fw_desc *desc)
+{
+	if (desc->v_addr)
+		pci_free_consistent(pci_dev, desc->len,
+				    desc->v_addr, desc->p_addr);
+	desc->v_addr = NULL;
+	desc->len = 0;
+}
+
+static inline int iwl_alloc_fw_desc(struct pci_dev *pci_dev,
+				    struct fw_desc *desc)
+{
+	desc->v_addr = pci_alloc_consistent(pci_dev, desc->len, &desc->p_addr);
+	return (desc->v_addr != NULL) ? 0 : -ENOMEM;
+}
+
 #endif				/* __iwl_helpers_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index d5d40bf..c834e69 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -5479,48 +5479,12 @@ static int iwl3945_init_geos(struct iwl3945_priv *priv)
 
 static void iwl3945_dealloc_ucode_pci(struct iwl3945_priv *priv)
 {
-	if (priv->ucode_code.v_addr != NULL) {
-		pci_free_consistent(priv->pci_dev,
-				    priv->ucode_code.len,
-				    priv->ucode_code.v_addr,
-				    priv->ucode_code.p_addr);
-		priv->ucode_code.v_addr = NULL;
-	}
-	if (priv->ucode_data.v_addr != NULL) {
-		pci_free_consistent(priv->pci_dev,
-				    priv->ucode_data.len,
-				    priv->ucode_data.v_addr,
-				    priv->ucode_data.p_addr);
-		priv->ucode_data.v_addr = NULL;
-	}
-	if (priv->ucode_data_backup.v_addr != NULL) {
-		pci_free_consistent(priv->pci_dev,
-				    priv->ucode_data_backup.len,
-				    priv->ucode_data_backup.v_addr,
-				    priv->ucode_data_backup.p_addr);
-		priv->ucode_data_backup.v_addr = NULL;
-	}
-	if (priv->ucode_init.v_addr != NULL) {
-		pci_free_consistent(priv->pci_dev,
-				    priv->ucode_init.len,
-				    priv->ucode_init.v_addr,
-				    priv->ucode_init.p_addr);
-		priv->ucode_init.v_addr = NULL;
-	}
-	if (priv->ucode_init_data.v_addr != NULL) {
-		pci_free_consistent(priv->pci_dev,
-				    priv->ucode_init_data.len,
-				    priv->ucode_init_data.v_addr,
-				    priv->ucode_init_data.p_addr);
-		priv->ucode_init_data.v_addr = NULL;
-	}
-	if (priv->ucode_boot.v_addr != NULL) {
-		pci_free_consistent(priv->pci_dev,
-				    priv->ucode_boot.len,
-				    priv->ucode_boot.v_addr,
-				    priv->ucode_boot.p_addr);
-		priv->ucode_boot.v_addr = NULL;
-	}
+	iwl_free_fw_desc(priv->pci_dev, &priv->ucode_code);
+	iwl_free_fw_desc(priv->pci_dev, &priv->ucode_data);
+	iwl_free_fw_desc(priv->pci_dev, &priv->ucode_data_backup);
+	iwl_free_fw_desc(priv->pci_dev, &priv->ucode_init);
+	iwl_free_fw_desc(priv->pci_dev, &priv->ucode_init_data);
+	iwl_free_fw_desc(priv->pci_dev, &priv->ucode_boot);
 }
 
 /**
@@ -5817,12 +5781,6 @@ static void iwl3945_nic_start(struct iwl3945_priv *priv)
 	iwl3945_write32(priv, CSR_RESET, 0);
 }
 
-static int iwl3945_alloc_fw_desc(struct pci_dev *pci_dev, struct fw_desc *desc)
-{
-	desc->v_addr = pci_alloc_consistent(pci_dev, desc->len, &desc->p_addr);
-	return (desc->v_addr != NULL) ? 0 : -ENOMEM;
-}
-
 /**
  * iwl3945_read_ucode - Read uCode images from disk file.
  *
@@ -5925,13 +5883,13 @@ static int iwl3945_read_ucode(struct iwl3945_priv *priv)
 	 * 1) unmodified from disk
 	 * 2) backup cache for save/restore during power-downs */
 	priv->ucode_code.len = inst_size;
-	iwl3945_alloc_fw_desc(priv->pci_dev, &priv->ucode_code);
+	iwl_alloc_fw_desc(priv->pci_dev, &priv->ucode_code);
 
 	priv->ucode_data.len = data_size;
-	iwl3945_alloc_fw_desc(priv->pci_dev, &priv->ucode_data);
+	iwl_alloc_fw_desc(priv->pci_dev, &priv->ucode_data);
 
 	priv->ucode_data_backup.len = data_size;
-	iwl3945_alloc_fw_desc(priv->pci_dev, &priv->ucode_data_backup);
+	iwl_alloc_fw_desc(priv->pci_dev, &priv->ucode_data_backup);
 
 	if (!priv->ucode_code.v_addr || !priv->ucode_data.v_addr ||
 	    !priv->ucode_data_backup.v_addr)
@@ -5940,10 +5898,10 @@ static int iwl3945_read_ucode(struct iwl3945_priv *priv)
 	/* Initialization instructions and data */
 	if (init_size && init_data_size) {
 		priv->ucode_init.len = init_size;
-		iwl3945_alloc_fw_desc(priv->pci_dev, &priv->ucode_init);
+		iwl_alloc_fw_desc(priv->pci_dev, &priv->ucode_init);
 
 		priv->ucode_init_data.len = init_data_size;
-		iwl3945_alloc_fw_desc(priv->pci_dev, &priv->ucode_init_data);
+		iwl_alloc_fw_desc(priv->pci_dev, &priv->ucode_init_data);
 
 		if (!priv->ucode_init.v_addr || !priv->ucode_init_data.v_addr)
 			goto err_pci_alloc;
@@ -5952,7 +5910,7 @@ static int iwl3945_read_ucode(struct iwl3945_priv *priv)
 	/* Bootstrap (instructions only, no data) */
 	if (boot_size) {
 		priv->ucode_boot.len = boot_size;
-		iwl3945_alloc_fw_desc(priv->pci_dev, &priv->ucode_boot);
+		iwl_alloc_fw_desc(priv->pci_dev, &priv->ucode_boot);
 
 		if (!priv->ucode_boot.v_addr)
 			goto err_pci_alloc;
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 621871d..ca7a175 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -5917,48 +5917,12 @@ static int iwl4965_init_geos(struct iwl4965_priv *priv)
 
 static void iwl4965_dealloc_ucode_pci(struct iwl4965_priv *priv)
 {
-	if (priv->ucode_code.v_addr != NULL) {
-		pci_free_consistent(priv->pci_dev,
-				    priv->ucode_code.len,
-				    priv->ucode_code.v_addr,
-				    priv->ucode_code.p_addr);
-		priv->ucode_code.v_addr = NULL;
-	}
-	if (priv->ucode_data.v_addr != NULL) {
-		pci_free_consistent(priv->pci_dev,
-				    priv->ucode_data.len,
-				    priv->ucode_data.v_addr,
-				    priv->ucode_data.p_addr);
-		priv->ucode_data.v_addr = NULL;
-	}
-	if (priv->ucode_data_backup.v_addr != NULL) {
-		pci_free_consistent(priv->pci_dev,
-				    priv->ucode_data_backup.len,
-				    priv->ucode_data_backup.v_addr,
-				    priv->ucode_data_backup.p_addr);
-		priv->ucode_data_backup.v_addr = NULL;
-	}
-	if (priv->ucode_init.v_addr != NULL) {
-		pci_free_consistent(priv->pci_dev,
-				    priv->ucode_init.len,
-				    priv->ucode_init.v_addr,
-				    priv->ucode_init.p_addr);
-		priv->ucode_init.v_addr = NULL;
-	}
-	if (priv->ucode_init_data.v_addr != NULL) {
-		pci_free_consistent(priv->pci_dev,
-				    priv->ucode_init_data.len,
-				    priv->ucode_init_data.v_addr,
-				    priv->ucode_init_data.p_addr);
-		priv->ucode_init_data.v_addr = NULL;
-	}
-	if (priv->ucode_boot.v_addr != NULL) {
-		pci_free_consistent(priv->pci_dev,
-				    priv->ucode_boot.len,
-				    priv->ucode_boot.v_addr,
-				    priv->ucode_boot.p_addr);
-		priv->ucode_boot.v_addr = NULL;
-	}
+	iwl_free_fw_desc(priv->pci_dev, &priv->ucode_code);
+	iwl_free_fw_desc(priv->pci_dev, &priv->ucode_data);
+	iwl_free_fw_desc(priv->pci_dev, &priv->ucode_data_backup);
+	iwl_free_fw_desc(priv->pci_dev, &priv->ucode_init);
+	iwl_free_fw_desc(priv->pci_dev, &priv->ucode_init_data);
+	iwl_free_fw_desc(priv->pci_dev, &priv->ucode_boot);
 }
 
 /**
@@ -6257,11 +6221,6 @@ static void iwl4965_nic_start(struct iwl4965_priv *priv)
 	iwl4965_write32(priv, CSR_RESET, 0);
 }
 
-static int iwl4965_alloc_fw_desc(struct pci_dev *pci_dev, struct fw_desc *desc)
-{
-	desc->v_addr = pci_alloc_consistent(pci_dev, desc->len, &desc->p_addr);
-	return (desc->v_addr != NULL) ? 0 : -ENOMEM;
-}
 
 /**
  * iwl4965_read_ucode - Read uCode images from disk file.
@@ -6372,21 +6331,21 @@ static int iwl4965_read_ucode(struct iwl4965_priv *priv)
 	 * 1) unmodified from disk
 	 * 2) backup cache for save/restore during power-downs */
 	priv->ucode_code.len = inst_size;
-	iwl4965_alloc_fw_desc(priv->pci_dev, &priv->ucode_code);
+	iwl_alloc_fw_desc(priv->pci_dev, &priv->ucode_code);
 
 	priv->ucode_data.len = data_size;
-	iwl4965_alloc_fw_desc(priv->pci_dev, &priv->ucode_data);
+	iwl_alloc_fw_desc(priv->pci_dev, &priv->ucode_data);
 
 	priv->ucode_data_backup.len = data_size;
-	iwl4965_alloc_fw_desc(priv->pci_dev, &priv->ucode_data_backup);
+	iwl_alloc_fw_desc(priv->pci_dev, &priv->ucode_data_backup);
 
 	/* Initialization instructions and data */
 	if (init_size && init_data_size) {
 		priv->ucode_init.len = init_size;
-		iwl4965_alloc_fw_desc(priv->pci_dev, &priv->ucode_init);
+		iwl_alloc_fw_desc(priv->pci_dev, &priv->ucode_init);
 
 		priv->ucode_init_data.len = init_data_size;
-		iwl4965_alloc_fw_desc(priv->pci_dev, &priv->ucode_init_data);
+		iwl_alloc_fw_desc(priv->pci_dev, &priv->ucode_init_data);
 
 		if (!priv->ucode_init.v_addr || !priv->ucode_init_data.v_addr)
 			goto err_pci_alloc;
@@ -6395,7 +6354,7 @@ static int iwl4965_read_ucode(struct iwl4965_priv *priv)
 	/* Bootstrap (instructions only, no data) */
 	if (boot_size) {
 		priv->ucode_boot.len = boot_size;
-		iwl4965_alloc_fw_desc(priv->pci_dev, &priv->ucode_boot);
+		iwl_alloc_fw_desc(priv->pci_dev, &priv->ucode_boot);
 
 		if (!priv->ucode_boot.v_addr)
 			goto err_pci_alloc;
-- 
1.5.3.4

