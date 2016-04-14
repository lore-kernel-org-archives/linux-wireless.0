Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57110 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753617AbcDNS7J (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Apr 2016 14:59:09 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net
Subject: [PATCH 17/26] rtl8xxxu: Load AGC table before patching for 1T2R parts
Date: Thu, 14 Apr 2016 14:58:58 -0400
Message-Id: <1460660347-26299-18-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160414_205948_015835_387A0B85)
In-Reply-To: <1460660347-26299-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1460660347-26299-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

This should get the order right and avoid patching something that is
later overwritten.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 28 ++++++++++++------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 43359a3..2127507 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -3811,6 +3811,20 @@ static int rtl8xxxu_init_phy_bb(struct rtl8xxxu_priv *priv)
 
 	priv->fops->init_phy_bb(priv);
 
+	if (priv->rtl_chip == RTL8723B)
+		rtl8xxxu_init_phy_regs(priv, rtl8xxx_agc_8723bu_table);
+	else if (priv->rtl_chip == RTL8192E) {
+		if (priv->hi_pa)
+			rtl8xxxu_init_phy_regs(priv,
+					       rtl8xxx_agc_8192eu_highpa_table);
+		else
+			rtl8xxxu_init_phy_regs(priv,
+					       rtl8xxx_agc_8192eu_std_table);
+	} else if (priv->hi_pa)
+		rtl8xxxu_init_phy_regs(priv, rtl8xxx_agc_highpa_table);
+	else
+		rtl8xxxu_init_phy_regs(priv, rtl8xxx_agc_standard_table);
+
 	if (priv->tx_paths == 1 && priv->rx_paths == 2) {
 		/*
 		 * For 1T2R boards, patch the registers.
@@ -3871,20 +3885,6 @@ static int rtl8xxxu_init_phy_bb(struct rtl8xxxu_priv *priv)
 		rtl8xxxu_write32(priv, REG_TX_TO_TX, val32);
 	}
 
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
 	if (priv->has_xtalk) {
 		val32 = rtl8xxxu_read32(priv, REG_MAC_PHY_CTRL);
 
-- 
2.5.5

