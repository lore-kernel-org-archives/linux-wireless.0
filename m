Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:52863 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748AbaL0NNF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Dec 2014 08:13:05 -0500
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>,
	<ath9k-devel@lists.ath9k.org>
Subject: [PATCH] ath: ath9k: use debugfs_create_devm_seqfile() helper for seq_file entries
Date: Sat, 27 Dec 2014 14:13:00 +0100
Message-ID: <1419685980-4728-1-git-send-email-arend@broadcom.com> (sfid-20141227_141703_576558_1C06E20E)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use the helper to get rid of the file operations per debugfs file. The
device driver data contains struct ieee80211_hw pointer and the
struct ath9k_softc pointer is assigned to ieee80211_hw::priv so it can
be accessed in the seq_file read operation.

Cc: ath9k-devel@lists.ath9k.org
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
Hi Kalle,

This patch was reverted in the driver-core repository as I overlooked
the use of driver data and caused ath9k driver to crash. I believe this
revised patch properly uses it now although I have no ath9k hardware to
test this. So I hope some ath9k developers out there can give this patch
a run for its money. It compiles and no checkpatch or sparse warnings.

The patch applies to the master branch of the wireless-drivers-next
repository.

Regards,
Arend
---
 drivers/net/wireless/ath/ath9k/debug.c | 129 ++++++++-------------------------
 1 file changed, 29 insertions(+), 100 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index c43e2ad..1bed9d7 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -403,7 +403,8 @@ static const struct file_operations fops_antenna_diversity = {
 
 static int read_file_dma(struct seq_file *file, void *data)
 {
-	struct ath_softc *sc = file->private;
+	struct ieee80211_hw *hw = dev_get_drvdata(file->private);
+	struct ath_softc *sc = hw->priv;
 	struct ath_hw *ah = sc->sc_ah;
 	u32 val[ATH9K_NUM_DMA_DEBUG_REGS];
 	int i, qcuOffset = 0, dcuOffset = 0;
@@ -470,20 +471,6 @@ static int read_file_dma(struct seq_file *file, void *data)
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
@@ -539,7 +526,8 @@ void ath_debug_stat_interrupt(struct ath_softc *sc, enum ath9k_int status)
 
 static int read_file_interrupt(struct seq_file *file, void *data)
 {
-	struct ath_softc *sc = file->private;
+	struct ieee80211_hw *hw = dev_get_drvdata(file->private);
+	struct ath_softc *sc = hw->priv;
 
 #define PR_IS(a, s)						\
 	do {							\
@@ -600,22 +588,10 @@ static int read_file_interrupt(struct seq_file *file, void *data)
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
+	struct ieee80211_hw *hw = dev_get_drvdata(file->private);
+	struct ath_softc *sc = hw->priv;
 
 	seq_printf(file, "%30s %10s%10s%10s\n\n", "BE", "BK", "VI", "VO");
 
@@ -661,7 +637,8 @@ static void print_queue(struct ath_softc *sc, struct ath_txq *txq,
 
 static int read_file_queues(struct seq_file *file, void *data)
 {
-	struct ath_softc *sc = file->private;
+	struct ieee80211_hw *hw = dev_get_drvdata(file->private);
+	struct ath_softc *sc = hw->priv;
 	struct ath_txq *txq;
 	int i;
 	static const char *qname[4] = {
@@ -682,7 +659,8 @@ static int read_file_queues(struct seq_file *file, void *data)
 
 static int read_file_misc(struct seq_file *file, void *data)
 {
-	struct ath_softc *sc = file->private;
+	struct ieee80211_hw *hw = dev_get_drvdata(file->private);
+	struct ath_softc *sc = hw->priv;
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	struct ath9k_vif_iter_data iter_data;
 	struct ath_chanctx *ctx;
@@ -773,7 +751,8 @@ static int read_file_misc(struct seq_file *file, void *data)
 
 static int read_file_reset(struct seq_file *file, void *data)
 {
-	struct ath_softc *sc = file->private;
+	struct ieee80211_hw *hw = dev_get_drvdata(file->private);
+	struct ath_softc *sc = hw->priv;
 	static const char * const reset_cause[__RESET_TYPE_MAX] = {
 		[RESET_TYPE_BB_HANG] = "Baseband Hang",
 		[RESET_TYPE_BB_WATCHDOG] = "Baseband Watchdog",
@@ -837,58 +816,6 @@ void ath_debug_stat_tx(struct ath_softc *sc, struct ath_buf *bf,
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
@@ -1018,7 +945,8 @@ static const struct file_operations fops_regdump = {
 
 static int read_file_dump_nfcal(struct seq_file *file, void *data)
 {
-	struct ath_softc *sc = file->private;
+	struct ieee80211_hw *hw = dev_get_drvdata(file->private);
+	struct ath_softc *sc = hw->priv;
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath9k_nfcal_hist *h = sc->cur_chan->caldata.nfCalHist;
 	struct ath_common *common = ath9k_hw_common(ah);
@@ -1329,14 +1257,14 @@ int ath9k_init_debug(struct ath_hw *ah)
 	ath9k_tx99_init_debug(sc);
 	ath9k_cmn_spectral_init_debug(&sc->spec_priv, sc->debug.debugfs_phy);
 
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
@@ -1345,10 +1273,10 @@ int ath9k_init_debug(struct ath_hw *ah)
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
@@ -1370,8 +1298,9 @@ int ath9k_init_debug(struct ath_hw *ah)
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
-- 
1.9.1

