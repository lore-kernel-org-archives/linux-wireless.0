Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53894 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751498AbcDNUhX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Apr 2016 16:37:23 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 05/16] rtl8xxxu: Apply 8188RU workaround for UMC B cut parts correctly
Date: Thu, 14 Apr 2016 16:37:10 -0400
Message-Id: <1460666241-5365-6-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160414_223738_874254_0C86CD96)
In-Reply-To: <1460666241-5365-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1460666241-5365-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

This patch was being missed since rtl_chip will never match RTL8188C
if hi_pa is true.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 578d1bf..bebe484 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -3756,7 +3756,7 @@ static void rtl8723au_init_phy_bb(struct rtl8xxxu_priv *priv)
 	else
 		rtl8xxxu_init_phy_regs(priv, rtl8723a_phy_1t_init_table);
 
-	if (priv->rtl_chip == RTL8188C && priv->hi_pa &&
+	if (priv->rtl_chip == RTL8188R && priv->hi_pa &&
 	    priv->vendor_umc && priv->chip_cut == 1)
 		rtl8xxxu_write8(priv, REG_OFDM0_AGC_PARM1 + 2, 0x50);
 
-- 
2.5.5

