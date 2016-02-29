Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52260 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752868AbcB2WFz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 17:05:55 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 043/113] rtl8xxxu: Initial rtl8723bu_init_bt() code
Date: Mon, 29 Feb 2016 17:04:41 -0500
Message-Id: <1456783551-28315-44-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160229_232953_169519_1EBDCB77)
In-Reply-To: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

This should initialize the antennas on the 8723bu, but so far I am
still not receiving anything :( More work is needed.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c   | 87 +++++++++++++++++++++-
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h   | 15 +++-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h  |  2 +
 3 files changed, 98 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 1626bd8..937b495 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -5603,10 +5603,87 @@ static void rtl8xxxu_power_off(struct rtl8xxxu_priv *priv)
 	rtl8xxxu_write8(priv, REG_RSV_CTRL, 0x0e);
 }
 
-static void rtl8xxxu_init_bt(struct rtl8xxxu_priv *priv)
+static void rtl8723bu_init_bt(struct rtl8xxxu_priv *priv)
 {
-	if (!priv->has_bluetooth)
-		return;
+	struct h2c_cmd h2c;
+	u32 val32;
+	u8 val8;
+
+	/*
+	 * No indication anywhere as to what 0x0790 does. The 2 antenna
+	 * vendor code preserves bits 6-7 here.
+	 */
+	rtl8xxxu_write8(priv, 0x0790, 0x05);
+	/*
+	 * 0x0778 seems to be related to enabling the number of antennas
+	 * In the vendor driver halbtc8723b2ant_InitHwConfig() sets it
+	 * to 0x03, while halbtc8723b1ant_InitHwConfig() sets it to 0x01
+	 */
+	rtl8xxxu_write8(priv, 0x0778, 0x01);
+
+	val8 = rtl8xxxu_read8(priv, REG_GPIO_MUXCFG);
+	val8 |= BIT(5);
+	rtl8xxxu_write8(priv, REG_GPIO_MUXCFG, val8);
+
+	rtl8xxxu_write_rfreg(priv, RF_A, RF6052_REG_IQADJ_G1, 0x780);
+
+	/*
+	 * Set BT grant to low
+	 */
+	memset(&h2c, 0, sizeof(struct h2c_cmd));
+	h2c.bt_grant.cmd = H2C_8723B_BT_GRANT;
+	h2c.bt_grant.data = 0;
+	rtl8723a_h2c_cmd(priv, &h2c, sizeof(h2c.bt_grant));
+
+	/*
+	 * WLAN action by PTA
+	 */
+	rtl8xxxu_write8(priv, REG_WLAN_ACT_CONTROL_8723B, 0x0c);
+
+	/*
+	 * BT select S0/S1 controlled by WiFi
+	 */
+	val8 = rtl8xxxu_read8(priv, 0x0067);
+	val8 |= BIT(5);
+	rtl8xxxu_write8(priv, 0x0067, val8);
+
+	val32 = rtl8xxxu_read32(priv, REG_PWR_DATA);
+	val32 |= BIT(11);
+	rtl8xxxu_write32(priv, REG_PWR_DATA, val32);
+
+	/*
+	 * Bits 6/7 are marked in/out ... but for what?
+	 */
+	rtl8xxxu_write8(priv, 0x0974, 0xff);
+
+	val32 = rtl8xxxu_read32(priv, 0x0944);
+	val32 |= (BIT(0) | BIT(1));
+	rtl8xxxu_write32(priv, 0x0944, val32);
+
+	rtl8xxxu_write8(priv, REG_RFE_CTRL_ANTA_SRC, 0x77);
+
+	val32 = rtl8xxxu_read32(priv, REG_LEDCFG0);
+	val32 &= ~BIT(24);
+	val32 |= BIT(23);
+	rtl8xxxu_write32(priv, REG_LEDCFG0, val32);
+
+	/*
+	 * Fix external switch Main->S1, Aux->S0
+	 */
+	val8 = rtl8xxxu_read8(priv, REG_PAD_CTRL1);
+	val8 &= ~BIT(0);
+	rtl8xxxu_write8(priv, REG_PAD_CTRL1, val8);
+
+	memset(&h2c, 0, sizeof(struct h2c_cmd));
+	h2c.ant_sel_rsv.cmd = H2C_8723B_ANT_SEL_RSV;
+	h2c.ant_sel_rsv.ant_inverse = 1;
+	h2c.ant_sel_rsv.int_switch_type = 0;
+	rtl8723a_h2c_cmd(priv, &h2c, sizeof(h2c.ant_sel_rsv));
+
+	/*
+	 * 0x280, 0x00, 0x200, 0x80 - not clear
+	 */
+	rtl8xxxu_write32(priv, REG_S0S1_PATH_SWITCH, 0x280);
 }
 
 static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
