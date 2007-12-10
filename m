Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:27890 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750941AbXLJKVL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2007 05:21:11 -0500
From: Bruno Randolf <bruno@thinktube.com>
To: ath5k-devel@lists.ath5k.org
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	mcgrof@gmail.com, jirislaby@gmail.com, mickflemm@gmail.com,
	Bruno Randolf <bruno@thinktube.com>
Subject: [PATCH 1/1] ath5k: add debugfs entries for registers, tsf, beacon, reset
Date: Mon, 10 Dec 2007 19:21:17 +0900
Message-Id: <1197282077-19511-1-git-send-email-bruno@thinktube.com> (sfid-20071210_102115_759958_C27C31A6)
In-Reply-To: <475D0747.7010701@gmail.com>
References: <475D0747.7010701@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

i resend this patch to address jiris comments and with some small improvements.
this hopefully last version now returns NULL instead of 0 in reg_start() and
reg_next().

'registers' prints the name and value of some registers. this should be adapted
to what we actually need later and is supposed to replace the hwdump facility i
removed in my earlier debugging changes.

'tsf' prints the current HW TSF. writing "reset" into the file will reset the
TSF.

'beacon' shows beacon relevant registers.  it is good for watching the beacon
timers with something like "watch -n0 cat /dbg/ath5k/phy0/beacon". writing
"enable" into the file will try to enable beacons by setting the flag
AR5K_BEACON_ENABLE, "disable" will disable that bit.

'reset' can be used to trigger a HW reset, by writing "reset" into it.

Changes-licensed-under: GPL

Signed-off-by: Bruno Randolf <bruno@thinktube.com>
Acked-by: Luis R. Rodriguez <mgrof@winlab.rutgers.edu>
Acked-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/net/wireless/ath5k/debug.c |  269 ++++++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath5k/debug.h |    4 +
 2 files changed, 273 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath5k/debug.c b/drivers/net/wireless/ath5k/debug.c
index 7427506..fcdd36e 100644
--- a/drivers/net/wireless/ath5k/debug.c
+++ b/drivers/net/wireless/ath5k/debug.c
@@ -64,12 +64,258 @@
 static unsigned int ath5k_debug;
 module_param_named(debug, ath5k_debug, uint, 0);
 
+
 #if ATH5K_DEBUG
 
+#include <linux/seq_file.h>
 #include "reg.h"
 
 static struct dentry *ath5k_global_debugfs;
 
