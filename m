Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:45796 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751618AbZHZPrF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Aug 2009 11:47:05 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 26 Aug 2009 08:47:08 -0700
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Luis.Rodriguez@atheros.com>,
	<Jouni.Malinen@atheros.com>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH 2/8] ath9k: Move btcoex stuff from hw.[ch] to new btcoex.[ch]
Date: Wed, 26 Aug 2009 21:08:44 +0530
Message-ID: <1251301130-10912-3-git-send-email-vasanth@atheros.com>
In-Reply-To: <1251301130-10912-2-git-send-email-vasanth@atheros.com>
References: <1251301130-10912-1-git-send-email-vasanth@atheros.com>
 <1251301130-10912-2-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/Makefile |    3 +-
 drivers/net/wireless/ath/ath9k/ath9k.h  |    1 +
 drivers/net/wireless/ath/ath9k/btcoex.c |   55 +++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/btcoex.h |   24 +++++++++++++
 drivers/net/wireless/ath/ath9k/hw.c     |   42 -----------------------
 drivers/net/wireless/ath/ath9k/hw.h     |    4 --
 6 files changed, 82 insertions(+), 47 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath9k/btcoex.c
 create mode 100644 drivers/net/wireless/ath/ath9k/btcoex.h

diff --git a/drivers/net/wireless/ath/ath9k/Makefile b/drivers/net/wireless/ath/ath9k/Makefile
index 28443e0..ff2c9a2 100644
--- a/drivers/net/wireless/ath/ath9k/Makefile
+++ b/drivers/net/wireless/ath/ath9k/Makefile
@@ -12,7 +12,8 @@ ath9k-y +=	hw.o \
 		recv.o \
 		xmit.o \
 		virtual.o \
-		rc.o
+		rc.o \
+		btcoex.o
 
 ath9k-$(CONFIG_PCI) += pci.o
 ath9k-$(CONFIG_ATHEROS_AR71XX) += ahb.o
diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 0868800..1a8d679 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -26,6 +26,7 @@
 #include "rc.h"
 #include "debug.h"
 #include "../ath.h"
+#include "btcoex.h"
 
 struct ath_node;
 
