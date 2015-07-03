Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:59071 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382AbbGCI3q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Jul 2015 04:29:46 -0400
From: <miaoqing@qti.qualcomm.com>
Cc: <linux-wireless@vger.kernel.org>, <ath9k-devel@qca.qualcomm.com>,
	<kvalo@qca.qualcomm.com>, Miaoqing Pan <miaoqing@qti.qualcomm.com>
To: <linville@tuxdriver.com>
Subject: [PATCH v2] ath9k: export HW random number generator
Date: Fri, 3 Jul 2015 16:28:30 +0800
Message-ID: <1435912110-9646-1-git-send-email-miaoqing@qca.qualcomm.com> (sfid-20150703_102954_935764_2AA5EFDC)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Miaoqing Pan <miaoqing@qca.qualcomm.com>

We measured the ADC-based entropy in 3 ways, Shannon entropy,
collision entropy, and directly measured min-entropy. Entropy is
in bits per 16 bit value,
   ---------------------------
   Shannon | collision | min
   ---------------------------
   12.00   | 10.80     | 9.18
   ---------------------------

Recommend: A generous safety factor be used. NIST Special Publication
800-90B (draft) requires that data used to seed a deterministic random
bit generator with N bits of strength have an estimated entropy at least
twice the block size of the underlying primitive. Given all the
uncertainties, it would be wise to collect even more.

Analysis was done by Jacobson,David(djacobso@qti.qualcomm.com).

Signed-off-by: Miaoqing Pan <miaoqing@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/Kconfig  |  7 ++++
 drivers/net/wireless/ath/ath9k/Makefile |  1 +
 drivers/net/wireless/ath/ath9k/ath9k.h  | 23 ++++++++++++
 drivers/net/wireless/ath/ath9k/main.c   |  4 ++
 drivers/net/wireless/ath/ath9k/rng.c    | 66 +++++++++++++++++++++++++++++++++
 5 files changed, 101 insertions(+)
 create mode 100644 drivers/net/wireless/ath/ath9k/rng.c

diff --git a/drivers/net/wireless/ath/ath9k/Kconfig b/drivers/net/wireless/ath/ath9k/Kconfig
index fee0cad..bde62ec9 100644
--- a/drivers/net/wireless/ath/ath9k/Kconfig
+++ b/drivers/net/wireless/ath/ath9k/Kconfig
@@ -176,3 +176,10 @@ config ATH9K_HTC_DEBUGFS
 	depends on ATH9K_HTC && DEBUG_FS
 	---help---
 	  Say Y, if you need access to ath9k_htc's statistics.
+
+config ATH9K_HWRNG
+	bool "Random number generator support"
+	depends on ATH9K && (HW_RANDOM = y || HW_RANDOM = ATH9K)
+	default y
+	---help---
+	  Provides a hardware random number generator to the kernel.
diff --git a/drivers/net/wireless/ath/ath9k/Makefile b/drivers/net/wireless/ath/ath9k/Makefile
index ecda613..76f9dc3 100644
--- a/drivers/net/wireless/ath/ath9k/Makefile
+++ b/drivers/net/wireless/ath/ath9k/Makefile
@@ -15,6 +15,7 @@ ath9k-$(CONFIG_ATH9K_DFS_DEBUGFS) += dfs_debug.o
 ath9k-$(CONFIG_ATH9K_DFS_CERTIFIED) += dfs.o
 ath9k-$(CONFIG_ATH9K_TX99) += tx99.o
 ath9k-$(CONFIG_ATH9K_WOW) += wow.o
+ath9k-$(CONFIG_ATH9K_HWRNG) += rng.o
 
 ath9k-$(CONFIG_ATH9K_DEBUGFS) += debug.o
 
diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index a7a81b3..45596e5 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -23,6 +23,7 @@
 #include <linux/leds.h>
 #include <linux/completion.h>
 #include <linux/time.h>
+#include <linux/hw_random.h>
 
 #include "common.h"
 #include "debug.h"
@@ -1041,6 +1042,12 @@ struct ath_softc {
 	u32 wow_intr_before_sleep;
 	bool force_wow;
 #endif
+
+#ifdef CONFIG_ATH9K_HWRNG
+	struct hwrng rng;
+	bool rng_initialized;
+	u32 rng_last;
+#endif
 };
 
 /********/
@@ -1063,6 +1070,22 @@ static inline int ath9k_tx99_send(struct ath_softc *sc,
 }
 #endif /* CONFIG_ATH9K_TX99 */
 
+/***************************/
+/* Random Number Generator */
+/***************************/
+#ifdef CONFIG_ATH9K_HWRNG
+void ath9k_rng_register(struct ath_softc *sc);
+void ath9k_rng_unregister(struct ath_softc *sc);
+#else
+static inline void ath9k_rng_register(struct ath_softc *sc)
+{
+}
+
+static inline void ath9k_rng_unregister(struct ath_softc *sc)
+{
+}
+#endif
+
 static inline void ath_read_cachesize(struct ath_common *common, int *csz)
 {
 	common->bus_ops->read_cachesize(common, csz);
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index cfd45cb..5916ab2 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -739,6 +739,8 @@ static int ath9k_start(struct ieee80211_hw *hw)
 
 	ath9k_ps_restore(sc);
 
+	ath9k_rng_register(sc);
+
 	return 0;
 }
 
@@ -828,6 +830,8 @@ static void ath9k_stop(struct ieee80211_hw *hw)
 
 	ath9k_deinit_channel_context(sc);
 
+	ath9k_rng_unregister(sc);
+
 	mutex_lock(&sc->mutex);
 
 	ath_cancel_work(sc);
diff --git a/drivers/net/wireless/ath/ath9k/rng.c b/drivers/net/wireless/ath/ath9k/rng.c
new file mode 100644
index 0000000..e2cce31
--- /dev/null
+++ b/drivers/net/wireless/ath/ath9k/rng.c
@@ -0,0 +1,66 @@
+/*
+ * Copyright (c) 2015 Qualcomm Atheros, Inc.
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#include "ath9k.h"
+#include "hw.h"
+#include "ar9003_phy.h"
+
+static int ath9k_rng_data_read(struct hwrng *rng, u32 *data)
+{
+	u32 v1, v2;
+	struct ath_softc *sc = (struct ath_softc *)rng->priv;
+	struct ath_hw *ah = sc->sc_ah;
+
+	ath9k_ps_wakeup(sc);
+
+	v1 = REG_READ(ah, AR_PHY_TST_ADC);
+	v2 = REG_READ(ah, AR_PHY_TST_ADC);
+
+	ath9k_ps_restore(sc);
+
+	/* wait for data ready */
+	if (v1 && v2 && sc->rng_last != v1 && v1 != v2) {
+		*data = (v1 & 0xffff) | (v2 << 16);
+		sc->rng_last = v2;
+
+		return sizeof(u32);
+	}
+
+	sc->rng_last = v2;
+
+	return 0;
+}
+
+void ath9k_rng_register(struct ath_softc *sc)
+{
+	if (WARN_ON(sc->rng_initialized))
+		return;
+
+	sc->rng.name = "ath9k";
+	sc->rng.data_read = ath9k_rng_data_read;
+	sc->rng.priv = (unsigned long)sc;
+
+	if (!hwrng_register(&sc->rng))
+		sc->rng_initialized = true;
+}
+
+void ath9k_rng_unregister(struct ath_softc *sc)
+{
+	if (sc->rng_initialized) {
+		hwrng_unregister(&sc->rng);
+		sc->rng_initialized = false;
+	}
+}
-- 
1.9.1

