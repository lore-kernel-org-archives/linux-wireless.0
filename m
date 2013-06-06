Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:34913 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752694Ab3FFEjR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Jun 2013 00:39:17 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, stable@vger.kernel.org,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH v2] ath9k: Use minstrel rate control by default
Date: Thu,  6 Jun 2013 10:06:29 +0530
Message-Id: <1370493389-15807-1-git-send-email-sujith@msujith.org> (sfid-20130606_063922_140635_FAD0103F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

The ath9k rate control algorithm has various architectural
issues that make it a poor fit in scenarios like congested
environments etc.

An example: https://bugzilla.redhat.com/show_bug.cgi?id=927191

Change the default to minstrel which is more robust in such cases.
The ath9k RC code is left in the driver for now, maybe it can
be removed altogether later on.

Cc: stable@vger.kernel.org
Cc: Jouni Malinen <jouni@qca.qualcomm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/Kconfig  | 10 +++++++---
 drivers/net/wireless/ath/ath9k/Makefile |  2 +-
 drivers/net/wireless/ath/ath9k/init.c   |  4 ----
 drivers/net/wireless/ath/ath9k/rc.h     |  2 +-
 4 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/Kconfig b/drivers/net/wireless/ath/ath9k/Kconfig
index 3b07851..760ab3f 100644
--- a/drivers/net/wireless/ath/ath9k/Kconfig
+++ b/drivers/net/wireless/ath/ath9k/Kconfig
@@ -84,13 +84,17 @@ config ATH9K_DFS_CERTIFIED
 	  developed. At this point enabling this option won't do anything
 	  except increase code size.
 
-config ATH9K_RATE_CONTROL
+config ATH9K_LEGACY_RATE_CONTROL
 	bool "Atheros ath9k rate control"
 	depends on ATH9K
-	default y
+	default n
 	---help---
 	  Say Y, if you want to use the ath9k specific rate control
-	  module instead of minstrel_ht.
+	  module instead of minstrel_ht. Be warned that there are various
+	  issues with the ath9k RC and minstrel is a more robust algorithm.
+	  Note that even if this option is selected, "ath9k_rate_control"
+	  has to be passed to mac80211 using the module parameter,
+	  ieee80211_default_rc_algo.
 
 config ATH9K_HTC
        tristate "Atheros HTC based wireless cards support"
diff --git a/drivers/net/wireless/ath/ath9k/Makefile b/drivers/net/wireless/ath/ath9k/Makefile
index 2ad8f94..75ee9e7 100644
--- a/drivers/net/wireless/ath/ath9k/Makefile
+++ b/drivers/net/wireless/ath/ath9k/Makefile
@@ -8,7 +8,7 @@ ath9k-y +=	beacon.o \
 		antenna.o
 
 ath9k-$(CONFIG_ATH9K_BTCOEX_SUPPORT) += mci.o
-ath9k-$(CONFIG_ATH9K_RATE_CONTROL) += rc.o
+ath9k-$(CONFIG_ATH9K_LEGACY_RATE_CONTROL) += rc.o
 ath9k-$(CONFIG_ATH9K_PCI) += pci.o
 ath9k-$(CONFIG_ATH9K_AHB) += ahb.o
 ath9k-$(CONFIG_ATH9K_DEBUGFS) += debug.o
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index db81acc..389ee1b 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -830,10 +830,6 @@ void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
 	sc->ant_rx = hw->wiphy->available_antennas_rx;
 	sc->ant_tx = hw->wiphy->available_antennas_tx;
 
-#ifdef CONFIG_ATH9K_RATE_CONTROL
-	hw->rate_control_algorithm = "ath9k_rate_control";
-#endif
-
 	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_2GHZ)
 		hw->wiphy->bands[IEEE80211_BAND_2GHZ] =
 			&sc->sbands[IEEE80211_BAND_2GHZ];
diff --git a/drivers/net/wireless/ath/ath9k/rc.h b/drivers/net/wireless/ath/ath9k/rc.h
index 267dbfc..b9a8738 100644
--- a/drivers/net/wireless/ath/ath9k/rc.h
+++ b/drivers/net/wireless/ath/ath9k/rc.h
@@ -231,7 +231,7 @@ static inline void ath_debug_stat_retries(struct ath_rate_priv *rc, int rix,
 }
 #endif
 
-#ifdef CONFIG_ATH9K_RATE_CONTROL
+#ifdef CONFIG_ATH9K_LEGACY_RATE_CONTROL
 int ath_rate_control_register(void);
 void ath_rate_control_unregister(void);
 #else
-- 
1.8.3

