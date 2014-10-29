Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:8266 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933114AbaJ2PC7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2014 11:02:59 -0400
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 2/2] brcmsmac: expose 802.11 core statistics in debugfs
Date: Wed, 29 Oct 2014 16:02:51 +0100
Message-ID: <1414594971-26389-3-git-send-email-arend@broadcom.com> (sfid-20141029_160302_998460_4BA3B163)
In-Reply-To: <1414594971-26389-1-git-send-email-arend@broadcom.com>
References: <1414594971-26389-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The 802.11 statistics obtained from the device can be retrieved
dumping the 'macstat' file in debugfs folder.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/debug.c | 166 +++++++++++++++++++-----
 1 file changed, 133 insertions(+), 33 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/debug.c b/drivers/net/wireless/brcm80211/brcmsmac/debug.c
index a5d4add..19740c1 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/debug.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/debug.c
@@ -71,48 +71,148 @@ struct dentry *brcms_debugfs_get_devdir(struct brcms_pub *drvr)
 }
 
 static
-ssize_t brcms_debugfs_hardware_read(struct file *f, char __user *data,
-					size_t count, loff_t *ppos)
+int brcms_debugfs_hardware_read(struct seq_file *s, void *data)
 {
-	char buf[128];
-	int res;
-	struct brcms_pub *drvr = f->private_data;
-
-	/* only allow read from start */
-	if (*ppos > 0)
-		return 0;
-
-	res = scnprintf(buf, sizeof(buf),
-		"board vendor: %x\n"
-		"board type: %x\n"
-		"board revision: %x\n"
-		"board flags: %x\n"
-		"board flags2: %x\n"
-		"firmware revision: %x\n",
-		drvr->wlc->hw->d11core->bus->boardinfo.vendor,
-		drvr->wlc->hw->d11core->bus->boardinfo.type,
-		drvr->wlc->hw->boardrev,
-		drvr->wlc->hw->boardflags,
-		drvr->wlc->hw->boardflags2,
-		drvr->wlc->ucode_rev
-		);
-
-	return simple_read_from_buffer(data, count, ppos, buf, res);
+	struct brcms_pub *drvr = s->private;
+
+	seq_printf(s, "board vendor: %x\n"
+		   "board type: %x\n"
+		   "board revision: %x\n"
+		   "board flags: %x\n"
+		   "board flags2: %x\n"
+		   "firmware revision: %x\n",
+		   drvr->wlc->hw->d11core->bus->boardinfo.vendor,
+		   drvr->wlc->hw->d11core->bus->boardinfo.type,
+		   drvr->wlc->hw->boardrev,
+		   drvr->wlc->hw->boardflags,
+		   drvr->wlc->hw->boardflags2,
+		   drvr->wlc->ucode_rev);
+
+	return 0;
+}
+
+static int brcms_debugfs_macstat_read(struct seq_file *s, void *data)
+{
+	struct brcms_pub *drvr = s->private;
+	struct brcms_info *wl = drvr->ieee_hw->priv;
+	struct macstat stats;
+	int i;
+
+	spin_lock_bh(&wl->lock);
+	stats = *(drvr->wlc->core->macstat_snapshot);
+	spin_unlock_bh(&wl->lock);
+
+	seq_printf(s, "txallfrm: %d\n", stats.txallfrm);
+	seq_printf(s, "txrtsfrm: %d\n", stats.txrtsfrm);
+	seq_printf(s, "txctsfrm: %d\n", stats.txctsfrm);
+	seq_printf(s, "txackfrm: %d\n", stats.txackfrm);
+	seq_printf(s, "txdnlfrm: %d\n", stats.txdnlfrm);
+	seq_printf(s, "txbcnfrm: %d\n", stats.txbcnfrm);
+	seq_printf(s, "txfunfl[8]:");
+	for (i = 0; i < ARRAY_SIZE(stats.txfunfl); i++)
+		seq_printf(s, " %d", stats.txfunfl[i]);
+	seq_printf(s, "\ntxtplunfl: %d\n", stats.txtplunfl);
+	seq_printf(s, "txphyerr: %d\n", stats.txphyerr);
+	seq_printf(s, "pktengrxducast: %d\n", stats.pktengrxducast);
+	seq_printf(s, "pktengrxdmcast: %d\n", stats.pktengrxdmcast);
+	seq_printf(s, "rxfrmtoolong: %d\n", stats.rxfrmtoolong);
+	seq_printf(s, "rxfrmtooshrt: %d\n", stats.rxfrmtooshrt);
+	seq_printf(s, "rxinvmachdr: %d\n", stats.rxinvmachdr);
+	seq_printf(s, "rxbadfcs: %d\n", stats.rxbadfcs);
+	seq_printf(s, "rxbadplcp: %d\n", stats.rxbadplcp);
+	seq_printf(s, "rxcrsglitch: %d\n", stats.rxcrsglitch);
+	seq_printf(s, "rxstrt: %d\n", stats.rxstrt);
+	seq_printf(s, "rxdfrmucastmbss: %d\n", stats.rxdfrmucastmbss);
+	seq_printf(s, "rxmfrmucastmbss: %d\n", stats.rxmfrmucastmbss);
+	seq_printf(s, "rxcfrmucast: %d\n", stats.rxcfrmucast);
+	seq_printf(s, "rxrtsucast: %d\n", stats.rxrtsucast);
+	seq_printf(s, "rxctsucast: %d\n", stats.rxctsucast);
+	seq_printf(s, "rxackucast: %d\n", stats.rxackucast);
+	seq_printf(s, "rxdfrmocast: %d\n", stats.rxdfrmocast);
+	seq_printf(s, "rxmfrmocast: %d\n", stats.rxmfrmocast);
+	seq_printf(s, "rxcfrmocast: %d\n", stats.rxcfrmocast);
+	seq_printf(s, "rxrtsocast: %d\n", stats.rxrtsocast);
+	seq_printf(s, "rxctsocast: %d\n", stats.rxctsocast);
+	seq_printf(s, "rxdfrmmcast: %d\n", stats.rxdfrmmcast);
+	seq_printf(s, "rxmfrmmcast: %d\n", stats.rxmfrmmcast);
+	seq_printf(s, "rxcfrmmcast: %d\n", stats.rxcfrmmcast);
+	seq_printf(s, "rxbeaconmbss: %d\n", stats.rxbeaconmbss);
+	seq_printf(s, "rxdfrmucastobss: %d\n", stats.rxdfrmucastobss);
+	seq_printf(s, "rxbeaconobss: %d\n", stats.rxbeaconobss);
+	seq_printf(s, "rxrsptmout: %d\n", stats.rxrsptmout);
+	seq_printf(s, "bcntxcancl: %d\n", stats.bcntxcancl);
+	seq_printf(s, "rxf0ovfl: %d\n", stats.rxf0ovfl);
+	seq_printf(s, "rxf1ovfl: %d\n", stats.rxf1ovfl);
+	seq_printf(s, "rxf2ovfl: %d\n", stats.rxf2ovfl);
+	seq_printf(s, "txsfovfl: %d\n", stats.txsfovfl);
+	seq_printf(s, "pmqovfl: %d\n", stats.pmqovfl);
+	seq_printf(s, "rxcgprqfrm: %d\n", stats.rxcgprqfrm);
+	seq_printf(s, "rxcgprsqovfl: %d\n", stats.rxcgprsqovfl);
+	seq_printf(s, "txcgprsfail: %d\n", stats.txcgprsfail);
+	seq_printf(s, "txcgprssuc: %d\n", stats.txcgprssuc);
+	seq_printf(s, "prs_timeout: %d\n", stats.prs_timeout);
+	seq_printf(s, "rxnack: %d\n", stats.rxnack);
+	seq_printf(s, "frmscons: %d\n", stats.frmscons);
+	seq_printf(s, "txnack: %d\n", stats.txnack);
+	seq_printf(s, "txglitch_nack: %d\n", stats.txglitch_nack);
+	seq_printf(s, "txburst: %d\n", stats.txburst);
+	seq_printf(s, "bphy_rxcrsglitch: %d\n", stats.bphy_rxcrsglitch);
+	seq_printf(s, "phywatchdog: %d\n", stats.phywatchdog);
+	seq_printf(s, "bphy_badplcp: %d\n", stats.bphy_badplcp);
+	return 0;
+}
+
+struct brcms_debugfs_entry {
+	int (*read)(struct seq_file *seq, void *data);
+	struct brcms_pub *drvr;
+};
+
+static int brcms_debugfs_entry_open(struct inode *inode, struct file *f)
+{
+	struct brcms_debugfs_entry *entry = inode->i_private;
+
+	return single_open(f, entry->read, entry->drvr);
 }
 
