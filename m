Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:47754 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754980Ab1AVASX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Jan 2011 19:18:23 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Jay Sternberg <jay.e.sternberg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 10/14] iwlwifi: correct debugfs data dumped from sram
Date: Fri, 21 Jan 2011 16:06:45 -0800
Message-Id: <1295654809-5790-11-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1295654809-5790-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1295654809-5790-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jay Sternberg <jay.e.sternberg@intel.com>

the sram data dumped through the debugfs interface would only work properly
when dumping data on even u32 boundaries and swap bytes based on endianness
on that boundary making byte arrays impossible to read.

now addresses are displayed at the start of every line and the data is
displayed consistently if dumping 1 byte or 20 and regardless of what is the
starting address.

if no lenght given, address displayed is u32 in device format

Signed-off-by: Jay Sternberg <jay.e.sternberg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-debugfs.c |   81 +++++++++++++++++++---------
 1 files changed, 56 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index 7f11a44..418c8ac 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -207,18 +207,19 @@ static ssize_t iwl_dbgfs_rx_statistics_read(struct file *file,
 	return ret;
 }
 
-#define BYTE1_MASK 0x000000ff;
-#define BYTE2_MASK 0x0000ffff;
-#define BYTE3_MASK 0x00ffffff;
 static ssize_t iwl_dbgfs_sram_read(struct file *file,
 					char __user *user_buf,
 					size_t count, loff_t *ppos)
 {
-	u32 val;
+	u32 val = 0;
 	char *buf;
 	ssize_t ret;
-	int i;
+	int i = 0;
+	bool device_format = false;
+	int offset = 0;
+	int len = 0;
 	int pos = 0;
+	int sram;
 	struct iwl_priv *priv = file->private_data;
 	size_t bufsz;
 
@@ -230,35 +231,62 @@ static ssize_t iwl_dbgfs_sram_read(struct file *file,
 		else
 			priv->dbgfs_sram_len = priv->ucode_data.len;
 	}
-	bufsz =  30 + priv->dbgfs_sram_len * sizeof(char) * 10;
+	len = priv->dbgfs_sram_len;
+
+	if (len == -4) {
+		device_format = true;
+		len = 4;
+	}
+
+	bufsz =  50 + len * 4;
 	buf = kmalloc(bufsz, GFP_KERNEL);
 	if (!buf)
 		return -ENOMEM;
+
 	pos += scnprintf(buf + pos, bufsz - pos, "sram_len: 0x%x\n",
-			priv->dbgfs_sram_len);
+			 len);
 	pos += scnprintf(buf + pos, bufsz - pos, "sram_offset: 0x%x\n",
 			priv->dbgfs_sram_offset);
-	for (i = priv->dbgfs_sram_len; i > 0; i -= 4) {
-		val = iwl_read_targ_mem(priv, priv->dbgfs_sram_offset + \
-					priv->dbgfs_sram_len - i);
-		if (i < 4) {
-			switch (i) {
-			case 1:
-				val &= BYTE1_MASK;
-				break;
-			case 2:
-				val &= BYTE2_MASK;
-				break;
-			case 3:
-				val &= BYTE3_MASK;
-				break;
-			}
+
+	/* adjust sram address since reads are only on even u32 boundaries */
+	offset = priv->dbgfs_sram_offset & 0x3;
+	sram = priv->dbgfs_sram_offset & ~0x3;
+
+	/* read the first u32 from sram */
+	val = iwl_read_targ_mem(priv, sram);
+
+	for (; len; len--) {
+		/* put the address at the start of every line */
+		if (i == 0)
+			pos += scnprintf(buf + pos, bufsz - pos,
+				"%08X: ", sram + offset);
+
+		if (device_format)
+			pos += scnprintf(buf + pos, bufsz - pos,
+				"%02x", (val >> (8 * (3 - offset))) & 0xff);
+		else
+			pos += scnprintf(buf + pos, bufsz - pos,
+				"%02x ", (val >> (8 * offset)) & 0xff);
+
+		/* if all bytes processed, read the next u32 from sram */
+		if (++offset == 4) {
+			sram += 4;
+			offset = 0;
+			val = iwl_read_targ_mem(priv, sram);
 		}
-		if (!(i % 16))
+
+		/* put in extra spaces and split lines for human readability */
+		if (++i == 16) {
+			i = 0;
 			pos += scnprintf(buf + pos, bufsz - pos, "\n");
-		pos += scnprintf(buf + pos, bufsz - pos, "0x%08x ", val);
+		} else if (!(i & 7)) {
+			pos += scnprintf(buf + pos, bufsz - pos, "   ");
+		} else if (!(i & 3)) {
+			pos += scnprintf(buf + pos, bufsz - pos, " ");
+		}
 	}
-	pos += scnprintf(buf + pos, bufsz - pos, "\n");
+	if (i)
+		pos += scnprintf(buf + pos, bufsz - pos, "\n");
 
 	ret = simple_read_from_buffer(user_buf, count, ppos, buf, pos);
 	kfree(buf);
@@ -282,6 +310,9 @@ static ssize_t iwl_dbgfs_sram_write(struct file *file,
 	if (sscanf(buf, "%x,%x", &offset, &len) == 2) {
 		priv->dbgfs_sram_offset = offset;
 		priv->dbgfs_sram_len = len;
+	} else if (sscanf(buf, "%x", &offset) == 1) {
+		priv->dbgfs_sram_offset = offset;
+		priv->dbgfs_sram_len = -4;
 	} else {
 		priv->dbgfs_sram_offset = 0;
 		priv->dbgfs_sram_len = 0;
-- 
1.7.0.4

