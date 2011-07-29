Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:42792 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755728Ab1G2MI4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jul 2011 08:08:56 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH v2 06/13] ath9k: Dump modal eeprom header
Date: Fri, 29 Jul 2011 17:38:13 +0530
Message-ID: <1311941300-2590-6-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20110729_140902_330495_E80EB754)
In-Reply-To: <1311941300-2590-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1311941300-2590-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Debugfs file location:
<debugfs_mnt>/ieee80211/phy#/ath9k/modal_eeprom

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/debug.c |   30 ++++++++++++++++++++++++++++++
 1 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index cdd370c..9bec3b8 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -1191,6 +1191,34 @@ static const struct file_operations fops_base_eeprom = {
 	.llseek = default_llseek,
 };
 
+static ssize_t read_file_modal_eeprom(struct file *file, char __user *user_buf,
+				      size_t count, loff_t *ppos)
+{
+	struct ath_softc *sc = file->private_data;
+	struct ath_hw *ah = sc->sc_ah;
+	u32 len = 0, size = 6000;
+	char *buf;
+	size_t retval;
+
+	buf = kzalloc(size, GFP_KERNEL);
+	if (buf == NULL)
+		return -ENOMEM;
+
+	len = ah->eep_ops->dump_eeprom(ah, false, buf, len, size);
+
+	retval = simple_read_from_buffer(user_buf, count, ppos, buf, len);
+	kfree(buf);
+
+	return retval;
+}
+
+static const struct file_operations fops_modal_eeprom = {
+	.read = read_file_modal_eeprom,
+	.open = ath9k_debugfs_open,
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,
+};
+
 int ath9k_init_debug(struct ath_hw *ah)
 {
 	struct ath_common *common = ath9k_hw_common(ah);
@@ -1236,6 +1264,8 @@ int ath9k_init_debug(struct ath_hw *ah)
 			    &fops_regdump);
 	debugfs_create_file("base_eeprom", S_IRUSR, sc->debug.debugfs_phy, sc,
 			    &fops_base_eeprom);
+	debugfs_create_file("modal_eeprom", S_IRUSR, sc->debug.debugfs_phy, sc,
+			    &fops_modal_eeprom);
 
 	debugfs_create_u32("gpio_mask", S_IRUSR | S_IWUSR,
 			   sc->debug.debugfs_phy, &sc->sc_ah->gpio_mask);
-- 
1.7.6

