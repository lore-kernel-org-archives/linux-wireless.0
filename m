Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43337 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751346AbcB2WFx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 17:05:53 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 001/113] rtl8xxxu: Add initial code to parse rtl8192eu efuse
Date: Mon, 29 Feb 2016 17:03:59 -0500
Message-Id: <1456783551-28315-2-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160229_232950_979349_C52CAA58)
In-Reply-To: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

This is the start of 8192eu support. For now just detect the device
and parse the efuse.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 80 +++++++++++++++++++++++-
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h | 50 ++++++++++++++-
 2 files changed, 124 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index fdeae3b..8dc4b2d 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -42,7 +42,7 @@
 
 #define DRIVER_NAME "rtl8xxxu"
 
-static int rtl8xxxu_debug;
+static int rtl8xxxu_debug = RTL8XXXU_DEBUG_EFUSE;
 static bool rtl8xxxu_ht40_2g;
 
 MODULE_AUTHOR("Jes Sorensen <Jes.Sorensen@redhat.com>");
@@ -1890,6 +1890,53 @@ static int rtl8192cu_parse_efuse(struct rtl8xxxu_priv *priv)
 
 #endif
 
+static int rtl8192eu_parse_efuse(struct rtl8xxxu_priv *priv)
+{
+	int i;
+
+	if (priv->efuse_wifi.efuse8192eu.rtl_id != cpu_to_le16(0x8129))
+		return -EINVAL;
+
+	ether_addr_copy(priv->mac_addr, priv->efuse_wifi.efuse8192eu.mac_addr);
+
+	memcpy(priv->cck_tx_power_index_A,
+	       priv->efuse_wifi.efuse8192eu.cck_tx_power_index_A,
+	       sizeof(priv->cck_tx_power_index_A));
+	memcpy(priv->cck_tx_power_index_B,
+	       priv->efuse_wifi.efuse8192eu.cck_tx_power_index_B,
+	       sizeof(priv->cck_tx_power_index_B));
+
+	memcpy(priv->ht40_1s_tx_power_index_A,
+	       priv->efuse_wifi.efuse8192eu.ht40_1s_tx_power_index_A,
+	       sizeof(priv->ht40_1s_tx_power_index_A));
+	memcpy(priv->ht40_1s_tx_power_index_B,
+	       priv->efuse_wifi.efuse8192eu.ht40_1s_tx_power_index_B,
+	       sizeof(priv->ht40_1s_tx_power_index_B));
+
+	dev_info(&priv->udev->dev, "Vendor: %.7s\n",
+		 priv->efuse_wifi.efuse8192eu.vendor_name);
+	dev_info(&priv->udev->dev, "Product: %.11s\n",
+		 priv->efuse_wifi.efuse8192eu.device_name);
+	dev_info(&priv->udev->dev, "Serial: %.11s\n",
+		 priv->efuse_wifi.efuse8192eu.serial);
+
+	if (rtl8xxxu_debug & RTL8XXXU_DEBUG_EFUSE) {
+		unsigned char *raw = priv->efuse_wifi.raw;
+
+		dev_info(&priv->udev->dev,
+			 "%s: dumping efuse (0x%02zx bytes):\n",
+			 __func__, sizeof(struct rtl8192eu_efuse));
+		for (i = 0; i < sizeof(struct rtl8192eu_efuse); i += 8) {
+			dev_info(&priv->udev->dev, "%02x: "
+				 "%02x %02x %02x %02x %02x %02x %02x %02x\n", i,
+				 raw[i], raw[i + 1], raw[i + 2],
+				 raw[i + 3], raw[i + 4], raw[i + 5],
+				 raw[i + 6], raw[i + 7]);
+		}
+	}
+	return -EINVAL;
+}
+
 static int
 rtl8xxxu_read_efuse8(struct rtl8xxxu_priv *priv, u16 offset, u8 *data)
 {
@@ -1973,7 +2020,7 @@ static int rtl8xxxu_read_efuse(struct rtl8xxxu_priv *priv)
 	}
 
 	/* Default value is 0xff */