+static int ath5k_debugfs_open(struct inode *inode, struct file *file)
+{
+	file->private_data = inode->i_private;
+	return 0;
+}
+
+
+/* debugfs: registers */
+
+struct reg {
+	char *name;
+	int addr;
+};
+
+#define REG_STRUCT_INIT(r) { #r, r }
+
+/* just a few random registers, might want to add more */
+static struct reg regs[] = {
+	REG_STRUCT_INIT(AR5K_CR),
+	REG_STRUCT_INIT(AR5K_RXDP),
+	REG_STRUCT_INIT(AR5K_CFG),
+	REG_STRUCT_INIT(AR5K_IER),
+	REG_STRUCT_INIT(AR5K_BCR),
+	REG_STRUCT_INIT(AR5K_RTSD0),
+	REG_STRUCT_INIT(AR5K_RTSD1),
+	REG_STRUCT_INIT(AR5K_TXCFG),
+	REG_STRUCT_INIT(AR5K_RXCFG),
+	REG_STRUCT_INIT(AR5K_RXJLA),
+	REG_STRUCT_INIT(AR5K_MIBC),
+	REG_STRUCT_INIT(AR5K_TOPS),
+	REG_STRUCT_INIT(AR5K_RXNOFRM),
+	REG_STRUCT_INIT(AR5K_TXNOFRM),
+	REG_STRUCT_INIT(AR5K_RPGTO),
+	REG_STRUCT_INIT(AR5K_RFCNT),
+	REG_STRUCT_INIT(AR5K_MISC),
+	REG_STRUCT_INIT(AR5K_QCUDCU_CLKGT),
+	REG_STRUCT_INIT(AR5K_ISR),
+	REG_STRUCT_INIT(AR5K_PISR),
+	REG_STRUCT_INIT(AR5K_SISR0),
+	REG_STRUCT_INIT(AR5K_SISR1),
+	REG_STRUCT_INIT(AR5K_SISR2),
+	REG_STRUCT_INIT(AR5K_SISR3),
+	REG_STRUCT_INIT(AR5K_SISR4),
+	REG_STRUCT_INIT(AR5K_IMR),
+	REG_STRUCT_INIT(AR5K_PIMR),
+	REG_STRUCT_INIT(AR5K_SIMR0),
+	REG_STRUCT_INIT(AR5K_SIMR1),
+	REG_STRUCT_INIT(AR5K_SIMR2),
+	REG_STRUCT_INIT(AR5K_SIMR3),
+	REG_STRUCT_INIT(AR5K_SIMR4),
+	REG_STRUCT_INIT(AR5K_DCM_ADDR),
+	REG_STRUCT_INIT(AR5K_DCCFG),
+	REG_STRUCT_INIT(AR5K_CCFG),
+	REG_STRUCT_INIT(AR5K_CPC0),
+	REG_STRUCT_INIT(AR5K_CPC1),
+	REG_STRUCT_INIT(AR5K_CPC2),
+	REG_STRUCT_INIT(AR5K_CPC3),
+	REG_STRUCT_INIT(AR5K_CPCORN),
+	REG_STRUCT_INIT(AR5K_RESET_CTL),
+	REG_STRUCT_INIT(AR5K_SLEEP_CTL),
+	REG_STRUCT_INIT(AR5K_INTPEND),
+	REG_STRUCT_INIT(AR5K_SFR),
+	REG_STRUCT_INIT(AR5K_PCICFG),
+	REG_STRUCT_INIT(AR5K_GPIOCR),
+	REG_STRUCT_INIT(AR5K_GPIODO),
+	REG_STRUCT_INIT(AR5K_SREV),
+};
+
+static void *reg_start(struct seq_file *seq, loff_t *pos)
+{
+	return *pos < ARRAY_SIZE(regs) ? &regs[*pos] : NULL;
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
+	return *pos < ARRAY_SIZE(regs) ? &regs[*pos] : NULL;
+}
+
+static int reg_show(struct seq_file *seq, void *p)
+{
+	struct ath5k_softc *sc = seq->private;
+	struct reg *r = p;
+	seq_printf(seq, "%-25s0x%08x\n", r->name,
+		ath5k_hw_reg_read(sc->ah, r->addr));
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
+	if (res == 0) {
+		s = file->private_data;
+		s->private = inode->i_private;
+	}
+	return res;
+}
+
+static const struct file_operations fops_registers = {
+	.open = open_file_registers,
+	.read    = seq_read,
+	.llseek  = seq_lseek,
+	.release = seq_release,
+	.owner = THIS_MODULE,
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
+	.owner = THIS_MODULE,
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
+	char buf[1000];
+	int len = 0;
+	unsigned int v;
+	u64 tsf;
+
+	v = ath5k_hw_reg_read(sc->ah, AR5K_BEACON);
+	len += snprintf(buf+len, sizeof(buf)-len,
+		"%-24s0x%08x\tintval: %d\tTIM: 0x%x\n",
+		"AR5K_BEACON", v, v & AR5K_BEACON_PERIOD,
+		(v & AR5K_BEACON_TIM) >> AR5K_BEACON_TIM_S);
+
+	len += snprintf(buf+len, sizeof(buf)-len, "%-24s0x%08x\n",
+		"AR5K_LAST_TSTP", ath5k_hw_reg_read(sc->ah, AR5K_LAST_TSTP));
+
+	len += snprintf(buf+len, sizeof(buf)-len, "%-24s0x%08x\n\n",
+		"AR5K_BEACON_CNT", ath5k_hw_reg_read(sc->ah, AR5K_BEACON_CNT));
+
+	v = ath5k_hw_reg_read(sc->ah, AR5K_TIMER0);
+	len += snprintf(buf+len, sizeof(buf)-len, "%-24s0x%08x\tTU: %08x\n",
+		"AR5K_TIMER0 (TBTT)", v, v);
+
+	v = ath5k_hw_reg_read(sc->ah, AR5K_TIMER1);
+	len += snprintf(buf+len, sizeof(buf)-len, "%-24s0x%08x\tTU: %08x\n",
+		"AR5K_TIMER1 (DMA)", v, v >> 3);
+
+	v = ath5k_hw_reg_read(sc->ah, AR5K_TIMER2);
+	len += snprintf(buf+len, sizeof(buf)-len, "%-24s0x%08x\tTU: %08x\n",
+		"AR5K_TIMER2 (SWBA)", v, v >> 3);
+
+	v = ath5k_hw_reg_read(sc->ah, AR5K_TIMER3);
+	len += snprintf(buf+len, sizeof(buf)-len, "%-24s0x%08x\tTU: %08x\n",
+		"AR5K_TIMER3 (ATIM)", v, v);
+
+	tsf = ath5k_hw_get_tsf64(sc->ah);
+	len += snprintf(buf+len, sizeof(buf)-len,
+		"TSF\t\t0x%016llx\tTU: %08x\n", tsf, (u32)(tsf >> 10));
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
+	.owner = THIS_MODULE,
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
+	.owner = THIS_MODULE,
+};
+
+
+/* init */
+
 void
 ath5k_debug_init(void)
 {
@@ -84,6 +330,22 @@ ath5k_debug_init_device(struct ath5k_softc *sc)
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
@@ -96,9 +358,16 @@ void
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
 ath5k_debug_dump_modes(struct ath5k_softc *sc, struct ieee80211_hw_mode *modes)
 {
diff --git a/drivers/net/wireless/ath5k/debug.h b/drivers/net/wireless/ath5k/debug.h
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
-- 
1.5.3.4

