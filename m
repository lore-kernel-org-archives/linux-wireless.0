Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:47422 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S933572AbcJ0JNm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Oct 2016 05:13:42 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        <rajatja@google.com>, <briannorris@google.com>,
        <dmitry.torokhov@gmail.com>, Xinming Hu <huxm@marvell.com>,
        Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH v2 4/5] mwifiex: get rid of drv_info* adapter variables
Date: Thu, 27 Oct 2016 14:42:42 +0530
Message-ID: <1477559563-18328-4-git-send-email-akarwar@marvell.com> (sfid-20161027_111347_510388_B1EA4EE1)
In-Reply-To: <1477559563-18328-1-git-send-email-akarwar@marvell.com>
References: <1477559563-18328-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Xinming Hu <huxm@marvell.com>

We can avoid drv_info_dump and drv_info_size adapter variables.
This info can be passed to mwifiex_upload_device_dump() as parameters

Signed-off-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
v2: This patch is introduced in v2. 
Also, I have dropped "v1 4/5 mwifiex: firmware dump code rearrangement
in pcie.c" patch in this series to avoid rebase efforts for other patches
from Rajat/Brian in queue. I will submit this later.
---
 drivers/net/wireless/marvell/mwifiex/main.c | 42 ++++++++++++-----------------
 drivers/net/wireless/marvell/mwifiex/main.h |  7 +++--
 drivers/net/wireless/marvell/mwifiex/pcie.c |  7 +++--
 drivers/net/wireless/marvell/mwifiex/sdio.c |  6 +++--
 4 files changed, 29 insertions(+), 33 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/main.c b/drivers/net/wireless/marvell/mwifiex/main.c
index 3b31ea2..158305f 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.c
+++ b/drivers/net/wireless/marvell/mwifiex/main.c
@@ -1031,7 +1031,7 @@ void mwifiex_multi_chan_resync(struct mwifiex_adapter *adapter)
 }
 EXPORT_SYMBOL_GPL(mwifiex_multi_chan_resync);
 
-void mwifiex_drv_info_dump(struct mwifiex_adapter *adapter)
+int mwifiex_drv_info_dump(struct mwifiex_adapter *adapter, void **drv_info)
 {
 	void *p;
 	char drv_version[64];
@@ -1041,21 +1041,17 @@ void mwifiex_drv_info_dump(struct mwifiex_adapter *adapter)
 	int i, idx;
 	struct netdev_queue *txq;
 	struct mwifiex_debug_info *debug_info;
-
-	if (adapter->drv_info_dump) {
-		vfree(adapter->drv_info_dump);
-		adapter->drv_info_dump = NULL;
-		adapter->drv_info_size = 0;
-	}
+	void *drv_info_dump;
 
 	mwifiex_dbg(adapter, MSG, "===mwifiex driverinfo dump start===\n");
 
-	adapter->drv_info_dump = vzalloc(MWIFIEX_DRV_INFO_SIZE_MAX);
+	/* memory allocate here should be free in mwifiex_upload_device_dump*/
+	drv_info_dump = vzalloc(MWIFIEX_DRV_INFO_SIZE_MAX);
 
-	if (!adapter->drv_info_dump)
-		return;
+	if (!drv_info_dump)
+		return 0;
 
-	p = (char *)(adapter->drv_info_dump);
+	p = (char *)(drv_info_dump);
 	p += sprintf(p, "driver_name = " "\"mwifiex\"\n");
 
 	mwifiex_drv_get_driver_version(adapter, drv_version,
@@ -1139,18 +1135,20 @@ void mwifiex_drv_info_dump(struct mwifiex_adapter *adapter)
 		kfree(debug_info);
 	}
 
-	adapter->drv_info_size = p - adapter->drv_info_dump;
 	mwifiex_dbg(adapter, MSG, "===mwifiex driverinfo dump end===\n");
+	*drv_info = drv_info_dump;
+	return p - drv_info_dump;
 }
 EXPORT_SYMBOL_GPL(mwifiex_drv_info_dump);
 
