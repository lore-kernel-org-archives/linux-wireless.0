Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48018 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751748AbcDNUh2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Apr 2016 16:37:28 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 14/16] rtl8xxxu: Implement rtl8192e_enable_rf()
Date: Thu, 14 Apr 2016 16:37:19 -0400
Message-Id: <1460666241-5365-15-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160414_223735_327306_9CCEDAA4)
In-Reply-To: <1460666241-5365-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1460666241-5365-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

This implements an 8192eu specific enable_rf() function. The 8192eu is
not a combo device, so no need for doing the BT specific bits needed
by the 8723bu.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 39 +++++++++++++++++++++++-
 1 file changed, 38 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 2d92e64..a86b5c4 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -7517,6 +7517,43 @@ static void rtl8723bu_set_ps_tdma(struct rtl8xxxu_priv *priv,
 }
 #endif
 
+static void rtl8192e_enable_rf(struct rtl8xxxu_priv *priv)
+{
+	u32 val32;
+	u8 val8;
+
+	val8 = rtl8xxxu_read8(priv, REG_GPIO_MUXCFG);
+	val8 |= BIT(5);
+	rtl8xxxu_write8(priv, REG_GPIO_MUXCFG, val8);
+
+	/*
+	 * WLAN action by PTA
+	 */
+	rtl8xxxu_write8(priv, REG_WLAN_ACT_CONTROL_8723B, 0x04);
+
+	val32 = rtl8xxxu_read32(priv, REG_PWR_DATA);
+	val32 |= PWR_DATA_EEPRPAD_RFE_CTRL_EN;
+	rtl8xxxu_write32(priv, REG_PWR_DATA, val32);
+
+	val32 = rtl8xxxu_read32(priv, REG_RFE_BUFFER);
+	val32 |= (BIT(0) | BIT(1));
+	rtl8xxxu_write32(priv, REG_RFE_BUFFER, val32);
+
+	rtl8xxxu_write8(priv, REG_RFE_CTRL_ANTA_SRC, 0x77);
+
+	val32 = rtl8xxxu_read32(priv, REG_LEDCFG0);
+	val32 &= ~BIT(24);
+	val32 |= BIT(23);
+	rtl8xxxu_write32(priv, REG_LEDCFG0, val32);
+
+	/*
+	 * Fix external switch Main->S1, Aux->S0
+	 */
+	val8 = rtl8xxxu_read8(priv, REG_PAD_CTRL1);
+	val8 &= ~BIT(0);
+	rtl8xxxu_write8(priv, REG_PAD_CTRL1, val8);
+}
+
 static void rtl8723b_enable_rf(struct rtl8xxxu_priv *priv)
 {
 	struct h2c_cmd h2c;
@@ -9953,7 +9990,7 @@ static struct rtl8xxxu_fileops rtl8192eu_fops = {
 	.phy_iq_calibrate = rtl8192eu_phy_iq_calibrate,
 	.config_channel = rtl8723bu_config_channel,
 	.parse_rx_desc = rtl8xxxu_parse_rxdesc24,
-	.enable_rf = rtl8723b_enable_rf,
+	.enable_rf = rtl8192e_enable_rf,
 	.disable_rf = rtl8723b_disable_rf,
 	.usb_quirks = rtl8xxxu_gen2_usb_quirks,
 	.set_tx_power = rtl8192e_set_tx_power,
-- 
2.5.5

