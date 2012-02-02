Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:37622 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754370Ab2BCAQw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Feb 2012 19:16:52 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 10/28] iwlwifi: don't use the bus for ucode fw_desc any more
Date: Thu,  2 Feb 2012 15:09:01 -0800
Message-Id: <1328224159-18134-11-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120203_011657_341224_7DC6BD5B)
In-Reply-To: <1328224159-18134-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1328224159-18134-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This is transport related

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c   |   14 ++++++++------
 drivers/net/wireless/iwlwifi/iwl-trans.h |    2 +-
 drivers/net/wireless/iwlwifi/iwl-ucode.c |   20 ++++++++++----------
 3 files changed, 19 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index d890b64..8b1839a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1023,31 +1023,33 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 	/* Runtime instructions and 2 copies of data:
 	 * 1) unmodified from disk
 	 * 2) backup cache for save/restore during power-downs */
-	if (iwl_alloc_fw_desc(bus(priv), &trans(priv)->ucode_rt.code,
+	if (iwl_alloc_fw_desc(trans(priv), &trans(priv)->ucode_rt.code,
 			      pieces.inst, pieces.inst_size))
 		goto err_pci_alloc;
-	if (iwl_alloc_fw_desc(bus(priv), &trans(priv)->ucode_rt.data,
+	if (iwl_alloc_fw_desc(trans(priv), &trans(priv)->ucode_rt.data,
 			      pieces.data, pieces.data_size))
 		goto err_pci_alloc;
 
 	/* Initialization instructions and data */
 	if (pieces.init_size && pieces.init_data_size) {
-		if (iwl_alloc_fw_desc(bus(priv), &trans(priv)->ucode_init.code,
+		if (iwl_alloc_fw_desc(trans(priv),
+				      &trans(priv)->ucode_init.code,
 				      pieces.init, pieces.init_size))
 			goto err_pci_alloc;
-		if (iwl_alloc_fw_desc(bus(priv), &trans(priv)->ucode_init.data,
+		if (iwl_alloc_fw_desc(trans(priv),
+				      &trans(priv)->ucode_init.data,
 				      pieces.init_data, pieces.init_data_size))
 			goto err_pci_alloc;
 	}
 
 	/* WoWLAN instructions and data */
 	if (pieces.wowlan_inst_size && pieces.wowlan_data_size) {
-		if (iwl_alloc_fw_desc(bus(priv),
+		if (iwl_alloc_fw_desc(trans(priv),
 				      &trans(priv)->ucode_wowlan.code,
 				      pieces.wowlan_inst,
 				      pieces.wowlan_inst_size))
 			goto err_pci_alloc;
-		if (iwl_alloc_fw_desc(bus(priv),
+		if (iwl_alloc_fw_desc(trans(priv),
 				      &trans(priv)->ucode_wowlan.data,
 				      pieces.wowlan_data,
 				      pieces.wowlan_data_size))
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index dec935a..d519599 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -408,7 +408,7 @@ static inline u32 iwl_trans_read32(struct iwl_trans *trans, u32 ofs)
 /*****************************************************
 * Utils functions
 ******************************************************/
-int iwl_alloc_fw_desc(struct iwl_bus *bus, struct fw_desc *desc,
+int iwl_alloc_fw_desc(struct iwl_trans *trans, struct fw_desc *desc,
 		      const void *data, size_t len);
 void iwl_dealloc_ucode(struct iwl_trans *trans);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-ucode.c b/drivers/net/wireless/iwlwifi/iwl-ucode.c
index 08483d7..793524a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-ucode.c
@@ -80,29 +80,29 @@ static struct iwl_wimax_coex_event_entry cu_priorities[COEX_NUM_OF_EVENTS] = {
  *
  ******************************************************************************/
 
-static void iwl_free_fw_desc(struct iwl_bus *bus, struct fw_desc *desc)
+static void iwl_free_fw_desc(struct iwl_trans *trans, struct fw_desc *desc)
 {
 	if (desc->v_addr)
-		dma_free_coherent(trans(bus)->dev, desc->len,
+		dma_free_coherent(trans->dev, desc->len,
 				  desc->v_addr, desc->p_addr);
 	desc->v_addr = NULL;
 	desc->len = 0;
 }
 
-static void iwl_free_fw_img(struct iwl_bus *bus, struct fw_img *img)
+static void iwl_free_fw_img(struct iwl_trans *trans, struct fw_img *img)
 {
-	iwl_free_fw_desc(bus, &img->code);
-	iwl_free_fw_desc(bus, &img->data);
+	iwl_free_fw_desc(trans, &img->code);
+	iwl_free_fw_desc(trans, &img->data);
 }
 
 void iwl_dealloc_ucode(struct iwl_trans *trans)
 {
-	iwl_free_fw_img(bus(trans), &trans->ucode_rt);
-	iwl_free_fw_img(bus(trans), &trans->ucode_init);
-	iwl_free_fw_img(bus(trans), &trans->ucode_wowlan);
+	iwl_free_fw_img(trans, &trans->ucode_rt);
+	iwl_free_fw_img(trans, &trans->ucode_init);
+	iwl_free_fw_img(trans, &trans->ucode_wowlan);
 }
 
-int iwl_alloc_fw_desc(struct iwl_bus *bus, struct fw_desc *desc,
+int iwl_alloc_fw_desc(struct iwl_trans *trans, struct fw_desc *desc,
 		      const void *data, size_t len)
 {
 	if (!len) {
@@ -110,7 +110,7 @@ int iwl_alloc_fw_desc(struct iwl_bus *bus, struct fw_desc *desc,
 		return -EINVAL;
 	}
 
-	desc->v_addr = dma_alloc_coherent(trans(bus)->dev, len,
+	desc->v_addr = dma_alloc_coherent(trans->dev, len,
 					  &desc->p_addr, GFP_KERNEL);
 	if (!desc->v_addr)
 		return -ENOMEM;
-- 
1.7.0.4

