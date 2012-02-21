Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:39807 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753742Ab2BUJXB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Feb 2012 04:23:01 -0500
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20291.25194.272350.581026@gargle.gargle.HOWL> (sfid-20120221_102307_466040_B2F51765)
Date: Tue, 21 Feb 2012 14:52:50 +0530
To: <linux-wireless@vger.kernel.org>
CC: <ath9k-devel@lists.ath9k.org>
Subject: [RFC/WIP 08/22] ath9k: Use CONFIG_ATH9K_BTCOEX_SUPPORT
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch uses CONFIG_ATH9K_BTCOEX_SUPPORT to conditionally
compile btcoex-related code in the driver core.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/Makefile |    4 ++--
 drivers/net/wireless/ath/ath9k/ath9k.h  |   28 ++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/gpio.c   |    4 ++++
 3 files changed, 34 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/Makefile b/drivers/net/wireless/ath/ath9k/Makefile
index da02242..b3c7b12 100644
--- a/drivers/net/wireless/ath/ath9k/Makefile
+++ b/drivers/net/wireless/ath/ath9k/Makefile
@@ -3,9 +3,9 @@ ath9k-y +=	beacon.o \
 		init.o \
 		main.o \
 		recv.o \
-		xmit.o \
-		mci.o \
+		xmit.o
 
+ath9k-$(CONFIG_ATH9K_BTCOEX_SUPPORT) += mci.o
 ath9k-$(CONFIG_ATH9K_RATE_CONTROL) += rc.o
 ath9k-$(CONFIG_ATH9K_PCI) += pci.o
 ath9k-$(CONFIG_ATH9K_AHB) += ahb.o
diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 23145ce..2efde57 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -454,6 +454,7 @@ struct ath_btcoex {
 	struct ath_mci_profile mci;
 };
 
+#ifdef CONFIG_ATH9K_BTCOEX_SUPPORT
 int ath9k_init_btcoex(struct ath_softc *sc);
 void ath9k_deinit_btcoex(struct ath_softc *sc);
 void ath9k_start_btcoex(struct ath_softc *sc);
@@ -462,6 +463,30 @@ void ath9k_btcoex_timer_resume(struct ath_softc *sc);
 void ath9k_btcoex_timer_pause(struct ath_softc *sc);
 void ath9k_btcoex_handle_interrupt(struct ath_softc *sc, u32 status);
 u16 ath9k_btcoex_aggr_limit(struct ath_softc *sc, u32 max_4ms_framelen);
+#else
+static inline int ath9k_init_btcoex(struct ath_softc *sc)
+{
+	return 0;
+}
+static inline void ath9k_deinit_btcoex(struct ath_softc *sc)
+{
+}
+static inline void ath9k_start_btcoex(struct ath_softc *sc)
+{
+}
+static inline void ath9k_stop_btcoex(struct ath_softc *sc)
+{
+}
+static inline void ath9k_btcoex_handle_interrupt(struct ath_softc *sc,
+						 u32 status)
+{
+}
+static inline u16 ath9k_btcoex_aggr_limit(struct ath_softc *sc,
+					  u32 max_4ms_framelen)
+{
+	return 0;
+}
+#endif
 
 /********************/
 /*   LED Control    */
@@ -655,8 +680,11 @@ struct ath_softc {
 	struct ath_beacon_config cur_beacon_conf;
 	struct delayed_work tx_complete_work;
 	struct delayed_work hw_pll_work;
+
+#ifdef CONFIG_ATH9K_BTCOEX_SUPPORT
 	struct ath_btcoex btcoex;
 	struct ath_mci_coex mci_coex;
+#endif
 
 	struct ath_descdma txsdma;
 
diff --git a/drivers/net/wireless/ath/ath9k/gpio.c b/drivers/net/wireless/ath/ath9k/gpio.c
index e870251..3ab62af 100644
--- a/drivers/net/wireless/ath/ath9k/gpio.c
+++ b/drivers/net/wireless/ath/ath9k/gpio.c
@@ -110,6 +110,8 @@ void ath_start_rfkill_poll(struct ath_softc *sc)
 		wiphy_rfkill_start_polling(sc->hw->wiphy);
 }
 
+#ifdef CONFIG_ATH9K_BTCOEX_SUPPORT
+
 /******************/
 /*     BTCOEX     */
 /******************/
@@ -423,3 +425,5 @@ int ath9k_init_btcoex(struct ath_softc *sc)
 
 	return 0;
 }
+
+#endif
-- 
1.7.9.1

