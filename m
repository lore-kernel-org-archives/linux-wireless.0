Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:36841 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752988Ab0CIH4G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Mar 2010 02:56:06 -0500
Received: from vs3017.wh2.ocn.ne.jp (125.206.180.250)
	by mail30f.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 1-086551361
	for <linux-wireless@vger.kernel.org>; Tue,  9 Mar 2010 16:56:01 +0900 (JST)
Subject: [PATCH 09/13] ath5k: add debugfs file frameerrors
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Date: Tue, 09 Mar 2010 16:56:00 +0900
Message-ID: <20100309075600.30616.94051.stgit@void>
In-Reply-To: <20100309075124.30616.40896.stgit@void>
References: <20100309075124.30616.40896.stgit@void>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

add a debugfs file to see different RX and TX errors as reported in our status
descriptors. this can help to diagnose driver problems.

statistics can be cleared by writing 'clear' into the frameerrors file.

example:

# cat /sys/kernel/debug/ath5k/phy0/frameerrors
RX
---------------------
CRC     27      (11%)
PHY     3       (1%)
FIFO    0       (0%)
decrypt 0       (0%)
MIC     0       (0%)
process 0       (0%)
jumbo   0       (0%)
[RX all 245]

TX
---------------------
retry   2       (9%)
FIFO    0       (0%)
filter  0       (0%)
[TX all 21]

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 drivers/net/wireless/ath/ath5k/base.c  |   23 ++++++-
 drivers/net/wireless/ath/ath5k/base.h  |   12 ++++
 drivers/net/wireless/ath/ath5k/debug.c |  106 ++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath5k/debug.h |    1 
 4 files changed, 140 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index e63cca9..9c42498 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -1843,18 +1843,28 @@ ath5k_tasklet_rx(unsigned long data)
 			break;
 		else if (unlikely(ret)) {
 			ATH5K_ERR(sc, "error in processing rx descriptor\n");
+			sc->stats.rxerr_proc++;
 			spin_unlock(&sc->rxbuflock);
 			return;
 		}
 
+		sc->stats.rx_all_count++;
+
 		if (unlikely(rs.rs_more)) {
 			ATH5K_WARN(sc, "unsupported jumbo\n");
+			sc->stats.rxerr_jumbo++;
 			goto next;
 		}
 
 		if (unlikely(rs.rs_status)) {
-			if (rs.rs_status & AR5K_RXERR_PHY)
+			if (rs.rs_status & AR5K_RXERR_CRC)
+				sc->stats.rxerr_crc++;
+			if (rs.rs_status & AR5K_RXERR_FIFO)
+				sc->stats.rxerr_fifo++;
+			if (rs.rs_status & AR5K_RXERR_PHY) {
+				sc->stats.rxerr_phy++;
 				goto next;
+			}
 			if (rs.rs_status & AR5K_RXERR_DECRYPT) {
 				/*
 				 * Decrypt error.  If the error occurred
@@ -1866,12 +1876,14 @@ ath5k_tasklet_rx(unsigned long data)
 				 *
 				 * XXX do key cache faulting
 				 */
+				sc->stats.rxerr_decrypt++;
 				if (rs.rs_keyix == AR5K_RXKEYIX_INVALID &&
 				    !(rs.rs_status & AR5K_RXERR_CRC))
 					goto accept;
 			}
 			if (rs.rs_status & AR5K_RXERR_MIC) {
 				rx_flag |= RX_FLAG_MMIC_ERROR;
+				sc->stats.rxerr_mic++;
 				goto accept;
 			}
 
@@ -2001,6 +2013,7 @@ ath5k_tx_processq(struct ath5k_softc *sc, struct ath5k_txq *txq)
 			break;
 		}
 
+		sc->stats.tx_all_count++;
 		skb = bf->skb;
 		info = IEEE80211_SKB_CB(skb);
 		bf->skb = NULL;
