Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58384 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754452Ab0IOXae (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Sep 2010 19:30:34 -0400
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <linux-wireless@vger.kernel.org>, <linux-omap@vger.kernel.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	<linux-arm-kernel@lists.infradead.org>,
	Chikkature Rajashekar Madhusudhan <madhu.cr@ti.com>,
	Luciano Coelho <luciano.coelho@nokia.com>,
	San Mehat <san@google.com>,
	Roger Quadros <roger.quadros@nokia.com>,
	Tony Lindgren <tony@atomide.com>,
	Nicolas Pitre <nico@fluxnic.net>, Ido Yariv <ido@wizery.com>,
	Kalle Valo <kalle.valo@iki.fi>,
	Russell King <linux@arm.linux.org.uk>,
	Vitaly Wool <vitalywool@gmail.com>,
	Ohad Ben-Cohen <ohad@wizery.com>
Subject: [PATCH v6 3/7] wl12xx: add platform data passing support
Date: Thu, 16 Sep 2010 01:31:12 +0200
Message-Id: <1284593472-29964-1-git-send-email-ohad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add a simple mechanism to pass platform data to the
SDIO instances of wl12xx.

This way there is no confusion over who owns the 'embedded data',
typechecking is preserved, and no possibility for the wrong driver to
pick up the data.

Originally proposed by Russell King.

Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
---
 drivers/net/wireless/Makefile                      |    2 +
 drivers/net/wireless/wl12xx/Kconfig                |    5 +++-
 drivers/net/wireless/wl12xx/wl12xx_platform_data.c |   28 ++++++++++++++++++++
 include/linux/wl12xx.h                             |    3 ++
 4 files changed, 37 insertions(+), 1 deletions(-)
 create mode 100644 drivers/net/wireless/wl12xx/wl12xx_platform_data.c

diff --git a/drivers/net/wireless/Makefile b/drivers/net/wireless/Makefile
index 5d4ce4d..85af697 100644
--- a/drivers/net/wireless/Makefile
+++ b/drivers/net/wireless/Makefile
@@ -50,5 +50,7 @@ obj-$(CONFIG_ATH_COMMON)	+= ath/
 obj-$(CONFIG_MAC80211_HWSIM)	+= mac80211_hwsim.o
 
 obj-$(CONFIG_WL12XX)	+= wl12xx/
+# small builtin driver bit
+obj-$(CONFIG_WL12XX_PLATFORM_DATA)	+= wl12xx/wl12xx_platform_data.o
 
 obj-$(CONFIG_IWM)	+= iwmc3200wifi/
diff --git a/drivers/net/wireless/wl12xx/Kconfig b/drivers/net/wireless/wl12xx/Kconfig
index 2f98058..4a8bb25 100644
--- a/drivers/net/wireless/wl12xx/Kconfig
+++ b/drivers/net/wireless/wl12xx/Kconfig
@@ -74,4 +74,7 @@ config WL1271_SDIO
 	  If you choose to build a module, it'll be called
 	  wl1271_sdio. Say N if unsure.
 
-
+config WL12XX_PLATFORM_DATA
+	bool
+	depends on WL1271_SDIO != n
+	default y
diff --git a/drivers/net/wireless/wl12xx/wl12xx_platform_data.c b/drivers/net/wireless/wl12xx/wl12xx_platform_data.c
new file mode 100644
index 0000000..973b110
--- /dev/null
+++ b/drivers/net/wireless/wl12xx/wl12xx_platform_data.c
@@ -0,0 +1,28 @@
+#include <linux/module.h>
+#include <linux/err.h>
+#include <linux/wl12xx.h>
+
+static const struct wl12xx_platform_data *platform_data;
+
+int __init wl12xx_set_platform_data(const struct wl12xx_platform_data *data)
+{
+	if (platform_data)
+		return -EBUSY;
+	if (!data)
+		return -EINVAL;
+
+	platform_data = kmemdup(data, sizeof(*data), GFP_KERNEL);
+	if (!platform_data)
+		return -ENOMEM;
+
+	return 0;
+}
+
+const struct wl12xx_platform_data *wl12xx_get_platform_data(void)
+{
+	if (!platform_data)
+		return ERR_PTR(-ENODEV);
+
+	return platform_data;
+}
+EXPORT_SYMBOL(wl12xx_get_platform_data);
diff --git a/include/linux/wl12xx.h b/include/linux/wl12xx.h
index 015687a..bd70563 100644
--- a/include/linux/wl12xx.h
+++ b/include/linux/wl12xx.h
@@ -31,4 +31,7 @@ struct wl12xx_platform_data {
 	bool use_eeprom;
 };
 
+int wl12xx_set_platform_data(const struct wl12xx_platform_data *data);
+const struct wl12xx_platform_data *wl12xx_get_platform_data(void);
+
 #endif
-- 
1.7.0.4

