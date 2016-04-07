Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48259 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757314AbcDGSTe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Apr 2016 14:19:34 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net
Subject: [PATCH 18/18] rtl8xxxu: Adjust AFE crystal value on 8192eu
Date: Thu,  7 Apr 2016 14:19:33 -0400
Message-Id: <1460053173-8494-19-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160407_202528_682505_3C5265E9)
In-Reply-To: <1460053173-8494-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1460053173-8494-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Adjust AFE before enabling PLL on 8192eu, probably also needed for
8723bu.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c   | 39 ++++++++++++++++++++++
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h  |  4 +++
 2 files changed, 43 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 61c0ece..b8cd42e 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -7093,6 +7093,41 @@ static int rtl8192cu_power_on(struct rtl8xxxu_priv *priv)
 
 #endif
 
+/*
+ * This is needed for 8723bu as well, presumable
+ */
+static void rtl8192e_crystal_afe_adjust(struct rtl8xxxu_priv *priv)
+{
+	u8 val8;
+	u32 val32;
+
+	/*
+	 * 40Mhz crystal source, MAC 0x28[2]=0
+	 */
+	val8 = rtl8xxxu_read8(priv, REG_AFE_PLL_CTRL);
+	val8 &= 0xfb;
+	rtl8xxxu_write8(priv, REG_AFE_PLL_CTRL, val8);
+
+	val32 = rtl8xxxu_read32(priv, REG_AFE_CTRL4);
+	val32 &= 0xfffffc7f;
+	rtl8xxxu_write32(priv, REG_AFE_CTRL4, val32);
+
+	/*
+	 * 92e AFE parameter
+	 * AFE PLL KVCO selection, MAC 0x28[6]=1
+	 */
+	val8 = rtl8xxxu_read8(priv, REG_AFE_PLL_CTRL);
+	val8 &= 0xbf;
+	rtl8xxxu_write8(priv, REG_AFE_PLL_CTRL, val8);
+
+	/*
+	 * AFE PLL KVCO selection, MAC 0x78[21]=0
+	 */
+	val32 = rtl8xxxu_read32(priv, REG_AFE_CTRL4);
+	val32 &= 0xffdfffff;
+	rtl8xxxu_write32(priv, REG_AFE_CTRL4, val32);
+}
+
 static int rtl8192eu_power_on(struct rtl8xxxu_priv *priv)
 {
 	u16 val16;
@@ -7115,6 +7150,10 @@ static int rtl8192eu_power_on(struct rtl8xxxu_priv *priv)
 		rtl8xxxu_write8(priv, REG_LDO_SW_CTRL, 0x83);
 	}
 
+	/*
+	 * Adjust AFE before enabling PLL
+	 */
+	rtl8192e_crystal_afe_adjust(priv);
 	rtl8192e_disabled_to_emu(priv);
 
 	ret = rtl8192e_emu_to_active(priv);
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
index 2aa14b1..bb08a39 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
@@ -109,6 +109,9 @@
 #define  AFE_XTAL_GATE_DIG		BIT(17)
 #define  AFE_XTAL_BT_GATE		BIT(20)
 
+/*
+ * 0x0028 is also known as REG_AFE_CTRL2 on 8723bu/8192eu
+ */
 #define REG_AFE_PLL_CTRL		0x0028
 #define  AFE_PLL_ENABLE			BIT(0)
 #define  AFE_PLL_320_ENABLE		BIT(1)
@@ -192,6 +195,7 @@
 						   control */
 #define  MULTI_GPS_FUNC_EN		BIT(22)	/* GPS function enable */
 
+#define REG_AFE_CTRL4			0x0078	/* 8192eu/8723bu */
 #define REG_LDO_SW_CTRL			0x007c	/* 8192eu */
 
 #define REG_MCU_FW_DL			0x0080
-- 
2.5.5

