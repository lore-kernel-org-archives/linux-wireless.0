Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:15911 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752108AbbHRH6H (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Aug 2015 03:58:07 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Matti Gottlieb <matti.gottlieb@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 10/26] iwlwifi: mvm: Add FW paging mechanism for the UMAC on SDIO
Date: Tue, 18 Aug 2015 10:57:20 +0300
Message-Id: <1439884656-18146-10-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150818_100109_494873_9D053D70)
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

When the device is slave on the bus(SDIO) the driver saves the UMAC's
image pages in blocks of 32K in the DRAM and sends the layout of the
pages to the FW. When the FW wants load / unload pages, it creates an
interrupt,	and the driver uploads / downloads the page to an address in
the a specific address on the device's memory.

The driver can support up to 1 MB of pages.

Add paging mechanism for the UMAC on SDIO in order to allow the program to
use a larger virtual space while using less physical memory on the device
itself.

Signed-off-by: Matti Gottlieb <matti.gottlieb@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-csr.h    |  2 +
 drivers/net/wireless/iwlwifi/iwl-fw.h     |  3 ++
 drivers/net/wireless/iwlwifi/iwl-prph.h   |  6 +++
 drivers/net/wireless/iwlwifi/iwl-trans.h  | 14 ++++++
 drivers/net/wireless/iwlwifi/mvm/fw-api.h | 26 +++++++++++
 drivers/net/wireless/iwlwifi/mvm/fw.c     | 76 +++++++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/mvm/ops.c    |  1 +
 7 files changed, 128 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/iwl-csr.h b/drivers/net/wireless/iwlwifi/iwl-csr.h
index fa71661..543abea 100644
--- a/drivers/net/wireless/iwlwifi/iwl-csr.h
+++ b/drivers/net/wireless/iwlwifi/iwl-csr.h
@@ -200,6 +200,7 @@
 #define CSR_INT_BIT_FH_TX        (1 << 27) /* Tx DMA FH_INT[1:0] */
 #define CSR_INT_BIT_SCD          (1 << 26) /* TXQ pointer advanced */
 #define CSR_INT_BIT_SW_ERR       (1 << 25) /* uCode error */
+#define CSR_INT_BIT_PAGING       (1 << 24) /* SDIO PAGING */
 #define CSR_INT_BIT_RF_KILL      (1 << 7)  /* HW RFKILL switch GP_CNTRL[27] toggled */
 #define CSR_INT_BIT_CT_KILL      (1 << 6)  /* Critical temp (chip too hot) rfkill */
 #define CSR_INT_BIT_SW_RX        (1 << 3)  /* Rx, command responses */
@@ -210,6 +211,7 @@
 				 CSR_INT_BIT_HW_ERR  | \
 				 CSR_INT_BIT_FH_TX   | \
 				 CSR_INT_BIT_SW_ERR  | \
+				 CSR_INT_BIT_PAGING  | \
 				 CSR_INT_BIT_RF_KILL | \
 				 CSR_INT_BIT_SW_RX   | \
 				 CSR_INT_BIT_WAKEUP  | \
