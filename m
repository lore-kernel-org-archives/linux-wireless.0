Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:44586 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752442AbaJ1MVL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Oct 2014 08:21:11 -0400
From: Arend van Spriel <arend@broadcom.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 3/3] ath: ath9k: use debugfs_create_devm_seqfile() helper for seq_file entries
Date: Tue, 28 Oct 2014 13:19:12 +0100
Message-ID: <1414498752-9746-4-git-send-email-arend@broadcom.com> (sfid-20141028_132116_182359_63F8284B)
In-Reply-To: <1414498752-9746-1-git-send-email-arend@broadcom.com>
References: <1414498752-9746-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use the helper to get rid of the file operations per debugfs file. The
struct ath9k_softc pointer is set as device driver data to be obtained
in the seq_file read operation.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/ath/ath9k/ahb.c   |   1 +
 drivers/net/wireless/ath/ath9k/debug.c | 122 ++++++---------------------------
 drivers/net/wireless/ath/ath9k/pci.c   |   1 +
 3 files changed, 24 insertions(+), 100 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ahb.c b/drivers/net/wireless/ath/ath9k/ahb.c
index 4173838..74b009b 100644
--- a/drivers/net/wireless/ath/ath9k/ahb.c
+++ b/drivers/net/wireless/ath/ath9k/ahb.c
@@ -126,6 +126,7 @@ static int ath_ahb_probe(struct platform_device *pdev)
 	sc = hw->priv;
 	sc->hw = hw;
 	sc->dev = &pdev->dev;
+	dev_set_drvdata(sc->dev, sc);
 	sc->mem = mem;
 	sc->irq = irq;
 
diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 1d6bfda..62d8a09 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -403,7 +403,7 @@ static const struct file_operations fops_antenna_diversity = {
 
 static int read_file_dma(struct seq_file *file, void *data)
 {
-	struct ath_softc *sc = file->private;
+	struct ath_softc *sc = dev_get_drvdata(file->private);
 	struct ath_hw *ah = sc->sc_ah;
 	u32 val[ATH9K_NUM_DMA_DEBUG_REGS];
 	int i, qcuOffset = 0, dcuOffset = 0;
@@ -470,20 +470,6 @@ static int read_file_dma(struct seq_file *file, void *data)
 	return 0;
 }
 
-static int open_file_dma(struct inode *inode, struct file *f)
-{
-	return single_open(f, read_file_dma, inode->i_private);
-}
-
-static const struct file_operations fops_dma = {
-	.open = open_file_dma,
-	.read = seq_read,
-	.owner = THIS_MODULE,
-	.llseek = seq_lseek,
-	.release = single_release,
-};
-
-
 void ath_debug_stat_interrupt(struct ath_softc *sc, enum ath9k_int status)
 {
 	if (status)
@@ -539,7 +525,7 @@ void ath_debug_stat_interrupt(struct ath_softc *sc, enum ath9k_int status)
 
 static int read_file_interrupt(struct seq_file *file, void *data)
 {
-	struct ath_softc *sc = file->private;
+	struct ath_softc *sc = dev_get_drvdata(file->private);
 
 #define PR_IS(a, s)						\
 	do {							\
@@ -600,22 +586,9 @@ static int read_file_interrupt(struct seq_file *file, void *data)
 	return 0;
 }
 
-static int open_file_interrupt(struct inode *inode, struct file *f)
-{
-	return single_open(f, read_file_interrupt, inode->i_private);
-}
-
-static const struct file_operations fops_interrupt = {
-	.read = seq_read,
-	.open = open_file_interrupt,
-	.owner = THIS_MODULE,
-	.llseek = seq_lseek,
-	.release = single_release,
-};
-
 static int read_file_xmit(struct seq_file *file, void *data)
 {
-	struct ath_softc *sc = file->private;
+	struct ath_softc *sc = dev_get_drvdata(file->private);
 
 	seq_printf(file, "%30s %10s%10s%10s\n\n", "BE", "BK", "VI", "VO");
 
@@ -661,7 +634,7 @@ static void print_queue(struct ath_softc *sc, struct ath_txq *txq,
 
 static int read_file_queues(struct seq_file *file, void *data)
 {
-	struct ath_softc *sc = file->private;
+	struct ath_softc *sc = dev_get_drvdata(file->private);
 	struct ath_txq *txq;
 	int i;
 	static const char *qname[4] = {
@@ -682,7 +655,7 @@ static int read_file_queues(struct seq_file *file, void *data)
 
 static int read_file_misc(struct seq_file *file, void *data)
 {
-	struct ath_softc *sc = file->private;
+	struct ath_softc *sc = dev_get_drvdata(file->private);
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	struct ath9k_vif_iter_data iter_data;
 	struct ath_chanctx *ctx;
@@ -772,7 +745,7 @@ static int read_file_misc(struct seq_file *file, void *data)
 
 static int read_file_reset(struct seq_file *file, void *data)
 {
-	struct ath_softc *sc = file->private;
+	struct ath_softc *sc = dev_get_drvdata(file->private);
 
 	seq_printf(file, "%17s: %2d\n", "Baseband Hang",
 		   sc->debug.stats.reset[RESET_TYPE_BB_HANG]);
@@ -833,58 +806,6 @@ void ath_debug_stat_tx(struct ath_softc *sc, struct ath_buf *bf,
 		TX_STAT_INC(qnum, delim_underrun);
 }
 
-static int open_file_xmit(struct inode *inode, struct file *f)
-{
-	return single_open(f, read_file_xmit, inode->i_private);
-}
-
-static const struct file_operations fops_xmit = {
-	.read = seq_read,
-	.open = open_file_xmit,
-	.owner = THIS_MODULE,
-	.llseek = seq_lseek,
-	.release = single_release,
-};
-
-static int open_file_queues(struct inode *inode, struct file *f)
-{
-	return single_open(f, read_file_queues, inode->i_private);
-}
-
-static const struct file_operations fops_queues = {
-	.read = seq_read,
-	.open = open_file_queues,
-	.owner = THIS_MODULE,
-	.llseek = seq_lseek,
-	.release = single_release,
-};
-
-static int open_file_misc(struct inode *inode, struct file *f)
-{
-	return single_open(f, read_file_misc, inode->i_private);
-}
-
-static const struct file_operations fops_misc = {
-	.read = seq_read,
-	.open = open_file_misc,
-	.owner = THIS_MODULE,
-	.llseek = seq_lseek,
-	.release = single_release,
-};
-
-static int open_file_reset(struct inode *inode, struct file *f)
-{
-	return single_open(f, read_file_reset, inode->i_private);
-}
-
-static const struct file_operations fops_reset = {
-	.read = seq_read,
-	.open = open_file_reset,
-	.owner = THIS_MODULE,
-	.llseek = seq_lseek,
-	.release = single_release,
-};
-
 void ath_debug_stat_rx(struct ath_softc *sc, struct ath_rx_status *rs)
 {
 	ath9k_cmn_debug_stat_rx(&sc->debug.stats.rxstats, rs);
@@ -1014,7 +935,7 @@ static const struct file_operations fops_regdump = {
 
 static int read_file_dump_nfcal(struct seq_file *file, void *data)
 {
-	struct ath_softc *sc = file->private;
+	struct ath_softc *sc = dev_get_drvdata(file->private);
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath9k_nfcal_hist *h = sc->cur_chan->caldata.nfCalHist;
 	struct ath_common *common = ath9k_hw_common(ah);
@@ -1256,14 +1177,14 @@ int ath9k_init_debug(struct ath_hw *ah)
 	ath9k_tx99_init_debug(sc);
 	ath9k_spectral_init_debug(sc);
 
-	debugfs_create_file("dma", S_IRUSR, sc->debug.debugfs_phy, sc,
-			    &fops_dma);
-	debugfs_create_file("interrupt", S_IRUSR, sc->debug.debugfs_phy, sc,
-			    &fops_interrupt);
-	debugfs_create_file("xmit", S_IRUSR, sc->debug.debugfs_phy, sc,
-			    &fops_xmit);
-	debugfs_create_file("queues", S_IRUSR, sc->debug.debugfs_phy, sc,
-			    &fops_queues);
+	debugfs_create_devm_seqfile(sc->dev, "dma", sc->debug.debugfs_phy,
+				    read_file_dma);
+	debugfs_create_devm_seqfile(sc->dev, "interrupt", sc->debug.debugfs_phy,
+				    read_file_interrupt);
+	debugfs_create_devm_seqfile(sc->dev, "xmit", sc->debug.debugfs_phy,
+				    read_file_xmit);
+	debugfs_create_devm_seqfile(sc->dev, "queues", sc->debug.debugfs_phy,
+				    read_file_queues);
 	debugfs_create_u32("qlen_bk", S_IRUSR | S_IWUSR, sc->debug.debugfs_phy,
 			   &sc->tx.txq_max_pending[IEEE80211_AC_BK]);
 	debugfs_create_u32("qlen_be", S_IRUSR | S_IWUSR, sc->debug.debugfs_phy,
@@ -1272,10 +1193,10 @@ int ath9k_init_debug(struct ath_hw *ah)
 			   &sc->tx.txq_max_pending[IEEE80211_AC_VI]);
 	debugfs_create_u32("qlen_vo", S_IRUSR | S_IWUSR, sc->debug.debugfs_phy,
 			   &sc->tx.txq_max_pending[IEEE80211_AC_VO]);
-	debugfs_create_file("misc", S_IRUSR, sc->debug.debugfs_phy, sc,
-			    &fops_misc);
-	debugfs_create_file("reset", S_IRUSR, sc->debug.debugfs_phy, sc,
-			    &fops_reset);
+	debugfs_create_devm_seqfile(sc->dev, "misc", sc->debug.debugfs_phy,
+				    read_file_misc);
+	debugfs_create_devm_seqfile(sc->dev, "reset", sc->debug.debugfs_phy,
+				    read_file_reset);
 
 	ath9k_cmn_debug_recv(sc->debug.debugfs_phy, &sc->debug.stats.rxstats);
 	ath9k_cmn_debug_phy_err(sc->debug.debugfs_phy, &sc->debug.stats.rxstats);
@@ -1297,8 +1218,9 @@ int ath9k_init_debug(struct ath_hw *ah)
 			    &ah->config.cwm_ignore_extcca);
 	debugfs_create_file("regdump", S_IRUSR, sc->debug.debugfs_phy, sc,
 			    &fops_regdump);
-	debugfs_create_file("dump_nfcal", S_IRUSR, sc->debug.debugfs_phy, sc,
-			    &fops_dump_nfcal);
+	debugfs_create_devm_seqfile(sc->dev, "dump_nfcal",
+				    sc->debug.debugfs_phy,
+				    read_file_dump_nfcal);
 
 	ath9k_cmn_debug_base_eeprom(sc->debug.debugfs_phy, sc->sc_ah);
 	ath9k_cmn_debug_modal_eeprom(sc->debug.debugfs_phy, sc->sc_ah);
diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
index c018dea..90c9e3c 100644
--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -856,6 +856,7 @@ static int ath_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	sc = hw->priv;
 	sc->hw = hw;
 	sc->dev = &pdev->dev;
+	dev_set_drvdata(sc->dev, sc);
 	sc->mem = pcim_iomap_table(pdev)[0];
 	sc->driver_data = id->driver_data;
 
-- 
1.9.1

