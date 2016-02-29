Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52272 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753152AbcB2WF4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 17:05:56 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 058/113] rtl8xxxu: Another 8723bu patch for rtl8xxxu_init_phy_bb()
Date: Mon, 29 Feb 2016 17:04:56 -0500
Message-Id: <1456783551-28315-59-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160229_230840_654615_935FC9F1)
In-Reply-To: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

This function is going to need to be split up into chip specific
variants.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 968ed95..473c910 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -3142,13 +3142,16 @@ static int rtl8xxxu_init_phy_bb(struct rtl8xxxu_priv *priv)
 		rtl8xxxu_write32(priv, REG_MAC_PHY_CTRL, val32);
 	}
 
-	ldoa15 = LDOA15_ENABLE | LDOA15_OBUF;
-	ldov12d = LDOV12D_ENABLE | BIT(2) | (2 << LDOV12D_VADJ_SHIFT);
-	ldohci12 = 0x57;
-	lpldo = 1;
-	val32 = (lpldo << 24) | (ldohci12 << 16) | (ldov12d << 8) | ldoa15;
+	if (priv->rtlchip != 0x8723bu) {
+		ldoa15 = LDOA15_ENABLE | LDOA15_OBUF;
+		ldov12d = LDOV12D_ENABLE | BIT(2) | (2 << LDOV12D_VADJ_SHIFT);
+		ldohci12 = 0x57;
+		lpldo = 1;
+		val32 = (lpldo << 24) | (ldohci12 << 16) |
+			(ldov12d << 8) | ldoa15;
 
-	rtl8xxxu_write32(priv, REG_LDOA15_CTRL, val32);
+		rtl8xxxu_write32(priv, REG_LDOA15_CTRL, val32);
+	}
 
 	return 0;
 }
-- 
2.5.0

