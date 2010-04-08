Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:46737 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933215Ab0DHT1k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Apr 2010 15:27:40 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>
Subject: [PATCH 021/102] ath9k_hw: Fill rx_enable() for the AR9003 hardware family
Date: Thu,  8 Apr 2010 15:26:17 -0400
Message-Id: <1270754858-26266-22-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1270754858-26266-1-git-send-email-lrodriguez@atheros.com>
References: <1270754858-26266-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Vasanthakumar Thiagarajan <vasanth@atheros.com>

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/Makefile     |    1 +
 drivers/net/wireless/ath/ath9k/ar9003_mac.c |   28 +++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/ar9003_mac.h |    1 +
 drivers/net/wireless/ath/ath9k/hw.c         |    5 +++-
 4 files changed, 34 insertions(+), 1 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath9k/ar9003_mac.c

diff --git a/drivers/net/wireless/ath/ath9k/Makefile b/drivers/net/wireless/ath/ath9k/Makefile
index ecf3f8c..96af3d9 100644
--- a/drivers/net/wireless/ath/ath9k/Makefile
+++ b/drivers/net/wireless/ath/ath9k/Makefile
@@ -25,6 +25,7 @@ ath9k_hw-y:=	hw.o \
 		ani.o \
 		btcoex.o \
 		mac.o \
+		ar9003_mac.o
 
 obj-$(CONFIG_ATH9K_HW) += ath9k_hw.o
 
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mac.c b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
new file mode 100644
index 0000000..ee84e64
--- /dev/null
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
@@ -0,0 +1,28 @@
+/*
+ * Copyright (c) 2010 Atheros Communications Inc.
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
+#include "hw.h"
+
+static void ar9003_hw_rx_enable(struct ath_hw *hw)
+{
+	REG_WRITE(hw, AR_CR, 0);
+}
+
+void ar9003_hw_attach_mac_ops(struct ath_hw *hw)
+{
+	struct ath_hw_ops *ops = ath9k_hw_ops(hw);
+
+	ops->rx_enable = ar9003_hw_rx_enable;
+}
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mac.h b/drivers/net/wireless/ath/ath9k/ar9003_mac.h
index 90c5ff0..a468c3d 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mac.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mac.h
@@ -32,4 +32,5 @@ struct ar9300_rxs {
 	u32 status11;
 } __packed;
 
+void ar9003_hw_attach_mac_ops(struct ath_hw *hw);
 #endif
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 6eb6f1f..6d2ec20 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1613,7 +1613,10 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 	if (tsf && AR_SREV_9280(ah) && ah->eep_ops->get_eeprom(ah, EEP_OL_PWRCTRL))
 		ath9k_hw_settsf64(ah, tsf);
 
-	ar9002_hw_attach_mac_ops(ah);
+	if (AR_SREV_9300_20_OR_LATER(ah))
+		ar9003_hw_attach_mac_ops(ah);
+	else
+		ar9002_hw_attach_mac_ops(ah);
 
 	if (AR_SREV_9280_10_OR_LATER(ah))
 		REG_SET_BIT(ah, AR_GPIO_INPUT_EN_VAL, AR_GPIO_JTAG_DISABLE);
-- 
1.6.3.3

