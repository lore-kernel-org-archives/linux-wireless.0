Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:2924 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751199AbbHRH5v (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Aug 2015 03:57:51 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Matti Gottlieb <matti.gottlieb@intel.com>,
	Eran Harary <eran.harary@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 01/26] iwlwifi: mvm: Add FW paging mechanism for the UMAC on PCI
Date: Tue, 18 Aug 2015 10:57:11 +0300
Message-Id: <1439884656-18146-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150818_100109_314244_4BD7B00C)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E8110F8@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E8110F8@hasmsx107.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Matti Gottlieb <matti.gottlieb@intel.com>

Family 8000 products has 2 embedded processors, the first
known as LMAC (lower MAC) and implements the functionality from
previous products, the second one is known as UMAC (upper MAC)
and is used mainly for driver offloads as well as new features.
The UMAC is typically “less” real-time than the LMAC and is used
for higher level controls.
The UMAC's code/data size is estimated to be in the mega-byte arena,
taking into account the code it needs to replace in the driver and
the set of new features.

In order to allow the UMAC to execute code that is bigger than its code
memory, we allow the UMAC embedded processor to page out code pages on
DRAM.

When the device is master on the bus(PCI) the driver saves the UMAC's
image pages in blocks of 32K in the DRAM and sends the layout of the
pages to the FW. The FW can load / unload the pages on its own.

The driver can support up to 1 MB of pages.

Add paging mechanism for the UMAC on PCI in order to allow the program
to use a larger virtual space while using less physical memory on the
device.

Signed-off-by: Eran Harary <eran.harary@intel.com>
Signed-off-by: Matti Gottlieb <matti.gottlieb@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-drv.c     |  32 +++-
 drivers/net/wireless/iwlwifi/iwl-fw-file.h |   4 +-
 drivers/net/wireless/iwlwifi/iwl-fw.h      |  40 +++++
 drivers/net/wireless/iwlwifi/mvm/fw-api.h  |  24 +++
 drivers/net/wireless/iwlwifi/mvm/fw.c      | 258 +++++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/mvm/mvm.h     |   5 +
 drivers/net/wireless/iwlwifi/mvm/ops.c     |   1 +
 drivers/net/wireless/iwlwifi/pcie/trans.c  |  18 +-
 8 files changed, 378 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-drv.c b/drivers/net/wireless/iwlwifi/iwl-drv.c
