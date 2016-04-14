Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54148 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751348AbcDNUhX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Apr 2016 16:37:23 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 03/16] rtl8xxxu: Move PHY RF init into device specific functions
Date: Thu, 14 Apr 2016 16:37:08 -0400
Message-Id: <1460666241-5365-4-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160414_225529_542147_2EE198FF)
In-Reply-To: <1460666241-5365-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1460666241-5365-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Load the RF table in init_phy_rf(), which allows for applying device
specific RF hacks in the same place. Getting rid of more ugly if ()
clutter.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 133 ++++++++++++++---------
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h |   1 +
 2 files changed, 80 insertions(+), 54 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index b88cf16..50ca3eb 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -4015,6 +4015,80 @@ static int rtl8xxxu_init_phy_rf(struct rtl8xxxu_priv *priv,
 	return 0;
 }
 
+static int rtl8723au_init_phy_rf(struct rtl8xxxu_priv *priv)
+{
+	int ret;
+
+	ret = rtl8xxxu_init_phy_rf(priv, rtl8723au_radioa_1t_init_table, RF_A);
+
+	/* Reduce 80M spur */
+	rtl8xxxu_write32(priv, REG_AFE_XTAL_CTRL, 0x0381808d);
+	rtl8xxxu_write32(priv, REG_AFE_PLL_CTRL, 0xf0ffff83);
+	rtl8xxxu_write32(priv, REG_AFE_PLL_CTRL, 0xf0ffff82);
+	rtl8xxxu_write32(priv, REG_AFE_PLL_CTRL, 0xf0ffff83);
+
+	return ret;
+}
+
+static int rtl8723bu_init_phy_rf(struct rtl8xxxu_priv *priv)
+{
+	int ret;
+
+	ret = rtl8xxxu_init_phy_rf(priv, rtl8723bu_radioa_1t_init_table, RF_A);
+	/*
+	 * PHY LCK
+	 */
+	rtl8xxxu_write_rfreg(priv, RF_A, 0xb0, 0xdfbe0);
+	rtl8xxxu_write_rfreg(priv, RF_A, RF6052_REG_MODE_AG, 0x8c01);
+	msleep(200);
+	rtl8xxxu_write_rfreg(priv, RF_A, 0xb0, 0xdffe0);
+
+	return ret;
+}
+
+#ifdef CONFIG_RTL8XXXU_UNTESTED
+static int rtl8192cu_init_phy_rf(struct rtl8xxxu_priv *priv)
+{
+	struct rtl8xxxu_rfregval *rftable;
+	int ret;
+
+	if (priv->rtl_chip == RTL8188C) {
+		if (priv->hi_pa)
+			rftable = rtl8188ru_radioa_1t_highpa_table;
+		else
+			rftable = rtl8192cu_radioa_1t_init_table;
+		ret = rtl8xxxu_init_phy_rf(priv, rftable, RF_A);
+	} else if (priv->rf_paths == 1) {
+		rftable = rtl8192cu_radioa_1t_init_table;
+		ret = rtl8xxxu_init_phy_rf(priv, rftable, RF_A);
+	} else {
+		rftable = rtl8192cu_radioa_2t_init_table;
+		ret = rtl8xxxu_init_phy_rf(priv, rftable, RF_A);
+		if (ret)
+			goto exit;
+		rftable = rtl8192cu_radiob_2t_init_table;
+		ret = rtl8xxxu_init_phy_rf(priv, rftable, RF_B);
+	}
+
+exit:
+	return ret;
+}
+#endif
+
+static int rtl8192eu_init_phy_rf(struct rtl8xxxu_priv *priv)
+{
+	int ret;
+
+	ret = rtl8xxxu_init_phy_rf(priv, rtl8192eu_radioa_init_table, RF_A);
+	if (ret)
+		goto exit;
+
+	ret = rtl8xxxu_init_phy_rf(priv, rtl8192eu_radiob_init_table, RF_B);
+
+exit:
+	return ret;
+}
+
 static int rtl8xxxu_llt_write(struct rtl8xxxu_priv *priv, u8 address, u8 data)
 {
 	int ret = -EBUSY;
@@ -7552,7 +7626,6 @@ static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
 {
 	struct rtl8xxxu_priv *priv = hw->priv;
 	struct device *dev = &priv->udev->dev;
-	struct rtl8xxxu_rfregval *rftable;
 	bool macpower;
 	int ret;
 	u8 val8;
@@ -7617,59 +7690,7 @@ static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
 	if (ret)
 		goto exit;
 
-	switch(priv->rtl_chip) {
-	case RTL8723A:
-		rftable = rtl8723au_radioa_1t_init_table;
-		ret = rtl8xxxu_init_phy_rf(priv, rftable, RF_A);
-
-		/* Reduce 80M spur */
-		rtl8xxxu_write32(priv, REG_AFE_XTAL_CTRL, 0x0381808d);
-		rtl8xxxu_write32(priv, REG_AFE_PLL_CTRL, 0xf0ffff83);
-		rtl8xxxu_write32(priv, REG_AFE_PLL_CTRL, 0xf0ffff82);
-		rtl8xxxu_write32(priv, REG_AFE_PLL_CTRL, 0xf0ffff83);
-		break;
-	case RTL8723B:
-		rftable = rtl8723bu_radioa_1t_init_table;
-		ret = rtl8xxxu_init_phy_rf(priv, rftable, RF_A);
-		/*
-		 * PHY LCK
-		 */
-		rtl8xxxu_write_rfreg(priv, RF_A, 0xb0, 0xdfbe0);
-		rtl8xxxu_write_rfreg(priv, RF_A, RF6052_REG_MODE_AG, 0x8c01);
-		msleep(200);
-		rtl8xxxu_write_rfreg(priv, RF_A, 0xb0, 0xdffe0);
-		break;
-	case RTL8188C:
-		if (priv->hi_pa)
-			rftable = rtl8188ru_radioa_1t_highpa_table;
-		else
-			rftable = rtl8192cu_radioa_1t_init_table;
-		ret = rtl8xxxu_init_phy_rf(priv, rftable, RF_A);
-		break;
-	case RTL8191C:
-		rftable = rtl8192cu_radioa_1t_init_table;
-		ret = rtl8xxxu_init_phy_rf(priv, rftable, RF_A);
-		break;
-	case RTL8192C:
-		rftable = rtl8192cu_radioa_2t_init_table;
-		ret = rtl8xxxu_init_phy_rf(priv, rftable, RF_A);
-		if (ret)
-			break;
-		rftable = rtl8192cu_radiob_2t_init_table;
-		ret = rtl8xxxu_init_phy_rf(priv, rftable, RF_B);
-		break;
-	case RTL8192E:
-		rftable = rtl8192eu_radioa_init_table;
-		ret = rtl8xxxu_init_phy_rf(priv, rftable, RF_A);
-		if (ret)
-			break;
-		rftable = rtl8192eu_radiob_init_table;
-		ret = rtl8xxxu_init_phy_rf(priv, rftable, RF_B);
-		break;
-	default:
-		ret = -EINVAL;
-	}
-
+	ret = priv->fops->init_phy_rf(priv);
 	if (ret)
 		goto exit;
 
@@ -9715,6 +9736,7 @@ static struct rtl8xxxu_fileops rtl8723au_fops = {
 	.reset_8051 = rtl8xxxu_reset_8051,
 	.llt_init = rtl8xxxu_init_llt_table,
 	.init_phy_bb = rtl8723au_init_phy_bb,
+	.init_phy_rf = rtl8723au_init_phy_rf,
 	.phy_iq_calibrate = rtl8723au_phy_iq_calibrate,
 	.config_channel = rtl8723au_config_channel,
 	.parse_rx_desc = rtl8xxxu_parse_rxdesc16,
@@ -9747,6 +9769,7 @@ static struct rtl8xxxu_fileops rtl8723bu_fops = {
 	.reset_8051 = rtl8723bu_reset_8051,
 	.llt_init = rtl8xxxu_auto_llt_table,
 	.init_phy_bb = rtl8723bu_init_phy_bb,
+	.init_phy_rf = rtl8723bu_init_phy_rf,
 	.phy_init_antenna_selection = rtl8723bu_phy_init_antenna_selection,
 	.phy_iq_calibrate = rtl8723bu_phy_iq_calibrate,
 	.config_channel = rtl8723bu_config_channel,
@@ -9785,6 +9808,7 @@ static struct rtl8xxxu_fileops rtl8192cu_fops = {
 	.reset_8051 = rtl8xxxu_reset_8051,
 	.llt_init = rtl8xxxu_init_llt_table,
 	.init_phy_bb = rtl8723au_init_phy_bb,
+	.init_phy_rf = rtl8192cu_init_phy_rf,
 	.phy_iq_calibrate = rtl8723au_phy_iq_calibrate,
 	.config_channel = rtl8723au_config_channel,
 	.parse_rx_desc = rtl8xxxu_parse_rxdesc16,
@@ -9819,6 +9843,7 @@ static struct rtl8xxxu_fileops rtl8192eu_fops = {
 	.reset_8051 = rtl8xxxu_reset_8051,
 	.llt_init = rtl8xxxu_auto_llt_table,
 	.init_phy_bb = rtl8192eu_init_phy_bb,
+	.init_phy_rf = rtl8192eu_init_phy_rf,
 	.phy_iq_calibrate = rtl8192eu_phy_iq_calibrate,
 	.config_channel = rtl8723bu_config_channel,
 	.parse_rx_desc = rtl8xxxu_parse_rxdesc24,
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
index da86f3f..3efbb60 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
@@ -1284,6 +1284,7 @@ struct rtl8xxxu_fileops {
 	void (*reset_8051) (struct rtl8xxxu_priv *priv);
 	int (*llt_init) (struct rtl8xxxu_priv *priv, u8 last_tx_page);
 	void (*init_phy_bb) (struct rtl8xxxu_priv *priv);
+	int (*init_phy_rf) (struct rtl8xxxu_priv *priv);
 	void (*phy_init_antenna_selection) (struct rtl8xxxu_priv *priv);
 	void (*phy_iq_calibrate) (struct rtl8xxxu_priv *priv);
 	void (*config_channel) (struct ieee80211_hw *hw);
-- 
2.5.5

