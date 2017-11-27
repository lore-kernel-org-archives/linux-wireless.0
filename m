Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from chaos.universe-factory.net ([31.24.148.19]:38452 "EHLO
        chaos.universe-factory.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932331AbdK0SFt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 27 Nov 2017 13:05:49 -0500
From: Matthias Schiffer <mschiffer@universe-factory.net>
To: kvalo@qca.qualcomm.com
Cc: ath9k-devel@qca.qualcomm.com, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, nbd@nbd.name
Subject: [PATCH 3/3] ath10k: move spectral scan support under a separate config symbol
Date: Mon, 27 Nov 2017 18:56:23 +0100
Message-Id: <af2dc61b09d13b393e777a661ecc528f627a6a0d.1511804622.git.mschiffer@universe-factory.net> (sfid-20171127_190623_822101_477C460C)
In-Reply-To: <e60138924429ca428efc6e3154606887b3bc5201.1511804622.git.mschiffer@universe-factory.net>
References: <e60138924429ca428efc6e3154606887b3bc5201.1511804622.git.mschiffer@universe-factory.net>
In-Reply-To: <e60138924429ca428efc6e3154606887b3bc5201.1511804622.git.mschiffer@universe-factory.net>
References: <e60138924429ca428efc6e3154606887b3bc5201.1511804622.git.mschiffer@universe-factory.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

At the moment, spectral scan support, and with it RELAY, is always enabled
with ATH10K_DEBUGFS. Spectral scan support is currently the only user of
RELAY in ath10k, and it unconditionally reserves a relay channel.

Having debugfs support in ath10k is often useful even on very small
embedded routers, where we'd rather like to avoid the code size and RAM
usage of the relay support. While ath10k-based devices usually have more
resources than ath9k-based ones, it makes sense to keep the configuration
symmetric to ath9k, so the same base kernel without RELAY can be used for
both ath9k and ath10k hardware.

Signed-off-by: Matthias Schiffer <mschiffer@universe-factory.net>
---

checkpatch.pl wants me to write a more meaningful description for
ATH10K_SPECTRAL, but I don't actually know enough about the spectral scan
feature to do so...

 drivers/net/wireless/ath/ath10k/Kconfig    | 9 ++++++++-
 drivers/net/wireless/ath/ath10k/Makefile   | 2 +-
 drivers/net/wireless/ath/ath10k/spectral.h | 4 ++--
 3 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/Kconfig b/drivers/net/wireless/ath/ath10k/Kconfig
index 87f56d0e17a6..deb5ae21a559 100644
--- a/drivers/net/wireless/ath/ath10k/Kconfig
+++ b/drivers/net/wireless/ath/ath10k/Kconfig
@@ -47,12 +47,19 @@ config ATH10K_DEBUG
 config ATH10K_DEBUGFS
 	bool "Atheros ath10k debugfs support"
 	depends on ATH10K && DEBUG_FS
-	select RELAY
 	---help---
 	  Enabled debugfs support
 
 	  If unsure, say Y to make it easier to debug problems.
 
+config ATH10K_SPECTRAL
+	bool "Atheros ath10k spectral scan support"
+	depends on ATH10K_DEBUGFS
+	select RELAY
+	default n
+	---help---
+	  Say Y to enable access to the FFT/spectral data via debugfs.
+
 config ATH10K_TRACING
 	bool "Atheros ath10k tracing support"
 	depends on ATH10K
diff --git a/drivers/net/wireless/ath/ath10k/Makefile b/drivers/net/wireless/ath/ath10k/Makefile
index 899b9b79f4ce..af8f11970a08 100644
--- a/drivers/net/wireless/ath/ath10k/Makefile
+++ b/drivers/net/wireless/ath/ath10k/Makefile
@@ -14,7 +14,7 @@ ath10k_core-y += mac.o \
 		 p2p.o \
 		 swap.o
 
-ath10k_core-$(CONFIG_ATH10K_DEBUGFS) += spectral.o
+ath10k_core-$(CONFIG_ATH10K_SPECTRAL) += spectral.o
 ath10k_core-$(CONFIG_NL80211_TESTMODE) += testmode.o
 ath10k_core-$(CONFIG_ATH10K_TRACING) += trace.o
 ath10k_core-$(CONFIG_THERMAL) += thermal.o
diff --git a/drivers/net/wireless/ath/ath10k/spectral.h b/drivers/net/wireless/ath/ath10k/spectral.h
index 89b0ad769d4f..b2a2e8ae04b8 100644
--- a/drivers/net/wireless/ath/ath10k/spectral.h
+++ b/drivers/net/wireless/ath/ath10k/spectral.h
@@ -44,7 +44,7 @@ enum ath10k_spectral_mode {
 	SPECTRAL_MANUAL,
 };
 
-#ifdef CONFIG_ATH10K_DEBUGFS
+#ifdef CONFIG_ATH10K_SPECTRAL
 
 int ath10k_spectral_process_fft(struct ath10k *ar,
 				struct wmi_phyerr_ev_arg *phyerr,
@@ -85,6 +85,6 @@ static inline void ath10k_spectral_destroy(struct ath10k *ar)
 {
 }
 
-#endif /* CONFIG_ATH10K_DEBUGFS */
+#endif /* CONFIG_ATH10K_SPECTRAL */
 
 #endif /* SPECTRAL_H */
-- 
2.15.0
