Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:40419 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230AbaLRXSS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2014 18:18:18 -0500
Received: by mail-wi0-f170.google.com with SMTP id bs8so3115706wib.5
        for <linux-wireless@vger.kernel.org>; Thu, 18 Dec 2014 15:18:17 -0800 (PST)
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: nbd@openwrt.org, thomas@net.t-labs.tu-berlin.de
Subject: [PATCH 2/3] ath9k: add debugfs support for hw TPC
Date: Fri, 19 Dec 2014 00:18:13 +0100
Message-Id: <1418944694-10614-3-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20141219_001825_118652_CC42952C)
In-Reply-To: <1418944694-10614-1-git-send-email-lorenzo.bianconi83@gmail.com>
References: <1418944694-10614-1-git-send-email-lorenzo.bianconi83@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add tpc entry to ath9k debugfs in order to enable/disable hw TPC

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
---
 drivers/net/wireless/ath/ath9k/debug.c | 71 ++++++++++++++++++++++++++++++++++
 1 file changed, 71 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 696e3d5..346290a 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -1188,6 +1188,75 @@ static const struct file_operations fops_ackto = {
 };
 #endif
 
+static ssize_t read_file_tpc(struct file *file, char __user *user_buf,
+			     size_t count, loff_t *ppos)
+{
+	struct ath_softc *sc = file->private_data;
+	struct ath_hw *ah = sc->sc_ah;
+	unsigned int len = 0, size = 32;
+	ssize_t retval;
+	char *buf;
+
+	buf = kzalloc(size, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	len += scnprintf(buf + len, size - len, "%s\n",
+			 ah->tpc_enabled ? "ENABLED" : "DISABLED");
+
+	if (len > size)
+		len = size;
+
+	retval = simple_read_from_buffer(user_buf, count, ppos, buf, len);
+	kfree(buf);
+
+	return retval;
+}
+
+static ssize_t write_file_tpc(struct file *file, const char __user *user_buf,
+			      size_t count, loff_t *ppos)
+{
+	struct ath_softc *sc = file->private_data;
+	struct ath_hw *ah = sc->sc_ah;
+	unsigned long val;
+	char buf[32];
+	ssize_t len;
+	bool tpc_enabled;
+
+	if (!AR_SREV_9300_20_OR_LATER(ah)) {
+		/* ar9002 does not support TPC for the moment */
+		return -EOPNOTSUPP;
+	}
+
+	len = min(count, sizeof(buf) - 1);
+	if (copy_from_user(buf, user_buf, len))
+		return -EFAULT;
+
+	buf[len] = '\0';
+	if (kstrtoul(buf, 0, &val))
+		return -EINVAL;
+
+	if (val < 0 || val > 1)
+		return -EINVAL;
+
+	tpc_enabled = !!val;
+
+	if (tpc_enabled != ah->tpc_enabled) {
+		ah->tpc_enabled = tpc_enabled;
+		ath9k_hw_set_txpowerlimit(ah, sc->cur_chan->txpower, false);
+	}
+
+	return count;
+}
+
+static const struct file_operations fops_tpc = {
+	.read = read_file_tpc,
+	.write = write_file_tpc,
+	.open = simple_open,
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,
+};
+
 /* Ethtool support for get-stats */
 
 #define AMKSTR(nm) #nm "_BE", #nm "_BK", #nm "_VI", #nm "_VO"
@@ -1397,6 +1466,8 @@ int ath9k_init_debug(struct ath_hw *ah)
 	debugfs_create_file("ack_to", S_IRUSR | S_IWUSR, sc->debug.debugfs_phy,
 			    sc, &fops_ackto);
 #endif
+	debugfs_create_file("tpc", S_IRUSR | S_IWUSR,
+			    sc->debug.debugfs_phy, sc, &fops_tpc);
 
 	return 0;
 }
-- 
2.1.0

