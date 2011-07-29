Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:14691 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755619Ab1G2MIu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jul 2011 08:08:50 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH v2 05/13] ath9k: Dump base eeprom header
Date: Fri, 29 Jul 2011 17:38:12 +0530
Message-ID: <1311941300-2590-5-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20110729_140853_776852_51D56F80)
In-Reply-To: <1311941300-2590-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1311941300-2590-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Debugfs file location:
<debugfs_mnt>/ieee80211/phy#/ath9k/base_eeprom

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/debug.c |   30 ++++++++++++++++++++++++++++++
 1 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index d1eb896..cdd370c 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -1163,6 +1163,34 @@ static const struct file_operations fops_regdump = {
 	.llseek = default_llseek,/* read accesses f_pos */
 };
 
+static ssize_t read_file_base_eeprom(struct file *file, char __user *user_buf,
+				     size_t count, loff_t *ppos)
+{
+	struct ath_softc *sc = file->private_data;
+	struct ath_hw *ah = sc->sc_ah;
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
+	.open = ath9k_debugfs_open,
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,
+};
+
 int ath9k_init_debug(struct ath_hw *ah)
 {
 	struct ath_common *common = ath9k_hw_common(ah);
@@ -1206,6 +1234,8 @@ int ath9k_init_debug(struct ath_hw *ah)
 			    &ah->config.cwm_ignore_extcca);
 	debugfs_create_file("regdump", S_IRUSR, sc->debug.debugfs_phy, sc,
 			    &fops_regdump);
+	debugfs_create_file("base_eeprom", S_IRUSR, sc->debug.debugfs_phy, sc,
+			    &fops_base_eeprom);
 
 	debugfs_create_u32("gpio_mask", S_IRUSR | S_IWUSR,
 			   sc->debug.debugfs_phy, &sc->sc_ah->gpio_mask);
-- 
1.7.6

