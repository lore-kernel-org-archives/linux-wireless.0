Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f50.google.com ([74.125.83.50]:32830 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212Ab3FZH4I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Jun 2013 03:56:08 -0400
Received: by mail-ee0-f50.google.com with SMTP id d49so7320599eek.9
        for <linux-wireless@vger.kernel.org>; Wed, 26 Jun 2013 00:56:07 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] b43: replace B43_BCMA_EXTRA with modparam allhwsupport
Date: Wed, 26 Jun 2013 09:55:54 +0200
Message-Id: <1372233354-2530-1-git-send-email-zajec5@gmail.com> (sfid-20130626_095612_358680_DCC62DC7)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This allows enabling support for extra hardware with just a module
param, without kernel/module recompilation.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/Kconfig |    6 ------
 drivers/net/wireless/b43/main.c  |   12 ++++++++++--
 2 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/b43/Kconfig b/drivers/net/wireless/b43/Kconfig
index 3f21e0b..51ff0b1 100644
--- a/drivers/net/wireless/b43/Kconfig
+++ b/drivers/net/wireless/b43/Kconfig
@@ -31,12 +31,6 @@ config B43_BCMA
 	depends on B43 && (BCMA = y || BCMA = B43)
 	default y
 
-config B43_BCMA_EXTRA
-	bool "Hardware support that overlaps with the brcmsmac driver"
-	depends on B43_BCMA
-	default n if BRCMSMAC
-	default y
-
 config B43_SSB
 	bool
 	depends on B43 && (SSB = y || SSB = B43)
diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index a95b77a..0e933bb 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -113,13 +113,15 @@ static int b43_modparam_pio = 0;
 module_param_named(pio, b43_modparam_pio, int, 0644);
 MODULE_PARM_DESC(pio, "Use PIO accesses by default: 0=DMA, 1=PIO");
 
+static int modparam_allhwsupport = !IS_ENABLED(CONFIG_BRCMSMAC);
+module_param_named(allhwsupport, modparam_allhwsupport, int, 0444);
+MODULE_PARM_DESC(allhwsupport, "Enable support for all hardware (even it if overlaps with the brcmsmac driver)");
+
 #ifdef CONFIG_B43_BCMA
 static const struct bcma_device_id b43_bcma_tbl[] = {
 	BCMA_CORE(BCMA_MANUF_BCM, BCMA_CORE_80211, 0x11, BCMA_ANY_CLASS),
-#ifdef CONFIG_B43_BCMA_EXTRA
 	BCMA_CORE(BCMA_MANUF_BCM, BCMA_CORE_80211, 0x17, BCMA_ANY_CLASS),
 	BCMA_CORE(BCMA_MANUF_BCM, BCMA_CORE_80211, 0x18, BCMA_ANY_CLASS),
-#endif
 	BCMA_CORE(BCMA_MANUF_BCM, BCMA_CORE_80211, 0x1D, BCMA_ANY_CLASS),
 	BCMA_CORETABLE_END
 };
@@ -5396,6 +5398,12 @@ static int b43_bcma_probe(struct bcma_device *core)
 	struct b43_wl *wl;
 	int err;
 
+	if (!modparam_allhwsupport &&
+	    (core->id.rev == 0x17 || core->id.rev == 0x18)) {
+		pr_err("Support for cores revisions 0x17 and 0x18 disabled by module param allhwsupport=0. Try b43.allhwsupport=1\n");
+		return -ENOTSUPP;
+	}
+
 	dev = b43_bus_dev_bcma_init(core);
 	if (!dev)
 		return -ENODEV;
-- 
1.7.10.4

