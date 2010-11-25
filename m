Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from phoenix3.szarvasnet.hu ([87.101.127.16]:59508 "EHLO
	phoenix3.szarvasnet.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753103Ab0KYRg7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Nov 2010 12:36:59 -0500
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Vivek Natarajan <vnatarajan@atheros.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH] ath9k: use per-device struct for pm_qos_* operations
Date: Thu, 25 Nov 2010 18:26:07 +0100
Message-Id: <1290705967-21129-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The ath9k driver uses a shared pm_qos_request_list structure for all
devices. This causes the following warning if more than one device is
present in the system:

WARNING: at kernel/pm_qos_params.c:234 ath9k_init_device+0x5e8/0x6b0()
pm_qos_add_request() called for already added request
Modules linked in:
Call Trace:
[<802b1cdc>] dump_stack+0x8/0x34
[<8007dd90>] warn_slowpath_common+0x78/0xa4
[<8007de44>] warn_slowpath_fmt+0x2c/0x38
[<801b0828>] ath9k_init_device+0x5e8/0x6b0
[<801bc508>] ath_pci_probe+0x2dc/0x39c
[<80176254>] pci_device_probe+0x64/0xa4
[<8019471c>] driver_probe_device+0xbc/0x188
[<80194854>] __driver_attach+0x6c/0xa4
[<80193e20>] bus_for_each_dev+0x60/0xb0
[<80193580>] bus_add_driver+0xcc/0x268
[<80194c08>] driver_register+0xe0/0x198
[<801764e0>] __pci_register_driver+0x50/0xe0
[<80365f48>] ath9k_init+0x3c/0x6c
[<8006050c>] do_one_initcall+0xfc/0x1d8
[<80355340>] kernel_init+0xd4/0x174
[<800639a4>] kernel_thread_helper+0x10/0x18

---[ end trace 5345fc6f870564a6 ]---

This patch fixes that warning by using a separate pm_qos_request_list
sructure for each device.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    4 +++-
 drivers/net/wireless/ath/ath9k/init.c  |    7 ++-----
 drivers/net/wireless/ath/ath9k/main.c  |    5 ++---
 3 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 6f90acc..0b4b470 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -21,6 +21,7 @@
 #include <linux/device.h>
 #include <linux/leds.h>
 #include <linux/completion.h>
+#include <linux/pm_qos_params.h>
 
 #include "debug.h"
 #include "common.h"
@@ -628,6 +629,8 @@ struct ath_softc {
 	struct ath_descdma txsdma;
 
 	struct ath_ant_comb ant_comb;
+
+	struct pm_qos_request_list pm_qos_req;
 };
 
 struct ath_wiphy {
@@ -657,7 +660,6 @@ static inline void ath_read_cachesize(struct ath_common *common, int *csz)
 }
 
 extern struct ieee80211_ops ath9k_ops;
-extern struct pm_qos_request_list ath9k_pm_qos_req;
 extern int modparam_nohwcrypt;
 extern int led_blink;
 
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 7eef1fa..edb1fdf 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -15,7 +15,6 @@
  */
 
 #include <linux/slab.h>
-#include <linux/pm_qos_params.h>
 
 #include "ath9k.h"
 
@@ -180,8 +179,6 @@ static const struct ath_ops ath9k_common_ops = {
 	.write = ath9k_iowrite32,
 };
 
-struct pm_qos_request_list ath9k_pm_qos_req;
-
 /**************************/
 /*     Initialization     */
 /**************************/
@@ -756,7 +753,7 @@ int ath9k_init_device(u16 devid, struct ath_softc *sc, u16 subsysid,
 	ath_init_leds(sc);
 	ath_start_rfkill_poll(sc);
 
-	pm_qos_add_request(&ath9k_pm_qos_req, PM_QOS_CPU_DMA_LATENCY,
+	pm_qos_add_request(&sc->pm_qos_req, PM_QOS_CPU_DMA_LATENCY,
 			   PM_QOS_DEFAULT_VALUE);
 
 	return 0;
@@ -827,7 +824,7 @@ void ath9k_deinit_device(struct ath_softc *sc)
 	}
 
 	ieee80211_unregister_hw(hw);
-	pm_qos_remove_request(&ath9k_pm_qos_req);
+	pm_qos_remove_request(&sc->pm_qos_req);
 	ath_rx_cleanup(sc);
 	ath_tx_cleanup(sc);
 	ath9k_deinit_softc(sc);
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 50bdb5d..3bada71 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -15,7 +15,6 @@
  */
 
 #include <linux/nl80211.h>
-#include <linux/pm_qos_params.h>
 #include "ath9k.h"
 #include "btcoex.h"
 
@@ -1184,7 +1183,7 @@ static int ath9k_start(struct ieee80211_hw *hw)
 			ath9k_btcoex_timer_resume(sc);
 	}
 
-	pm_qos_update_request(&ath9k_pm_qos_req, 55);
+	pm_qos_update_request(&sc->pm_qos_req, 55);
 
 mutex_unlock:
 	mutex_unlock(&sc->mutex);
@@ -1339,7 +1338,7 @@ static void ath9k_stop(struct ieee80211_hw *hw)
 
 	sc->sc_flags |= SC_OP_INVALID;
 
-	pm_qos_update_request(&ath9k_pm_qos_req, PM_QOS_DEFAULT_VALUE);
+	pm_qos_update_request(&sc->pm_qos_req, PM_QOS_DEFAULT_VALUE);
 
 	mutex_unlock(&sc->mutex);
 
-- 
1.7.2.1

