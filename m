Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46705 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752650AbcB2WFx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 17:05:53 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 013/113] rtl8xxxu: Add rtl8723bu_parse_efuse() and 8723bu efuse definition
Date: Mon, 29 Feb 2016 17:04:11 -0500
Message-Id: <1456783551-28315-14-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160229_231123_358059_CD27F060)
In-Reply-To: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Implement first stab at parsing the 8723bu's efuse.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 47 +++++++++++++++++++++++-
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h | 42 +++++++++++++++++++++
 2 files changed, 88 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index cd0c84a..b6068da 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -1877,6 +1877,51 @@ static int rtl8723au_parse_efuse(struct rtl8xxxu_priv *priv)
 	return 0;
 }
 
+static int rtl8723bu_parse_efuse(struct rtl8xxxu_priv *priv)
+{
+	if (priv->efuse_wifi.efuse8723bu.rtl_id != cpu_to_le16(0x8129))
+		return -EINVAL;
+
+	ether_addr_copy(priv->mac_addr, priv->efuse_wifi.efuse8723bu.mac_addr);
+
+	memcpy(priv->cck_tx_power_index_A,
+	       priv->efuse_wifi.efuse8723bu.cck_tx_power_index_A,
+	       sizeof(priv->cck_tx_power_index_A));
+	memcpy(priv->cck_tx_power_index_B,
+	       priv->efuse_wifi.efuse8723bu.cck_tx_power_index_B,
+	       sizeof(priv->cck_tx_power_index_B));
+
+	memcpy(priv->ht40_1s_tx_power_index_A,
+	       priv->efuse_wifi.efuse8723bu.ht40_1s_tx_power_index_A,
+	       sizeof(priv->ht40_1s_tx_power_index_A));
+	memcpy(priv->ht40_1s_tx_power_index_B,
+	       priv->efuse_wifi.efuse8723bu.ht40_1s_tx_power_index_B,
+	       sizeof(priv->ht40_1s_tx_power_index_B));
+
+	dev_info(&priv->udev->dev, "Vendor: %.7s\n",
+		 priv->efuse_wifi.efuse8723bu.vendor_name);
+	dev_info(&priv->udev->dev, "Product: %.41s\n",
+		 priv->efuse_wifi.efuse8723bu.device_name);
+
+	if (rtl8xxxu_debug & RTL8XXXU_DEBUG_EFUSE) {
+		int i;
+		unsigned char *raw = priv->efuse_wifi.raw;
+
+		dev_info(&priv->udev->dev,
+			 "%s: dumping efuse (0x%02zx bytes):\n",
+			 __func__, sizeof(struct rtl8723bu_efuse));
+		for (i = 0; i < sizeof(struct rtl8723bu_efuse); i += 8) {
+			dev_info(&priv->udev->dev, "%02x: "
+				 "%02x %02x %02x %02x %02x %02x %02x %02x\n", i,
+				 raw[i], raw[i + 1], raw[i + 2],
+				 raw[i + 3], raw[i + 4], raw[i + 5],
+				 raw[i + 6], raw[i + 7]);
+		}
+	}
+
+	return 0;
+}
+
 #ifdef CONFIG_RTL8XXXU_UNTESTED
 
 static int rtl8192cu_parse_efuse(struct rtl8xxxu_priv *priv)
@@ -6142,7 +6187,7 @@ static struct rtl8xxxu_fileops rtl8723au_fops = {
 };
 
 static struct rtl8xxxu_fileops rtl8723bu_fops = {
-	.parse_efuse = rtl8723au_parse_efuse,
+	.parse_efuse = rtl8723bu_parse_efuse,
 	.load_firmware = rtl8723bu_load_firmware,
 	.power_on = rtl8723au_power_on,
 	.llt_init = rtl8xxxu_auto_llt_table,
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
index dd4c563..bf424db 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
@@ -500,6 +500,47 @@ struct rtl8192cu_efuse {
 	u8 customer_id;
 };
 
+struct rtl8723bu_efuse {
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
+	u8 res2[3];
+	u8 rf_board_option;
+	u8 rf_feature_option;
+	u8 rf_bt_setting;
+	u8 eeprom_version;
+	u8 eeprom_customer_id;
+	u8 res3[2];
+	u8 tx_pwr_calibrate_rate;
+	u8 rf_antenna_option;		/* 0xc9 */
+	u8 rfe_option;
+	u8 res4[9];
+	u8 usb_optional_function;
+	u8 res5[0x1e];
+	u8 res6[2];
+	u8 serial[0x0b];		/* 0xf5 */
+	u8 vid;				/* 0x100 */
+	u8 res7;
+	u8 pid;
+	u8 res8[4];
+	u8 mac_addr[ETH_ALEN];		/* 0x107 */
+	u8 res9[2];
+	u8 vendor_name[0x07];
+	u8 res10[2];
+	u8 device_name[0x14];		/* 0xe8 */
+	u8 res11[0xd4];
+};
+
 struct rtl8192eu_efuse {
 	__le16 rtl_id;
 	u8 res0[0x0e];
@@ -690,6 +731,7 @@ struct rtl8xxxu_priv {
 	union {
 		u8 raw[EFUSE_MAP_LEN];
 		struct rtl8723au_efuse efuse8723;
+		struct rtl8723bu_efuse efuse8723bu;
 		struct rtl8192cu_efuse efuse8192;
 		struct rtl8192eu_efuse efuse8192eu;
 	} efuse_wifi;
-- 
2.5.0

