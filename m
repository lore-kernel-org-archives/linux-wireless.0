Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:13731 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752241Ab0LNHsj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Dec 2010 02:48:39 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 13 Dec 2010 23:48:23 -0800
From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <lrodriguez@atheros.com>,
	Mohammed Shafi Shajakhan <mshajakhan@atheros.com>,
	Senthilkumar Balasubramanian
	<Senthilkumar.Balasubramanian@Atheros.com>
Subject: [PATCH] ath9k: Make PM-QOS value as user configurable
Date: Tue, 14 Dec 2010 13:18:28 +0530
Message-ID: <1292312908-6182-1-git-send-email-mshajakhan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>

This patch allows the pm-qos value to be user configurable by making it as
a module parameter.This will help our customers to configure the pm-qos
value according to the effect in throughput due to the DMA latency problem
which was observed in Intel Pinetrail platforms.
	The tested value of '55' will be filled as the default
pm-qos-value incase the user does not specifies pm-qos value as a
module parameter.
example usage: sudo modprobe ath9k pmqos=65

Cc: Senthilkumar Balasubramanian <Senthilkumar.Balasubramanian@Atheros.com>
Signed-off-by: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    3 +++
 drivers/net/wireless/ath/ath9k/init.c  |    4 ++++
 drivers/net/wireless/ath/ath9k/main.c  |    2 +-
 3 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 9b5501f..b0b1216 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -57,6 +57,8 @@ struct ath_node;
 
 #define A_MAX(a, b) ((a) > (b) ? (a) : (b))
 
+#define ATH9K_PM_QOS_DEFAULT_VALUE	55
+
 #define TSF_TO_TU(_h,_l) \
 	((((u32)(_h)) << 22) | (((u32)(_l)) >> 10))
 
@@ -663,6 +665,7 @@ static inline void ath_read_cachesize(struct ath_common *common, int *csz)
 extern struct ieee80211_ops ath9k_ops;
 extern int modparam_nohwcrypt;
 extern int led_blink;
+extern int ath9k_pm_qos_value;
 
 irqreturn_t ath_isr(int irq, void *dev);
 int ath9k_init_device(u16 devid, struct ath_softc *sc, u16 subsysid,
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index b2983ce..1238795 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -41,6 +41,10 @@ static int ath9k_btcoex_enable;
 module_param_named(btcoex_enable, ath9k_btcoex_enable, int, 0444);
 MODULE_PARM_DESC(btcoex_enable, "Enable wifi-BT coexistence");
 
+int ath9k_pm_qos_value = ATH9K_PM_QOS_DEFAULT_VALUE;
+module_param_named(pmqos, ath9k_pm_qos_value, int, S_IRUSR | S_IRGRP | S_IROTH);
+MODULE_PARM_DESC(pmqos, "User specified PM-QOS value");
+
 /* We use the hw_value as an index into our private channel structure */
 
 #define CHAN2G(_freq, _idx)  { \
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index c68205d..36f4f5a 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1196,7 +1196,7 @@ static int ath9k_start(struct ieee80211_hw *hw)
 			ath9k_btcoex_timer_resume(sc);
 	}
 
-	pm_qos_update_request(&sc->pm_qos_req, 55);
+	pm_qos_update_request(&sc->pm_qos_req, ath9k_pm_qos_value);
 
 	if (ah->caps.pcie_lcr_extsync_en && common->bus_ops->extn_synch_en)
 		common->bus_ops->extn_synch_en(common);
-- 
1.7.0.4

