Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:60796 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752577Ab1B1GU7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Feb 2011 01:20:59 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sun, 27 Feb 2011 22:20:38 -0800
From: Vivek Natarajan <vnatarajan@atheros.com>
To: <greg@kroah.com>
CC: <linux-wireless@vger.kernel.org>, <stable@kernel.org>,
	Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
Subject: [stable 2.6.37][PATCH] ath9k: Fix ath9k to allow CPU to enter C3 state.
Date: Mon, 28 Feb 2011 11:50:53 +0530
Message-ID: <1298874054-3803-1-git-send-email-vnatarajan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The default qos value of 55 causes higher power consumption
and the battery drains out quickly. So, remove the pm_qos request
in the driver and the throughout issue in the Intel Pinetrail
platforms in which the DMA latency is seen can be fixed with
the following script:
http://www.kernel.org/pub/linux/kernel/people/mcgrof/scripts/cpudmalatency.c
http://johannes.sipsolutions.net/files/netlatency.c.txt

More details can be found in the following bugzilla link:
https://bugzilla.kernel.org/show_bug.cgi?id=27532

Cc: stable@kernel.org
Signed-off-by: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    2 --
 drivers/net/wireless/ath/ath9k/init.c  |    4 ----
 drivers/net/wireless/ath/ath9k/main.c  |    4 ----
 3 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 0963071..f424b08 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -21,7 +21,6 @@
 #include <linux/device.h>
 #include <linux/leds.h>
 #include <linux/completion.h>
-#include <linux/pm_qos_params.h>
 
 #include "debug.h"
 #include "common.h"
@@ -648,7 +647,6 @@ struct ath_softc {
 
 	struct ath_ant_comb ant_comb;
 
-	struct pm_qos_request_list pm_qos_req;
 };
 
 struct ath_wiphy {
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 14b8ab3..91d9b2a 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -758,9 +758,6 @@ int ath9k_init_device(u16 devid, struct ath_softc *sc, u16 subsysid,
 	ath_init_leds(sc);
 	ath_start_rfkill_poll(sc);
 
-	pm_qos_add_request(&sc->pm_qos_req, PM_QOS_CPU_DMA_LATENCY,
-			   PM_QOS_DEFAULT_VALUE);
-
 	return 0;
 
 error_world:
@@ -829,7 +826,6 @@ void ath9k_deinit_device(struct ath_softc *sc)
 	}
 
 	ieee80211_unregister_hw(hw);
-	pm_qos_remove_request(&sc->pm_qos_req);
 	ath_rx_cleanup(sc);
 	ath_tx_cleanup(sc);
 	ath9k_deinit_softc(sc);
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index c0c3464..7d332e5 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1244,8 +1244,6 @@ static int ath9k_start(struct ieee80211_hw *hw)
 			ath9k_btcoex_timer_resume(sc);
 	}
 
-	pm_qos_update_request(&sc->pm_qos_req, 55);
-
 mutex_unlock:
 	mutex_unlock(&sc->mutex);
 
@@ -1423,8 +1421,6 @@ static void ath9k_stop(struct ieee80211_hw *hw)
 
 	sc->sc_flags |= SC_OP_INVALID;
 
-	pm_qos_update_request(&sc->pm_qos_req, PM_QOS_DEFAULT_VALUE);
-
 	mutex_unlock(&sc->mutex);
 
 	ath_print(common, ATH_DBG_CONFIG, "Driver halt\n");
-- 
1.7.3.4

