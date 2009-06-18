Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:3041 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753380AbZFRC0H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Jun 2009 22:26:07 -0400
Date: Wed, 17 Jun 2009 22:25:24 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Pierre Ossman <pierre@ossman.eu>
Cc: Kalle Valo <kalle.valo@iki.fi>, linux-wireless@vger.kernel.org,
	san@google.com
Subject: Re: [PATCH/RFC 7/7] wl12xx: add sdio support
Message-ID: <20090618022524.GC10014@hash.localnet>
References: <1244685780-28930-1-git-send-email-me@bobcopeland.com> <1244685780-28930-8-git-send-email-me@bobcopeland.com> <20090613132144.6c7783bc@mjolnir.ossman.eu> <87bposnmxi.fsf@litku.valot.fi> <20090613220908.271865cd@mjolnir.ossman.eu> <20090613205737.GA30439@hash.localnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090613205737.GA30439@hash.localnet>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jun 13, 2009 at 04:57:37PM -0400, Bob Copeland wrote:
> > I think this should be somewhere under arch/ in the board setup code,
> > where currently you have some code adding the "msm_wifi" platform
> > device.
> 
> Yeah, in fact I tried that a while ago but something didn't work right,
> some ordering issue perhaps.  I'll try again.

Just to follow up now that I've tested that again: the issue is msm_wifi
setup loads before the mmc host driver, which interferes with mounting the
sdcard in the other slot.  There's also some platform code in the host
driver that registers callbacks when the wifi driver is loaded, presumably
to avoid using a timer for card detect.

Anyway, this is only compile tested but should work when we get all that
sorted...

v3:
  * remove platform junk
  * fix ordering of remove()
  * move IDs to sdio_ids.h
  * remove sdio_set_block_size() call

From: Bob Copeland <me@bobcopeland.com>
Date: Sat, 30 May 2009 13:50:29 -0400
Subject: [PATCH] wl12xx: add sdio support

This adds the wl12xx_sdio module, enabling the SDIO interface for
wl12xx, as used by the Google G1 phone and others.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---

 drivers/net/wireless/wl12xx/Kconfig  |   11 ++
 drivers/net/wireless/wl12xx/Makefile |    2 +
 drivers/net/wireless/wl12xx/sdio.c   |  180 ++++++++++++++++++++++++++++++++++
 include/linux/mmc/sdio_ids.h         |    3 +
 4 files changed, 196 insertions(+), 0 deletions(-)
 create mode 100644 drivers/net/wireless/wl12xx/sdio.c

diff --git a/drivers/net/wireless/wl12xx/Kconfig b/drivers/net/wireless/wl12xx/Kconfig
index 9575d16..c4af50a 100644
--- a/drivers/net/wireless/wl12xx/Kconfig
+++ b/drivers/net/wireless/wl12xx/Kconfig
@@ -20,3 +20,14 @@ config WL12XX_SPI
 
 	  If you choose to build a module, it'll be called wl12xx_spi. Say N if
 	  unsure.
+
+config WL12XX_SDIO
+	tristate "TI wl1251/wl1271 SDIO support"
+	depends on WL12XX && MMC
+	---help---
+	  This module adds support for the SDIO interface of adapters using
+	  TI wl1251/wl1271 chipsets.  Select this if your platform is using
+	  the SDIO bus.
+
+	  If you choose to build a module, it'll be called wl12xx_sdio. Say N if
+	  unsure.
diff --git a/drivers/net/wireless/wl12xx/Makefile b/drivers/net/wireless/wl12xx/Makefile
index ffd5664..25df712 100644
--- a/drivers/net/wireless/wl12xx/Makefile
+++ b/drivers/net/wireless/wl12xx/Makefile
@@ -3,6 +3,8 @@ wl12xx-objs		= main.o event.o tx.o rx.o \
 			  debugfs.o io.o
 
 wl12xx_spi-objs		+= spi.o
+wl12xx_sdio-objs	+= sdio.o
 
 obj-$(CONFIG_WL12XX)	+= wl12xx.o
 obj-$(CONFIG_WL12XX_SPI)	+= wl12xx_spi.o
