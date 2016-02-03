Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40042 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965902AbcBCSkD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Feb 2016 13:40:03 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 03/28] rtl8xxxu: If fw running in RAM, reset the 8051 before trying to download a new one
Date: Wed,  3 Feb 2016 13:39:37 -0500
Message-Id: <1454524802-26763-4-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160203_201502_497955_608801D3)
In-Reply-To: <1454524802-26763-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1454524802-26763-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index b6a264b..e98e053 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -2089,7 +2089,7 @@ exit:
 static int rtl8xxxu_download_firmware(struct rtl8xxxu_priv *priv)
 {
 	int pages, remainder, i, ret;
-	u8 val8;
+	u8 val8, sys_func;
 	u16 val16;
 	u32 val32;
 	u8 *fwptr;
@@ -2103,6 +2103,23 @@ static int rtl8xxxu_download_firmware(struct rtl8xxxu_priv *priv)
 	val16 |= SYS_FUNC_CPU_ENABLE;
 	rtl8xxxu_write16(priv, REG_SYS_FUNC, val16);
 
+	val8 = rtl8xxxu_read8(priv, REG_MCU_FW_DL);
+	if (val8 & MCU_FW_RAM_SEL) {
+		pr_info("do the RAM reset\n");
+		rtl8xxxu_write8(priv, REG_MCU_FW_DL, 0x00);
+		val8 = rtl8xxxu_read8(priv, REG_RSV_CTRL + 1);
+		val8 &= ~BIT(3);
+		rtl8xxxu_write8(priv, REG_RSV_CTRL + 1, val8);
+		sys_func = rtl8xxxu_read8(priv, REG_SYS_FUNC + 1);
+		sys_func &= ~BIT(2);
+		rtl8xxxu_write8(priv, REG_SYS_FUNC + 1, sys_func);
+		val8 = rtl8xxxu_read8(priv, REG_RSV_CTRL + 1);
+		val8 |= BIT(3);
+		rtl8xxxu_write8(priv, REG_RSV_CTRL + 1, val8);
+		sys_func |= BIT(2);
+		rtl8xxxu_write8(priv, REG_SYS_FUNC + 1, sys_func);
+	}
+
 	/* MCU firmware download enable */
 	val8 = rtl8xxxu_read8(priv, REG_MCU_FW_DL);
 	val8 |= MCU_FW_DL_ENABLE;
-- 
2.5.0

