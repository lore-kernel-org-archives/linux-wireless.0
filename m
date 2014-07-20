Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:37145 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752455AbaGTMbh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Jul 2014 08:31:37 -0400
Received: by mail-wg0-f41.google.com with SMTP id z12so5252558wgg.12
        for <linux-wireless@vger.kernel.org>; Sun, 20 Jul 2014 05:31:36 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@lists.ath9k.org, linville@tuxdriver.com,
	Philippe Duchein <wireless-dev@duchein.net>
Subject: [PATCH 08/10] ath9k: add debugfs support for dynack
Date: Sun, 20 Jul 2014 14:31:24 +0200
Message-Id: <1405859486-31414-9-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20140720_143146_903175_6985DF58)
In-Reply-To: <1405859486-31414-1-git-send-email-lorenzo.bianconi83@gmail.com>
References: <1405859486-31414-1-git-send-email-lorenzo.bianconi83@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add ack_to entry to debugfs in order to dump current ack timeout value.

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
---
 drivers/net/wireless/ath/ath9k/debug.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index d227936..8d77b7a 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -1169,6 +1169,29 @@ static const struct file_operations fops_btcoex = {
 };
 #endif
 
+#ifdef CONFIG_ATH9K_DYNACK
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
@@ -1374,5 +1397,10 @@ int ath9k_init_debug(struct ath_hw *ah)
 			    &fops_btcoex);
 #endif
 
+#ifdef CONFIG_ATH9K_DYNACK
+	debugfs_create_file("ack_to", S_IRUSR | S_IWUSR, sc->debug.debugfs_phy,
+			    sc, &fops_ackto);
+#endif
+
 	return 0;
 }
-- 
1.9.1

