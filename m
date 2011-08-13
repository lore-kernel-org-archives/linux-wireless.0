Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:50048 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900Ab1HME7L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Aug 2011 00:59:11 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH 11/11] ath9k: Dump modal noisefloor calibration history
Date: Sat, 13 Aug 2011 10:28:18 +0530
Message-ID: <1313211498-14442-11-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20110813_065913_682488_BED2C90D)
In-Reply-To: <1313211498-14442-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1313211498-14442-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Debugfs file location:
<debugfs_mnt>/ieee80211/phy#/ath9k/dump_nfcal

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/debug.c |   55 ++++++++++++++++++++++++++++++++
 1 files changed, 55 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 9bec3b8..da45f32 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -1163,6 +1163,59 @@ static const struct file_operations fops_regdump = {
 	.llseek = default_llseek,/* read accesses f_pos */
 };
 
+static ssize_t read_file_dump_nfcal(struct file *file, char __user *user_buf,
+				    size_t count, loff_t *ppos)
+{
+	struct ath_softc *sc = file->private_data;
+	struct ath_hw *ah = sc->sc_ah;
+	struct ath9k_nfcal_hist *h = sc->caldata.nfCalHist;
+	struct ath_common *common = ath9k_hw_common(ah);
+	struct ieee80211_conf *conf = &common->hw->conf;
+	u32 len = 0, size = 1500;
+	u32 i, j;
+	ssize_t retval = 0;
+	char *buf;
+	u8 chainmask = (ah->rxchainmask << 3) | ah->rxchainmask;
+	u8 nread;
+
+	buf = kzalloc(size, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	len += snprintf(buf + len, size - len,
+			"Channel Noise Floor : %d\n", ah->noise);
+	len += snprintf(buf + len, size - len,
+			"Chain | privNF | # Readings | NF Readings\n");
+	for (i = 0; i < NUM_NF_READINGS; i++) {
+		if (!(chainmask & (1 << i)) ||
+		    ((i >= AR5416_MAX_CHAINS) && !conf_is_ht40(conf)))
+			continue;
+
+		nread = AR_PHY_CCA_FILTERWINDOW_LENGTH - h[i].invalidNFcount;
+		len += snprintf(buf + len, size - len, " %d\t %d\t %d\t\t",
+				i, h[i].privNF, nread);
+		for (j = 0; j < nread; j++)
+			len += snprintf(buf + len, size - len,
+					" %d", h[i].nfCalBuffer[j]);
+		len += snprintf(buf + len, size - len, "\n");
+	}
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
+static const struct file_operations fops_dump_nfcal = {
+	.read = read_file_dump_nfcal,
+	.open = ath9k_debugfs_open,
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,
+};
+
 static ssize_t read_file_base_eeprom(struct file *file, char __user *user_buf,
 				     size_t count, loff_t *ppos)
 {
@@ -1262,6 +1315,8 @@ int ath9k_init_debug(struct ath_hw *ah)
 			    &ah->config.cwm_ignore_extcca);
 	debugfs_create_file("regdump", S_IRUSR, sc->debug.debugfs_phy, sc,
 			    &fops_regdump);
+	debugfs_create_file("dump_nfcal", S_IRUSR, sc->debug.debugfs_phy, sc,
+			    &fops_dump_nfcal);
 	debugfs_create_file("base_eeprom", S_IRUSR, sc->debug.debugfs_phy, sc,
 			    &fops_base_eeprom);
 	debugfs_create_file("modal_eeprom", S_IRUSR, sc->debug.debugfs_phy, sc,
-- 
1.7.6

