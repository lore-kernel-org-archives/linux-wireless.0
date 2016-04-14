Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54154 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751506AbcDNUhX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Apr 2016 16:37:23 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 11/16] rtl8xxxu: Add TX power base values for gen1 parts
Date: Thu, 14 Apr 2016 16:37:16 -0400
Message-Id: <1460666241-5365-12-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160414_225529_370590_A630A67C)
In-Reply-To: <1460666241-5365-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1460666241-5365-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 118 ++++++++++++++++++++---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h |  26 +++++
 2 files changed, 130 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 6280d3d..422e7fa 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -214,6 +214,72 @@ static struct rtl8xxxu_reg8val rtl8192e_mac_init_table[] = {
 	{0xffff, 0xff},
 };
 
+static struct rtl8xxxu_power_base rtl8188r_power_base = {
+	.reg_0e00 = 0x06080808,
+	.reg_0e04 = 0x00040406,
+	.reg_0e08 = 0x00000000,
+	.reg_086c = 0x00000000,
+
+	.reg_0e10 = 0x04060608,
+	.reg_0e14 = 0x00020204,
+	.reg_0e18 = 0x04060608,
+	.reg_0e1c = 0x00020204,
+
+	.reg_0830 = 0x06080808,
+	.reg_0834 = 0x00040406,
+	.reg_0838 = 0x00000000,
+	.reg_086c_2 = 0x00000000,
+
+	.reg_083c = 0x04060608,
+	.reg_0848 = 0x00020204,
+	.reg_084c = 0x04060608,
+	.reg_0868 = 0x00020204,
+};
+
+static struct rtl8xxxu_power_base rtl8192c_power_base = {
+	.reg_0e00 = 0x07090c0c,
+	.reg_0e04 = 0x01020405,
+	.reg_0e08 = 0x00000000,
+	.reg_086c = 0x00000000,
+
+	.reg_0e10 = 0x0b0c0c0e,
+	.reg_0e14 = 0x01030506,
+	.reg_0e18 = 0x0b0c0d0e,
+	.reg_0e1c = 0x01030509,
+
+	.reg_0830 = 0x07090c0c,
+	.reg_0834 = 0x01020405,
+	.reg_0838 = 0x00000000,
+	.reg_086c_2 = 0x00000000,
+
+	.reg_083c = 0x0b0c0d0e,
+	.reg_0848 = 0x01030509,
+	.reg_084c = 0x0b0c0d0e,
+	.reg_0868 = 0x01030509,
+};
+
+static struct rtl8xxxu_power_base rtl8723a_power_base = {
+	.reg_0e00 = 0x0a0c0c0c,
+	.reg_0e04 = 0x02040608,
+	.reg_0e08 = 0x00000000,
+	.reg_086c = 0x00000000,
+
+	.reg_0e10 = 0x0a0c0d0e,
+	.reg_0e14 = 0x02040608,
+	.reg_0e18 = 0x0a0c0d0e,
+	.reg_0e1c = 0x02040608,
+
+	.reg_0830 = 0x0a0c0c0c,
+	.reg_0834 = 0x02040608,
+	.reg_0838 = 0x00000000,
+	.reg_086c_2 = 0x00000000,
+
+	.reg_083c = 0x0a0c0d0e,
+	.reg_0848 = 0x02040608,
+	.reg_084c = 0x0a0c0d0e,
+	.reg_0868 = 0x02040608,
+};
+
 static struct rtl8xxxu_reg32val rtl8723a_phy_1t_init_table[] = {
 	{0x800, 0x80040000}, {0x804, 0x00000003},
 	{0x808, 0x0000fc00}, {0x80c, 0x0000000a},
@@ -2410,6 +2476,7 @@ static void rtl8723bu_config_channel(struct ieee80211_hw *hw)
 static void
 rtl8723a_set_tx_power(struct rtl8xxxu_priv *priv, int channel, bool ht40)
 {
+	struct rtl8xxxu_power_base *power_base = priv->power_base;
 	u8 cck[RTL8723A_MAX_RF_PATHS], ofdm[RTL8723A_MAX_RF_PATHS];
 	u8 ofdmbase[RTL8723A_MAX_RF_PATHS], mcsbase[RTL8723A_MAX_RF_PATHS];
 	u32 val32, ofdm_a, ofdm_b, mcs_a, mcs_b;
@@ -2418,8 +2485,8 @@ rtl8723a_set_tx_power(struct rtl8xxxu_priv *priv, int channel, bool ht40)
 
 	group = rtl8723a_channel_to_group(channel);
 
-	cck[0] = priv->cck_tx_power_index_A[group];
-	cck[1] = priv->cck_tx_power_index_B[group];
+	cck[0] = priv->cck_tx_power_index_A[group] - 1;
+	cck[1] = priv->cck_tx_power_index_B[group] - 1;
 
 	if (priv->hi_pa) {
 		if (cck[0] > 0x20)
@@ -2430,6 +2497,10 @@ rtl8723a_set_tx_power(struct rtl8xxxu_priv *priv, int channel, bool ht40)
 
 	ofdm[0] = priv->ht40_1s_tx_power_index_A[group];
 	ofdm[1] = priv->ht40_1s_tx_power_index_B[group];
+	if (ofdm[0])
+		ofdm[0] -= 1;
+	if (ofdm[1])
+		ofdm[1] -= 1;
 
 	ofdmbase[0] = ofdm[0] +	priv->ofdm_tx_power_index_diff[group].a;
 	ofdmbase[1] = ofdm[1] +	priv->ofdm_tx_power_index_diff[group].b;
@@ -2485,27 +2556,39 @@ rtl8723a_set_tx_power(struct rtl8xxxu_priv *priv, int channel, bool ht40)
 		ofdmbase[0] << 16 | ofdmbase[0] << 24;
 	ofdm_b = ofdmbase[1] | ofdmbase[1] << 8 |
 		ofdmbase[1] << 16 | ofdmbase[1] << 24;
-	rtl8xxxu_write32(priv, REG_TX_AGC_A_RATE18_06, ofdm_a);
-	rtl8xxxu_write32(priv, REG_TX_AGC_B_RATE18_06, ofdm_b);
 
-	rtl8xxxu_write32(priv, REG_TX_AGC_A_RATE54_24, ofdm_a);
-	rtl8xxxu_write32(priv, REG_TX_AGC_B_RATE54_24, ofdm_b);
+	rtl8xxxu_write32(priv, REG_TX_AGC_A_RATE18_06,
+			 ofdm_a + power_base->reg_0e00);
+	rtl8xxxu_write32(priv, REG_TX_AGC_B_RATE18_06,
+			 ofdm_b + power_base->reg_0830);
+
+	rtl8xxxu_write32(priv, REG_TX_AGC_A_RATE54_24,
+			 ofdm_a + power_base->reg_0e04);
+	rtl8xxxu_write32(priv, REG_TX_AGC_B_RATE54_24,
+			 ofdm_b + power_base->reg_0834);
 
 	mcs_a = mcsbase[0] | mcsbase[0] << 8 |
 		mcsbase[0] << 16 | mcsbase[0] << 24;
 	mcs_b = mcsbase[1] | mcsbase[1] << 8 |
 		mcsbase[1] << 16 | mcsbase[1] << 24;
 
-	rtl8xxxu_write32(priv, REG_TX_AGC_A_MCS03_MCS00, mcs_a);
-	rtl8xxxu_write32(priv, REG_TX_AGC_B_MCS03_MCS00, mcs_b);
+	rtl8xxxu_write32(priv, REG_TX_AGC_A_MCS03_MCS00,
+			 mcs_a + power_base->reg_0e10);
+	rtl8xxxu_write32(priv, REG_TX_AGC_B_MCS03_MCS00,
+			 mcs_b + power_base->reg_083c);
 
-	rtl8xxxu_write32(priv, REG_TX_AGC_A_MCS07_MCS04, mcs_a);
-	rtl8xxxu_write32(priv, REG_TX_AGC_B_MCS07_MCS04, mcs_b);
+	rtl8xxxu_write32(priv, REG_TX_AGC_A_MCS07_MCS04,
+			 mcs_a + power_base->reg_0e14);
+	rtl8xxxu_write32(priv, REG_TX_AGC_B_MCS07_MCS04,
+			 mcs_b + power_base->reg_0848);
 
-	rtl8xxxu_write32(priv, REG_TX_AGC_A_MCS11_MCS08, mcs_a);
-	rtl8xxxu_write32(priv, REG_TX_AGC_B_MCS11_MCS08, mcs_b);
+	rtl8xxxu_write32(priv, REG_TX_AGC_A_MCS11_MCS08,
+			 mcs_a + power_base->reg_0e18);
+	rtl8xxxu_write32(priv, REG_TX_AGC_B_MCS11_MCS08,
+			 mcs_b + power_base->reg_084c);
 
-	rtl8xxxu_write32(priv, REG_TX_AGC_A_MCS15_MCS12, mcs_a);
+	rtl8xxxu_write32(priv, REG_TX_AGC_A_MCS15_MCS12,
+			 mcs_a + power_base->reg_0e1c);
 	for (i = 0; i < 3; i++) {
 		if (i != 2)
 			val8 = (mcsbase[0] > 8) ? (mcsbase[0] - 8) : 0;
@@ -2513,7 +2596,8 @@ rtl8723a_set_tx_power(struct rtl8xxxu_priv *priv, int channel, bool ht40)
 			val8 = (mcsbase[0] > 6) ? (mcsbase[0] - 6) : 0;
 		rtl8xxxu_write8(priv, REG_OFDM0_XC_TX_IQ_IMBALANCE + i, val8);
 	}
-	rtl8xxxu_write32(priv, REG_TX_AGC_B_MCS15_MCS12, mcs_b);
+	rtl8xxxu_write32(priv, REG_TX_AGC_B_MCS15_MCS12,
+			 mcs_b + power_base->reg_0868);
 	for (i = 0; i < 3; i++) {
 		if (i != 2)
 			val8 = (mcsbase[1] > 8) ? (mcsbase[1] - 8) : 0;
@@ -2920,6 +3004,9 @@ static int rtl8723au_parse_efuse(struct rtl8xxxu_priv *priv)
 		priv->has_xtalk = 1;
 		priv->xtalk = priv->efuse_wifi.efuse8723.xtal_k & 0x3f;
 	}
+
+	priv->power_base = &rtl8723a_power_base;
+
 	dev_info(&priv->udev->dev, "Vendor: %.7s\n",
 		 efuse->vendor_name);
 	dev_info(&priv->udev->dev, "Product: %.41s\n",
@@ -3052,10 +3139,13 @@ static int rtl8192cu_parse_efuse(struct rtl8xxxu_priv *priv)
 	dev_info(&priv->udev->dev, "Product: %.20s\n",
 		 efuse->device_name);
 
+	priv->power_base = &rtl8192c_power_base;
+
 	if (efuse->rf_regulatory & 0x20) {
 		sprintf(priv->chip_name, "8188RU");
 		priv->rtl_chip = RTL8188R;
 		priv->hi_pa = 1;
+		priv->power_base = &rtl8188r_power_base;
 	}
 
 	if (rtl8xxxu_debug & RTL8XXXU_DEBUG_EFUSE) {
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
index a1b076c..ebd1a6e 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
@@ -630,6 +630,31 @@ struct rtl8xxxu_firmware_header {
 };
 
 /*
+ * 8723au/8192cu/8188ru required base power index offset tables.
+ */
+struct rtl8xxxu_power_base {
+	u32 reg_0e00;
+	u32 reg_0e04;
+	u32 reg_0e08;
+	u32 reg_086c;
+
+	u32 reg_0e10;
+	u32 reg_0e14;
+	u32 reg_0e18;
+	u32 reg_0e1c;
+
+	u32 reg_0830;
+	u32 reg_0834;
+	u32 reg_0838;
+	u32 reg_086c_2;
+
+	u32 reg_083c;
+	u32 reg_0848;
+	u32 reg_084c;
+	u32 reg_0868;
+};
+
+/*
  * The 8723au has 3 channel groups: 1-3, 4-9, and 10-14
  */
 struct rtl8723au_idx {
@@ -1201,6 +1226,7 @@ struct rtl8xxxu_priv {
 	struct rtl8723au_idx ofdm_tx_power_diff[RTL8723B_TX_COUNT];
 	struct rtl8723au_idx ht20_tx_power_diff[RTL8723B_TX_COUNT];
 	struct rtl8723au_idx ht40_tx_power_diff[RTL8723B_TX_COUNT];
+	struct rtl8xxxu_power_base *power_base;
 	u32 chip_cut:4;
 	u32 rom_rev:4;
 	u32 is_multi_func:1;
-- 
2.5.5

