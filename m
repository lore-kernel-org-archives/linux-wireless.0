Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:20138 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751339AbeEBHPr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 2 May 2018 03:15:47 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 17/21] staging: wilc1000: remove unnecessary header file inclusion for wilc
Date: Wed, 2 May 2018 12:43:43 +0530
Message-ID: <1525245227-3924-18-git-send-email-ajay.kathat@microchip.com> (sfid-20180502_093236_544372_C04E17FC)
In-Reply-To: <1525245227-3924-1-git-send-email-ajay.kathat@microchip.com>
References: <1525245227-3924-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove the unnecessary file inclusion in the source code. Also follow
the convension to first include the system header then project specific
header files.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/coreconfigurator.c       |  5 +----
 drivers/staging/wilc1000/host_interface.c         | 14 --------------
 drivers/staging/wilc1000/linux_mon.c              |  2 --
 drivers/staging/wilc1000/linux_wlan.c             | 20 ++------------------
 drivers/staging/wilc1000/wilc_debugfs.c           |  2 --
 drivers/staging/wilc1000/wilc_sdio.c              | 10 ++--------
 drivers/staging/wilc1000/wilc_spi.c               | 12 ------------
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c |  2 --
 drivers/staging/wilc1000/wilc_wfi_netdevice.h     | 21 +--------------------
 drivers/staging/wilc1000/wilc_wlan.c              |  3 ---
 drivers/staging/wilc1000/wilc_wlan_cfg.c          |  1 -
 11 files changed, 6 insertions(+), 86 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index 43b0b21..9f9ca76 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -1,9 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 #include "coreconfigurator.h"
-#include "wilc_wlan_if.h"
-#include "wilc_wlan.h"
-#include <linux/errno.h>
-#include <linux/slab.h>
+
 #define TAG_PARAM_OFFSET	(MAC_HDR_LEN + TIME_STAMP_LEN + \
 				 BEACON_INTERVAL_LEN + CAP_INFO_LEN)
 
diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 52d3a2c..c647cea 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1,18 +1,4 @@
 // SPDX-License-Identifier: GPL-2.0
-#include <linux/slab.h>
-#include <linux/time.h>
-#include <linux/kthread.h>
-#include <linux/delay.h>
-#include <linux/completion.h>
-#include <linux/list.h>
-#include <linux/workqueue.h>
-#include "host_interface.h"
-#include <linux/spinlock.h>
-#include <linux/errno.h>
-#include "coreconfigurator.h"
-#include "wilc_wlan.h"
-#include "wilc_wlan_if.h"
-#include <linux/etherdevice.h>
 #include "wilc_wfi_netdevice.h"
 
 #define HOST_IF_MSG_SCAN                        0
diff --git a/drivers/staging/wilc1000/linux_mon.c b/drivers/staging/wilc1000/linux_mon.c
index a08ee9c..a659110 100644
--- a/drivers/staging/wilc1000/linux_mon.c
+++ b/drivers/staging/wilc1000/linux_mon.c
@@ -1,7 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
 #include "wilc_wfi_cfgoperations.h"
