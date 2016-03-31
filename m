Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50008 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933048AbcCaVIo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Mar 2016 17:08:44 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net
Subject: [PATCH 10/10] rtl8xxxu: Do not set LDOA15 / LDOV12 on 8192eu
Date: Thu, 31 Mar 2016 17:08:42 -0400
Message-Id: <1459458522-28686-11-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160331_230907_483393_4D374849)
In-Reply-To: <1459458522-28686-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1459458522-28686-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Per the vendor driver, it looks like the 8192eu doesn't have LDOA15 /
LDOV12 registers.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index f2e32a7..333addd 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -3283,7 +3283,7 @@ static int rtl8xxxu_init_phy_bb(struct rtl8xxxu_priv *priv)
 		rtl8xxxu_write32(priv, REG_MAC_PHY_CTRL, val32);
 	}
 
-	if (priv->rtl_chip != RTL8723B) {
+	if (priv->rtl_chip != RTL8723B && priv->rtl_chip != RTL8192E) {
 		ldoa15 = LDOA15_ENABLE | LDOA15_OBUF;
 		ldov12d = LDOV12D_ENABLE | BIT(2) | (2 << LDOV12D_VADJ_SHIFT);
 		ldohci12 = 0x57;
-- 
2.5.5

