Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46724 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753091AbcB2WF4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 17:05:56 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 061/113] rtl8xxxu: 80M spur hack is for 8723au only
Date: Mon, 29 Feb 2016 17:04:59 -0500
Message-Id: <1456783551-28315-62-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160229_230951_788325_0E383DB8)
In-Reply-To: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Only apply the 80M spur hack for 8723au parts.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index c253641..8b91edc 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -6151,11 +6151,12 @@ static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
 	if (ret)
 		goto exit;
 
-	/* Reduce 80M spur */
-	rtl8xxxu_write32(priv, REG_AFE_XTAL_CTRL, 0x0381808d);
-	rtl8xxxu_write32(priv, REG_AFE_PLL_CTRL, 0xf0ffff83);
-	rtl8xxxu_write32(priv, REG_AFE_PLL_CTRL, 0xf0ffff82);
-	rtl8xxxu_write32(priv, REG_AFE_PLL_CTRL, 0xf0ffff83);
+	if (priv->rtlchip == 0x8723a) { /* Reduce 80M spur */
+		rtl8xxxu_write32(priv, REG_AFE_XTAL_CTRL, 0x0381808d);
+		rtl8xxxu_write32(priv, REG_AFE_PLL_CTRL, 0xf0ffff83);
+		rtl8xxxu_write32(priv, REG_AFE_PLL_CTRL, 0xf0ffff82);
+		rtl8xxxu_write32(priv, REG_AFE_PLL_CTRL, 0xf0ffff83);
+	}
 
 	/* RFSW Control - clear bit 14 ?? */
 	rtl8xxxu_write32(priv, REG_FPGA0_TX_INFO, 0x00000003);
-- 
2.5.0

