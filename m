Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:34228 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144AbaGNGvP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jul 2014 02:51:15 -0400
From: Dedy Lansky <qca_dlansky@qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH 5/7] wil6210: use same mapping table for FW addr translation and debugfs
Date: Mon, 14 Jul 2014 09:49:41 +0300
Message-ID: <1405320583-5775-6-git-send-email-qca_dlansky@qca.qualcomm.com> (sfid-20140714_085121_570013_47398E24)
In-Reply-To: <1405320583-5775-1-git-send-email-qca_dlansky@qca.qualcomm.com>
References: <1405320583-5775-1-git-send-email-qca_dlansky@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>

Use single data source for all information regarding the firmware
memory map. With this change "ucode_xxx" regions disappears since
they are in fact part of larger "upper area" region

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/debugfs.c |   49 ++++++++++++----------------
 drivers/net/wireless/ath/wil6210/wil6210.h |   15 +++++---
 drivers/net/wireless/ath/wil6210/wmi.c     |   20 +++++------
 3 files changed, 39 insertions(+), 45 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index b640068..d5b095d 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -965,6 +965,26 @@ static const struct file_operations fops_sta = {
 };
 
 /*----------------*/
+static void wil6210_debugfs_init_blobs(struct wil6210_priv *wil,
+				       struct dentry *dbg)
+{
+	int i;
+	char name[32];
+
+	for (i = 0; i < ARRAY_SIZE(fw_mapping); i++) {
+		struct debugfs_blob_wrapper *blob = &wil->blobs[i];
+		const struct fw_map *map = &fw_mapping[i];
+
+		if (!map->name)
+			continue;
+
+		blob->data = (void * __force)wil->csr + HOSTADDR(map->host);
+		blob->size = map->to - map->from;
+		snprintf(name, sizeof(name), "blob_%s", map->name);
+		wil_debugfs_create_ioblob(name, S_IRUGO, dbg, blob);
+	}
+}
+
 int wil6210_debugfs_init(struct wil6210_priv *wil)
 {
 	struct dentry *dbg = wil->debug = debugfs_create_dir(WIL_NAME,
@@ -1014,34 +1034,7 @@ int wil6210_debugfs_init(struct wil6210_priv *wil)
 	debugfs_create_file("link", S_IRUGO, dbg, wil, &fops_link);
 	debugfs_create_file("info", S_IRUGO, dbg, wil, &fops_info);
 
-	wil->rgf_blob.data = (void * __force)wil->csr + 0;
-	wil->rgf_blob.size = 0xa000;
-	wil_debugfs_create_ioblob("blob_rgf", S_IRUGO, dbg, &wil->rgf_blob);
-
-	wil->fw_code_blob.data = (void * __force)wil->csr + 0x40000;
-	wil->fw_code_blob.size = 0x40000;
-	wil_debugfs_create_ioblob("blob_fw_code", S_IRUGO, dbg,
-				  &wil->fw_code_blob);
-
-	wil->fw_data_blob.data = (void * __force)wil->csr + 0x80000;
-	wil->fw_data_blob.size = 0x8000;
-	wil_debugfs_create_ioblob("blob_fw_data", S_IRUGO, dbg,
-				  &wil->fw_data_blob);
-
-	wil->fw_peri_blob.data = (void * __force)wil->csr + 0x88000;
-	wil->fw_peri_blob.size = 0x18000;
-	wil_debugfs_create_ioblob("blob_fw_peri", S_IRUGO, dbg,
-				  &wil->fw_peri_blob);
-
-	wil->uc_code_blob.data = (void * __force)wil->csr + 0xa0000;
-	wil->uc_code_blob.size = 0x10000;
-	wil_debugfs_create_ioblob("blob_uc_code", S_IRUGO, dbg,
-				  &wil->uc_code_blob);
-
-	wil->uc_data_blob.data = (void * __force)wil->csr + 0xb0000;
-	wil->uc_data_blob.size = 0x4000;
-	wil_debugfs_create_ioblob("blob_uc_data", S_IRUGO, dbg,
-				  &wil->uc_data_blob);
+	wil6210_debugfs_init_blobs(wil, dbg);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 09c36a7..02205b0 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -144,6 +144,14 @@ struct RGF_ICR {
 #define ISR_MISC_FW_ERROR	BIT_DMA_EP_MISC_ICR_FW_INT(3)
 
 /* Hardware definitions end */
+struct fw_map {
+	u32 from; /* linker address - from, inclusive */
+	u32 to;   /* linker address - to, exclusive */
+	u32 host; /* PCI/Host address - BAR0 + 0x880000 */
+	const char *name; /* for debugfs */
+};
+/* array size should be in sync with actual definition in the wmi.c */
+extern const struct fw_map fw_mapping[6];
 
 /**
  * mk_cidxtid - construct @cidxtid field
@@ -425,12 +433,7 @@ struct wil6210_priv {
 	atomic_t isr_count_rx, isr_count_tx;
 	/* debugfs */
 	struct dentry *debug;
-	struct debugfs_blob_wrapper fw_code_blob;
-	struct debugfs_blob_wrapper fw_data_blob;
-	struct debugfs_blob_wrapper fw_peri_blob;
-	struct debugfs_blob_wrapper uc_code_blob;
-	struct debugfs_blob_wrapper uc_data_blob;
-	struct debugfs_blob_wrapper rgf_blob;
+	struct debugfs_blob_wrapper blobs[ARRAY_SIZE(fw_mapping)];
 };
 
 #define wil_to_wiphy(i) (i->wdev->wiphy)
diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index a136dab..084c3de 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -65,18 +65,16 @@
 
 /**
  * @fw_mapping provides memory remapping table
+ *
+ * array size should be in sync with the declaration in the wil6210.h
  */
-static const struct {
-	u32 from; /* linker address - from, inclusive */
-	u32 to;   /* linker address - to, exclusive */
-	u32 host; /* PCI/Host address - BAR0 + 0x880000 */
-} fw_mapping[] = {
-	{0x000000, 0x040000, 0x8c0000}, /* FW code RAM 256k */
-	{0x800000, 0x808000, 0x900000}, /* FW data RAM 32k */
-	{0x840000, 0x860000, 0x908000}, /* peripheral data RAM 128k/96k used */
-	{0x880000, 0x88a000, 0x880000}, /* various RGF */
-	{0x88b000, 0x88c000, 0x88b000}, /* Pcie_ext_rgf */
-	{0x8c0000, 0x949000, 0x8c0000}, /* trivial mapping for upper area */
+const struct fw_map fw_mapping[] = {
+	{0x000000, 0x040000, 0x8c0000, "fw_code"}, /* FW code RAM      256k */
+	{0x800000, 0x808000, 0x900000, "fw_data"}, /* FW data RAM       32k */
+	{0x840000, 0x860000, 0x908000, "fw_peri"}, /* periph. data RAM 128k */
+	{0x880000, 0x88a000, 0x880000, "rgf"},     /* various RGF       40k */
+	{0x88b000, 0x88c000, 0x88b000, "rgf_ext"}, /* Pcie_ext_rgf       4k */
+	{0x8c0000, 0x949000, 0x8c0000, "upper"},   /* upper area       548k */
 	/*
 	 * 920000..930000 ucode code RAM
 	 * 930000..932000 ucode data RAM
-- 
1.7.6

