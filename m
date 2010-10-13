Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:53672 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753104Ab0JMLDY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Oct 2010 07:03:24 -0400
From: csanjay@mistralsolutions.com
To: linux-omap@vger.kernel.org
Cc: linux-wireless@vger.kernel.org,
	Sanjay Kumar Champati <csanjay@mistralsolutions.com>
Subject: [WL1271 DC supprot on OMAP3EVM 5/5] Supported BT and WLAN configuration for WL1271 over the OMAP37XX
Date: Wed, 13 Oct 2010 16:21:17 +0530
Message-Id: <1286967077-20071-6-git-send-email-csanjay@mistralsolutions.com>
In-Reply-To: <1286967077-20071-1-git-send-email-csanjay@mistralsolutions.com>
References: <1286967077-20071-1-git-send-email-csanjay@mistralsolutions.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sanjay Kumar Champati <csanjay@mistralsolutions.com>

* Modified the "omap3_evm_defconfig" file to support WLAN and BT configuration for WL1271

Signed-off-by: Sanjay Kumar Champati <csanjay@mistralsolutions.com>
---
 arch/arm/configs/omap3_evm_defconfig |   27 ++++++++++++++++++++++++---
 1 files changed, 24 insertions(+), 3 deletions(-)

diff --git a/arch/arm/configs/omap3_evm_defconfig b/arch/arm/configs/omap3_evm_defconfig
index a18b22e..676cd99 100644
--- a/arch/arm/configs/omap3_evm_defconfig
+++ b/arch/arm/configs/omap3_evm_defconfig
@@ -1,7 +1,7 @@
 #
 # Automatically generated make config: don't edit
 # Linux kernel version: 2.6.32
-# Tue Jan  5 13:03:54 2010
+# Sun Oct 10 05:00:18 2010
 #
 CONFIG_ARM=y
 CONFIG_SYS_SUPPORTS_APM_EMULATION=y
@@ -492,10 +492,29 @@ CONFIG_DEFAULT_TCP_CONG="cubic"
 # CONFIG_HAMRADIO is not set
 # CONFIG_CAN is not set
 # CONFIG_IRDA is not set
-# CONFIG_BT is not set
+CONFIG_BT=y
+CONFIG_BT_L2CAP=y
+CONFIG_BT_SCO=y
+CONFIG_BT_RFCOMM=y
+CONFIG_BT_RFCOMM_TTY=y
+
+#
+# Bluetooth device drivers
+#
+CONFIG_BT_HCIUART=y
+CONFIG_BT_HCIUART_H4=y
+CONFIG_BT_HCIUART_BCSP=y
+CONFIG_BT_HCIUART_LL=y
+CONFIG_BT_WL1271=y
 # CONFIG_AF_RXRPC is not set
 CONFIG_WIRELESS=y
+CONFIG_WIRELESS_EXT=y
+CONFIG_WEXT_CORE=y
+CONFIG_WEXT_PROC=y
+CONFIG_WEXT_SPY=y
+CONFIG_WEXT_PRIV=y
 # CONFIG_CFG80211 is not set
+CONFIG_WIRELESS_EXT_SYSFS=y
 # CONFIG_LIB80211 is not set
 
 #
@@ -740,6 +759,7 @@ CONFIG_SMSC911X=y
 # CONFIG_NETDEV_1000 is not set
 # CONFIG_NETDEV_10000 is not set
 CONFIG_WLAN=y
+CONFIG_WL1271_WLAN=y
 # CONFIG_USB_ZD1201 is not set
 # CONFIG_HOSTAP is not set
 
@@ -1302,6 +1322,7 @@ CONFIG_SND_SOC=y
 CONFIG_SND_OMAP_SOC=y
 CONFIG_SND_OMAP_SOC_MCBSP=y
 CONFIG_SND_OMAP_SOC_OMAP3EVM=y
+CONFIG_SND_OMAP_SOC_WL1271BT=y
 CONFIG_SND_SOC_I2C_AND_SPI=y
 # CONFIG_SND_SOC_ALL_CODECS is not set
 CONFIG_SND_SOC_TWL4030=y
@@ -2004,7 +2025,7 @@ CONFIG_CRYPTO_HW=y
 CONFIG_BITREVERSE=y
 CONFIG_GENERIC_FIND_LAST_BIT=y
 CONFIG_CRC_CCITT=y
-# CONFIG_CRC16 is not set
+CONFIG_CRC16=y
 # CONFIG_CRC_T10DIF is not set
 # CONFIG_CRC_ITU_T is not set
 CONFIG_CRC32=y
-- 
1.6.3.3

