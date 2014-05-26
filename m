Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46181 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752049AbaEZHt2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 May 2014 03:49:28 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Linus Walleij <linus.walleij@linaro.org>,
	Chris Ball <chris@printf.net>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Arend van Spriel <arend@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Chen-Yu Tsai <wens@csie.org>, linux-arm-kernel@lists.infradead.org,
	linux-mmc@vger.kernel.org, linux-wireless@vger.kernel.org,
	devicetree <devicetree@vger.kernel.org>,
	linux-sunxi@googlegroups.com,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 06/11] mmc: Add SDIO function devicetree subnode parsing
Date: Mon, 26 May 2014 09:48:01 +0200
Message-Id: <1401090486-4414-7-git-send-email-hdegoede@redhat.com> (sfid-20140526_094939_560012_FD43E871)
In-Reply-To: <1401090486-4414-1-git-send-email-hdegoede@redhat.com>
References: <1401090486-4414-1-git-send-email-hdegoede@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sascha Hauer <s.hauer@pengutronix.de>

This adds SDIO devicetree subnode parsing to the mmc core. While
SDIO devices are runtime probable they sometimes need nonprobable
additional information on embedded systems, like an additional gpio
interrupt or a clock. This patch makes it possible to supply this
information from the devicetree. SDIO drivers will find a pointer
to the devicenode in their devices of_node pointer.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 Documentation/devicetree/bindings/mmc/mmc.txt | 30 +++++++++++++++++++++++++++
 drivers/mmc/core/bus.c                        | 14 +++++++++++++
 drivers/mmc/core/core.c                       | 25 ++++++++++++++++++++++
 drivers/mmc/core/core.h                       |  3 +++
 drivers/mmc/core/sdio_bus.c                   | 16 ++++++++++++++
 5 files changed, 88 insertions(+)

diff --git a/Documentation/devicetree/bindings/mmc/mmc.txt b/Documentation/devicetree/bindings/mmc/mmc.txt
index 9dce540..5e54089 100644
--- a/Documentation/devicetree/bindings/mmc/mmc.txt
+++ b/Documentation/devicetree/bindings/mmc/mmc.txt
@@ -60,6 +60,15 @@ Optional SDIO properties:
 - keep-power-in-suspend: Preserves card power during a suspend/resume cycle
 - enable-sdio-wakeup: Enables wake up of host system on SDIO IRQ assertion
 
+Function subnodes:
+On embedded systems the cards connected to a host may need additional properties.
+These can be specified in subnodes to the host controller node. The subnodes are
+identified by the standard 'reg' property.
+Required properties:
+- reg: Must contain the SDIO function number of the function this subnode describes.
+       A value of 0 denotes the memory SD function, values from 1 to 7 denote the
+       SDIO functions.
+
 Example:
 
 sdhci@ab000000 {
@@ -74,3 +83,24 @@ sdhci@ab000000 {
 	keep-power-in-suspend;
 	enable-sdio-wakeup;
 }
+
+Example with SDIO subnode:
+
+sdhci@ab000000 {
+	compatible = "sdhci";
+	reg = <0xab000000 0x200>;
+	interrupts = <23>;
+	bus-width = <4>;
+	cd-gpios = <&gpio 69 0>;
+	cd-inverted;
+	wp-gpios = <&gpio 70 0>;
+	max-frequency = <50000000>;
+	keep-power-in-suspend;
+	enable-sdio-wakeup;
+
+	func@2 {
+		reg = <2>;
+		reset-gpios = <&gpio 69 0>;
+		clock-frequency = <26000000>;
+	};
+}
diff --git a/drivers/mmc/core/bus.c b/drivers/mmc/core/bus.c
index 8246448..58d12b7 100644
--- a/drivers/mmc/core/bus.c
+++ b/drivers/mmc/core/bus.c
@@ -16,6 +16,7 @@
 #include <linux/err.h>
 #include <linux/slab.h>
 #include <linux/stat.h>
+#include <linux/of.h>
 #include <linux/pm_runtime.h>
 
 #include <linux/mmc/card.h>
@@ -289,6 +290,16 @@ struct mmc_card *mmc_alloc_card(struct mmc_host *host, struct device_type *type)
 	return card;
 }
 
