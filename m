Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43340 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751471AbcB2WFx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 17:05:53 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 002/113] rtl8xxxu: Identify chip vendors correctly
Date: Mon, 29 Feb 2016 17:04:00 -0500
Message-Id: <1456783551-28315-3-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160229_232951_352285_6BE76725)
In-Reply-To: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

This identifies the chip vendors correctly and also picks the correct
firmware for rtl8192eu.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c   | 73 +++++++++++++++++-----
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h   |  2 +
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h  |  4 ++
 3 files changed, 64 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 8dc4b2d..2db2d21 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -1662,16 +1662,24 @@ static void rtl8xxxu_print_chipinfo(struct rtl8xxxu_priv *priv)
 	case 1:
 		cut = "B";
 		break;
+	case 2:
+		cut = "C";
+		break;
+	case 3:
+		cut = "D";
+		break;
+	case 4:
+		cut = "E";
+		break;
 	default:
 		cut = "unknown";
 	}
 
 	dev_info(dev,
 		 "RTL%s rev %s (%s) %iT%iR, TX queues %i, WiFi=%i, BT=%i, GPS=%i, HI PA=%i\n",
-		 priv->chip_name, cut, priv->vendor_umc ? "UMC" : "TSMC",
-		 priv->tx_paths, priv->rx_paths, priv->ep_tx_count,
-		 priv->has_wifi, priv->has_bluetooth, priv->has_gps,
-		 priv->hi_pa);
+		 priv->chip_name, cut, priv->chip_vendor, priv->tx_paths,
+		 priv->rx_paths, priv->ep_tx_count, priv->has_wifi,
+		 priv->has_bluetooth, priv->has_gps, priv->hi_pa);
 
 	dev_info(dev, "RTL%s MAC: %pM\n", priv->chip_name, priv->mac_addr);
 }
@@ -1708,7 +1716,21 @@ static int rtl8xxxu_identify_chip(struct rtl8xxxu_priv *priv)
 	} else if (val32 & SYS_CFG_TYPE_ID) {
 		bonding = rtl8xxxu_read32(priv, REG_HPON_FSM);
 		bonding &= HPON_FSM_BONDING_MASK;
-		if (bonding == HPON_FSM_BONDING_1T2R) {
+		if (priv->chip_cut >= 3) {
+			if (bonding == HPON_FSM_BONDING_1T2R) {
+				sprintf(priv->chip_name, "8191EU");
+				priv->rf_paths = 2;
+				priv->rx_paths = 2;
+				priv->tx_paths = 1;
+				priv->rtlchip = 0x8191e;
+			} else {
+				sprintf(priv->chip_name, "8192EU");
+				priv->rf_paths = 2;
+				priv->rx_paths = 2;
+				priv->tx_paths = 2;
+				priv->rtlchip = 0x8192e;
+			}
+		} else if (bonding == HPON_FSM_BONDING_1T2R) {
 			sprintf(priv->chip_name, "8191CU");
 			priv->rf_paths = 2;
 			priv->rx_paths = 2;
@@ -1731,8 +1753,34 @@ static int rtl8xxxu_identify_chip(struct rtl8xxxu_priv *priv)
 		priv->has_wifi = 1;
 	}
 
-	if (val32 & SYS_CFG_VENDOR_ID)
-		priv->vendor_umc = 1;
+	switch (priv->rtlchip) {
+	case 0x8188e:
+	case 0x8192e:
+	case 0x8723b:
+		switch (val32 & SYS_CFG_VENDOR_EXT_MASK) {
+		case SYS_CFG_VENDOR_ID_TSMC:
+			sprintf(priv->chip_vendor, "TSMC");
+			break;
+		case SYS_CFG_VENDOR_ID_SMIC:
+			sprintf(priv->chip_vendor, "SMIC");
+			priv->vendor_smic = 1;
+			break;
+		case SYS_CFG_VENDOR_ID_UMC:
+			sprintf(priv->chip_vendor, "UMC");
+			priv->vendor_umc = 1;
+			break;
+		default:
+			sprintf(priv->chip_vendor, "unknown");
+		}
+		break;
+	default:
+		if (val32 & SYS_CFG_VENDOR_ID) {
+			sprintf(priv->chip_vendor, "UMC");
+			priv->vendor_umc = 1;
+		} else {
+			sprintf(priv->chip_vendor, "TSMC");
+		}
+	}
 
 	val32 = rtl8xxxu_read32(priv, REG_GPIO_OUTSTS);
 	priv->rom_rev = (val32 & GPIO_RF_RL_ID) >> 28;
@@ -1934,7 +1982,7 @@ static int rtl8192eu_parse_efuse(struct rtl8xxxu_priv *priv)
 				 raw[i + 6], raw[i + 7]);
 		}
 	}
-	return -EINVAL;
+	return 0;
 }
 
 static int
@@ -2269,6 +2317,7 @@ static int rtl8xxxu_load_firmware(struct rtl8xxxu_priv *priv, char *fw_name)
 
 	signature = le16_to_cpu(priv->fw_data->signature);
 	switch (signature & 0xfff0) {
+	case 0x92e0:
 	case 0x92c0:
 	case 0x88c0:
 	case 0x2300:
@@ -2338,13 +2387,7 @@ static int rtl8192eu_load_firmware(struct rtl8xxxu_priv *priv)
 	char *fw_name;
 	int ret;
 
-	return -EBUSY;
-	if (!priv->vendor_umc)
-		fw_name = "rtlwifi/rtl8192cufw_TMSC.bin";
-	else if (priv->chip_cut || priv->rtlchip == 0x8192c)
-		fw_name = "rtlwifi/rtl8192cufw_B.bin";
-	else
-		fw_name = "rtlwifi/rtl8192cufw_A.bin";
+	fw_name = "rtlwifi/rtl8192eu_nic.bin";
 
 	ret = rtl8xxxu_load_firmware(priv, fw_name);
 
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
index 8168a35..0d4ff80 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
@@ -625,6 +625,7 @@ struct rtl8xxxu_priv {
 
 	u8 mac_addr[ETH_ALEN];
 	char chip_name[8];
+	char chip_vendor[8];
 	u8 cck_tx_power_index_A[3];	/* 0x10 */
 	u8 cck_tx_power_index_B[3];
 	u8 ht40_1s_tx_power_index_A[3];	/* 0x16 */
@@ -647,6 +648,7 @@ struct rtl8xxxu_priv {
 	u32 has_gps:1;
 	u32 hi_pa:1;
 	u32 vendor_umc:1;
+	u32 vendor_smic:1;
 	u32 has_polarity_ctrl:1;
 	u32 has_eeprom:1;
 	u32 boot_eeprom:1;
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
index 8f6c9c6..a934c0d 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
@@ -222,6 +222,10 @@
 #define  SYS_CFG_CHIP_VER		(BIT(12) | BIT(13) | BIT(14) | BIT(15))
 #define  SYS_CFG_BT_FUNC		BIT(16)
 #define  SYS_CFG_VENDOR_ID		BIT(19)
+#define  SYS_CFG_VENDOR_EXT_MASK	(BIT(18) | BIT(19))
+#define   SYS_CFG_VENDOR_ID_TSMC	0
+#define   SYS_CFG_VENDOR_ID_SMIC	BIT(18)
+#define   SYS_CFG_VENDOR_ID_UMC		BIT(19)
 #define  SYS_CFG_PAD_HWPD_IDN		BIT(22)
 #define  SYS_CFG_TRP_VAUX_EN		BIT(23)
 #define  SYS_CFG_TRP_BT_EN		BIT(24)
-- 
2.5.0

