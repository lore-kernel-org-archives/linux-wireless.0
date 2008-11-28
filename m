Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:20269 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752133AbYK1QwF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Nov 2008 11:52:05 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 28 Nov 2008 08:52:05 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18736.8446.364863.337541@gargle.gargle.HOWL> (sfid-20081128_175212_983111_D0FD0E14)
Date: Fri, 28 Nov 2008 22:19:02 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 2/5] ath9k: Add ATH9K_DEBUG configuration option
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Make debugging configurable, and add a module parameter
to give the debug mask.
Add debug.c to hold all debug specific code.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/Kconfig  |   11 +++++++++
 drivers/net/wireless/ath9k/Makefile |    2 +
 drivers/net/wireless/ath9k/core.h   |   21 +++++++++++++++++-
 drivers/net/wireless/ath9k/debug.c  |   40 +++++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath9k/main.c   |   18 +--------------
 5 files changed, 75 insertions(+), 17 deletions(-)
 create mode 100644 drivers/net/wireless/ath9k/debug.c

diff --git a/drivers/net/wireless/ath9k/Kconfig b/drivers/net/wireless/ath9k/Kconfig
index 80a6924..c43bd32 100644
--- a/drivers/net/wireless/ath9k/Kconfig
+++ b/drivers/net/wireless/ath9k/Kconfig
@@ -9,3 +9,14 @@ config ATH9K
 	  Atheros IEEE 802.11n AR5008 and AR9001 family of chipsets.
 
 	  If you choose to build a module, it'll be called ath9k.
+
+config ATH9K_DEBUG
+	bool "Atheros ath9k debugging"
+	depends on ATH9K
+	---help---
+	  Say Y, if you need ath9k to display debug messages.
+	  Pass the debug mask as a module parameter:
+
+	  modprobe ath9k debug=0x00002000
+
+	  Look in ath9k/core.h for possible debug masks
diff --git a/drivers/net/wireless/ath9k/Makefile b/drivers/net/wireless/ath9k/Makefile
index c741e8d..1209d14 100644
--- a/drivers/net/wireless/ath9k/Makefile
+++ b/drivers/net/wireless/ath9k/Makefile
@@ -11,4 +11,6 @@ ath9k-y +=	hw.o \
 		xmit.o \
 		rc.o
 
+ath9k-$(CONFIG_ATH9K_DEBUG) += debug.o
+
 obj-$(CONFIG_ATH9K) += ath9k.o
diff --git a/drivers/net/wireless/ath9k/core.h b/drivers/net/wireless/ath9k/core.h
index ae32b2c..50bef47 100644
--- a/drivers/net/wireless/ath9k/core.h
+++ b/drivers/net/wireless/ath9k/core.h
@@ -105,6 +105,24 @@ enum ATH_DEBUG {
 
 #define DBG_DEFAULT (ATH_DBG_FATAL)
 
+#ifdef CONFIG_ATH9K_DEBUG
+
+void DPRINTF(struct ath_softc *sc, int dbg_mask, const char *fmt, ...);
+void ath9k_init_debug(struct ath_softc *sc);
+
+#else
+
+static inline void DPRINTF(struct ath_softc *sc, int dbg_mask,
+			   const char *fmt, ...)
+{
+}
+
+static inline ath9k_init_debug(struct ath_softc *sc)
+{
+}
+
+#endif
+
 struct ath_config {
 	u32 ath_aggr_prot;
 	u16 txpowlimit;
@@ -619,7 +637,9 @@ struct ath_softc {
 	u8 sc_myaddr[ETH_ALEN];
 	u8 sc_bssidmask[ETH_ALEN];
 
+#ifdef CONFIG_ATH9K_DEBUG
 	int sc_debug;
+#endif
 	u32 sc_intrstatus;
 	u32 sc_flags; /* SC_OP_* */
 	unsigned int rx_filter;
@@ -713,7 +733,6 @@ struct ath_softc {
 	struct ath_ani sc_ani;
 };
 
-void DPRINTF(struct ath_softc *sc, int dbg_mask, const char *fmt, ...);
 int ath_reset(struct ath_softc *sc, bool retry_tx);
 int ath_get_hal_qnum(u16 queue, struct ath_softc *sc);
 int ath_get_mac80211_qnum(u32 queue, struct ath_softc *sc);
diff --git a/drivers/net/wireless/ath9k/debug.c b/drivers/net/wireless/ath9k/debug.c
new file mode 100644
index 0000000..31af7cc
--- /dev/null
+++ b/drivers/net/wireless/ath9k/debug.c
@@ -0,0 +1,40 @@
+/*
+ * Copyright (c) 2008 Atheros Communications Inc.
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
+#include "core.h"
+
+static unsigned int ath9k_debug = DBG_DEFAULT;
+module_param_named(debug, ath9k_debug, uint, 0);
+
+void DPRINTF(struct ath_softc *sc, int dbg_mask, const char *fmt, ...)
+{
+	if (!sc)
+		return;
+
+	if (sc->sc_debug & dbg_mask) {
+		va_list args;
+
+		va_start(args, fmt);
+		printk(KERN_DEBUG "ath9k: ");
+		vprintk(fmt, args);
+		va_end(args);
+	}
+}
+
+void ath9k_init_debug(struct ath_softc *sc)
+{
+	sc->sc_debug = ath9k_debug;
+}
diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index 4fbe34e..6e624be 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -38,21 +38,6 @@ static struct pci_device_id ath_pci_id_table[] __devinitdata = {
 
 static void ath_detach(struct ath_softc *sc);
 
-void DPRINTF(struct ath_softc *sc, int dbg_mask, const char *fmt, ...)
-{
-	if (!sc)
-		return;
-
-	if (sc->sc_debug & dbg_mask) {
-		va_list args;
-
-		va_start(args, fmt);
-		printk(KERN_DEBUG "ath9k: ");
-		vprintk(fmt, args);
-		va_end(args);
-	}
-}
-
 /* return bus cachesize in 4B word units */
 
 static void bus_read_cachesize(struct ath_softc *sc, int *csz)
@@ -1326,7 +1311,8 @@ static int ath_init(u16 devid, struct ath_softc *sc)
 
 	/* XXX: hardware will not be ready until ath_open() being called */
 	sc->sc_flags |= SC_OP_INVALID;
-	sc->sc_debug = DBG_DEFAULT;
+
+	ath9k_init_debug(sc);
 
 	spin_lock_init(&sc->sc_resetlock);
 	tasklet_init(&sc->intr_tq, ath9k_tasklet, (unsigned long)sc);
-- 
1.6.0.3

