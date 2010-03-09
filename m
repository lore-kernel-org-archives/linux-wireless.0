Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:4717 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751808Ab0CIHzU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Mar 2010 02:55:20 -0500
Received: from vs3012.wh2.ocn.ne.jp (125.206.180.183)
	by mail30g.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 0-0340121318
	for <linux-wireless@vger.kernel.org>; Tue,  9 Mar 2010 16:55:19 +0900 (JST)
Subject: [PATCH 01/13] ath5k: add antenna statistics and debugfs file for
	antenna settings
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Date: Tue, 09 Mar 2010 16:55:17 +0900
Message-ID: <20100309075517.30616.25838.stgit@void>
In-Reply-To: <20100309075124.30616.40896.stgit@void>
References: <20100309075124.30616.40896.stgit@void>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

keep statistics about which antenna was used for TX and RX. this is used only
for debugging right now, but might have other applications later.

add a new file 'antenna' in debugfs (/sys/kernel/debug/ath5k/phy0/antenna) to show
antenna use statistics and antenna diversity related register values. it can
also be used to set the antenna mode until we have proper support for that in
iw:
  - echo diversity > antenna: use default antenna mode (RX and TX diversity)
  - echo fixed-a > antenna: use fixed antenna A for RX and TX
  - echo fixed-b > antenna: use fixed antenna B for RX and TX
  - echo clear > antenna: reset antenna statistics

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 drivers/net/wireless/ath/ath5k/base.c  |   11 +++
 drivers/net/wireless/ath/ath5k/base.h  |    8 ++
 drivers/net/wireless/ath/ath5k/debug.c |  106 ++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath5k/debug.h |    1 
 4 files changed, 126 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 2468c64..85eb670 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -1942,6 +1942,12 @@ accept:
 		rxs->signal = rxs->noise + rs.rs_rssi;
 
 		rxs->antenna = rs.rs_antenna;
+
+		if (rs.rs_antenna > 0 && rs.rs_antenna < 5)
+			sc->stats.antenna_rx[rs.rs_antenna]++;
+		else
+			sc->stats.antenna_rx[0]++; /* invalid */
+
 		rxs->rate_idx = ath5k_hw_to_driver_rix(sc, rs.rs_rate);
 		rxs->flag |= ath5k_rx_decrypted(sc, ds, skb, &rs);
 
@@ -2029,6 +2035,11 @@ ath5k_tx_processq(struct ath5k_softc *sc, struct ath5k_txq *txq)
 			info->status.ack_signal = ts.ts_rssi;
 		}
 
+		if (ts.ts_antenna > 0 && ts.ts_antenna < 5)
+			sc->stats.antenna_tx[ts.ts_antenna]++;
+		else
+			sc->stats.antenna_tx[0]++; /* invalid */
+
 		ieee80211_tx_status(sc->hw, skb);
 
 		spin_lock(&sc->txbuflock);
diff --git a/drivers/net/wireless/ath/ath5k/base.h b/drivers/net/wireless/ath/ath5k/base.h
index 7e1a88a..ca52584 100644
--- a/drivers/net/wireless/ath/ath5k/base.h
+++ b/drivers/net/wireless/ath/ath5k/base.h
@@ -105,6 +105,12 @@ struct ath5k_rfkill {
 	struct tasklet_struct toggleq;
 };
 
+/* statistics (only used for debugging now) */
+struct ath5k_statistics {
+	unsigned int antenna_rx[5];	/* frames count per antenna RX */
+	unsigned int antenna_tx[5];	/* frames count per antenna TX */
+};
+
 #if CHAN_DEBUG
 #define ATH_CHAN_MAX	(26+26+26+200+200)
 #else
@@ -191,6 +197,8 @@ struct ath5k_softc {
 	int 			power_level;	/* Requested tx power in dbm */
 	bool			assoc;		/* associate state */
 	bool			enable_beacon;	/* true if beacons are on */
+
+	struct ath5k_statistics	stats;
 };
 
 #define ath5k_hw_hasbssidmask(_ah) \
