Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.133]:52893 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751866AbeCOQvE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Mar 2018 12:51:04 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Sebastian Reichel <sre@kernel.org>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH] [v2] Bluetooth: btrsi: rework dependencies
Date: Thu, 15 Mar 2018 17:50:16 +0100
Message-Id: <20180315165050.2211236-1-arnd@arndb.de> (sfid-20180315_175152_182697_E2D1123A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The linkage between the bluetooth driver and the wireless
driver is not defined properly, leading to build problems
such as:

warning: (BT_HCIRSI) selects RSI_COEX which has unmet direct dependencies (NETDEVICES && WLAN && WLAN_VENDOR_RSI && BT_HCIRSI && RSI_91X)
drivers/net/wireless/rsi/rsi_91x_main.o: In function `rsi_read_pkt':
(.text+0x205): undefined reference to `rsi_bt_ops'

As the dependency is actually the reverse (RSI_91X uses
the BT_RSI driver, not the other way round), this changes
the dependency to match, and enables the bluetooth driver
from the RSI_COEX symbol.

Fixes: 38aa4da50483 ("Bluetooth: btrsi: add new rsi bluetooth driver")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
v2: Pick a different from v1
---
 drivers/bluetooth/Kconfig        | 4 +---
 drivers/net/wireless/rsi/Kconfig | 4 +++-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/bluetooth/Kconfig b/drivers/bluetooth/Kconfig
index d8bbd661dbdb..149a38ee1fce 100644
--- a/drivers/bluetooth/Kconfig
+++ b/drivers/bluetooth/Kconfig
@@ -393,9 +393,7 @@ config BT_QCOMSMD
 	  kernel or say M to compile as a module.
 
 config BT_HCIRSI
-	tristate "Redpine HCI support"
-	default n
-	select RSI_COEX
+	tristate
 	help
 	  Redpine BT driver.
 	  This driver handles BT traffic from upper layers and pass
diff --git a/drivers/net/wireless/rsi/Kconfig b/drivers/net/wireless/rsi/Kconfig
index f004be33fcfa..c6006fab8638 100644
--- a/drivers/net/wireless/rsi/Kconfig
+++ b/drivers/net/wireless/rsi/Kconfig
@@ -13,6 +13,7 @@ if WLAN_VENDOR_RSI
 
 config RSI_91X
 	tristate "Redpine Signals Inc 91x WLAN driver support"
+	select BT_RSI if RSI_COEX
 	depends on MAC80211
 	---help---
 	  This option enabes support for RSI 1x1 devices.
@@ -44,7 +45,8 @@ config RSI_USB
 
 config RSI_COEX
 	bool "Redpine Signals WLAN BT Coexistence support"
-	depends on BT_HCIRSI && RSI_91X
+	depends on BT && RSI_91X
+	depends on !(BT=m && RSI_91X=y)
 	default y
 	---help---
 	  This option enables the WLAN BT coex support in rsi drivers.
-- 
2.9.0
