Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58325 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757308AbcDGSTe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Apr 2016 14:19:34 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net
Subject: [PATCH 08/18] rtl8xxxu: Correctly parse 8192eu efuse
Date: Thu,  7 Apr 2016 14:19:23 -0400
Message-Id: <1460053173-8494-9-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160407_202528_390844_B3549A58)
In-Reply-To: <1460053173-8494-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1460053173-8494-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

The 8192eu efuse only has power data for path A and B. It follows the
same layout as 8723bu.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 40 ++++++++++++++++++++++++
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h | 38 ++++++++++------------
 2 files changed, 56 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index d6abe27..b5b157f 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -2122,6 +2122,9 @@ static int rtl8723a_channel_to_group(int channel)
 	return group;
 }
 
+/*
+ * Valid for rtl8723bu and rtl8192eu
+ */
 static int rtl8723b_channel_to_group(int channel)
 {
 	int group;
@@ -2987,6 +2990,43 @@ static int rtl8192eu_parse_efuse(struct rtl8xxxu_priv *priv)
 
 	ether_addr_copy(priv->mac_addr, efuse->mac_addr);
 
+	memcpy(priv->cck_tx_power_index_A, efuse->tx_power_index_A.cck_base,
+	       sizeof(efuse->tx_power_index_A.cck_base));
+	memcpy(priv->cck_tx_power_index_B, efuse->tx_power_index_B.cck_base,
+	       sizeof(efuse->tx_power_index_B.cck_base));
+
+	memcpy(priv->ht40_1s_tx_power_index_A,
+	       efuse->tx_power_index_A.ht40_base,
+	       sizeof(efuse->tx_power_index_A.ht40_base));
+	memcpy(priv->ht40_1s_tx_power_index_B,
+	       efuse->tx_power_index_B.ht40_base,
+	       sizeof(efuse->tx_power_index_B.ht40_base));
+
+	priv->ht20_tx_power_diff[0].a =
+		efuse->tx_power_index_A.ht20_ofdm_1s_diff.b;
+	priv->ht20_tx_power_diff[0].b =
+		efuse->tx_power_index_B.ht20_ofdm_1s_diff.b;
+
+	priv->ht40_tx_power_diff[0].a = 0;
+	priv->ht40_tx_power_diff[0].b = 0;
+
+	for (i = 1; i < RTL8723B_TX_COUNT; i++) {
+		priv->ofdm_tx_power_diff[i].a =
+			efuse->tx_power_index_A.pwr_diff[i - 1].ofdm;
+		priv->ofdm_tx_power_diff[i].b =
+			efuse->tx_power_index_B.pwr_diff[i - 1].ofdm;
+
+		priv->ht20_tx_power_diff[i].a =
+			efuse->tx_power_index_A.pwr_diff[i - 1].ht20;
+		priv->ht20_tx_power_diff[i].b =
+			efuse->tx_power_index_B.pwr_diff[i - 1].ht20;
+
+		priv->ht40_tx_power_diff[i].a =
+			efuse->tx_power_index_A.pwr_diff[i - 1].ht40;
+		priv->ht40_tx_power_diff[i].b =
+			efuse->tx_power_index_B.pwr_diff[i - 1].ht40;
+	}
+
 	priv->has_xtalk = 1;
 	priv->xtalk = priv->efuse_wifi.efuse8192eu.xtal_k & 0x3f;
 
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
index 63d7268..48a80fa 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
@@ -788,55 +788,49 @@ struct rtl8192eu_efuse_tx_power {
 	u8 cck_base[6];
 	u8 ht40_base[5];
 	struct rtl8723au_idx ht20_ofdm_1s_diff;
-	struct rtl8723au_idx ht40_ht20_2s_diff;
-	struct rtl8723au_idx ofdm_cck_2s_diff; /* not used */
-	struct rtl8723au_idx ht40_ht20_3s_diff;
-	struct rtl8723au_idx ofdm_cck_3s_diff; /* not used */
-	struct rtl8723au_idx ht40_ht20_4s_diff;
-	struct rtl8723au_idx ofdm_cck_4s_diff; /* not used */
+	struct rtl8723bu_pwr_idx pwr_diff[3];
+	u8 dummy5g[24]; /* max channel group (14) + power diff offset (10) */
 };
 
 struct rtl8192eu_efuse {
 	__le16 rtl_id;
 	u8 res0[0x0e];
 	struct rtl8192eu_efuse_tx_power tx_power_index_A;	/* 0x10 */
-	struct rtl8192eu_efuse_tx_power tx_power_index_B;	/* 0x22 */
-	struct rtl8192eu_efuse_tx_power tx_power_index_C;	/* 0x34 */
-	struct rtl8192eu_efuse_tx_power tx_power_index_D;	/* 0x46 */
-	u8 res1[0x60];
+	struct rtl8192eu_efuse_tx_power tx_power_index_B;	/* 0x3a */
+	u8 res2[0x54];
 	u8 channel_plan;		/* 0xb8 */
 	u8 xtal_k;
 	u8 thermal_meter;
 	u8 iqk_lck;
 	u8 pa_type;			/* 0xbc */
 	u8 lna_type_2g;			/* 0xbd */
-	u8 res2[1];
+	u8 res3[1];
 	u8 lna_type_5g;			/* 0xbf */
-	u8 res13[1];
+	u8 res4[1];
 	u8 rf_board_option;
 	u8 rf_feature_option;
 	u8 rf_bt_setting;
 	u8 eeprom_version;
 	u8 eeprom_customer_id;
-	u8 res3[3];
+	u8 res5[3];
 	u8 rf_antenna_option;		/* 0xc9 */
-	u8 res4[6];
+	u8 res6[6];
 	u8 vid;				/* 0xd0 */
-	u8 res5[1];
+	u8 res7[1];
 	u8 pid;				/* 0xd2 */
-	u8 res6[1];
+	u8 res8[1];
 	u8 usb_optional_function;
-	u8 res7[2];
+	u8 res9[2];
 	u8 mac_addr[ETH_ALEN];		/* 0xd7 */
-	u8 res8[2];
+	u8 res10[2];
 	u8 vendor_name[7];
-	u8 res9[2];
+	u8 res11[2];
 	u8 device_name[0x0b];		/* 0xe8 */
-	u8 res10[2];
+	u8 res12[2];
 	u8 serial[0x0b];		/* 0xf5 */
-	u8 res11[0x30];
+	u8 res13[0x30];
 	u8 unknown[0x0d];		/* 0x130 */
-	u8 res12[0xc3];
+	u8 res14[0xc3];
 };
 
 struct rtl8xxxu_reg8val {
-- 
2.5.5

