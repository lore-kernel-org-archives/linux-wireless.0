Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37090 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754032Ab2IJRO4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Sep 2012 13:14:56 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6/6] iwlwifi: load firmware in chunks
Date: Mon, 10 Sep 2012 19:15:30 +0200
Message-Id: <1347297330-23338-7-git-send-email-johannes@sipsolutions.net> (sfid-20120910_191508_460162_661FB48E)
In-Reply-To: <1347297330-23338-1-git-send-email-johannes@sipsolutions.net>
References: <1347297330-23338-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Instead of allocating one big chunk of DMA-coherent
memory for the firmware and keeping it around, only
vmalloc() the firmware and copy it into a single
page of DMA-coherent memory for the upload.

The advantage is that we don't need DMA memory for
the firmware image that is stored while the driver
is operating, we only need it while uploading.

This will make it easier for the driver to work if
the system has fragmented memory.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/ucode.c  |    4 +--
 drivers/net/wireless/iwlwifi/iwl-drv.c    |   26 +++++++-------
 drivers/net/wireless/iwlwifi/iwl-fw.h     |    3 +-
 drivers/net/wireless/iwlwifi/pcie/trans.c |   53 ++++++++++++++++++++++-------
 4 files changed, 58 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/ucode.c b/drivers/net/wireless/iwlwifi/dvm/ucode.c