diff --git a/drivers/net/wireless/ath/ath9k/btcoex.c b/drivers/net/wireless/ath/ath9k/btcoex.c
new file mode 100644
index 0000000..abaf92d
--- /dev/null
+++ b/drivers/net/wireless/ath/ath9k/btcoex.c
@@ -0,0 +1,55 @@
+/*
+ * Copyright (c) 2009 Atheros Communications Inc.
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
+
+void ath9k_hw_btcoex_init(struct ath_hw *ah)
+{
+	/* connect bt_active to baseband */
+	REG_CLR_BIT(ah, AR_GPIO_INPUT_EN_VAL,
+			(AR_GPIO_INPUT_EN_VAL_BT_PRIORITY_DEF |
+			 AR_GPIO_INPUT_EN_VAL_BT_FREQUENCY_DEF));
+
+	REG_SET_BIT(ah, AR_GPIO_INPUT_EN_VAL,
+			AR_GPIO_INPUT_EN_VAL_BT_ACTIVE_BB);
+
+	/* Set input mux for bt_active to gpio pin */
+	REG_RMW_FIELD(ah, AR_GPIO_INPUT_MUX1,
+			AR_GPIO_INPUT_MUX1_BT_ACTIVE,
+			ah->btactive_gpio);
+
+	/* Configure the desired gpio port for input */
+	ath9k_hw_cfg_gpio_input(ah, ah->btactive_gpio);
+}
+
+void ath9k_hw_btcoex_enable(struct ath_hw *ah)
+{
+	/* Configure the desired GPIO port for TX_FRAME output */
+	ath9k_hw_cfg_output(ah, ah->wlanactive_gpio,
+			    AR_GPIO_OUTPUT_MUX_AS_TX_FRAME);
+
+	ah->ah_sc->sc_flags |= SC_OP_BTCOEX_ENABLED;
+}
+
+void ath9k_hw_btcoex_disable(struct ath_hw *ah)
+{
+	ath9k_hw_set_gpio(ah, ah->wlanactive_gpio, 0);
+
+	ath9k_hw_cfg_output(ah, ah->wlanactive_gpio,
+			AR_GPIO_OUTPUT_MUX_AS_OUTPUT);
+
+	ah->ah_sc->sc_flags &= ~SC_OP_BTCOEX_ENABLED;
+}
diff --git a/drivers/net/wireless/ath/ath9k/btcoex.h b/drivers/net/wireless/ath/ath9k/btcoex.h
new file mode 100644
index 0000000..9954280
--- /dev/null
+++ b/drivers/net/wireless/ath/ath9k/btcoex.h
@@ -0,0 +1,24 @@
+/*
+ * Copyright (c) 2009 Atheros Communications Inc.
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
+#ifndef BTCOEX_H
+#define BTCOEX_H
+
+void ath9k_hw_btcoex_init(struct ath_hw *ah);
+void ath9k_hw_btcoex_enable(struct ath_hw *ah);
+void ath9k_hw_btcoex_disable(struct ath_hw *ah);
+
+#endif
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index d81e826..c3ecc7e 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -4068,45 +4068,3 @@ void ath9k_hw_set11nmac2040(struct ath_hw *ah, enum ath9k_ht_macmode mode)
 
 	REG_WRITE(ah, AR_2040_MODE, macmode);
 }
-
-/***************************/
-/*  Bluetooth Coexistence  */
-/***************************/
-
-void ath9k_hw_btcoex_init(struct ath_hw *ah)
-{
-	/* connect bt_active to baseband */
-	REG_CLR_BIT(ah, AR_GPIO_INPUT_EN_VAL,
-			(AR_GPIO_INPUT_EN_VAL_BT_PRIORITY_DEF |
-			 AR_GPIO_INPUT_EN_VAL_BT_FREQUENCY_DEF));
-
-	REG_SET_BIT(ah, AR_GPIO_INPUT_EN_VAL,
-			AR_GPIO_INPUT_EN_VAL_BT_ACTIVE_BB);
-
-	/* Set input mux for bt_active to gpio pin */
-	REG_RMW_FIELD(ah, AR_GPIO_INPUT_MUX1,
-			AR_GPIO_INPUT_MUX1_BT_ACTIVE,
-			ah->btactive_gpio);
-
-	/* Configure the desired gpio port for input */
-	ath9k_hw_cfg_gpio_input(ah, ah->btactive_gpio);
-}
-
-void ath9k_hw_btcoex_enable(struct ath_hw *ah)
-{
-	/* Configure the desired GPIO port for TX_FRAME output */
-	ath9k_hw_cfg_output(ah, ah->wlanactive_gpio,
-			    AR_GPIO_OUTPUT_MUX_AS_TX_FRAME);
-
-	ah->ah_sc->sc_flags |= SC_OP_BTCOEX_ENABLED;
-}
-
-void ath9k_hw_btcoex_disable(struct ath_hw *ah)
-{
-	ath9k_hw_set_gpio(ah, ah->wlanactive_gpio, 0);
-
-	ath9k_hw_cfg_output(ah, ah->wlanactive_gpio,
-			AR_GPIO_OUTPUT_MUX_AS_OUTPUT);
-
-	ah->ah_sc->sc_flags &= ~SC_OP_BTCOEX_ENABLED;
-}
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index e634cb4..32f7c4b 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -614,8 +614,4 @@ bool ath9k_hw_intrpend(struct ath_hw *ah);
 bool ath9k_hw_getisr(struct ath_hw *ah, enum ath9k_int *masked);
 enum ath9k_int ath9k_hw_set_interrupts(struct ath_hw *ah, enum ath9k_int ints);
 
-void ath9k_hw_btcoex_init(struct ath_hw *ah);
-void ath9k_hw_btcoex_enable(struct ath_hw *ah);
-void ath9k_hw_btcoex_disable(struct ath_hw *ah);
-
 #endif
-- 
1.5.5.1

