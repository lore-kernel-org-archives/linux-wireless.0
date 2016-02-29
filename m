Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40145 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753087AbcB2WF4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 17:05:56 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 069/113] rtl8xxxu: Group chip quirks together
Date: Mon, 29 Feb 2016 17:05:07 -0500
Message-Id: <1456783551-28315-70-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160229_230847_461060_B3A9DFB9)
In-Reply-To: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Group chip quirks together instead of having them scattered all over
in the init code.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 28 +++++++++++++-----------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 566159e..de921cf 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -6028,18 +6028,6 @@ static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
 	if (ret)
 		goto exit;
 
-	/* Fix USB interface interference issue */
-	if (priv->rtlchip == 0x8723a) {
-		rtl8xxxu_write8(priv, 0xfe40, 0xe0);
-		rtl8xxxu_write8(priv, 0xfe41, 0x8d);
-		rtl8xxxu_write8(priv, 0xfe42, 0x80);
-		rtl8xxxu_write32(priv, REG_TXDMA_OFFSET_CHK, 0xfd0320);
-	} else {
-		val32 = rtl8xxxu_read32(priv, REG_TXDMA_OFFSET_CHK);
-		val32 |= TXDMA_OFFSET_DROP_DATA_EN;
-		rtl8xxxu_write32(priv, REG_TXDMA_OFFSET_CHK, val32);
-	}
-
 	/* Solve too many protocol error on USB bus */
 	/* Can't do this for 8188/8192 UMC A cut parts */
 	if (priv->rtlchip == 0x8723a ||
@@ -6127,11 +6115,25 @@ static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
 	if (ret)
 		goto exit;
 
-	if (priv->rtlchip == 0x8723a) { /* Reduce 80M spur */
+	/*
+	 * Chip specific quirks
+	 */
+	if (priv->rtlchip == 0x8723a) {
+		/* Fix USB interface interference issue */
+		rtl8xxxu_write8(priv, 0xfe40, 0xe0);
+		rtl8xxxu_write8(priv, 0xfe41, 0x8d);
+		rtl8xxxu_write8(priv, 0xfe42, 0x80);
+		rtl8xxxu_write32(priv, REG_TXDMA_OFFSET_CHK, 0xfd0320);
+
+		/* Reduce 80M spur */
 		rtl8xxxu_write32(priv, REG_AFE_XTAL_CTRL, 0x0381808d);
 		rtl8xxxu_write32(priv, REG_AFE_PLL_CTRL, 0xf0ffff83);
 		rtl8xxxu_write32(priv, REG_AFE_PLL_CTRL, 0xf0ffff82);
 		rtl8xxxu_write32(priv, REG_AFE_PLL_CTRL, 0xf0ffff83);
+	} else {
+		val32 = rtl8xxxu_read32(priv, REG_TXDMA_OFFSET_CHK);
+		val32 |= TXDMA_OFFSET_DROP_DATA_EN;
+		rtl8xxxu_write32(priv, REG_TXDMA_OFFSET_CHK, val32);
 	}
 
 	if (!macpower){
-- 
2.5.0

