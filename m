Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:58280 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756AbaHDIWg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Aug 2014 04:22:36 -0400
From: Dedy Lansky <qca_dlansky@qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH 08/14] wil6210: convert debugfs to the table mode
Date: Mon, 4 Aug 2014 11:20:48 +0300
Message-ID: <1407140454-31639-9-git-send-email-qca_dlansky@qca.qualcomm.com> (sfid-20140804_102240_372467_39C75C8B)
In-Reply-To: <1407140454-31639-1-git-send-email-qca_dlansky@qca.qualcomm.com>
References: <1407140454-31639-1-git-send-email-qca_dlansky@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>

Define tables for similar file entries, i.e.
- table for debugfs_create_file
- table for static parameters
- table for parameters that are members of "wil" structure
- table for blobs
- table for interrupt controllers

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/debugfs.c | 263 ++++++++++++++++++++---------
 1 file changed, 181 insertions(+), 82 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index 3990a2d..d55018b 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -35,6 +35,21 @@ static u32 mem_addr;
 static u32 dbg_txdesc_index;
 static u32 dbg_vring_index; /* 24+ for Rx, 0..23 for Tx */
 
+enum dbg_off_type {
+	doff_u32 = 0,
+	doff_x32 = 1,
+	doff_ulong = 2,
+	doff_io32 = 3,
+};
+
+/* offset to "wil" */
+struct dbg_off {
+	const char *name;
+	umode_t mode;
+	ulong off;
+	enum dbg_off_type type;
+};
+
 static void wil_print_vring(struct seq_file *s, struct wil6210_priv *wil,
 			    const char *name, struct vring *vring,
 			    char _s, char _h)
