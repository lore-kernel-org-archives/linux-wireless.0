Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:55699 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753489Ab3BCWZz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Feb 2013 17:25:55 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/2] bcma: unregister gpios before unloading bcma
Date: Sun,  3 Feb 2013 23:25:33 +0100
Message-Id: <1359930334-25472-1-git-send-email-hauke@hauke-m.de> (sfid-20130203_232605_486509_4A208C49)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch unregisters the gpio chip before bcma gets unloaded.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
Reported-by: Piotr Haber <phaber@broadcom.com>
---

This should also go into 3.8.

 drivers/bcma/bcma_private.h |    5 +++++
 drivers/bcma/driver_gpio.c  |    5 +++++
 drivers/bcma/main.c         |    7 +++++++
 3 files changed, 17 insertions(+)

diff --git a/drivers/bcma/bcma_private.h b/drivers/bcma/bcma_private.h
index 6f377bd..79595a0 100644
--- a/drivers/bcma/bcma_private.h
+++ b/drivers/bcma/bcma_private.h
@@ -97,11 +97,16 @@ void bcma_core_pci_hostmode_init(struct bcma_drv_pci *pc);
 #ifdef CONFIG_BCMA_DRIVER_GPIO
 /* driver_gpio.c */
 int bcma_gpio_init(struct bcma_drv_cc *cc);
+int bcma_gpio_unregister(struct bcma_drv_cc *cc);
 #else
 static inline int bcma_gpio_init(struct bcma_drv_cc *cc)
 {
 	return -ENOTSUPP;
 }
+static inline int bcma_gpio_unregister(struct bcma_drv_cc *cc)
+{
+	return 0;
+}
 #endif /* CONFIG_BCMA_DRIVER_GPIO */
 
 #endif
diff --git a/drivers/bcma/driver_gpio.c b/drivers/bcma/driver_gpio.c
index 0b5df53..45f0996 100644
--- a/drivers/bcma/driver_gpio.c
+++ b/drivers/bcma/driver_gpio.c
@@ -107,3 +107,8 @@ int bcma_gpio_init(struct bcma_drv_cc *cc)
 
 	return gpiochip_add(chip);
 }
+
+int bcma_gpio_unregister(struct bcma_drv_cc *cc)
+{
+	return gpiochip_remove(&cc->gpio);
+}
diff --git a/drivers/bcma/main.c b/drivers/bcma/main.c
index 6eda7ef..9a6188a 100644
--- a/drivers/bcma/main.c
+++ b/drivers/bcma/main.c
@@ -276,6 +276,13 @@ int bcma_bus_register(struct bcma_bus *bus)
 void bcma_bus_unregister(struct bcma_bus *bus)
 {
 	struct bcma_device *cores[3];
+	int err;
+
+	err = bcma_gpio_unregister(&bus->drv_cc);
+	if (err == -EBUSY)
+		bcma_err(bus, "Some GPIOs are still in use.\n");
+	else if (err)
+		bcma_err(bus, "Can not unregister GPIO driver: %i\n", err);
 
 	cores[0] = bcma_find_core(bus, BCMA_CORE_MIPS_74K);
 	cores[1] = bcma_find_core(bus, BCMA_CORE_PCIE);
-- 
1.7.10.4

