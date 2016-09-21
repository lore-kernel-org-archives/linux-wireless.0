Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48650 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755408AbcIUBTb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Sep 2016 21:19:31 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
        Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 3/4] rtl8xxxu: Use a struct rtl8xxxu_fileops * in rtl8xxxu_init_device()
Date: Tue, 20 Sep 2016 21:19:28 -0400
Message-Id: <1474420769-20086-4-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160921_031940_768588_59D43961)
In-Reply-To: <1474420769-20086-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1474420769-20086-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

This saves some 217, or about, derefences of priv->fops.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  | 37 +++++++++++-----------
 1 file changed, 19 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index c628b90..71145eb 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -3886,6 +3886,7 @@ static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
 {
 	struct rtl8xxxu_priv *priv = hw->priv;
 	struct device *dev = &priv->udev->dev;
+	struct rtl8xxxu_fileops *fops = priv->fops;
 	bool macpower;
 	int ret;
 	u8 val8;
@@ -3904,7 +3905,7 @@ static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
 	else
 		macpower = true;
 
-	ret = priv->fops->power_on(priv);
+	ret = fops->power_on(priv);
 	if (ret < 0) {
 		dev_warn(dev, "%s: Failed power on\n", __func__);
 		goto exit;
@@ -3921,7 +3922,7 @@ static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
 	/*
 	 * Set RX page boundary
 	 */
-	rtl8xxxu_write16(priv, REG_TRXFF_BNDY + 2, priv->fops->trxff_boundary);
+	rtl8xxxu_write16(priv, REG_TRXFF_BNDY + 2, fops->trxff_boundary);
 
 	ret = rtl8xxxu_download_firmware(priv);
 	dev_dbg(dev, "%s: download_firmware %i\n", __func__, ret);
@@ -3932,8 +3933,8 @@ static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
 	if (ret)
 		goto exit;
 
-	if (priv->fops->phy_init_antenna_selection)
-		priv->fops->phy_init_antenna_selection(priv);
+	if (fops->phy_init_antenna_selection)
+		fops->phy_init_antenna_selection(priv);
 
 	ret = rtl8xxxu_init_mac(priv);
 
@@ -3946,7 +3947,7 @@ static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
 	if (ret)
 		goto exit;
 
-	ret = priv->fops->init_phy_rf(priv);
+	ret = fops->init_phy_rf(priv);
 	if (ret)
 		goto exit;
 
@@ -3971,7 +3972,7 @@ static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
 		/*
 		 * Set TX buffer boundary
 		 */
-		val8 = priv->fops->total_page_num + 1;
+		val8 = fops->total_page_num + 1;
 
 		rtl8xxxu_write8(priv, REG_TXPKTBUF_BCNQ_BDNY, val8);
 		rtl8xxxu_write8(priv, REG_TXPKTBUF_MGQ_BDNY, val8);
@@ -3984,14 +3985,14 @@ static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
 	 * The vendor drivers set PBP for all devices, except 8192e.
 	 * There is no explanation for this in any of the sources.
 	 */
-	val8 = (priv->fops->pbp_rx << PBP_PAGE_SIZE_RX_SHIFT) |
-		(priv->fops->pbp_tx << PBP_PAGE_SIZE_TX_SHIFT);
+	val8 = (fops->pbp_rx << PBP_PAGE_SIZE_RX_SHIFT) |
+		(fops->pbp_tx << PBP_PAGE_SIZE_TX_SHIFT);
 	if (priv->rtl_chip != RTL8192E)
 		rtl8xxxu_write8(priv, REG_PBP, val8);
 
 	dev_dbg(dev, "%s: macpower %i\n", __func__, macpower);
 	if (!macpower) {
-		ret = priv->fops->llt_init(priv);
+		ret = fops->llt_init(priv);
 		if (ret) {
 			dev_warn(dev, "%s: LLT table init failed\n", __func__);
 			goto exit;
@@ -4000,12 +4001,12 @@ static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
 		/*
 		 * Chip specific quirks
 		 */
-		priv->fops->usb_quirks(priv);
+		fops->usb_quirks(priv);
 
 		/*
 		 * Enable TX report and TX report timer for 8723bu/8188eu/...
 		 */
-		if (priv->fops->has_tx_report) {
+		if (fops->has_tx_report) {
 			val8 = rtl8xxxu_read8(priv, REG_TX_REPORT_CTRL);
 			val8 |= TX_REPORT_CTRL_TIMER_ENABLE;
 			rtl8xxxu_write8(priv, REG_TX_REPORT_CTRL, val8);
@@ -4140,8 +4141,8 @@ static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
 		rtl8xxxu_write8(priv, REG_RSV_CTRL, val8);
 	}
 
-	if (priv->fops->init_aggregation)
-		priv->fops->init_aggregation(priv);
+	if (fops->init_aggregation)
+		fops->init_aggregation(priv);
 
 	/*
 	 * Enable CCK and OFDM block
@@ -4158,7 +4159,7 @@ static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
 	/*
 	 * Start out with default power levels for channel 6, 20MHz
 	 */
-	priv->fops->set_tx_power(priv, 1, false);
+	fops->set_tx_power(priv, 1, false);
 
 	/* Let the 8051 take control of antenna setting */
 	if (priv->rtl_chip != RTL8192E) {
@@ -4174,8 +4175,8 @@ static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
 
 	rtl8xxxu_write16(priv, REG_FAST_EDCA_CTRL, 0);
 
-	if (priv->fops->init_statistics)
-		priv->fops->init_statistics(priv);
+	if (fops->init_statistics)
+		fops->init_statistics(priv);
 
 	if (priv->rtl_chip == RTL8192E) {
 		/*
@@ -4193,12 +4194,12 @@ static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
 
 	rtl8723a_phy_lc_calibrate(priv);
 
-	priv->fops->phy_iq_calibrate(priv);
+	fops->phy_iq_calibrate(priv);
 
 	/*
 	 * This should enable thermal meter
 	 */
-	if (priv->fops->gen2_thermal_meter)
+	if (fops->gen2_thermal_meter)
 		rtl8xxxu_write_rfreg(priv,
 				     RF_A, RF6052_REG_T_METER_8723B, 0x37cf8);
 	else
-- 
2.7.4
