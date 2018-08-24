Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:60896 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726860AbeHXOtr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Aug 2018 10:49:47 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>,
        linux-mediatek@lists.infradead.org,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 01/17] mt76: unify wait_for_mac
Date: Fri, 24 Aug 2018 13:15:05 +0200
Message-Id: <1535109321-17126-2-git-send-email-sgruszka@redhat.com> (sfid-20180824_131539_103543_CDF4F9F5)
In-Reply-To: <1535109321-17126-1-git-send-email-sgruszka@redhat.com>
References: <1535109321-17126-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Create new mt76xx_mac.h for common mac functions of mt76x0 and mt76x2
and unity wait_for_mac for both drivers.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/init.c   | 11 +++---
 drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h |  3 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/usb.c    |  5 +--
 drivers/net/wireless/mediatek/mt76/mt76x2.h        | 17 ---------
 drivers/net/wireless/mediatek/mt76/mt76x2_init.c   |  2 +-
 drivers/net/wireless/mediatek/mt76/mt76x2_mac.h    |  1 +
 drivers/net/wireless/mediatek/mt76/mt76x2u_init.c  |  4 +--
 drivers/net/wireless/mediatek/mt76/mt76xx_mac.h    | 42 ++++++++++++++++++++++
 8 files changed, 57 insertions(+), 28 deletions(-)
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76xx_mac.h

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
index 7cdb3e740522..f6e9ef300761 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
@@ -384,9 +384,11 @@ int mt76x0_init_hardware(struct mt76x0_dev *dev)
 
 	mt76x0_chip_onoff(dev, true, true);
 
-	ret = mt76x0_wait_asic_ready(dev);
-	if (ret)
+	if (!mt76xx_wait_for_mac(&dev->mt76)) {
+		ret = -ETIMEDOUT;
 		goto err;
+	}
+
 	ret = mt76x0_mcu_init(dev);
 	if (ret)
 		goto err;
@@ -399,9 +401,10 @@ int mt76x0_init_hardware(struct mt76x0_dev *dev)
 	}
 
 	/* Wait for ASIC ready after FW load. */
-	ret = mt76x0_wait_asic_ready(dev);
-	if (ret)
+	if (!mt76xx_wait_for_mac(&dev->mt76)) {
+		ret = -ETIMEDOUT;
 		goto err;
+	}
 
 	mt76x0_reset_csr_bbp(dev);
 	mt76x0_init_usb_dma(dev);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
index fc9857f61771..83aabb60eed8 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
@@ -26,6 +26,7 @@
 #include <linux/debugfs.h>
 
 #include "../mt76.h"
+#include "../mt76xx_mac.h"
 #include "regs.h"
 
 #define MT_CALIBRATE_INTERVAL		(4 * HZ)
@@ -263,8 +264,6 @@ static inline bool is_mt7610e(struct mt76x0_dev *dev)
 
 void mt76x0_init_debugfs(struct mt76x0_dev *dev);
 
-int mt76x0_wait_asic_ready(struct mt76x0_dev *dev);
-
 /* Compatibility with mt76 */
 #define mt76_rmw_field(_dev, _reg, _field, _val)	\
 	mt76_rmw(_dev, _reg, _field, FIELD_PREP(_field, _val))
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
index 54ae1f113be2..d535012c506e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
@@ -287,9 +287,10 @@ static int mt76x0_probe(struct usb_interface *usb_intf,
 	/* Disable the HW, otherwise MCU fail to initalize on hot reboot */
 	mt76x0_chip_onoff(dev, false, false);
 
-	ret = mt76x0_wait_asic_ready(dev);
-	if (ret)
+	if (!mt76xx_wait_for_mac(&dev->mt76)) {
+		ret = -ETIMEDOUT;
 		goto err;
+	}
 
 	asic_rev = mt76_rr(dev, MT_ASIC_VERSION);
 	mac_rev = mt76_rr(dev, MT_MAC_CSR0);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2.h b/drivers/net/wireless/mediatek/mt76/mt76x2.h
index dca3209bf5f1..4c952b8a777c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2.h
@@ -163,23 +163,6 @@ struct mt76x2_sta {
 	int inactive_count;
 };
 
-static inline bool mt76x2_wait_for_mac(struct mt76x2_dev *dev)
-{
-	int i;
-
-	for (i = 0; i < 500; i++) {
-		switch (mt76_rr(dev, MT_MAC_CSR0)) {
-		case 0:
-		case ~0:
-			break;
-		default:
-			return true;
-		}
-		usleep_range(5000, 10000);
-	}
-	return false;
-}
-
 static inline bool is_mt7612(struct mt76x2_dev *dev)
 {
 	return mt76_chip(&dev->mt76) == 0x7612;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
index b814391f79ac..d3c846e5504d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
@@ -101,7 +101,7 @@ static int mt76x2_mac_reset(struct mt76x2_dev *dev, bool hard)
 	u32 val;
 	int i, k;
 
-	if (!mt76x2_wait_for_mac(dev))
+	if (!mt76xx_wait_for_mac(&dev->mt76))
 		return -ETIMEDOUT;
 
 	val = mt76_rr(dev, MT_WPDMA_GLO_CFG);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_mac.h b/drivers/net/wireless/mediatek/mt76/mt76x2_mac.h
index 5af0107ba748..b692208880c4 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_mac.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_mac.h
@@ -18,6 +18,7 @@
 #define __MT76x2_MAC_H
 
 #include "mt76.h"
+#include "mt76xx_mac.h"
 
 struct mt76x2_dev;
 struct mt76x2_sta;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2u_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2u_init.c
index 9b81e7641c06..3c5712f04184 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2u_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2u_init.c
@@ -184,7 +184,7 @@ int mt76x2u_init_hardware(struct mt76x2_dev *dev)
 	mt76x2_reset_wlan(dev, true);
 	mt76x2u_power_on(dev);
 
-	if (!mt76x2_wait_for_mac(dev))
+	if (!mt76xx_wait_for_mac(&dev->mt76))
 		return -ETIMEDOUT;
 
 	err = mt76x2u_mcu_fw_init(dev);
@@ -197,7 +197,7 @@ int mt76x2u_init_hardware(struct mt76x2_dev *dev)
 		return -EIO;
 
 	/* wait for asic ready after fw load. */
-	if (!mt76x2_wait_for_mac(dev))
+	if (!mt76xx_wait_for_mac(&dev->mt76))
 		return -ETIMEDOUT;
 
 	mt76_wr(dev, MT_HEADER_TRANS_CTRL_REG, 0);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76xx_mac.h b/drivers/net/wireless/mediatek/mt76/mt76xx_mac.h
new file mode 100644
index 000000000000..177f8770136f
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/mt76xx_mac.h
@@ -0,0 +1,42 @@
+/*
+ * Copyright (C) 2016 Felix Fietkau <nbd@nbd.name>
+ * Copyright (C) 2018 Stanislaw Gruszka <stf_xl@wp.pl>
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
+#ifndef __MT76XX_MAC_H
+#define __MT76XX_MAC_H
+
+static inline bool mt76xx_wait_for_mac(struct mt76_dev *dev)
+{
+	const u32 MAC_CSR0 = 0x1000;
+	int i;
+
+	for (i = 0; i < 500; i++) {
+		if (test_bit(MT76_REMOVED, &dev->state))
+			return -EIO;
+
+		switch (dev->bus->rr(dev, MAC_CSR0)) {
+		case 0:
+		case ~0:
+			break;
+		default:
+			return true;
+		}
+		usleep_range(5000, 10000);
+	}
+	return false;
+}
+
+#endif
-- 
1.9.3