index 6685259..721d3cb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/iwlwifi/iwl-drv.c
@@ -573,10 +573,11 @@ static int iwl_parse_tlv_firmware(struct iwl_drv *drv,
 	size_t len = ucode_raw->size;
 	const u8 *data;
 	u32 tlv_len;
+	u32 usniffer_img;
 	enum iwl_ucode_tlv_type tlv_type;
 	const u8 *tlv_data;
 	char buildstr[25];
-	u32 build;
+	u32 build, paging_mem_size;
 	int num_of_cpus;
 	bool usniffer_images = false;
 	bool usniffer_req = false;
@@ -955,6 +956,35 @@ static int iwl_parse_tlv_firmware(struct iwl_drv *drv,
 					    IWL_UCODE_REGULAR_USNIFFER,
 					    tlv_len);
 			break;
+		case IWL_UCODE_TLV_PAGING:
+			if (tlv_len != sizeof(u32))
+				goto invalid_tlv_len;
+			paging_mem_size = le32_to_cpup((__le32 *)tlv_data);
+
+			IWL_DEBUG_FW(drv,
+				     "Paging: paging enabled (size = %u bytes)\n",
+				     paging_mem_size);
+
+			if (paging_mem_size > MAX_PAGING_IMAGE_SIZE) {
+				IWL_ERR(drv,
+					"Paging: driver supports up to %lu bytes for paging image\n",
+					MAX_PAGING_IMAGE_SIZE);
+				return -EINVAL;
+			}
+
+			if (paging_mem_size & (FW_PAGING_SIZE - 1)) {
+				IWL_ERR(drv,
+					"Paging: image isn't multiple %lu\n",
+					FW_PAGING_SIZE);
+				return -EINVAL;
+			}
+
+			drv->fw.img[IWL_UCODE_REGULAR].paging_mem_size =
+				paging_mem_size;
+			usniffer_img = IWL_UCODE_REGULAR_USNIFFER;
+			drv->fw.img[usniffer_img].paging_mem_size =
+				paging_mem_size;
+			break;
 		case IWL_UCODE_TLV_SDIO_ADMA_ADDR:
 			if (tlv_len != sizeof(u32))
 				goto invalid_tlv_len;
diff --git a/drivers/net/wireless/iwlwifi/iwl-fw-file.h b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
index 926e456..5d7f2d9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw-file.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
@@ -132,6 +132,7 @@ enum iwl_ucode_tlv_type {
 	IWL_UCODE_TLV_API_CHANGES_SET	= 29,
 	IWL_UCODE_TLV_ENABLED_CAPABILITIES	= 30,
 	IWL_UCODE_TLV_N_SCAN_CHANNELS		= 31,
+	IWL_UCODE_TLV_PAGING		= 32,
 	IWL_UCODE_TLV_SEC_RT_USNIFFER	= 34,
 	IWL_UCODE_TLV_SDIO_ADMA_ADDR	= 35,
 	IWL_UCODE_TLV_FW_VERSION	= 36,
@@ -343,8 +344,9 @@ enum iwl_ucode_tlv_capa {
  * For 16.0 uCode and above, there is no differentiation between sections,
  * just an offset to the HW address.
  */
-#define IWL_UCODE_SECTION_MAX 12
+#define IWL_UCODE_SECTION_MAX 16
 #define CPU1_CPU2_SEPARATOR_SECTION	0xFFFFCCCC
+#define PAGING_SEPARATOR_SECTION	0xAAAABBBB
 
 /* uCode version contains 4 values: Major/Minor/API/Serial */
 #define IWL_UCODE_MAJOR(ver)	(((ver) & 0xFF000000) >> 24)
diff --git a/drivers/net/wireless/iwlwifi/iwl-fw.h b/drivers/net/wireless/iwlwifi/iwl-fw.h
index 3e3c9d8..224c7f4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw.h
@@ -133,6 +133,7 @@ struct fw_desc {
 struct fw_img {
 	struct fw_desc sec[IWL_UCODE_SECTION_MAX];
 	bool is_dual_cpus;
+	u32 paging_mem_size;
 };
 
 struct iwl_sf_region {
@@ -140,6 +141,45 @@ struct iwl_sf_region {
 	u32 size;
 };
 
+/*
+ * Block paging calculations
+ */
+#define PAGE_2_EXP_SIZE 12 /* 4K == 2^12 */
+#define FW_PAGING_SIZE BIT(PAGE_2_EXP_SIZE) /* page size is 4KB */
+#define PAGE_PER_GROUP_2_EXP_SIZE 3
+/* 8 pages per group */
+#define NUM_OF_PAGE_PER_GROUP BIT(PAGE_PER_GROUP_2_EXP_SIZE)
+/* don't change, support only 32KB size */
+#define PAGING_BLOCK_SIZE (NUM_OF_PAGE_PER_GROUP * FW_PAGING_SIZE)
+/* 32K == 2^15 */
+#define BLOCK_2_EXP_SIZE (PAGE_2_EXP_SIZE + PAGE_PER_GROUP_2_EXP_SIZE)
+
+/*
+ * Image paging calculations
+ */
+#define BLOCK_PER_IMAGE_2_EXP_SIZE 5
+/* 2^5 == 32 blocks per image */
+#define NUM_OF_BLOCK_PER_IMAGE BIT(BLOCK_PER_IMAGE_2_EXP_SIZE)
+/* maximum image size 1024KB */
+#define MAX_PAGING_IMAGE_SIZE (NUM_OF_BLOCK_PER_IMAGE * PAGING_BLOCK_SIZE)
+
+#define PAGING_CMD_IS_SECURED BIT(9)
+#define PAGING_CMD_IS_ENABLED BIT(8)
+#define PAGING_CMD_NUM_OF_PAGES_IN_LAST_GRP_POS	0
+#define PAGING_TLV_SECURE_MASK 1
+
+/**
+ * struct iwl_fw_paging
+ * @fw_paging_phys: page phy pointer
+ * @fw_paging_block: pointer to the allocated block
+ * @fw_paging_size: page size
+ */
+struct iwl_fw_paging {
+	dma_addr_t fw_paging_phys;
+	struct page *fw_paging_block;
+	u32 fw_paging_size;
+};
+
 /**
  * struct iwl_fw_cscheme_list - a cipher scheme list
  * @size: a number of entries
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api.h b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
index 4e29c11..9c6b153 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
@@ -149,6 +149,9 @@ enum {
 
 	LQ_CMD = 0x4e,
 
+	/* paging block to FW cpu2 */
+	FW_PAGING_BLOCK_CMD = 0x4f,
+
 	/* Scan offload */
 	SCAN_OFFLOAD_REQUEST_CMD = 0x51,
 	SCAN_OFFLOAD_ABORT_CMD = 0x52,
@@ -370,6 +373,27 @@ struct iwl_nvm_access_cmd {
 	u8 data[];
 } __packed; /* NVM_ACCESS_CMD_API_S_VER_2 */
 
+#define NUM_OF_FW_PAGING_BLOCKS	33 /* 32 for data and 1 block for CSS */
+
+/*
+ * struct iwl_fw_paging_cmd - paging layout
+ *
+ * (FW_PAGING_BLOCK_CMD = 0x4f)
+ *
+ * Send to FW the paging layout in the driver.
+ *
+ * @flags: various flags for the command
+ * @block_size: the block size in powers of 2
+ * @block_num: number of blocks specified in the command.
+ * @device_phy_addr: virtual addresses from device side
+*/
+struct iwl_fw_paging_cmd {
+	__le32 flags;
+	__le32 block_size;
+	__le32 block_num;
+	__le32 device_phy_addr[NUM_OF_FW_PAGING_BLOCKS];
+} __packed; /* FW_PAGING_BLOCK_CMD_API_S_VER_1 */
+
 /**
  * struct iwl_nvm_access_resp_ver2 - response to NVM_ACCESS_CMD
  * @offset: offset in bytes into the section
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw.c b/drivers/net/wireless/iwlwifi/mvm/fw.c
index 106edc7..acb402b 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/iwlwifi/mvm/fw.c
@@ -106,6 +106,244 @@ static int iwl_send_tx_ant_cfg(struct iwl_mvm *mvm, u8 valid_tx_ant)
 				    sizeof(tx_ant_cmd), &tx_ant_cmd);
 }
 
+static void iwl_free_fw_paging(struct iwl_mvm *mvm)
+{
+	int i;
+
+	if (!mvm->fw_paging_db[0].fw_paging_block)
+		return;
+
+	for (i = 0; i < NUM_OF_FW_PAGING_BLOCKS; i++) {
+		if (!mvm->fw_paging_db[i].fw_paging_block) {
+			IWL_DEBUG_FW(mvm,
+				     "Paging: block %d already freed, continue to next page\n",
+				     i);
+
+			continue;
+		}
+
+		__free_pages(mvm->fw_paging_db[i].fw_paging_block,
+			     get_order(mvm->fw_paging_db[i].fw_paging_size));
+	}
+	memset(mvm->fw_paging_db, 0, sizeof(mvm->fw_paging_db));
+}
+
+static int iwl_fill_paging_mem(struct iwl_mvm *mvm, const struct fw_img *image)
+{
+	int sec_idx, idx;
+	u32 offset = 0;
+
+	/*
+	 * find where is the paging image start point:
+	 * if CPU2 exist and it's in paging format, then the image looks like:
+	 * CPU1 sections (2 or more)
+	 * CPU1_CPU2_SEPARATOR_SECTION delimiter - separate between CPU1 to CPU2
+	 * CPU2 sections (not paged)
+	 * PAGING_SEPARATOR_SECTION delimiter - separate between CPU2
+	 * non paged to CPU2 paging sec
+	 * CPU2 paging CSS
+	 * CPU2 paging image (including instruction and data)
+	 */
+	for (sec_idx = 0; sec_idx < IWL_UCODE_SECTION_MAX; sec_idx++) {
+		if (image->sec[sec_idx].offset == PAGING_SEPARATOR_SECTION) {
+			sec_idx++;
+			break;
+		}
+	}
+
+	if (sec_idx >= IWL_UCODE_SECTION_MAX) {
+		IWL_ERR(mvm, "driver didn't find paging image\n");
+		iwl_free_fw_paging(mvm);
+		return -EINVAL;
+	}
+
+	/* copy the CSS block to the dram */
+	IWL_DEBUG_FW(mvm, "Paging: load paging CSS to FW, sec = %d\n",
+		     sec_idx);
+
+	memcpy(page_address(mvm->fw_paging_db[0].fw_paging_block),
+	       image->sec[sec_idx].data,
+	       mvm->fw_paging_db[0].fw_paging_size);
+
+	IWL_DEBUG_FW(mvm,
+		     "Paging: copied %d CSS bytes to first block\n",
+		     mvm->fw_paging_db[0].fw_paging_size);
+
+	sec_idx++;
+
+	/*
+	 * copy the paging blocks to the dram
+	 * loop index start from 1 since that CSS block already copied to dram
+	 * and CSS index is 0.
+	 * loop stop at num_of_paging_blk since that last block is not full.
+	 */
+	for (idx = 1; idx < mvm->num_of_paging_blk; idx++) {
+		memcpy(page_address(mvm->fw_paging_db[idx].fw_paging_block),
+		       image->sec[sec_idx].data + offset,
+		       mvm->fw_paging_db[idx].fw_paging_size);
+
+		IWL_DEBUG_FW(mvm,
+			     "Paging: copied %d paging bytes to block %d\n",
+			     mvm->fw_paging_db[idx].fw_paging_size,
+			     idx);
+
+		offset += mvm->fw_paging_db[idx].fw_paging_size;
+	}
+
+	/* copy the last paging block */
+	if (mvm->num_of_pages_in_last_blk > 0) {
+		memcpy(page_address(mvm->fw_paging_db[idx].fw_paging_block),
+		       image->sec[sec_idx].data + offset,
+		       FW_PAGING_SIZE * mvm->num_of_pages_in_last_blk);
+
+		IWL_DEBUG_FW(mvm,
+			     "Paging: copied %d pages in the last block %d\n",
+			     mvm->num_of_pages_in_last_blk, idx);
+	}
+
+	return 0;
+}
+
+static int iwl_alloc_fw_paging_mem(struct iwl_mvm *mvm,
+				   const struct fw_img *image)
+{
+	struct page *block;
+	dma_addr_t phys = 0;
+	int blk_idx = 0;
+	int order, num_of_pages;
+	int dma_enabled;
+
+	if (mvm->fw_paging_db[0].fw_paging_block)
+		return 0;
+
+	dma_enabled = is_device_dma_capable(mvm->trans->dev);
+
+	/* ensure BLOCK_2_EXP_SIZE is power of 2 of PAGING_BLOCK_SIZE */
+	BUILD_BUG_ON(BIT(BLOCK_2_EXP_SIZE) != PAGING_BLOCK_SIZE);
+
+	num_of_pages = image->paging_mem_size / FW_PAGING_SIZE;
+	mvm->num_of_paging_blk = ((num_of_pages - 1) /
+				    NUM_OF_PAGE_PER_GROUP) + 1;
+
+	mvm->num_of_pages_in_last_blk =
+		num_of_pages -
+		NUM_OF_PAGE_PER_GROUP * (mvm->num_of_paging_blk - 1);
+
+	IWL_DEBUG_FW(mvm,
+		     "Paging: allocating mem for %d paging blocks, each block holds 8 pages, last block holds %d pages\n",
+		     mvm->num_of_paging_blk,
+		     mvm->num_of_pages_in_last_blk);
+
+	/* allocate block of 4Kbytes for paging CSS */
+	order = get_order(FW_PAGING_SIZE);
+	block = alloc_pages(GFP_KERNEL, order);
+	if (!block) {
+		/* free all the previous pages since we failed */
+		iwl_free_fw_paging(mvm);
+		return -ENOMEM;
+	}
+
+	mvm->fw_paging_db[blk_idx].fw_paging_block = block;
+	mvm->fw_paging_db[blk_idx].fw_paging_size = FW_PAGING_SIZE;
+
+	if (dma_enabled) {
+		phys = dma_map_page(mvm->trans->dev, block, 0,
+				    PAGE_SIZE << order, DMA_BIDIRECTIONAL);
+		if (dma_mapping_error(mvm->trans->dev, phys)) {
+			/*
+			 * free the previous pages and the current one since
+			 * we failed to map_page.
+			 */
+			iwl_free_fw_paging(mvm);
+			return -ENOMEM;
+		}
+		mvm->fw_paging_db[blk_idx].fw_paging_phys = phys;
+	}
+
+	IWL_DEBUG_FW(mvm,
+		     "Paging: allocated 4K(CSS) bytes (order %d) for firmware paging.\n",
+		     order);
+
+	/*
+	 * allocate blocks in dram.
+	 * since that CSS allocated in fw_paging_db[0] loop start from index 1
+	 */
+	for (blk_idx = 1; blk_idx < mvm->num_of_paging_blk + 1; blk_idx++) {
+		/* allocate block of PAGING_BLOCK_SIZE (32K) */
+		order = get_order(PAGING_BLOCK_SIZE);
+		block = alloc_pages(GFP_KERNEL, order);
+		if (!block) {
+			/* free all the previous pages since we failed */
+			iwl_free_fw_paging(mvm);
+			return -ENOMEM;
+		}
+
+		mvm->fw_paging_db[blk_idx].fw_paging_block = block;
+		mvm->fw_paging_db[blk_idx].fw_paging_size = PAGING_BLOCK_SIZE;
+
+		if (dma_enabled) {
+			phys = dma_map_page(mvm->trans->dev, block, 0,
+					    PAGE_SIZE << order,
+					    DMA_BIDIRECTIONAL);
+			if (dma_mapping_error(mvm->trans->dev, phys)) {
+				/*
+				 * free the previous pages and the current one
+				 * since we failed to map_page.
+				 */
+				iwl_free_fw_paging(mvm);
+				return -ENOMEM;
+			}
+			mvm->fw_paging_db[blk_idx].fw_paging_phys = phys;
+		}
+
+		IWL_DEBUG_FW(mvm,
+			     "Paging: allocated 32K bytes (order %d) for firmware paging.\n",
+			     order);
+	}
+
+	return 0;
+}
+
+static int iwl_save_fw_paging(struct iwl_mvm *mvm,
+			      const struct fw_img *fw)
+{
+	int ret;
+
+	ret = iwl_alloc_fw_paging_mem(mvm, fw);
+	if (ret)
+		return ret;
+
+	return iwl_fill_paging_mem(mvm, fw);
+}
+
+/* send paging cmd to FW in case CPU2 has paging image */
+static int iwl_send_paging_cmd(struct iwl_mvm *mvm, const struct fw_img *fw)
+{
+	int blk_idx;
+	__le32 dev_phy_addr;
+	struct iwl_fw_paging_cmd fw_paging_cmd = {
+		.flags =
+			cpu_to_le32(PAGING_CMD_IS_SECURED |
+				    PAGING_CMD_IS_ENABLED |
+				    (mvm->num_of_pages_in_last_blk <<
+				    PAGING_CMD_NUM_OF_PAGES_IN_LAST_GRP_POS)),
+		.block_size = cpu_to_le32(BLOCK_2_EXP_SIZE),
+		.block_num = cpu_to_le32(mvm->num_of_paging_blk),
+	};
+
+	/* loop for for all paging blocks + CSS block */
+	for (blk_idx = 0; blk_idx < mvm->num_of_paging_blk + 1; blk_idx++) {
+		dev_phy_addr =
+			cpu_to_le32(mvm->fw_paging_db[blk_idx].fw_paging_phys >>
+				    PAGE_2_EXP_SIZE);
+		fw_paging_cmd.device_phy_addr[blk_idx] = dev_phy_addr;
+	}
+
+	return iwl_mvm_send_cmd_pdu(mvm, iwl_cmd_id(FW_PAGING_BLOCK_CMD,
+						    IWL_ALWAYS_LONG_GROUP, 0),
+				    0, sizeof(fw_paging_cmd), &fw_paging_cmd);
+}
+
 static bool iwl_alive_fn(struct iwl_notif_wait_data *notif_wait,
 			 struct iwl_rx_packet *pkt, void *data)
 {
@@ -269,6 +507,26 @@ static int iwl_mvm_load_ucode_wait_alive(struct iwl_mvm *mvm,
 	iwl_trans_fw_alive(mvm->trans, alive_data.scd_base_addr);
 
 	/*
+	 * configure and operate fw paging mechanism.
+	 * driver configures the paging flow only once, CPU2 paging image
+	 * included in the IWL_UCODE_INIT image.
+	 */
+	if (fw->paging_mem_size) {
+		ret = iwl_save_fw_paging(mvm, fw);
+		if (ret) {
+			IWL_ERR(mvm, "failed to save the FW paging image\n");
+			return ret;
+		}
+
+		ret = iwl_send_paging_cmd(mvm, fw);
+		if (ret) {
+			IWL_ERR(mvm, "failed to send the paging cmd\n");
+			iwl_free_fw_paging(mvm);
+			return ret;
+		}
+	}
+
+	/*
 	 * Note: all the queues are enabled as part of the interface
 	 * initialization, but in firmware restart scenarios they
 	 * could be stopped, so wake them up. In firmware restart,
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 95f326d..fdf401b 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -610,6 +610,11 @@ struct iwl_mvm {
 	/* NVM sections */
 	struct iwl_nvm_section nvm_sections[NVM_MAX_NUM_SECTIONS];
 
+	/* Paging section */
+	struct iwl_fw_paging fw_paging_db[NUM_OF_FW_PAGING_BLOCKS];
+	u16 num_of_paging_blk;
+	u16 num_of_pages_in_last_blk;
+
 	/* EEPROM MAC addresses */
 	struct mac_address addresses[IWL_MVM_MAX_ADDRESSES];
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index 6957d02..ef09a05 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -288,6 +288,7 @@ static const char *const iwl_mvm_cmd_strings[REPLY_MAX] = {
 	CMD(PHY_CONFIGURATION_CMD),
 	CMD(CALIB_RES_NOTIF_PHY_DB),
 	CMD(SET_CALIB_DEFAULT_CMD),
+	CMD(FW_PAGING_BLOCK_CMD),
 	CMD(ADD_STA_KEY),
 	CMD(ADD_STA),
 	CMD(REMOVE_STA),
diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index cbc29cc..8cc8f2b 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -764,8 +764,15 @@ static int iwl_pcie_load_cpu_sections_8000(struct iwl_trans *trans,
 	for (i = *first_ucode_section; i < IWL_UCODE_SECTION_MAX; i++) {
 		last_read_idx = i;
 
+		/*
+		 * CPU1_CPU2_SEPARATOR_SECTION delimiter - separate between
+		 * CPU1 to CPU2.
+		 * PAGING_SEPARATOR_SECTION delimiter - separate between
+		 * CPU2 non paged to CPU2 paging sec.
+		 */
 		if (!image->sec[i].data ||
-		    image->sec[i].offset == CPU1_CPU2_SEPARATOR_SECTION) {
+		    image->sec[i].offset == CPU1_CPU2_SEPARATOR_SECTION ||
+		    image->sec[i].offset == PAGING_SEPARATOR_SECTION) {
 			IWL_DEBUG_FW(trans,
 				     "Break since Data not valid or Empty section, sec = %d\n",
 				     i);
@@ -813,8 +820,15 @@ static int iwl_pcie_load_cpu_sections(struct iwl_trans *trans,
 	for (i = *first_ucode_section; i < IWL_UCODE_SECTION_MAX; i++) {
 		last_read_idx = i;
 
+		/*
+		 * CPU1_CPU2_SEPARATOR_SECTION delimiter - separate between
+		 * CPU1 to CPU2.
+		 * PAGING_SEPARATOR_SECTION delimiter - separate between
+		 * CPU2 non paged to CPU2 paging sec.
+		 */
 		if (!image->sec[i].data ||
-		    image->sec[i].offset == CPU1_CPU2_SEPARATOR_SECTION) {
+		    image->sec[i].offset == CPU1_CPU2_SEPARATOR_SECTION ||
+		    image->sec[i].offset == PAGING_SEPARATOR_SECTION) {
 			IWL_DEBUG_FW(trans,
 				     "Break since Data not valid or Empty section, sec = %d\n",
 				     i);
-- 
2.1.4

