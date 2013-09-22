Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f169.google.com ([74.125.82.169]:60765 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752466Ab3IVJHm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Sep 2013 05:07:42 -0400
Received: by mail-we0-f169.google.com with SMTP id t60so2042624wes.0
        for <linux-wireless@vger.kernel.org>; Sun, 22 Sep 2013 02:07:40 -0700 (PDT)
From: Catalin Iacob <iacobcatalin@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Chaoming Li <chaoming_li@realsil.com.cn>,
	linux-wireless@vger.kernel.org,
	Catalin Iacob <iacobcatalin@gmail.com>
Subject: [PATCH] rtlwifi: remove duplicate declarations and macros in headers
Date: Sun, 22 Sep 2013 11:06:26 +0200
Message-Id: <1379840786-4809-1-git-send-email-iacobcatalin@gmail.com> (sfid-20130922_110755_717916_BE6CD03E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch brings no functional change.

There are still duplicate macros across the rtlwifi directory, for example
IQK_DELAY_TIME is defined multiple times, sometimes with different values,
this patch only removes duplicates within the same header file.

Signed-off-by: Catalin Iacob <iacobcatalin@gmail.com>
---
 drivers/net/wireless/rtlwifi/base.h                |  1 -
 drivers/net/wireless/rtlwifi/rtl8192c/phy_common.h |  2 --
 drivers/net/wireless/rtlwifi/rtl8192ce/def.h       |  2 --
 drivers/net/wireless/rtlwifi/rtl8192ce/phy.h       |  3 ---
 drivers/net/wireless/rtlwifi/rtl8192ce/reg.h       | 20 --------------------
 drivers/net/wireless/rtlwifi/rtl8192de/phy.h       |  3 ---
 drivers/net/wireless/rtlwifi/rtl8192se/reg.h       |  5 -----
 drivers/net/wireless/rtlwifi/wifi.h                |  2 --
 8 files changed, 38 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/base.h b/drivers/net/wireless/rtlwifi/base.h
index 0e5fe09..c07f114 100644
--- a/drivers/net/wireless/rtlwifi/base.h
+++ b/drivers/net/wireless/rtlwifi/base.h
@@ -114,7 +114,6 @@ void rtl_init_rfkill(struct ieee80211_hw *hw);
 void rtl_deinit_rfkill(struct ieee80211_hw *hw);
 
 void rtl_beacon_statistic(struct ieee80211_hw *hw, struct sk_buff *skb);
-void rtl_watch_dog_timer_callback(unsigned long data);
 void rtl_deinit_deferred_work(struct ieee80211_hw *hw);
 
 bool rtl_action_proc(struct ieee80211_hw *hw, struct sk_buff *skb, u8 is_tx);
diff --git a/drivers/net/wireless/rtlwifi/rtl8192c/phy_common.h b/drivers/net/wireless/rtlwifi/rtl8192c/phy_common.h
index cec10d6..24957e2 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192c/phy_common.h
+++ b/drivers/net/wireless/rtlwifi/rtl8192c/phy_common.h
@@ -39,9 +39,7 @@
 #define RT_CANNOT_IO(hw)		false
 #define HIGHPOWER_RADIOA_ARRAYLEN	22
 
-#define IQK_ADDA_REG_NUM		16
 #define MAX_TOLERANCE			5
-#define	IQK_DELAY_TIME			1
 
 #define	APK_BB_REG_NUM			5
 #define	APK_AFE_REG_NUM			16
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/def.h b/drivers/net/wireless/rtlwifi/rtl8192ce/def.h
index 3cfa1bb..fa24de4 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/def.h
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/def.h
@@ -152,8 +152,6 @@ enum version_8192c {
 #define IS_VENDOR_UMC_A_CUT(version)	((IS_CHIP_VENDOR_UMC(version)) ? \
 	((GET_CVID_CUT_VERSION(version)) ? false : true) : false)
 #define IS_CHIP_VER_B(version)  ((version & CHIP_VER_B) ? true : false)
-#define IS_VENDOR_UMC_A_CUT(version)	((IS_CHIP_VENDOR_UMC(version)) ? \
-	((GET_CVID_CUT_VERSION(version)) ? false : true) : false)
 #define IS_92C_SERIAL(version)  ((version & CHIP_92C_BITMASK) ? true : false)
 #define IS_CHIP_VENDOR_UMC(version)		\
 	((version & CHIP_VENDOR_UMC) ? true : false)
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/phy.h b/drivers/net/wireless/rtlwifi/rtl8192ce/phy.h
index d5e3b70..80a0893 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/phy.h
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/phy.h
@@ -39,9 +39,7 @@
 #define RT_CANNOT_IO(hw)		false
 #define HIGHPOWER_RADIOA_ARRAYLEN	22
 
-#define IQK_ADDA_REG_NUM		16
 #define MAX_TOLERANCE			5
-#define	IQK_DELAY_TIME			1
 
 #define	APK_BB_REG_NUM			5
 #define	APK_AFE_REG_NUM			16
@@ -226,7 +224,6 @@ bool rtl92c_phy_config_rf_with_headerfile(struct ieee80211_hw *hw,
 					  enum radio_path rfpath);
 bool rtl8192_phy_check_is_legal_rfpath(struct ieee80211_hw *hw,
 					      u32 rfpath);
-bool rtl92c_phy_set_io_cmd(struct ieee80211_hw *hw, enum io_type iotype);
 bool rtl92ce_phy_set_rf_power_state(struct ieee80211_hw *hw,
 					  enum rf_pwrstate rfpwr_state);
 void rtl92ce_phy_set_rf_on(struct ieee80211_hw *hw);
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/reg.h b/drivers/net/wireless/rtlwifi/rtl8192ce/reg.h
index bd4aef7..8922ecb 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/reg.h
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/reg.h
@@ -560,7 +560,6 @@
 #define	EEPROM_DEFAULT_TXPOWERLEVEL		0x22
 #define	EEPROM_DEFAULT_HT40_2SDIFF		0x0
 #define EEPROM_DEFAULT_HT20_DIFF		2
-#define	EEPROM_DEFAULT_LEGACYHTTXPOWERDIFF	0x3
 #define EEPROM_DEFAULT_HT40_PWRMAXOFFSET	0
 #define EEPROM_DEFAULT_HT20_PWRMAXOFFSET	0
 
@@ -639,17 +638,8 @@
 
 #define	EEPROM_TXPWR_GROUP			0x6F
 
-#define EEPROM_TSSI_A				0x76
-#define EEPROM_TSSI_B				0x77
-#define EEPROM_THERMAL_METER			0x78
-
 #define EEPROM_CHANNELPLAN			0x75
 
-#define RF_OPTION1				0x79
-#define RF_OPTION2				0x7A
-#define RF_OPTION3				0x7B
-#define RF_OPTION4				0x7C
-
 #define	STOPBECON				BIT(6)
 #define	STOPHIGHT				BIT(5)
 #define	STOPMGT					BIT(4)
@@ -689,13 +679,6 @@
 #define RSV_CTRL				0x001C
 #define RD_CTRL					0x0524
 
-#define REG_USB_INFO				0xFE17
-#define REG_USB_SPECIAL_OPTION			0xFE55
-
-#define REG_USB_DMA_AGG_TO			0xFE5B
-#define REG_USB_AGG_TO				0xFE5C
-#define REG_USB_AGG_TH				0xFE5D
-
 #define REG_USB_VID				0xFE60
 #define REG_USB_PID				0xFE62
 #define REG_USB_OPTIONAL			0xFE64
@@ -1196,9 +1179,6 @@
 #define POLLING_LLT_THRESHOLD			20
 #define POLLING_READY_TIMEOUT_COUNT		1000
 
-#define	MAX_MSS_DENSITY_2T			0x13
-#define	MAX_MSS_DENSITY_1T			0x0A
-
 #define EPROM_CMD_OPERATING_MODE_MASK	((1<<7)|(1<<6))
 #define EPROM_CMD_CONFIG			0x3
 #define EPROM_CMD_LOAD				1
diff --git a/drivers/net/wireless/rtlwifi/rtl8192de/phy.h b/drivers/net/wireless/rtlwifi/rtl8192de/phy.h
index f074952..a66232e 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192de/phy.h
+++ b/drivers/net/wireless/rtlwifi/rtl8192de/phy.h
@@ -39,9 +39,7 @@
 #define RT_CANNOT_IO(hw)			false
 #define HIGHPOWER_RADIOA_ARRAYLEN		22
 
-#define IQK_ADDA_REG_NUM			16
 #define MAX_TOLERANCE				5
-#define	IQK_DELAY_TIME				1
 
 #define	APK_BB_REG_NUM				5
 #define	APK_AFE_REG_NUM				16
@@ -173,6 +171,5 @@ void rtl92d_acquire_cckandrw_pagea_ctl(struct ieee80211_hw *hw,
 				       unsigned long *flag);
 u8 rtl92d_get_rightchnlplace_for_iqk(u8 chnl);
 void rtl92d_phy_reload_iqk_setting(struct ieee80211_hw *hw, u8 channel);
-void rtl92d_phy_iq_calibrate(struct ieee80211_hw *hw);
 
 #endif
diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/reg.h b/drivers/net/wireless/rtlwifi/rtl8192se/reg.h
index 84d1181..c81c835 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192se/reg.h
+++ b/drivers/net/wireless/rtlwifi/rtl8192se/reg.h
@@ -425,14 +425,9 @@
 #define	EXT_IMEM_CODE_DONE			BIT(2)
 #define	IMEM_CHK_RPT				BIT(1)
 #define	IMEM_CODE_DONE				BIT(0)
-#define	IMEM_CODE_DONE				BIT(0)
-#define	IMEM_CHK_RPT				BIT(1)
 #define	EMEM_CODE_DONE				BIT(2)
 #define	EMEM_CHK_RPT				BIT(3)
-#define	DMEM_CODE_DONE				BIT(4)
 #define	IMEM_RDY				BIT(5)
-#define	BASECHG					BIT(6)
-#define	FWRDY					BIT(7)
 #define	LOAD_FW_READY				(IMEM_CODE_DONE | \
 						IMEM_CHK_RPT | \
 						EMEM_CODE_DONE | \
diff --git a/drivers/net/wireless/rtlwifi/wifi.h b/drivers/net/wireless/rtlwifi/wifi.h
index cc03e7c..96763dc 100644
--- a/drivers/net/wireless/rtlwifi/wifi.h
+++ b/drivers/net/wireless/rtlwifi/wifi.h
@@ -192,8 +192,6 @@ enum hardware_type {
 (IS_HARDWARE_TYPE_8192DE(rtlhal) || IS_HARDWARE_TYPE_8192DU(rtlhal))
 #define	IS_HARDWARE_TYPE_8723(rtlhal)			\
 (IS_HARDWARE_TYPE_8723E(rtlhal) || IS_HARDWARE_TYPE_8723U(rtlhal))
-#define IS_HARDWARE_TYPE_8723U(rtlhal)			\
-	(rtlhal->hw_type == HARDWARE_TYPE_RTL8723U)
 
 #define RX_HAL_IS_CCK_RATE(_pdesc)\
 	(_pdesc->rxmcs == DESC92_RATE1M ||		\
-- 
1.8.3.1

