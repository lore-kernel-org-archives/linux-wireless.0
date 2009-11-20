Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:61936 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754162AbZKTUFJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Nov 2009 15:05:09 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 13/19] iwlwifi: by default, dump entire sram data portion
Date: Fri, 20 Nov 2009 12:05:04 -0800
Message-Id: <1258747510-21233-14-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1258747510-21233-1-git-send-email-reinette.chatre@intel.com>
References: <1258747510-21233-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

For "sram" debugfs file, if user did not specify the offset and length,
dump the entire data portion of sram by default.
Data portion is 0x800000 - 0x80ffff, but the actual data size is known
to the driver from the ucode file.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-debugfs.c |   14 +++++++++++---
 1 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index 016ff40..5adf0b6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -235,13 +235,21 @@ static ssize_t iwl_dbgfs_sram_read(struct file *file,
 	struct iwl_priv *priv = (struct iwl_priv *)file->private_data;
 	size_t bufsz;
 
-	bufsz =  30 + priv->dbgfs->sram_len * sizeof(char) * 12;
+	/* default is to dump the entire data segment */
+	if (!priv->dbgfs->sram_offset && !priv->dbgfs->sram_len) {
+		priv->dbgfs->sram_offset = 0x800000;
+		if (priv->ucode_type == UCODE_INIT)
+			priv->dbgfs->sram_len = priv->ucode_init_data.len;
+		else
+			priv->dbgfs->sram_len = priv->ucode_data.len;
+	}
+	bufsz =  30 + priv->dbgfs->sram_len * sizeof(char) * 10;
 	buf = kmalloc(bufsz, GFP_KERNEL);
 	if (!buf)
 		return -ENOMEM;
-	pos += scnprintf(buf + pos, bufsz - pos, "sram_len: %d\n",
+	pos += scnprintf(buf + pos, bufsz - pos, "sram_len: 0x%x\n",
 			priv->dbgfs->sram_len);
-	pos += scnprintf(buf + pos, bufsz - pos, "sram_offset: %d\n",
+	pos += scnprintf(buf + pos, bufsz - pos, "sram_offset: 0x%x\n",
 			priv->dbgfs->sram_offset);
 	for (i = priv->dbgfs->sram_len; i > 0; i -= 4) {
 		val = iwl_read_targ_mem(priv, priv->dbgfs->sram_offset + \
-- 
1.5.6.3