@@ -250,9 +265,9 @@ DEFINE_SIMPLE_ATTRIBUTE(fops_iomem_x32, wil_debugfs_iomem_x32_get,
 static struct dentry *wil_debugfs_create_iomem_x32(const char *name,
 						   umode_t mode,
 						   struct dentry *parent,
-						   void __iomem *value)
+						   void *value)
 {
-	return debugfs_create_file(name, mode, parent, (void * __force)value,
+	return debugfs_create_file(name, mode, parent, value,
 				   &fops_iomem_x32);
 }
 
@@ -276,6 +291,49 @@ static struct dentry *wil_debugfs_create_ulong(const char *name, umode_t mode,
 	return debugfs_create_file(name, mode, parent, value, &wil_fops_ulong);
 }
 
+/**
+ * wil6210_debugfs_init_offset - create set of debugfs files
+ * @wil - driver's context, used for printing
+ * @dbg - directory on the debugfs, where files will be created
+ * @base - base address used in address calculation
+ * @tbl - table with file descriptions. Should be terminated with empty element.
+ *
+ * Creates files accordingly to the @tbl.
+ */
+static void wil6210_debugfs_init_offset(struct wil6210_priv *wil,
+					struct dentry *dbg, void *base,
+					const struct dbg_off * const tbl)
+{
+	int i;
+
+	for (i = 0; tbl[i].name; i++) {
+		struct dentry *f = NULL;
+
+		switch (tbl[i].type) {
+		case doff_u32:
+			f = debugfs_create_u32(tbl[i].name, tbl[i].mode, dbg,
+					       base + tbl[i].off);
+			break;
+		case doff_x32:
+			f = debugfs_create_x32(tbl[i].name, tbl[i].mode, dbg,
+					       base + tbl[i].off);
+			break;
+		case doff_ulong:
+			f = wil_debugfs_create_ulong(tbl[i].name, tbl[i].mode,
+						     dbg, base + tbl[i].off);
+			break;
+		case doff_io32:
+			f = wil_debugfs_create_iomem_x32(tbl[i].name,
+							 tbl[i].mode, dbg,
+							 base + tbl[i].off);
+			break;
+		}
+		if (IS_ERR_OR_NULL(f))
+			wil_err(wil, "Create file \"%s\": err %ld\n",
+				tbl[i].name, PTR_ERR(f));
+	}
+}
+
 static int wil_debugfs_itr_trsh_set(void *data, u64 val)
 {
 	struct wil6210_priv *wil = data;
@@ -310,14 +368,16 @@ static int wil_debugfs_itr_trsh_get(void *data, u64 *val)
 DEFINE_SIMPLE_ATTRIBUTE(fops_itr_trsh, wil_debugfs_itr_trsh_get,
 			wil_debugfs_itr_trsh_set, "0x%08llx\n");
 
-static struct dentry *debugfs_create_itr_trsh(const char *name,
-					      umode_t mode,
-					      struct dentry *parent,
-					      struct wil6210_priv *wil)
-{
-	return debugfs_create_file(name, mode, parent, wil, &fops_itr_trsh);
-}
-
+static const struct dbg_off isr_off[] = {
+	{"ICC", S_IRUGO | S_IWUSR, offsetof(struct RGF_ICR, ICC), doff_io32},
+	{"ICR", S_IRUGO | S_IWUSR, offsetof(struct RGF_ICR, ICR), doff_io32},
+	{"ICM", S_IRUGO | S_IWUSR, offsetof(struct RGF_ICR, ICM), doff_io32},
+	{"ICS",		  S_IWUSR, offsetof(struct RGF_ICR, ICS), doff_io32},
+	{"IMV", S_IRUGO | S_IWUSR, offsetof(struct RGF_ICR, IMV), doff_io32},
+	{"IMS",		  S_IWUSR, offsetof(struct RGF_ICR, IMS), doff_io32},
+	{"IMC",		  S_IWUSR, offsetof(struct RGF_ICR, IMC), doff_io32},
+	{},
+};
 static int wil6210_debugfs_create_ISR(struct wil6210_priv *wil,
 				      const char *name,
 				      struct dentry *parent, u32 off)
@@ -327,24 +387,19 @@ static int wil6210_debugfs_create_ISR(struct wil6210_priv *wil,
 	if (IS_ERR_OR_NULL(d))
 		return -ENODEV;
 
-	wil_debugfs_create_iomem_x32("ICC", S_IRUGO | S_IWUSR, d,
-				     wil->csr + off);
-	wil_debugfs_create_iomem_x32("ICR", S_IRUGO | S_IWUSR, d,
-				     wil->csr + off + 4);
-	wil_debugfs_create_iomem_x32("ICM", S_IRUGO | S_IWUSR, d,
-				     wil->csr + off + 8);
-	wil_debugfs_create_iomem_x32("ICS", S_IWUSR, d,
-				     wil->csr + off + 12);
-	wil_debugfs_create_iomem_x32("IMV", S_IRUGO | S_IWUSR, d,
-				     wil->csr + off + 16);
-	wil_debugfs_create_iomem_x32("IMS", S_IWUSR, d,
-				     wil->csr + off + 20);
-	wil_debugfs_create_iomem_x32("IMC", S_IWUSR, d,
-				     wil->csr + off + 24);
+	wil6210_debugfs_init_offset(wil, d, (void * __force)wil->csr + off,
+				    isr_off);
 
 	return 0;
 }
 
+static const struct dbg_off pseudo_isr_off[] = {
+	{"CAUSE",   S_IRUGO, HOSTADDR(RGF_DMA_PSEUDO_CAUSE), doff_io32},
+	{"MASK_SW", S_IRUGO, HOSTADDR(RGF_DMA_PSEUDO_CAUSE_MASK_SW), doff_io32},
+	{"MASK_FW", S_IRUGO, HOSTADDR(RGF_DMA_PSEUDO_CAUSE_MASK_FW), doff_io32},
+	{},
+};
+
 static int wil6210_debugfs_create_pseudo_ISR(struct wil6210_priv *wil,
 					     struct dentry *parent)
 {
@@ -353,16 +408,19 @@ static int wil6210_debugfs_create_pseudo_ISR(struct wil6210_priv *wil,
 	if (IS_ERR_OR_NULL(d))
 		return -ENODEV;
 
-	wil_debugfs_create_iomem_x32("CAUSE", S_IRUGO, d, wil->csr +
-				     HOSTADDR(RGF_DMA_PSEUDO_CAUSE));
-	wil_debugfs_create_iomem_x32("MASK_SW", S_IRUGO, d, wil->csr +
-				     HOSTADDR(RGF_DMA_PSEUDO_CAUSE_MASK_SW));
-	wil_debugfs_create_iomem_x32("MASK_FW", S_IRUGO, d, wil->csr +
-				     HOSTADDR(RGF_DMA_PSEUDO_CAUSE_MASK_FW));
+	wil6210_debugfs_init_offset(wil, d, (void * __force)wil->csr,
+				    pseudo_isr_off);
 
 	return 0;
 }
 
+static const struct dbg_off itr_cnt_off[] = {
+	{"TRSH", S_IRUGO | S_IWUSR, HOSTADDR(RGF_DMA_ITR_CNT_TRSH), doff_io32},
+	{"DATA", S_IRUGO | S_IWUSR, HOSTADDR(RGF_DMA_ITR_CNT_DATA), doff_io32},
+	{"CTL",  S_IRUGO | S_IWUSR, HOSTADDR(RGF_DMA_ITR_CNT_CRL), doff_io32},
+	{},
+};
+
 static int wil6210_debugfs_create_ITR_CNT(struct wil6210_priv *wil,
 					  struct dentry *parent)
 {
@@ -371,12 +429,8 @@ static int wil6210_debugfs_create_ITR_CNT(struct wil6210_priv *wil,
 	if (IS_ERR_OR_NULL(d))
 		return -ENODEV;
 
-	wil_debugfs_create_iomem_x32("TRSH", S_IRUGO | S_IWUSR, d, wil->csr +
-				     HOSTADDR(RGF_DMA_ITR_CNT_TRSH));
-	wil_debugfs_create_iomem_x32("DATA", S_IRUGO | S_IWUSR, d, wil->csr +
-				     HOSTADDR(RGF_DMA_ITR_CNT_DATA));
-	wil_debugfs_create_iomem_x32("CTL", S_IRUGO | S_IWUSR, d, wil->csr +
-				     HOSTADDR(RGF_DMA_ITR_CNT_CRL));
+	wil6210_debugfs_init_offset(wil, d, (void * __force)wil->csr,
+				    itr_cnt_off);
 
 	return 0;
 }
@@ -1033,6 +1087,88 @@ static void wil6210_debugfs_init_blobs(struct wil6210_priv *wil,
 	}
 }
 
+/* misc files */
+static const struct {
+	const char *name;
+	umode_t mode;
+	const struct file_operations *fops;
+} dbg_files[] = {
+	{"mbox",	S_IRUGO,		&fops_mbox},
+	{"vrings",	S_IRUGO,		&fops_vring},
+	{"stations",	S_IRUGO,		&fops_sta},
+	{"desc",	S_IRUGO,		&fops_txdesc},
+	{"bf",		S_IRUGO,		&fops_bf},
+	{"ssid",	S_IRUGO | S_IWUSR,	&fops_ssid},
+	{"mem_val",	S_IRUGO,		&fops_memread},
+	{"reset",		  S_IWUSR,	&fops_reset},
+	{"rxon",		  S_IWUSR,	&fops_rxon},
+	{"tx_mgmt",		  S_IWUSR,	&fops_txmgmt},
+	{"wmi_send",		  S_IWUSR,	&fops_wmi},
+	{"temp",	S_IRUGO,		&fops_temp},
+	{"freq",	S_IRUGO,		&fops_freq},
+	{"link",	S_IRUGO,		&fops_link},
+	{"info",	S_IRUGO,		&fops_info},
+	{"itr_trsh_val", S_IRUGO | S_IWUSR,	&fops_itr_trsh},
+};
+
+static void wil6210_debugfs_init_files(struct wil6210_priv *wil,
+				       struct dentry *dbg)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(dbg_files); i++)
+		debugfs_create_file(dbg_files[i].name, dbg_files[i].mode, dbg,
+				    wil, dbg_files[i].fops);
+}
+
+/* interrupt control blocks */
+static const struct {
+	const char *name;
+	u32 icr_off;
+} dbg_icr[] = {
+	{"USER_ICR",		HOSTADDR(RGF_USER_USER_ICR)},
+	{"DMA_EP_TX_ICR",	HOSTADDR(RGF_DMA_EP_TX_ICR)},
+	{"DMA_EP_RX_ICR",	HOSTADDR(RGF_DMA_EP_RX_ICR)},
+	{"DMA_EP_MISC_ICR",	HOSTADDR(RGF_DMA_EP_MISC_ICR)},
+};
+
+static void wil6210_debugfs_init_isr(struct wil6210_priv *wil,
+				     struct dentry *dbg)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(dbg_icr); i++)
+		wil6210_debugfs_create_ISR(wil, dbg_icr[i].name, dbg,
+					   dbg_icr[i].icr_off);
+}
+
+#define WIL_FIELD(name, mode, type) { __stringify(name), mode, \
+	offsetof(struct wil6210_priv, name), type}
+
+/* fields in struct wil6210_priv */
+static const struct dbg_off dbg_wil_off[] = {
+	WIL_FIELD(secure_pcp,	S_IRUGO | S_IWUSR,	doff_u32),
+	WIL_FIELD(status,	S_IRUGO | S_IWUSR,	doff_ulong),
+	WIL_FIELD(fw_version,	S_IRUGO,		doff_u32),
+	WIL_FIELD(hw_version,	S_IRUGO,		doff_x32),
+	{},
+};
+
+static const struct dbg_off dbg_wil_regs[] = {
+	{"RGF_MAC_MTRL_COUNTER_0", S_IRUGO, HOSTADDR(RGF_MAC_MTRL_COUNTER_0),
+		doff_io32},
+	{"RGF_USER_USAGE_1", S_IRUGO, HOSTADDR(RGF_USER_USAGE_1), doff_io32},
+	{},
+};
+
+/* static parameters */
+static const struct dbg_off dbg_statics[] = {
+	{"desc_index",	S_IRUGO | S_IWUSR, (ulong)&dbg_txdesc_index, doff_u32},
+	{"vring_index",	S_IRUGO | S_IWUSR, (ulong)&dbg_vring_index, doff_u32},
+	{"mem_addr",	S_IRUGO | S_IWUSR, (ulong)&mem_addr, doff_u32},
+	{},
+};
+
 int wil6210_debugfs_init(struct wil6210_priv *wil)
 {
 	struct dentry *dbg = wil->debug = debugfs_create_dir(WIL_NAME,
@@ -1041,54 +1177,17 @@ int wil6210_debugfs_init(struct wil6210_priv *wil)
 	if (IS_ERR_OR_NULL(dbg))
 		return -ENODEV;
 
-	debugfs_create_file("mbox", S_IRUGO, dbg, wil, &fops_mbox);
-	debugfs_create_file("vrings", S_IRUGO, dbg, wil, &fops_vring);
-	debugfs_create_file("stations", S_IRUGO, dbg, wil, &fops_sta);
-	debugfs_create_file("desc", S_IRUGO, dbg, wil, &fops_txdesc);
-	debugfs_create_u32("desc_index", S_IRUGO | S_IWUSR, dbg,
-			   &dbg_txdesc_index);
-	debugfs_create_u32("vring_index", S_IRUGO | S_IWUSR, dbg,
-			   &dbg_vring_index);
-
-	debugfs_create_file("bf", S_IRUGO, dbg, wil, &fops_bf);
-	debugfs_create_file("ssid", S_IRUGO | S_IWUSR, dbg, wil, &fops_ssid);
-	debugfs_create_u32("secure_pcp", S_IRUGO | S_IWUSR, dbg,
-			   &wil->secure_pcp);
-	wil_debugfs_create_ulong("status", S_IRUGO | S_IWUSR, dbg,
-				 &wil->status);
-	debugfs_create_u32("fw_version", S_IRUGO, dbg, &wil->fw_version);
-	debugfs_create_x32("hw_version", S_IRUGO, dbg, &wil->hw_version);
-
-	wil6210_debugfs_create_ISR(wil, "USER_ICR", dbg,
-				   HOSTADDR(RGF_USER_USER_ICR));
-	wil6210_debugfs_create_ISR(wil, "DMA_EP_TX_ICR", dbg,
-				   HOSTADDR(RGF_DMA_EP_TX_ICR));
-	wil6210_debugfs_create_ISR(wil, "DMA_EP_RX_ICR", dbg,
-				   HOSTADDR(RGF_DMA_EP_RX_ICR));
-	wil6210_debugfs_create_ISR(wil, "DMA_EP_MISC_ICR", dbg,
-				   HOSTADDR(RGF_DMA_EP_MISC_ICR));
+	wil6210_debugfs_init_files(wil, dbg);
+	wil6210_debugfs_init_isr(wil, dbg);
+	wil6210_debugfs_init_blobs(wil, dbg);
+	wil6210_debugfs_init_offset(wil, dbg, wil, dbg_wil_off);
+	wil6210_debugfs_init_offset(wil, dbg, (void * __force)wil->csr,
+				    dbg_wil_regs);
+	wil6210_debugfs_init_offset(wil, dbg, NULL, dbg_statics);
+
 	wil6210_debugfs_create_pseudo_ISR(wil, dbg);
-	wil6210_debugfs_create_ITR_CNT(wil, dbg);
-	wil_debugfs_create_iomem_x32("MAC_MTRL_COUNTER_0", S_IRUGO, dbg,
-				     wil->csr +
-				     HOSTADDR(RGF_MAC_MTRL_COUNTER_0));
-	debugfs_create_itr_trsh("itr_trsh_val", S_IRUGO | S_IWUSR, dbg, wil);
-	wil_debugfs_create_iomem_x32("RGF_USER_USAGE_1", S_IRUGO, dbg,
-				     wil->csr +
-				     HOSTADDR(RGF_USER_USAGE_1));
-	debugfs_create_u32("mem_addr", S_IRUGO | S_IWUSR, dbg, &mem_addr);
-	debugfs_create_file("mem_val", S_IRUGO, dbg, wil, &fops_memread);
-
-	debugfs_create_file("reset", S_IWUSR, dbg, wil, &fops_reset);
-	debugfs_create_file("rxon", S_IWUSR, dbg, wil, &fops_rxon);
-	debugfs_create_file("tx_mgmt", S_IWUSR, dbg, wil, &fops_txmgmt);
-	debugfs_create_file("wmi_send", S_IWUSR, dbg, wil, &fops_wmi);
-	debugfs_create_file("temp", S_IRUGO, dbg, wil, &fops_temp);
-	debugfs_create_file("freq", S_IRUGO, dbg, wil, &fops_freq);
-	debugfs_create_file("link", S_IRUGO, dbg, wil, &fops_link);
-	debugfs_create_file("info", S_IRUGO, dbg, wil, &fops_info);
 
-	wil6210_debugfs_init_blobs(wil, dbg);
+	wil6210_debugfs_create_ITR_CNT(wil, dbg);
 
 	return 0;
 }
-- 
1.8.5.2

