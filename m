Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:57155 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756278Ab0ITLqI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Sep 2010 07:46:08 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH 5/5] ath9k: make the driver specific rate control module optional
Date: Mon, 20 Sep 2010 13:45:40 +0200
Message-Id: <1284983140-30099-5-git-send-email-nbd@openwrt.org>
In-Reply-To: <1284983140-30099-4-git-send-email-nbd@openwrt.org>
References: <1284983140-30099-1-git-send-email-nbd@openwrt.org>
 <1284983140-30099-2-git-send-email-nbd@openwrt.org>
 <1284983140-30099-3-git-send-email-nbd@openwrt.org>
 <1284983140-30099-4-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath9k can use minstrel_ht instead, so it makes sense to save some space here.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/Kconfig  |    8 ++++++++
 drivers/net/wireless/ath/ath9k/Makefile |    2 +-
 drivers/net/wireless/ath/ath9k/init.c   |    2 ++
 drivers/net/wireless/ath/ath9k/rc.h     |   11 +++++++++++
 4 files changed, 22 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/Kconfig b/drivers/net/wireless/ath/ath9k/Kconfig
index 35f23bd..ad57a6d 100644
--- a/drivers/net/wireless/ath/ath9k/Kconfig
+++ b/drivers/net/wireless/ath/ath9k/Kconfig
@@ -32,6 +32,14 @@ config ATH9K_DEBUGFS
 
 	  Also required for changing debug message flags at run time.
 
+config ATH9K_RATE_CONTROL
+	bool "Atheros ath9k rate control"
+	depends on ATH9K
+	default y
+	---help---
+	  Say Y, if you want to use the ath9k specific rate control
+	  module instead of minstrel_ht.
+
 config ATH9K_HTC
        tristate "Atheros HTC based wireless cards support"
        depends on USB && MAC80211
diff --git a/drivers/net/wireless/ath/ath9k/Makefile b/drivers/net/wireless/ath/ath9k/Makefile
index 4555e99..aca0162 100644
--- a/drivers/net/wireless/ath/ath9k/Makefile
+++ b/drivers/net/wireless/ath/ath9k/Makefile
@@ -5,8 +5,8 @@ ath9k-y +=	beacon.o \
 		recv.o \
 		xmit.o \
 		virtual.o \
-		rc.o
 
+ath9k-$(CONFIG_ATH9K_RATE_CONTROL) += rc.o
 ath9k-$(CONFIG_PCI) += pci.o
 ath9k-$(CONFIG_ATHEROS_AR71XX) += ahb.o
 ath9k-$(CONFIG_ATH9K_DEBUGFS) += debug.o
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index e7c07b3..f9d84d4 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -654,7 +654,9 @@ void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
 	hw->sta_data_size = sizeof(struct ath_node);
 	hw->vif_data_size = sizeof(struct ath_vif);
 
+#ifdef CONFIG_ATH9K_RATE_CONTROL
 	hw->rate_control_algorithm = "ath9k_rate_control";
+#endif
 
 	if (test_bit(ATH9K_MODE_11G, sc->sc_ah->caps.wireless_modes))
 		hw->wiphy->bands[IEEE80211_BAND_2GHZ] =
diff --git a/drivers/net/wireless/ath/ath9k/rc.h b/drivers/net/wireless/ath/ath9k/rc.h
index dc10826..268072f 100644
--- a/drivers/net/wireless/ath/ath9k/rc.h
+++ b/drivers/net/wireless/ath/ath9k/rc.h
@@ -224,7 +224,18 @@ enum ath9k_internal_frame_type {
 	ATH9K_IFT_UNPAUSE
 };
 
+#ifdef CONFIG_ATH9K_RATE_CONTROL
 int ath_rate_control_register(void);
 void ath_rate_control_unregister(void);
+#else
+static inline int ath_rate_control_register(void)
+{
+	return 0;
+}
+
+static inline void ath_rate_control_unregister(void)
+{
+}
+#endif
 
 #endif /* RC_H */
-- 
1.7.2.2

