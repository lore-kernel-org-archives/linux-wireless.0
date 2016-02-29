Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46718 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752911AbcB2WFz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 17:05:55 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 045/113] rtl8xxxu: Improve 8723bu init code
Date: Mon, 29 Feb 2016 17:04:43 -0500
Message-Id: <1456783551-28315-46-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160229_231008_362158_475CE737)
In-Reply-To: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Implement additional init sequence code for the 8723bu.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c   | 45 ++++++++++++++++++----
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h   |  8 ++++
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h  |  5 ++-
 3 files changed, 49 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 0db6b3f..7dcf387 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -2984,14 +2984,18 @@ static int rtl8xxxu_init_phy_bb(struct rtl8xxxu_priv *priv)
 	 *       addresses, which is initialized here. Do we need this?
 	 */
 
-	val8 = rtl8xxxu_read8(priv, REG_AFE_PLL_CTRL);
-	udelay(2);
-	val8 |= AFE_PLL_320_ENABLE;
-	rtl8xxxu_write8(priv, REG_AFE_PLL_CTRL, val8);
-	udelay(2);
+	if (priv->rtlchip == 0x8723b) {
+		rtl8xxxu_write32(priv, REG_S0S1_PATH_SWITCH, 0x00);
+	} else {
+		val8 = rtl8xxxu_read8(priv, REG_AFE_PLL_CTRL);
+		udelay(2);
+		val8 |= AFE_PLL_320_ENABLE;
+		rtl8xxxu_write8(priv, REG_AFE_PLL_CTRL, val8);
+		udelay(2);
 
-	rtl8xxxu_write8(priv, REG_AFE_PLL_CTRL + 1, 0xff);
-	udelay(2);
+		rtl8xxxu_write8(priv, REG_AFE_PLL_CTRL + 1, 0xff);
+		udelay(2);
+	}
 
 	val8 = rtl8xxxu_read8(priv, REG_SYS_FUNC);
 	val8 |= SYS_FUNC_BB_GLB_RSTN | SYS_FUNC_BBRSTB;
@@ -5603,6 +5607,21 @@ static void rtl8xxxu_power_off(struct rtl8xxxu_priv *priv)
 	rtl8xxxu_write8(priv, REG_RSV_CTRL, 0x0e);
 }
 
+static void rtl8723bu_set_ps_tdma(struct rtl8xxxu_priv *priv,
+				  u8 arg1, u8 arg2, u8 arg3, u8 arg4, u8 arg5)
+{
+	struct h2c_cmd h2c;
+
+	memset(&h2c, 0, sizeof(struct h2c_cmd));
+	h2c.b_type_dma.cmd = H2C_8723B_B_TYPE_TDMA;
+	h2c.b_type_dma.data1 = arg1;
+	h2c.b_type_dma.data2 = arg2;
+	h2c.b_type_dma.data3 = arg3;
+	h2c.b_type_dma.data4 = arg4;
+	h2c.b_type_dma.data5 = arg5;
+	rtl8723a_h2c_cmd(priv, &h2c, sizeof(h2c.b_type_dma));
+}
+
 static void rtl8723bu_init_bt(struct rtl8xxxu_priv *priv)
 {
 	struct h2c_cmd h2c;
@@ -5683,7 +5702,17 @@ static void rtl8723bu_init_bt(struct rtl8xxxu_priv *priv)
 	/*
 	 * 0x280, 0x00, 0x200, 0x80 - not clear
 	 */
-	rtl8xxxu_write32(priv, REG_S0S1_PATH_SWITCH, 0x280);
+	rtl8xxxu_write32(priv, REG_S0S1_PATH_SWITCH, 0x00);
+
+	/*
+	 * Software control, antenna at WiFi side
+	 */
+	rtl8723bu_set_ps_tdma(priv, 0x00, 0x00, 0x00, 0x00, 0x00);
+
+	rtl8xxxu_write32(priv, REG_BT_COEX_TABLE1, 0x55555555);
+	rtl8xxxu_write32(priv, REG_BT_COEX_TABLE2, 0x5a5a5a5a);
+	rtl8xxxu_write32(priv, REG_BT_COEX_TABLE3, 0x00ffffff);
+	rtl8xxxu_write32(priv, REG_BT_COEX_TABLE4, 0x00000003);
 }
 
 static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
index bcbdc78..c4c0b28 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
@@ -742,6 +742,14 @@ struct h2c_cmd {
 		} __packed ramask;
 		struct {
 			u8 cmd;
+			u8 data1;
+			u8 data2;
+			u8 data3;
+			u8 data4;
+			u8 data5;
+		} __packed b_type_dma;
+		struct {
+			u8 cmd;
 			u8 data;
 		} __packed bt_wlan_calibration;
 		struct {
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
index 248f64c..a82c0ba 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
@@ -709,7 +709,10 @@
 #define REG_BCN_PSR_RPT			0x06a8
 #define REG_CALB32K_CTRL		0x06ac
 #define REG_PKT_MON_CTRL		0x06b4
-#define REG_BT_COEX_TABLE		0x06c0
+#define REG_BT_COEX_TABLE1		0x06c0
+#define REG_BT_COEX_TABLE2		0x06c4
+#define REG_BT_COEX_TABLE3		0x06c8
+#define REG_BT_COEX_TABLE4		0x06cc
 #define REG_WMAC_RESP_TXINFO		0x06d8
 
 #define REG_MACID1			0x0700
-- 
2.5.0

