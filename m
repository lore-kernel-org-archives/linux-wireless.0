Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54135 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753086Ab1DJLGN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Apr 2011 07:06:13 -0400
Received: by iyb14 with SMTP id 14so4749615iyb.19
        for <linux-wireless@vger.kernel.org>; Sun, 10 Apr 2011 04:06:13 -0700 (PDT)
From: Robin Dong <hao.bigrat@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Robin Dong <sanbai@taobao.com>
Subject: [PATCH] fix iwl3945 tx power setting in iwl3945_init_drv
Date: Sun, 10 Apr 2011 19:06:02 +0800
Message-Id: <1302433562-4078-1-git-send-email-hao.bigrat@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Robin Dong <sanbai@taobao.com>

When I build and run the kernel-2.6.39-rc2 on my laptop, my intel-3945-a/b/g wireless
card will not work and the dmesg is:

[   58.597834] iwl3945 0000:03:00.0: Requested user TXPOWER 15 above upper limit 14.
[   58.597839] iwl3945 0000:03:00.0: Error setting Tx power (-22).
[   58.598276] iwl3945 0000:03:00.0: Requested user TXPOWER 15 above upper limit 14.
[   58.598279] iwl3945 0000:03:00.0: Error setting Tx power (-22).
[   94.064147] iwl3945 0000:03:00.0: Requested user TXPOWER 15 above upper limit 14.
[   94.064152] iwl3945 0000:03:00.0: Error setting Tx power (-22).
[   94.064529] iwl3945 0000:03:00.0: Requested user TXPOWER 15 above upper limit 14.
[   94.064533] iwl3945 0000:03:00.0: Error setting Tx power (-22).
[  133.892160] sky2 0000:02:00.0: eth1: disabling interface
[  473.313935] sky2 0000:02:00.0: eth1: enabling interface
[  473.314238] ADDRCONF(NETDEV_UP): eth1: link is not ready
[  473.383740] iwl3945 0000:03:00.0: Requested user TXPOWER 15 above upper limit 14.
[  473.383748] iwl3945 0000:03:00.0: Error setting Tx power (-22).
[  473.384146] iwl3945 0000:03:00.0: Requested user TXPOWER 15 above upper limit 14.
[  473.384153] iwl3945 0000:03:00.0: Error setting Tx power (-22).
[  473.455655] iwl3945 0000:03:00.0: Requested user TXPOWER 15 above upper limit 14.
[  473.455663] iwl3945 0000:03:00.0: Error setting Tx power (-22).
[  473.456128] iwl3945 0000:03:00.0: Requested user TXPOWER 15 above upper limit 14.
[  473.456134] iwl3945 0000:03:00.0: Error setting Tx power (-22).

It is weird the iwl3945 set txpower 15 above limit 14.
So I checked iwl4965 and iwl3945 driver and found out it will set 
tx_power_next to 0 in "iwl4965_init_drv" but to 15 in "iwl3945_init_drv"
I change tx_power_next=0 in "iwl3945_init_drv", and my wireless card works.

Signed-off-by: Robin Dong <sanbai@taobao.com>
---
 drivers/net/wireless/iwlegacy/iwl-3945-hw.h  |    2 +-
 drivers/net/wireless/iwlegacy/iwl3945-base.c |    4 ++-- 2 files changed, 3 insertions(+), 3 deletions(-) diff --git a/drivers/net/wireless/iwlegacy/iwl-3945-hw.h b/drivers/net/wireless/iwlegacy/iwl-3945-hw.h index 779d3cb..21438ee 100644
--- a/drivers/net/wireless/iwlegacy/iwl-3945-hw.h
+++ b/drivers/net/wireless/iwlegacy/iwl-3945-hw.h
@@ -74,7 +74,7 @@
 /* RSSI to dBm */
 #define IWL39_RSSI_OFFSET	95
 
-#define IWL_DEFAULT_TX_POWER	0x0F
+#define IWL3945_TX_POWER_TARGET_POWER_MIN	(0)
 
 /*
  * EEPROM related constants, enums, and structures.
diff --git a/drivers/net/wireless/iwlegacy/iwl3945-base.c b/drivers/net/wireless/iwlegacy/iwl3945-base.c
index 28eb3d8..91ed03b 100644
--- a/drivers/net/wireless/iwlegacy/iwl3945-base.c
+++ b/drivers/net/wireless/iwlegacy/iwl3945-base.c
@@ -3826,8 +3826,8 @@ static int iwl3945_init_drv(struct iwl_priv *priv)
 		IWL_DELAY_NEXT_FORCE_FW_RELOAD;
 
 
-	priv->tx_power_user_lmt = IWL_DEFAULT_TX_POWER;
-	priv->tx_power_next = IWL_DEFAULT_TX_POWER;
+	priv->tx_power_user_lmt = IWL3945_TX_POWER_TARGET_POWER_MIN;
+	priv->tx_power_next = IWL3945_TX_POWER_TARGET_POWER_MIN;
 
 	if (eeprom->version < EEPROM_3945_EEPROM_VERSION) {
 		IWL_WARN(priv, "Unsupported EEPROM version: 0x%04X\n",
-- 
1.7.1

