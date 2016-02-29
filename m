Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33417 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752747AbcB2WFy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 17:05:54 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 023/113] rtl8xxxu: Group USB fixups together for all chips
Date: Mon, 29 Feb 2016 17:04:21 -0500
Message-Id: <1456783551-28315-24-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160229_231106_717228_4F132E61)
In-Reply-To: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

In addition do not apply fixups for 8188/8191/8192 A-cut UMC parts.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 57 +++++++++++++-----------
 1 file changed, 32 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 6976cec..2ff7430 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -4757,11 +4757,42 @@ static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
 		}
 	}
 
-	if (priv->rtlchip == 0x8192e) {
+	/* Fix USB interface interference issue */
+	if (priv->rtlchip == 0x8723a) {
+		rtl8xxxu_write8(priv, 0xfe40, 0xe0);
+		rtl8xxxu_write8(priv, 0xfe41, 0x8d);
+		rtl8xxxu_write8(priv, 0xfe42, 0x80);
+		rtl8xxxu_write32(priv, REG_TXDMA_OFFSET_CHK, 0xfd0320);
+	} else {
 		val32 = rtl8xxxu_read32(priv, REG_TXDMA_OFFSET_CHK);
 		val32 |= TXDMA_OFFSET_DROP_DATA_EN;
 		rtl8xxxu_write32(priv, REG_TXDMA_OFFSET_CHK, val32);
+	}
 
+	/* Solve too many protocol error on USB bus */
+	/* Can't do this for 8188/8192 UMC A cut parts */
+	if (priv->rtlchip == 0x8723a ||
+	    ((priv->rtlchip == 0x8192c || priv->rtlchip == 0x8191c ||
+	      priv->rtlchip == 0x8188c) &&
+	     (priv->chip_cut || !priv->vendor_umc))) {
+		rtl8xxxu_write8(priv, 0xfe40, 0xe6);
+		rtl8xxxu_write8(priv, 0xfe41, 0x94);
+		rtl8xxxu_write8(priv, 0xfe42, 0x80);
+
+		rtl8xxxu_write8(priv, 0xfe40, 0xe0);
+		rtl8xxxu_write8(priv, 0xfe41, 0x19);
+		rtl8xxxu_write8(priv, 0xfe42, 0x80);
+
+		rtl8xxxu_write8(priv, 0xfe40, 0xe5);
+		rtl8xxxu_write8(priv, 0xfe41, 0x91);
+		rtl8xxxu_write8(priv, 0xfe42, 0x80);
+
+		rtl8xxxu_write8(priv, 0xfe40, 0xe2);
+		rtl8xxxu_write8(priv, 0xfe41, 0x81);
+		rtl8xxxu_write8(priv, 0xfe42, 0x80);
+	}
+
+	if (priv->rtlchip == 0x8192e || priv->rtlchip == 0x8723b) {
 		rtl8xxxu_write32(priv, REG_HIMR0, 0x00);
 		rtl8xxxu_write32(priv, REG_HIMR1, 0x00);
 	}
@@ -4968,30 +4999,6 @@ static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
 
 	rtl8723a_phy_lc_calibrate(priv);
 
-	/* fix USB interface interference issue */
-	rtl8xxxu_write8(priv, 0xfe40, 0xe0);
-	rtl8xxxu_write8(priv, 0xfe41, 0x8d);
-	rtl8xxxu_write8(priv, 0xfe42, 0x80);
-	rtl8xxxu_write32(priv, REG_TXDMA_OFFSET_CHK, 0xfd0320);
-
-	/* Solve too many protocol error on USB bus */
-	/* Can't do this for 8188/8192 UMC A cut parts */
-	rtl8xxxu_write8(priv, 0xfe40, 0xe6);
-	rtl8xxxu_write8(priv, 0xfe41, 0x94);
-	rtl8xxxu_write8(priv, 0xfe42, 0x80);
-
-	rtl8xxxu_write8(priv, 0xfe40, 0xe0);
-	rtl8xxxu_write8(priv, 0xfe41, 0x19);
-	rtl8xxxu_write8(priv, 0xfe42, 0x80);
-
-	rtl8xxxu_write8(priv, 0xfe40, 0xe5);
-	rtl8xxxu_write8(priv, 0xfe41, 0x91);
-	rtl8xxxu_write8(priv, 0xfe42, 0x80);
-
-	rtl8xxxu_write8(priv, 0xfe40, 0xe2);
-	rtl8xxxu_write8(priv, 0xfe41, 0x81);
-	rtl8xxxu_write8(priv, 0xfe42, 0x80);
-
 	/* Init BT hw config. */
 	rtl8xxxu_init_bt(priv);
 
-- 
2.5.0

