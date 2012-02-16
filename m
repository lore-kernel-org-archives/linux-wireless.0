Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:60779 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753466Ab2BPGVf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Feb 2012 01:21:35 -0500
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20284.41047.270368.466355@gargle.gargle.HOWL> (sfid-20120216_072138_345772_520516B1)
Date: Thu, 16 Feb 2012 11:51:11 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH v2 3/9] ath9k: Add a debugfs file to display reset statistics
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Location: <debugfs_path>/ieee80211/phy#/ath9k/reset

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/debug.c |   41 ++++++++++++++++++++++++++++++++
 1 files changed, 41 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index b2c6069..fe1f55f 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -750,6 +750,38 @@ static ssize_t read_file_misc(struct file *file, char __user *user_buf,
 	return retval;
 }
 
+static ssize_t read_file_reset(struct file *file, char __user *user_buf,
+			       size_t count, loff_t *ppos)
+{
+	struct ath_softc *sc = file->private_data;
+	char buf[512];
+	unsigned int len = 0;
+
+	len += snprintf(buf + len, sizeof(buf) - len,
+			"%17s: %2d\n", "Baseband Hang",
+			sc->debug.stats.reset[RESET_TYPE_BB_HANG]);
+	len += snprintf(buf + len, sizeof(buf) - len,
+			"%17s: %2d\n", "Baseband Watchdog",
+			sc->debug.stats.reset[RESET_TYPE_BB_WATCHDOG]);
+	len += snprintf(buf + len, sizeof(buf) - len,
+			"%17s: %2d\n", "Fatal HW Error",
+			sc->debug.stats.reset[RESET_TYPE_FATAL_INT]);
+	len += snprintf(buf + len, sizeof(buf) - len,
+			"%17s: %2d\n", "TX HW error",
+			sc->debug.stats.reset[RESET_TYPE_TX_ERROR]);
+	len += snprintf(buf + len, sizeof(buf) - len,
+			"%17s: %2d\n", "TX Path Hang",
+			sc->debug.stats.reset[RESET_TYPE_TX_HANG]);
+	len += snprintf(buf + len, sizeof(buf) - len,
+			"%17s: %2d\n", "PLL RX Hang",
+			sc->debug.stats.reset[RESET_TYPE_PLL_HANG]);
+
+	if (len > sizeof(buf))
+		len = sizeof(buf);
+
+	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
+}
+
 void ath_debug_stat_tx(struct ath_softc *sc, struct ath_buf *bf,
 		       struct ath_tx_status *ts, struct ath_txq *txq,
 		       unsigned int flags)
@@ -837,6 +869,13 @@ static const struct file_operations fops_misc = {
 	.llseek = default_llseek,
 };
 
+static const struct file_operations fops_reset = {
+	.read = read_file_reset,
+	.open = ath9k_debugfs_open,
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,
+};
+
 static ssize_t read_file_recv(struct file *file, char __user *user_buf,
 			      size_t count, loff_t *ppos)
 {
@@ -1549,6 +1588,8 @@ int ath9k_init_debug(struct ath_hw *ah)
 			    &fops_stations);
 	debugfs_create_file("misc", S_IRUSR, sc->debug.debugfs_phy, sc,
 			    &fops_misc);
+	debugfs_create_file("reset", S_IRUSR, sc->debug.debugfs_phy, sc,
+			    &fops_reset);
 	debugfs_create_file("recv", S_IRUSR, sc->debug.debugfs_phy, sc,
 			    &fops_recv);
 	debugfs_create_file("rx_chainmask", S_IRUSR | S_IWUSR,
-- 
1.7.9.1