+static void mmc_set_of_node(struct mmc_card *card)
+{
+	struct mmc_host *host = card->host;
+
+	if (!host->parent->of_node)
+		return;
+
+	card->dev.of_node = mmc_of_find_child_device(host->parent->of_node, 0);
+}
+
 /*
  * Register a new MMC card with the driver model.
  */
@@ -359,6 +370,8 @@ int mmc_add_card(struct mmc_card *card)
 #endif
 	mmc_init_context_info(card->host);
 
+	mmc_set_of_node(card);
+
 	ret = device_add(&card->dev);
 	if (ret)
 		return ret;
@@ -387,6 +400,7 @@ void mmc_remove_card(struct mmc_card *card)
 				mmc_hostname(card->host), card->rca);
 		}
 		device_del(&card->dev);
+		of_node_put(card->dev.of_node);
 	}
 
 	put_device(&card->dev);
diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index acbc3f2..6f86949 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -1201,6 +1201,31 @@ EXPORT_SYMBOL(mmc_of_parse_voltage);
 
 #endif /* CONFIG_OF */
 
+static int mmc_of_get_func_num(struct device_node *node)
+{
+	u32 reg;
+	int ret;
+
+	ret = of_property_read_u32(node, "reg", &reg);
+	if (ret < 0)
+		return ret;
+
+	return reg;
+}
+
+struct device_node *mmc_of_find_child_device(struct device_node *parent,
+		unsigned func_num)
+{
+	struct device_node *node;
+
+	for_each_child_of_node(parent, node) {
+		if (mmc_of_get_func_num(node) == func_num)
+			return node;
+	}
+
+	return NULL;
+}
+
 #ifdef CONFIG_REGULATOR
 
 /**
diff --git a/drivers/mmc/core/core.h b/drivers/mmc/core/core.h
index 443a584..65615f3 100644
--- a/drivers/mmc/core/core.h
+++ b/drivers/mmc/core/core.h
@@ -32,6 +32,9 @@ struct mmc_bus_ops {
 void mmc_attach_bus(struct mmc_host *host, const struct mmc_bus_ops *ops);
 void mmc_detach_bus(struct mmc_host *host);
 
+struct device_node *mmc_of_find_child_device(struct device_node *parent,
+		unsigned func_num);
+
 void mmc_init_erase(struct mmc_card *card);
 
 void mmc_set_chip_select(struct mmc_host *host, int mode);
diff --git a/drivers/mmc/core/sdio_bus.c b/drivers/mmc/core/sdio_bus.c
index 92d1ba8..0bff9e8 100644
--- a/drivers/mmc/core/sdio_bus.c
+++ b/drivers/mmc/core/sdio_bus.c
@@ -22,6 +22,7 @@
 #include <linux/mmc/host.h>
 #include <linux/mmc/sdio_func.h>
 
+#include "core.h"
 #include "sdio_cis.h"
 #include "sdio_bus.h"
 
@@ -314,6 +315,19 @@ static void sdio_acpi_set_handle(struct sdio_func *func)
 static inline void sdio_acpi_set_handle(struct sdio_func *func) {}
 #endif
 
+#include <linux/of.h>
+
+void sdio_set_of_node(struct sdio_func *func)
+{
+	struct mmc_host *host = func->card->host;
+
+	if (!host->parent->of_node)
+		return;
+
+	func->dev.of_node = mmc_of_find_child_device(host->parent->of_node,
+						    func->num);
+}
+
 /*
  * Register a new SDIO function with the driver model.
  */
@@ -323,6 +337,7 @@ int sdio_add_func(struct sdio_func *func)
 
 	dev_set_name(&func->dev, "%s:%d", mmc_card_id(func->card), func->num);
 
+	sdio_set_of_node(func);
 	sdio_acpi_set_handle(func);
 	ret = device_add(&func->dev);
 	if (ret == 0) {
@@ -346,6 +361,7 @@ void sdio_remove_func(struct sdio_func *func)
 
 	acpi_dev_pm_detach(&func->dev, false);
 	device_del(&func->dev);
+	of_node_put(func->dev.of_node);
 	put_device(&func->dev);
 }
 
-- 
1.9.3

