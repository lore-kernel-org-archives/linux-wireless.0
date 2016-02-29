Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33426 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752854AbcB2WFy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 17:05:54 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 042/113] rtl8xxxu: Initial implementation of rtl8723bu_config_channel()
Date: Mon, 29 Feb 2016 17:04:40 -0500
Message-Id: <1456783551-28315-43-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160229_232953_814053_4D4C2CE9)
In-Reply-To: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

This is a first stab of implementing rtl8723bu_config_channel(). For
now this will only do 20MHz channels.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c   | 134 +++++++++++++++++++++
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h   |   1 +
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h  |  14 +++
 3 files changed, 149 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index cd13524..1626bd8 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -1777,6 +1777,136 @@ static void rtl8723au_config_channel(struct ieee80211_hw *hw)
 	}
 }
 
+static void rtl8723bu_config_channel(struct ieee80211_hw *hw)
+{
+	struct rtl8xxxu_priv *priv = hw->priv;
+	u32 val32, rsr;
+	u8 val8, opmode, subchannel;
+	u16 rf_mode_bw;
+	bool ht = true;
+	int sec_ch_above, channel;
+	int i;
+
+	rf_mode_bw = rtl8xxxu_read16(priv, REG_WMAC_TRXPTCL_CTL);
+	rf_mode_bw &= ~WMAC_TRXPTCL_CTL_BW_MASK;
+	rsr = rtl8xxxu_read32(priv, REG_RESPONSE_RATE_SET);
+	channel = hw->conf.chandef.chan->hw_value;
+
+/* Hack */
+	subchannel = 0;
+
+	switch (hw->conf.chandef.width) {
+	case NL80211_CHAN_WIDTH_20_NOHT:
+		ht = false;
+	case NL80211_CHAN_WIDTH_20:
+		rf_mode_bw |= WMAC_TRXPTCL_CTL_BW_20;
+		subchannel = 0;
+
+		val32 = rtl8xxxu_read32(priv, REG_FPGA0_RF_MODE);
+		val32 &= ~FPGA_RF_MODE;
+		rtl8xxxu_write32(priv, REG_FPGA0_RF_MODE, val32);
+
+		val32 = rtl8xxxu_read32(priv, REG_FPGA1_RF_MODE);
+		val32 &= ~FPGA_RF_MODE;
+		rtl8xxxu_write32(priv, REG_FPGA1_RF_MODE, val32);
+
+		val32 = rtl8xxxu_read32(priv, REG_OFDM0_TX_PSDO_NOISE_WEIGHT);
+		val32 &= ~(BIT(30) | BIT(31));
+		rtl8xxxu_write32(priv, REG_OFDM0_TX_PSDO_NOISE_WEIGHT, val32);
+
+		break;
+	case NL80211_CHAN_WIDTH_40:
+		rf_mode_bw |= WMAC_TRXPTCL_CTL_BW_40;
+
+		if (hw->conf.chandef.center_freq1 >
+		    hw->conf.chandef.chan->center_freq) {
+			sec_ch_above = 1;
+			channel += 2;
+		} else {
+			sec_ch_above = 0;
+			channel -= 2;
+		}
+
+		val32 = rtl8xxxu_read32(priv, REG_FPGA0_RF_MODE);
+		val32 |= FPGA_RF_MODE;
+		rtl8xxxu_write32(priv, REG_FPGA0_RF_MODE, val32);
+
+		val32 = rtl8xxxu_read32(priv, REG_FPGA1_RF_MODE);
+		val32 |= FPGA_RF_MODE;
+		rtl8xxxu_write32(priv, REG_FPGA1_RF_MODE, val32);
+
+		/*
+		 * Set Control channel to upper or lower. These settings
+		 * are required only for 40MHz
+		 */
+		val32 = rtl8xxxu_read32(priv, REG_CCK0_SYSTEM);
+		val32 &= ~CCK0_SIDEBAND;
+		if (!sec_ch_above)
+			val32 |= CCK0_SIDEBAND;
+		rtl8xxxu_write32(priv, REG_CCK0_SYSTEM, val32);
+
+		val32 = rtl8xxxu_read32(priv, REG_OFDM1_LSTF);
+		val32 &= ~OFDM_LSTF_PRIME_CH_MASK; /* 0xc00 */
+		if (sec_ch_above)
+			val32 |= OFDM_LSTF_PRIME_CH_LOW;
+		else
+			val32 |= OFDM_LSTF_PRIME_CH_HIGH;
+		rtl8xxxu_write32(priv, REG_OFDM1_LSTF, val32);
+
+		val32 = rtl8xxxu_read32(priv, REG_FPGA0_POWER_SAVE);
+		val32 &= ~(FPGA0_PS_LOWER_CHANNEL | FPGA0_PS_UPPER_CHANNEL);
+		if (sec_ch_above)
+			val32 |= FPGA0_PS_UPPER_CHANNEL;
+		else
+			val32 |= FPGA0_PS_LOWER_CHANNEL;
+		rtl8xxxu_write32(priv, REG_FPGA0_POWER_SAVE, val32);
+		break;
+	case NL80211_CHAN_WIDTH_80:
+		rf_mode_bw |= WMAC_TRXPTCL_CTL_BW_80;
+		break;
+	default:
+		break;
+	}
+
+	for (i = RF_A; i < priv->rf_paths; i++) {
+		val32 = rtl8xxxu_read_rfreg(priv, i, RF6052_REG_MODE_AG);
+		val32 &= ~MODE_AG_CHANNEL_MASK;
+		val32 |= channel;
+		rtl8xxxu_write_rfreg(priv, i, RF6052_REG_MODE_AG, val32);
+	}
+
+	rtl8xxxu_write16(priv, REG_WMAC_TRXPTCL_CTL, rf_mode_bw);
+	rtl8xxxu_write8(priv, REG_DATA_SUBCHANNEL, subchannel);
+
+	if (ht)
+		val8 = 0x0e;
+	else
+		val8 = 0x0a;
+
+	rtl8xxxu_write8(priv, REG_SIFS_CCK + 1, val8);
+	rtl8xxxu_write8(priv, REG_SIFS_OFDM + 1, val8);
+
+	rtl8xxxu_write16(priv, REG_R2T_SIFS, 0x0808);
+	rtl8xxxu_write16(priv, REG_T2T_SIFS, 0x0a0a);
+
+	for (i = RF_A; i < priv->rf_paths; i++) {
+		val32 = rtl8xxxu_read_rfreg(priv, i, RF6052_REG_MODE_AG);
+		val32 &= ~MODE_AG_BW_MASK;
+		switch(hw->conf.chandef.width) {
+		case NL80211_CHAN_WIDTH_80:
+			val32 |= MODE_AG_BW_80MHZ_8723B;
+			break;
+		case NL80211_CHAN_WIDTH_40:
+			val32 |= MODE_AG_BW_40MHZ_8723B;
+			break;
+		default:
+			val32 |= MODE_AG_BW_20MHZ_8723B;
+			break;
+		}
+		rtl8xxxu_write_rfreg(priv, i, RF6052_REG_MODE_AG, val32);
+	}
+}
+
 static void
 rtl8723a_set_tx_power(struct rtl8xxxu_priv *priv, int channel, bool ht40)
 {
@@ -7321,6 +7451,7 @@ static struct rtl8xxxu_fileops rtl8723au_fops = {
 	.power_on = rtl8723au_power_on,
 	.llt_init = rtl8xxxu_init_llt_table,
 	.phy_iq_calibrate = rtl8723au_phy_iq_calibrate,
+	.config_channel = rtl8723au_config_channel,
 	.writeN_block_size = 1024,
 	.mbox_ext_reg = REG_HMBOX_EXT_0,
 	.mbox_ext_width = 2,
@@ -7337,6 +7468,7 @@ static struct rtl8xxxu_fileops rtl8723bu_fops = {
 	.llt_init = rtl8xxxu_auto_llt_table,
 	.phy_init_antenna_selection = rtl8723bu_phy_init_antenna_selection,
 	.phy_iq_calibrate = rtl8723bu_phy_iq_calibrate,
+	.config_channel = rtl8723bu_config_channel,
 	.writeN_block_size = 1024,
 	.mbox_ext_reg = REG_HMBOX_EXT0_8723B,
 	.mbox_ext_width = 4,
@@ -7355,6 +7487,7 @@ static struct rtl8xxxu_fileops rtl8192cu_fops = {
 	.power_on = rtl8192cu_power_on,
 	.llt_init = rtl8xxxu_init_llt_table,
 	.phy_iq_calibrate = rtl8723au_phy_iq_calibrate,
+	.config_channel = rtl8723au_config_channel,
 	.writeN_block_size = 128,
 	.mbox_ext_reg = REG_HMBOX_EXT_0,
 	.mbox_ext_width = 2,
@@ -7372,6 +7505,7 @@ static struct rtl8xxxu_fileops rtl8192eu_fops = {
 	.power_on = rtl8192eu_power_on,
 	.llt_init = rtl8xxxu_auto_llt_table,
 	.phy_iq_calibrate = rtl8723bu_phy_iq_calibrate,
+	.config_channel = rtl8723bu_config_channel,
 	.writeN_block_size = 128,
 	.mbox_ext_reg = REG_HMBOX_EXT0_8723B,
 	.mbox_ext_width = 4,
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
index 6c6bac2..bce52cd 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
@@ -861,6 +861,7 @@ struct rtl8xxxu_fileops {
 	int (*llt_init) (struct rtl8xxxu_priv *priv, u8 last_tx_page);
 	void (*phy_init_antenna_selection) (struct rtl8xxxu_priv *priv);
 	void (*phy_iq_calibrate) (struct rtl8xxxu_priv *priv);
+	void (*config_channel) (struct ieee80211_hw *hw);
 	int writeN_block_size;
 	u16 mbox_ext_reg;
 	char mbox_ext_width;
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
index 499210f..147deba 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
@@ -473,6 +473,9 @@
 #define REG_FAST_EDCA_CTRL		0x0460
 #define REG_RD_RESP_PKT_TH		0x0463
 #define REG_INIRTS_RATE_SEL		0x0480
+/* 8723bu */
+#define REG_DATA_SUBCHANNEL		0x0483
+/* 8723au */
 #define REG_INIDATA_RATE_SEL		0x0484
 
 #define REG_POWER_STATUS		0x04a4
@@ -658,6 +661,10 @@
 #define REG_FWDLY			0x0661
 #define REG_RXERR_RPT			0x0664
 #define REG_WMAC_TRXPTCL_CTL		0x0668
+#define  WMAC_TRXPTCL_CTL_BW_MASK	(BIT(7) | BIT(8))
+#define  WMAC_TRXPTCL_CTL_BW_20		0
+#define  WMAC_TRXPTCL_CTL_BW_40		BIT(7)
+#define  WMAC_TRXPTCL_CTL_BW_80		BIT(8)
 
 /*  Security */
 #define REG_CAM_CMD			0x0670
@@ -872,6 +879,9 @@
 
 #define REG_OFDM0_RX_IQ_EXT_ANTA	0x0ca0
 
+/* 8723bu */
+#define REG_OFDM0_TX_PSDO_NOISE_WEIGHT	0x0ce4
+
 #define REG_OFDM1_LSTF			0x0d00
 #define  OFDM_LSTF_PRIME_CH_LOW		BIT(10)
 #define  OFDM_LSTF_PRIME_CH_HIGH	BIT(11)
@@ -1030,6 +1040,10 @@
 #define RF6052_REG_MODE_AG		0x18	/* RF channel and BW switch */
 #define  MODE_AG_CHANNEL_MASK		0x3ff
 #define  MODE_AG_CHANNEL_20MHZ		BIT(10)
+#define  MODE_AG_BW_MASK		(BIT(10) | BIT(11))
+#define  MODE_AG_BW_20MHZ_8723B		(BIT(10) | BIT(11))
+#define  MODE_AG_BW_40MHZ_8723B		BIT(10)
+#define  MODE_AG_BW_80MHZ_8723B		0
 
 #define RF6052_REG_TOP			0x19
 #define RF6052_REG_RX_G1		0x1a
-- 
2.5.0

