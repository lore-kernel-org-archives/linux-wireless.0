Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:55698 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753380Ab3BCWZz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Feb 2013 17:25:55 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/2] ssb: unregister gpios before unloading ssb
Date: Sun,  3 Feb 2013 23:25:34 +0100
Message-Id: <1359930334-25472-2-git-send-email-hauke@hauke-m.de> (sfid-20130203_232604_767715_6087E347)
In-Reply-To: <1359930334-25472-1-git-send-email-hauke@hauke-m.de>
References: <1359930334-25472-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch unregisters the gpio chip before ssb gets unloaded.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---

This should also go into 3.8.

 drivers/ssb/driver_gpio.c |   12 ++++++++++++
 drivers/ssb/main.c        |    9 +++++++++
 drivers/ssb/ssb_private.h |    5 +++++
 3 files changed, 26 insertions(+)

diff --git a/drivers/ssb/driver_gpio.c b/drivers/ssb/driver_gpio.c
index accabe3..dc109de 100644
--- a/drivers/ssb/driver_gpio.c
+++ b/drivers/ssb/driver_gpio.c
@@ -196,3 +196,15 @@ int ssb_gpio_init(struct ssb_bus *bus)
 
 	return -1;
 }
+
+int ssb_gpio_unregister(struct ssb_bus *bus)
+{
+	if (ssb_chipco_available(&bus->chipco) ||
+	    ssb_extif_available(&bus->extif)) {
+		return gpiochip_remove(&bus->gpio);
+	} else {
+		SSB_WARN_ON(1);
+	}
+
+	return -1;
+}
diff --git a/drivers/ssb/main.c b/drivers/ssb/main.c
index 9987d9f..3b645b8 100644
--- a/drivers/ssb/main.c
+++ b/drivers/ssb/main.c
@@ -443,6 +443,15 @@ static void ssb_devices_unregister(struct ssb_bus *bus)
 
 void ssb_bus_unregister(struct ssb_bus *bus)
 {
+	int err;
+
+	err = ssb_gpio_unregister(bus);
+	if (err == -EBUSY)
+		ssb_dprintk(KERN_ERR PFX "Some GPIOs are still in use.\n");
+	else if (err)
+		ssb_dprintk(KERN_ERR PFX
+			    "Can not unregister GPIO driver: %i\n", err);
+
 	ssb_buses_lock();
 	ssb_devices_unregister(bus);
 	list_del(&bus->list);
diff --git a/drivers/ssb/ssb_private.h b/drivers/ssb/ssb_private.h
index 53198dc..466171b 100644
--- a/drivers/ssb/ssb_private.h
+++ b/drivers/ssb/ssb_private.h
@@ -267,11 +267,16 @@ static inline void ssb_extif_init(struct ssb_extif *extif)
 
 #ifdef CONFIG_SSB_DRIVER_GPIO
 extern int ssb_gpio_init(struct ssb_bus *bus);
+extern int ssb_gpio_unregister(struct ssb_bus *bus);
 #else /* CONFIG_SSB_DRIVER_GPIO */
 static inline int ssb_gpio_init(struct ssb_bus *bus)
 {
 	return -ENOTSUPP;
 }
+static inline int ssb_gpio_unregister(struct ssb_bus *bus)
+{
+	return 0;
+}
 #endif /* CONFIG_SSB_DRIVER_GPIO */
 
 #endif /* LINUX_SSB_PRIVATE_H_ */
-- 
1.7.10.4

