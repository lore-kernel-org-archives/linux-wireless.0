Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:35413 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752478Ab0LVGuW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Dec 2010 01:50:22 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 21 Dec 2010 22:50:06 -0800
From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
To: <linville@tuxdriver.com>
CC: <Jouni.Malinen@Atheros.com>, <linux-wireless@vger.kernel.org>,
	<lrodriguez@atheros.com>,
	Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
Subject: [PATCH] ath9k: Reset keycache on resume
Date: Wed, 22 Dec 2010 12:20:12 +0530
Message-ID: <1293000612-10884-1-git-send-email-mshajakhan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>

It looks like some hardware registers are left into undefined state
after suspend/resume. At minimum, this can cause odd issues related to
key cache and hardware trying to encrypt/decrypt frames unexpectedly.
This seems to happen even when there is no keys configured, i.e., hardware
can end up touching TX frames just based of invalid key cache context
even if the driver is not asking a specific entry to be used. In
addition, RX can likely be affected. This patch fixes this issue.

Signed-off-by: Jouni Malinen <Jouni.Malinen@Atheros.com>
Signed-off-by: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    1 +
 drivers/net/wireless/ath/ath9k/init.c  |    2 +-
 drivers/net/wireless/ath/ath9k/pci.c   |    8 ++++++++
 3 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 2c31f51..12e60bb 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -669,6 +669,7 @@ extern int led_blink;
 extern int ath9k_pm_qos_value;
 
 irqreturn_t ath_isr(int irq, void *dev);
+void ath9k_init_crypto(struct ath_softc *sc);
 int ath9k_init_device(u16 devid, struct ath_softc *sc, u16 subsysid,
 		    const struct ath_bus_ops *bus_ops);
 void ath9k_deinit_device(struct ath_softc *sc);
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index b0e5e71..91cb422 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -372,7 +372,7 @@ fail:
 #undef DS2PHYS
 }
 
-static void ath9k_init_crypto(struct ath_softc *sc)
+void ath9k_init_crypto(struct ath_softc *sc)
 {
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	int i = 0;
diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
index 7ca8499..af34d05 100644
--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -309,6 +309,14 @@ static int ath_pci_resume(struct device *device)
 			    AR_GPIO_OUTPUT_MUX_AS_OUTPUT);
 	ath9k_hw_set_gpio(sc->sc_ah, sc->sc_ah->led_pin, 1);
 
+	  /*
+	   * Reset key cache to sane defaults (all entries cleared) instead of
+	   * semi-random values after suspend/resume.
+	   */
+	ath9k_ps_wakeup(sc);
+	ath9k_init_crypto(sc);
+	ath9k_ps_restore(sc);
+
 	sc->ps_idle = true;
 	ath_radio_disable(sc, hw);
 
-- 
1.7.0.4