-	memset(priv->efuse_wifi.raw, 0xff, EFUSE_MAP_LEN_8723A);
+	memset(priv->efuse_wifi.raw, 0xff, EFUSE_MAP_LEN);
 
 	efuse_addr = 0;
 	while (efuse_addr < EFUSE_REAL_CONTENT_LEN_8723A) {
@@ -2005,7 +2052,7 @@ static int rtl8xxxu_read_efuse(struct rtl8xxxu_priv *priv)
 
 			/* We have 8 bits to indicate validity */
 			map_addr = offset * 8;
-			if (map_addr >= EFUSE_MAP_LEN_8723A) {
+			if (map_addr >= EFUSE_MAP_LEN) {
 				dev_warn(dev, "%s: Illegal map_addr (%04x), "
 					 "efuse corrupt!\n",
 					 __func__, map_addr);
@@ -2286,6 +2333,24 @@ static int rtl8192cu_load_firmware(struct rtl8xxxu_priv *priv)
 
 #endif
 
+static int rtl8192eu_load_firmware(struct rtl8xxxu_priv *priv)
+{
+	char *fw_name;
+	int ret;
+
+	return -EBUSY;
+	if (!priv->vendor_umc)
+		fw_name = "rtlwifi/rtl8192cufw_TMSC.bin";
+	else if (priv->chip_cut || priv->rtlchip == 0x8192c)
+		fw_name = "rtlwifi/rtl8192cufw_B.bin";
+	else
+		fw_name = "rtlwifi/rtl8192cufw_A.bin";
+
+	ret = rtl8xxxu_load_firmware(priv, fw_name);
+
+	return ret;
+}
+
 static void rtl8xxxu_firmware_self_reset(struct rtl8xxxu_priv *priv)
 {
 	u16 val16;
@@ -5863,6 +5928,13 @@ static struct rtl8xxxu_fileops rtl8192cu_fops = {
 
 #endif
 
+static struct rtl8xxxu_fileops rtl8192eu_fops = {
+	.parse_efuse = rtl8192eu_parse_efuse,
+	.load_firmware = rtl8192eu_load_firmware,
+	.power_on = rtl8192cu_power_on,
+	.writeN_block_size = 128,
+};
+
 static struct usb_device_id dev_table[] = {
 {USB_DEVICE_AND_INTERFACE_INFO(USB_VENDOR_ID_REALTEK, 0x8724, 0xff, 0xff, 0xff),
 	.driver_info = (unsigned long)&rtl8723au_fops},
@@ -5870,6 +5942,8 @@ static struct usb_device_id dev_table[] = {
 	.driver_info = (unsigned long)&rtl8723au_fops},
 {USB_DEVICE_AND_INTERFACE_INFO(USB_VENDOR_ID_REALTEK, 0x0724, 0xff, 0xff, 0xff),
 	.driver_info = (unsigned long)&rtl8723au_fops},
+{USB_DEVICE_AND_INTERFACE_INFO(USB_VENDOR_ID_REALTEK, 0x818b, 0xff, 0xff, 0xff),
+	.driver_info = (unsigned long)&rtl8192eu_fops},
 #ifdef CONFIG_RTL8XXXU_UNTESTED
 /* Still supported by rtlwifi */
 {USB_DEVICE_AND_INTERFACE_INFO(USB_VENDOR_ID_REALTEK, 0x8176, 0xff, 0xff, 0xff),
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
index bbd0f6b..8168a35 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
@@ -55,8 +55,8 @@
 #define RTL8723A_MAX_RF_PATHS		2
 #define RF6052_MAX_TX_PWR		0x3f
 
-#define EFUSE_MAP_LEN_8723A		256
-#define EFUSE_MAX_SECTION_8723A		32
+#define EFUSE_MAP_LEN			512
+#define EFUSE_MAX_SECTION_8723A		64
 #define EFUSE_REAL_CONTENT_LEN_8723A	512
 #define EFUSE_BT_MAP_LEN_8723A		1024
 #define EFUSE_MAX_WORD_UNIT		4
@@ -500,6 +500,49 @@ struct rtl8192cu_efuse {
 	u8 customer_id;
 };
 
+struct rtl8192eu_efuse {
+	__le16 rtl_id;
+	u8 res0[0x0e];
+	u8 cck_tx_power_index_A[3];	/* 0x10 */
+	u8 cck_tx_power_index_B[3];
+	u8 ht40_1s_tx_power_index_A[3];	/* 0x16 */
+	u8 ht40_1s_tx_power_index_B[3];
+	u8 res1[0x9c];
+	u8 channel_plan;		/* 0xb8 */
+	u8 xtal_k;
+	u8 thermal_meter;
+	u8 iqk_lck;
+	u8 pa_type;			/* 0xbc */
+	u8 lna_type_2g;			/* 0xbd */
+	u8 res2[1];
+	u8 lna_type_5g;			/* 0xbf */
+	u8 res13[1];
+	u8 rf_board_option;
+	u8 rf_feature_option;
+	u8 rf_bt_setting;
+	u8 eeprom_version;
+	u8 eeprom_customer_id;
+	u8 res3[3];
+	u8 rf_antenna_option;		/* 0xc9 */
+	u8 res4[6];
+	u8 vid;				/* 0xd0 */
+	u8 res5[1];
+	u8 pid;				/* 0xd2 */
+	u8 res6[1];
+	u8 usb_optional_function;
+	u8 res7[2];
+	u8 mac_addr[ETH_ALEN];		/* 0xd7 */
+	u8 res8[2];
+	u8 vendor_name[7];
+	u8 res9[2];
+	u8 device_name[0x0b];		/* 0xe8 */
+	u8 res10[2];
+	u8 serial[0x0b];		/* 0xf5 */
+	u8 res11[0x30];
+	u8 unknown[0x0d];		/* 0x130 */
+	u8 res12[0xc3];
+};
+
 struct rtl8xxxu_reg8val {
 	u16 reg;
 	u8 val;
@@ -643,9 +686,10 @@ struct rtl8xxxu_priv {
 		u8 val8;
 	} usb_buf;
 	union {
-		u8 raw[EFUSE_MAP_LEN_8723A];
+		u8 raw[EFUSE_MAP_LEN];
 		struct rtl8723au_efuse efuse8723;
 		struct rtl8192cu_efuse efuse8192;
+		struct rtl8192eu_efuse efuse8192eu;
 	} efuse_wifi;
 	u32 adda_backup[RTL8XXXU_ADDA_REGS];
 	u32 mac_backup[RTL8XXXU_MAC_REGS];
-- 
2.5.0

