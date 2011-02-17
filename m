Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:42497 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758045Ab1BQVSM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Feb 2011 16:18:12 -0500
Date: Thu, 17 Feb 2011 15:18:10 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: george0505@realtek.com, chaoming_li@realsil.com.cn,
	linux-wireless@vger.kernel.org
Subject: [PATCH 2/14] rtlwifi: Make changes in rtlwifi/rtl8192ce/def.h to
 support rtl8192cu
Message-ID: <4d5d9092.1V0vnWMrMHmaQ/0o%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This change modifies rtlwifi/rtl8192ce/def.h to handle rtl8192cu. In
addition, a couple of routines needed for both drivers are converted
to be inline.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/def.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192ce/def.h
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/def.h
@@ -121,11 +121,37 @@
 #define CHIP_92C			0x01
 #define CHIP_88C			0x00
 
+/* Add vendor information into chip version definition.
+ * Add UMC B-Cut and RTL8723 chip info definition.
+ *
+ * BIT 7	Reserved
+ * BIT 6	UMC BCut
+ * BIT 5	Manufacturer(TSMC/UMC)
+ * BIT 4	TEST/NORMAL
+ * BIT 3	8723 Version
+ * BIT 2	8723?
+ * BIT 1	1T2R?
+ * BIT 0	88C/92C
+*/
+
 enum version_8192c {
 	VERSION_A_CHIP_92C = 0x01,
 	VERSION_A_CHIP_88C = 0x00,
 	VERSION_B_CHIP_92C = 0x11,
 	VERSION_B_CHIP_88C = 0x10,
+	VERSION_TEST_CHIP_88C = 0x00,
+	VERSION_TEST_CHIP_92C = 0x01,
+	VERSION_NORMAL_TSMC_CHIP_88C = 0x10,
+	VERSION_NORMAL_TSMC_CHIP_92C = 0x11,
+	VERSION_NORMAL_TSMC_CHIP_92C_1T2R = 0x13,
+	VERSION_NORMAL_UMC_CHIP_88C_A_CUT = 0x30,
+	VERSION_NORMAL_UMC_CHIP_92C_A_CUT = 0x31,
+	VERSION_NORMAL_UMC_CHIP_92C_1T2R_A_CUT = 0x33,
+	VERSION_NORMA_UMC_CHIP_8723_1T1R_A_CUT = 0x34,
+	VERSION_NORMA_UMC_CHIP_8723_1T1R_B_CUT = 0x3c,
+	VERSION_NORMAL_UMC_CHIP_88C_B_CUT = 0x70,
+	VERSION_NORMAL_UMC_CHIP_92C_B_CUT = 0x71,
+	VERSION_NORMAL_UMC_CHIP_92C_1T2R_B_CUT = 0x73,
 	VERSION_UNKNOWN = 0x88,
 };
 
@@ -254,4 +280,122 @@ struct h2c_cmd_8192c {
 	u8 *p_cmdbuffer;
 };
 
+static inline u8 _rtl92c_get_chnl_group(u8 chnl)
+{
+	u8 group = 0;
+
+	if (chnl < 3)
+		group = 0;
+	else if (chnl < 9)
+		group = 1;
+	else
+		group = 2;
+
+	return group;
+}
+
+/* NOTE: reference to rtl8192c_rates struct */
+static inline int _rtl92c_rate_mapping(struct ieee80211_hw *hw, bool isHT,
+				       u8 desc_rate, bool first_ampdu)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	int rate_idx = 0;
+
+	if (first_ampdu) {
+		if (false == isHT) {
+			switch (desc_rate) {
+			case DESC92C_RATE1M:
+				rate_idx = 0;
+				break;
+			case DESC92C_RATE2M:
+				rate_idx = 1;
+				break;
+			case DESC92C_RATE5_5M:
+				rate_idx = 2;
+				break;
+			case DESC92C_RATE11M:
+				rate_idx = 3;
+				break;
+			case DESC92C_RATE6M:
+				rate_idx = 4;
+				break;
+			case DESC92C_RATE9M:
+				rate_idx = 5;
+				break;
+			case DESC92C_RATE12M:
+				rate_idx = 6;
+				break;
+			case DESC92C_RATE18M:
+				rate_idx = 7;
+				break;
+			case DESC92C_RATE24M:
+				rate_idx = 8;
+				break;
+			case DESC92C_RATE36M:
+				rate_idx = 9;
+				break;
+			case DESC92C_RATE48M:
+				rate_idx = 10;
+				break;
+			case DESC92C_RATE54M:
+				rate_idx = 11;
+				break;
+			default:
+				RT_TRACE(rtlpriv, COMP_ERR, DBG_DMESG,
+					 ("Rate %d is not support, set to "
+					"1M rate.\n", desc_rate));
+				rate_idx = 0;
+				break;
+			}
+		} else {
+			rate_idx = 11;
+		}
+		return rate_idx;
+	}
+	switch (desc_rate) {
+	case DESC92C_RATE1M:
+		rate_idx = 0;
+		break;
+	case DESC92C_RATE2M:
+		rate_idx = 1;
+		break;
+	case DESC92C_RATE5_5M:
+		rate_idx = 2;
+		break;
+	case DESC92C_RATE11M:
+		rate_idx = 3;
+		break;
+	case DESC92C_RATE6M:
+		rate_idx = 4;
+		break;
+	case DESC92C_RATE9M:
+		rate_idx = 5;
+		break;
+	case DESC92C_RATE12M:
+		rate_idx = 6;
+		break;
+	case DESC92C_RATE18M:
+		rate_idx = 7;
+		break;
+	case DESC92C_RATE24M:
+		rate_idx = 8;
+		break;
+	case DESC92C_RATE36M:
+		rate_idx = 9;
+		break;
+	case DESC92C_RATE48M:
+		rate_idx = 10;
+		break;
+	case DESC92C_RATE54M:
+		rate_idx = 11;
+		break;
+	/* TODO: How to mapping MCS rate? */
+	/*  NOTE: referenc to __ieee80211_rx */
+	default:
+		rate_idx = 11;
+		break;
+	}
+	return rate_idx;
+}
+
 #endif
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
@@ -1335,19 +1335,6 @@ void rtl92ce_update_interrupt_mask(struc
 	rtl92ce_enable_interrupt(hw);
 }
 
-static u8 _rtl92c_get_chnl_group(u8 chnl)
-{
-	u8 group;
-
-	if (chnl < 3)
-		group = 0;
-	else if (chnl < 9)
-		group = 1;
-	else
-		group = 2;
-	return group;
-}
-
 static void _rtl92ce_read_txpower_info_from_hwpg(struct ieee80211_hw *hw,
 						 bool autoload_fail,
 						 u8 *hwinfo)
