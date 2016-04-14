Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33931 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753630AbcDNS7J (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Apr 2016 14:59:09 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net
Subject: [PATCH 19/26] rtl8xxxu: REG_LDOA15_CTRL is only used on gen1 parts
Date: Thu, 14 Apr 2016 14:59:00 -0400
Message-Id: <1460660347-26299-20-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160414_212529_463878_4D09B8D5)
In-Reply-To: <1460660347-26299-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1460660347-26299-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Move setting it to rtl8723au_init_phy_bb()

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index baa53a1..4ef8a05 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -3719,7 +3719,7 @@ static int rtl8xxxu_init_phy_regs(struct rtl8xxxu_priv *priv,
 
 static void rtl8723au_init_phy_bb(struct rtl8xxxu_priv *priv)
 {
-	u8 val8;
+	u8 val8, ldoa15, ldov12d, lpldo, ldohci12;
 	u16 val16;
 	u32 val32;
 
@@ -3761,6 +3761,13 @@ static void rtl8723au_init_phy_bb(struct rtl8xxxu_priv *priv)
 		rtl8xxxu_init_phy_regs(priv, rtl8xxx_agc_highpa_table);
 	else
 		rtl8xxxu_init_phy_regs(priv, rtl8xxx_agc_standard_table);
+
+	ldoa15 = LDOA15_ENABLE | LDOA15_OBUF;
+	ldov12d = LDOV12D_ENABLE | BIT(2) | (2 << LDOV12D_VADJ_SHIFT);
+	ldohci12 = 0x57;
+	lpldo = 1;
+	val32 = (lpldo << 24) | (ldohci12 << 16) | (ldov12d << 8) | ldoa15;
+	rtl8xxxu_write32(priv, REG_LDOA15_CTRL, val32);
 }
 
 static void rtl8723bu_init_phy_bb(struct rtl8xxxu_priv *priv)
@@ -3818,7 +3825,7 @@ static void rtl8192eu_init_phy_bb(struct rtl8xxxu_priv *priv)
  */
 static int rtl8xxxu_init_phy_bb(struct rtl8xxxu_priv *priv)
 {
-	u8 val8, ldoa15, ldov12d, lpldo, ldohci12;
+	u8 val8;
 	u32 val32;
 
 	priv->fops->init_phy_bb(priv);
@@ -3893,17 +3900,6 @@ static int rtl8xxxu_init_phy_bb(struct rtl8xxxu_priv *priv)
 		rtl8xxxu_write32(priv, REG_MAC_PHY_CTRL, val32);
 	}
 
-	if (priv->rtl_chip != RTL8723B && priv->rtl_chip != RTL8192E) {
-		ldoa15 = LDOA15_ENABLE | LDOA15_OBUF;
-		ldov12d = LDOV12D_ENABLE | BIT(2) | (2 << LDOV12D_VADJ_SHIFT);
-		ldohci12 = 0x57;
-		lpldo = 1;
-		val32 = (lpldo << 24) | (ldohci12 << 16) |
-			(ldov12d << 8) | ldoa15;
-
-		rtl8xxxu_write32(priv, REG_LDOA15_CTRL, val32);
-	}
-
 	if (priv->rtl_chip == RTL8192E)
 		rtl8xxxu_write32(priv, REG_AFE_XTAL_CTRL, 0x000f81fb);
 
-- 
2.5.5

