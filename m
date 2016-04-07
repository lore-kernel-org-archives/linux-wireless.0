Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58310 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757020AbcDGSTe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Apr 2016 14:19:34 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net
Subject: [PATCH 02/18] rtl8xxxu: Do not mess with AFE_XTAL_CTRL on 8192eu
Date: Thu,  7 Apr 2016 14:19:17 -0400
Message-Id: <1460053173-8494-3-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160407_201938_413368_055DFB89)
In-Reply-To: <1460053173-8494-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1460053173-8494-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

To match the vendor driver, do not mess with AFE_XTAL_CTRL on 8192eu.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 97e0d17..a4662a0 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -3208,7 +3208,7 @@ static int rtl8xxxu_init_phy_bb(struct rtl8xxxu_priv *priv)
 		rtl8xxxu_write16(priv, REG_SYS_FUNC, val16);
 	}
 
-	if (priv->rtl_chip != RTL8723B) {
+	if (priv->rtl_chip != RTL8723B && priv->rtl_chip != RTL8192E) {
 		/* AFE_XTAL_RF_GATE (bit 14) if addressing as 32 bit register */
 		val32 = rtl8xxxu_read32(priv, REG_AFE_XTAL_CTRL);
 		val32 &= ~AFE_XTAL_RF_GATE;
-- 
2.5.5

