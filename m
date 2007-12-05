Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:13812 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751821AbXLEKt6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Dec 2007 05:49:58 -0500
From: bruno randolf <bruno@thinktube.com>
To: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH 1/1] ath5k: add debugfs entries for registers, tsf, beacon
Date: Wed, 5 Dec 2007 19:50:08 +0900
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, mcgrof@gmail.com, mickflemm@gmail.com
References: <1196839665-14178-1-git-send-email-bruno@thinktube.com> <47566B95.5080101@gmail.com>
In-Reply-To: <47566B95.5080101@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Message-Id: <200712051950.08672.bruno@thinktube.com> (sfid-20071205_105014_508343_7148076E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 05 December 2007 18:12:53 Jiri Slaby wrote:
> > +	char buf[5000];
>
> Doh, 4k stacks on i386! You can't do this safely.

ohh! i didn't know.

> I think we can use seq_* stuff here instead, see below.

> Put those register in the array, and from .seq_next, return &array[++*pos]
> or NULL for the last member. .seq_show will contain the REG_PRINT_APPEND
> macro contents.

thanks for the hint. i changed the patch to do that now. but unfortunately by 
doing so we loose the ability to print the register names.

anyways, here is the new version:


ath5k: add debugfs entries for registers, tsf, beacon

'registers' prints the value of some registers. this should be adapted to what
we actually need later.

'tsf' prints the current HW TSF. writing "reset" into the file will reset the
TSF.

'beacon' shows beacon relevant registers. writing "enable" into the file will
enable beacons by writing AR5K_BEACON_ENABLE, "disable" will disable that bit.

'reset' performs a HW reset.

Changes-licensed-under: GPL
Signed-off-by: Bruno Randolf <bruno@thinktube.com>

diff --git a/drivers/net/wireless/ath5k/debug.c 
b/drivers/net/wireless/ath5k/debug.c
index 7427506..27a246c 100644
--- a/drivers/net/wireless/ath5k/debug.c
+++ b/drivers/net/wireless/ath5k/debug.c
@@ -66,10 +66,192 @@ module_param_named(debug, ath5k_debug, uint, 0);
 
 #if ATH5K_DEBUG
 
+#include <linux/seq_file.h>
 #include "reg.h"
 
+/* this assumes variables buf for buffer and len for count */
+#define REG_PRINT_APPEND(_reg) \
+	len += snprintf(buf+len, sizeof(buf)-len, "%-30s0x%08x\n", #_reg, \
+		ath5k_hw_reg_read(sc->ah, _reg));
+
+
 static struct dentry *ath5k_global_debugfs;
 
+
+static int ath5k_debugfs_open(struct inode *inode, struct file *file)
+{
+	file->private_data = inode->i_private;
+	return 0;
+}
+
+
+/* debugfs: registers */
+
+/* just a few random registers, might want to add more */
+static int regs[] = {
+	AR5K_CR, AR5K_RXDP, AR5K_CFG, AR5K_IER, AR5K_BCR, AR5K_RTSD0,
+	AR5K_RTSD1, AR5K_TXCFG, AR5K_RXCFG, AR5K_RXJLA, AR5K_MIBC, AR5K_TOPS,
+	AR5K_RXNOFRM, AR5K_TXNOFRM, AR5K_RPGTO, AR5K_RFCNT, AR5K_MISC,
+	AR5K_QCUDCU_CLKGT,
+	AR5K_ISR, AR5K_PISR, AR5K_SISR0, AR5K_SISR1, AR5K_SISR2, AR5K_SISR3,
+	AR5K_SISR4, AR5K_IMR, AR5K_PIMR, AR5K_SIMR0, AR5K_SIMR1, AR5K_SIMR2,
+	AR5K_SIMR3, AR5K_SIMR4,
+	AR5K_DCM_ADDR, AR5K_DCCFG, AR5K_CCFG, AR5K_CPC0, AR5K_CPC1, AR5K_CPC2,
+	AR5K_CPC3, AR5K_CPCORN, AR5K_RESET_CTL, AR5K_SLEEP_CTL, AR5K_INTPEND,
+	AR5K_SFR, AR5K_PCICFG, AR5K_GPIOCR, AR5K_GPIODO, AR5K_SREV
+};
+
+static void *reg_start(struct seq_file *seq, loff_t *pos)
+{
+	return *pos < ARRAY_SIZE(regs) ? &regs[*pos] : 0;
+}
+
+static void reg_stop(struct seq_file *seq, void *p)
+{
+	/* nothing to do */
+}
+
+static void *reg_next(struct seq_file *seq, void *p, loff_t *pos)
+{
+	++*pos;
+	return *pos < ARRAY_SIZE(regs) ? &regs[*pos] : 0;
+}
+
+static int reg_show(struct seq_file *seq, void *p)
+{
+	struct ath5k_softc *sc = seq->private;
+	seq_printf(seq, "0x%04x = 0x%08x\n", *(int *)p,
+		ath5k_hw_reg_read(sc->ah, *(int *)p));
+	return 0;
+}
+
+static struct seq_operations register_seq_ops = {
+	.start = reg_start,
+	.next  = reg_next,
+	.stop  = reg_stop,
+	.show  = reg_show
+};
+
+static int open_file_registers(struct inode *inode, struct file *file)
+{
+	struct seq_file *s;
+	int res;
+	res = seq_open(file, &register_seq_ops);
+	s = (struct seq_file *)file->private_data;
+	s->private = inode->i_private;
+	return res;
+}
+
+static const struct file_operations fops_registers = {
+	.open = open_file_registers,
+	.read    = seq_read,
+	.llseek  = seq_lseek,
+	.release = seq_release
+};
+
+
+/* debugfs: TSF */
+
+static ssize_t read_file_tsf(struct file *file, char __user *user_buf,
+				   size_t count, loff_t *ppos)
+{
+	struct ath5k_softc *sc = file->private_data;
+	char buf[100];
+	snprintf(buf, 100, "0x%016llx\n", ath5k_hw_get_tsf64(sc->ah));
+	return simple_read_from_buffer(user_buf, count, ppos, buf, 19);
+}
+
+static ssize_t write_file_tsf(struct file *file,
+				 const char __user *userbuf,
+				 size_t count, loff_t *ppos)
+{
+	struct ath5k_softc *sc = file->private_data;
+	if (strncmp(userbuf, "reset", 5) == 0) {
+		ath5k_hw_reset_tsf(sc->ah);
+		printk(KERN_INFO "debugfs reset TSF\n");
+	}
+	return count;
+}
+
+static const struct file_operations fops_tsf = {
+	.read = read_file_tsf,
+	.write = write_file_tsf,
+	.open = ath5k_debugfs_open,
+};
+
+
+/* debugfs: beacons */
+
+static ssize_t read_file_beacon(struct file *file, char __user *user_buf,
+				   size_t count, loff_t *ppos)
+{
+	struct ath5k_softc *sc = file->private_data;
+	struct ath5k_hw *ah = sc->ah;
+
+	char buf[1000];
+	int len = 0;
+	REG_PRINT_APPEND(AR5K_BEACON);
+	len += snprintf(buf+len, 1000-len, "\tbeacon period:\t%d\n",
+		ath5k_hw_reg_read(ah, AR5K_BEACON) & AR5K_BEACON_PERIOD);
+	len += snprintf(buf+len, 1000-len, "\tbeacon tim:\t%x\n",
+		(ath5k_hw_reg_read(ah, AR5K_BEACON) & AR5K_BEACON_TIM)
+		>> AR5K_BEACON_TIM_S);
+	len += snprintf(buf+len, 1000-len, "\tbeacons enabled: %s\n",
+		ath5k_hw_reg_read(ah, AR5K_BEACON) & AR5K_BEACON_ENABLE ?
+			"YES" : "NO");
+	REG_PRINT_APPEND(AR5K_TIMER0);
+	REG_PRINT_APPEND(AR5K_TIMER1);
+	REG_PRINT_APPEND(AR5K_TIMER2);
+	REG_PRINT_APPEND(AR5K_TIMER3);
+	REG_PRINT_APPEND(AR5K_LAST_TSTP);
+	REG_PRINT_APPEND(AR5K_BEACON_CNT);
+
+	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
+}
+
+static ssize_t write_file_beacon(struct file *file,
+				 const char __user *userbuf,
+				 size_t count, loff_t *ppos)
+{
+	struct ath5k_softc *sc = file->private_data;
+	struct ath5k_hw *ah = sc->ah;
+
+	if (strncmp(userbuf, "disable", 7) == 0) {
+		AR5K_REG_DISABLE_BITS(ah, AR5K_BEACON, AR5K_BEACON_ENABLE);
+		printk(KERN_INFO "debugfs disable beacons\n");
+	} else if (strncmp(userbuf, "enable", 6) == 0) {
+		AR5K_REG_ENABLE_BITS(ah, AR5K_BEACON, AR5K_BEACON_ENABLE);
+		printk(KERN_INFO "debugfs enable beacons\n");
+	}
+	return count;
+}
+
+static const struct file_operations fops_beacon = {
+	.read = read_file_beacon,
+	.write = write_file_beacon,
+	.open = ath5k_debugfs_open,
+};
+
+
+/* debugfs: reset */
+
+static ssize_t write_file_reset(struct file *file,
+				 const char __user *userbuf,
+				 size_t count, loff_t *ppos)
+{
+	struct ath5k_softc *sc = file->private_data;
+	tasklet_schedule(&sc->restq);
+	return count;
+}
+
+static const struct file_operations fops_reset = {
+	.write = write_file_reset,
+	.open = ath5k_debugfs_open,
+};
+
+
+/* init */
+
 void
 ath5k_debug_init(void)
 {
@@ -84,6 +266,22 @@ ath5k_debug_init_device(struct ath5k_softc *sc)
 			ath5k_global_debugfs);
 	sc->debug.debugfs_debug = debugfs_create_u32("debug",
 			0666, sc->debug.debugfs_phydir, &sc->debug.level);
+
+	sc->debug.debugfs_registers = debugfs_create_file("registers", 0444,
+				sc->debug.debugfs_phydir,
+				sc, &fops_registers);
+
+	sc->debug.debugfs_tsf = debugfs_create_file("tsf", 0666,
+				sc->debug.debugfs_phydir,
+				sc, &fops_tsf);
+
+	sc->debug.debugfs_beacon = debugfs_create_file("beacon", 0666,
+				sc->debug.debugfs_phydir,
+				sc, &fops_beacon);
+
+	sc->debug.debugfs_reset = debugfs_create_file("reset", 0222,
+				sc->debug.debugfs_phydir,
+				sc, &fops_reset);
 }
 
 void