+obj-$(CONFIG_WL12XX_SDIO)	+= wl12xx_sdio.o
diff --git a/drivers/net/wireless/wl12xx/sdio.c b/drivers/net/wireless/wl12xx/sdio.c
new file mode 100644
index 0000000..afe6bd4
--- /dev/null
+++ b/drivers/net/wireless/wl12xx/sdio.c
@@ -0,0 +1,180 @@
+/*
+ * wl12xx SDIO routines
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ * Copyright (C) 2005 Texas Instruments Incorporated
+ * Copyright (C) 2008 Google Inc
+ * Copyright (C) 2009 Bob Copeland (me@bobcopeland.com)
+ */
+#include <linux/module.h>
+#include <linux/crc7.h>
+#include <linux/mod_devicetable.h>
+#include <linux/irq.h>
+#include <linux/mmc/sdio_func.h>
+#include <linux/mmc/sdio_ids.h>
+#include <linux/platform_device.h>
+
+#include "wl12xx.h"
+#include "wl12xx_80211.h"
+#include "reg.h"
+#include "ps.h"
+#include "io.h"
+#include "tx.h"
+#include "debugfs.h"
+
+static struct sdio_func *wl_to_func(struct wl12xx *wl)
+{
+	return wl->if_priv;
+}
+
+static void wl12xx_sdio_interrupt(struct sdio_func *func)
+{
+	wl12xx_irq(0, sdio_get_drvdata(func));
+}
+
+static const struct sdio_device_id wl12xx_devices[] = {
+	{ SDIO_DEVICE(SDIO_VENDOR_ID_TI, SDIO_DEVICE_ID_TI_WL1251) },
+	{}
+};
+MODULE_DEVICE_TABLE(sdio, wl12xx_devices);
+
+
+void wl12xx_sdio_read(struct wl12xx *wl, int addr, void *buf, size_t len)
+{
+	int ret;
+	struct sdio_func *func = wl_to_func(wl);
+
+	sdio_claim_host(func);
+	ret = sdio_memcpy_fromio(func, buf, addr, len);
+	if (ret)
+		wl12xx_error("sdio read failed (%d)", ret);
+	sdio_release_host(func);
+}
+
+void wl12xx_sdio_write(struct wl12xx *wl, int addr, void *buf, size_t len)
+{
+	int ret;
+	struct sdio_func *func = wl_to_func(wl);
+
+	sdio_claim_host(func);
+	ret = sdio_memcpy_toio(func, addr, buf, len);
+	if (ret)
+		wl12xx_error("sdio write failed (%d)", ret);
+	sdio_release_host(func);
+}
+
+void wl12xx_sdio_reset(struct wl12xx *wl)
+{
+}
+
+void wl12xx_sdio_set_power(bool enable)
+{
+}
+
+struct wl12xx_if_operations wl12xx_sdio_ops = {
+	.read = wl12xx_sdio_read,
+	.write = wl12xx_sdio_write,
+	.reset = wl12xx_sdio_reset,
+};
+
+int wl12xx_sdio_probe(struct sdio_func *func, const struct sdio_device_id *id)
+{
+	int ret;
+	struct wl12xx *wl;
+	struct ieee80211_hw *hw;
+
+	printk(KERN_DEBUG "wl12xx: in probe\n");
+
+	hw = wl12xx_alloc_hw();
+	if (IS_ERR(hw))
+		return PTR_ERR(hw);
+
+	wl = hw->priv;
+
+	sdio_claim_host(func);
+	ret = sdio_enable_func(func);
+	if (ret)
+		goto release;
+
+	SET_IEEE80211_DEV(hw, &func->dev);
+	wl->if_priv = func;
+	wl->if_ops = &wl12xx_sdio_ops;
+	wl->set_power = wl12xx_sdio_set_power;
+
+	sdio_release_host(func);
+	ret = wl12xx_init_ieee80211(wl);
+	sdio_claim_host(func);
+	if (ret)
+		goto disable;
+
+	ret = sdio_claim_irq(func, wl12xx_sdio_interrupt);
+	if (ret)
+		goto no_irq;
+
+	sdio_release_host(func);
+	sdio_set_drvdata(func, wl);
+	return ret;
+
+no_irq:
+	wl12xx_free_hw(wl);
+disable:
+	sdio_disable_func(func);
+release:
+	sdio_release_host(func);
+	return ret;
+}
+
+static void __devexit wl12xx_sdio_remove(struct sdio_func *func)
+{
+	struct wl12xx *wl = sdio_get_drvdata(func);
+
+	wl12xx_free_hw(wl);
+
+	sdio_claim_host(func);
+	sdio_release_irq(func);
+	sdio_disable_func(func);
+	sdio_release_host(func);
+}
+
+static struct sdio_driver wl12xx_sdio_driver = {
+	.name		= "wl12xx_sdio",
+	.id_table	= wl12xx_devices,
+	.probe		= wl12xx_sdio_probe,
+	.remove		= __devexit_p(wl12xx_sdio_remove),
+};
+
+static int __init wl12xx_sdio_init(void)
+{
+	int err;
+
+	err = sdio_register_driver(&wl12xx_sdio_driver);
+	if (err)
+		wl12xx_error("failed to register sdio driver: %d", err);
+	return err;
+}
+
+static void __exit wl12xx_sdio_exit(void)
+{
+	sdio_unregister_driver(&wl12xx_sdio_driver);
+	wl12xx_notice("unloaded");
+}
+
+module_init(wl12xx_sdio_init);
+module_exit(wl12xx_sdio_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Kalle Valo <Kalle.Valo@nokia.com>");
+MODULE_AUTHOR("Luciano Coelho <luciano.coelho@nokia.com>");
diff --git a/include/linux/mmc/sdio_ids.h b/include/linux/mmc/sdio_ids.h
index c7211ab..403840f 100644
--- a/include/linux/mmc/sdio_ids.h
+++ b/include/linux/mmc/sdio_ids.h
@@ -28,4 +28,7 @@
 #define SDIO_DEVICE_ID_MARVELL_8688WLAN		0x9104
 #define SDIO_DEVICE_ID_MARVELL_8688BT		0x9105
 
+#define SDIO_VENDOR_ID_TI			0x104c
+#define SDIO_DEVICE_ID_TI_WL1251		0x9066
+
 #endif
-- 
1.6.2.2


-- 
Bob Copeland %% www.bobcopeland.com

