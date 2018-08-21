Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:42598 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726585AbeHUI2i (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Aug 2018 04:28:38 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Naftali Goldstein <naftali.goldstein@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Tue, 21 Aug 2018 08:09:38 +0300
Message-Id: <20180821050952.31603-4-luca@coelho.fi> (sfid-20180821_071007_988069_95EC09AD)
In-Reply-To: <20180821050952.31603-1-luca@coelho.fi>
References: <20180821050952.31603-1-luca@coelho.fi>
Subject: [PATCH v2 03/17] iwlwifi: runtime: avoid calling debugfs read functions more than once
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Naftali Goldstein <naftali.goldstein@intel.com>

Upon first calling read() on a debugfs file, invoke
iwl_dbgfs_##name##_read and store the response buffer on the heap, so
subsequent read() calls don't need to invoke said function again.

This is done because cat etc will call read() repeatedly until EOF is
reached (or read() returns 0), which in the current implementation will
cause said function to be invoked multiple times.

With the current implementation this can also cause buggy behavior in
some weird edge cases where the first invocation returns a string of
length n, and the second of length m>n: The last m-n characters of
the second invocation will be printed to screen.

Signed-off-by: Naftali Goldstein <naftali.goldstein@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../net/wireless/intel/iwlwifi/fw/debugfs.c   | 111 ++++++++++++++----
 1 file changed, 87 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/debugfs.c b/drivers/net/wireless/intel/iwlwifi/fw/debugfs.c
index 8ba5a60ec9ed..2dd534b474b8 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/debugfs.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/debugfs.c
@@ -8,6 +8,7 @@
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
+ * Copyright (C) 2018 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -33,6 +34,7 @@
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
+ * Copyright (C) 2018 Intel Corporation
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -66,55 +68,117 @@
 #include "debugfs.h"
 #include "dbg.h"
 
-#define FWRT_DEBUGFS_READ_FILE_OPS(name)				\
-static ssize_t iwl_dbgfs_##name##_read(struct iwl_fw_runtime *fwrt,	\
-				       char *buf, size_t count,		\
-				       loff_t *ppos);			\
+#define FWRT_DEBUGFS_OPEN_WRAPPER(name, buflen, argtype)		\
+struct dbgfs_##name##_data {						\
+	argtype *arg;							\
+	bool read_done;							\
+	ssize_t rlen;							\
+	char rbuf[buflen];						\
+};									\
+static int _iwl_dbgfs_##name##_open(struct inode *inode,		\
+				    struct file *file)			\
+{									\
+	struct dbgfs_##name##_data *data;				\
+									\
+	data = kzalloc(sizeof(*data), GFP_KERNEL);			\
+	if (!data)							\
+		return -ENOMEM;						\
+									\
+	data->read_done = false;					\
+	data->arg = inode->i_private;					\
+	file->private_data = data;					\
+									\
+	return 0;							\
+}
+
+#define FWRT_DEBUGFS_READ_WRAPPER(name)					\
+static ssize_t _iwl_dbgfs_##name##_read(struct file *file,		\
+					char __user *user_buf,		\
+					size_t count, loff_t *ppos)	\
+{									\
+	struct dbgfs_##name##_data *data = file->private_data;		\
+									\
+	if (!data->read_done) {						\
+		data->read_done = true;					\
+		data->rlen = iwl_dbgfs_##name##_read(data->arg,		\
+						     sizeof(data->rbuf),\
+						     data->rbuf);	\
+	}								\
+									\
+	if (data->rlen < 0)						\
+		return data->rlen;					\
+	return simple_read_from_buffer(user_buf, count, ppos,		\
+				       data->rbuf, data->rlen);		\
+}
+
+static int _iwl_dbgfs_release(struct inode *inode, struct file *file)
+{
+	kfree(file->private_data);
+
+	return 0;
+}
+
+#define _FWRT_DEBUGFS_READ_FILE_OPS(name, buflen, argtype)		\
+FWRT_DEBUGFS_OPEN_WRAPPER(name, buflen, argtype)			\
+FWRT_DEBUGFS_READ_WRAPPER(name)						\
 static const struct file_operations iwl_dbgfs_##name##_ops = {		\
-	.read = iwl_dbgfs_##name##_read,				\
-	.open = simple_open,						\
+	.read = _iwl_dbgfs_##name##_read,				\
+	.open = _iwl_dbgfs_##name##_open,				\
 	.llseek = generic_file_llseek,					\
+	.release = _iwl_dbgfs_release,					\
 }
 