@@ -96,9 +294,16 @@ void
 ath5k_debug_finish_device(struct ath5k_softc *sc)
 {
 	debugfs_remove(sc->debug.debugfs_debug);
+	debugfs_remove(sc->debug.debugfs_registers);
+	debugfs_remove(sc->debug.debugfs_tsf);
+	debugfs_remove(sc->debug.debugfs_beacon);
+	debugfs_remove(sc->debug.debugfs_reset);
 	debugfs_remove(sc->debug.debugfs_phydir);
 }
 
+
+/* functions used in other places */
+
 void
 ath5k_debug_dump_modes(struct ath5k_softc *sc, struct ieee80211_hw_mode 
*modes)
 {
diff --git a/drivers/net/wireless/ath5k/debug.h 
b/drivers/net/wireless/ath5k/debug.h
index 115073f..2b491cb 100644
--- a/drivers/net/wireless/ath5k/debug.h
+++ b/drivers/net/wireless/ath5k/debug.h
@@ -77,6 +77,10 @@ struct ath5k_dbg_info {
 	/* debugfs entries */
 	struct dentry		*debugfs_phydir;
 	struct dentry		*debugfs_debug;
+	struct dentry		*debugfs_registers;
+	struct dentry		*debugfs_tsf;
+	struct dentry		*debugfs_beacon;
+	struct dentry		*debugfs_reset;
 };
 
 /**




