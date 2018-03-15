Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.131]:44115 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752693AbeCOPnT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Mar 2018 11:43:19 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH] Bluetooth: btrsi: rework dependencies
Date: Thu, 15 Mar 2018 16:42:29 +0100
Message-Id: <20180315154312.3941446-1-arnd@arndb.de> (sfid-20180315_164343_924498_11801428)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The linkage between the bluetooth driver and the wireless
driver is not defined properly, leading to build problems
such as:

warning: (BT_HCIRSI) selects RSI_COEX which has unmet direct dependencies (NETDEVICES && WLAN && WLAN_VENDOR_RSI && BT_HCIRSI && RSI_91X)
drivers/net/wireless/rsi/rsi_91x_main.o: In function `rsi_read_pkt':
(.text+0x205): undefined reference to `rsi_bt_ops'

To actually make it work, we need the following steps:

- remove the bogus 'select RSI_COEX', this is already covered
  by the default
- change RSI_COEX to a 'bool' symbol so that the #ifdefs work
  all the time
- ensure that BT_HCIRSI is built-in whenever RSI_91X is built-in
- prevent BT_HCIRSI from being enabled when CONFIG_BT=m and
  RSI_91X=y, as this cannot work

Fixes: 38aa4da50483 ("Bluetooth: btrsi: add new rsi bluetooth driver")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/bluetooth/Kconfig        | 9 ++++++++-
 drivers/bluetooth/Makefile       | 2 +-
 drivers/net/wireless/rsi/Kconfig | 6 +-----
 3 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/bluetooth/Kconfig b/drivers/bluetooth/Kconfig
index d8bbd661dbdb..6b3e8bf69d07 100644
--- a/drivers/bluetooth/Kconfig
+++ b/drivers/bluetooth/Kconfig
@@ -394,8 +394,9 @@ config BT_QCOMSMD
 
 config BT_HCIRSI
 	tristate "Redpine HCI support"
+	depends on RSI_91X
+	depends on !(BT=m && RSI_91X=y)
 	default n
-	select RSI_COEX
 	help
 	  Redpine BT driver.
 	  This driver handles BT traffic from upper layers and pass
@@ -404,4 +405,10 @@ config BT_HCIRSI
 	  Say Y here to compile support for HCI over Redpine into the
 	  kernel or say M to compile as a module.
 
+config BT_HCIRSI_MODULE
+	tristate
+	# ensure that the BT_HCIRSI driver is visible to the core
+	default y if BT_HCIRSI=m && RSI_91X=y
+	default BT_HCIRSI
+
 endmenu
diff --git a/drivers/bluetooth/Makefile b/drivers/bluetooth/Makefile
index 03cfc1b20c4a..9e8d22712ff3 100644
--- a/drivers/bluetooth/Makefile
+++ b/drivers/bluetooth/Makefile
@@ -28,7 +28,7 @@ obj-$(CONFIG_BT_QCA)		+= btqca.o
 
 obj-$(CONFIG_BT_HCIUART_NOKIA)	+= hci_nokia.o
 
-obj-$(CONFIG_BT_HCIRSI)		+= btrsi.o
+obj-$(CONFIG_BT_HCIRSI_MODULE)	+= btrsi.o
 
 btmrvl-y			:= btmrvl_main.o
 btmrvl-$(CONFIG_DEBUG_FS)	+= btmrvl_debugfs.o
diff --git a/drivers/net/wireless/rsi/Kconfig b/drivers/net/wireless/rsi/Kconfig
index f004be33fcfa..bc6195767c61 100644
--- a/drivers/net/wireless/rsi/Kconfig
+++ b/drivers/net/wireless/rsi/Kconfig
@@ -43,12 +43,8 @@ config RSI_USB
 	  Select M (recommended), if you have a RSI 1x1 wireless module.
 
 config RSI_COEX
-	bool "Redpine Signals WLAN BT Coexistence support"
-	depends on BT_HCIRSI && RSI_91X
-	default y
+	def_bool BT_HCIRSI && RSI_91X
 	---help---
 	  This option enables the WLAN BT coex support in rsi drivers.
-	  Select M (recommended), if you have want to use this feature
-	  and you have RS9113 module.
 
 endif # WLAN_VENDOR_RSI
-- 
2.9.0
