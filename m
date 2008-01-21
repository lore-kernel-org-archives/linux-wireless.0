Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:15942 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755556AbYAUCJi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Jan 2008 21:09:38 -0500
From: Bruno Randolf <bruno@thinktube.com>
Subject: [PATCH 1/2] ath5k: debug level improvements
To: ath5k-devel@lists.ath5k.org
Cc: mcgrof@gmail.com, jirislaby@gmail.com, mickflemm@gmail.com,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com
Date: Mon, 21 Jan 2008 11:09:24 +0900
Message-ID: <20080121020924.3818.46553.stgit@one> (sfid-20080121_020952_662219_E69F5676)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* use only one debug level for beacon debugging: unify ATH5K_DEBUG_BEACON and
ATH5K_DEBUG_BEACON_PROC.

* remove debug level ATH5K_DEBUG_FATAL. doesn't make sense as a debug level -
if it's fatal it should be logged as an error.

* fancier printing of debug levels. cat /debugfs/ath5k/phy0/debug.

* allow debug levels to be changed by echoing their name into
/debugfs/ath5k/phy0/debug. this will toggle the state, when it was off it will
be turned on and vice versa.

* use copy_from_user() when reading from the debug files. use unsigned int for
better optimization.

drivers/net/wireless/ath5k/base.c:      Changes-licensed-under: 3-Clause-BSD
drivers/net/wireless/ath5k/debug.c:     Changes-licensed-under: GPL
drivers/net/wireless/ath5k/debug.h:     Changes-licensed-under: GPL

Signed-off-by: Bruno Randolf <bruno@thinktube.com>
Acked-by: Luis R. Rodriguez <mcgrof@winlab.rutgers.edu>
Acked-by: Jiri Slaby <jirislaby@gmail.com>
---

 drivers/net/wireless/ath5k/base.c  |   10 ++-
 drivers/net/wireless/ath5k/debug.c |  120 ++++++++++++++++++++++++++++++------
 drivers/net/wireless/ath5k/debug.h |   18 ++---
 3 files changed, 113 insertions(+), 35 deletions(-)


diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index 742616a..6bbee64 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -1919,7 +1919,7 @@ ath5k_beacon_send(struct ath5k_softc *sc)
 	struct ath5k_buf *bf = sc->bbuf;
 	struct ath5k_hw *ah = sc->ah;
 
