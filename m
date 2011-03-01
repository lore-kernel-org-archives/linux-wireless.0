Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:37584 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754757Ab1CAFbC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Mar 2011 00:31:02 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 28 Feb 2011 21:30:40 -0800
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, Felix Fietkau <nbd@openwrt.org>
Subject: [PATCH] ath9k: Add a debugfs interface to dump chip registers
Date: Tue, 1 Mar 2011 05:30:55 -0800
Message-ID: <1298986255-1369-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

/<debugfs_root>/ieee80211/phyX/ath9k/regdump is the interface
to dump the registers.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/debug.c |   54 ++++++++++++++++++++++++++++++++
 1 files changed, 54 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 5cfcf8c..d404aa0 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -15,6 +15,7 @@
  */
 
 #include <linux/slab.h>
+#include <linux/vmalloc.h>
 #include <asm/unaligned.h>
 
 #include "ath9k.h"
@@ -30,6 +31,19 @@ static int ath9k_debugfs_open(struct inode *inode, struct file *file)
 	return 0;
 }
 
+static ssize_t ath9k_debugfs_read_buf(struct file *file, char __user *user_buf,
+				      size_t count, loff_t *ppos)
+{
+	u8 *buf = file->private_data;
+	return simple_read_from_buffer(user_buf, count, ppos, buf, strlen(buf));
+}
+
+static int ath9k_debugfs_release_buf(struct inode *inode, struct file *file)
+{
+	vfree(file->private_data);
+	return 0;
+}
+
 #ifdef CONFIG_ATH_DEBUG
 
 static ssize_t read_file_debug(struct file *file, char __user *user_buf,
@@ -1027,6 +1041,42 @@ static const struct file_operations fops_regval = {
 	.llseek = default_llseek,
 };
 
+#define REGDUMP_LINE_SIZE	20
+
+static int open_file_regdump(struct inode *inode, struct file *file)
+{
+	struct ath_softc *sc = inode->i_private;
+	unsigned int len = 0;
+	u8 *buf;
+	int i;
+	unsigned long num_regs, regdump_len, max_reg_offset;
+
+	max_reg_offset = AR_SREV_9300_20_OR_LATER(sc->sc_ah) ? 0x16bd4 : 0xb500;
+	num_regs = max_reg_offset / 4 + 1;
+	regdump_len = num_regs * REGDUMP_LINE_SIZE + 1;
+	buf = vmalloc(regdump_len);
+	if (!buf)
+		return -ENOMEM;
+
+	ath9k_ps_wakeup(sc);
+	for (i = 0; i < num_regs; i++)
+		len += scnprintf(buf + len, regdump_len - len,
+			"0x%06x 0x%08x\n", i << 2, REG_READ(sc->sc_ah, i << 2));
+	ath9k_ps_restore(sc);
+
+	file->private_data = buf;
+
+	return 0;
+}
+
+static const struct file_operations fops_regdump = {
+	.open = open_file_regdump,
+	.read = ath9k_debugfs_read_buf,
+	.release = ath9k_debugfs_release_buf,
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,/* read accesses f_pos */
+};
+
 int ath9k_init_debug(struct ath_hw *ah)
 {
 	struct ath_common *common = ath9k_hw_common(ah);
@@ -1091,6 +1141,10 @@ int ath9k_init_debug(struct ath_hw *ah)
 			sc->debug.debugfs_phy, &ah->config.cwm_ignore_extcca))
 		goto err;
 
+	if (!debugfs_create_file("regdump", S_IRUSR, sc->debug.debugfs_phy,
+			sc, &fops_regdump))
+		goto err;
+
 	sc->debug.regidx = 0;
 	return 0;
 err:
-- 
1.7.0.4

