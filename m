Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([211.75.126.72]:36866 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754899AbeDCHyQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Apr 2018 03:54:16 -0400
From: <pkshih@realtek.com>
To: <kvalo@codeaurora.org>
CC: <Larry.Finger@lwfinger.net>, <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 17/17] rtlwifi: add halmac to Makefile and Kconfig
Date: Tue, 3 Apr 2018 15:53:32 +0800
Message-ID: <20180403075332.3344-18-pkshih@realtek.com> (sfid-20180403_095420_729399_AF72B9FE)
In-Reply-To: <20180403075332.3344-1-pkshih@realtek.com>
References: <20180403075332.3344-1-pkshih@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

Add halmac to Makefile and Kconfig, so we can build this module if 8822BE
is selected.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtlwifi/Kconfig       |  5 ++++
 drivers/net/wireless/realtek/rtlwifi/Makefile      |  1 +
 .../net/wireless/realtek/rtlwifi/halmac/Makefile   | 29 ++++++++++++++++++++++
 3 files changed, 35 insertions(+)
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/Makefile

diff --git a/drivers/net/wireless/realtek/rtlwifi/Kconfig b/drivers/net/wireless/realtek/rtlwifi/Kconfig
index 73067cac289c..d9aba8fed151 100644
--- a/drivers/net/wireless/realtek/rtlwifi/Kconfig
+++ b/drivers/net/wireless/realtek/rtlwifi/Kconfig
@@ -151,4 +151,9 @@ config RTLBTCOEXIST
 	depends on RTL8723AE || RTL8723BE || RTL8821AE || RTL8192EE
 	default y
 
+config RTLHALMAC
+	tristate
+	depends on RTL8822BE
+	default y
+
 endif
diff --git a/drivers/net/wireless/realtek/rtlwifi/Makefile b/drivers/net/wireless/realtek/rtlwifi/Makefile
index 09c30e428375..a30a73c351d8 100644
--- a/drivers/net/wireless/realtek/rtlwifi/Makefile
+++ b/drivers/net/wireless/realtek/rtlwifi/Makefile
@@ -28,6 +28,7 @@ obj-$(CONFIG_RTL8723AE)		+= rtl8723ae/
 obj-$(CONFIG_RTL8723BE)		+= rtl8723be/
 obj-$(CONFIG_RTL8188EE)		+= rtl8188ee/
 obj-$(CONFIG_RTLBTCOEXIST)	+= btcoexist/
+obj-$(CONFIG_RTLHALMAC)		+= halmac/
 obj-$(CONFIG_RTL8723_COMMON)	+= rtl8723com/
 obj-$(CONFIG_RTL8821AE)		+= rtl8821ae/
 obj-$(CONFIG_RTL8192EE)		+= rtl8192ee/
diff --git a/drivers/net/wireless/realtek/rtlwifi/halmac/Makefile b/drivers/net/wireless/realtek/rtlwifi/halmac/Makefile
new file mode 100644
index 000000000000..41c1ae7e5e53
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtlwifi/halmac/Makefile
@@ -0,0 +1,29 @@
+
+
+halmac-objs := \
+	halmac_api.o	\
+	halmac_88xx/halmac_bb_rf_88xx.o	\
+	halmac_88xx/halmac_efuse_88xx.o	\
+	halmac_88xx/halmac_gpio_88xx.o	\
+	halmac_88xx/halmac_pcie_88xx.o	\
+	halmac_88xx/halmac_sdio_88xx.o	\
+	halmac_88xx/halmac_usb_88xx.o	\
+	halmac_88xx/halmac_cfg_wmac_88xx.o	\
+	halmac_88xx/halmac_flash_88xx.o	\
+	halmac_88xx/halmac_init_88xx.o	\
+	halmac_88xx/halmac_common_88xx.o	\
+	halmac_88xx/halmac_fw_88xx.o	\
+	halmac_88xx/halmac_mimo_88xx.o	\
+	halmac_88xx/halmac_8822b/halmac_gpio_8822b.o	\
+	halmac_88xx/halmac_8822b/halmac_pcie_8822b.o	\
+	halmac_88xx/halmac_8822b/halmac_sdio_8822b.o	\
+	halmac_88xx/halmac_8822b/halmac_usb_8822b.o	\
+	halmac_88xx/halmac_8822b/halmac_pwr_seq_8822b.o	\
+	halmac_88xx/halmac_8822b/halmac_common_8822b.o	\
+	halmac_88xx/halmac_8822b/halmac_cfg_wmac_8822b.o	\
+	halmac_88xx/halmac_8822b/halmac_phy_8822b.o	\
+	halmac_88xx/halmac_8822b/halmac_init_8822b.o	\
+	rtl_halmac.o
+
+
+obj-m = halmac.o
-- 
2.15.1
