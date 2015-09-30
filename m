Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:3155 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752304AbbI3DMk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Sep 2015 23:12:40 -0400
From: "Pan, Miaoqing" <miaoqing@qti.qualcomm.com>
To: "miaoqing@codeaurora.org" <miaoqing@codeaurora.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ath9k-devel <ath9k-devel@qca.qualcomm.com>,
	"Valo, Kalle" <kvalo@qca.qualcomm.com>,
	"lkp@intel.com" <lkp@intel.com>
Subject: RE: [PATCH] ath9k: feeding entropy in kernel from ADC capture
Date: Wed, 30 Sep 2015 03:12:26 +0000
Message-ID: <f1bd170ef9fa433ab95052e0ad7057a8@aptaiexm02f.ap.qualcomm.com> (sfid-20150930_051244_144967_458F0071)
References: <1443582474-1144-1-git-send-email-miaoqing@codeaurora.org>
In-Reply-To: <1443582474-1144-1-git-send-email-miaoqing@codeaurora.org>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Please drop this patch, miss adding 'v2' prefix.

Thanks,
Miaoqing

-----Original Message-----
From: miaoqing@codeaurora.org [mailto:miaoqing@codeaurora.org] 
Sent: Wednesday, September 30, 2015 11:08 AM
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org; ath9k-devel; Valo, Kalle; lkp@intel.com; Miaoqing Pan
Subject: [PATCH] ath9k: feeding entropy in kernel from ADC capture

From: Miaoqing Pan <miaoqing@codeaurora.org>

This patch is derived from
commit 6301566e0b2d ("ath9k: export HW random number generator"),

We evaluated the entropy of the ADC data on QCA9531, QCA9561, QCA955x, and AR9340, and it has sufficient quality random data (at least 10 bits and up to 22 bits of min-entropy for a 32-bit value). We conservatively assume the min-entropy is 10 bits out of 32 bits. Thus, ATH9K_RNG_BUF_SIZE is set to 320 (u32) i.e., 1.25 kilobytes of data is inserted to fill up the pool as soon as the entropy counter becomes 896/4096 (set by random.c).
Since ADC was not designed to be a dedicated HW RNG, we do not want to bind it to /dev/hwrng framework directly. This patch feeds the entropy directly from the WiFi driver to the input pool. The ADC register output is only used as a seed for the Linux entropy pool. No conditioning is needed, since all the conditioning is performed by the pool itself.

Signed-off-by: Miaoqing Pan <miaoqing@codeaurora.org>
---
 drivers/net/wireless/ath/ath9k/Kconfig  |  11 ++++
 drivers/net/wireless/ath/ath9k/Makefile |   1 +
 drivers/net/wireless/ath/ath9k/ath9k.h  |  22 +++++++
 drivers/net/wireless/ath/ath9k/main.c   |   4 ++
 drivers/net/wireless/ath/ath9k/rng.c    | 106 ++++++++++++++++++++++++++++++++
 5 files changed, 144 insertions(+)
 create mode 100644 drivers/net/wireless/ath/ath9k/rng.c

diff --git a/drivers/net/wireless/ath/ath9k/Kconfig b/drivers/net/wireless/ath/ath9k/Kconfig
index fee0cad..40fa915 100644
--- a/drivers/net/wireless/ath/ath9k/Kconfig
+++ b/drivers/net/wireless/ath/ath9k/Kconfig
@@ -176,3 +176,14 @@ config ATH9K_HTC_DEBUGFS
 	depends on ATH9K_HTC && DEBUG_FS
 	---help---
 	  Say Y, if you need access to ath9k_htc's statistics.
+
+config ATH9K_HWRNG
+	bool "Random number generator support"
+	depends on ATH9K && (HW_RANDOM = y || HW_RANDOM = ATH9K)
+	default y
+	---help---
+	  This option incorporates the ADC register output as a source of
+	  randomness into Linux entropy pool (/dev/urandom and /dev/random)
+
+	  Say Y, feeds the entropy directly from the WiFi driver to the input
+	  pool.
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
index c85c479..cd74f68 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -23,6 +23,7 @@
 #include <linux/leds.h>
 #include <linux/completion.h>
 #include <linux/time.h>
+#include <linux/hw_random.h>
 
 #include "common.h"
 #include "debug.h"
@@ -1039,6 +1040,11 @@ struct ath_softc {
 	u32 wow_intr_before_sleep;
 	bool force_wow;
 #endif
+
+#ifdef CONFIG_ATH9K_HWRNG
+	u32 rng_last;
+	struct task_struct *rng_task;
+#endif
 };
 
 /********/
@@ -1061,6 +1067,22 @@ static inline int ath9k_tx99_send(struct ath_softc *sc,  }  #endif /* CONFIG_ATH9K_TX99 */
 
