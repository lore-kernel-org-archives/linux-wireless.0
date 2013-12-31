Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f41.google.com ([74.125.83.41]:47150 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755176Ab3LaRQb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Dec 2013 12:16:31 -0500
Received: by mail-ee0-f41.google.com with SMTP id t10so5667746eei.0
        for <linux-wireless@vger.kernel.org>; Tue, 31 Dec 2013 09:16:30 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 20/28] iwlwifi: mvm: dump to debugfs the SRAM as binary
Date: Tue, 31 Dec 2013 19:15:49 +0200
Message-Id: <1388510157-23345-20-git-send-email-egrumbach@gmail.com> (sfid-20131231_183437_163819_3223F13F)
In-Reply-To: <52C2FB68.2010708@gmail.com>
References: <52C2FB68.2010708@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This allows to format it at will using external tools.
Since different teams want it in different formats, dump
the raw data and everyone can play with the data the way
they want.

While at it - make this code slightly more robust by making
the required verification on the offsets / length in the
write handler.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/debugfs.c |   49 ++++++++++++----------------
 1 file changed, 21 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
index e8f62a6..373ced6 100644
--- a/drivers/net/wireless/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
@@ -123,51 +123,31 @@ static ssize_t iwl_dbgfs_sram_read(struct file *file, char __user *user_buf,
 {
 	struct iwl_mvm *mvm = file->private_data;
 	const struct fw_img *img;
-	int ofs, len, pos = 0;
-	size_t bufsz, ret;
-	char *buf;
+	unsigned int ofs, len;
+	size_t ret;
 	u8 *ptr;
 
 	if (!mvm->ucode_loaded)
 		return -EINVAL;
 
 	/* default is to dump the entire data segment */
+	img = &mvm->fw->img[mvm->cur_ucode];
+	ofs = img->sec[IWL_UCODE_SECTION_DATA].offset;
+	len = img->sec[IWL_UCODE_SECTION_DATA].len;
+
 	if (!mvm->dbgfs_sram_offset && !mvm->dbgfs_sram_len) {
-		img = &mvm->fw->img[mvm->cur_ucode];
-		ofs = img->sec[IWL_UCODE_SECTION_DATA].offset;
-		len = img->sec[IWL_UCODE_SECTION_DATA].len;
-	} else {
 		ofs = mvm->dbgfs_sram_offset;
 		len = mvm->dbgfs_sram_len;
 	}
 
-	bufsz = len * 4 + 256;
-	buf = kzalloc(bufsz, GFP_KERNEL);
-	if (!buf)
-		return -ENOMEM;
-
 	ptr = kzalloc(len, GFP_KERNEL);
-	if (!ptr) {
-		kfree(buf);
+	if (!ptr)
 		return -ENOMEM;
-	}
-
-	pos += scnprintf(buf + pos, bufsz - pos, "sram_len: 0x%x\n", len);
-	pos += scnprintf(buf + pos, bufsz - pos, "sram_offset: 0x%x\n", ofs);
 
 	iwl_trans_read_mem_bytes(mvm->trans, ofs, ptr, len);
-	for (ofs = 0; ofs < len; ofs += 16) {
-		pos += scnprintf(buf + pos, bufsz - pos, "0x%.4x ", ofs);
-		hex_dump_to_buffer(ptr + ofs, 16, 16, 1, buf + pos,
-				   bufsz - pos, false);
-		pos += strlen(buf + pos);
-		if (bufsz - pos > 0)
-			buf[pos++] = '\n';
-	}
 
-	ret = simple_read_from_buffer(user_buf, count, ppos, buf, pos);
+	ret = simple_read_from_buffer(user_buf, count, ppos, ptr, len);
 
-	kfree(buf);
 	kfree(ptr);
 
 	return ret;
@@ -176,11 +156,24 @@ static ssize_t iwl_dbgfs_sram_read(struct file *file, char __user *user_buf,
 static ssize_t iwl_dbgfs_sram_write(struct iwl_mvm *mvm, char *buf,
 				    size_t count, loff_t *ppos)
 {
+	const struct fw_img *img;
 	u32 offset, len;
+	u32 img_offset, img_len;
+
+	if (!mvm->ucode_loaded)
+		return -EINVAL;
+
+	img = &mvm->fw->img[mvm->cur_ucode];
+	img_offset = img->sec[IWL_UCODE_SECTION_DATA].offset;
+	img_len = img->sec[IWL_UCODE_SECTION_DATA].len;
 
 	if (sscanf(buf, "%x,%x", &offset, &len) == 2) {
 		if ((offset & 0x3) || (len & 0x3))
 			return -EINVAL;
+
+		if (offset + len > img_offset + img_len)
+			return -EINVAL;
+
 		mvm->dbgfs_sram_offset = offset;
 		mvm->dbgfs_sram_len = len;
 	} else {
-- 
1.7.9.5

