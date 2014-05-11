Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:58958 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757978AbaEKIFi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 May 2014 04:05:38 -0400
From: Oleksij Rempel <linux@rempel-privat.de>
To: ath9k-devel@venema.h4ckr.net, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH 03/10] ath9k: move base_eeprom debug code to ath9k_cmn_debug_base_eeprom
Date: Sun, 11 May 2014 10:04:33 +0200
Message-Id: <1399795480-7459-4-git-send-email-linux@rempel-privat.de> (sfid-20140511_100559_949591_D6EFD1E3)
In-Reply-To: <1399795480-7459-1-git-send-email-linux@rempel-privat.de>
References: <1399795480-7459-1-git-send-email-linux@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
---
 drivers/net/wireless/ath/ath9k/common-debug.c | 35 +++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/common-debug.h |  2 ++
 drivers/net/wireless/ath/ath9k/debug.c        | 31 +-----------------------
 3 files changed, 38 insertions(+), 30 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/common-debug.c b/drivers/net/wireless/ath/ath9k/common-debug.c
index da5efdb..f2234e0 100644
--- a/drivers/net/wireless/ath/ath9k/common-debug.c
+++ b/drivers/net/wireless/ath/ath9k/common-debug.c
@@ -51,3 +51,38 @@ void ath9k_cmn_debug_modal_eeprom(struct dentry *debugfs_phy,
 			    &fops_modal_eeprom);
 }
 EXPORT_SYMBOL(ath9k_cmn_debug_modal_eeprom);
+
+static ssize_t read_file_base_eeprom(struct file *file, char __user *user_buf,
+				     size_t count, loff_t *ppos)
+{
+	struct ath_hw *ah = file->private_data;
+	u32 len = 0, size = 1500;
+	ssize_t retval = 0;
+	char *buf;
+
+	buf = kzalloc(size, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	len = ah->eep_ops->dump_eeprom(ah, true, buf, len, size);
+
+	retval = simple_read_from_buffer(user_buf, count, ppos, buf, len);
+	kfree(buf);
+
+	return retval;
+}
+
+static const struct file_operations fops_base_eeprom = {
+	.read = read_file_base_eeprom,
+	.open = simple_open,
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,
+};
+
+void ath9k_cmn_debug_base_eeprom(struct dentry *debugfs_phy,
+				 struct ath_hw *ah)
+{
+	debugfs_create_file("base_eeprom", S_IRUSR, debugfs_phy, ah,
+			    &fops_base_eeprom);
+}
+EXPORT_SYMBOL(ath9k_cmn_debug_base_eeprom);
diff --git a/drivers/net/wireless/ath/ath9k/common-debug.h b/drivers/net/wireless/ath/ath9k/common-debug.h
index 062c007..78eaf90 100644
--- a/drivers/net/wireless/ath/ath9k/common-debug.h
+++ b/drivers/net/wireless/ath/ath9k/common-debug.h
@@ -16,3 +16,5 @@
 
 void ath9k_cmn_debug_modal_eeprom(struct dentry *debugfs_phy,
 				  struct ath_hw *ah);
+void ath9k_cmn_debug_base_eeprom(struct dentry *debugfs_phy,
+				 struct ath_hw *ah);
diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 1825a49..361f0793 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -1268,34 +1268,6 @@ static const struct file_operations fops_dump_nfcal = {
 	.llseek = default_llseek,
 };
 
-static ssize_t read_file_base_eeprom(struct file *file, char __user *user_buf,
-				     size_t count, loff_t *ppos)
-{
-	struct ath_softc *sc = file->private_data;
-	struct ath_hw *ah = sc->sc_ah;
-	u32 len = 0, size = 1500;
-	ssize_t retval = 0;
-	char *buf;
-
-	buf = kzalloc(size, GFP_KERNEL);
-	if (!buf)
-		return -ENOMEM;
-
-	len = ah->eep_ops->dump_eeprom(ah, true, buf, len, size);
-
-	retval = simple_read_from_buffer(user_buf, count, ppos, buf, len);
-	kfree(buf);
-
-	return retval;
-}
-
-static const struct file_operations fops_base_eeprom = {
-	.read = read_file_base_eeprom,
-	.open = simple_open,
-	.owner = THIS_MODULE,
-	.llseek = default_llseek,
-};
-
 #ifdef CONFIG_ATH9K_BTCOEX_SUPPORT
 static ssize_t read_file_btcoex(struct file *file, char __user *user_buf,
 				size_t count, loff_t *ppos)
@@ -1519,9 +1491,8 @@ int ath9k_init_debug(struct ath_hw *ah)
 			    &fops_regdump);
 	debugfs_create_file("dump_nfcal", S_IRUSR, sc->debug.debugfs_phy, sc,
 			    &fops_dump_nfcal);
-	debugfs_create_file("base_eeprom", S_IRUSR, sc->debug.debugfs_phy, sc,
-			    &fops_base_eeprom);
 
+	ath9k_cmn_debug_base_eeprom(sc->debug.debugfs_phy, sc->sc_ah);
 	ath9k_cmn_debug_modal_eeprom(sc->debug.debugfs_phy, sc->sc_ah);
 
 	debugfs_create_u32("gpio_mask", S_IRUSR | S_IWUSR,
-- 
1.9.1