@@ -5933,7 +6010,8 @@ static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
 	rtl8xxxu_write_rfreg(priv, RF_A, RF6052_REG_T_METER, 0x60);
 
 	/* Init BT hw config. */
-	rtl8xxxu_init_bt(priv);
+	if (priv->fops->init_bt)
+		priv->fops->init_bt(priv);
 
 	/* Set NAV_UPPER to 30000us */
 	val8 = ((30000 + NAV_UPPER_UNIT - 1) / NAV_UPPER_UNIT);
@@ -7469,6 +7547,7 @@ static struct rtl8xxxu_fileops rtl8723bu_fops = {
 	.phy_init_antenna_selection = rtl8723bu_phy_init_antenna_selection,
 	.phy_iq_calibrate = rtl8723bu_phy_iq_calibrate,
 	.config_channel = rtl8723bu_config_channel,
+	.init_bt = rtl8723bu_init_bt,
 	.writeN_block_size = 1024,
 	.mbox_ext_reg = REG_HMBOX_EXT0_8723B,
 	.mbox_ext_width = 4,
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
index bce52cd..bcbdc78 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
@@ -696,8 +696,9 @@ enum h2c_cmd_8723b {
 	H2C_8723B_BT_MP_OPER = 0x67,
 	H2C_8723B_BT_CONTROL = 0x68,
 	H2C_8723B_BT_WIFI_CTRL = 0x69,
-	H2C_8723B_BT_FW_PATCH = 0x6A,
-	H2C_8723B_BT_WLAN_CALIBRATION = 0x6D,
+	H2C_8723B_BT_FW_PATCH = 0x6a,
+	H2C_8723B_BT_WLAN_CALIBRATION = 0x6d,
+	H2C_8723B_BT_GRANT = 0x6e,
 
 	/*
 	 * WOWLAN Class: 100
@@ -743,6 +744,15 @@ struct h2c_cmd {
 			u8 cmd;
 			u8 data;
 		} __packed bt_wlan_calibration;
+		struct {
+			u8 cmd;
+			u8 ant_inverse;
+			u8 int_switch_type;
+		} __packed ant_sel_rsv;
+		struct {
+			u8 cmd;
+			u8 data;
+		} __packed bt_grant;
 	};
 };
 
@@ -862,6 +872,7 @@ struct rtl8xxxu_fileops {
 	void (*phy_init_antenna_selection) (struct rtl8xxxu_priv *priv);
 	void (*phy_iq_calibrate) (struct rtl8xxxu_priv *priv);
 	void (*config_channel) (struct ieee80211_hw *hw);
+	void (*init_bt) (struct rtl8xxxu_priv *priv);
 	int writeN_block_size;
 	u16 mbox_ext_reg;
 	char mbox_ext_width;
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
index 147deba..248f64c 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
@@ -721,6 +721,8 @@
 #define REG_BT_CONTROL_8723BU		0x0764
 #define  BT_CONTROL_BT_GRANT		BIT(12)
 
+#define REG_WLAN_ACT_CONTROL_8723B	0x076e
+
 #define REG_FPGA0_RF_MODE		0x0800
 #define  FPGA_RF_MODE			BIT(0)
 #define  FPGA_RF_MODE_JAPAN		BIT(1)
-- 
2.5.0