@@ -2027,8 +2040,14 @@ ath5k_tx_processq(struct ath5k_softc *sc, struct ath5k_txq *txq)
 
 		if (unlikely(ts.ts_status)) {
 			sc->ll_stats.dot11ACKFailureCount++;
-			if (ts.ts_status & AR5K_TXERR_FILT)
+			if (ts.ts_status & AR5K_TXERR_FILT) {
 				info->flags |= IEEE80211_TX_STAT_TX_FILTERED;
+				sc->stats.txerr_filt++;
+			}
+			if (ts.ts_status & AR5K_TXERR_XRETRY)
+				sc->stats.txerr_retry++;
+			if (ts.ts_status & AR5K_TXERR_FIFO)
+				sc->stats.txerr_fifo++;
 		} else {
 			info->flags |= IEEE80211_TX_STAT_ACK;
 			info->status.ack_signal = ts.ts_rssi;
diff --git a/drivers/net/wireless/ath/ath5k/base.h b/drivers/net/wireless/ath/ath5k/base.h
index ca52584..33f1d8b 100644
--- a/drivers/net/wireless/ath/ath5k/base.h
+++ b/drivers/net/wireless/ath/ath5k/base.h
@@ -109,6 +109,18 @@ struct ath5k_rfkill {
 struct ath5k_statistics {
 	unsigned int antenna_rx[5];	/* frames count per antenna RX */
 	unsigned int antenna_tx[5];	/* frames count per antenna TX */
+	unsigned int rx_all_count;	/* all RX frames, including errors */
+	unsigned int tx_all_count;	/* all TX frames, including errors */
+	unsigned int rxerr_crc;
+	unsigned int rxerr_phy;
+	unsigned int rxerr_fifo;
+	unsigned int rxerr_decrypt;
+	unsigned int rxerr_mic;
+	unsigned int rxerr_proc;
+	unsigned int rxerr_jumbo;
+	unsigned int txerr_retry;
+	unsigned int txerr_fifo;
+	unsigned int txerr_filt;
 };
 
 #if CHAN_DEBUG
diff --git a/drivers/net/wireless/ath/ath5k/debug.c b/drivers/net/wireless/ath/ath5k/debug.c
index 236f20f..bccd4a7 100644
--- a/drivers/net/wireless/ath/ath5k/debug.c
+++ b/drivers/net/wireless/ath/ath5k/debug.c
@@ -465,6 +465,106 @@ static const struct file_operations fops_antenna = {
 };
 
 
+/* debugfs: frameerrors */
+
+static ssize_t read_file_frameerrors(struct file *file, char __user *user_buf,
+				   size_t count, loff_t *ppos)
+{
+	struct ath5k_softc *sc = file->private_data;
+	struct ath5k_statistics *st = &sc->stats;
+	char buf[700];
+	unsigned int len = 0;
+
+	len += snprintf(buf+len, sizeof(buf)-len,
+			"RX\n---------------------\n");
+	len += snprintf(buf+len, sizeof(buf)-len, "CRC\t%d\t(%d%%)\n",
+			st->rxerr_crc,
+			st->rx_all_count > 0 ?
+				st->rxerr_crc*100/st->rx_all_count : 0);
+	len += snprintf(buf+len, sizeof(buf)-len, "PHY\t%d\t(%d%%)\n",
+			st->rxerr_phy,
+			st->rx_all_count > 0 ?
+				st->rxerr_phy*100/st->rx_all_count : 0);
+	len += snprintf(buf+len, sizeof(buf)-len, "FIFO\t%d\t(%d%%)\n",
+			st->rxerr_fifo,
+			st->rx_all_count > 0 ?
+				st->rxerr_fifo*100/st->rx_all_count : 0);
+	len += snprintf(buf+len, sizeof(buf)-len, "decrypt\t%d\t(%d%%)\n",
+			st->rxerr_decrypt,
+			st->rx_all_count > 0 ?
+				st->rxerr_decrypt*100/st->rx_all_count : 0);
+	len += snprintf(buf+len, sizeof(buf)-len, "MIC\t%d\t(%d%%)\n",
+			st->rxerr_mic,
+			st->rx_all_count > 0 ?
+				st->rxerr_mic*100/st->rx_all_count : 0);
+	len += snprintf(buf+len, sizeof(buf)-len, "process\t%d\t(%d%%)\n",
+			st->rxerr_proc,
+			st->rx_all_count > 0 ?
+				st->rxerr_proc*100/st->rx_all_count : 0);
+	len += snprintf(buf+len, sizeof(buf)-len, "jumbo\t%d\t(%d%%)\n",
+			st->rxerr_jumbo,
+			st->rx_all_count > 0 ?
+				st->rxerr_jumbo*100/st->rx_all_count : 0);
+	len += snprintf(buf+len, sizeof(buf)-len, "[RX all\t%d]\n",
+			st->rx_all_count);
+
+	len += snprintf(buf+len, sizeof(buf)-len,
+			"\nTX\n---------------------\n");
+	len += snprintf(buf+len, sizeof(buf)-len, "retry\t%d\t(%d%%)\n",
+			st->txerr_retry,
+			st->tx_all_count > 0 ?
+				st->txerr_retry*100/st->tx_all_count : 0);
+	len += snprintf(buf+len, sizeof(buf)-len, "FIFO\t%d\t(%d%%)\n",
+			st->txerr_fifo,
+			st->tx_all_count > 0 ?
+				st->txerr_fifo*100/st->tx_all_count : 0);
+	len += snprintf(buf+len, sizeof(buf)-len, "filter\t%d\t(%d%%)\n",
+			st->txerr_filt,
+			st->tx_all_count > 0 ?
+				st->txerr_filt*100/st->tx_all_count : 0);
+	len += snprintf(buf+len, sizeof(buf)-len, "[TX all\t%d]\n",
+			st->tx_all_count);
+
+	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
+}
+
+static ssize_t write_file_frameerrors(struct file *file,
+				 const char __user *userbuf,
+				 size_t count, loff_t *ppos)
+{
+	struct ath5k_softc *sc = file->private_data;
+	struct ath5k_statistics *st = &sc->stats;
+	char buf[20];
+
+	if (copy_from_user(buf, userbuf, min(count, sizeof(buf))))
+		return -EFAULT;
+
+	if (strncmp(buf, "clear", 5) == 0) {
+		st->rxerr_crc = 0;
+		st->rxerr_phy = 0;
+		st->rxerr_fifo = 0;
+		st->rxerr_decrypt = 0;
+		st->rxerr_mic = 0;
+		st->rxerr_proc = 0;
+		st->rxerr_jumbo = 0;
+		st->rx_all_count = 0;
+		st->txerr_retry = 0;
+		st->txerr_fifo = 0;
+		st->txerr_filt = 0;
+		st->tx_all_count = 0;
+		printk(KERN_INFO "ath5k debug: cleared frameerrors stats\n");
+	}
+	return count;
+}
+
+static const struct file_operations fops_frameerrors = {
+	.read = read_file_frameerrors,
+	.write = write_file_frameerrors,
+	.open = ath5k_debugfs_open,
+	.owner = THIS_MODULE,
+};
+
+
 /* init */
 
 void
@@ -498,6 +598,11 @@ ath5k_debug_init_device(struct ath5k_softc *sc)
 	sc->debug.debugfs_antenna = debugfs_create_file("antenna",
 				S_IWUSR | S_IRUSR,
 				sc->debug.debugfs_phydir, sc, &fops_antenna);
+
+	sc->debug.debugfs_frameerrors = debugfs_create_file("frameerrors",
+				S_IWUSR | S_IRUSR,
+				sc->debug.debugfs_phydir, sc,
+				&fops_frameerrors);
 }
 
 void
@@ -514,6 +619,7 @@ ath5k_debug_finish_device(struct ath5k_softc *sc)
 	debugfs_remove(sc->debug.debugfs_beacon);
 	debugfs_remove(sc->debug.debugfs_reset);
 	debugfs_remove(sc->debug.debugfs_antenna);
+	debugfs_remove(sc->debug.debugfs_frameerrors);
 	debugfs_remove(sc->debug.debugfs_phydir);
 }
 
diff --git a/drivers/net/wireless/ath/ath5k/debug.h b/drivers/net/wireless/ath/ath5k/debug.h
index 0186127..da24ff5 100644
--- a/drivers/net/wireless/ath/ath5k/debug.h
+++ b/drivers/net/wireless/ath/ath5k/debug.h
@@ -75,6 +75,7 @@ struct ath5k_dbg_info {
 	struct dentry		*debugfs_beacon;
 	struct dentry		*debugfs_reset;
 	struct dentry		*debugfs_antenna;
+	struct dentry		*debugfs_frameerrors;
 };
 
 /**

