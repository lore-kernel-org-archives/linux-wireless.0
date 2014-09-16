Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:45545 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756090AbaIPAN0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2014 20:13:26 -0400
Received: by mail-wi0-f174.google.com with SMTP id n3so5300079wiv.1
        for <linux-wireless@vger.kernel.org>; Mon, 15 Sep 2014 17:13:24 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCHv2 08/10] ath9k: add debugfs support for dynack
Date: Tue, 16 Sep 2014 02:13:14 +0200
Message-Id: <1410826396-15544-9-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20140916_021337_269339_C58C48B4)
In-Reply-To: <1410826396-15544-1-git-send-email-lorenzo.bianconi83@gmail.com>
References: <1410826396-15544-1-git-send-email-lorenzo.bianconi83@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add ack_to entry to debugfs in order to dump current ACK timeout value

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
---
 drivers/net/wireless/ath/ath9k/debug.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 5d8b5ea..46f20a3 100644
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