diff --git a/drivers/net/wireless/ath/ath5k/debug.c b/drivers/net/wireless/ath/ath5k/debug.c
index 747508c..236f20f 100644
--- a/drivers/net/wireless/ath/ath5k/debug.c
+++ b/drivers/net/wireless/ath/ath5k/debug.c
@@ -364,6 +364,107 @@ static const struct file_operations fops_debug = {
 };
 
 
+/* debugfs: antenna */
+
+static ssize_t read_file_antenna(struct file *file, char __user *user_buf,
+				   size_t count, loff_t *ppos)
+{
+	struct ath5k_softc *sc = file->private_data;
+	char buf[700];
+	unsigned int len = 0;
+	unsigned int i;
+	unsigned int v;
+
+	len += snprintf(buf+len, sizeof(buf)-len, "antenna mode\t%d\n",
+		sc->ah->ah_ant_mode);
+	len += snprintf(buf+len, sizeof(buf)-len, "default antenna\t%d\n",
+		sc->ah->ah_def_ant);
+	len += snprintf(buf+len, sizeof(buf)-len, "tx antenna\t%d\n",
+		sc->ah->ah_tx_ant);
+
+	len += snprintf(buf+len, sizeof(buf)-len, "\nANTENNA\t\tRX\tTX\n");
+	for (i = 1; i < ARRAY_SIZE(sc->stats.antenna_rx); i++) {
+		len += snprintf(buf+len, sizeof(buf)-len,
+			"[antenna %d]\t%d\t%d\n",
+			i, sc->stats.antenna_rx[i], sc->stats.antenna_tx[i]);
+	}
+	len += snprintf(buf+len, sizeof(buf)-len, "[invalid]\t%d\t%d\n",
+			sc->stats.antenna_rx[0], sc->stats.antenna_tx[0]);
+
+	v = ath5k_hw_reg_read(sc->ah, AR5K_DEFAULT_ANTENNA);
+	len += snprintf(buf+len, sizeof(buf)-len,
+			"\nAR5K_DEFAULT_ANTENNA\t0x%08x\n", v);
+
+	v = ath5k_hw_reg_read(sc->ah, AR5K_STA_ID1);
+	len += snprintf(buf+len, sizeof(buf)-len,
+		"AR5K_STA_ID1_DEFAULT_ANTENNA\t%d\n",
+		(v & AR5K_STA_ID1_DEFAULT_ANTENNA) != 0);
+	len += snprintf(buf+len, sizeof(buf)-len,
+		"AR5K_STA_ID1_DESC_ANTENNA\t%d\n",
+		(v & AR5K_STA_ID1_DESC_ANTENNA) != 0);
+	len += snprintf(buf+len, sizeof(buf)-len,
+		"AR5K_STA_ID1_RTS_DEF_ANTENNA\t%d\n",
+		(v & AR5K_STA_ID1_RTS_DEF_ANTENNA) != 0);
+	len += snprintf(buf+len, sizeof(buf)-len,
+		"AR5K_STA_ID1_SELFGEN_DEF_ANT\t%d\n",
+		(v & AR5K_STA_ID1_SELFGEN_DEF_ANT) != 0);
+
+	v = ath5k_hw_reg_read(sc->ah, AR5K_PHY_AGCCTL);
+	len += snprintf(buf+len, sizeof(buf)-len,
+		"\nAR5K_PHY_AGCCTL_OFDM_DIV_DIS\t%d\n",
+		(v & AR5K_PHY_AGCCTL_OFDM_DIV_DIS) != 0);
+
+	v = ath5k_hw_reg_read(sc->ah, AR5K_PHY_RESTART);
+	len += snprintf(buf+len, sizeof(buf)-len,
+		"AR5K_PHY_RESTART_DIV_GC\t\t%x\n",
+		(v & AR5K_PHY_RESTART_DIV_GC) >> AR5K_PHY_RESTART_DIV_GC_S);
+
+	v = ath5k_hw_reg_read(sc->ah, AR5K_PHY_FAST_ANT_DIV);
+	len += snprintf(buf+len, sizeof(buf)-len,
+		"AR5K_PHY_FAST_ANT_DIV_EN\t%d\n",
+		(v & AR5K_PHY_FAST_ANT_DIV_EN) != 0);
+
+	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
+}
+
+static ssize_t write_file_antenna(struct file *file,
+				 const char __user *userbuf,
+				 size_t count, loff_t *ppos)
+{
+	struct ath5k_softc *sc = file->private_data;
+	unsigned int i;
+	char buf[20];
+
+	if (copy_from_user(buf, userbuf, min(count, sizeof(buf))))
+		return -EFAULT;
+
+	if (strncmp(buf, "diversity", 9) == 0) {
+		ath5k_hw_set_antenna_mode(sc->ah, AR5K_ANTMODE_DEFAULT);
+		printk(KERN_INFO "ath5k debug: enable diversity\n");
+	} else if (strncmp(buf, "fixed-a", 7) == 0) {
+		ath5k_hw_set_antenna_mode(sc->ah, AR5K_ANTMODE_FIXED_A);
+		printk(KERN_INFO "ath5k debugfs: fixed antenna A\n");
+	} else if (strncmp(buf, "fixed-b", 7) == 0) {
+		ath5k_hw_set_antenna_mode(sc->ah, AR5K_ANTMODE_FIXED_B);
+		printk(KERN_INFO "ath5k debug: fixed antenna B\n");
+	} else if (strncmp(buf, "clear", 5) == 0) {
+		for (i = 0; i < ARRAY_SIZE(sc->stats.antenna_rx); i++) {
+			sc->stats.antenna_rx[i] = 0;
+			sc->stats.antenna_tx[i] = 0;
+		}
+		printk(KERN_INFO "ath5k debug: cleared antenna stats\n");
+	}
+	return count;
+}
+
+static const struct file_operations fops_antenna = {
+	.read = read_file_antenna,
+	.write = write_file_antenna,
+	.open = ath5k_debugfs_open,
+	.owner = THIS_MODULE,
+};
+
+
 /* init */
 
 void