-	ATH5K_DBG(sc, ATH5K_DEBUG_BEACON_PROC, "in beacon_send\n");
+	ATH5K_DBG_UNLIMIT(sc, ATH5K_DEBUG_BEACON, "in beacon_send\n");
 
 	if (unlikely(bf->skb == NULL || sc->opmode == IEEE80211_IF_TYPE_STA ||
 			sc->opmode == IEEE80211_IF_TYPE_MNTR)) {
@@ -1935,10 +1935,10 @@ ath5k_beacon_send(struct ath5k_softc *sc)
 	 */
 	if (unlikely(ath5k_hw_num_tx_pending(ah, sc->bhalq) != 0)) {
 		sc->bmisscount++;
-		ATH5K_DBG(sc, ATH5K_DEBUG_BEACON_PROC,
+		ATH5K_DBG(sc, ATH5K_DEBUG_BEACON,
 			"missed %u consecutive beacons\n", sc->bmisscount);
 		if (sc->bmisscount > 3) {		/* NB: 3 is a guess */
-			ATH5K_DBG(sc, ATH5K_DEBUG_BEACON_PROC,
+			ATH5K_DBG(sc, ATH5K_DEBUG_BEACON,
 				"stuck beacon time (%u missed)\n",
 				sc->bmisscount);
 			tasklet_schedule(&sc->restq);
@@ -1946,7 +1946,7 @@ ath5k_beacon_send(struct ath5k_softc *sc)
 		return;
 	}
 	if (unlikely(sc->bmisscount != 0)) {
-		ATH5K_DBG(sc, ATH5K_DEBUG_BEACON_PROC,
+		ATH5K_DBG(sc, ATH5K_DEBUG_BEACON,
 			"resume beacon xmit after %u misses\n",
 			sc->bmisscount);
 		sc->bmisscount = 0;
@@ -1966,7 +1966,7 @@ ath5k_beacon_send(struct ath5k_softc *sc)
 
 	ath5k_hw_put_tx_buf(ah, sc->bhalq, bf->daddr);
 	ath5k_hw_tx_start(ah, sc->bhalq);
-	ATH5K_DBG(sc, ATH5K_DEBUG_BEACON_PROC, "TXDP[%u] = %llx (%p)\n",
+	ATH5K_DBG(sc, ATH5K_DEBUG_BEACON, "TXDP[%u] = %llx (%p)\n",
 		sc->bhalq, (unsigned long long)bf->daddr, bf->desc);
 
 	sc->bsent++;
diff --git a/drivers/net/wireless/ath5k/debug.c b/drivers/net/wireless/ath5k/debug.c
index 4ba649e..6a3424a 100644
--- a/drivers/net/wireless/ath5k/debug.c
+++ b/drivers/net/wireless/ath5k/debug.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2007 Bruno Randolf <bruno@thinktube.com>
+ * Copyright (c) 2007-2008 Bruno Randolf <bruno@thinktube.com>
  *
  *  This file is free software: you may copy, redistribute and/or modify it
  *  under the terms of the GNU General Public License as published by the
@@ -209,7 +209,12 @@ static ssize_t write_file_tsf(struct file *file,
 				 size_t count, loff_t *ppos)
 {
 	struct ath5k_softc *sc = file->private_data;
-	if (strncmp(userbuf, "reset", 5) == 0) {
+	char buf[20];
+
+	if (copy_from_user(buf, userbuf, min_t(size_t, count, 20)))
+		return -EFAULT;
+
+	if (strncmp(buf, "reset", 5) == 0) {
 		ath5k_hw_reset_tsf(sc->ah);
 		printk(KERN_INFO "debugfs reset TSF\n");
 	}
@@ -232,7 +237,7 @@ static ssize_t read_file_beacon(struct file *file, char __user *user_buf,
 	struct ath5k_softc *sc = file->private_data;
 	struct ath5k_hw *ah = sc->ah;
 	char buf[1000];
-	int len = 0;
+	unsigned int len = 0;
 	unsigned int v;
 	u64 tsf;
 
@@ -277,11 +282,15 @@ static ssize_t write_file_beacon(struct file *file,
 {
 	struct ath5k_softc *sc = file->private_data;
 	struct ath5k_hw *ah = sc->ah;
+	char buf[20];
+
+	if (copy_from_user(buf, userbuf, min_t(size_t, count, 20)))
+		return -EFAULT;
 
-	if (strncmp(userbuf, "disable", 7) == 0) {
+	if (strncmp(buf, "disable", 7) == 0) {
 		AR5K_REG_DISABLE_BITS(ah, AR5K_BEACON, AR5K_BEACON_ENABLE);
 		printk(KERN_INFO "debugfs disable beacons\n");
-	} else if (strncmp(userbuf, "enable", 6) == 0) {
+	} else if (strncmp(buf, "enable", 6) == 0) {
 		AR5K_REG_ENABLE_BITS(ah, AR5K_BEACON, AR5K_BEACON_ENABLE);
 		printk(KERN_INFO "debugfs enable beacons\n");
 	}
@@ -314,6 +323,82 @@ static const struct file_operations fops_reset = {
 };
 
 
+/* debugfs: debug level */
+
+static struct {
+	enum ath5k_debug_level level;
+	const char *name;
+	const char *desc;
+} dbg_info[] = {
+	{ ATH5K_DEBUG_RESET,	"reset",	"reset and initialization" },
+	{ ATH5K_DEBUG_INTR,	"intr",		"interrupt handling" },
+	{ ATH5K_DEBUG_MODE,	"mode",		"mode init/setup" },
+	{ ATH5K_DEBUG_XMIT,	"xmit",		"basic xmit operation" },
+	{ ATH5K_DEBUG_BEACON,	"beacon",	"beacon handling" },
+	{ ATH5K_DEBUG_CALIBRATE, "calib",	"periodic calibration" },
+	{ ATH5K_DEBUG_TXPOWER,	"txpower",	"transmit power setting" },
+	{ ATH5K_DEBUG_LED,	"led",		"LED mamagement" },
+	{ ATH5K_DEBUG_DUMP_RX,	"dumprx",	"print received skb content" },
+	{ ATH5K_DEBUG_DUMP_TX,	"dumptx",	"print transmit skb content" },
+	{ ATH5K_DEBUG_DUMPMODES, "dumpmodes",	"dump modes" },
+	{ ATH5K_DEBUG_TRACE,	"trace",	"trace function calls" },
+	{ ATH5K_DEBUG_ANY,	"all",		"show all debug levels" },
+};
+
+static ssize_t read_file_debug(struct file *file, char __user *user_buf,
+				   size_t count, loff_t *ppos)
+{
+	struct ath5k_softc *sc = file->private_data;
+	char buf[1000];
+	unsigned int len = 0;
+	unsigned int i;
+
+	len += snprintf(buf+len, sizeof(buf)-len,
+		"DEBUG LEVEL: 0x%08x\n\n", sc->debug.level);
+
+	for (i = 0; i < ARRAY_SIZE(dbg_info) - 1; i++) {
+		len += snprintf(buf+len, sizeof(buf)-len,
+			"%10s %c 0x%08x - %s\n", dbg_info[i].name,
+			sc->debug.level & dbg_info[i].level ? '+' : ' ',
+			dbg_info[i].level, dbg_info[i].desc);
+	}
+	len += snprintf(buf+len, sizeof(buf)-len,
+		"%10s %c 0x%08x - %s\n", dbg_info[i].name,
+		sc->debug.level == dbg_info[i].level ? '+' : ' ',
+		dbg_info[i].level, dbg_info[i].desc);
+
+	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
+}
+
+static ssize_t write_file_debug(struct file *file,
+				 const char __user *userbuf,
+				 size_t count, loff_t *ppos)
+{
+	struct ath5k_softc *sc = file->private_data;
+	unsigned int i;
+	char buf[20];
+
+	if (copy_from_user(buf, userbuf, min_t(size_t, count, 20)))
+		return -EFAULT;
+
+	for (i = 0; i < ARRAY_SIZE(dbg_info); i++) {
+		if (strncmp(buf, dbg_info[i].name,
+					strlen(dbg_info[i].name)) == 0) {
+			sc->debug.level ^= dbg_info[i].level; /* toggle bit */
+			break;
+		}
+	}
+	return count;
+}
+
+static const struct file_operations fops_debug = {
+	.read = read_file_debug,
+	.write = write_file_debug,
+	.open = ath5k_debugfs_open,
+	.owner = THIS_MODULE,
+};
+
+
 /* init */
 
 void
@@ -326,26 +411,24 @@ void
 ath5k_debug_init_device(struct ath5k_softc *sc)
 {
 	sc->debug.level = ath5k_debug;
+
 	sc->debug.debugfs_phydir = debugfs_create_dir(wiphy_name(sc->hw->wiphy),
-			ath5k_global_debugfs);
-	sc->debug.debugfs_debug = debugfs_create_u32("debug",
-			0666, sc->debug.debugfs_phydir, &sc->debug.level);
+				ath5k_global_debugfs);
+
+	sc->debug.debugfs_debug = debugfs_create_file("debug", 0666,
+				sc->debug.debugfs_phydir, sc, &fops_debug);
 
 	sc->debug.debugfs_registers = debugfs_create_file("registers", 0444,
-				sc->debug.debugfs_phydir,
-				sc, &fops_registers);
+				sc->debug.debugfs_phydir, sc, &fops_registers);
 
 	sc->debug.debugfs_tsf = debugfs_create_file("tsf", 0666,
-				sc->debug.debugfs_phydir,
-				sc, &fops_tsf);
+				sc->debug.debugfs_phydir, sc, &fops_tsf);
 
 	sc->debug.debugfs_beacon = debugfs_create_file("beacon", 0666,
-				sc->debug.debugfs_phydir,
-				sc, &fops_beacon);
+				sc->debug.debugfs_phydir, sc, &fops_beacon);
 
 	sc->debug.debugfs_reset = debugfs_create_file("reset", 0222,
-				sc->debug.debugfs_phydir,
-				sc, &fops_reset);
+				sc->debug.debugfs_phydir, sc, &fops_reset);
 }
 
 void
@@ -415,8 +498,7 @@ ath5k_debug_printrxbuffs(struct ath5k_softc *sc, struct ath5k_hw *ah)
 	struct ath5k_buf *bf;
 	int status;
 
-	if (likely(!(sc->debug.level &
-	    (ATH5K_DEBUG_RESET | ATH5K_DEBUG_FATAL))))
+	if (likely(!(sc->debug.level & ATH5K_DEBUG_RESET)))
 		return;
 
 	printk(KERN_DEBUG "rx queue %x, link %p\n",
@@ -426,7 +508,7 @@ ath5k_debug_printrxbuffs(struct ath5k_softc *sc, struct ath5k_hw *ah)
 	list_for_each_entry(bf, &sc->rxbuf, list) {
 		ds = bf->desc;
 		status = ah->ah_proc_rx_desc(ah, ds);
-		if (!status || (sc->debug.level & ATH5K_DEBUG_FATAL))
+		if (!status)
 			ath5k_debug_printrxbuf(bf, status == 0);
 	}
 	spin_unlock_bh(&sc->rxbuflock);
diff --git a/drivers/net/wireless/ath5k/debug.h b/drivers/net/wireless/ath5k/debug.h
index 2b491cb..c4fd8c4 100644
--- a/drivers/net/wireless/ath5k/debug.h
+++ b/drivers/net/wireless/ath5k/debug.h
@@ -91,7 +91,6 @@ struct ath5k_dbg_info {
  * @ATH5K_DEBUG_MODE: mode init/setup
  * @ATH5K_DEBUG_XMIT: basic xmit operation
  * @ATH5K_DEBUG_BEACON: beacon handling
- * @ATH5K_DEBUG_BEACON_PROC: beacon ISR proc
  * @ATH5K_DEBUG_CALIBRATE: periodic calibration
  * @ATH5K_DEBUG_TXPOWER: transmit power setting
  * @ATH5K_DEBUG_LED: led management
@@ -99,7 +98,6 @@ struct ath5k_dbg_info {
  * @ATH5K_DEBUG_DUMP_TX: print transmit skb content
  * @ATH5K_DEBUG_DUMPMODES: dump modes
  * @ATH5K_DEBUG_TRACE: trace function calls
- * @ATH5K_DEBUG_FATAL: fatal errors
  * @ATH5K_DEBUG_ANY: show at any debug level
  *
  * The debug level is used to control the amount and type of debugging output
@@ -115,15 +113,13 @@ enum ath5k_debug_level {
 	ATH5K_DEBUG_MODE	= 0x00000004,
 	ATH5K_DEBUG_XMIT	= 0x00000008,
 	ATH5K_DEBUG_BEACON	= 0x00000010,
-	ATH5K_DEBUG_BEACON_PROC	= 0x00000020,
-	ATH5K_DEBUG_CALIBRATE	= 0x00000100,
-	ATH5K_DEBUG_TXPOWER	= 0x00000200,
-	ATH5K_DEBUG_LED		= 0x00000400,
-	ATH5K_DEBUG_DUMP_RX	= 0x00001000,
-	ATH5K_DEBUG_DUMP_TX	= 0x00002000,
-	ATH5K_DEBUG_DUMPMODES	= 0x00004000,
-	ATH5K_DEBUG_TRACE	= 0x00010000,
-	ATH5K_DEBUG_FATAL	= 0x80000000,
+	ATH5K_DEBUG_CALIBRATE	= 0x00000020,
+	ATH5K_DEBUG_TXPOWER	= 0x00000040,
+	ATH5K_DEBUG_LED		= 0x00000080,
+	ATH5K_DEBUG_DUMP_RX	= 0x00000100,
+	ATH5K_DEBUG_DUMP_TX	= 0x00000200,
+	ATH5K_DEBUG_DUMPMODES	= 0x00000400,
+	ATH5K_DEBUG_TRACE	= 0x00001000,
 	ATH5K_DEBUG_ANY		= 0xffffffff
 };
 

