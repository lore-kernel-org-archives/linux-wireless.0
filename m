Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40132 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752961AbcB2WFz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 17:05:55 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 056/113] rtl8xxxu: Additional fixes for 8723bu
Date: Mon, 29 Feb 2016 17:04:54 -0500
Message-Id: <1456783551-28315-57-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160229_231016_418479_C09535A7)
In-Reply-To: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Additional tweaks to further map the init sequence for the 8723bu to
that of the vendor driver.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 25 +++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 15e27ab3..d97e66c 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -2957,7 +2957,8 @@ rtl8xxxu_init_mac(struct rtl8xxxu_priv *priv, struct rtl8xxxu_reg8val *array)
 		}
 	}
 
-	rtl8xxxu_write8(priv, REG_MAX_AGGR_NUM, 0x0a);
+	if (priv->rtlchip != 0x8723b)
+		rtl8xxxu_write8(priv, REG_MAX_AGGR_NUM, 0x0a);
 
 	return 0;
 }
@@ -3003,6 +3004,11 @@ static int rtl8xxxu_init_phy_bb(struct rtl8xxxu_priv *priv)
 	 */
 
 	if (priv->rtlchip == 0x8723b) {
+		val16 = rtl8xxxu_read16(priv, REG_SYS_FUNC);
+		val16 |= SYS_FUNC_BB_GLB_RSTN | SYS_FUNC_BBRSTB |
+			SYS_FUNC_DIO_RF;
+		rtl8xxxu_write16(priv, REG_SYS_FUNC, val16);
+
 		rtl8xxxu_write32(priv, REG_S0S1_PATH_SWITCH, 0x00);
 	} else {
 		val8 = rtl8xxxu_read8(priv, REG_AFE_PLL_CTRL);
@@ -3013,11 +3019,11 @@ static int rtl8xxxu_init_phy_bb(struct rtl8xxxu_priv *priv)
 
 		rtl8xxxu_write8(priv, REG_AFE_PLL_CTRL + 1, 0xff);
 		udelay(2);
-	}
 
-	val16 = rtl8xxxu_read16(priv, REG_SYS_FUNC);
-	val16 |= SYS_FUNC_BB_GLB_RSTN | SYS_FUNC_BBRSTB;
-	rtl8xxxu_write16(priv, REG_SYS_FUNC, val16);
+		val16 = rtl8xxxu_read16(priv, REG_SYS_FUNC);
+		val16 |= SYS_FUNC_BB_GLB_RSTN | SYS_FUNC_BBRSTB;
+		rtl8xxxu_write16(priv, REG_SYS_FUNC, val16);
+	}
 
 	if (priv->rtlchip != 0x8723b) {
 		/* AFE_XTAL_RF_GATE (bit 14) if addressing as 32 bit register */
@@ -3036,9 +3042,14 @@ static int rtl8xxxu_init_phy_bb(struct rtl8xxxu_priv *priv)
 		rtl8xxxu_init_phy_regs(priv, rtl8188ru_phy_1t_highpa_table);
 	else if (priv->tx_paths == 2)
 		rtl8xxxu_init_phy_regs(priv, rtl8192cu_phy_2t_init_table);
-	else if (priv->rtlchip == 0x8723b)
+	else if (priv->rtlchip == 0x8723b) {
+		/*
+		 * Why?
+		 */
+		rtl8xxxu_write8(priv, REG_SYS_FUNC, 0xe3);
+		rtl8xxxu_write8(priv, REG_AFE_XTAL_CTRL + 1, 0x80);
 		rtl8xxxu_init_phy_regs(priv, rtl8723b_phy_1t_init_table);
-	else
+	} else
 		rtl8xxxu_init_phy_regs(priv, rtl8723a_phy_1t_init_table);
 
 
-- 
2.5.0

