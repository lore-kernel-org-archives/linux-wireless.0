Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40649 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757309AbcDGSTe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Apr 2016 14:19:34 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net
Subject: [PATCH 07/18] rtl8xxxu: Pick PHY init table based on chip version first
Date: Thu,  7 Apr 2016 14:19:22 -0400
Message-Id: <1460053173-8494-8-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160407_202001_549883_F48A0AA8)
In-Reply-To: <1460053173-8494-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1460053173-8494-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Pick PHY init table based on device before distinguishing between
1T/2T/high PA tables. The latter is only currently used for
8188cu/8192cu/8188ru.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index fa6ab85..d6abe27 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -3637,11 +3637,7 @@ static int rtl8xxxu_init_phy_bb(struct rtl8xxxu_priv *priv)
 	val8 = RF_ENABLE | RF_RSTB | RF_SDMRSTB;
 	rtl8xxxu_write8(priv, REG_RF_CTRL, val8);
 
-	if (priv->hi_pa)
-		rtl8xxxu_init_phy_regs(priv, rtl8188ru_phy_1t_highpa_table);
-	else if (priv->tx_paths == 2)
-		rtl8xxxu_init_phy_regs(priv, rtl8192cu_phy_2t_init_table);
-	else if (priv->rtl_chip == RTL8723B) {
+	if (priv->rtl_chip == RTL8723B) {
 		/*
 		 * Why?
 		 */
@@ -3656,10 +3652,13 @@ static int rtl8xxxu_init_phy_bb(struct rtl8xxxu_priv *priv)
 		val8 = RF_ENABLE | RF_RSTB | RF_SDMRSTB;
 		rtl8xxxu_write8(priv, REG_RF_CTRL, val8);
 		rtl8xxxu_init_phy_regs(priv, rtl8192eu_phy_init_table);
-	} else
+	} else	if (priv->hi_pa)
+		rtl8xxxu_init_phy_regs(priv, rtl8188ru_phy_1t_highpa_table);
+	else if (priv->tx_paths == 2)
+		rtl8xxxu_init_phy_regs(priv, rtl8192cu_phy_2t_init_table);
+	else
 		rtl8xxxu_init_phy_regs(priv, rtl8723a_phy_1t_init_table);
 
-
 	if (priv->rtl_chip == RTL8188C && priv->hi_pa &&
 	    priv->vendor_umc && priv->chip_cut == 1)
 		rtl8xxxu_write8(priv, REG_OFDM0_AGC_PARM1 + 2, 0x50);
-- 
2.5.5