-void mwifiex_upload_device_dump(struct mwifiex_adapter *adapter)
+void mwifiex_upload_device_dump(struct mwifiex_adapter *adapter, void *drv_info,
+				int drv_info_size)
 {
 	u8 idx, *dump_data, *fw_dump_ptr;
 	u32 dump_len;
 
 	dump_len = (strlen("========Start dump driverinfo========\n") +
-		       adapter->drv_info_size +
+		       drv_info_size +
 		       strlen("\n========End dump========\n"));
 
 	for (idx = 0; idx < adapter->num_mem_types; idx++) {
@@ -1180,8 +1178,8 @@ void mwifiex_upload_device_dump(struct mwifiex_adapter *adapter)
 
 	strcpy(fw_dump_ptr, "========Start dump driverinfo========\n");
 	fw_dump_ptr += strlen("========Start dump driverinfo========\n");
-	memcpy(fw_dump_ptr, adapter->drv_info_dump, adapter->drv_info_size);
-	fw_dump_ptr += adapter->drv_info_size;
+	memcpy(fw_dump_ptr, drv_info, drv_info_size);
+	fw_dump_ptr += drv_info_size;
 	strcpy(fw_dump_ptr, "\n========End dump========\n");
 	fw_dump_ptr += strlen("\n========End dump========\n");
 
@@ -1219,18 +1217,12 @@ done:
 		struct memory_type_mapping *entry =
 			&adapter->mem_type_mapping_tbl[idx];
 
-		if (entry->mem_ptr) {
-			vfree(entry->mem_ptr);
-			entry->mem_ptr = NULL;
-		}
+		vfree(entry->mem_ptr);
+		entry->mem_ptr = NULL;
 		entry->mem_size = 0;
 	}
 
-	if (adapter->drv_info_dump) {
-		vfree(adapter->drv_info_dump);
-		adapter->drv_info_dump = NULL;
-		adapter->drv_info_size = 0;
-	}
+	vfree(drv_info);
 }
 EXPORT_SYMBOL_GPL(mwifiex_upload_device_dump);
 
diff --git a/drivers/net/wireless/marvell/mwifiex/main.h b/drivers/net/wireless/marvell/mwifiex/main.h
index d61fe3a..a4aca45 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.h
+++ b/drivers/net/wireless/marvell/mwifiex/main.h
@@ -990,8 +990,6 @@ struct mwifiex_adapter {
 	u8 key_api_major_ver, key_api_minor_ver;
 	struct memory_type_mapping *mem_type_mapping_tbl;
 	u8 num_mem_types;
-	void *drv_info_dump;
-	u32 drv_info_size;
 	bool scan_chan_gap_enabled;
 	struct sk_buff_head rx_data_q;
 	bool mfg_mode;
@@ -1606,8 +1604,9 @@ void mwifiex_hist_data_add(struct mwifiex_private *priv,
 u8 mwifiex_adjust_data_rate(struct mwifiex_private *priv,
 			    u8 rx_rate, u8 ht_info);
 
-void mwifiex_drv_info_dump(struct mwifiex_adapter *adapter);
-void mwifiex_upload_device_dump(struct mwifiex_adapter *adapter);
+int mwifiex_drv_info_dump(struct mwifiex_adapter *adapter, void **drv_info);
+void mwifiex_upload_device_dump(struct mwifiex_adapter *adapter, void *drv_info,
+				int drv_info_size);
 void *mwifiex_alloc_dma_align_buf(int rx_len, gfp_t flags);
 void mwifiex_queue_main_work(struct mwifiex_adapter *adapter);
 int mwifiex_get_wakeup_reason(struct mwifiex_private *priv, u16 action,
diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index 9147e6a..9025af7 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -2699,9 +2699,12 @@ static void mwifiex_pcie_fw_dump(struct mwifiex_adapter *adapter)
 
 static void mwifiex_pcie_device_dump_work(struct mwifiex_adapter *adapter)
 {
-	mwifiex_drv_info_dump(adapter);
+	int drv_info_size;
+	void *drv_info;
+
+	drv_info_size = mwifiex_drv_info_dump(adapter, &drv_info);
 	mwifiex_pcie_fw_dump(adapter);
-	mwifiex_upload_device_dump(adapter);
+	mwifiex_upload_device_dump(adapter, drv_info, drv_info_size);
 }
 
 static unsigned long iface_work_flags;
diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.c b/drivers/net/wireless/marvell/mwifiex/sdio.c
index 4cad1c2..241d2b3 100644
--- a/drivers/net/wireless/marvell/mwifiex/sdio.c
+++ b/drivers/net/wireless/marvell/mwifiex/sdio.c
@@ -2602,13 +2602,15 @@ done:
 static void mwifiex_sdio_device_dump_work(struct mwifiex_adapter *adapter)
 {
 	struct sdio_mmc_card *card = adapter->card;
+	int drv_info_size;
+	void *drv_info;
 
-	mwifiex_drv_info_dump(adapter);
+	drv_info_size = mwifiex_drv_info_dump(adapter, &drv_info);
 	if (card->fw_dump_enh)
 		mwifiex_sdio_generic_fw_dump(adapter);
 	else
 		mwifiex_sdio_fw_dump(adapter);
-	mwifiex_upload_device_dump(adapter);
+	mwifiex_upload_device_dump(adapter, drv_info, drv_info_size);
 }
 
 static void mwifiex_sdio_work(struct work_struct *work)
-- 
1.9.1
