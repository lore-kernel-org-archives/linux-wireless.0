Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56980 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752780AbcDNS7J (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Apr 2016 14:59:09 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net
Subject: [PATCH 04/26] rtl8xxxu: Reorder chip quirks to follow flow of 8192eu driver
Date: Thu, 14 Apr 2016 14:58:45 -0400
Message-Id: <1460660347-26299-5-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160414_212530_651808_2CE3FD47)
In-Reply-To: <1460660347-26299-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1460660347-26299-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Another flow order change to match the vendor driver.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 42 ++++++++++++------------
 1 file changed, 21 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index a9290d4..9e9d3e3 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -7660,27 +7660,6 @@ static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
 	priv->rf_mode_ag[0] = rtl8xxxu_read_rfreg(priv, RF_A,
 						  RF6052_REG_MODE_AG);
 
-	/*
-	 * Chip specific quirks
-	 */
-	if (priv->rtl_chip == RTL8723A) {
-		/* Fix USB interface interference issue */
-		rtl8xxxu_write8(priv, 0xfe40, 0xe0);
-		rtl8xxxu_write8(priv, 0xfe41, 0x8d);
-		rtl8xxxu_write8(priv, 0xfe42, 0x80);
-		rtl8xxxu_write32(priv, REG_TXDMA_OFFSET_CHK, 0xfd0320);
-
-		/* Reduce 80M spur */
-		rtl8xxxu_write32(priv, REG_AFE_XTAL_CTRL, 0x0381808d);
-		rtl8xxxu_write32(priv, REG_AFE_PLL_CTRL, 0xf0ffff83);
-		rtl8xxxu_write32(priv, REG_AFE_PLL_CTRL, 0xf0ffff82);
-		rtl8xxxu_write32(priv, REG_AFE_PLL_CTRL, 0xf0ffff83);
-	} else {
-		val32 = rtl8xxxu_read32(priv, REG_TXDMA_OFFSET_CHK);
-		val32 |= TXDMA_OFFSET_DROP_DATA_EN;
-		rtl8xxxu_write32(priv, REG_TXDMA_OFFSET_CHK, val32);
-	}
-
 	if (!macpower) {
 		/*
 		 * Set TX buffer boundary
@@ -7720,6 +7699,27 @@ static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
 		}
 
 		/*
+		 * Chip specific quirks
+		 */
+		if (priv->rtl_chip == RTL8723A) {
+			/* Fix USB interface interference issue */
+			rtl8xxxu_write8(priv, 0xfe40, 0xe0);
+			rtl8xxxu_write8(priv, 0xfe41, 0x8d);
+			rtl8xxxu_write8(priv, 0xfe42, 0x80);
+			rtl8xxxu_write32(priv, REG_TXDMA_OFFSET_CHK, 0xfd0320);
+
+			/* Reduce 80M spur */
+			rtl8xxxu_write32(priv, REG_AFE_XTAL_CTRL, 0x0381808d);
+			rtl8xxxu_write32(priv, REG_AFE_PLL_CTRL, 0xf0ffff83);
+			rtl8xxxu_write32(priv, REG_AFE_PLL_CTRL, 0xf0ffff82);
+			rtl8xxxu_write32(priv, REG_AFE_PLL_CTRL, 0xf0ffff83);
+		} else {
+			val32 = rtl8xxxu_read32(priv, REG_TXDMA_OFFSET_CHK);
+			val32 |= TXDMA_OFFSET_DROP_DATA_EN;
+			rtl8xxxu_write32(priv, REG_TXDMA_OFFSET_CHK, val32);
+		}
+
+		/*
 		 * Presumably this is for 8188EU as well
 		 * Enable TX report and TX report timer
 		 */
-- 
2.5.5

