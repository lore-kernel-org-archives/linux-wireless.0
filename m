Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40040 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965903AbcBCSkD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Feb 2016 13:40:03 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 02/28] rtl8xxxu: rtl8xxxu_download_firmware(): Cosmetic cleanups
Date: Wed,  3 Feb 2016 13:39:36 -0500
Message-Id: <1454524802-26763-3-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160203_201501_835211_AA81DA88)
In-Reply-To: <1454524802-26763-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1454524802-26763-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 6b39e4d..b6a264b 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -2105,15 +2105,18 @@ static int rtl8xxxu_download_firmware(struct rtl8xxxu_priv *priv)
 
 	/* MCU firmware download enable */
 	val8 = rtl8xxxu_read8(priv, REG_MCU_FW_DL);
-	rtl8xxxu_write8(priv, REG_MCU_FW_DL, val8 | MCU_FW_DL_ENABLE);
+	val8 |= MCU_FW_DL_ENABLE;
+	rtl8xxxu_write8(priv, REG_MCU_FW_DL, val8);
 
 	/* 8051 reset */
 	val32 = rtl8xxxu_read32(priv, REG_MCU_FW_DL);
-	rtl8xxxu_write32(priv, REG_MCU_FW_DL, val32 & ~BIT(19));
+	val32 &= ~BIT(19);
+	rtl8xxxu_write32(priv, REG_MCU_FW_DL, val32);
 
 	/* Reset firmware download checksum */
 	val8 = rtl8xxxu_read8(priv, REG_MCU_FW_DL);
-	rtl8xxxu_write8(priv, REG_MCU_FW_DL, val8 | MCU_FW_DL_CSUM_REPORT);
+	val8 |= MCU_FW_DL_CSUM_REPORT;
+	rtl8xxxu_write8(priv, REG_MCU_FW_DL, val8);
 
 	pages = priv->fw_size / RTL_FW_PAGE_SIZE;
 	remainder = priv->fw_size % RTL_FW_PAGE_SIZE;
@@ -2122,7 +2125,8 @@ static int rtl8xxxu_download_firmware(struct rtl8xxxu_priv *priv)
 
 	for (i = 0; i < pages; i++) {
 		val8 = rtl8xxxu_read8(priv, REG_MCU_FW_DL + 2) & 0xF8;
-		rtl8xxxu_write8(priv, REG_MCU_FW_DL + 2, val8 | i);
+		val8 |= i;
+		rtl8xxxu_write8(priv, REG_MCU_FW_DL + 2, val8);
 
 		ret = rtl8xxxu_writeN(priv, REG_FW_START_ADDRESS,
 				      fwptr, RTL_FW_PAGE_SIZE);
@@ -2136,7 +2140,8 @@ static int rtl8xxxu_download_firmware(struct rtl8xxxu_priv *priv)
 
 	if (remainder) {
 		val8 = rtl8xxxu_read8(priv, REG_MCU_FW_DL + 2) & 0xF8;
-		rtl8xxxu_write8(priv, REG_MCU_FW_DL + 2, val8 | i);
+		val8 |= i;
+		rtl8xxxu_write8(priv, REG_MCU_FW_DL + 2, val8);
 		ret = rtl8xxxu_writeN(priv, REG_FW_START_ADDRESS,
 				      fwptr, remainder);
 		if (ret != remainder) {
@@ -2149,8 +2154,8 @@ static int rtl8xxxu_download_firmware(struct rtl8xxxu_priv *priv)
 fw_abort:
 	/* MCU firmware download disable */
 	val16 = rtl8xxxu_read16(priv, REG_MCU_FW_DL);
-	rtl8xxxu_write16(priv, REG_MCU_FW_DL,
-			 val16 & (~MCU_FW_DL_ENABLE & 0xff));
+	val16 &= ~MCU_FW_DL_ENABLE;
+	rtl8xxxu_write16(priv, REG_MCU_FW_DL, val16);
 
 	return ret;
 }
-- 
2.5.0