-#define FWRT_DEBUGFS_WRITE_WRAPPER(name, buflen)			\
-static ssize_t iwl_dbgfs_##name##_write(struct iwl_fw_runtime *fwrt,	\
-					char *buf, size_t count,	\
-					loff_t *ppos);			\
+#define FWRT_DEBUGFS_WRITE_WRAPPER(name, buflen, argtype)		\
 static ssize_t _iwl_dbgfs_##name##_write(struct file *file,		\
 					 const char __user *user_buf,	\
 					 size_t count, loff_t *ppos)	\
 {									\
-	struct iwl_fw_runtime *fwrt = file->private_data;		\
+	argtype *arg =							\
+		((struct dbgfs_##name##_data *)file->private_data)->arg;\
 	char buf[buflen] = {};						\
 	size_t buf_size = min(count, sizeof(buf) -  1);			\
 									\
 	if (copy_from_user(buf, user_buf, buf_size))			\
 		return -EFAULT;						\
 									\
-	return iwl_dbgfs_##name##_write(fwrt, buf, buf_size, ppos);	\
+	return iwl_dbgfs_##name##_write(arg, buf, buf_size);		\
 }
 
-#define FWRT_DEBUGFS_READ_WRITE_FILE_OPS(name, buflen)			\
-FWRT_DEBUGFS_WRITE_WRAPPER(name, buflen)				\
+#define _FWRT_DEBUGFS_READ_WRITE_FILE_OPS(name, buflen, argtype)	\
+FWRT_DEBUGFS_OPEN_WRAPPER(name, buflen, argtype)			\
+FWRT_DEBUGFS_WRITE_WRAPPER(name, buflen, argtype)			\
+FWRT_DEBUGFS_READ_WRAPPER(name)						\
 static const struct file_operations iwl_dbgfs_##name##_ops = {		\
 	.write = _iwl_dbgfs_##name##_write,				\
-	.read = iwl_dbgfs_##name##_read,				\
-	.open = simple_open,						\
+	.read = _iwl_dbgfs_##name##_read,				\
+	.open = _iwl_dbgfs_##name##_open,				\
 	.llseek = generic_file_llseek,					\
+	.release = _iwl_dbgfs_release,					\
 }
 
-#define FWRT_DEBUGFS_WRITE_FILE_OPS(name, buflen)			\
-FWRT_DEBUGFS_WRITE_WRAPPER(name, buflen)				\
+#define _FWRT_DEBUGFS_WRITE_FILE_OPS(name, buflen, argtype)		\
+FWRT_DEBUGFS_OPEN_WRAPPER(name, buflen, argtype)			\
+FWRT_DEBUGFS_WRITE_WRAPPER(name, buflen, argtype)			\
 static const struct file_operations iwl_dbgfs_##name##_ops = {		\
 	.write = _iwl_dbgfs_##name##_write,				\
-	.open = simple_open,						\
+	.open = _iwl_dbgfs_##name##_open,				\
 	.llseek = generic_file_llseek,					\
+	.release = _iwl_dbgfs_release,					\
 }
 
+#define FWRT_DEBUGFS_READ_FILE_OPS(name, bufsz)				\
+	_FWRT_DEBUGFS_READ_FILE_OPS(name, bufsz, struct iwl_fw_runtime)
+
+#define FWRT_DEBUGFS_WRITE_FILE_OPS(name, bufsz)			\
+	_FWRT_DEBUGFS_WRITE_FILE_OPS(name, bufsz, struct iwl_fw_runtime)
+
+#define FWRT_DEBUGFS_READ_WRITE_FILE_OPS(name, bufsz)			\
+	_FWRT_DEBUGFS_READ_WRITE_FILE_OPS(name, bufsz, struct iwl_fw_runtime)
+
 #define FWRT_DEBUGFS_ADD_FILE_ALIAS(alias, name, parent, mode) do {	\
-		if (!debugfs_create_file(alias, mode, parent, fwrt,	\
-					 &iwl_dbgfs_##name##_ops))	\
-			goto err;					\
+	if (!debugfs_create_file(alias, mode, parent, fwrt,		\
+				 &iwl_dbgfs_##name##_ops))		\
+		goto err;						\
 	} while (0)
 #define FWRT_DEBUGFS_ADD_FILE(name, parent, mode) \
 	FWRT_DEBUGFS_ADD_FILE_ALIAS(#name, name, parent, mode)
@@ -173,8 +237,7 @@ void iwl_fw_trigger_timestamp(struct iwl_fw_runtime *fwrt, u32 delay)
 }
 
 static ssize_t iwl_dbgfs_timestamp_marker_write(struct iwl_fw_runtime *fwrt,
-						char *buf, size_t count,
-						loff_t *ppos)
+						char *buf, size_t count)
 {
 	int ret;
 	u32 delay;
-- 
2.18.0
