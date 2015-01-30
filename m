Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:52801 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932563AbbA3Ncx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jan 2015 08:32:53 -0500
Received: from [117.207.72.194] (port=10794 helo=sujith-pixel.qualcomm.com)
	by server72.web-hosting.com with esmtpsa (UNKNOWN:AES128-SHA256:128)
	(Exim 4.82)
	(envelope-from <sujith@msujith.org>)
	id 1YHBgq-004FiR-To
	for linux-wireless@vger.kernel.org; Fri, 30 Jan 2015 08:32:53 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 10/17] ath9k: Add a debugfs file for WOW
Date: Fri, 30 Jan 2015 19:05:30 +0530
Message-Id: <1422624937-4810-11-git-send-email-sujith@msujith.org> (sfid-20150130_143258_037591_2EEA2E40)
In-Reply-To: <1422624937-4810-1-git-send-email-sujith@msujith.org>
References: <1422624937-4810-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

This can be used to force WOW for cards that
are not present in the supported PCI ID list.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |  1 +
 drivers/net/wireless/ath/ath9k/debug.c | 68 ++++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/wow.c   |  4 +-
 3 files changed, 71 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 803a7d4..20216c5 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -1044,6 +1044,7 @@ struct ath_softc {
 
 #ifdef CONFIG_ATH9K_WOW
 	u32 wow_intr_before_sleep;
+	bool force_wow;
 #endif
 };
 
diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index dd5d391..50a2e0a 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -1043,6 +1043,69 @@ static const struct file_operations fops_ackto = {
 };
 #endif
 
+#ifdef CONFIG_ATH9K_WOW
+
+static ssize_t read_file_wow(struct file *file, char __user *user_buf,
+			     size_t count, loff_t *ppos)
+{
+	struct ath_softc *sc = file->private_data;
+	unsigned int len = 0, size = 32;
+	ssize_t retval;
+	char *buf;
+
+	buf = kzalloc(size, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	len += scnprintf(buf + len, size - len, "WOW: %s\n",
+			 sc->force_wow ? "ENABLED" : "DISABLED");
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
+static ssize_t write_file_wow(struct file *file, const char __user *user_buf,
+			      size_t count, loff_t *ppos)
+{
+	struct ath_softc *sc = file->private_data;
+	unsigned long val;
+	char buf[32];
+	ssize_t len;
+
+	len = min(count, sizeof(buf) - 1);
+	if (copy_from_user(buf, user_buf, len))
+		return -EFAULT;
+
+	buf[len] = '\0';
+	if (kstrtoul(buf, 0, &val))
+		return -EINVAL;
+
+	if (val != 1)
+		return -EINVAL;
+
+	if (!sc->force_wow) {
+		sc->force_wow = true;
+		ath9k_init_wow(sc->hw);
+	}
+
+	return count;
+}
+
+static const struct file_operations fops_wow = {
+	.read = read_file_wow,
+	.write = write_file_wow,
+	.open = simple_open,
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,
+};
+
+#endif
+
 static ssize_t read_file_tpc(struct file *file, char __user *user_buf,
 			     size_t count, loff_t *ppos)
 {
@@ -1313,6 +1376,11 @@ int ath9k_init_debug(struct ath_hw *ah)
 			    &fops_btcoex);
 #endif
 
+#ifdef CONFIG_ATH9K_WOW
+	debugfs_create_file("wow", S_IRUSR | S_IWUSR,
+			    sc->debug.debugfs_phy, sc, &fops_wow);
+#endif
+
 #ifdef CONFIG_ATH9K_DYNACK
 	debugfs_create_file("ack_to", S_IRUSR | S_IWUSR, sc->debug.debugfs_phy,
 			    sc, &fops_ackto);
diff --git a/drivers/net/wireless/ath/ath9k/wow.c b/drivers/net/wireless/ath/ath9k/wow.c
index d4cfbc3..4b3b565 100644
--- a/drivers/net/wireless/ath/ath9k/wow.c
+++ b/drivers/net/wireless/ath/ath9k/wow.c
@@ -327,7 +327,7 @@ void ath9k_init_wow(struct ieee80211_hw *hw)
 {
 	struct ath_softc *sc = hw->priv;
 
-	if (sc->driver_data & ATH9K_PCI_WOW) {
+	if ((sc->driver_data & ATH9K_PCI_WOW) || sc->force_wow) {
 		hw->wiphy->wowlan = &ath9k_wowlan_support;
 		device_init_wakeup(sc->dev, 1);
 	}
@@ -337,6 +337,6 @@ void ath9k_deinit_wow(struct ieee80211_hw *hw)
 {
 	struct ath_softc *sc = hw->priv;
 
-	if (sc->driver_data & ATH9K_PCI_WOW)
+	if ((sc->driver_data & ATH9K_PCI_WOW) || sc->force_wow)
 		device_init_wakeup(sc->dev, 0);
 }
-- 
2.2.2

