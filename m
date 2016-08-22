Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:41080 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753952AbcHVJna (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Aug 2016 05:43:30 -0400
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Lior David <qca_liord@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com,
        Maya Erez <qca_merez@qca.qualcomm.com>
Subject: [PATCH 3/4] wil6210: extract firmware capabilities from FW file
Date: Mon, 22 Aug 2016 12:42:21 +0300
Message-Id: <1471858942-23766-4-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20160822_114345_421529_179B54F7)
In-Reply-To: <1471858942-23766-1-git-send-email-qca_merez@qca.qualcomm.com>
References: <1471858942-23766-1-git-send-email-qca_merez@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Lior David <qca_liord@qca.qualcomm.com>

When driver is loaded, extract a capabilities record
from the FW file. This record contains bits indicating
which optional features are supported by this FW.
The driver can use this information to determine
which functionality to support and/or expose to user
space.
The extraction is done before wiphy structure is
registered, because the capabilities can affect
information published by the this structure.

Signed-off-by: Lior David <qca_liord@qca.qualcomm.com>
Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/debugfs.c  | 25 +++++++++
 drivers/net/wireless/ath/wil6210/fw.h       | 11 +++-
 drivers/net/wireless/ath/wil6210/fw_inc.c   | 85 +++++++++++++++++++++--------
 drivers/net/wireless/ath/wil6210/main.c     |  4 +-
 drivers/net/wireless/ath/wil6210/pcie_bus.c |  4 ++
 drivers/net/wireless/ath/wil6210/wil6210.h  |  4 +-
 6 files changed, 106 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index a8098b4..a244a36 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -1553,6 +1553,30 @@ static const struct file_operations fops_led_blink_time = {
 	.open  = simple_open,
 };
 
+/*---------FW capabilities------------*/
+static int wil_fw_capabilities_debugfs_show(struct seq_file *s, void *data)
+{
+	struct wil6210_priv *wil = s->private;
+
+	seq_printf(s, "fw_capabilities : %*pb\n", WMI_FW_CAPABILITY_MAX,
+		   wil->fw_capabilities);
+
+	return 0;
+}
+
+static int wil_fw_capabilities_seq_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, wil_fw_capabilities_debugfs_show,
+			   inode->i_private);
+}
+
+static const struct file_operations fops_fw_capabilities = {
+	.open		= wil_fw_capabilities_seq_open,
+	.release	= single_release,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+};
+
 /*----------------*/
 static void wil6210_debugfs_init_blobs(struct wil6210_priv *wil,
 				       struct dentry *dbg)
@@ -1603,6 +1627,7 @@ static const struct {
 	{"recovery",	S_IRUGO | S_IWUSR,	&fops_recovery},
 	{"led_cfg",	S_IRUGO | S_IWUSR,	&fops_led_cfg},
 	{"led_blink_time",	S_IRUGO | S_IWUSR,	&fops_led_blink_time},
+	{"fw_capabilities",	S_IRUGO,	&fops_fw_capabilities},
 };
 
 static void wil6210_debugfs_init_files(struct wil6210_priv *wil,
diff --git a/drivers/net/wireless/ath/wil6210/fw.h b/drivers/net/wireless/ath/wil6210/fw.h
index 7a2c6c1..c3191c6 100644
--- a/drivers/net/wireless/ath/wil6210/fw.h
+++ b/drivers/net/wireless/ath/wil6210/fw.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2014 Qualcomm Atheros, Inc.
+ * Copyright (c) 2014,2016 Qualcomm Atheros, Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
@@ -58,6 +58,15 @@ struct wil_fw_record_comment { /* type == wil_fw_type_comment */
 	u8 data[0]; /* free-form data [data_size], see above */
 } __packed;
 
+/* FW capabilities encoded inside a comment record */
+#define WIL_FW_CAPABILITIES_MAGIC (0xabcddcba)
+struct wil_fw_record_capabilities { /* type == wil_fw_type_comment */
+	/* identifies capabilities record */
+	__le32 magic;
+	/* capabilities (variable size), see enum wmi_fw_capability */
+	u8 capabilities[0];
+};
+
 /* perform action
  * data_size = @head.size - offsetof(struct wil_fw_record_action, data)
  */
diff --git a/drivers/net/wireless/ath/wil6210/fw_inc.c b/drivers/net/wireless/ath/wil6210/fw_inc.c
index d30657e..3860238 100644
--- a/drivers/net/wireless/ath/wil6210/fw_inc.c
+++ b/drivers/net/wireless/ath/wil6210/fw_inc.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2014-2015 Qualcomm Atheros, Inc.
+ * Copyright (c) 2014-2016 Qualcomm Atheros, Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
@@ -118,6 +118,12 @@ static int wil_fw_verify(struct wil6210_priv *wil, const u8 *data, size_t size)
 	return (int)dlen;
 }
 
