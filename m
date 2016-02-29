Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45371 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753532AbcB2WGE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 17:06:04 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 112/113] rtl8xxxu: Use correct 8051 reset function for 8723b parts
Date: Mon, 29 Feb 2016 17:05:50 -0500
Message-Id: <1456783551-28315-113-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160229_232953_514878_AE79A60C)
In-Reply-To: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

8723b needs more action, so implement support for device specific
reset functions.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 40 ++++++++++++++++++++++--
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h |  1 +
 2 files changed, 39 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 11a970c..1c5a6ef 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -2720,12 +2720,44 @@ static void rtl8xxxu_reset_8051(struct rtl8xxxu_priv *priv)
 	val8 = rtl8xxxu_read8(priv, REG_RSV_CTRL + 1);
 	val8 &= ~BIT(0);
 	rtl8xxxu_write8(priv, REG_RSV_CTRL + 1, val8);
+
 	sys_func = rtl8xxxu_read16(priv, REG_SYS_FUNC);
 	sys_func &= ~SYS_FUNC_CPU_ENABLE;
 	rtl8xxxu_write16(priv, REG_SYS_FUNC, sys_func);
+
 	val8 = rtl8xxxu_read8(priv, REG_RSV_CTRL + 1);
 	val8 |= BIT(0);
 	rtl8xxxu_write8(priv, REG_RSV_CTRL + 1, val8);
+
+	sys_func |= SYS_FUNC_CPU_ENABLE;
+	rtl8xxxu_write16(priv, REG_SYS_FUNC, sys_func);
+}
+
+static void rtl8723bu_reset_8051(struct rtl8xxxu_priv *priv)
+{
+	u8 val8;
+	u16 sys_func;
+
+	val8 = rtl8xxxu_read8(priv, REG_RSV_CTRL);
+	val8 &= ~BIT(1);
+	rtl8xxxu_write8(priv, REG_RSV_CTRL, val8);
+
+	val8 = rtl8xxxu_read8(priv, REG_RSV_CTRL + 1);
+	val8 &= ~BIT(0);
+	rtl8xxxu_write8(priv, REG_RSV_CTRL + 1, val8);
+
+	sys_func = rtl8xxxu_read16(priv, REG_SYS_FUNC);
+	sys_func &= ~SYS_FUNC_CPU_ENABLE;
+	rtl8xxxu_write16(priv, REG_SYS_FUNC, sys_func);
+
+	val8 = rtl8xxxu_read8(priv, REG_RSV_CTRL);
+	val8 &= ~BIT(1);
+	rtl8xxxu_write8(priv, REG_RSV_CTRL, val8);
+
+	val8 = rtl8xxxu_read8(priv, REG_RSV_CTRL + 1);
+	val8 |= BIT(0);
+	rtl8xxxu_write8(priv, REG_RSV_CTRL + 1, val8);
+
 	sys_func |= SYS_FUNC_CPU_ENABLE;
 	rtl8xxxu_write16(priv, REG_SYS_FUNC, sys_func);
 }
@@ -2758,7 +2790,7 @@ static int rtl8xxxu_start_firmware(struct rtl8xxxu_priv *priv)
 	 * Reset the 8051 in order for the firmware to start running,
 	 * otherwise it won't come up on the 8192eu
 	 */
-	rtl8xxxu_reset_8051(priv);
+	priv->fops->reset_8051(priv);
 
 	/* Wait for firmware to become ready */
 	for (i = 0; i < RTL8XXXU_FIRMWARE_POLL_MAX; i++) {
@@ -2805,7 +2837,7 @@ static int rtl8xxxu_download_firmware(struct rtl8xxxu_priv *priv)
 	if (val8 & MCU_FW_RAM_SEL) {
 		pr_info("do the RAM reset\n");
 		rtl8xxxu_write8(priv, REG_MCU_FW_DL, 0x00);
-		rtl8xxxu_reset_8051(priv);
+		priv->fops->reset_8051(priv);
 	}
 
 	/* MCU firmware download enable */
@@ -8405,6 +8437,7 @@ static struct rtl8xxxu_fileops rtl8723au_fops = {
 	.load_firmware = rtl8723au_load_firmware,
 	.power_on = rtl8723au_power_on,
 	.power_off = rtl8xxxu_power_off,
+	.reset_8051 = rtl8xxxu_reset_8051,
 	.llt_init = rtl8xxxu_init_llt_table,
 	.phy_iq_calibrate = rtl8723au_phy_iq_calibrate,
 	.config_channel = rtl8723au_config_channel,
@@ -8429,6 +8462,7 @@ static struct rtl8xxxu_fileops rtl8723bu_fops = {
 	.load_firmware = rtl8723bu_load_firmware,
 	.power_on = rtl8723bu_power_on,
 	.power_off = rtl8723bu_power_off,
+	.reset_8051 = rtl8723bu_reset_8051,
 	.llt_init = rtl8xxxu_auto_llt_table,
 	.phy_init_antenna_selection = rtl8723bu_phy_init_antenna_selection,
 	.phy_iq_calibrate = rtl8723bu_phy_iq_calibrate,
@@ -8459,6 +8493,7 @@ static struct rtl8xxxu_fileops rtl8192cu_fops = {
 	.load_firmware = rtl8192cu_load_firmware,
 	.power_on = rtl8192cu_power_on,
 	.power_off = rtl8xxxu_power_off,
+	.reset_8051 = rtl8xxxu_reset_8051,
 	.llt_init = rtl8xxxu_init_llt_table,
 	.phy_iq_calibrate = rtl8723au_phy_iq_calibrate,
 	.config_channel = rtl8723au_config_channel,
@@ -8485,6 +8520,7 @@ static struct rtl8xxxu_fileops rtl8192eu_fops = {
 	.load_firmware = rtl8192eu_load_firmware,
 	.power_on = rtl8192eu_power_on,
 	.power_off = rtl8xxxu_power_off,
+	.reset_8051 = rtl8xxxu_reset_8051,
 	.llt_init = rtl8xxxu_auto_llt_table,
 	.phy_iq_calibrate = rtl8723bu_phy_iq_calibrate,
 	.config_channel = rtl8723bu_config_channel,
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
index bfa9d6c..7b73654 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
@@ -1258,6 +1258,7 @@ struct rtl8xxxu_fileops {
 	int (*load_firmware) (struct rtl8xxxu_priv *priv);
 	int (*power_on) (struct rtl8xxxu_priv *priv);
 	void (*power_off) (struct rtl8xxxu_priv *priv);
+	void (*reset_8051) (struct rtl8xxxu_priv *priv);
 	int (*llt_init) (struct rtl8xxxu_priv *priv, u8 last_tx_page);
 	void (*phy_init_antenna_selection) (struct rtl8xxxu_priv *priv);
 	void (*phy_iq_calibrate) (struct rtl8xxxu_priv *priv);
-- 
2.5.0

