Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42884 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752694AbcDNS7O (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Apr 2016 14:59:14 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net
Subject: [PATCH 23/26] rtl8xxxu: Split USB quirks into gen1 and gen2 quirks
Date: Thu, 14 Apr 2016 14:59:04 -0400
Message-Id: <1460660347-26299-24-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160414_205920_180805_BE8F1997)
In-Reply-To: <1460660347-26299-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1460660347-26299-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

This removes a bunch of if () spaghetti and re-applies the USB bus
quirks for 8188/8192 that had gotten lost.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 95 ++++++++++++++----------
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h |  1 +
 2 files changed, 56 insertions(+), 40 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 3e3ca28..821be87 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -6899,6 +6899,50 @@ static int rtl8xxxu_flush_fifo(struct rtl8xxxu_priv *priv)
 	return retval;
 }
 
+static void rtl8xxxu_gen1_usb_quirks(struct rtl8xxxu_priv *priv)
+{
+	/* Fix USB interface interference issue */
+	rtl8xxxu_write8(priv, 0xfe40, 0xe0);
+	rtl8xxxu_write8(priv, 0xfe41, 0x8d);
+	rtl8xxxu_write8(priv, 0xfe42, 0x80);
+	/*
+	 * This sets TXDMA_OFFSET_DROP_DATA_EN (bit 9) as well as bits
+	 * 8 and 5, for which I have found no documentation.
+	 */
+	rtl8xxxu_write32(priv, REG_TXDMA_OFFSET_CHK, 0xfd0320);
+
+	/*
+	 * Solve too many protocol error on USB bus.
+	 * Can't do this for 8188/8192 UMC A cut parts
+	 */
+	if (!(!priv->chip_cut && priv->vendor_umc)) {
+		rtl8xxxu_write8(priv, 0xfe40, 0xe6);
+		rtl8xxxu_write8(priv, 0xfe41, 0x94);
+		rtl8xxxu_write8(priv, 0xfe42, 0x80);
+
+		rtl8xxxu_write8(priv, 0xfe40, 0xe0);
+		rtl8xxxu_write8(priv, 0xfe41, 0x19);
+		rtl8xxxu_write8(priv, 0xfe42, 0x80);
+
+		rtl8xxxu_write8(priv, 0xfe40, 0xe5);
+		rtl8xxxu_write8(priv, 0xfe41, 0x91);
+		rtl8xxxu_write8(priv, 0xfe42, 0x80);
+
+		rtl8xxxu_write8(priv, 0xfe40, 0xe2);
+		rtl8xxxu_write8(priv, 0xfe41, 0x81);
+		rtl8xxxu_write8(priv, 0xfe42, 0x80);
+	}
+}
+
+static void rtl8xxxu_gen2_usb_quirks(struct rtl8xxxu_priv *priv)
+{
+	u32 val32;
+
+	val32 = rtl8xxxu_read32(priv, REG_TXDMA_OFFSET_CHK);
+	val32 |= TXDMA_OFFSET_DROP_DATA_EN;
+	rtl8xxxu_write32(priv, REG_TXDMA_OFFSET_CHK, val32);
+}
+
 static int rtl8723au_power_on(struct rtl8xxxu_priv *priv)
 {
 	u8 val8;
@@ -7563,29 +7607,6 @@ static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
 	if (ret)
 		goto exit;
 
-	/* Solve too many protocol error on USB bus */
-	/* Can't do this for 8188/8192 UMC A cut parts */
-	if (priv->rtl_chip == RTL8723A ||
-	    ((priv->rtl_chip == RTL8192C || priv->rtl_chip == RTL8191C ||
-	      priv->rtl_chip == RTL8188C) &&
-	     (priv->chip_cut || !priv->vendor_umc))) {
-		rtl8xxxu_write8(priv, 0xfe40, 0xe6);
-		rtl8xxxu_write8(priv, 0xfe41, 0x94);
-		rtl8xxxu_write8(priv, 0xfe42, 0x80);
-
-		rtl8xxxu_write8(priv, 0xfe40, 0xe0);
-		rtl8xxxu_write8(priv, 0xfe41, 0x19);
-		rtl8xxxu_write8(priv, 0xfe42, 0x80);
-
-		rtl8xxxu_write8(priv, 0xfe40, 0xe5);
-		rtl8xxxu_write8(priv, 0xfe41, 0x91);
-		rtl8xxxu_write8(priv, 0xfe42, 0x80);
-
-		rtl8xxxu_write8(priv, 0xfe40, 0xe2);
-		rtl8xxxu_write8(priv, 0xfe41, 0x81);
-		rtl8xxxu_write8(priv, 0xfe42, 0x80);
-	}
-
 	if (priv->fops->phy_init_antenna_selection)
 		priv->fops->phy_init_antenna_selection(priv);
 
@@ -7604,6 +7625,12 @@ static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
 	case RTL8723A:
 		rftable = rtl8723au_radioa_1t_init_table;
 		ret = rtl8xxxu_init_phy_rf(priv, rftable, RF_A);
+
+		/* Reduce 80M spur */
+		rtl8xxxu_write32(priv, REG_AFE_XTAL_CTRL, 0x0381808d);
+		rtl8xxxu_write32(priv, REG_AFE_PLL_CTRL, 0xf0ffff83);
+		rtl8xxxu_write32(priv, REG_AFE_PLL_CTRL, 0xf0ffff82);
+		rtl8xxxu_write32(priv, REG_AFE_PLL_CTRL, 0xf0ffff83);
 		break;
 	case RTL8723B:
 		rftable = rtl8723bu_radioa_1t_init_table;
@@ -7706,23 +7733,7 @@ static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
 		/*
 		 * Chip specific quirks
 		 */
-		if (priv->rtl_chip == RTL8723A) {
-			/* Fix USB interface interference issue */
-			rtl8xxxu_write8(priv, 0xfe40, 0xe0);
-			rtl8xxxu_write8(priv, 0xfe41, 0x8d);
-			rtl8xxxu_write8(priv, 0xfe42, 0x80);
-			rtl8xxxu_write32(priv, REG_TXDMA_OFFSET_CHK, 0xfd0320);
-
-			/* Reduce 80M spur */
-			rtl8xxxu_write32(priv, REG_AFE_XTAL_CTRL, 0x0381808d);
-			rtl8xxxu_write32(priv, REG_AFE_PLL_CTRL, 0xf0ffff83);
-			rtl8xxxu_write32(priv, REG_AFE_PLL_CTRL, 0xf0ffff82);
-			rtl8xxxu_write32(priv, REG_AFE_PLL_CTRL, 0xf0ffff83);
-		} else {
-			val32 = rtl8xxxu_read32(priv, REG_TXDMA_OFFSET_CHK);
-			val32 |= TXDMA_OFFSET_DROP_DATA_EN;
-			rtl8xxxu_write32(priv, REG_TXDMA_OFFSET_CHK, val32);
-		}
+		priv->fops->usb_quirks(priv);
 
 		/*
 		 * Presumably this is for 8188EU as well
@@ -9712,6 +9723,7 @@ static struct rtl8xxxu_fileops rtl8723au_fops = {
 	.parse_rx_desc = rtl8xxxu_parse_rxdesc16,
 	.enable_rf = rtl8723a_enable_rf,
 	.disable_rf = rtl8723a_disable_rf,
+	.usb_quirks = rtl8xxxu_gen1_usb_quirks,
 	.set_tx_power = rtl8723a_set_tx_power,
 	.update_rate_mask = rtl8723au_update_rate_mask,
 	.report_connect = rtl8723au_report_connect,
@@ -9746,6 +9758,7 @@ static struct rtl8xxxu_fileops rtl8723bu_fops = {
 	.init_statistics = rtl8723bu_init_statistics,
 	.enable_rf = rtl8723b_enable_rf,
 	.disable_rf = rtl8723b_disable_rf,
+	.usb_quirks = rtl8xxxu_gen2_usb_quirks,
 	.set_tx_power = rtl8723b_set_tx_power,
 	.update_rate_mask = rtl8723bu_update_rate_mask,
 	.report_connect = rtl8723bu_report_connect,
@@ -9780,6 +9793,7 @@ static struct rtl8xxxu_fileops rtl8192cu_fops = {
 	.parse_rx_desc = rtl8xxxu_parse_rxdesc16,
 	.enable_rf = rtl8723a_enable_rf,
 	.disable_rf = rtl8723a_disable_rf,
+	.usb_quirks = rtl8xxxu_gen1_usb_quirks,
 	.set_tx_power = rtl8723a_set_tx_power,
 	.update_rate_mask = rtl8723au_update_rate_mask,
 	.report_connect = rtl8723au_report_connect,
@@ -9813,6 +9827,7 @@ static struct rtl8xxxu_fileops rtl8192eu_fops = {
 	.parse_rx_desc = rtl8xxxu_parse_rxdesc24,
 	.enable_rf = rtl8723b_enable_rf,
 	.disable_rf = rtl8723b_disable_rf,
+	.usb_quirks = rtl8xxxu_gen2_usb_quirks,
 	.set_tx_power = rtl8192e_set_tx_power,
 	.update_rate_mask = rtl8723bu_update_rate_mask,
 	.report_connect = rtl8723bu_report_connect,
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
index 8064b26..da86f3f 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
@@ -1293,6 +1293,7 @@ struct rtl8xxxu_fileops {
 	void (*init_statistics) (struct rtl8xxxu_priv *priv);
 	void (*enable_rf) (struct rtl8xxxu_priv *priv);
 	void (*disable_rf) (struct rtl8xxxu_priv *priv);
+	void (*usb_quirks) (struct rtl8xxxu_priv *priv);
 	void (*set_tx_power) (struct rtl8xxxu_priv *priv, int channel,
 			      bool ht40);
 	void (*update_rate_mask) (struct rtl8xxxu_priv *priv,
-- 
2.5.5