+static int fw_ignore_section(struct wil6210_priv *wil, const void *data,
+			     size_t size)
+{
+	return 0;
+}
+
 static int fw_handle_comment(struct wil6210_priv *wil, const void *data,
 			     size_t size)
 {
@@ -126,6 +132,27 @@ static int fw_handle_comment(struct wil6210_priv *wil, const void *data,
 	return 0;
 }
 
+static int
+fw_handle_capabilities(struct wil6210_priv *wil, const void *data,
+		       size_t size)
+{
+	const struct wil_fw_record_capabilities *rec = data;
+	size_t capa_size;
+
+	if (size < sizeof(*rec) ||
+	    le32_to_cpu(rec->magic) != WIL_FW_CAPABILITIES_MAGIC)
+		return 0;
+
+	capa_size = size - offsetof(struct wil_fw_record_capabilities,
+				    capabilities);
+	bitmap_zero(wil->fw_capabilities, WMI_FW_CAPABILITY_MAX);
+	memcpy(wil->fw_capabilities, rec->capabilities,
+	       min(sizeof(wil->fw_capabilities), capa_size));
+	wil_hex_dump_fw("CAPA", DUMP_PREFIX_OFFSET, 16, 1,
+			rec->capabilities, capa_size, false);
+	return 0;
+}
+
 static int fw_handle_data(struct wil6210_priv *wil, const void *data,
 			  size_t size)
 {
@@ -383,42 +410,51 @@ static int fw_handle_gateway_data4(struct wil6210_priv *wil, const void *data,
 
 static const struct {
 	int type;
-	int (*handler)(struct wil6210_priv *wil, const void *data, size_t size);
+	int (*load_handler)(struct wil6210_priv *wil, const void *data,
+			    size_t size);
+	int (*parse_handler)(struct wil6210_priv *wil, const void *data,
+			     size_t size);
 } wil_fw_handlers[] = {
-	{wil_fw_type_comment, fw_handle_comment},
-	{wil_fw_type_data, fw_handle_data},
-	{wil_fw_type_fill, fw_handle_fill},
+	{wil_fw_type_comment, fw_handle_comment, fw_handle_capabilities},
+	{wil_fw_type_data, fw_handle_data, fw_ignore_section},
+	{wil_fw_type_fill, fw_handle_fill, fw_ignore_section},
 	/* wil_fw_type_action */
 	/* wil_fw_type_verify */
-	{wil_fw_type_file_header, fw_handle_file_header},
-	{wil_fw_type_direct_write, fw_handle_direct_write},
-	{wil_fw_type_gateway_data, fw_handle_gateway_data},
-	{wil_fw_type_gateway_data4, fw_handle_gateway_data4},
+	{wil_fw_type_file_header, fw_handle_file_header,
+		fw_handle_file_header},
+	{wil_fw_type_direct_write, fw_handle_direct_write, fw_ignore_section},
+	{wil_fw_type_gateway_data, fw_handle_gateway_data, fw_ignore_section},
+	{wil_fw_type_gateway_data4, fw_handle_gateway_data4,
+		fw_ignore_section},
 };
 
 static int wil_fw_handle_record(struct wil6210_priv *wil, int type,
-				const void *data, size_t size)
+				const void *data, size_t size, bool load)
 {
 	int i;
 
-	for (i = 0; i < ARRAY_SIZE(wil_fw_handlers); i++) {
+	for (i = 0; i < ARRAY_SIZE(wil_fw_handlers); i++)
 		if (wil_fw_handlers[i].type == type)
-			return wil_fw_handlers[i].handler(wil, data, size);
-	}
+			return load ?
+				wil_fw_handlers[i].load_handler(
+					wil, data, size) :
+				wil_fw_handlers[i].parse_handler(
+					wil, data, size);
 
 	wil_err_fw(wil, "unknown record type: %d\n", type);
 	return -EINVAL;
 }
 
 /**
- * wil_fw_load - load FW into device
- *
- * Load the FW and uCode code and data to the corresponding device
- * memory regions
+ * wil_fw_process - process section from FW file
+ * if load is true: Load the FW and uCode code and data to the
+ * corresponding device memory regions,
+ * otherwise only parse and look for capabilities
  *
  * Return error code
  */
-static int wil_fw_load(struct wil6210_priv *wil, const void *data, size_t size)
+static int wil_fw_process(struct wil6210_priv *wil, const void *data,
+			  size_t size, bool load)
 {
 	int rc = 0;
 	const struct wil_fw_record_head *hdr;
@@ -437,7 +473,7 @@ static int wil_fw_load(struct wil6210_priv *wil, const void *data, size_t size)
 			return -EINVAL;
 		}
 		rc = wil_fw_handle_record(wil, le16_to_cpu(hdr->type),
-					  &hdr[1], hdr_sz);
+					  &hdr[1], hdr_sz, load);
 		if (rc)
 			return rc;
 	}
