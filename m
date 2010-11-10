Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:21164 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755227Ab0KJJ4P (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Nov 2010 04:56:15 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 10 Nov 2010 01:56:02 -0800
From: Vivek Natarajan <vnatarajan@atheros.com>
To: <lrodriguez@atheros.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2] compat/ath9k: pm-qos params patch
Date: Wed, 10 Nov 2010 15:26:08 +0530
Message-ID: <1289382968-4165-1-git-send-email-vnatarajan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch is similar to the one for ipw2x00:
This patch is required because now pm-qos has 3 different flavors:

On kernels >= 2.6.36 the pm qos req is kzalloc()'d by pm-qos itself
On kernel   = 2.6.35 the pm qos req uses the stack
On kernels <  2.6.35 the pm qos req is pegged to a unique name.

Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
---
Rebased on top of my recent patch:
ath9k: Remove pm_qos request after hw unregister.

 drivers/net/wireless/ath/ath9k/ath9k.h |    4 ++++
 drivers/net/wireless/ath/ath9k/init.c  |   19 +++++++++++++++++++
 drivers/net/wireless/ath/ath9k/main.c  |   15 +++++++++++++++
 3 files changed, 38 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 170d44a..ab920fb 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -675,7 +675,11 @@ static inline void ath_read_cachesize(struct ath_common *common, int *csz)
 }
 
 extern struct ieee80211_ops ath9k_ops;
+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,36))
 extern struct pm_qos_request_list ath9k_pm_qos_req;
+#elif (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,35))
+extern struct pm_qos_request_list *ath9k_pm_qos_req;
+#endif
 extern int modparam_nohwcrypt;
 extern int led_blink;
 
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 92bc5c5..56182fe 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -180,7 +180,12 @@ static const struct ath_ops ath9k_common_ops = {
 	.write = ath9k_iowrite32,
 };
 
+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,36))
 struct pm_qos_request_list ath9k_pm_qos_req;
+#elif (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,35))
+struct pm_qos_request_list *ath9k_pm_qos_req;
+#endif
+
 
 /**************************/
 /*     Initialization     */
@@ -759,8 +764,16 @@ int ath9k_init_device(u16 devid, struct ath_softc *sc, u16 subsysid,
 	ath_init_leds(sc);
 	ath_start_rfkill_poll(sc);
 
+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,36))
 	pm_qos_add_request(&ath9k_pm_qos_req, PM_QOS_CPU_DMA_LATENCY,
 			   PM_QOS_DEFAULT_VALUE);
+#elif (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,35))
+	ath9k_pm_qos_req = pm_qos_add_request(PM_QOS_CPU_DMA_LATENCY,
+					      PM_QOS_DEFAULT_VALUE);
+#else
+	pm_qos_add_requirement(PM_QOS_CPU_DMA_LATENCY, "ath9k",
+			       PM_QOS_DEFAULT_VALUE);
+#endif
 
 	return 0;
 
@@ -830,7 +843,13 @@ void ath9k_deinit_device(struct ath_softc *sc)
 	}
 
 	ieee80211_unregister_hw(hw);
+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,36))
 	pm_qos_remove_request(&ath9k_pm_qos_req);
+#elif (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,35))
+	pm_qos_remove_request(ath9k_pm_qos_req);
+#else
+	pm_qos_remove_requirement(PM_QOS_CPU_DMA_LATENCY, "ath9k");
+#endif
 	ath_rx_cleanup(sc);
 	ath_tx_cleanup(sc);
 	ath9k_deinit_softc(sc);
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 25d3ef4..fa378bc 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1244,7 +1244,14 @@ static int ath9k_start(struct ieee80211_hw *hw)
 			ath9k_btcoex_timer_resume(sc);
 	}
 
+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,36))
 	pm_qos_update_request(&ath9k_pm_qos_req, 55);
+#elif (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,35))
+	pm_qos_update_request(ath9k_pm_qos_req, 55);
+#else
+	pm_qos_update_requirement(PM_QOS_CPU_DMA_LATENCY, "ath9k", 55);
+#endif
+
 
 mutex_unlock:
 	mutex_unlock(&sc->mutex);
@@ -1423,7 +1430,15 @@ static void ath9k_stop(struct ieee80211_hw *hw)
 
 	sc->sc_flags |= SC_OP_INVALID;
 
+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,36))
 	pm_qos_update_request(&ath9k_pm_qos_req, PM_QOS_DEFAULT_VALUE);
+#elif (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,35))
+	pm_qos_update_request(ath9k_pm_qos_req, PM_QOS_DEFAULT_VALUE);
+#else
+	pm_qos_update_requirement(PM_QOS_CPU_DMA_LATENCY, "ath9k",
+			PM_QOS_DEFAULT_VALUE);
+#endif
+
 
 	mutex_unlock(&sc->mutex);
 
-- 
1.6.3.3

