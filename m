Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57961 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752925AbcB2WFz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 17:05:55 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 053/113] rtl8xxxu: Do not set REG_AFE_XTAL_CTRL on 8723bu
Date: Mon, 29 Feb 2016 17:04:51 -0500
Message-Id: <1456783551-28315-54-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160229_230957_486597_41C0CC62)
In-Reply-To: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

The 8723bu does not like REG_AFE_XTAL_CTRL being set, so skip this for
now, to match the vendor driver.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index bb2ad9b..7f17e69 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -2998,6 +2998,7 @@ static int rtl8xxxu_init_phy_regs(struct rtl8xxxu_priv *priv,
 static int rtl8xxxu_init_phy_bb(struct rtl8xxxu_priv *priv)
 {
 	u8 val8, ldoa15, ldov12d, lpldo, ldohci12;
+	u16 val16;
 	u32 val32;
 
 	/*
@@ -3018,16 +3019,18 @@ static int rtl8xxxu_init_phy_bb(struct rtl8xxxu_priv *priv)
 		udelay(2);
 	}
 
-	val8 = rtl8xxxu_read8(priv, REG_SYS_FUNC);
-	val8 |= SYS_FUNC_BB_GLB_RSTN | SYS_FUNC_BBRSTB;
-	rtl8xxxu_write8(priv, REG_SYS_FUNC, val8);
+	val16 = rtl8xxxu_read16(priv, REG_SYS_FUNC);
+	val16 |= SYS_FUNC_BB_GLB_RSTN | SYS_FUNC_BBRSTB;
+	rtl8xxxu_write16(priv, REG_SYS_FUNC, val16);
 
-	/* AFE_XTAL_RF_GATE (bit 14) if addressing as 32 bit register */
-	val32 = rtl8xxxu_read32(priv, REG_AFE_XTAL_CTRL);
-	val32 &= ~AFE_XTAL_RF_GATE;
-	if (priv->has_bluetooth)
-		val32 &= ~AFE_XTAL_BT_GATE;
-	rtl8xxxu_write32(priv, REG_AFE_XTAL_CTRL, val32);
+	if (priv->rtlchip != 0x8723b) {
+		/* AFE_XTAL_RF_GATE (bit 14) if addressing as 32 bit register */
+		val32 = rtl8xxxu_read32(priv, REG_AFE_XTAL_CTRL);
+		val32 &= ~AFE_XTAL_RF_GATE;
+		if (priv->has_bluetooth)
+			val32 &= ~AFE_XTAL_BT_GATE;
+		rtl8xxxu_write32(priv, REG_AFE_XTAL_CTRL, val32);
+	}
 
 	/* 6. 0x1f[7:0] = 0x07 */
 	val8 = RF_ENABLE | RF_RSTB | RF_SDMRSTB;
-- 
2.5.0

