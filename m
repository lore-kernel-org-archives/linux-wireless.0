Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:36539 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754080AbZKTUFH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Nov 2009 15:05:07 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 09/19] iwlwifi: dynamically allocate buffer for sram debugfs file
Date: Fri, 20 Nov 2009 12:05:00 -0800
Message-Id: <1258747510-21233-10-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1258747510-21233-1-git-send-email-reinette.chatre@intel.com>
References: <1258747510-21233-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Dynamically allocate memory for dumping SRAM based on the length of memory
to be displayed.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-debugfs.c |   15 +++++++++++++--
 1 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index 4630094..016ff40 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -228,13 +228,21 @@ static ssize_t iwl_dbgfs_sram_read(struct file *file,
 					size_t count, loff_t *ppos)
 {
 	u32 val;
-	char buf[1024];
+	char *buf;
 	ssize_t ret;
 	int i;
 	int pos = 0;
 	struct iwl_priv *priv = (struct iwl_priv *)file->private_data;
-	const size_t bufsz = sizeof(buf);
+	size_t bufsz;
 
+	bufsz =  30 + priv->dbgfs->sram_len * sizeof(char) * 12;
+	buf = kmalloc(bufsz, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+	pos += scnprintf(buf + pos, bufsz - pos, "sram_len: %d\n",
+			priv->dbgfs->sram_len);
+	pos += scnprintf(buf + pos, bufsz - pos, "sram_offset: %d\n",
+			priv->dbgfs->sram_offset);
 	for (i = priv->dbgfs->sram_len; i > 0; i -= 4) {
 		val = iwl_read_targ_mem(priv, priv->dbgfs->sram_offset + \
 					priv->dbgfs->sram_len - i);
@@ -251,11 +259,14 @@ static ssize_t iwl_dbgfs_sram_read(struct file *file,
 				break;
 			}
 		}
+		if (!(i % 16))
+			pos += scnprintf(buf + pos, bufsz - pos, "\n");
 		pos += scnprintf(buf + pos, bufsz - pos, "0x%08x ", val);
 	}
 	pos += scnprintf(buf + pos, bufsz - pos, "\n");
 
 	ret = simple_read_from_buffer(user_buf, count, ppos, buf, pos);
+	kfree(buf);
 	return ret;
 }
 
-- 
1.5.6.3

