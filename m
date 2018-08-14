Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:41367 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727670AbeHNJhX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Aug 2018 05:37:23 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 22/24] staging: wilc1000: move 'chip_ps_state' static variable as part of 'wilc' struct
Date: Tue, 14 Aug 2018 12:20:14 +0530
Message-ID: <1534229416-13254-23-git-send-email-ajay.kathat@microchip.com> (sfid-20180814_091109_529968_597932D5)
In-Reply-To: <1534229416-13254-1-git-send-email-ajay.kathat@microchip.com>
References: <1534229416-13254-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move the static variable as part of 'wilc' priv struct.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/linux_wlan.c         |  1 +
 drivers/staging/wilc1000/wilc_wfi_netdevice.h |  2 ++
 drivers/staging/wilc1000/wilc_wlan.c          | 10 ++++------
 3 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 74f8166..4b99de2 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1062,6 +1062,7 @@ int wilc_netdev_init(struct wilc **wilc, struct device *dev, int io_type,
 	wl->io_type = io_type;
 	wl->hif_func = ops;
 	wl->enable_ps = true;
+	wl->chip_ps_state = CHIP_WAKEDUP;
 	INIT_LIST_HEAD(&wl->txq_head.list);
 	INIT_LIST_HEAD(&wl->rxq_head.list);
 
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index 54ce1ff..9d57adb 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -206,6 +206,8 @@ struct wilc {
 	/* deinitialization lock */
 	struct mutex hif_deinit_lock;
 	struct completion hif_driver_comp;
+
+	enum chip_ps_states chip_ps_state;
 };
 
 struct wilc_wfi_mon_priv {
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index f0743d9..fb8a1e4 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -9,8 +9,6 @@
 #include "wilc_wfi_netdevice.h"
 #include "wilc_wlan_cfg.h"
 
-static enum chip_ps_states chip_ps_state = CHIP_WAKEDUP;
-
 static inline bool is_wilc1000(u32 id)
 {
 	return ((id & 0xfffff000) == 0x100000 ? true : false);
@@ -449,7 +447,7 @@ void chip_wakeup(struct wilc *wilc)
 		} while ((clk_status_reg & 0x1) == 0);
 	}
 
-	if (chip_ps_state == CHIP_SLEEPING_MANUAL) {
+	if (wilc->chip_ps_state == CHIP_SLEEPING_MANUAL) {
 		if (wilc_get_chipid(wilc, false) < 0x1002b0) {
 			u32 val32;
 
@@ -462,19 +460,19 @@ void chip_wakeup(struct wilc *wilc)
 			wilc->hif_func->hif_write_reg(wilc, 0x1e9c, val32);
 		}
 	}
-	chip_ps_state = CHIP_WAKEDUP;
+	wilc->chip_ps_state = CHIP_WAKEDUP;
 }
 
 void wilc_chip_sleep_manually(struct wilc *wilc)
 {
-	if (chip_ps_state != CHIP_WAKEDUP)
+	if (wilc->chip_ps_state != CHIP_WAKEDUP)
 		return;
 	acquire_bus(wilc, ACQUIRE_ONLY);
 
 	chip_allow_sleep(wilc);
 	wilc->hif_func->hif_write_reg(wilc, 0x10a8, 1);
 
-	chip_ps_state = CHIP_SLEEPING_MANUAL;
+	wilc->chip_ps_state = CHIP_SLEEPING_MANUAL;
 	release_bus(wilc, RELEASE_ONLY);
 }
 
-- 
2.7.4
