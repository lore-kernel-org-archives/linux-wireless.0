Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33928 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753504AbcDNS7J (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Apr 2016 14:59:09 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net
Subject: [PATCH 18/26] rtl8xxxu: Move loading of AGC table to device specific function
Date: Thu, 14 Apr 2016 14:58:59 -0400
Message-Id: <1460660347-26299-19-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160414_205946_384692_694DB0A7)
In-Reply-To: <1460660347-26299-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1460660347-26299-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

This moves the loading of the AGC table into init_phy_bb() and reduces
the if() clutter.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 26 +++++++++++-------------
 1 file changed, 12 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 2127507..baa53a1 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -3756,6 +3756,11 @@ static void rtl8723au_init_phy_bb(struct rtl8xxxu_priv *priv)
 	if (priv->rtl_chip == RTL8188C && priv->hi_pa &&
 	    priv->vendor_umc && priv->chip_cut == 1)
 		rtl8xxxu_write8(priv, REG_OFDM0_AGC_PARM1 + 2, 0x50);
+
+	if (priv->hi_pa)
+		rtl8xxxu_init_phy_regs(priv, rtl8xxx_agc_highpa_table);
+	else
+		rtl8xxxu_init_phy_regs(priv, rtl8xxx_agc_standard_table);
 }
 
 static void rtl8723bu_init_phy_bb(struct rtl8xxxu_priv *priv)
@@ -3777,6 +3782,8 @@ static void rtl8723bu_init_phy_bb(struct rtl8xxxu_priv *priv)
 	rtl8xxxu_write8(priv, REG_SYS_FUNC, 0xe3);
 	rtl8xxxu_write8(priv, REG_AFE_XTAL_CTRL + 1, 0x80);
 	rtl8xxxu_init_phy_regs(priv, rtl8723b_phy_1t_init_table);
+
+	rtl8xxxu_init_phy_regs(priv, rtl8xxx_agc_8723bu_table);
 }
 
 static void rtl8192eu_init_phy_bb(struct rtl8xxxu_priv *priv)
@@ -3799,6 +3806,11 @@ static void rtl8192eu_init_phy_bb(struct rtl8xxxu_priv *priv)
 	val8 = RF_ENABLE | RF_RSTB | RF_SDMRSTB;
 	rtl8xxxu_write8(priv, REG_RF_CTRL, val8);
 	rtl8xxxu_init_phy_regs(priv, rtl8192eu_phy_init_table);
+
+	if (priv->hi_pa)
+		rtl8xxxu_init_phy_regs(priv, rtl8xxx_agc_8192eu_highpa_table);
+	else
+		rtl8xxxu_init_phy_regs(priv, rtl8xxx_agc_8192eu_std_table);
 }
 
 /*
@@ -3811,20 +3823,6 @@ static int rtl8xxxu_init_phy_bb(struct rtl8xxxu_priv *priv)
 
 	priv->fops->init_phy_bb(priv);
 
-	if (priv->rtl_chip == RTL8723B)
-		rtl8xxxu_init_phy_regs(priv, rtl8xxx_agc_8723bu_table);
-	else if (priv->rtl_chip == RTL8192E) {
-		if (priv->hi_pa)
-			rtl8xxxu_init_phy_regs(priv,
-					       rtl8xxx_agc_8192eu_highpa_table);
-		else
-			rtl8xxxu_init_phy_regs(priv,
-					       rtl8xxx_agc_8192eu_std_table);
-	} else if (priv->hi_pa)
-		rtl8xxxu_init_phy_regs(priv, rtl8xxx_agc_highpa_table);
-	else
-		rtl8xxxu_init_phy_regs(priv, rtl8xxx_agc_standard_table);
-
 	if (priv->tx_paths == 1 && priv->rx_paths == 2) {
 		/*
 		 * For 1T2R boards, patch the registers.
-- 
2.5.5

