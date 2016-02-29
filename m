Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37700 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753002AbcB2WFz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 17:05:55 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 060/113] rtl8xxxu: Init H2C command register for 8723bu
Date: Mon, 29 Feb 2016 17:04:58 -0500
Message-Id: <1456783551-28315-61-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160229_231025_331335_5FF3911D)
In-Reply-To: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

In addition make register read/write flow match closer to vendor
driver flow. This is mainly to be able to compare the register write
log with the vendor driver, and can be optimized later once 8723bu
support is working.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index cd5c61b..c253641 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -2685,6 +2685,11 @@ static int rtl8xxxu_start_firmware(struct rtl8xxxu_priv *priv)
 		goto exit;
 	}
 
+	/*
+	 * Init H2C command
+	 */
+	if (priv->rtlchip == 0x8723b)
+		rtl8xxxu_write8(priv, REG_HMTFR, 0x0f);
 exit:
 	return ret;
 }
@@ -2927,14 +2932,20 @@ static void rtl8723bu_phy_init_antenna_selection(struct rtl8xxxu_priv *priv)
 
 	val32 = rtl8xxxu_read32(priv, REG_GPIO_MUXCFG);
 	val32 &= ~BIT(4);
+	rtl8xxxu_write32(priv, REG_GPIO_MUXCFG, val32);
+
+	val32 = rtl8xxxu_read32(priv, REG_GPIO_MUXCFG);
 	val32 |= BIT(3);
 	rtl8xxxu_write32(priv, REG_GPIO_MUXCFG, val32);
 
 	val32 = rtl8xxxu_read32(priv, REG_LEDCFG0);
-	val32 &= ~BIT(23);
 	val32 |= BIT(24);
 	rtl8xxxu_write32(priv, REG_LEDCFG0, val32);
 
+	val32 = rtl8xxxu_read32(priv, REG_LEDCFG0);
+	val32 &= ~BIT(23);
+	rtl8xxxu_write32(priv, REG_LEDCFG0, val32);
+
 	val32 = rtl8xxxu_read32(priv, 0x0944);
 	val32 |= (BIT(0) | BIT(1));
 	rtl8xxxu_write32(priv, 0x0944, val32);
@@ -2943,6 +2954,10 @@ static void rtl8723bu_phy_init_antenna_selection(struct rtl8xxxu_priv *priv)
 	val32 &= 0xffffff00;
 	val32 |= 0x77;
 	rtl8xxxu_write32(priv, 0x0930, val32);
+
+	val32 = rtl8xxxu_read32(priv, REG_PWR_DATA);
+	val32 |= PWR_DATA_EEPRPAD_RFE_CTRL_EN;
+	rtl8xxxu_write32(priv, REG_PWR_DATA, val32);
 }
 
 static int
@@ -6079,7 +6094,7 @@ static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
 		rtl8xxxu_write8(priv, 0xfe42, 0x80);
 	}
 
-	if (priv->rtlchip == 0x8192e || priv->rtlchip == 0x8723b) {
+	if (priv->rtlchip == 0x8192e) {
 		rtl8xxxu_write32(priv, REG_HIMR0, 0x00);
 		rtl8xxxu_write32(priv, REG_HIMR1, 0x00);
 	}
-- 
2.5.0

