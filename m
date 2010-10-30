Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:53537 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754801Ab0J3Qfa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Oct 2010 12:35:30 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sat, 30 Oct 2010 09:35:19 -0700
From: Vivek Natarajan <vnatarajan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH] ath9k: Fix a DMA latency issue for Intel Pinetrail platforms.
Date: Sat, 30 Oct 2010 22:05:13 +0530
Message-ID: <1288456513-2617-1-git-send-email-vnatarajan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Throughput was severely affected in Intel Pinetrail platforms
because of a DMA problem in C3 state. This patch fixes this
issue.

Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
CC: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    1 +
 drivers/net/wireless/ath/ath9k/init.c  |    8 ++++++++
 drivers/net/wireless/ath/ath9k/main.c  |    5 +++++
 3 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 973c919..04a9c86 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -675,6 +675,7 @@ static inline void ath_read_cachesize(struct ath_common *common, int *csz)
 }
 
 extern struct ieee80211_ops ath9k_ops;
+extern struct pm_qos_request_list ath9k_pm_qos_req;
 extern int modparam_nohwcrypt;
 extern int led_blink;
 
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 95b41db..6a0d99e 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -15,6 +15,7 @@
  */
 
 #include <linux/slab.h>
+#include <linux/pm_qos_params.h>
 
 #include "ath9k.h"
 
@@ -179,6 +180,8 @@ static const struct ath_ops ath9k_common_ops = {
 	.write = ath9k_iowrite32,
 };
 
+struct pm_qos_request_list ath9k_pm_qos_req;
+
 /**************************/
 /*     Initialization     */
 /**************************/
@@ -756,6 +759,9 @@ int ath9k_init_device(u16 devid, struct ath_softc *sc, u16 subsysid,
 	ath_init_leds(sc);
 	ath_start_rfkill_poll(sc);
 
+	pm_qos_add_request(&ath9k_pm_qos_req, PM_QOS_CPU_DMA_LATENCY,
+			   PM_QOS_DEFAULT_VALUE);
+
 	return 0;
 
 error_world:
@@ -811,6 +817,8 @@ void ath9k_deinit_device(struct ath_softc *sc)
 
 	ath9k_ps_wakeup(sc);
 
+	pm_qos_remove_request(&ath9k_pm_qos_req);
+
 	wiphy_rfkill_stop_polling(sc->hw->wiphy);
 	ath_deinit_leds(sc);
 
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index c6ec800..81fa245 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -15,6 +15,7 @@
  */
 
 #include <linux/nl80211.h>
+#include <linux/pm_qos_params.h>
 #include "ath9k.h"
 #include "btcoex.h"
 
@@ -1213,6 +1214,8 @@ static int ath9k_start(struct ieee80211_hw *hw)
 			ath9k_btcoex_timer_resume(sc);
 	}
 
+	pm_qos_update_request(&ath9k_pm_qos_req, 55);
+
 mutex_unlock:
 	mutex_unlock(&sc->mutex);
 
@@ -1388,6 +1391,8 @@ static void ath9k_stop(struct ieee80211_hw *hw)
 
 	sc->sc_flags |= SC_OP_INVALID;
 
+	pm_qos_update_request(&ath9k_pm_qos_req, PM_QOS_DEFAULT_VALUE);
+
 	mutex_unlock(&sc->mutex);
 
 	ath_print(common, ATH_DBG_CONFIG, "Driver halt\n");
-- 
1.6.3.3