-static const struct file_operations brcms_debugfs_hardware_ops = {
+static const struct file_operations brcms_debugfs_def_ops = {
 	.owner = THIS_MODULE,
-	.open = simple_open,
-	.read = brcms_debugfs_hardware_read
+	.open = brcms_debugfs_entry_open,
+	.release = single_release,
+	.read = seq_read,
+	.llseek = seq_lseek
 };
 
+static int
+brcms_debugfs_add_entry(struct brcms_pub *drvr, const char *fn,
+			int (*read_fn)(struct seq_file *seq, void *data))
+{
+	struct device *dev = &drvr->wlc->hw->d11core->dev;
+	struct dentry *dentry =  drvr->dbgfs_dir;
+	struct brcms_debugfs_entry *entry;
+
+	if (IS_ERR_OR_NULL(dentry))
+		return -ENOENT;
+
+	entry = devm_kzalloc(dev, sizeof(*entry), GFP_KERNEL);
+	if (!entry)
+		return -ENOMEM;
+
+	entry->read = read_fn;
+	entry->drvr = drvr;
+
+	dentry = debugfs_create_file(fn, S_IRUGO, dentry, entry,
+				     &brcms_debugfs_def_ops);
+
+	return PTR_ERR_OR_ZERO(dentry);
+}
+
 void brcms_debugfs_create_files(struct brcms_pub *drvr)
 {
-	struct dentry *dentry = drvr->dbgfs_dir;
+	if (IS_ERR_OR_NULL(drvr->dbgfs_dir))
+		return;
 
-	if (!IS_ERR_OR_NULL(dentry))
-		debugfs_create_file("hardware", S_IRUGO, dentry,
-				    drvr, &brcms_debugfs_hardware_ops);
+	brcms_debugfs_add_entry(drvr, "hardware", brcms_debugfs_hardware_read);
+	brcms_debugfs_add_entry(drvr, "macstat", brcms_debugfs_macstat_read);
 }
 
 #define __brcms_fn(fn)						\
-- 
1.9.1

