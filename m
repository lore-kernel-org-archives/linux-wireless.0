Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:33783 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727141AbeICWMC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Sep 2018 18:12:02 -0400
Received: by mail-wm0-f67.google.com with SMTP id r1-v6so7257297wmh.0
        for <linux-wireless@vger.kernel.org>; Mon, 03 Sep 2018 10:50:47 -0700 (PDT)
From: =?UTF-8?q?Tomislav=20Po=C5=BEega?= <pozega.tomislav@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, ath9k-devel@qca.qualcomm.com,
        ath9k_htc_fw@lists.infradead.org
Subject: [PATCH 1/3] debug: use common debug for ack timeout output
Date: Mon,  3 Sep 2018 19:50:31 +0200
Message-Id: <1535997033-16330-1-git-send-email-pozega.tomislav@gmail.com> (sfid-20180903_195103_577334_F577E511)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move ack debug code to common-debug and adjust
ath9k/ath9k_htc debug for common ack output.

Signed-off-by: Tomislav Požega <pozega.tomislav@gmail.com>
---
 drivers/net/wireless/ath/ath9k/common-debug.c  |   29 ++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/common-debug.h  |    7 +++++
 drivers/net/wireless/ath/ath9k/debug.c         |   26 +--------------------
 drivers/net/wireless/ath/ath9k/htc_drv_debug.c |    4 +++
 4 files changed, 41 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/common-debug.c b/drivers/net/wireless/ath/ath9k/common-debug.c
index 239429f..230fe55 100644
--- a/drivers/net/wireless/ath/ath9k/common-debug.c
+++ b/drivers/net/wireless/ath/ath9k/common-debug.c
@@ -258,3 +258,32 @@ void ath9k_cmn_debug_phy_err(struct dentry *debugfs_phy,
 			    &fops_phy_err);
 }
 EXPORT_SYMBOL(ath9k_cmn_debug_phy_err);
+
+#ifdef CONFIG_ATH9K_DYNACK
+static ssize_t read_file_ackto(struct file *file, char __user *user_buf,
+                               size_t count, loff_t *ppos)
+{
+        struct ath_hw *ah = file->private_data;
+        char buf[32];
+        unsigned int len;
+
+        len = sprintf(buf, "%u %c\n", ah->dynack.ackto,
+                      (ah->dynack.enabled) ? 'A' : 'S');
+
+        return simple_read_from_buffer(user_buf, count, ppos, buf, len);
+}
+
+static const struct file_operations fops_ackto = {
+        .read = read_file_ackto,
+        .open = simple_open,
+        .owner = THIS_MODULE,
+        .llseek = default_llseek,
+};
+
+void ath9k_cmn_debug_ack_to(struct dentry *debugfs_phy,
+			    struct ath_hw *ah)
+{
+	debugfs_create_file("ack_to", 0400, debugfs_phy, ah, &fops_ackto);
+}
+EXPORT_SYMBOL(ath9k_cmn_debug_ack_to);
+#endif
diff --git a/drivers/net/wireless/ath/ath9k/common-debug.h b/drivers/net/wireless/ath/ath9k/common-debug.h
index 3376990..a4bc75f 100644
--- a/drivers/net/wireless/ath/ath9k/common-debug.h
+++ b/drivers/net/wireless/ath/ath9k/common-debug.h
@@ -71,6 +71,8 @@ void ath9k_cmn_debug_recv(struct dentry *debugfs_phy,
 			  struct ath_rx_stats *rxstats);
 void ath9k_cmn_debug_phy_err(struct dentry *debugfs_phy,
 			     struct ath_rx_stats *rxstats);
+void ath9k_cmn_debug_ack_to(struct dentry *debugfs_phy,
+			    struct ath_hw *ah);
 #else
 static inline void ath9k_cmn_debug_modal_eeprom(struct dentry *debugfs_phy,
 						struct ath_hw *ah)
@@ -96,4 +98,9 @@ static inline void ath9k_cmn_debug_phy_err(struct dentry *debugfs_phy,
 					   struct ath_rx_stats *rxstats)
 {
 }
+
+static inline void ath9k_cmn_debug_ack_to(struct dentry *debugfs_phy,
+					  struct ath_hw *ah)
+{
+}
 #endif /* CONFIG_ATH9K_COMMON_DEBUG */
diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 0a6eb8a..d2ea0b1 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -1038,29 +1038,6 @@ static ssize_t read_file_btcoex(struct file *file, char __user *user_buf,
 };
 #endif
 
-#ifdef CONFIG_ATH9K_DYNACK
-static ssize_t read_file_ackto(struct file *file, char __user *user_buf,
-			       size_t count, loff_t *ppos)
-{
-	struct ath_softc *sc = file->private_data;
-	struct ath_hw *ah = sc->sc_ah;
-	char buf[32];
-	unsigned int len;
-
-	len = sprintf(buf, "%u %c\n", ah->dynack.ackto,
-		      (ah->dynack.enabled) ? 'A' : 'S');
-
-	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
-}
-
-static const struct file_operations fops_ackto = {
-	.read = read_file_ackto,
-	.open = simple_open,
-	.owner = THIS_MODULE,
-	.llseek = default_llseek,
-};
-#endif
-
 #ifdef CONFIG_ATH9K_WOW
 
 static ssize_t read_file_wow(struct file *file, char __user *user_buf,
@@ -1451,8 +1428,7 @@ int ath9k_init_debug(struct ath_hw *ah)
 #endif
 
 #ifdef CONFIG_ATH9K_DYNACK
-	debugfs_create_file("ack_to", 0400, sc->debug.debugfs_phy,
-			    sc, &fops_ackto);
+	ath9k_cmn_dbg_ack_to(sc->debug.debugfs_phy, sc->sc_ah);
 #endif
 	debugfs_create_file("tpc", 0600, sc->debug.debugfs_phy, sc, &fops_tpc);
 
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_debug.c b/drivers/net/wireless/ath/ath9k/htc_drv_debug.c
index b3ed65e..a345da8 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_debug.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_debug.c
@@ -520,5 +520,9 @@ int ath9k_htc_init_debug(struct ath_hw *ah)
 	ath9k_cmn_debug_base_eeprom(priv->debug.debugfs_phy, priv->ah);
 	ath9k_cmn_debug_modal_eeprom(priv->debug.debugfs_phy, priv->ah);
 
+#ifdef CONFIG_ATH9K_DYNACK
+	ath9k_cmn_debug_ack_to(priv->debug.debugfs_phy, priv->ah);
+#endif
+
 	return 0;
 }
-- 
1.7.0.4