-#include "wilc_wlan_if.h"
-#include "wilc_wlan.h"
 
 struct wilc_wfi_radiotap_hdr {
 	struct ieee80211_radiotap_header hdr;
diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 4208548..7b883c0 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1,28 +1,12 @@
 // SPDX-License-Identifier: GPL-2.0
-#include "wilc_wfi_cfgoperations.h"
-#include "wilc_wlan_if.h"
-#include "wilc_wlan.h"
-
-#include <linux/slab.h>
-#include <linux/sched.h>
-#include <linux/delay.h>
-#include <linux/workqueue.h>
-#include <linux/interrupt.h>
 #include <linux/irq.h>
 #include <linux/gpio.h>
-
 #include <linux/kthread.h>
 #include <linux/firmware.h>
-
-#include <linux/init.h>
 #include <linux/netdevice.h>
 #include <linux/inetdevice.h>
-#include <linux/etherdevice.h>
-#include <linux/module.h>
-#include <linux/kernel.h>
-#include <linux/skbuff.h>
-#include <linux/mutex.h>
-#include <linux/completion.h>
+
+#include "wilc_wfi_cfgoperations.h"
 
 bool wilc_enable_ps = true;
 
diff --git a/drivers/staging/wilc1000/wilc_debugfs.c b/drivers/staging/wilc1000/wilc_debugfs.c
index 0deb61a..287c11b 100644
--- a/drivers/staging/wilc1000/wilc_debugfs.c
+++ b/drivers/staging/wilc1000/wilc_debugfs.c
@@ -13,8 +13,6 @@
 #if defined(WILC_DEBUGFS)
 #include <linux/module.h>
 #include <linux/debugfs.h>
-#include <linux/poll.h>
-#include <linux/sched.h>
 
 #include "wilc_wlan_if.h"
 
diff --git a/drivers/staging/wilc1000/wilc_sdio.c b/drivers/staging/wilc1000/wilc_sdio.c
index 54121c3..211be73 100644
--- a/drivers/staging/wilc1000/wilc_sdio.c
+++ b/drivers/staging/wilc1000/wilc_sdio.c
@@ -5,17 +5,11 @@
  * Module Name:  wilc_sdio.c
  */
 
-#include <linux/string.h>
-#include "wilc_wlan_if.h"
-#include "wilc_wlan.h"
-#include "wilc_wfi_netdevice.h"
 #include <linux/mmc/sdio_func.h>
-#include <linux/mmc/card.h>
-#include <linux/mmc/sdio_ids.h>
-#include <linux/mmc/sdio.h>
-#include <linux/mmc/host.h>
 #include <linux/of_gpio.h>
 
+#include "wilc_wfi_netdevice.h"
+
 #define SDIO_MODALIAS "wilc1000_sdio"
 
 #define SDIO_VENDOR_ID_WILC 0x0296
diff --git a/drivers/staging/wilc1000/wilc_spi.c b/drivers/staging/wilc1000/wilc_spi.c
index 1f2dde1..6475263 100644
--- a/drivers/staging/wilc1000/wilc_spi.c
+++ b/drivers/staging/wilc1000/wilc_spi.c
@@ -5,21 +5,9 @@
  * Module Name:  wilc_spi.c
  */
 
-#include <linux/module.h>
-#include <linux/init.h>
-#include <linux/kernel.h>
-#include <linux/fs.h>
-#include <linux/slab.h>
-#include <linux/types.h>
-#include <linux/cdev.h>
-#include <linux/uaccess.h>
-#include <linux/device.h>
 #include <linux/spi/spi.h>
 #include <linux/of_gpio.h>
 
-#include <linux/string.h>
-#include "wilc_wlan_if.h"
-#include "wilc_wlan.h"
 #include "wilc_wfi_netdevice.h"
 
 struct wilc_spi {
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 579e04a2..5e7bb1f 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -1,7 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
 #include "wilc_wfi_cfgoperations.h"
-#include "host_interface.h"
-#include <linux/errno.h>
 
 #define NO_ENCRYPT		0
 #define ENCRYPT_ENABLED		BIT(0)
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index 5448c6b..01cb9ac 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -7,33 +7,14 @@
 #define PMKID_FOUND 1
  #define NUM_STA_ASSOCIATED 8
 
-#include <linux/module.h>
-#include <linux/init.h>
-#include <linux/moduleparam.h>
-#include <linux/sched.h>
-#include <linux/kernel.h>
-#include <linux/slab.h>
-#include <linux/errno.h>
-#include <linux/types.h>
-#include <linux/interrupt.h>
-#include <linux/time.h>
-#include <linux/in.h>
-#include <linux/netdevice.h>
-#include <linux/etherdevice.h>
-#include <linux/ip.h>
 #include <linux/tcp.h>
-#include <linux/skbuff.h>
 #include <linux/ieee80211.h>
 #include <net/cfg80211.h>
 #include <net/ieee80211_radiotap.h>
 #include <linux/if_arp.h>
-#include <linux/in6.h>
-#include <asm/checksum.h>
+
 #include "host_interface.h"
 #include "wilc_wlan.h"
-#include <linux/wireless.h>
-#include <linux/completion.h>
-#include <linux/mutex.h>
 
 #define FLOW_CONTROL_LOWER_THRESHOLD	128
 #define FLOW_CONTROL_UPPER_THRESHOLD	256
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 43cf9b8..7147e0c 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -1,7 +1,4 @@
 // SPDX-License-Identifier: GPL-2.0
-#include <linux/completion.h>
-#include "wilc_wlan_if.h"
-#include "wilc_wlan.h"
 #include "wilc_wfi_netdevice.h"
 #include "wilc_wlan_cfg.h"
 
diff --git a/drivers/staging/wilc1000/wilc_wlan_cfg.c b/drivers/staging/wilc1000/wilc_wlan_cfg.c
index 2b44f4c..c0b9b70 100644
--- a/drivers/staging/wilc1000/wilc_wlan_cfg.c
+++ b/drivers/staging/wilc1000/wilc_wlan_cfg.c
@@ -8,7 +8,6 @@
 /*  */
 /* ///////////////////////////////////////////////////////////////////////// */
 
-#include <linux/string.h>
 #include "wilc_wlan_if.h"
 #include "wilc_wlan.h"
 #include "wilc_wlan_cfg.h"
-- 
2.7.4
