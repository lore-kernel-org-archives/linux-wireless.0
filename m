Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:23383 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755393Ab1G1R3f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jul 2011 13:29:35 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH 2/9] ath9k: Dump modal eeprom header for AR9003
Date: Thu, 28 Jul 2011 22:59:29 +0530
Message-ID: <1311874176-27569-2-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20110728_192938_405133_498447B7)
In-Reply-To: <1311874176-27569-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1311874176-27569-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Debugfs file location:
<debugfs_mnt>/ieee80211/phy#/ath9k/modal_eeprom

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/debug.c |   96 ++++++++++++++++++++++++++++++++
 1 files changed, 96 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index df71c72..b0a80d5 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -1308,6 +1308,100 @@ static const struct file_operations fops_base_eeprom = {
 	.llseek = default_llseek,
 };
 
+static u32 read_9003_modal_eeprom(char *buf, u32 len, u32 size,
+				  struct ar9300_modal_eep_header *pModal)
+{
+#define PR_EEP(_s, _val)						\
+	do {								\
+		len += snprintf(buf + len, size - len, "%20s : %10d\n",	\
+				_s, (_val));				\
+	} while (0)
+
+	PR_EEP("Chain0 Ant. Control", le16_to_cpu(pModal->antCtrlChain[0]));
+	PR_EEP("Chain1 Ant. Control", le16_to_cpu(pModal->antCtrlChain[1]));
+	PR_EEP("Chain2 Ant. Control", le16_to_cpu(pModal->antCtrlChain[1]));
+	PR_EEP("Ant. Common Control", le32_to_cpu(pModal->antCtrlCommon));
+	PR_EEP("Ant. Common Control2", le32_to_cpu(pModal->antCtrlCommon2));
+	PR_EEP("Ant. Gain", pModal->antennaGain);
+	PR_EEP("Switch Settle", pModal->switchSettling);
+	PR_EEP("Chain0 xatten1DB", pModal->xatten1DB[0]);
+	PR_EEP("Chain1 xatten1DB", pModal->xatten1DB[1]);
+	PR_EEP("Chain2 xatten1DB", pModal->xatten1DB[2]);
+	PR_EEP("Chain0 xatten1Margin", pModal->xatten1Margin[0]);
+	PR_EEP("Chain1 xatten1Margin", pModal->xatten1Margin[1]);
+	PR_EEP("Chain2 xatten1Margin", pModal->xatten1Margin[2]);
+	PR_EEP("Temp Slope", pModal->tempSlope);
+	PR_EEP("Volt Slope", pModal->voltSlope);
+	PR_EEP("spur Channels0", pModal->spurChans[0]);
+	PR_EEP("spur Channels1", pModal->spurChans[1]);
+	PR_EEP("spur Channels2", pModal->spurChans[2]);
+	PR_EEP("spur Channels3", pModal->spurChans[3]);
+	PR_EEP("spur Channels4", pModal->spurChans[4]);
+	PR_EEP("Chain0 NF Threshold", pModal->noiseFloorThreshCh[0]);
+	PR_EEP("Chain1 NF Threshold", pModal->noiseFloorThreshCh[1]);
+	PR_EEP("Chain2 NF Threshold", pModal->noiseFloorThreshCh[2]);
+	PR_EEP("xPA Bias Level", pModal->xpaBiasLvl);
+	PR_EEP("txFrameToDataStart", pModal->txFrameToDataStart);
+	PR_EEP("txFrameToPaOn", pModal->txFrameToPaOn);
+	PR_EEP("txFrameToXpaOn", pModal->txFrameToXpaOn);
+	PR_EEP("txClip", pModal->txClip);
+	PR_EEP("ADC Desired size", pModal->adcDesiredSize);
+	PR_EEP("Chain0 ob", pModal->ob[0]);
+	PR_EEP("Chain1 ob", pModal->ob[1]);
+	PR_EEP("Chain2 ob", pModal->ob[2]);
+
+	PR_EEP("Chain0 db_stage2", pModal->db_stage2[0]);
+	PR_EEP("Chain1 db_stage2", pModal->db_stage2[1]);
+	PR_EEP("Chain2 db_stage2", pModal->db_stage2[2]);
+	PR_EEP("Chain0 db_stage3", pModal->db_stage3[0]);
+	PR_EEP("Chain1 db_stage3", pModal->db_stage3[1]);
+	PR_EEP("Chain2 db_stage3", pModal->db_stage3[2]);
+	PR_EEP("Chain0 db_stage4", pModal->db_stage4[0]);
+	PR_EEP("Chain1 db_stage4", pModal->db_stage4[1]);
+	PR_EEP("Chain2 db_stage4", pModal->db_stage4[2]);
+	if (len > size)
+		len = size;
+
+	return len;
+
+#undef PR_EEP
+}
+
+static ssize_t read_file_modal_eeprom(struct file *file, char __user *user_buf,
+				      size_t count, loff_t *ppos)
+{
+	struct ath_softc *sc = file->private_data;
+	struct ath_hw *ah = sc->sc_ah;
+	struct ar9300_eeprom *eep = &ah->eeprom.ar9300_eep;
+	u32 len = 0, size = 6000;
+	char *buf;
+	size_t retval;
+
+	buf = kzalloc(size, GFP_KERNEL);
+	if (buf == NULL)
+		return -ENOMEM;
+
+	if (!AR_SREV_9300_20_OR_LATER(ah))
+		return 0;
+
+	len += snprintf(buf + len, size - len, "%20s :\n", "2GHz modal Header");
+	len += read_9003_modal_eeprom(buf, len, size, &eep->modalHeader2G);
+	len += snprintf(buf + len, size - len, "%20s :\n", "5GHz modal Header");
+	len += read_9003_modal_eeprom(buf, len, size, &eep->modalHeader5G);
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
@@ -1353,6 +1447,8 @@ int ath9k_init_debug(struct ath_hw *ah)
 			    &fops_regdump);
 	debugfs_create_file("base_eeprom", S_IRUSR, sc->debug.debugfs_phy, sc,
 			    &fops_base_eeprom);
+	debugfs_create_file("modal_eeprom", S_IRUSR, sc->debug.debugfs_phy, sc,
+			    &fops_modal_eeprom);
 
 	debugfs_create_u32("gpio_mask", S_IRUSR | S_IWUSR,
 			   sc->debug.debugfs_phy, &sc->sc_ah->gpio_mask);
-- 
1.7.6