+/***************************/
+/* Random Number Generator */
+/***************************/
+#ifdef CONFIG_ATH9K_HWRNG
+void ath9k_rng_start(struct ath_softc *sc); void ath9k_rng_stop(struct 
+ath_softc *sc); #else static inline void ath9k_rng_start(struct 
+ath_softc *sc) { }
+
+static inline void ath9k_rng_stop(struct ath_softc *sc) { } #endif
+
 static inline void ath_read_cachesize(struct ath_common *common, int *csz)  {
 	common->bus_ops->read_cachesize(common, csz); diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 323eb33..39ba17f 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -739,6 +739,8 @@ static int ath9k_start(struct ieee80211_hw *hw)
 
 	ath9k_ps_restore(sc);
 
+	ath9k_rng_start(sc);
+
 	return 0;
 }
 
@@ -828,6 +830,8 @@ static void ath9k_stop(struct ieee80211_hw *hw)
 
 	ath9k_deinit_channel_context(sc);
 
+	ath9k_rng_stop(sc);
+
 	mutex_lock(&sc->mutex);
 
 	ath_cancel_work(sc);
diff --git a/drivers/net/wireless/ath/ath9k/rng.c b/drivers/net/wireless/ath/ath9k/rng.c
new file mode 100644
index 0000000..93a7485
--- /dev/null
+++ b/drivers/net/wireless/ath/ath9k/rng.c
@@ -0,0 +1,106 @@
+/*
+ * Copyright (c) 2015 Qualcomm Atheros, Inc.
+ *
+ * Permission to use, copy, modify, and/or distribute this software for 
+any
+ * purpose with or without fee is hereby granted, provided that the 
+above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL 
+WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE 
+FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY 
+DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN 
+AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT 
+OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#include <linux/hw_random.h>
+#include <linux/kthread.h>
+
+#include "ath9k.h"
+#include "hw.h"
+#include "ar9003_phy.h"
+
+#define ATH9K_RNG_BUF_SIZE	320
+#define ATH9K_RNG_ENTROPY(x)	(((x) * 8 * 320) >> 10) /* quality: 320/1024 */
+
+static int ath9k_rng_data_read(struct ath_softc *sc, u32 *buf, u32 
+buf_size) {
+	int i, j;
+	u32  v1, v2, rng_last = sc->rng_last;
+	struct ath_hw *ah = sc->sc_ah;
+
+	ath9k_ps_wakeup(sc);
+
+	REG_RMW_FIELD(ah, AR_PHY_TEST, AR_PHY_TEST_BBB_OBS_SEL, 1);
+	REG_CLR_BIT(ah, AR_PHY_TEST, AR_PHY_TEST_RX_OBS_SEL_BIT5);
+	REG_RMW_FIELD(ah, AR_PHY_TEST_CTL_STATUS, AR_PHY_TEST_CTL_RX_OBS_SEL, 
+0);
+
+	for (i = 0, j = 0; i < buf_size; i++) {
+		v1 = REG_READ(ah, AR_PHY_TST_ADC) & 0xffff;
+		v2 = REG_READ(ah, AR_PHY_TST_ADC) & 0xffff;
+
+		/* wait for data ready */
+		if (v1 && v2 && rng_last != v1 && v1 != v2 && v1 != 0xffff &&
+		    v2 != 0xffff)
+			buf[j++] = (v1 << 16) | v2;
+
+		rng_last = v2;
+	}
+
+	ath9k_ps_restore(sc);
+
+	sc->rng_last = rng_last;
+
+	return j << 2;
+}
+
+static int ath9k_rng_kthread(void *data) {
+	int bytes_read;
+	struct ath_softc *sc = data;
+	u32 *rng_buf;
+
+	rng_buf = kmalloc_array(ATH9K_RNG_BUF_SIZE, sizeof(u32), GFP_KERNEL);
+	if (!rng_buf)
+		goto out;
+
+	while (!kthread_should_stop()) {
+		bytes_read = ath9k_rng_data_read(sc, rng_buf,
+						 ATH9K_RNG_BUF_SIZE);
+		if (!bytes_read) {
+			msleep_interruptible(10);
+			continue;
+		}
+
+		add_hwgenerator_randomness((void *)rng_buf, bytes_read,
+					   ATH9K_RNG_ENTROPY(bytes_read));
+	}
+
+	kfree(rng_buf);
+out:
+	sc->rng_task = NULL;
+
+	return 0;
+}
+
+void ath9k_rng_start(struct ath_softc *sc) {
+	struct ath_hw *ah = sc->sc_ah;
+
+	if (sc->rng_task)
+		return;
+
+	if (!AR_SREV_9300_20_OR_LATER(ah))
+		return;
+
+	sc->rng_task = kthread_run(ath9k_rng_kthread, sc, "ath9k-hwrng");
+	if (IS_ERR(sc->rng_task))
+		sc->rng_task = NULL;
+}
+
+void ath9k_rng_stop(struct ath_softc *sc) {
+	if (sc->rng_task)
+		kthread_stop(sc->rng_task);
+}
--
1.9.1

