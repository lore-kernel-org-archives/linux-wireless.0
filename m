Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33478 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753483AbcB2WGD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 17:06:03 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 072/113] rtl8xxxu: Implement init_statistics for 8723bu
Date: Mon, 29 Feb 2016 17:05:10 -0500
Message-Id: <1456783551-28315-73-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160229_232952_124896_DB1509DD)
In-Reply-To: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Vendor driver implements this for 8723b and 8821 series

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c   | 27 ++++++++++++++++++++++
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h   |  1 +
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h  |  7 ++++++
 3 files changed, 35 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index a0a847c..e586f53 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -5981,6 +5981,29 @@ static void rtl8723bu_init_aggregation(struct rtl8xxxu_priv *priv)
 	rtl8xxxu_write32(priv, REG_RXDMA_AGG_PG_TH, agg_rx);
 }
 
+static void rtl8723bu_init_statistics(struct rtl8xxxu_priv *priv)
+{
+	u32 val32;
+
+	/* Time duration for NHM unit: 4us, 0x2710=40ms */
+	rtl8xxxu_write16(priv, REG_NHM_TIMER_8723B + 2, 0x2710);
+	rtl8xxxu_write16(priv, REG_NHM_TH9_TH10_8723B + 2, 0xffff);
+	rtl8xxxu_write32(priv, REG_NHM_TH3_TO_TH0_8723B, 0xffffff52);
+	rtl8xxxu_write32(priv, REG_NHM_TH7_TO_TH4_8723B, 0xffffffff);
+	/* TH8 */
+	val32 = rtl8xxxu_read32(priv, REG_FPGA0_IQK);
+	val32 |= 0xff;
+	rtl8xxxu_write32(priv, REG_FPGA0_IQK, val32);
+	/* Enable CCK */
+	val32 = rtl8xxxu_read32(priv, REG_NHM_TH9_TH10_8723B);
+	val32 |= BIT(8) | BIT(9) | BIT(10);
+	rtl8xxxu_write32(priv, REG_NHM_TH9_TH10_8723B, val32);
+	/* Max power amongst all RX antennas */
+	val32 = rtl8xxxu_read32(priv, REG_OFDM0_FA_RSTC);
+	val32 |= BIT(7);
+	rtl8xxxu_write32(priv, REG_OFDM0_FA_RSTC, val32);
+}
+
 static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
 {
 	struct rtl8xxxu_priv *priv = hw->priv;
@@ -6371,6 +6394,9 @@ static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
 
 	rtl8xxxu_write16(priv, REG_FAST_EDCA_CTRL, 0);
 
+	if (priv->fops->init_statistics)
+		priv->fops->init_statistics(priv);
+
 	rtl8723a_phy_lc_calibrate(priv);
 
 	priv->fops->phy_iq_calibrate(priv);
@@ -8021,6 +8047,7 @@ static struct rtl8xxxu_fileops rtl8723bu_fops = {
 	.init_bt = rtl8723bu_init_bt,
 	.parse_rx_desc = rtl8723bu_parse_rx_desc,
 	.init_aggregation = rtl8723bu_init_aggregation,
+	.init_statistics = rtl8723bu_init_statistics,
 	.writeN_block_size = 1024,
 	.mbox_ext_reg = REG_HMBOX_EXT0_8723B,
 	.mbox_ext_width = 4,
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
index 14b7a35..b75678b 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
@@ -1134,6 +1134,7 @@ struct rtl8xxxu_fileops {
 	int (*parse_rx_desc) (struct rtl8xxxu_priv *priv, struct sk_buff *skb,
 			      struct ieee80211_rx_status *rx_status);
 	void (*init_aggregation) (struct rtl8xxxu_priv *priv);
+	void (*init_statistics) (struct rtl8xxxu_priv *priv);
 	int writeN_block_size;
 	u16 mbox_ext_reg;
 	char mbox_ext_width;
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
index d6c7ad3..d3f6fa3 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
@@ -833,6 +833,11 @@
 #define REG_FPGA0_ANALOG3		0x0888
 #define REG_FPGA0_ANALOG4		0x088c
 
+#define REG_NHM_TH9_TH10_8723B		0x0890
+#define REG_NHM_TIMER_8723B		0x0894
+#define REG_NHM_TH3_TO_TH0_8723B	0x0898
+#define REG_NHM_TH7_TO_TH4_8723B	0x089c
+
 #define REG_FPGA0_XA_LSSI_READBACK	0x08a0	/* Tranceiver LSSI Readback */
 #define REG_FPGA0_XB_LSSI_READBACK	0x08a4
 #define REG_HSPI_XA_READBACK		0x08b8	/* Transceiver A HSPI read */
@@ -869,6 +874,8 @@
 
 #define REG_OFDM0_TR_MUX_PAR		0x0c08
 
+#define REG_OFDM0_FA_RSTC		0x0c0c
+
 #define REG_OFDM0_XA_RX_IQ_IMBALANCE	0x0c14
 #define REG_OFDM0_XB_RX_IQ_IMBALANCE	0x0c1c
 
-- 
2.5.0

