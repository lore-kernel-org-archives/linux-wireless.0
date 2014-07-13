Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:56494 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752584AbaGMKSd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Jul 2014 06:18:33 -0400
Received: by mail-wg0-f42.google.com with SMTP id l18so2857729wgh.1
        for <linux-wireless@vger.kernel.org>; Sun, 13 Jul 2014 03:18:32 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: ath9k-devel@lists.ath9k.org
Cc: linux-wireless@vger.kernel.org,
	Philippe Duchein <wireless-dev@duchein.net>
Subject: [RFCv2 08/10] ath9k: add debugfs support for dynack
Date: Sun, 13 Jul 2014 12:18:22 +0200
Message-Id: <1405246704-7489-9-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20140713_121848_521363_4F782B4E)
In-Reply-To: <1405246704-7489-1-git-send-email-lorenzo.bianconi83@gmail.com>
References: <1405246704-7489-1-git-send-email-lorenzo.bianconi83@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add ack_to entry to debugfs in order to dump current ack timeout value.
Add dynack entry to enable/disable ack timeout estimation algorithm:

echo (1|0) > /sys/kernel/debug/ieee80211/phy0/ath9k/dynack

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
---
 drivers/net/wireless/ath/ath9k/debug.c | 82 ++++++++++++++++++++++++++++++++++
 1 file changed, 82 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index ce073e9..de6ea5a 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -1169,6 +1169,81 @@ static const struct file_operations fops_btcoex = {
 };
 #endif
 
+#ifdef CONFIG_ATH9K_DYNACK
+/* enable/disable dynack processing */
+static ssize_t read_file_dynack(struct file *file, char __user *user_buf,
+				size_t count, loff_t *ppos)
+{
+	struct ath_softc *sc = file->private_data;
+	struct ath_hw *ah = sc->sc_ah;
+	char buf[32];
+	unsigned int len;
+
+	len = sprintf(buf, "%u\n", ah->dynack.enabled);
+	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
+}
+
+static ssize_t write_file_dynack(struct file *file, const char __user *user_buf,
+				 size_t count, loff_t *ppos)
+{
+	struct ath_softc *sc = file->private_data;
+	struct ath_hw *ah = sc->sc_ah;
+	char buf[32];
+	unsigned long dynack;
+	ssize_t len;
+	u32 rfilt;
+
+	len = min(count, sizeof(buf) - 1);
+	if (copy_from_user(buf, user_buf, len))
+		return -EFAULT;
+
+	buf[len] = '\0';
+	if (kstrtoul(buf, 0, &dynack))
+			return -EINVAL;
+
+	ah->dynack.enabled = dynack;
+
+	rfilt = ath_calcrxfilter(sc);
+	ath9k_hw_setrxfilter(ah, rfilt);
+
+	if (ah->dynack.enabled)
+		ath_dynack_reset(ah);
+	else
+		ath9k_hw_init_global_settings(ah);
+
+	return count;
+}
+
+static const struct file_operations fops_dynack = {
+	.read = read_file_dynack,
+	.write = write_file_dynack,
+	.open = simple_open,
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,
+};
+
+static ssize_t read_file_ackto(struct file *file, char __user *user_buf,
+			       size_t count, loff_t *ppos)
+{
+	struct ath_softc *sc = file->private_data;
+	struct ath_hw *ah = sc->sc_ah;
+	char buf[32];
+	unsigned int len;
+
+	len = sprintf(buf, "%u %c\n", ah->dynack.ackto,
+		      (ah->dynack.enabled) ? 'A' : 'S');
+
+	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
+}
+
+static const struct file_operations fops_ackto = {
+	.read = read_file_ackto,
+	.open = simple_open,
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,
+};
+#endif
+
 /* Ethtool support for get-stats */
 
 #define AMKSTR(nm) #nm "_BE", #nm "_BK", #nm "_VI", #nm "_VO"
@@ -1374,5 +1449,12 @@ int ath9k_init_debug(struct ath_hw *ah)
 			    &fops_btcoex);
 #endif
 
+#ifdef CONFIG_ATH9K_DYNACK
+	debugfs_create_file("dynack", S_IRUSR | S_IWUSR,
+			    sc->debug.debugfs_phy, sc, &fops_dynack);
+	debugfs_create_file("ack_to", S_IRUSR | S_IWUSR, sc->debug.debugfs_phy,
+			    sc, &fops_ackto);
+#endif
+
 	return 0;
 }
-- 
1.9.1

