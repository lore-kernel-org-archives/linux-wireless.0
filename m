Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 220-135-115-6.HINET-IP.hinet.net ([220.135.115.6]:59105 "EHLO
        ns.kevlo.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751618AbeCQOhl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 17 Mar 2018 10:37:41 -0400
Date: Sat, 17 Mar 2018 22:26:07 +0800
From: Kevin Lo <kevlo@kevlo.org>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH] rtlwifi: correct comment
Message-ID: <20180317142607.GA11027@ns.kevlo.org> (sfid-20180317_153753_559474_2E6E49E9)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Correct comment.  Set bit 3 and bit 4 of 0x0005 register (REG_APS_FSMCO + 1)
to 0 which means disable WL suspend, not enable WL suspend.

Signed-off-by: Kevin Lo <kevlo@kevlo.org>
---
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/pwrseq.h b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/pwrseq.h
index f2d9c6116e5c..8379a3e5198c 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/pwrseq.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/pwrseq.h
@@ -142,7 +142,7 @@
 	/*wait power state to suspend*/},				\
 	{0x0005, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_ALL_MSK,	\
 	PWR_BASEADDR_MAC, PWR_CMD_WRITE, BIT(3) | BIT(4), 0		\
-	/*0x04[12:11] = 2b'01enable WL suspend*/},
+	/*0x04[12:11] = 2b'00 disable WL suspend*/},
 
 #define RTL8188EE_TRANS_CARDEMU_TO_CARDDIS				\
 	{0x0026, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_ALL_MSK,	\
@@ -179,7 +179,7 @@
 	/*wait power state to suspend*/},				\
 	{0x0005, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_ALL_MSK,	\
 	PWR_BASEADDR_MAC, PWR_CMD_WRITE, BIT(3)|BIT(4), 0		\
-	/*0x04[12:11] = 2b'01enable WL suspend*/},
+	/*0x04[12:11] = 2b'00 disable WL suspend*/},
 
 #define RTL8188EE_TRANS_CARDEMU_TO_PDN					\
 	{0x0006, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_ALL_MSK,	\
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/pwrseq.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/pwrseq.h
index 781eeaa6af49..c570801508cc 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/pwrseq.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/pwrseq.h
@@ -134,7 +134,7 @@
 	/*wait power state to suspend*/					\
 	{0x0086, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_SDIO_MSK,	\
 	 PWR_BASEADDR_SDIO , PWR_CMD_POLLING, BIT(1), BIT(1)},		\
-	/*0x04[12:11] = 2b'01enable WL suspend*/			\
+	/*0x04[12:11] = 2b'00 disable WL suspend*/			\
 	{0x0005, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_ALL_MSK,	\
 	 PWR_BASEADDR_MAC , PWR_CMD_WRITE, BIT(3) | BIT(4), 0},
 
@@ -181,7 +181,7 @@
 	/*Lock small LDO Register*/					\
 	{0x00CC, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_SDIO_MSK,	\
 	 PWR_BASEADDR_MAC , PWR_CMD_WRITE, BIT(2), 0},			\
-	/*0x04[12:11] = 2b'01enable WL suspend*/			\
+	/*0x04[12:11] = 2b'00 disable WL suspend*/			\
 	{0x0005, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_ALL_MSK,	\
 	 PWR_BASEADDR_MAC , PWR_CMD_WRITE, BIT(3) | BIT(4), 0},
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/pwrseq.h b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/pwrseq.h
index 4ac7db526f15..e6c3aac3e9fd 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/pwrseq.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/pwrseq.h
@@ -135,7 +135,7 @@
  /*wait power state to suspend*/ \
 	{0x0086, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_SDIO_MSK,\
 		PWR_BASEADDR_SDIO, PWR_CMD_POLLING, BIT(1), BIT(1)},\
- /*0x04[12:11] = 2b'01enable WL suspend*/ \
+ /*0x04[12:11] = 2b'00 disable WL suspend*/ \
 	{0x0005, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_ALL_MSK,\
 		PWR_BASEADDR_MAC, PWR_CMD_WRITE, BIT(3)|BIT(4), 0},
 
@@ -172,7 +172,7 @@
 	{0x0086, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, \
 		PWR_INTF_SDIO_MSK, PWR_BASEADDR_SDIO,\
 		PWR_CMD_POLLING, BIT(1), BIT(1)},\
- /*0x04[12:11] = 2b'00enable WL suspend*/ \
+ /*0x04[12:11] = 2b'00 disable WL suspend*/ \
 	{0x0005, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, \
 		PWR_INTF_ALL_MSK, PWR_BASEADDR_MAC,\
 		PWR_CMD_WRITE, BIT(3)|BIT(4), 0},\
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/pwrseq.h b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/pwrseq.h
index 0fee5e0e55c2..3367cfbc9502 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/pwrseq.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/pwrseq.h
@@ -204,7 +204,7 @@
 	/*0x23[4] = 1b'0 12H LDO enter normal mode*/			\
 	{0x0023, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_SDIO_MSK,	\
 	 PWR_BASEADDR_MAC, PWR_CMD_WRITE, BIT(4), 0},			\
-	/*0x04[12:11] = 2b'01enable WL suspend*/			\
+	/*0x04[12:11] = 2b'00 disable WL suspend*/			\
 	{0x0005, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_ALL_MSK,	\
 	 PWR_BASEADDR_MAC, PWR_CMD_WRITE, BIT(3)|BIT(4), 0},
 
@@ -251,7 +251,7 @@
 	/*0x48[16] = 0 to disable GPIO9 as EXT WAKEUP*/			\
 	{0x004A, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_USB_MSK,	\
 	 PWR_BASEADDR_MAC, PWR_CMD_WRITE, BIT(0), 0},			\
-	/*0x04[12:11] = 2b'01enable WL suspend*/			\
+	/*0x04[12:11] = 2b'00 disable WL suspend*/			\
 	{0x0005, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_ALL_MSK,	\
 	 PWR_BASEADDR_MAC, PWR_CMD_WRITE, BIT(3)|BIT(4), 0},		\
 	/*0x23[4] = 1b'0 12H LDO enter normal mode*/			\
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/pwrseq.h b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/pwrseq.h
index 36b3e91d996e..6dd575435c63 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/pwrseq.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/pwrseq.h
@@ -531,7 +531,7 @@ extern struct wlan_pwr_cfg  rtl8812_leave_lps_flow
 	 /*0x23[4] = 1b'0 12H LDO enter normal mode*/},   \
 	{0x0005, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_ALL_MSK,\
 	PWR_BASEADDR_MAC, PWR_CMD_WRITE, BIT3|BIT4, 0 \
-	 /*0x04[12:11] = 2b'01enable WL suspend*/},
+	 /*0x04[12:11] = 2b'00 disable WL suspend*/},
 
 #define RTL8821A_TRANS_CARDEMU_TO_CARDDIS				\
 	{0x0007, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_SDIO_MSK,\
@@ -572,7 +572,7 @@ extern struct wlan_pwr_cfg  rtl8812_leave_lps_flow
 	 /*0x48[16] = 0 to disable GPIO9 as EXT WAKEUP*/},   \
 	{0x0005, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_ALL_MSK,\
 	PWR_BASEADDR_MAC, PWR_CMD_WRITE, BIT3|BIT4, 0 \
-	 /*0x04[12:11] = 2b'01enable WL suspend*/},\
+	 /*0x04[12:11] = 2b'00 disable WL suspend*/},\
 	{0x0023, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_SDIO_MSK,\
 	PWR_BASEADDR_MAC, PWR_CMD_WRITE, BIT4, 0 \
 	 /*0x23[4] = 1b'0 12H LDO enter normal mode*/},   \
