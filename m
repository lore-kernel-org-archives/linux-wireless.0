Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52292 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965904AbcBCSkD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Feb 2016 13:40:03 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 10/28] rtl8xxxu: Implement rtl8xxxu_reset_8051()
Date: Wed,  3 Feb 2016 13:39:44 -0500
Message-Id: <1454524802-26763-11-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160203_194821_652089_B4D24E21)
In-Reply-To: <1454524802-26763-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1454524802-26763-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

We need to reset the 8051 in order for it to launch the fw on the
rtl8192eu.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 38 ++++++++++++++++--------
 1 file changed, 26 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 08d8e1f..7a571ef 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -2043,6 +2043,24 @@ exit:
 	return ret;
 }
 
+static void rtl8xxxu_reset_8051(struct rtl8xxxu_priv *priv)
+{
+	u8 val8;
+	u16 sys_func;
+
+	val8 = rtl8xxxu_read8(priv, REG_RSV_CTRL + 1);
+	val8 &= ~BIT(3);
+	rtl8xxxu_write8(priv, REG_RSV_CTRL + 1, val8);
+	sys_func = rtl8xxxu_read16(priv, REG_SYS_FUNC);
+	sys_func &= ~SYS_FUNC_CPU_ENABLE;
+	rtl8xxxu_write16(priv, REG_SYS_FUNC, sys_func);
+	val8 = rtl8xxxu_read8(priv, REG_RSV_CTRL + 1);
+	val8 |= BIT(3);
+	rtl8xxxu_write8(priv, REG_RSV_CTRL + 1, val8);
+	sys_func |= SYS_FUNC_CPU_ENABLE;
+	rtl8xxxu_write16(priv, REG_SYS_FUNC, sys_func);
+}
+
 static int rtl8xxxu_start_firmware(struct rtl8xxxu_priv *priv)
 {
 	struct device *dev = &priv->udev->dev;
@@ -2067,6 +2085,12 @@ static int rtl8xxxu_start_firmware(struct rtl8xxxu_priv *priv)
 	val32 &= ~MCU_WINT_INIT_READY;
 	rtl8xxxu_write32(priv, REG_MCU_FW_DL, val32);
 
+	/*
+	 * Reset the 8051 in order for the firmware to start running,
+	 * otherwise it won't come up on the 8192eu
+	 */
+	rtl8xxxu_reset_8051(priv);
+
 	/* Wait for firmware to become ready */
 	for (i = 0; i < RTL8XXXU_FIRMWARE_POLL_MAX; i++) {
 		val32 = rtl8xxxu_read32(priv, REG_MCU_FW_DL);
@@ -2089,7 +2113,7 @@ exit:
 static int rtl8xxxu_download_firmware(struct rtl8xxxu_priv *priv)
 {
 	int pages, remainder, i, ret;
-	u8 val8, sys_func;
+	u8 val8;
 	u16 val16;
 	u32 val32;
 	u8 *fwptr;
@@ -2107,17 +2131,7 @@ static int rtl8xxxu_download_firmware(struct rtl8xxxu_priv *priv)
 	if (val8 & MCU_FW_RAM_SEL) {
 		pr_info("do the RAM reset\n");
 		rtl8xxxu_write8(priv, REG_MCU_FW_DL, 0x00);
-		val8 = rtl8xxxu_read8(priv, REG_RSV_CTRL + 1);
-		val8 &= ~BIT(3);
-		rtl8xxxu_write8(priv, REG_RSV_CTRL + 1, val8);
-		sys_func = rtl8xxxu_read8(priv, REG_SYS_FUNC + 1);
-		sys_func &= ~BIT(2);
-		rtl8xxxu_write8(priv, REG_SYS_FUNC + 1, sys_func);
-		val8 = rtl8xxxu_read8(priv, REG_RSV_CTRL + 1);
-		val8 |= BIT(3);
-		rtl8xxxu_write8(priv, REG_RSV_CTRL + 1, val8);
-		sys_func |= BIT(2);
-		rtl8xxxu_write8(priv, REG_SYS_FUNC + 1, sys_func);
+		rtl8xxxu_reset_8051(priv);
 	}
 
 	/* MCU firmware download enable */
-- 
2.5.0

