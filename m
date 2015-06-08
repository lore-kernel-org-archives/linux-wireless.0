Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:34842 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752332AbbFHMij (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jun 2015 08:38:39 -0400
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 4/4] brcmfmac: use debugfs_create_devm_seqfile() helper function
Date: Mon, 8 Jun 2015 14:38:35 +0200
Message-ID: <1433767115-8136-5-git-send-email-arend@broadcom.com> (sfid-20150608_143847_709764_D050BCBA)
In-Reply-To: <1433767115-8136-1-git-send-email-arend@broadcom.com>
References: <1433767115-8136-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some time ago the function debugfs_create_devm_seqfile() was
introduced in debugfs. The caller simply needs to provide a
device pointer and read function. The function brcmf_debugfs_add_entry()
is now simply a wrapper only doing the work for CONFIG_BRCMDBG.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Daniel (Deognyoun) Kim <dekim@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/debug.c | 40 +++----------------------
 1 file changed, 4 insertions(+), 36 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/debug.c b/drivers/net/wireless/brcm80211/brcmfmac/debug.c
index 10a9221..2d6d005 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/debug.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/debug.c
@@ -64,44 +64,12 @@ struct dentry *brcmf_debugfs_get_devdir(struct brcmf_pub *drvr)
 	return drvr->dbgfs_dir;
 }
 
-struct brcmf_debugfs_entry {
-	int (*read)(struct seq_file *seq, void *data);
-	struct brcmf_pub *drvr;
-};
-
-static int brcmf_debugfs_entry_open(struct inode *inode, struct file *f)
-{
-	struct brcmf_debugfs_entry *entry = inode->i_private;
-
-	return single_open(f, entry->read, entry->drvr->bus_if->dev);
-}
-
-static const struct file_operations brcmf_debugfs_def_ops = {
-	.owner = THIS_MODULE,
-	.open = brcmf_debugfs_entry_open,
-	.release = single_release,
-	.read = seq_read,
-	.llseek = seq_lseek
-};
-
 int brcmf_debugfs_add_entry(struct brcmf_pub *drvr, const char *fn,
 			    int (*read_fn)(struct seq_file *seq, void *data))
 {
-	struct dentry *dentry =  drvr->dbgfs_dir;
-	struct brcmf_debugfs_entry *entry;
-
-	if (IS_ERR_OR_NULL(dentry))
-		return -ENOENT;
-
-	entry = devm_kzalloc(drvr->bus_if->dev, sizeof(*entry), GFP_KERNEL);
-	if (!entry)
-		return -ENOMEM;
-
-	entry->read = read_fn;
-	entry->drvr = drvr;
-
-	dentry = debugfs_create_file(fn, S_IRUGO, dentry, entry,
-				     &brcmf_debugfs_def_ops);
+	struct dentry *e;
 
-	return PTR_ERR_OR_ZERO(dentry);
+	e = debugfs_create_devm_seqfile(drvr->bus_if->dev, fn,
+					drvr->dbgfs_dir, read_fn);
+	return PTR_ERR_OR_ZERO(e);
 }
-- 
1.9.1