diff --git a/drivers/net/wireless/iwlwifi/iwl-fw.h b/drivers/net/wireless/iwlwifi/iwl-fw.h
index 0d9d6f5..45e7321 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw.h
@@ -163,6 +163,9 @@ struct iwl_sf_region {
 /* maximum image size 1024KB */
 #define MAX_PAGING_IMAGE_SIZE (NUM_OF_BLOCK_PER_IMAGE * PAGING_BLOCK_SIZE)
 
+/* Virtual address signature */
+#define PAGING_ADDR_SIG 0xAA000000
+
 #define PAGING_CMD_IS_SECURED BIT(9)
 #define PAGING_CMD_IS_ENABLED BIT(8)
 #define PAGING_CMD_NUM_OF_PAGES_IN_LAST_GRP_POS	0
diff --git a/drivers/net/wireless/iwlwifi/iwl-prph.h b/drivers/net/wireless/iwlwifi/iwl-prph.h
index c4e7a71..3ab777f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-prph.h
+++ b/drivers/net/wireless/iwlwifi/iwl-prph.h
@@ -392,4 +392,10 @@ enum {
 	LMPM_CHICK_EXTENDED_ADDR_SPACE = BIT(0),
 };
 
+/* FW chicken bits */
+#define LMPM_PAGE_PASS_NOTIF			0xA03824
+enum {
+	LMPM_PAGE_PASS_NOTIF_POS = BIT(20),
+};
+
 #endif				/* __iwl_prph_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 151e3de..9d8b5cb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -668,6 +668,12 @@ enum iwl_d0i3_mode {
  * @dbg_conf_tlv: array of pointers to configuration TLVs for debug
  * @dbg_trigger_tlv: array of pointers to triggers TLVs for debug
  * @dbg_dest_reg_num: num of reg_ops in %dbg_dest_tlv
+ * @paging_req_addr: The location were the FW will upload / download the pages
+ *	from. The address is set by the opmode
+ * @paging_db: Pointer to the opmode paging data base, the pointer is set by
+ *	the opmode.
+ * @paging_download_buf: Buffer used for copying all of the pages before
+ *	downloading them to the FW. The buffer is allocated in the opmode
  */
 struct iwl_trans {
 	const struct iwl_trans_ops *ops;
@@ -705,6 +711,14 @@ struct iwl_trans {
 	struct iwl_fw_dbg_trigger_tlv * const *dbg_trigger_tlv;
 	u8 dbg_dest_reg_num;
 
+	/*
+	 * Paging parameters - All of the parameters should be set by the
+	 * opmode when paging is enabled
+	 */
+	u32 paging_req_addr;
+	struct iwl_fw_paging *paging_db;
+	void *paging_download_buf;
+
 	enum iwl_d0i3_mode d0i3_mode;
 
 	bool wowlan_d0i3;
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api.h b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
index 9c6b153..4af7513a 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
@@ -120,6 +120,9 @@ enum {
 	ADD_STA = 0x18,
 	REMOVE_STA = 0x19,
 
+	/* paging get item */
+	FW_GET_ITEM_CMD = 0x1a,
+
 	/* TX */
 	TX_CMD = 0x1c,
 	TXPATH_FLUSH = 0x1e,
@@ -394,6 +397,29 @@ struct iwl_fw_paging_cmd {
 	__le32 device_phy_addr[NUM_OF_FW_PAGING_BLOCKS];
 } __packed; /* FW_PAGING_BLOCK_CMD_API_S_VER_1 */
 
+/*
+ * Fw items ID's
+ *
+ * @IWL_FW_ITEM_ID_PAGING: Address of the pages that the FW will upload
+ *	download
+ */
+enum iwl_fw_item_id {
+	IWL_FW_ITEM_ID_PAGING = 3,
+};
+
+/*
+ * struct iwl_fw_get_item_cmd - get an item from the fw
+ */
+struct iwl_fw_get_item_cmd {
+	__le32 item_id;
+} __packed; /* FW_GET_ITEM_CMD_API_S_VER_1 */
+
+struct iwl_fw_get_item_resp {
+	__le32 item_id;
+	__le32 item_byte_cnt;
+	__le32 item_val;
+} __packed; /* FW_GET_ITEM_RSP_S_VER_1 */
+
 /**
  * struct iwl_nvm_access_resp_ver2 - response to NVM_ACCESS_CMD
  * @offset: offset in bytes into the section
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw.c b/drivers/net/wireless/iwlwifi/mvm/fw.c
index aff5bbf..4a0ce83 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/iwlwifi/mvm/fw.c
@@ -125,6 +125,7 @@ static void iwl_free_fw_paging(struct iwl_mvm *mvm)
 		__free_pages(mvm->fw_paging_db[i].fw_paging_block,
 			     get_order(mvm->fw_paging_db[i].fw_paging_size));
 	}
+	kfree(mvm->trans->paging_download_buf);
 	memset(mvm->fw_paging_db, 0, sizeof(mvm->fw_paging_db));
 }
 
@@ -258,6 +259,9 @@ static int iwl_alloc_fw_paging_mem(struct iwl_mvm *mvm,
 			return -ENOMEM;
 		}
 		mvm->fw_paging_db[blk_idx].fw_paging_phys = phys;
+	} else {
+		mvm->fw_paging_db[blk_idx].fw_paging_phys = PAGING_ADDR_SIG |
+			blk_idx << BLOCK_2_EXP_SIZE;
 	}
 
 	IWL_DEBUG_FW(mvm,
@@ -294,6 +298,10 @@ static int iwl_alloc_fw_paging_mem(struct iwl_mvm *mvm,
 				return -ENOMEM;
 			}
 			mvm->fw_paging_db[blk_idx].fw_paging_phys = phys;
+		} else {
+			mvm->fw_paging_db[blk_idx].fw_paging_phys =
+				PAGING_ADDR_SIG |
+				blk_idx << BLOCK_2_EXP_SIZE;
 		}
 
 		IWL_DEBUG_FW(mvm,
@@ -344,6 +352,60 @@ static int iwl_send_paging_cmd(struct iwl_mvm *mvm, const struct fw_img *fw)
 				    0, sizeof(fw_paging_cmd), &fw_paging_cmd);
 }
 
+/*
+ * Send paging item cmd to FW in case CPU2 has paging image
+ */
+static int iwl_trans_get_paging_item(struct iwl_mvm *mvm)
+{
+	int ret;
+	struct iwl_fw_get_item_cmd fw_get_item_cmd = {
+		.item_id = cpu_to_le32(IWL_FW_ITEM_ID_PAGING),
+	};
+
+	struct iwl_fw_get_item_resp *item_resp;
+	struct iwl_host_cmd cmd = {
+		.id = iwl_cmd_id(FW_GET_ITEM_CMD, IWL_ALWAYS_LONG_GROUP, 0),
+		.flags = CMD_WANT_SKB | CMD_SEND_IN_RFKILL,
+		.data = { &fw_get_item_cmd, },
+	};
+
+	cmd.len[0] = sizeof(struct iwl_fw_get_item_cmd);
+
+	ret = iwl_mvm_send_cmd(mvm, &cmd);
+	if (ret) {
+		IWL_ERR(mvm,
+			"Paging: Failed to send FW_GET_ITEM_CMD cmd (err = %d)\n",
+			ret);
+		return ret;
+	}
+
+	item_resp = (void *)((struct iwl_rx_packet *)cmd.resp_pkt)->data;
+	if (item_resp->item_id != cpu_to_le32(IWL_FW_ITEM_ID_PAGING)) {
+		IWL_ERR(mvm,
+			"Paging: got wrong item in FW_GET_ITEM_CMD resp (item_id = %u)\n",
+			le32_to_cpu(item_resp->item_id));
+		ret = -EIO;
+		goto exit;
+	}
+
+	mvm->trans->paging_download_buf = kzalloc(MAX_PAGING_IMAGE_SIZE,
+						  GFP_KERNEL);
+	if (!mvm->trans->paging_download_buf) {
+		ret = -ENOMEM;
+		goto exit;
+	}
+	mvm->trans->paging_req_addr = le32_to_cpu(item_resp->item_val);
+	mvm->trans->paging_db = mvm->fw_paging_db;
+	IWL_DEBUG_FW(mvm,
+		     "Paging: got paging request address (paging_req_addr 0x%08x)\n",
+		     mvm->trans->paging_req_addr);
+
+exit:
+	iwl_free_resp(&cmd);
+
+	return ret;
+}
+
 static bool iwl_alive_fn(struct iwl_notif_wait_data *notif_wait,
 			 struct iwl_rx_packet *pkt, void *data)
 {
@@ -517,6 +579,20 @@ static int iwl_mvm_load_ucode_wait_alive(struct iwl_mvm *mvm,
 	 * included in the IWL_UCODE_INIT image.
 	 */
 	if (fw->paging_mem_size) {
+		/*
+		 * When dma is not enabled, the driver needs to copy / write
+		 * the downloaded / uploaded page to / from the smem.
+		 * This gets the location of the place were the pages are
+		 * stored.
+		 */
+		if (!is_device_dma_capable(mvm->trans->dev)) {
+			ret = iwl_trans_get_paging_item(mvm);
+			if (ret) {
+				IWL_ERR(mvm, "failed to get FW paging item\n");
+				return ret;
+			}
+		}
+
 		ret = iwl_save_fw_paging(mvm, fw);
 		if (ret) {
 			IWL_ERR(mvm, "failed to save the FW paging image\n");
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index 4873112..5d577c1 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -291,6 +291,7 @@ static const char *const iwl_mvm_cmd_strings[REPLY_MAX] = {
 	CMD(FW_PAGING_BLOCK_CMD),
 	CMD(ADD_STA_KEY),
 	CMD(ADD_STA),
+	CMD(FW_GET_ITEM_CMD),
 	CMD(REMOVE_STA),
 	CMD(LQ_CMD),
 	CMD(SCAN_OFFLOAD_CONFIG_CMD),
-- 
2.1.4