index 6d8d6dd..2cb1efb 100644
--- a/drivers/net/wireless/iwlwifi/dvm/ucode.c
+++ b/drivers/net/wireless/iwlwifi/dvm/ucode.c
@@ -295,7 +295,7 @@ static int iwl_alive_notify(struct iwl_priv *priv)
 static int iwl_verify_sec_sparse(struct iwl_priv *priv,
 				  const struct fw_desc *fw_desc)
 {
-	__le32 *image = (__le32 *)fw_desc->v_addr;
+	__le32 *image = (__le32 *)fw_desc->data;
 	u32 len = fw_desc->len;
 	u32 val;
 	u32 i;
@@ -319,7 +319,7 @@ static int iwl_verify_sec_sparse(struct iwl_priv *priv,
 static void iwl_print_mismatch_sec(struct iwl_priv *priv,
 				    const struct fw_desc *fw_desc)
 {
-	__le32 *image = (__le32 *)fw_desc->v_addr;
+	__le32 *image = (__le32 *)fw_desc->data;
 	u32 len = fw_desc->len;
 	u32 val;
 	u32 offs;
diff --git a/drivers/net/wireless/iwlwifi/iwl-drv.c b/drivers/net/wireless/iwlwifi/iwl-drv.c
index 48d6d44..198634b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/iwlwifi/iwl-drv.c
@@ -64,6 +64,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/firmware.h>
 #include <linux/module.h>
+#include <linux/vmalloc.h>
 
 #include "iwl-drv.h"
 #include "iwl-debug.h"
@@ -164,10 +165,8 @@ struct fw_sec {
 
 static void iwl_free_fw_desc(struct iwl_drv *drv, struct fw_desc *desc)
 {
-	if (desc->v_addr)
-		dma_free_coherent(drv->trans->dev, desc->len,
-				  desc->v_addr, desc->p_addr);
-	desc->v_addr = NULL;
+	vfree(desc->data);
+	desc->data = NULL;
 	desc->len = 0;
 }
 
@@ -186,21 +185,24 @@ static void iwl_dealloc_ucode(struct iwl_drv *drv)
 }
 
 static int iwl_alloc_fw_desc(struct iwl_drv *drv, struct fw_desc *desc,
-		      struct fw_sec *sec)
+			     struct fw_sec *sec)
 {
-	if (!sec || !sec->size) {
-		desc->v_addr = NULL;
+	void *data;
+
+	desc->data = NULL;
+
+	if (!sec || !sec->size)
 		return -EINVAL;
-	}
 
-	desc->v_addr = dma_alloc_coherent(drv->trans->dev, sec->size,
-					  &desc->p_addr, GFP_KERNEL);
-	if (!desc->v_addr)
+	data = vmalloc(sec->size);
+	if (!data)
 		return -ENOMEM;
 
 	desc->len = sec->size;
 	desc->offset = sec->offset;
-	memcpy(desc->v_addr, sec->data, sec->size);
+	memcpy(data, sec->data, desc->len);
+	desc->data = data;
+
 	return 0;
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-fw.h b/drivers/net/wireless/iwlwifi/iwl-fw.h
index 2153e4c..d1a86b6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw.h
@@ -124,8 +124,7 @@ struct iwl_ucode_capabilities {
 
 /* one for each uCode image (inst/data, init/runtime/wowlan) */
 struct fw_desc {
-	dma_addr_t p_addr;	/* hardware address */
-	void *v_addr;		/* software address */
+	const void *data;	/* vmalloc'ed data */
 	u32 len;		/* size in bytes */
 	u32 offset;		/* offset in the device */
 };
diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index d44fa2a..3cb4f85 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -923,13 +923,10 @@ static int iwl_prepare_card_hw(struct iwl_trans *trans)
 /*
  * ucode
  */
-static int iwl_load_section(struct iwl_trans *trans, u8 section_num,
-			    const struct fw_desc *section)
+static int iwl_load_firmware_chunk(struct iwl_trans *trans, u32 dst_addr,
+				   dma_addr_t phy_addr, u32 byte_cnt)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-	dma_addr_t phy_addr = section->p_addr;
-	u32 byte_cnt = section->len;
-	u32 dst_addr = section->offset;
 	int ret;
 
 	trans_pcie->ucode_write_complete = false;
@@ -943,8 +940,8 @@ static int iwl_load_section(struct iwl_trans *trans, u8 section_num,
 			   dst_addr);
 
 	iwl_write_direct32(trans,
-		FH_TFDIB_CTRL0_REG(FH_SRVC_CHNL),
-		phy_addr & FH_MEM_TFDIB_DRAM_ADDR_LSB_MSK);
+			   FH_TFDIB_CTRL0_REG(FH_SRVC_CHNL),
+			   phy_addr & FH_MEM_TFDIB_DRAM_ADDR_LSB_MSK);
 
 	iwl_write_direct32(trans,
 			   FH_TFDIB_CTRL1_REG(FH_SRVC_CHNL),
@@ -963,26 +960,58 @@ static int iwl_load_section(struct iwl_trans *trans, u8 section_num,
 			   FH_TCSR_TX_CONFIG_REG_VAL_DMA_CREDIT_DISABLE	|
 			   FH_TCSR_TX_CONFIG_REG_VAL_CIRQ_HOST_ENDTFD);
 
-	IWL_DEBUG_FW(trans, "[%d] uCode section being loaded...\n",
-		     section_num);
 	ret = wait_event_timeout(trans_pcie->ucode_write_waitq,
 				 trans_pcie->ucode_write_complete, 5 * HZ);
 	if (!ret) {
-		IWL_ERR(trans, "Could not load the [%d] uCode section\n",
-			section_num);
+		IWL_ERR(trans, "Failed to load firmware chunk!\n");
 		return -ETIMEDOUT;
 	}
 
 	return 0;
 }
 
+static int iwl_load_section(struct iwl_trans *trans, u8 section_num,
+			    const struct fw_desc *section)
+{
+	u8 *v_addr;
+	dma_addr_t p_addr;
+	u32 offset;
+	int ret = 0;
+
+	IWL_DEBUG_FW(trans, "[%d] uCode section being loaded...\n",
+		     section_num);
+
+	v_addr = dma_alloc_coherent(trans->dev, PAGE_SIZE, &p_addr, GFP_KERNEL);
+	if (!v_addr)
+		return -ENOMEM;
+
+	for (offset = 0; offset < section->len; offset += PAGE_SIZE) {
+		u32 copy_size;
+
+		copy_size = min_t(u32, PAGE_SIZE, section->len - offset);
+
+		memcpy(v_addr, (u8 *)section->data + offset, copy_size);
+		ret = iwl_load_firmware_chunk(trans, section->offset + offset,
+					      p_addr, copy_size);
+		if (ret) {
+			IWL_ERR(trans,
+				"Could not load the [%d] uCode section\n",
+				section_num);
+			break;
+		}
+	}
+
+	dma_free_coherent(trans->dev, PAGE_SIZE, v_addr, p_addr);
+	return ret;
+}
+
 static int iwl_load_given_ucode(struct iwl_trans *trans,
 				const struct fw_img *image)
 {
 	int i, ret = 0;
 
 	for (i = 0; i < IWL_UCODE_SECTION_MAX; i++) {
-		if (!image->sec[i].p_addr)
+		if (!image->sec[i].data)
 			break;
 
 		ret = iwl_load_section(trans, i, &image->sec[i]);
-- 
1.7.10.4