@@ -456,13 +492,16 @@ static int wil_fw_load(struct wil6210_priv *wil, const void *data, size_t size)
 }
 
 /**
- * wil_request_firmware - Request firmware and load to device
+ * wil_request_firmware - Request firmware
  *
- * Request firmware image from the file and load it to device
+ * Request firmware image from the file
+ * If load is true, load firmware to device, otherwise
+ * only parse and extract capabilities
  *
  * Return error code
  */
-int wil_request_firmware(struct wil6210_priv *wil, const char *name)
+int wil_request_firmware(struct wil6210_priv *wil, const char *name,
+			 bool load)
 {
 	int rc, rc1;
 	const struct firmware *fw;
@@ -482,7 +521,7 @@ int wil_request_firmware(struct wil6210_priv *wil, const char *name)
 			rc = rc1;
 			goto out;
 		}
-		rc = wil_fw_load(wil, d, rc1);
+		rc = wil_fw_process(wil, d, rc1, load);
 		if (rc < 0)
 			goto out;
 	}
diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index 7b7619c..7198c86 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -894,10 +894,10 @@ int wil_reset(struct wil6210_priv *wil, bool load_fw)
 
 		wil_halt_cpu(wil);
 		/* Loading f/w from the file */
-		rc = wil_request_firmware(wil, WIL_FW_NAME);
+		rc = wil_request_firmware(wil, WIL_FW_NAME, true);
 		if (rc)
 			return rc;
-		rc = wil_request_firmware(wil, WIL_FW2_NAME);
+		rc = wil_request_firmware(wil, WIL_FW2_NAME, true);
 		if (rc)
 			return rc;
 
diff --git a/drivers/net/wireless/ath/wil6210/pcie_bus.c b/drivers/net/wireless/ath/wil6210/pcie_bus.c
index 5b7a9d2..44746ca 100644
--- a/drivers/net/wireless/ath/wil6210/pcie_bus.c
+++ b/drivers/net/wireless/ath/wil6210/pcie_bus.c
@@ -39,6 +39,7 @@ void wil_set_capabilities(struct wil6210_priv *wil)
 	u32 rev_id = wil_r(wil, RGF_USER_JTAG_DEV_ID);
 
 	bitmap_zero(wil->hw_capabilities, hw_capability_last);
+	bitmap_zero(wil->fw_capabilities, WMI_FW_CAPABILITY_MAX);
 
 	switch (rev_id) {
 	case JTAG_DEV_ID_SPARROW_B0:
@@ -52,6 +53,9 @@ void wil_set_capabilities(struct wil6210_priv *wil)
 	}
 
 	wil_info(wil, "Board hardware is %s\n", wil->hw_name);
+
+	/* extract FW capabilities from file without loading the FW */
+	wil_request_firmware(wil, WIL_FW_NAME, false);
 }
 
 void wil_disable_irq(struct wil6210_priv *wil)
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 1eb7fe7..979536c 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -580,6 +580,7 @@ struct wil6210_priv {
 	u32 hw_version;
 	const char *hw_name;
 	DECLARE_BITMAP(hw_capabilities, hw_capability_last);
+	DECLARE_BITMAP(fw_capabilities, WMI_FW_CAPABILITY_MAX);
 	u8 n_mids; /* number of additional MIDs as reported by FW */
 	u32 recovery_count; /* num of FW recovery attempts in a short time */
 	u32 recovery_state; /* FW recovery state machine */
@@ -895,7 +896,8 @@ void wil6210_unmask_irq_rx(struct wil6210_priv *wil);
 int wil_iftype_nl2wmi(enum nl80211_iftype type);
 
 int wil_ioctl(struct wil6210_priv *wil, void __user *data, int cmd);
-int wil_request_firmware(struct wil6210_priv *wil, const char *name);
+int wil_request_firmware(struct wil6210_priv *wil, const char *name,
+			 bool load);
 
 int wil_can_suspend(struct wil6210_priv *wil, bool is_runtime);
 int wil_suspend(struct wil6210_priv *wil, bool is_runtime);
-- 
1.9.1
