Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from chaos.universe-factory.net ([31.24.148.19]:38456 "EHLO
        chaos.universe-factory.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932225AbdK0SFt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 27 Nov 2017 13:05:49 -0500
From: Matthias Schiffer <mschiffer@universe-factory.net>
To: kvalo@qca.qualcomm.com
Cc: ath9k-devel@qca.qualcomm.com, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, nbd@nbd.name
Subject: [PATCH 2/3] ath9k: move spectral scan support under a separate config symbol
Date: Mon, 27 Nov 2017 18:56:22 +0100
Message-Id: <1c982c915065a9b5ed3232eedb567f589eca261b.1511804622.git.mschiffer@universe-factory.net> (sfid-20171127_190623_571528_916E663B)
In-Reply-To: <e60138924429ca428efc6e3154606887b3bc5201.1511804622.git.mschiffer@universe-factory.net>
References: <e60138924429ca428efc6e3154606887b3bc5201.1511804622.git.mschiffer@universe-factory.net>
In-Reply-To: <e60138924429ca428efc6e3154606887b3bc5201.1511804622.git.mschiffer@universe-factory.net>
References: <e60138924429ca428efc6e3154606887b3bc5201.1511804622.git.mschiffer@universe-factory.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

At the moment, spectral scan support, and with it RELAY, is always enabled
with ATH9K[_HTC]_DEBUGFS. Spectral scan support is currently the only user
of RELAY in ath9k, and it unconditionally reserves a relay channel.

Having debugfs support in ath9k is often useful even on very small embedded
routers, where we'd rather like to avoid the code size and RAM usage of the
relay support.

Signed-off-by: Matthias Schiffer <mschiffer@universe-factory.net>
---
 drivers/net/wireless/ath/ath9k/Kconfig           | 14 ++++++++++----
 drivers/net/wireless/ath/ath9k/Makefile          |  4 ++--
 drivers/net/wireless/ath/ath9k/common-spectral.h |  4 ++--
 3 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/Kconfig b/drivers/net/wireless/ath/ath9k/Kconfig
index 783a38f1a626..1f3523019509 100644
--- a/drivers/net/wireless/ath/ath9k/Kconfig
+++ b/drivers/net/wireless/ath/ath9k/Kconfig
@@ -61,13 +61,12 @@ config ATH9K_DEBUGFS
 	depends on ATH9K && DEBUG_FS
 	select MAC80211_DEBUGFS
 	select ATH9K_COMMON_DEBUG
-	select RELAY
 	---help---
 	  Say Y, if you need access to ath9k's statistics for
 	  interrupts, rate control, etc.
 
-	  Also required for changing debug message flags at run time.
-	  As well as access to the FFT/spectral data and TX99.
+	  Also required for changing debug message flags at run time and for
+	  TX99.
 
 config ATH9K_STATION_STATISTICS
 	bool "Detailed station statistics"
@@ -177,7 +176,6 @@ config ATH9K_HTC_DEBUGFS
 	bool "Atheros ath9k_htc debugging"
 	depends on ATH9K_HTC && DEBUG_FS
 	select ATH9K_COMMON_DEBUG
-	select RELAY
 	---help---
 	  Say Y, if you need access to ath9k_htc's statistics.
 	  As well as access to the FFT/spectral data.
@@ -192,3 +190,11 @@ config ATH9K_HWRNG
 
 	  Say Y, feeds the entropy directly from the WiFi driver to the input
 	  pool.
+
+config ATH9K_COMMON_SPECTRAL
+	bool "Atheros ath9k/ath9k_htc spectral scan support"
+	depends on ATH9K_DEBUGFS || ATH9K_HTC_DEBUGFS
+	select RELAY
+	default n
+	---help---
+	  Say Y to enable access to the FFT/spectral data via debugfs.
diff --git a/drivers/net/wireless/ath/ath9k/Makefile b/drivers/net/wireless/ath/ath9k/Makefile
index 90e4a341076c..80197101eda7 100644
--- a/drivers/net/wireless/ath/ath9k/Makefile
+++ b/drivers/net/wireless/ath/ath9k/Makefile
@@ -61,8 +61,8 @@ ath9k_common-y:=	common.o \
 			common-init.o \
 			common-beacon.o
 
-ath9k_common-$(CONFIG_ATH9K_COMMON_DEBUG) += common-debug.o \
-					     common-spectral.o
+ath9k_common-$(CONFIG_ATH9K_COMMON_DEBUG) += common-debug.o
+ath9k_common-$(CONFIG_ATH9K_COMMON_SPECTRAL) += common-spectral.o
 
 ath9k_htc-y +=	htc_hst.o \
 		hif_usb.o \
diff --git a/drivers/net/wireless/ath/ath9k/common-spectral.h b/drivers/net/wireless/ath/ath9k/common-spectral.h
index 5d1a51d83aa6..303ab470ce34 100644
--- a/drivers/net/wireless/ath/ath9k/common-spectral.h
+++ b/drivers/net/wireless/ath/ath9k/common-spectral.h
@@ -151,7 +151,7 @@ static inline u8 spectral_bitmap_weight(u8 *bins)
 	return bins[0] & 0x3f;
 }
 
-#ifdef CONFIG_ATH9K_COMMON_DEBUG
+#ifdef CONFIG_ATH9K_COMMON_SPECTRAL
 void ath9k_cmn_spectral_init_debug(struct ath_spec_scan_priv *spec_priv, struct dentry *debugfs_phy);
 void ath9k_cmn_spectral_deinit_debug(struct ath_spec_scan_priv *spec_priv);
 
@@ -183,6 +183,6 @@ static inline int ath_cmn_process_fft(struct ath_spec_scan_priv *spec_priv,
 {
 	return 0;
 }
-#endif /* CONFIG_ATH9K_COMMON_DEBUG */
+#endif /* CONFIG_ATH9K_COMMON_SPECTRAL */
 
 #endif /* SPECTRAL_H */
-- 
2.15.0