@@ -393,6 +494,10 @@ ath5k_debug_init_device(struct ath5k_softc *sc)
 
 	sc->debug.debugfs_reset = debugfs_create_file("reset", S_IWUSR,
 				sc->debug.debugfs_phydir, sc, &fops_reset);
+
+	sc->debug.debugfs_antenna = debugfs_create_file("antenna",
+				S_IWUSR | S_IRUSR,
+				sc->debug.debugfs_phydir, sc, &fops_antenna);
 }
 
 void
@@ -408,6 +513,7 @@ ath5k_debug_finish_device(struct ath5k_softc *sc)
 	debugfs_remove(sc->debug.debugfs_registers);
 	debugfs_remove(sc->debug.debugfs_beacon);
 	debugfs_remove(sc->debug.debugfs_reset);
+	debugfs_remove(sc->debug.debugfs_antenna);
 	debugfs_remove(sc->debug.debugfs_phydir);
 }
 
diff --git a/drivers/net/wireless/ath/ath5k/debug.h b/drivers/net/wireless/ath/ath5k/debug.h
index 66f69f0..0186127 100644
--- a/drivers/net/wireless/ath/ath5k/debug.h
+++ b/drivers/net/wireless/ath/ath5k/debug.h
@@ -74,6 +74,7 @@ struct ath5k_dbg_info {
 	struct dentry		*debugfs_registers;
 	struct dentry		*debugfs_beacon;
 	struct dentry		*debugfs_reset;
+	struct dentry		*debugfs_antenna;
 };
 
 /**

